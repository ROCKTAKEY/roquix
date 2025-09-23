(define-module (roquix packages texlab)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo))

(define-public texlab
  (package
    (name "texlab")
    (version "5.23.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/latex-lsp/texlab")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "11ravyp78svz04pmkj111cchdn9rp6rkfg48kjpngcwsi36q0js1"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:install-source? #f
      #:cargo-install-paths ''("crates/texlab")))
    (inputs (cargo-inputs 'texlab
                          #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/latex-lsp/texlab")
    (synopsis "LaTeX Language Server")
    (description "This package provides @code{LaTeX} Language Server.")
    (license license:gpl3)))
