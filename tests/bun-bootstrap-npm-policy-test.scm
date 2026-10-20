(use-modules (roquix build-system bun)
             (roquix packages bun-bootstrap)
             (roquix packages bun-npm-inputs)
             (srfi srfi-1)
             (srfi srfi-13)
             (srfi srfi-64))

(test-begin "bun-bootstrap-npm-policy")

(test-assert "bootstrap excludes prebuilt WebKit packages"
  (not (find (lambda (package)
               (string-prefix? "bun-webkit"
                               (bun-lock-package-name package)))
             %bun-1.0.7-bootstrap-npm-inputs)))

(test-equal "generated lock inputs still describe WebKit packages"
  '("bun-webkit"
    "bun-webkit-linux-amd64"
    "bun-webkit-linux-arm64"
    "bun-webkit-macos-amd64"
    "bun-webkit-macos-arm64")
  (filter-map (lambda (package)
                (let ((name (bun-lock-package-name package)))
                  (and (string-prefix? "bun-webkit" name)
                       name)))
              %bun-1.0.7-all-npm-inputs))

(let ((runner (test-runner-current)))
  (test-end "bun-bootstrap-npm-policy")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
