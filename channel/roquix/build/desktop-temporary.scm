(define-module (roquix build desktop-temporary)
  #:use-module (guix build utils)
  #:use-module ((guix build syscalls) #:select (mkdtemp! statfs file-system-type
                                              fcntl-flock))
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 rdelim)
  #:use-module (ice-9 regex)
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

(define (private-directory path)
  (catch 'system-error
    (lambda () (mkdir path #o700))
    (lambda args
      (unless (= EEXIST (system-error-errno args)) (apply throw args))))
  (let ((info (lstat path)))
    (unless (and (eq? 'directory (stat:type info))
                 (= (getuid) (stat:uid info))
                 (= #o700 (stat:perms info)))
      (error "temporary storage must be an owned private directory" path)))
  path)

(define (boot-id? value)
  (and (string? value)
       (string-match "^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"
                     value)))

(define (prepare-temporary-storage base)
  (unless (temporary-base? base)
    (error "temporary storage requires a parsed base" base))
  (let ((path (temporary-base-path base)))
    ;; Linux filesystem magic values identify memory-backed storage even when
    ;; it is bind-mounted beneath an otherwise disk-backed directory.
    ;; https://www.kernel.org/doc/html/latest/filesystems/tmpfs.html
    (when (memv (file-system-type (statfs path)) '(#x01021994 #x858458f6))
      (error "temporary base must not be tmpfs or ramfs" path))
    (let* ((owner (private-directory
                   (string-append path "/roquix-tmp-" (number->string (getuid)))))
           (boot (call-with-input-file "/proc/sys/kernel/random/boot_id" read-line)))
      (unless (boot-id? boot) (error "invalid kernel boot ID" boot))
      (call-with-port
          (open (string-append owner "/.lock")
                (logior O_CREAT O_RDWR O_NOFOLLOW O_CLOEXEC) #o600)
        (lambda (lock)
          (fcntl-flock lock 'write-lock)
          ;; A killed launcher can leave live payload descendants. Only a new
          ;; kernel boot proves those processes can no longer use these files.
          ;; Serialize reclamation so simultaneous launches cannot race deletes.
          (for-each
           (lambda (name)
             (unless (string=? name boot)
               (delete-file-recursively (string-append owner "/" name))))
           (scandir owner boot-id?))
          (private-directory (string-append owner "/" boot)))))))

(define (call-with-desktop-temporary-directory base procedure)
  (let* ((storage (prepare-temporary-storage base))
         (directory (mkdtemp! (string-append storage "/run-XXXXXX"))))
    (dynamic-wind
      (lambda () #t)
      (lambda () (procedure directory))
      (lambda () (delete-file-recursively directory)))))
