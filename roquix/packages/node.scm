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
    (version "22.6.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://nodejs.org/dist/v" version
                                  "/node-v" version "-linux-x64.tar.xz"))
              (sha256
               (base32
                "00spngkl27pcw4c87vanc87dg9awbdagf98v7sxhjcn3xlwybfxc"))))
    (build-system binary-build-system)
    (arguments
     `(#:install-plan '(("bin" "bin")
                        ("include" "include")
                        ("lib" "lib")
                        ("share" "share"))
       #:patchelf-plan `(("bin/node" ("gcc" "gcc-toolchain")))
       #:strip-binaries? #f
       #:phases
       (modify-phases %standard-phases
         (add-after 'install 'install-corepack
           (lambda* (#:key outputs #:allow-other-keys)
             ;; FIXME: Cannot install npm because installing npm with corepack causes segmentation fault
             (invoke (string-append (assoc-ref outputs "out") "/bin/node")
                     (string-append (assoc-ref outputs "out") "/bin/corepack")
                     "enable"
                     "--install-directory" (string-append (assoc-ref outputs "out") "/bin")))))))
    (inputs `((,gcc "lib")
              ,gcc-toolchain))
    (home-page "https://nodejs.org/")
    (synopsis "nodejs")
    (description
     "Node.js is a JavaScript runtime built on Chrome's V8 JavaScript engine.")
    (license license:expat)))
