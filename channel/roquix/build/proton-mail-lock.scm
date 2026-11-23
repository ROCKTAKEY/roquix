(define-module (roquix build proton-mail-lock)
  #:use-module (ice-9 match)
  #:use-module (json)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-11)
  #:autoload (yamlpp) (yaml-load-all-from-file)
  #:export (write-desktop-lock))

(define %desktop-build-tools
  '("@electron-forge/cli" "@electron-forge/maker-deb" "@electron/fuses"
    "@sentry/electron" "@vercel/webpack-asset-relocator-loader" "css-loader"
    "dotenv" "electron" "fork-ts-checker-webpack-plugin" "node-loader"
    "style-loader" "ts-loader" "typescript" "webpack"))

(define (desktop-dependencies importers)
  (define (versions workspace field select?)
    (filter-map (match-lambda
                  ((name . pin)
                   (let ((version (assoc-ref pin "version")))
                     (and (select? name version) (cons name version)))))
                (assoc-ref (assoc-ref importers workspace) field)))
  ;; Only the public build tools and the shared modules imported by the
  ;; desktop client are needed. Other workspaces include private test clients.
  (append
   (versions "applications/inbox-desktop" "dependencies"
             (lambda (name version) (not (string-prefix? "link:" version))))
   (versions "applications/inbox-desktop" "devDependencies"
             (lambda (name version)
               (or (string-prefix? "@electron-forge/plugin-" name)
                   (member name %desktop-build-tools))))
   (versions "packages/shared" "dependencies"
             (lambda (name version)
               (member name '("minimist" "ua-parser-js" "@protontech/crypto"))))
   (versions "packages/colors" "devDependencies"
             (lambda (name version) (string=? name "ts-node")))))

(define (without-peers version)
  (substring version 0 (or (string-index version #\() (string-length version))))

(define (dependency-closure lock roots)
  (define snapshots (assoc-ref lock "snapshots"))
  (define packages (assoc-ref lock "packages"))
  (define selected (make-hash-table))
  (define archives (make-hash-table))

  (define (visit entry)
    (match-let* (((name . version) entry)
                 ;; Aliases already carry the target package name in VERSION.
                 (snapshot (or (assoc (string-append name "@" version) snapshots)
                               (assoc version snapshots)
                               (error "Missing pnpm snapshot" entry)))
                 ((key . fields) snapshot))
      (unless (hash-ref selected key)
        (hash-set! selected key fields)
        (let ((archive (without-peers key)))
          (hash-set! archives archive
                     (or (assoc-ref packages archive)
                         (error "Missing pnpm package" archive))))
        (for-each visit (append (or (assoc-ref fields "dependencies") '())
                                (or (assoc-ref fields "optionalDependencies") '()))))))
  (for-each visit roots)
  (values (hash-map->list cons archives) (hash-map->list cons selected)))

(define (write-desktop-lock file)
  ;; pnpm also stores its own package manager in a separate YAML document.
  (define lock
    (find (lambda (doc) (assoc "applications/inbox-desktop" (assoc-ref doc "importers")))
          (yaml-load-all-from-file file)))
  (define roots (desktop-dependencies (assoc-ref lock "importers")))
  (define (specifier version)
    (let ((base (without-peers version)))
      (if (string-prefix? "@" base) (string-append "npm:" base) base)))
  (define pins
    (map (match-lambda
           ((name . version)
            (cons name `(("specifier" . ,(specifier version)) ("version" . ,version)))))
         roots))
  ;; JSON is a YAML flow format and preserves strings such as lockfileVersion.
  (define (write-object file object)
    (call-with-output-file file (lambda (port) (scm->json object port))))
  (write-object "package.json"
                `(("private" . #t)
                  ("dependencies" . ,(map (match-lambda
                                            ((name . version) (cons name (specifier version))))
                                          roots))))
  (let-values (((packages snapshots) (dependency-closure lock roots)))
    (write-object "pnpm-lock.yaml"
                  `(("lockfileVersion" . ,(assoc-ref lock "lockfileVersion"))
                    ("settings" . ,(assoc-ref lock "settings"))
                    ("importers" . (("." . (("dependencies" . ,pins)))))
                    ("packages" . ,packages)
                    ("snapshots" . ,snapshots))))
  (write-object "pnpm-workspace.yaml"
                '(("autoInstallPeers" . #f) ("blockExoticSubdeps" . #f)
                  ("nodeLinker" . "hoisted") ("minimumReleaseAge" . 0))))
