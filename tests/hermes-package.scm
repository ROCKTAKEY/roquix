(use-modules (guix packages)
             (guix build-system pyproject)
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
(test-assert "Python dependencies use source archives, Git, or existing Guix packages"
  (every
    (lambda (package)
      (let ((uri (origin-uri (package-source package))))
        (or (not (string? uri))
            (and (not (string-contains uri ".whl"))
                 (not (string-contains uri "install_only"))))))
    (@ (roquix packages hermes python) hermes-python-dependencies)))
(test-assert "new Python dependencies use the standard pyproject build system"
  (every (lambda (package)
           (or (not (string-prefix? "hermes-python-" (package-name package)))
               (eq? pyproject-build-system (package-build-system package))))
         (@ (roquix packages hermes python) hermes-python-dependencies)))
(test-assert "WASM builders reuse the shared Emscripten package"
  (every (lambda (p)
           (any (lambda (input)
                  (eq? (cadr input) (@ (roquix packages wasm) emscripten-4)))
                (package-native-inputs p)))
         (list (@ (roquix packages hermes wasm) hermes-yoga-wasm)
               (@ (roquix packages hermes wasm) hermes-es-module-lexer-wasm))))
(test-assert "Hermes modules do not import T3 Code modules"
  (let visit ((module (resolve-module '(roquix packages hermes)))
              (seen '()))
    (let ((name (module-name module)))
      (or (member name seen)
          (and (not (and (>= (length name) 3)
                         (equal? (take name 2) '(roquix packages))
                         (string-prefix? "t3code" (symbol->string (caddr name)))))
               (every (lambda (dependency)
                        (visit (resolve-module (module-name dependency))
                               (cons name seen)))
                      (filter (lambda (dependency)
                                (eq? 'roquix (car (module-name dependency))))
                              (module-uses module))))))))
(define failures
  (test-runner-fail-count (test-runner-current)))
(test-end "hermes-package")
(exit (zero? failures))
