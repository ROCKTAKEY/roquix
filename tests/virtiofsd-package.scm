(use-modules (guix build-system cargo)
             (guix git-download)
             (guix packages)
             ((roquix packages virtiofsd) #:prefix roquix:)
             (srfi srfi-13)
             (srfi srfi-64))

(test-begin "virtiofsd-package")

(test-equal "virtiofsd uses the upstream release"
  "v1.13.3"
  (git-reference-commit
   (origin-uri (package-source roquix:virtiofsd))))

(test-eq "virtiofsd builds with Cargo"
  cargo-build-system
  (package-build-system roquix:virtiofsd))

(test-assert "virtiofsd includes its required system libraries"
  (let ((names (map car (package-inputs roquix:virtiofsd))))
    (and (member "libcap-ng" names)
         (member "libseccomp" names))))

(test-assert "virtiofsd includes its locked Rust dependencies"
  (pair? (filter (lambda (input)
                   (string-prefix? "rust-" (car input)))
                 (package-inputs roquix:virtiofsd))))

(let ((runner (test-runner-current)))
  (test-end "virtiofsd-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
