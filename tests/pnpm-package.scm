(use-modules (guix build-system cargo)
             (guix packages)
             (roquix packages pnpm)
             (srfi srfi-64))

(test-begin "pnpm-package")

(test-eq "pnpm is built from Rust source"
  cargo-build-system
  (package-build-system pnpm))

(let ((runner (test-runner-current)))
  (test-end "pnpm-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
