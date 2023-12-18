(define-module (roquix packages typst)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (nonguix build-system binary))

(define-public typst
  (package
   (name "typst")
   (version "0.10.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append "https://github.com/typst/typst/releases/download/v" version "/typst-x86_64-unknown-linux-musl.tar.xz"))
     (sha256
      (base32 "1nasm5xm4ybg6sih7g88gwk67g5yga8chfr8c83i76kg31kg5qfk"))))
   (build-system binary-build-system)
   (arguments
    '(#:install-plan '(("typst" "bin/"))))
   (home-page "https://typst.app")
   (synopsis
    "A new markup-based typesetting system that is powerful and easy to learn.")
   (description
    "This package provides a new markup-based typesetting system that is powerful and
easy to learn.")
   (license license:asl2.0)))
