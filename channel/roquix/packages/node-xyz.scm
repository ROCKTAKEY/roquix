(define-module (roquix packages node-xyz)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust)
  #:export (native-library))

(define* (native-library name
                         version
                         repository
                         commit
                         hash
                         directory
                         member
                         library
                         filename
                         #:key (tests? #f)
                         (rust rust-1.95)
                         (features '())
                         (license-value license:expat))
  (package
    (name name)
    (version version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://codeload.github.com/" repository
                           "/tar.gz/" commit))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 hash))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust
      #:install-source? #f
      #:features `',features
      ;; Node-API addons need a Node host. Runtime APIs are exercised by
      ;; the application's check-installed phase; build tools run during its build.
      #:tests? tests?
      #:cargo-build-flags `'("--release" "--package"
                             ,member)
      #:cargo-test-flags `'("--package" ,member "--lib")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'enter-library
            (lambda _
              (chdir #$directory)))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((destination (string-append (assoc-ref outputs "out")
                                                "/lib")))
                (mkdir-p destination)
                (copy-file #$(string-append "target/release/" library)
                           (string-append destination "/"
                                          #$filename))))))))
    (inputs (cargo-inputs (string->symbol name)
                          #:module '(roquix packages rust-crates)))
    (home-page (string-append "https://github.com/" repository))
    (synopsis "Native library built with Cargo")
    (description
     "This package builds a native library from Rust source for use by host applications.")
    (license license-value)))

(define-public tailwindcss-oxide
  (native-library "tailwindcss-oxide"
                  "4.3.3"
                  "tailwindlabs/tailwindcss"
                  "v4.3.3"
                  "0vmyl9fxx2ykvva58s19gkjm9w8l1hgdvcnayvl8fljhjcjcw0p7"
                  "."
                  "tailwind-oxide"
                  "libtailwind_oxide.so"
                  "tailwindcss-oxide.linux-x64-gnu.node"))

(define-public lightningcss-native
  (native-library "lightningcss-native"
                  "1.33.0"
                  "parcel-bundler/lightningcss"
                  "1d680fa14e9a089c92dc0929f869d6757ae91c30"
                  "1d0vwp2135ibqgyz803czrjslg6hvd2sn2440n2pybxaym17ydxb"
                  "."
                  "lightningcss_node"
                  "liblightningcss_node.so"
                  "lightningcss.linux-x64-gnu.node"
                  #:license-value license:mpl2.0))

