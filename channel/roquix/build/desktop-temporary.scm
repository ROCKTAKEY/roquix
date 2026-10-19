(define-module (roquix build desktop-temporary)
  #:use-module (guix build utils)
  #:use-module ((guix build syscalls) #:select (mkdtemp! statfs file-system-type))
  #:use-module (srfi srfi-9)
  #:export (parse-temporary-base call-with-desktop-temporary-directory))

(define-record-type <temporary-base>
  (%temporary-base path) temporary-base?
  (path temporary-base-path))

(define (parse-temporary-base path)
  (unless (and (string? path) (string-prefix? "/" path)
               (not (string-contains path "=")))
    (error "temporary base must be an absolute path without '='" path))
  (%temporary-base path))

(define (call-with-desktop-temporary-directory base procedure)
  (unless (temporary-base? base)
    (error "temporary storage requires a parsed base" base))
  (let ((path (temporary-base-path base)))
    ;; Linux filesystem magic values identify memory-backed storage even when
    ;; it is bind-mounted beneath an otherwise disk-backed directory.
    ;; https://www.kernel.org/doc/html/latest/filesystems/tmpfs.html
    (when (memv (file-system-type (statfs path)) '(#x01021994 #x858458f6))
      (error "temporary base must not be tmpfs or ramfs" path))
    (let ((directory (mkdtemp! (string-append path "/roquix-tmp-XXXXXX"))))
      (dynamic-wind
        (lambda () #t)
        (lambda () (procedure directory))
        (lambda () (delete-file-recursively directory))))))
