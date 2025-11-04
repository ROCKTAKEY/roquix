(define-module (roquix packages texlab)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (rustup build toolchain)
  #:use-module (gnu packages llvm))

(define-public texlab
  (package
    (name "texlab")
    (version "5.24.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/latex-lsp/texlab")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "163c3rdjbq2nbyzc4blj7rcgj6af14jw2fyn7fpzhmzgmgdbf41z"))))
    ;; TODO: Use official rust-1.89.0 when the official guix channel is updated
    (build-system (make-cargo-build-system "1.89.0"))
    (arguments
     (list
      #:install-source? #f
      #:cargo-install-paths ''("crates/texlab")))
    (inputs (cons* clang-toolchain
                   (cargo-inputs 'texlab
                                 #:module '(roquix packages rust-crates))))
    (home-page "https://github.com/latex-lsp/texlab")
    (synopsis "LaTeX Language Server")
    (description "This package provides @code{LaTeX} Language Server.")
    (license license:gpl3)))
