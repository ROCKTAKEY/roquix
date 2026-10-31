;;; T3 Code build-phase helpers used by t3code.scm.
;;; Betteroffice consumers need TypeScript sources paired with the generated WASM
;;; bindings. Installed Node consumers need their own resolved dependency closures,
;;; since pnpm can assign different peer versions to different consumers. These
;;; helpers prepare both trees; select-runtime-roots.mjs supplies the upstream
;;; policy for choosing the runtime dependency roots.

(define-module (roquix packages t3code staging)
  #:use-module (guix build utils)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (json)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (stage-office-sources stage-runtime-dependencies))

(define (manifest directory)
  (call-with-input-file (string-append directory "/package.json")
    ;; Node resolves conditional exports in their declaration order.
    (lambda (port) (json->scm port #:ordered #t))))

(define (relative-path directory target)
  (let loop
    ((from (string-split (canonicalize-path directory) #\/))
     (to (string-split (canonicalize-path target) #\/)))
    (if (and (pair? from)
             (pair? to)
             (string=? (car from)
                       (car to)))
        (loop (cdr from)
              (cdr to))
        (string-join (append (make-list (length from) "..") to) "/"))))

(define (rewrite-source file transform)
  (let* ((text (call-with-input-file file
                 get-string-all))
         (updated (transform text)))
    (unless (string=? text updated)
      ;; Store inputs can supply read-only files and directories.  Updating the
      ;; existing inode needs no permission to replace its directory entry.
      (chmod file #o644)
      (call-with-output-file file
        (lambda (port)
          (display updated port))))))

(define (stage-office-sources target source)
  (let ((metadata (manifest target))
        (rebuilt (manifest source)))
    (define (source-entry value)
      (cond
        ((string? value)
         (if (string-prefix? "./dist/" value)
             (let* ((path (string-append "./src/"
                                         (substring value 7)))
                    (extension (string-match "(\\.d)?\\.(mjs|mts|js|ts)$" path))
                    (stem (if extension
                              (substring path 0
                                         (match:start extension)) path)))
               (or (find (lambda (entry)
                           (file-exists? (string-append source "/" entry)))
                         (list (string-append stem ".ts")
                               (string-append stem ".tsx") stem))
                   (error "No Office source entry"
                          (assoc-ref metadata "name") value))) value))
        ((vector? value)
         (list->vector (map source-entry
                            (vector->list value))))
        ((list? value)
         (map (lambda (entry)
                (cons (car entry)
                      (source-entry (cdr entry)))) value))
        (else (error "Invalid Office export entry" value))))
    (unless (every (lambda (key)
                     (and (string? (assoc-ref metadata key))
                          (equal? (assoc-ref metadata key)
                                  (assoc-ref rebuilt key))))
                   '("name" "version"))
      (error "Office source identity mismatch" target source))
    (let ((updated (map (lambda (entry)
                          (if (member (car entry)
                                      '("exports" "main" "module" "types"))
                              (cons (car entry)
                                    (source-entry (cdr entry))) entry))
                        metadata)))
      (when (file-exists? (string-append target "/dist"))
        (delete-file-recursively (string-append target "/dist")))
      (for-each (lambda (directory)
                  (copy-recursively (string-append source "/" directory)
                                    (string-append target "/" directory)))
                '("src" "shared"))
      (for-each (lambda (file)
                  (rewrite-source file
                                  (lambda (text)
                                    (regexp-substitute/global #f
                                     "(['\"])(\\.\\./)+shared/"
                                     text
                                     'pre
                                     (lambda (match )
                                       (string-append (match:substring match 1)
                                                      (relative-path (dirname
                                                                      file)
                                                                     (string-append
                                                                      target
                                                                      "/shared"))
                                                      "/"))
                                     'post))))
                (find-files (string-append target "/src") "\\.tsx?$"))
      (when (string=? (assoc-ref metadata "name") "@betteroffice/docx")
        (rewrite-source (string-append target
                         "/src/yrs/residentEngineWorkerClient.ts")
                        (lambda (text)
                          (unless (string-contains text
                                   "./residentEngineWorker.mjs")
                            (error "Unrecognized DOCX worker entry" target))
                          (regexp-substitute/global #f
                           "\\./residentEngineWorker\\.mjs"
                           text
                           'pre
                           "./residentEngineWorker.ts"
                           'post))))
      (call-with-output-file (string-append target "/package.json")
        (lambda (port)
          (scm->json updated port)
          (newline port))))))

(define (package-name? name)
  (and (string? name)
       (string-match "^(@[A-Za-z0-9_.-]+/)?[A-Za-z0-9_.-]+$" name)
       (not (member (basename name)
                    '("." "..")))))

(define-record-type <runtime-package>
  (make-runtime-package name dependencies required) runtime-package?
  (name runtime-package-name)
  (dependencies runtime-package-dependencies)
  (required runtime-package-required))

(define (read-runtime-package source)
  (let* ((metadata (manifest source))
         (name (assoc-ref metadata "name"))
         (dependencies (map car
                            (or (assoc-ref metadata "dependencies")
                                '())))
         (optional (map car
                        (or (assoc-ref metadata "optionalDependencies")
                            '())))
         (peers (map car
                     (or (assoc-ref metadata "peerDependencies")
                         '())))
         (peer-options (or (assoc-ref metadata "peerDependenciesMeta")
                           '()))
         (names (sort (delete-duplicates (append dependencies optional peers))
                      string<?)))
    (unless (and (package-name? name)
                 (every package-name? names))
      (error "Invalid runtime package names" source name names))
    (make-runtime-package name names
                          (filter (lambda (dependency)
                                    (and (not (member dependency optional))
                                         (or (member dependency dependencies)
                                             (not (eq? #t
                                                       (assoc-ref (or (assoc-ref
                                                                       peer-options
                                                                       dependency)
                                                                      '())
                                                                  "optional"))))))
                                  names))))

(define-record-type <runtime-workspace>
  (make-runtime-workspace directory dependencies) runtime-workspace?
  (directory runtime-workspace-directory)
  (dependencies runtime-workspace-dependencies))

(define (select-runtime-workspaces root selector variant)
  (unless (member variant
                  '("cli" "desktop"))
    (error "Unknown runtime variant" variant))
  (let* ((port (open-pipe* OPEN_READ "node" selector root variant))
         (text (get-string-all port))
         (status (close-pipe port)))
    (unless (zero? status)
      (error "Upstream dependency selection failed" status))
    (map (lambda (entry)
           (let ((workspace (assoc-ref entry "workspace"))
                 (names (assoc-ref entry "dependencies")))
             (unless (and (member workspace
                                  (if (string=? variant "cli")
                                      '("apps/server")
                                      '("apps/server" "apps/desktop")))
                          (vector? names)
                          (every package-name?
                                 (vector->list names)))
               (error "Invalid upstream dependency selection" entry))
             (make-runtime-workspace workspace
                                     (vector->list names))))
         (vector->list (json-string->scm text)))))

(define (find-dependency directory name)
  (let ((candidate (string-append directory "/node_modules/" name))
        (parent (dirname directory)))
    (cond
      ((file-exists? candidate)
       (canonicalize-path candidate))
      ((string=? directory parent)
       #f)
      (else (find-dependency parent name)))))

(define (link-dependency directory name target)
  (let ((link (string-append directory "/node_modules/" name)))
    (mkdir-p (dirname link))
    (symlink (relative-path (dirname link) target) link)))

(define* (stage-runtime-dependencies root destination selector
                                     #:key (variant "desktop"))
  (let ((staged (make-hash-table))
        (next-id 0))
    (define (stage-package source)
      (or (hash-ref staged source)
          (let* ((package
                   (read-runtime-package source))
                 (name (runtime-package-name package))
                 (target (string-append destination "/node_modules/.runtime/"
                                        (number->string next-id) "/" name)))
            ;; pnpm consumers can resolve different peer versions.  Preserve
            ;; each closure, registering it before following dependency cycles.
            (hash-set! staged source target)
            (set! next-id
                  (+ next-id 1))
            (copy-recursively source target
                              #:select? (lambda (file stat)
                                          (and (not (string=? (basename file)
                                                              "node_modules"))
                                               (not (and (string=? name
                                                                   "node-pty")
                                                         (string=? file
                                                                   (string-append
                                                                    source
                                                                    "/third_party/conpty")))))))
            (for-each (lambda (dependency)
                        (let ((resolved (find-dependency source dependency)))
                          (cond
                            ;; Guix uses glibc; an npm musl fallback must not shadow it.
                            ((and resolved
                                  (not (string-suffix? "-musl" dependency)))
                             (link-dependency target dependency
                                              (stage-package resolved)))
                            ((member dependency
                                     (runtime-package-required package))
                             (error "Missing runtime dependency" name
                                    dependency)))))
                      (runtime-package-dependencies package))
            target)))
    (for-each (lambda (workspace)
                (let ((directory (runtime-workspace-directory workspace)))
                  (for-each (lambda (name)
                              (let ((source (find-dependency (string-append
                                                              root "/"
                                                              directory) name)))
                                (unless source
                                  (error "Missing runtime dependency" name))
                                (link-dependency (string-append destination
                                                                "/" directory)
                                                 name
                                                 (stage-package source))))
                            (runtime-workspace-dependencies workspace))))
              (select-runtime-workspaces root selector variant))))
