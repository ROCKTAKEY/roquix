(use-modules (roquix packages docker)
             (guix packages)
             (guix build-system gnu)
             (srfi srfi-64))

(test-begin "docker-compose-package")

(test-equal "Compose is built from source" gnu-build-system
  (package-build-system docker-compose))
(test-assert "Compose has a pinned source archive"
  (origin? (package-source docker-compose)))

(let ((runner (test-runner-current)))
  (test-end "docker-compose-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
