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
   (version "19.0.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://nodejs.org/dist/v"
                                version "/node-v" version "-linux-x64.tar.xz"))
            (sha256
             (base32
              "163n1432b2m6q9jlrnr1l6chq99mwnmxny378zwz1px79gys0vx1"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("bin" "bin")
                  ("include" "include")
                  ("lib" "lib")
                  ("share" "share"))
                #:patchelf-plan
                `(("bin/node" ("gcc:lib" "gcc-toolchain")))
                #:strip-binaries? #f))
   (inputs
    `(("gcc:lib" ,gcc "lib")
      ("gcc-toolchain" ,gcc-toolchain)))
   (home-page "https://nodejs.org/")
   (synopsis "nodejs")
   (description
    "Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine.")
   (license license:expat)))
