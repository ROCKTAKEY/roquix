(use-modules (roquix build desktop-temporary)
             (guix build utils)
             ((guix build syscalls) #:select (mkdtemp!))
             (ice-9 rdelim)
             (srfi srfi-64))

(test-begin "desktop-temporary")

(test-error "temporary bases must be absolute" #t
  (parse-temporary-base "relative"))

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
          (not (file-exists? allocated)))))
    (lambda () (delete-file-recursively root))))

(let ((runner (test-runner-current)))
  (test-end "desktop-temporary")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
