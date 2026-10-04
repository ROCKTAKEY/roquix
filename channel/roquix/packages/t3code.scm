(define-module (roquix packages t3code)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages xdisorg))

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
      #:rust rust-1.95
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
    (synopsis "Native library for T3 Code")
    (description
     "This package builds a native T3 Code dependency from source.")
    (license license-value)))

;; Match npm's gitHead, rather than assuming the Git tag includes the npm release.
;; https://registry.npmjs.org/@ff-labs/fff-node/0.9.4
(define t3code-fff-native
  (native-library "t3code-fff-native"
                  "0.9.4"
                  "dmtrKovalenko/fff"
                  "7d7910b6ba78ea8406671eaac8cdb5eb9850d9d1"
                  "0zrhp8axn4bgg89wyb0d01qk2lfk1ljl3ap244mrjhf6sm2m2v7n"
                  "."
                  "fff-c"
                  "libfff_c.so"
                  "libfff_c.so"
                  #:tests? #t))

(define t3code-ffi-native
  (let ((library (native-library "t3code-ffi-native"
                  "1.3.2"
                  "zhangyuang/node-ffi-rs"
                  "9c5ba3452d8cedbb0b30c7ce4dd0138135bd06ea"
                  "0ai108349k7p4if4ss9n3i37q38dz8llcnj7ddj7hcjc210yyjmb"
                  "."
                  "ffi-rs"
                  "libffi_rs.so"
                  "ffi-rs.linux-x64-gnu.node"
                  #:features '("libffi-sys/system"))))
    (package
      (inherit library)
      ;; Use Guix's source-built libffi rather than the crate's FHS configure script.
      (inputs (cons (list "libffi" libffi)
                    (package-inputs library))))))

(define t3code-keyring-native
  (native-library "t3code-keyring-native"
                  "1.3.0"
                  "Brooooooklyn/keyring-node"
                  "e46be75c3ba8d5fde6b88a17c6153b87ffe4b946"
                  "0s52pmbg6swqc3wa8l80xmd50qzjd5hl3sybzs74nlalzaj3pvxb"
                  "."
                  "napi-keyring"
                  "libnapi_keyring.so"
                  "keyring.linux-x64-gnu.node"))

(define t3code-xa11y-native
  (let ((library (native-library "t3code-xa11y-native"
                  "0.13.0"
                  "xa11y/xa11y"
                  "6c3a5878e5e9a36942144854914985dbc7aaaf88"
                  "040sc9f0b28jybp2ads18fhjn2gk80w81zhndrh04fd8zd9yaclx"
                  "xa11y-js"
                  "xa11y-js"
                  "libxa11y_js.so"
                  "xa11y.linux-x64-gnu.node")))
    (package
      (inherit library)
      (native-inputs (list pkg-config))
      (inputs (cons (list "libxkbcommon" libxkbcommon)
                    (package-inputs library))))))

(define %rolldown-source
  (origin
    (method url-fetch)
    (uri
     "https://codeload.github.com/rolldown/rolldown/tar.gz/5b4746e442989d770c606ce08d2737e6aafbd25d")
    (file-name "t3code-vite-plus-rolldown.tar.gz")
    (sha256 (base32 "1b2qsb91k5avlbi4yifl52lgxadyjgjgd0ccfln54lks9n1s8fi0"))))

(define %vite-task-source
  (origin
    (method url-fetch)
    (uri
     "https://codeload.github.com/voidzero-dev/vite-task/tar.gz/d05b1dcdbaabaa69643ee0b89cebe3cd390957e9")
    (file-name "t3code-vite-task.tar.gz")
    (sha256 (base32 "105avw30wqjpz9xgzrm2f16rfsns3xm1yrj0izdy1r7yhjcr21yl"))))

(define t3code-vite-plus-native
  (let ((library (native-library "t3code-vite-plus-native"
                  "0.3.3"
                  "voidzero-dev/vite-plus"
                  "v0.3.3"
                  "1ijkifs9wia2mfk1v1yjdbma024mz2h9nzkk6ij2gda1i6zxalsv"
                  "."
                  "vite-plus-cli"
                  "libvite_plus_cli.so"
                  "vite-plus.linux-x64-gnu.node"
                  #:features '("rolldown"))))
    (package
      (inherit library)
      (arguments
       (substitute-keyword-arguments (package-arguments library)
         ;; Oxc's declared MSRV is 1.96, but its consumed code builds with
         ;; Guix's 1.95 compiler after the C-variadic adaptation below.
         ((#:cargo-build-flags flags)
          `(append ,flags
                   '("--ignore-rust-version")))
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-after 'unpack 'prepare-component-sources
                (lambda* (#:key inputs #:allow-other-keys)
                  ;; Vite Task's unpublished members omit version requirements,
                  ;; so cargo package cannot normalize them into registry crates.
                  ;; Keep its workspace separate to preserve inherited manifests.
                  ;; https://github.com/voidzero-dev/vite-task/blob/d05b1dcdbaabaa69643ee0b89cebe3cd390957e9/crates/fspy/Cargo.toml
                  (mkdir "rolldown")
                  (invoke "tar"
                          "xf"
                          (assoc-ref inputs "rolldown-source")
                          "--strip-components=1"
                          "-C"
                          "rolldown")
                  (mkdir "../vite-task")
                  (invoke "tar"
                          "xf"
                          (assoc-ref inputs "vite-task-source")
                          "--strip-components=1"
                          "-C"
                          "../vite-task")
                  (substitute* "Cargo.toml"
                    (("^([a-z_]+) = \\{ git = \"https://github.com/voidzero-dev/vite-task.git\", rev = \"[^\"]+\" \\}"
                      _ name)
                     (string-append name " = { path = \"../vite-task/crates/"
                                    name "\" }")))
                  (substitute* "../vite-task/Cargo.toml"
                    (("git = \"https://github.com/polachok/passfd\", rev = \"[^\"]+\"")
                     "version = \"0.2.0\"")
                    (("git = \"https://github.com/rust-vmm/seccompiler\", rev = \"[^\"]+\"")
                     "version = \"0.5.0\""))
                  ;; Rust 1.95 exposes C variadics behind a feature gate and
                  ;; names VaList's extraction method arg instead of next_arg.
                  ;; https://github.com/rust-lang/rust/blob/1.95.0/library/core/src/ffi/va_list.rs
                  (let ((preload "../vite-task/crates/fspy_preload_unix/src"))
                    (substitute* (string-append preload "/lib.rs")
                      (("^// Compile")
                       "#![feature(c_variadic)]\n\n// Compile"))
                    (substitute* (find-files preload "\\.rs$")
                      (("\\.next_arg")
                       ".arg")))
                  ;; Artifact dependencies and tracked proc-macro inputs still
                  ;; require gated features, as in upstream's nightly build.
                  (setenv "RUSTC_BOOTSTRAP" "1")
                  (setenv "WORKSPACE_DIR"
                          (string-append (getcwd) "/rolldown"))
                  (setenv "RUSTFLAGS" "--cfg tokio_unstable")))
              (add-after 'unpack-rust-crates 'exclude-component-workspaces
                (lambda _
                  ;; Cargo's registry directory accepts individual crates,
                  ;; whereas these component archives contain workspaces.
                  (delete-file-recursively
                   "guix-vendor/t3code-vite-task.tar.gz")
                  (delete-file-recursively
                   "guix-vendor/t3code-vite-plus-rolldown.tar.gz")))
              (add-after 'configure 'enable-artifact-dependencies
                (lambda _
                  (let ((port (open-file ".cargo/config" "a")))
                    (display "\n[unstable]\nbindeps = true\n" port)
                    (close-port port))))))))
      (native-inputs (list (list "cmake" cmake-minimal)
                           (list "pkg-config" pkg-config)
                           (list "rolldown-source" %rolldown-source)
                           (list "vite-task-source" %vite-task-source)))
      (inputs (append (list (list "zstd" zstd "lib")
                            (list "sqlite" sqlite))
                      (package-inputs library))))))

(define t3code-tailwind-native
  (native-library "t3code-tailwind-native"
                  "4.3.3"
                  "tailwindlabs/tailwindcss"
                  "v4.3.3"
                  "0vmyl9fxx2ykvva58s19gkjm9w8l1hgdvcnayvl8fljhjcjcw0p7"
                  "."
                  "tailwind-oxide"
                  "libtailwind_oxide.so"
                  "tailwindcss-oxide.linux-x64-gnu.node"))

(define t3code-lightningcss-native
  (native-library "t3code-lightningcss-native"
                  "1.33.0"
                  "parcel-bundler/lightningcss"
                  "1d680fa14e9a089c92dc0929f869d6757ae91c30"
                  "1d0vwp2135ibqgyz803czrjslg6hvd2sn2440n2pybxaym17ydxb"
                  "."
                  "lightningcss_node"
                  "liblightningcss_node.so"
                  "lightningcss.linux-x64-gnu.node"
                  #:license-value license:mpl2.0))

