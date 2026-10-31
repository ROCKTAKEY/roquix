(define-module (roquix packages bun-bootstrap esbuild)
  #:use-module (guix build utils)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (bind-bun-esbuild-tools))

(define-record-type <bun-esbuild-binding>
  (make-bun-esbuild-binding link input) bun-esbuild-binding?
  (link bun-esbuild-binding-link)
  (input bun-esbuild-binding-input))

(define (parse-bun-esbuild-bindings datum)
  (unless (list? datum)
    (error "Bun esbuild bindings must be a list" datum))
  (let ((bindings (map (lambda (entry)
                         (unless (and (pair? entry)
                                      (string? (car entry))
                                      (string? (cdr entry)))
                           (error "invalid Bun esbuild binding" entry))
                         (let ((link (car entry))
                               (input (cdr entry)))
                           (unless (and (not (string-null? link))
                                        (not (string-prefix? "/" link))
                                        (every (lambda (component)
                                                 (not (member component
                                                              '("" "." ".."))))
                                               (string-split link #\/))
                                        (not (string-null? input)))
                             (error "unsafe Bun esbuild binding" entry))
                           (make-bun-esbuild-binding link input))) datum)))
    (unless (= (length bindings)
               (length (delete-duplicates (map bun-esbuild-binding-link
                                               bindings) string=?)))
      (error "duplicate Bun esbuild link" datum)) bindings))

(define (bind-bun-esbuild-tools inputs datum)
  "Bind npm esbuild entry points in DATUM to source-built Guix INPUTS."
  (for-each (lambda (binding)
              (let* ((link (bun-esbuild-binding-link binding))
                     (input-label (bun-esbuild-binding-input binding))
                     (input (assoc-ref inputs input-label)))
                (unless input
                  (error "missing Bun esbuild input" input-label))
                (let ((esbuild (string-append input "/bin/esbuild")))
                  (unless (file-exists? esbuild)
                    (error "Bun esbuild input has no executable" esbuild))
                  ;; file-exists? follows symlinks, so use lstat to remove stale npm
                  ;; links whose platform package was intentionally not installed.
                  (when (false-if-exception (lstat link))
                    (delete-file link))
                  (mkdir-p (dirname link))
                  (symlink esbuild link))))
            (parse-bun-esbuild-bindings datum)) #t)
