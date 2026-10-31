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
(define failures
  (test-runner-fail-count (test-runner-current)))
(test-end "hermes-package")
(exit (zero? failures))
