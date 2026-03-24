(define-module
  (roquix packages cpp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages check))

(define-public argh
  (package
    (name "argh")
    (version "1.3.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/adishavit/argh")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0kl6rgrzda28h1xxd611bsn8y76pfrgdv49v3h37j6mx5p2a24bi"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:phases
      ;; `build' phase just run tests and an example program.
      #~(modify-phases %standard-phases
          (delete 'build)
          (replace 'check
            (assoc-ref %standard-phases 'build)))))
    (synopsis "Minimalist argument handler for C++")
    (description
     "A minimalist argument handler for C++.")
    (home-page "https://github.com/adishavit/argh")
    (license license:bsd-3)))

(define-public argumentum
  (package
   (name "argumentum")
   (version "0.3.2")
   (source (origin
            (method git-fetch)
            (uri (git-reference
                  (url "https://github.com/mmahnic/argumentum")
                  (commit (string-append "v" version))))
            (file-name (git-file-name name version))
            (sha256
             (base32
              "0fx73mj2hk4h5kviy8kis5330rkrryf8p8jd2iskyh0vs9vnanac"))))
   (build-system cmake-build-system)
   (arguments
    '(#:configure-flags '("-DARGUMENTUM_INSTALL_HEADERONLY=ON"
                          "-DARGUMENTUM_BUILD_TESTS=ON")))
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
