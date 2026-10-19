(use-modules (guix packages)
             (guix utils))

(let ((probe (primitive-load
              (string-append (dirname (current-filename))
                             "/desktop-container-package.scm"))))
  (package
    (inherit probe)
    (name "desktop-temporary-probe-container")
    (arguments
     (cons* #:desktop-temporary-directory
            (or (getenv "ROQUIX_TEST_TEMPORARY_DIRECTORY") "/var/tmp")
            (substitute-keyword-arguments (package-arguments probe)
              ((#:desktop-network? _) #f)
              ((#:desktop-audio? _) #f))))))
