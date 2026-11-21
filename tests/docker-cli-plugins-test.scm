(use-modules (roquix home services docker)
             (gnu home services)
             (gnu services)
             (guix build-system trivial)
             (guix gexp)
             (guix packages)
             (srfi srfi-1))

(define (fixture name files)
  (package
    (name name) (version "1") (source #f)
    (build-system trivial-build-system)
    (arguments
     (list #:builder
           (with-imported-modules '((guix build utils))
             #~(begin
                 (use-modules (guix build utils))
                 (for-each
                  (lambda (file)
                    (let ((path (string-append #$output "/" file)))
                      (mkdir-p (dirname path))
                      (call-with-output-file path
                        (lambda (port) (display "fixture" port)))
                      (chmod path #o555)))
                  '#$files)))))
    (home-page #f) (synopsis "Test fixture")
    (description "Docker CLI plugin service test fixture.") (license #f)))

(define first
  (fixture "plugin-one" '("lib/docker/cli-plugins/docker-one"
                          "lib/docker/cli-plugins/README")))
(define second
  (fixture "plugin-two" '("lib/docker/cli-plugins/docker-two")))
(define plugins
  (cond
   ((equal? (getenv "PLUGIN_TEST") "duplicate")
    (list first (fixture "duplicate" '("lib/docker/cli-plugins/docker-one"))))
   ((equal? (getenv "PLUGIN_TEST") "missing")
    (list (fixture "missing" '("bin/docker-missing"))))
   ((equal? (getenv "PLUGIN_TEST") "empty") '())
   (else (list first second))))
(define config (home-docker-cli-plugins-configuration (plugins plugins)))
(define extension
  (find (lambda (extension)
          (eq? home-files-service-type (service-extension-target extension)))
        (service-type-extensions home-docker-cli-plugins-service-type)))
(cadar ((service-extension-compute extension) config))
