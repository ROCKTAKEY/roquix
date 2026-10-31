(use-modules (guix packages)
             (srfi srfi-1)
             (srfi srfi-64))

(test-begin "hermes-package")
(define interface
  (false-if-exception (resolve-interface '(roquix packages hermes))))
(define (lookup name)
  (and interface
       (module-ref interface name #f)))
(define cli
  (lookup 'hermes))
(define desktop
  (lookup 'hermes-desktop))
(define light
  (lookup 'hermes-desktop-light))
(test-assert "CLI and both desktop variants are independently installable"
             (every package?
                    (list cli desktop light)))
(when (every package?
             (list cli desktop light))
  (test-assert "all surfaces use one source revision"
               (every (lambda (p)
                        (eq? (package-source cli)
                             (package-source p)))
                      (list desktop light)))
  (test-assert "installing Desktop also exposes the CLI"
               (any (lambda (input)
                      (eq? cli
                           (cadr input)))
                    (package-propagated-inputs desktop)))
  (test-assert "Light does not depend on a local agent"
               (not (any (lambda (input)
                           (eq? cli
                                (cadr input)))
                         (append (package-inputs light)
                                 (package-propagated-inputs light)))))
  (test-assert "CLI does not depend on Electron"
               (not (any (lambda (input)
                           (string=? "electron"
                                     (package-name (cadr input))))
                         (package-inputs cli)))))
(test-assert "Python is built from CPython source"
  (let* ((runtime (module-ref (resolve-module '(roquix packages hermes)) 'hermes-python))
         (uri (origin-uri (package-source runtime))))
    (and (string? uri) (string-prefix? "https://www.python.org/ftp/python/" uri))))
(test-assert "Python dependencies use source distributions or existing Guix packages"
  (every
    (lambda (package)
      (let ((uri (origin-uri (package-source package))))
        (or (not (string? uri))
            (and (not (string-contains uri ".whl"))
                 (not (string-contains uri "install_only"))))))
    (@ (roquix packages hermes-python) hermes-python-dependencies)))
(define failures
  (test-runner-fail-count (test-runner-current)))
(test-end "hermes-package")
(exit (zero? failures))
