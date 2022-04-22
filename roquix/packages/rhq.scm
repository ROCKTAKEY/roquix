(define-module
  (roquix packages rhq)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages crates-io))

(define-public rust-shellexpand-1
  (package
    (name "rust-shellexpand")
    (version "1.1.1")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "shellexpand" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
          (base32 "1dd6rcq423jcf1wipbwymfqv6z3yvqhx9wmaxsdiyhbvvknpjzic"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t #:cargo-inputs (("rust-dirs" ,rust-dirs-2))))
    (home-page "https://github.com/netvl/shellexpand")
    (synopsis "Shell-like expansions in strings")
    (description "Shell-like expansions in strings")
    (license (list license:expat license:asl2.0))))

(define-public rust-rhq-core-0.3
  (package
    (name "rust-rhq-core")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rhq-core" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
          (base32 "0ghxksysys16lcc46pn4ikcq77f39i0iy1sv1nvlmgp43lz2w9c9"))))
    (build-system cargo-build-system)
    (arguments
      `(#:skip-build?
        #t
        #:cargo-inputs
        (("rust-chrono" ,rust-chrono-0.4)
         ("rust-error-chain" ,rust-error-chain-0.11)
         ("rust-glob" ,rust-glob-0.2)
         ("rust-lazy-static" ,rust-lazy-static-0.2)
         ("rust-regex" ,rust-regex-0.2)
         ("rust-serde" ,rust-serde-1)
         ("rust-serde-derive" ,rust-serde-derive-1)
         ("rust-serde-json" ,rust-serde-json-1)
         ("rust-shellexpand" ,rust-shellexpand-1)
         ("rust-toml" ,rust-toml-0.4)
         ("rust-url" ,rust-url-1)
         ("rust-walkdir" ,rust-walkdir-1))))
    (home-page "https://github.com/ubnt-intrepid/rhq")
    (synopsis "Core library for rhq")
    (description "Core library for rhq")
    (license license:expat)))

(define-public rust-rhq-0.3
  (package
    (name "rust-rhq")
    (version "0.3.0")
    (source
      (origin
        (method url-fetch)
        (uri (crate-uri "rhq" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
          (base32 "07aqa4s9nizj2vzngxbv19bpnckcshpald4aczzkr4ccihpilhip"))))
    (build-system cargo-build-system)
    (arguments
      `(#:cargo-inputs
        (("rust-clap" ,rust-clap-2)
         ("rust-env-logger" ,rust-env-logger-0.4)
         ("rust-rhq-core" ,rust-rhq-core-0.3))))
    (propagated-inputs
     (list git))
    (home-page "https://github.com/ubnt-intrepid/rhq")
    (synopsis "A repository management tool")
    (description "This package provides a repository management tool")
    (license license:expat)))
