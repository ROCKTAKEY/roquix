(define-module
  (roquix packages neocmakelsp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages rust))


(define-public neocmakelsp
  (package
    (name "neocmakelsp")
    (version "0.8.25")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "neocmakelsp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18139jbw7x1xsfiix1mxjx714mq9bw4zkj71d4k3fz5db1ywhrag"))))
    (build-system cargo-build-system)
    (inputs (cargo-inputs 'neocmakelsp
                          #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/neocmakelsp/neocmakelsp")
    (synopsis "The Lsp for cmake")
    (description "This package provides The Lsp for cmake.")
    (license license:expat)))
