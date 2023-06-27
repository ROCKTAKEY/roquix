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
   (version "0.114.1")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/gohugoio/hugo/releases/download/v"
                                version "/hugo_" version "_Linux-64bit.tar.gz"))
            (sha256
             (base32
              "0g6da20m1klk6vinnakqi9hsypibqdd0gwi7fjs7hk0basram381"))))
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
   (version "0.114.1")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/gohugoio/hugo/releases/download/v"
                                version "/hugo_extended_" version "_Linux-64bit.tar.gz"))
            (sha256
             (base32
              "1yannl0z7h86265q1srhlpp95m199949dnwx6gcyi4cy8cw76bl6"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("hugo" "bin/"))
                #:patchelf-plan
                `(("hugo" ("gcc")))
                #:strip-binaries? #f))
   (inputs
    `((,gcc "lib")))
   (home-page "https://github.com/gohugoio/hugo")
   (synopsis "Hugo")
   (description
    "This package provides a Fast and Flexible Static Site Generator built with love
by @url{https://github.com/bep,bep}, @url{http://spf13.com/,spf13} and
@url{https://github.com/gohugoio/hugo/graphs/contributors,friends} in
@url{https://golang.org/,Go}.")
   (license license:asl2.0)))
