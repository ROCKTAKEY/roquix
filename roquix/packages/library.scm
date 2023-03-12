(define-module
  (roquix packages library)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages check))

(define-public argumentum
  (package
    (name "argumentum")
    (version "0.3.1")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/mmahnic/argumentum")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0vqz2g2r694vrrnfkdzriwxl6wixc3459s404bnhni73m7dgr9rh"))))
    (build-system cmake-build-system)
    (arguments
     '(#:configure-flags '("-DARGUMENTUM_BUILD_TESTS=ON")))
    (native-inputs (list googletest))
    (home-page "https://github.com/mmahnic/argumentum")
    (synopsis "C++ command line parsing library")
    (description
     "Argumentum is a C++ library for writing command-line program interfaces.
The parameters that a program supports are registered in an instance of arument_parser,
the main library class. argument_parser processes the input arguments,
checks that they are valid and converts them to C++ variables.
It also generates help and usage messages when requested.")
    (license license:mpl2.0)))
