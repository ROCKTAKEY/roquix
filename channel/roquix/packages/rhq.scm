(define-module (roquix packages rhq)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust-crates))

(define-public rhq
  (let ((commit "d85b044b2098a61dab95390a207a7cae4f05c0fc")
        (revision "0"))
    (package
      (name "rhq")
      (version (git-version "0.3.0" revision commit))
      (source
       ;; (origin
       ;; (method url-fetch)
       ;; (uri (crate-uri "rhq" version))
       ;; (file-name (string-append name "-" version ".tar.gz"))
       ;; (sha256
       ;; (base32 "07aqa4s9nizj2vzngxbv19bpnckcshpald4aczzkr4ccihpilhip")))
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/ubnt-intrepid/rhq")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0601nrcpxkmwn2a9564xiz294xyq4mdxghv6bxd90rg54ab931qv"))))
      (build-system cargo-build-system)
      (inputs (cargo-inputs 'rhq
                            #:module '(roquix packages rust-crates)))
      (home-page "https://github.com/ubnt-intrepid/rhq")
      (synopsis "Repository management tool")
      (description "This package provides a repository management tool.")
      (license license:expat))))
