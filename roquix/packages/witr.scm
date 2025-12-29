(define-module
  (roquix packages witr)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system go))

(define-public witr
  (package
   (name "witr")
   (version "0.1.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/pranshuparmar/witr")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "016yiwn0b00ynllka6h2w6gk2yjzj5nx2xf26shb0cz4crdwww0d"))))
   (build-system go-build-system)
   (arguments
    `(#:import-path "github.com/pranshuparmar/witr/cmd/witr"
      #:unpack-path "github.com/pranshuparmar/witr"
      #:build-flags (list "-ldflags" ,(string-append "-X main.version=" version))))
   (home-page "https://github.com/pranshuparmar/witr")
   (synopsis "Show why this is running.")
   (description "Show why this is running.")
   (license license:asl2.0)))
