(use-modules (roquix packages opencode)
             (guix packages)
             (guix git-download)
             (srfi srfi-64))

(test-begin "opencode-package")

(test-equal "OpenCode tracks the V2 release" "2.0.32"
            (package-version opencode))

(test-equal "source tag matches the packaged release"
            (string-append "v"
                           (package-version opencode))
            (git-reference-commit (origin-uri (package-source opencode))))

(let ((runner (test-runner-current)))
  (test-end "opencode-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
