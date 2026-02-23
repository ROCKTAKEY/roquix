(define-module
  (roquix packages loon)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages pkg-config))

(define-public loon
  (package
   (name "loon")
   (version "0.4.20")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/ecto/loon")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "1b20xdy4jyvhcq98n65pv30x1hd3ba3bzadv4ayib8g6mzqgr5bj"))))
   (build-system cargo-build-system)
   (arguments '(#:install-source? #f))
   (native-inputs (list pkg-config))
   (inputs (cons* `(,zstd "lib")
                  (cargo-inputs 'loon #:module '(roquix packages rust-crates))))
   (home-page "https://github.com/ecto/loon")
   (synopsis "A functional language with invisible types, safe ownership, and algebraic effects.")
   (description "A functional language with invisible types, safe ownership, and algebraic effects.")
   (license license:expat)))
