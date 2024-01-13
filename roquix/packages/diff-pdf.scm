(define-module
  (roquix packages diff-pdf)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages pkg-config))

(define-public diff-pdf
  (package
   (name "diff-pdf")
   (version "0.5.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/vslavik/diff-pdf")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "1bfyx88rr848nqy456y92cvmaz2ql9gmrkbxf3vc3w95rg17bpcf"))))
   (build-system gnu-build-system)
   (arguments '())
   (native-inputs
    (list
     autoconf
     automake
     pkg-config))
   (inputs
    (list
     wxwidgets
     cairo
     poppler))
   (home-page "https://github.com/vslavik/diff-pdf")
   (synopsis "A simple tool for visually comparing two PDF files")
   (description "A simple tool for visually comparing two PDF files")
   (license license:gpl2)))
