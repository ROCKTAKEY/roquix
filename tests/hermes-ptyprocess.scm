(use-modules (guix packages)
             (guix build-system pyproject)
             (srfi srfi-64))

(test-begin "hermes-ptyprocess")
(define ptyprocess
  (module-ref (resolve-module '(roquix packages hermes python))
              'hermes-python-ptyprocess))
(test-equal "Hermes owns its locked ptyprocess dependency"
  "hermes-python-ptyprocess" (package-name ptyprocess))
(test-equal "ptyprocess retains the locked release"
  "0.7.0" (package-version ptyprocess))
(test-equal "ptyprocess uses the release archive"
  (pypi-uri "ptyprocess" "0.7.0")
  (origin-uri (package-source ptyprocess)))
(define failures (test-runner-fail-count (test-runner-current)))
(test-end "hermes-ptyprocess")
(exit (zero? failures))
