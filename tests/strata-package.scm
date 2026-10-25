(use-modules (guix build-system cmake)
             (guix packages)
             (roquix packages strata)
             (srfi srfi-64))

(test-begin "strata-package")

(test-equal "Strata packages the checked upstream release"
  "0.2.5" (package-version strata-hip))

(test-eq "Strata uses the CMake build system"
  cmake-build-system (package-build-system strata-hip))

(test-assert "HIP runtime and BLAS are Guix-managed inputs"
  (let ((inputs (map car (package-inputs strata-hip))))
    (and (member "rocm-hip-runtime" inputs)
         (member "hipblas" inputs))))

(test-equal "Strata supports the Linux HIP platform"
  '("x86_64-linux") (package-supported-systems strata-hip))

(let ((runner (test-runner-current)))
  (test-end "strata-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
