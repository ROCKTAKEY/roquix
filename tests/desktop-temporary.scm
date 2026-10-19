(use-modules (roquix build desktop-temporary)
             (guix build utils)
             ((guix build syscalls) #:select (mkdtemp!))
             (ice-9 rdelim)
             (srfi srfi-64))

(test-begin "desktop-temporary")

(test-error "temporary bases must be absolute" #t
  (parse-temporary-base "relative"))

(test-error "tmpfs cannot silently defeat disk temporary storage" #t
  (call-with-desktop-temporary-directory (parse-temporary-base "/dev/shm")
    (lambda (_) #t)))

(let* ((root (mkdtemp! (string-append (getcwd) "/.desktop-temporary-test-XXXXXX")))
       (allocated #f))
  (dynamic-wind
    (lambda () #t)
    (lambda ()
      (test-assert "disk storage is private per invocation and removed on unwind"
        (let ((base (parse-temporary-base root)))
          (catch 'probe-error
            (lambda ()
              (call-with-desktop-temporary-directory base
                (lambda (first)
                  (set! allocated first)
                  (unless (and (string-prefix? root first)
                               (= #o700 (stat:perms (stat first))))
                    (error "temporary directory is not private"))
                  (call-with-output-file (string-append first "/sentinel")
                    (lambda (port) (display "private" port)))
                  (call-with-desktop-temporary-directory base
                    (lambda (second)
                      (when (or (string=? first second)
                                (file-exists? (string-append second "/sentinel")))
                        (error "temporary contents are shared"))))
                  (unless (file-exists? (string-append first "/sentinel"))
                    (error "active temporary files were reclaimed"))
                  (throw 'probe-error))))
            (lambda (_) #t))
          (not (file-exists? allocated))))
      (test-assert "only previous boots are reclaimed without following symlinks"
        (let* ((owner (string-append root "/roquix-tmp-" (number->string (getuid))))
               (boot (call-with-input-file "/proc/sys/kernel/random/boot_id" read-line))
               (current (string-append owner "/" boot))
               (old (string-append owner "/00000000-0000-0000-0000-000000000000"))
               (orphan (string-append current "/run-orphan"))
               (outside (string-append root "/unrelated")))
          (mkdir-p old)
          (mkdir-p orphan)
          (mkdir outside)
          (symlink outside (string-append old "/link"))
          (call-with-desktop-temporary-directory (parse-temporary-base root)
            (lambda (_)
              (and (not (file-exists? old))
                   (file-exists? orphan)
                   (file-exists? outside))))))
      (test-error "a symlink cannot redirect the private storage root" #t
        (let ((owner (string-append root "/roquix-tmp-" (number->string (getuid)))))
          (delete-file-recursively owner)
          (symlink (string-append root "/unrelated") owner)
          (call-with-desktop-temporary-directory (parse-temporary-base root)
            (lambda (_) #t)))))
    (lambda () (delete-file-recursively root))))

(let ((runner (test-runner-current)))
  (test-end "desktop-temporary")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
