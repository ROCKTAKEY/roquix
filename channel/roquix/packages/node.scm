(define-module
  (roquix packages node)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages commencement))

(define-public node-latest
  (package
    (name "node")
    (version "22.9.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://nodejs.org/dist/v" version
                                  "/node-v" version "-linux-x64.tar.xz"))
              (sha256
               (base32
                "0hk1c847aiv49j6s34j103m447zn5c1vvwblh8nwjhxb47pykyhv"))))
    (build-system binary-build-system)
    (arguments
     `(#:install-plan '(("bin" "bin")
                        ("include" "include")
                        ("lib" "lib")
                        ("share" "share"))
       #:patchelf-plan `(("bin/node" ("gcc" "gcc-toolchain")))
       #:strip-binaries? #f))
    (inputs `((,gcc "lib")
              ,gcc-toolchain))
    (home-page "https://nodejs.org/")
    (synopsis "nodejs")
    (description
     "Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine.")
    (license license:expat)))
