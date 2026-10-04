(use-modules (guix build-system trivial)
             (guix gexp)
             (guix modules)
             (guix packages)
             (guix profiles)
             ((guix licenses) #:prefix license:)
             (gnu packages linux)
             (gnu packages python)
             (gnu packages nss)
             (gnu packages package-management))

(define modules
  (source-module-closure '((roquix build desktop-network)
                          (roquix build container-launcher))
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

(define probe-profile
  (profile (content (packages->manifest (list python nss-certs)))))

(define container-probe
  (program-file "network-container-probe"
    (with-imported-modules modules
      #~(begin
          (use-modules (roquix build container-launcher))
          (let ((guix #$(file-append guix "/bin/guix")))
            (apply execl guix guix
                   (container-command-arguments
                    #$probe-profile "python3" #:network? #t
                    #:set-environment
                    (list (cons "SSL_CERT_FILE"
                                #$(file-append probe-profile "/etc/ssl/certs/ca-certificates.crt")))
                    #:expose (list (cons (string-append (cadr (command-line)) "/resolv.conf")
                                         "/etc/resolv.conf"))
                    #:arguments (cddr (command-line)))))))))

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
                       (symlink #$runner (string-append #$output "/bin/network-runner"))
                       (symlink #$container-probe
                                (string-append #$output "/bin/network-container-probe")))))
  (synopsis "Exercise the desktop network launch contract")
  (description "Exercise namespace separation and network bridge readiness.")
  (home-page "https://example.invalid/desktop-network")
  (license license:public-domain))
