(use-modules (roquix build-system bun)
             (guix gexp)
             ((guix licenses)
              #:prefix license:)
             (guix packages))

(define fixture-root
  (string-append (dirname (current-filename)) "/fixtures"))

(define fixture-directory
  (string-append fixture-root "/bun-build-system"))

(define fixture-node-modules-directory
  (string-append fixture-root "/bun-build-system-node-modules"))

(package
  (name "bun-build-system-test")
  (version "1")
  (source
   (local-file fixture-directory "bun-build-system-test-source"
               #:recursive? #t))
  (build-system bun-build-system)
  (arguments
   (list
    #:install-plan
    #~'(("dist/" "./"))
    #:node-modules (local-file fixture-node-modules-directory
                               "bun-build-system-test-node-modules"
                               #:recursive? #t)))
  (supported-systems '("x86_64-linux"))
  (home-page "https://example.invalid/")
  (synopsis "Test package for bun-build-system")
  (description "Exercise the default Bun build and test phases and the
explicit install plan.")
  (license license:public-domain))
