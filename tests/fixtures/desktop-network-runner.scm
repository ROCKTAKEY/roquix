(use-modules (guix build-system trivial)
             (guix gexp)
             (guix modules)
             (guix packages)
             ((guix licenses) #:prefix license:)
             (gnu packages linux))

(define modules
  (source-module-closure '((roquix build desktop-network))
                         #:select? (lambda (name) (memq (car name) '(guix roquix)))))

(define child
  (program-file "network-child"
    (with-imported-modules modules
      #~(begin
          (use-modules (roquix build desktop-network))
          (run-network-child (cadr (command-line)) (cddr (command-line)))))))

(define runner
  (program-file "network-runner"
    (with-imported-modules modules
      #~(begin
          (use-modules (roquix build desktop-network))
          (let* ((arguments (cdr (command-line)))
                 (status (run-desktop-network
                          (prepare-desktop-network (car arguments))
                          (cddr arguments)
                          #$(file-append util-linux "/bin/unshare")
                          (cadr arguments) #$child)))
            (exit (or (status:exit-val status)
                      (+ 128 (status:term-sig status)))))))))

(package
  (name "desktop-network-runner")
  (version "1")
  (source #f)
  (build-system trivial-build-system)
  (arguments
   (list #:modules '((guix build utils))
         #:builder #~(begin
                       (use-modules (guix build utils))
                       (mkdir-p (string-append #$output "/bin"))
                       (symlink #$runner (string-append #$output "/bin/network-runner")))))
  (synopsis "Exercise the desktop network launch contract")
  (description "Exercise namespace separation and network bridge readiness.")
  (home-page "https://example.invalid/desktop-network")
  (license license:public-domain))
