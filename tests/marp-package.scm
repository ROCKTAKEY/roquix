(use-modules (guix packages)
             (srfi srfi-64))

(define marp
  (false-if-exception
   (module-ref (resolve-interface '(roquix packages marp)) 'marp-cli)))

(test-begin "marp-package")
(test-assert "Marp CLI is available from the channel" (package? marp))
(when (package? marp)
  (test-assert "slide export includes a browser"
    (assoc-ref (package-inputs marp) "ungoogled-chromium")))
(let ((runner (test-runner-current)))
  (test-end "marp-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
