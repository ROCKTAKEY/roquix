(define-module
  (roquix packages hugo)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc))

(define-public go-github-com-gohugoio-hugo
  (package
   (name "go-github-com-gohugoio-hugo")
   (version "0.108.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/gohugoio/hugo/releases/download/v"
                                version "/hugo_" version "_Linux-64bit.tar.gz"))
            (sha256
             (base32
              "19axlkpalicahrr1xqaj0909aj4z4q65xy5q36kdr95mdjvp7rw1"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("hugo" "bin/"))))
   (home-page "https://github.com/gohugoio/hugo")
   (synopsis "Hugo")
   (description
    "This package provides a Fast and Flexible Static Site Generator built with love
by @url{https://github.com/bep,bep}, @url{http://spf13.com/,spf13} and
@url{https://github.com/gohugoio/hugo/graphs/contributors,friends} in
@url{https://golang.org/,Go}.")
   (license license:asl2.0)))

(define-public go-github-com-gohugoio-hugo-extended
  (package
   (name "go-github-com-gohugoio-hugo-extended")
   (version "0.108.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/gohugoio/hugo/releases/download/v"
                                version "/hugo_extended_" version "_Linux-64bit.tar.gz"))
            (sha256
             (base32
              "12iiyi070a118k3vfs932lp3nan4lryql53fgh6n07v213sq0ip4"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("hugo" "bin/"))
                #:patchelf-plan
                `(("hugo" ("gcc:lib")))
                #:strip-binaries? #f))
   (inputs
    `(("gcc:lib" ,gcc "lib")))
   (home-page "https://github.com/gohugoio/hugo")
   (synopsis "Hugo")
   (description
    "This package provides a Fast and Flexible Static Site Generator built with love
by @url{https://github.com/bep,bep}, @url{http://spf13.com/,spf13} and
@url{https://github.com/gohugoio/hugo/graphs/contributors,friends} in
@url{https://golang.org/,Go}.")
   (license license:asl2.0)))
