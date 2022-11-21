(define-module (roquix packages lsp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc))

(define-public texlab
  (package
   (name "texlab")
   (version "4.3.2")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/latex-lsp/texlab/releases/download/v"
           version
           "/texlab-x86_64-linux.tar.gz"))
     (sha256
      (base32
       "1q1wmdk8wwxjk7xyx5rffwrzm9wibnb3q8bkdkhi3yrvr7gqgzk0"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("texlab" "/bin/"))
                #:patchelf-plan
                '(("texlab" ("gcc:lib" "glibc")))))
   (inputs
    `(("gcc:lib" ,gcc "lib")
      ("glibc" ,glibc)))
   (synopsis "An implementation of the Language Server Protocol for LaTeX")
   (description
    "A cross-platform implementation of the Language Server Protocol providing rich cross-editing support for the LaTeX typesetting system.
The server may be used with any editor that implements the Language Server Protocol.")
   (home-page "https://github.com/latex-lsp/texlab")
   (license license:gpl3)))
