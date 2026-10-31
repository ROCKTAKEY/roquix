(define-module (roquix packages hermes-node)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages web)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages cmake)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (roquix packages native-libraries))

(define-public hermes-esbuild
  (package
    (inherit esbuild)
    (version "0.28.1")
    (source
      (origin
        (method url-fetch)
        (uri "https://codeload.github.com/evanw/esbuild/tar.gz/bb9db84c02433fbe37b3509f53f9f3e3cc48725e")
        (file-name "esbuild-0.28.1.tar.gz")
        (sha256 (base32 "08b9phrcx60qqab9yvrw81j4qlsvs1zc15w0a5q724809z9q6gdb"))
        (modules '((guix build utils)))
        (snippet '(delete-file-recursively "npm"))))))

(define-public hermes-tailwind-native
  tailwindcss-oxide)

(define-public hermes-vite-lightningcss-native
  lightningcss-native)

(define-public hermes-lightningcss-native
  (native-library
    "hermes-lightningcss" "1.32.0" "parcel-bundler/lightningcss"
    "7f8a861bdee476fe90c89a8badeb3fd33a99c51a"
    "1611hkr07zg56ck2gabi65n3m5ifvcikmbq5v46czadigf51yidr"
    "." "lightningcss_node" "liblightningcss_node.so"
    "lightningcss.linux-x64-gnu.node" #:license-value license:mpl2.0))

(define-public hermes-rolldown-native
  (let ((base
         (native-library
           "hermes-rolldown" "1.2.13" "rolldown/rolldown" "v1.2.13"
           "016g64x7yrky5vjaw0hqvbvs6mw60ncydda984knih1zvk8kcbgj"
           "." "rolldown_binding" "librolldown_binding.so"
           "rolldown-binding.linux-x64-gnu.node" #:rust rust-1.96)))
    (package
      (inherit base)
      (native-inputs (list cmake-minimal))
      (arguments
        (substitute-keyword-arguments
          (package-arguments base)
          ((#:cargo-build-flags flags) ''("--release" "--package" "rolldown_binding" "--ignore-rust-version"))
          ((#:phases phases)
           #~(modify-phases #$phases
               (add-after 'unpack 'configure-source-build
                 (lambda _
                   (setenv "RUSTC_BOOTSTRAP" "1")
                   (setenv "RUSTFLAGS" "--cfg tokio_unstable")
                   (setenv "WORKSPACE_DIR" (getcwd))))
               (add-after 'unpack-rust-crates 'enable-existing-compiler-api
                 (lambda _
                   ;; Rust 1.96 provides bit_width behind its feature gate.
                   (substitute* "guix-vendor/rust-oxc-ecmascript-0.153.0.tar.gz/src/lib.rs"
                     (("^//! Methods defined")
                      "#![feature(uint_bit_width)]\n//! Methods defined")))))))))))

(define-public hermes-hash-sources
  (list
    (list "xxhashjs" (origin (method url-fetch)
      (uri "https://registry.npmjs.org/xxhashjs/-/xxhashjs-0.2.2.tgz")
      (sha256 (base32 "1hi8ws6qxm9bsk7zs9ny64spww6rwiqmx15mc0rid93914648pld"))))
    (list "cuint" (origin (method url-fetch)
      (uri "https://registry.npmjs.org/cuint/-/cuint-0.2.2.tgz")
      (sha256 (base32 "0bm84a5nrpkvkp54gab12vpq8zgbiibr861ff598ldwrykrvg40v"))))
    (list "js-md4" (origin (method url-fetch)
      (uri "https://registry.npmjs.org/js-md4/-/js-md4-0.3.2.tgz")
      (sha256 (base32 "0m6v25vjj8n4046pbxm5s1gl15hdyj3xahna3f3kspni6gszagdn"))))
  ))
