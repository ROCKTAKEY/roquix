(define-module
  (roquix packages library)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages check))

(define-public argumentum
  (let ((commit "b7f1753ce8e4a96a44ca09d4ff34163759fc33f9")
        (revision "94"))
    (package
      (name "argumentum")
      (version (git-version "0.3.1" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/mmahnic/argumentum")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "155vgsv87l1ccwg2y8165bdfi8x1pmfbfmwf4qzcchg7k1n6giib"))))
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
      (license license:mpl2.0))))
