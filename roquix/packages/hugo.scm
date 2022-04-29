(define-module
  (roquix packages hugo)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary))

(define-public go-github-com-gohugoio-hugo
  (package
   (name "go-github-com-gohugoio-hugo")
   (version "0.98.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/gohugoio/hugo/releases/download/v"
                                version "/hugo_" version "_Linux-64bit.tar.gz"))
            (sha256
             (base32
              "0i9cr4xcik5832nmaa8f0j0v4wfg6h7vvyb5dv0a4rxq1sh0fs2j"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("hugo" "/bin/"))))
   (home-page "https://github.com/gohugoio/hugo")
   (synopsis "Hugo")
   (description
    "This package provides a Fast and Flexible Static Site Generator built with love
by @url{https://github.com/bep,bep}, @url{http://spf13.com/,spf13} and
@url{https://github.com/gohugoio/hugo/graphs/contributors,friends} in
@url{https://golang.org/,Go}.")
   (license license:asl2.0)))
