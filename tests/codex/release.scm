(use-modules (guix git-download)
             (guix packages)
             (roquix packages codex)
             (srfi srfi-64))

(test-begin "codex-release")

(test-equal "package version identifies the requested release"
            (string-append (cadr (command-line)) "-roquix")
            (package-version codex))

(test-equal "source tag identifies the requested release"
            (string-append "rust-v"
                           (cadr (command-line)))
            (git-reference-commit (origin-uri (package-source codex))))

(define failures
  (test-runner-fail-count (test-runner-current)))
(test-end "codex-release")
(exit (if (zero? failures) 0 1))
