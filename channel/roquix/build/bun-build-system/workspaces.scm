(define-module (roquix build bun-build-system workspaces)
  #:use-module (roquix build bun-build-system jsonc)
  #:use-module ((guix build union)
                #:select (relative-file-name))
  #:use-module (guix build utils)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (parse-bun-workspaces read-bun-workspaces bun-workspace?
                                 bun-workspace-name bun-workspace-directory
                                 link-bun-workspaces))

(define-record-type <bun-workspace>
  (make-bun-workspace name directory) bun-workspace?
  (name bun-workspace-name)
  (directory bun-workspace-directory))

(define (workspace-directory? directory)
  (and (string? directory)
       (not (string-null? directory))
       (not (string-prefix? "/" directory))
       (every (lambda (component)
                (not (member component
                             '("" "." ".."))))
              (string-split directory #\/))))

(define (npm-package-name? name)
  (and (string? name)
       (string-match "^(@[^/@]+/[^/@]+|[^/@]+)$" name)))

(define (parse-workspace entry)
  (unless (and (pair? entry)
               (string? (car entry))
               (list? (cdr entry)))
    (error "invalid Bun workspace entry" entry))
  (let ((directory (car entry))
        (name (assoc-ref (cdr entry) "name")))
    (unless (workspace-directory? directory)
      (error "invalid Bun workspace directory" directory))
    (unless (npm-package-name? name)
      (error "invalid Bun workspace package name" name))
    (make-bun-workspace name directory)))

(define (parse-bun-workspaces lock)
  "Parse workspace names and directories from a Bun text lockfile value."
  (unless (list? lock)
    (error "Bun lockfile must be an object" lock))
  (let ((entries (or (assoc-ref lock "workspaces")
                     '())))
    (unless (list? entries)
      (error "Bun lockfile workspaces must be an object" entries))
    (let* ((workspaces (map parse-workspace
                            (remove (lambda (entry)
                                      (and (pair? entry)
                                           (member (car entry)
                                                   '("" ".")))) entries)))
           (names (map bun-workspace-name workspaces)))
      (unless (= (length names)
                 (length (delete-duplicates names string=?)))
        (error "duplicate Bun workspace package name" names)) workspaces)))

(define (read-bun-workspaces port)
  "Parse validated workspaces from Bun's JSONC text lock format."
  (parse-bun-workspaces (jsonc->scm port)))

(define (remove-existing-link path)
  (let ((status (false-if-exception (lstat path))))
    (when status
      (if (eq? 'directory
               (stat:type status))
          (delete-file-recursively path)
          (delete-file path)))))

(define (link-bun-workspace workspace)
  (let* ((directory (bun-workspace-directory workspace))
         (name (bun-workspace-name workspace))
         (link (string-append "node_modules/" name))
         (parent (dirname link)))
    (unless (file-is-directory? directory)
      (error "Bun workspace directory does not exist" directory))
    (mkdir-p parent)
    (remove-existing-link link)
    (symlink (relative-file-name (canonicalize-path parent)
                                 (canonicalize-path directory)) link)))

(define (link-bun-workspaces . _)
  "Link source workspaces into root node_modules according to bun.lock."
  (if (file-exists? "bun.lock")
      (for-each link-bun-workspace
                (call-with-input-file "bun.lock"
                  read-bun-workspaces))
      (format #t "no bun.lock workspace metadata found~%")) #t)
