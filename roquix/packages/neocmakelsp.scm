(define-module
  (roquix packages neocmakelsp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages crates-compression)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-windows)
  #:use-module (gnu packages crates-web)
  #:use-module (gnu packages crates-apple)
  #:use-module (gnu packages crates-crypto))

(define-public rust-gimli-0.28
  (package
    (inherit rust-gimli-0.31)
    (name "rust-gimli")
    (version "0.28.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gimli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lv23wc8rxvmjia3mcxc6hj9vkqnv1bqq0h8nzjcgf71mrxx6wa2"))))
    (arguments
     `(#:cargo-inputs
       (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
        ("rust-fallible-iterator" ,rust-fallible-iterator-0.3)
        ("rust-indexmap" ,rust-indexmap-2)
        ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
        ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
        ("rust-stable-deref-trait" ,rust-stable-deref-trait-1))
       #:cargo-development-inputs
       (("rust-test-assembler" ,rust-test-assembler-0.1))))))

(define-public rust-tree-sitter-cmake-0.5
  (package
    (name "rust-tree-sitter-cmake")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tree-sitter-cmake" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09rlc6nr179vkybcx77giqqvpphs4jbmnqjncpqk3hnmj2xvpfmh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-tree-sitter" ,rust-tree-sitter-0.22))))
    (home-page "https://github.com/uyha/tree-sitter-cmake")
    (synopsis "cmake grammar for the tree-sitter parsing library")
    (description
     "This package provides cmake grammar for the tree-sitter parsing library.")
    (license license:expat)))

(define-public rust-wasmtime-c-api-macros-19
  (package
    (name "rust-wasmtime-c-api-macros")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-c-api-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1y434cdnmjyqs1k58zq1v8j5vnh3q76f3n000m5s8iz2h9pdjdmb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Support macros for `wasmtime-c-api`")
    (description "This package provides Support macros for `wasmtime-c-api`.")
    (license (list license:asl2.0))))

(define-public rust-wast-35
  (package
    (name "rust-wast")
    (version "35.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wast" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0s2d43g326dw21bygpalzjnr1fi83lx4afimg1h5hilrnkql1w9f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-leb128" ,rust-leb128-0.2))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wast")
    (synopsis
     "Customizable Rust parsers for the WebAssembly Text formats WAT and WAST")
    (description
     "This package provides Customizable Rust parsers for the @code{WebAssembly} Text formats WAT and WAST.")
    (license (list license:asl2.0))))

(define-public rust-witx-0.9
  (package
    (name "rust-witx")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "witx" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jzgmayh2jjbv70jzfka38g4bk4g1fj9d0m70qkxpkdbbixg4rp3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-wast" ,rust-wast-35))))
    (home-page "https://github.com/WebAssembly/WASI")
    (synopsis "Parse and validate witx file format")
    (description "This package provides Parse and validate witx file format.")
    (license license:asl2.0)))

(define-public rust-wiggle-generate-19
  (package
    (name "rust-wiggle-generate")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wiggle-generate" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1m9cjrgbaiksz9388j9qxpg15s5ggydsdaz1w7zl9zrc8mzqix9d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-shellexpand" ,rust-shellexpand-2)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-witx" ,rust-witx-0.9))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Library crate for wiggle code generator")
    (description
     "This package provides Library crate for wiggle code generator.")
    (license (list license:asl2.0))))

(define-public rust-wiggle-macro-19
  (package
    (name "rust-wiggle-macro")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wiggle-macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ryvpxrdyzm2p40njnqjysi01vj3ba4jy11smamrhx2h6vg15nxc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-wiggle-generate" ,rust-wiggle-generate-19))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Wiggle code generator")
    (description "This package provides Wiggle code generator.")
    (license (list license:asl2.0))))

(define-public rust-wiggle-19
  (package
    (name "rust-wiggle")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wiggle" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0azprih9qq5rfwx86w9w2p2800h4m76a3nmc9h8jzl5czgjkz7c9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-wasmtime" ,rust-wasmtime-19)
                       ("rust-wiggle-macro" ,rust-wiggle-macro-19)
                       ("rust-witx" ,rust-witx-0.9))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Runtime components of wiggle code generator")
    (description
     "This package provides Runtime components of wiggle code generator.")
    (license (list license:asl2.0))))

(define-public rust-winch-codegen-0.17
  (package
    (name "rust-winch-codegen")
    (version "0.17.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winch-codegen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1bz65qdkr89ajqx05ycg1s8yj23s02z3s03w06fb4fwypjd8c59d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-cranelift-codegen" ,rust-cranelift-codegen-0.106)
                       ("rust-gimli" ,rust-gimli-0.28)
                       ("rust-regalloc2" ,rust-regalloc2-0.9)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12)
                       ("rust-wasmparser" ,rust-wasmparser-0.201)
                       ("rust-wasmtime-environ" ,rust-wasmtime-environ-19))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Winch code generation library")
    (description "This package provides Winch code generation library.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-winch-19
  (package
    (name "rust-wasmtime-winch")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-winch" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0qy8pnm1i68n5q9h4wcmc7jssjppr5rya721fwdrn99z1plv866n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-cranelift-codegen" ,rust-cranelift-codegen-0.106)
                       ("rust-gimli" ,rust-gimli-0.28)
                       ("rust-object" ,rust-object-0.32)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12)
                       ("rust-wasmparser" ,rust-wasmparser-0.201)
                       ("rust-wasmtime-cranelift-shared" ,rust-wasmtime-cranelift-shared-19)
                       ("rust-wasmtime-environ" ,rust-wasmtime-environ-19)
                       ("rust-winch-codegen" ,rust-winch-codegen-0.17))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Integration between Wasmtime and Winch")
    (description
     "This package provides Integration between Wasmtime and Winch.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-slab-19
  (package
    (name "rust-wasmtime-slab")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-slab" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1h44wpcbm7wrbr2mn8jirh2wn5xg0g80i3xmmh3gsxz8kkpqpi90"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Uni-typed slab with a free list for use in Wasmtime")
    (description
     "This package provides Uni-typed slab with a free list for use in Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-wmemcheck-19
  (package
    (name "rust-wasmtime-wmemcheck")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-wmemcheck" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sb7b7pjbkqd2xsgsj1p17dms6gczfbg19njcqhjncpqklpcda69"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Memcheck implementation for Wasmtime")
    (description "This package provides Memcheck implementation for Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-psm-0.1
  (package
    (name "rust-psm")
    (version "0.1.21")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "psm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0x78nj5wxkxwijd2gvv2ycq06443b2y1ih4j46kk6c2flg6zg1sp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1))))
    (home-page "https://github.com/rust-lang/stacker/")
    (synopsis
     "Portable Stack Manipulation: stack manipulation and introspection routines")
    (description
     "This package provides Portable Stack Manipulation: stack manipulation and introspection routines.")
    (license (list license:expat license:asl2.0))))

(define-public rust-memfd-0.6
  (package
    (name "rust-memfd")
    (version "0.6.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "memfd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0r5cm3wzyr1x7768h3hns77b494qbz0g05cb9wgpjvrcsm5gmkxj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustix" ,rust-rustix-0.38))))
    (home-page "https://github.com/lucab/memfd-rs")
    (synopsis "pure-Rust library to work with Linux memfd and sealing")
    (description
     "This package provides a pure-Rust library to work with Linux memfd and sealing.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasmtime-runtime-19
  (package
    (name "rust-wasmtime-runtime")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-runtime" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1f2ykzpwgrqdf1b5sfczasvkjxxfhd76wh5p14riizd45hjfw1hq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mach" ,rust-mach-0.3)
                       ("rust-memfd" ,rust-memfd-0.6)
                       ("rust-memoffset" ,rust-memoffset-0.9)
                       ("rust-paste" ,rust-paste-1)
                       ("rust-psm" ,rust-psm-0.1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-sptr" ,rust-sptr-0.3)
                       ("rust-wasm-encoder" ,rust-wasm-encoder-0.201)
                       ("rust-wasmtime-asm-macros" ,rust-wasmtime-asm-macros-19)
                       ("rust-wasmtime-environ" ,rust-wasmtime-environ-19)
                       ("rust-wasmtime-fiber" ,rust-wasmtime-fiber-19)
                       ("rust-wasmtime-jit-debug" ,rust-wasmtime-jit-debug-19)
                       ("rust-wasmtime-versioned-export-macros" ,rust-wasmtime-versioned-export-macros-19)
                       ("rust-wasmtime-versioned-export-macros" ,rust-wasmtime-versioned-export-macros-19)
                       ("rust-wasmtime-wmemcheck" ,rust-wasmtime-wmemcheck-19)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Runtime library support for Wasmtime")
    (description "This package provides Runtime library support for Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-jit-icache-coherence-19
  (package
    (name "rust-wasmtime-jit-icache-coherence")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-jit-icache-coherence" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1c04bq9r1xlp4h8f6x6nq8djbcklw99k8dv00r03vcl79pps4b62"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Utilities for JIT icache maintenance")
    (description "This package provides Utilities for JIT icache maintenance.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-jit-debug-19
  (package
    (name "rust-wasmtime-jit-debug")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-jit-debug" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pznqrsjhc096873nzgwkl7l9fhfjnlr3wxdc914dw7pgchk9plj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-object" ,rust-object-0.32)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-wasmtime-versioned-export-macros" ,rust-wasmtime-versioned-export-macros-19))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "JIT debug interfaces support for Wasmtime")
    (description
     "This package provides JIT debug interfaces support for Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-asm-macros-19
  (package
    (name "rust-wasmtime-asm-macros")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-asm-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1brxqwb8zdgrcqg16si5anmnphbz6sbglw6ajnq6y4raw2caa2hi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Macros for defining asm functions in Wasmtime")
    (description
     "This package provides Macros for defining asm functions in Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-fiber-19
  (package
    (name "rust-wasmtime-fiber")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-fiber" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1mnvbv5fdwm6rwm7cqjay6alqcms3wp39v8nha0arjvva91vcdcj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-wasmtime-asm-macros" ,rust-wasmtime-asm-macros-19)
                       ("rust-wasmtime-versioned-export-macros" ,rust-wasmtime-versioned-export-macros-19)
                       ("rust-wasmtime-versioned-export-macros" ,rust-wasmtime-versioned-export-macros-19)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Fiber support for Wasmtime")
    (description "This package provides Fiber support for Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-versioned-export-macros-19
  (package
    (name "rust-wasmtime-versioned-export-macros")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-versioned-export-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "199d38wm8nsgmv6m06bj1i00mjn4a1fjksb8w2g1lnrm29fgmapz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Macros for defining versioned exports in Wasmtime")
    (description
     "This package provides Macros for defining versioned exports in Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmprinter-0.201
  (package
    (name "rust-wasmprinter")
    (version "0.201.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmprinter" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rf2q8lggfwpkrwy8qhsrfzzd1ch0z0f6y4sf84bl1i7f3d6czm6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-wasmparser" ,rust-wasmparser-0.201))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasmprinter")
    (synopsis
     "Rust converter from the WebAssembly binary format to the text format.")
    (description
     "This package provides Rust converter from the @code{WebAssembly} binary format to the text format.")
    (license (list license:asl2.0))))

(define-public rust-afl-0.13
  (package
    (name "rust-afl")
    (version "0.13.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "afl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rfpfnfj88iss9mkqybjwx3dyxyx91k07m7k0zzzqr0jnjwvi47q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clap" ,rust-clap-4)
                       ("rust-fs-extra" ,rust-fs-extra-1)
                       ("rust-home" ,rust-home-0.5)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-rustc-version" ,rust-rustc-version-0.4)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-xdg" ,rust-xdg-2)
                       ("rust-xdg" ,rust-xdg-2))))
    (home-page "https://github.com/rust-fuzz/afl.rs")
    (synopsis "Fuzzing Rust code with american-fuzzy-lop")
    (description
     "This package provides Fuzzing Rust code with american-fuzzy-lop.")
    (license license:asl2.0)))

(define-public rust-cpp-demangle-0.4
  (package
    (name "rust-cpp-demangle")
    (version "0.4.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cpp_demangle" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "069ila6117qji0jcmk0v0nkdzjkbi7wkvcs9g5b3kv46a802g0ky"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-afl" ,rust-afl-0.13)
                       ("rust-cfg-if" ,rust-cfg-if-1))))
    (home-page "https://github.com/gimli-rs/cpp_demangle")
    (synopsis "crate for demangling C++ symbols")
    (description "This package provides a crate for demangling C++ symbols.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasmtime-environ-19
  (package
    (name "rust-wasmtime-environ")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-environ" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0c6x1v4ak3jpsnx852sraki383v5jzzy2il6f0clrdnvfamg5qyp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-cpp-demangle" ,rust-cpp-demangle-0.4)
                       ("rust-cranelift-entity" ,rust-cranelift-entity-0.106)
                       ("rust-gimli" ,rust-gimli-0.28)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-object" ,rust-object-0.32)
                       ("rust-rustc-demangle" ,rust-rustc-demangle-0.1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-wasm-encoder" ,rust-wasm-encoder-0.201)
                       ("rust-wasmparser" ,rust-wasmparser-0.201)
                       ("rust-wasmprinter" ,rust-wasmprinter-0.201)
                       ("rust-wasmtime-component-util" ,rust-wasmtime-component-util-19)
                       ("rust-wasmtime-types" ,rust-wasmtime-types-19))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis
     "Standalone environment support for WebAsssembly code in Cranelift")
    (description
     "This package provides Standalone environment support for @code{WebAsssembly} code in Cranelift.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-cranelift-shared-19
  (package
    (name "rust-wasmtime-cranelift-shared")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-cranelift-shared" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0yjwq1s891jc9d8xk7z8r721n6j3f9y1rz4wsajq3px0pv5ri22h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-cranelift-codegen" ,rust-cranelift-codegen-0.106)
                       ("rust-cranelift-control" ,rust-cranelift-control-0.106)
                       ("rust-cranelift-native" ,rust-cranelift-native-0.106)
                       ("rust-gimli" ,rust-gimli-0.28)
                       ("rust-object" ,rust-object-0.32)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12)
                       ("rust-wasmtime-environ" ,rust-wasmtime-environ-19))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Base-level integration with Wasmtime and Cranelift")
    (description
     "This package provides Base-level integration with Wasmtime and Cranelift.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-types-19
  (package
    (name "rust-wasmtime-types")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-types" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03zy71z5ci61xsq1w3ld5hya92l650apqd2v5sfns4v3l1x2kgnf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cranelift-entity" ,rust-cranelift-entity-0.106)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-wasmparser" ,rust-wasmparser-0.201))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "WebAssembly type definitions for Cranelift")
    (description
     "This package provides @code{WebAssembly} type definitions for Cranelift.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-wasm-0.106
  (package
    (name "rust-cranelift-wasm")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-wasm" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0kyi47wwij578c2asmkv08v6rn74zya35bp65pav1lv2p1wpkcgq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cranelift-codegen" ,rust-cranelift-codegen-0.106)
                       ("rust-cranelift-entity" ,rust-cranelift-entity-0.106)
                       ("rust-cranelift-frontend" ,rust-cranelift-frontend-0.106)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-itertools" ,rust-itertools-0.12)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-wasmparser" ,rust-wasmparser-0.201)
                       ("rust-wasmtime-types" ,rust-wasmtime-types-19))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Translator from WebAssembly to Cranelift IR")
    (description
     "This package provides Translator from @code{WebAssembly} to Cranelift IR.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-native-0.106
  (package
    (name "rust-cranelift-native")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-native" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0r49ldnkqrkshwqbgm408n827ihr4j7adfxpck0ln72z0kl4c559"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cranelift-codegen" ,rust-cranelift-codegen-0.106)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Support for targeting the host with Cranelift")
    (description
     "This package provides Support for targeting the host with Cranelift.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-frontend-0.106
  (package
    (name "rust-cranelift-frontend")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-frontend" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0aqgm8mzbrr2f08q2r5yp1k0h0z9ryyl6dh944dz7wlqvzyab0jl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cranelift-codegen" ,rust-cranelift-codegen-0.106)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Cranelift IR builder helper")
    (description "This package provides Cranelift IR builder helper.")
    (license (list license:asl2.0))))

(define-public rust-souper-ir-2
  (package
    (name "rust-souper-ir")
    (version "2.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "souper-ir" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0i60q84w5k3rd0j3zhsdc5xasrd4wrkamyrs01rik3lq6g71h355"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-id-arena" ,rust-id-arena-2))))
    (home-page "https://github.com/fitzgen/souper-ir")
    (synopsis "library for manipulating Souper IR")
    (description "This package provides a library for manipulating Souper IR.")
    (license (list license:expat license:asl2.0))))

(define-public rust-slice-group-by-0.3
  (package
    (name "rust-slice-group-by")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "slice-group-by" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19vbyyxqvc25fv2dmhlxijlk5sa9j34yb6hyydb9vf89kh36fqc2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/Kerollmops/slice-group-by")
    (synopsis "Iterators over groups in slices and strs")
    (description
     "This package provides Iterators over groups in slices and strs.")
    (license license:expat)))

(define-public rust-regalloc2-0.9
  (package
    (name "rust-regalloc2")
    (version "0.9.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "regalloc2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19i94jyjma82hgyf5wj83zkqc5wnfxnh38k3lcj7m6w7ki9ns5dd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hashbrown" ,rust-hashbrown-0.13)
                       ("rust-libfuzzer-sys" ,rust-libfuzzer-sys-0.4)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-slice-group-by" ,rust-slice-group-by-0.3)
                       ("rust-smallvec" ,rust-smallvec-1))))
    (home-page "https://github.com/bytecodealliance/regalloc2")
    (synopsis "Backtracking register allocator inspired from IonMonkey")
    (description
     "This package provides Backtracking register allocator inspired from @code{IonMonkey}.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-isle-0.106
  (package
    (name "rust-cranelift-isle")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-isle" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1sl2zkd3ridpd6a6j1gfxg4v8m9mwd10x42nnfyq6cq5nrlihvkg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-codespan-reporting" ,rust-codespan-reporting-0.11)
                       ("rust-log" ,rust-log-0.4))))
    (home-page
     "https://github.com/bytecodealliance/wasmtime/tree/main/cranelift/isle")
    (synopsis
     "ISLE: Instruction Selection and Lowering Expressions. A domain-specific language for instruction selection in Cranelift")
    (description
     "This package provides ISLE: Instruction Selection and Lowering Expressions.  A domain-specific
language for instruction selection in Cranelift.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-control-0.106
  (package
    (name "rust-cranelift-control")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-control" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1syaz8b4wjz7ad6q7nxr7wgs61myzfdf10kmmmrlp5nz8f0818nf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "White-box fuzz testing framework")
    (description "This package provides White-box fuzz testing framework.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-codegen-shared-0.106
  (package
    (name "rust-cranelift-codegen-shared")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-codegen-shared" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06dy864c7xd6hw2pi30zxdp4a9zg53a9wzgplz2bwziv4k0yr4np"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis
     "For code shared between cranelift-codegen-meta and cranelift-codegen")
    (description
     "This package provides For code shared between cranelift-codegen-meta and cranelift-codegen.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-codegen-meta-0.106
  (package
    (name "rust-cranelift-codegen-meta")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-codegen-meta" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nm104c3c5bj7w3ai25rzf3nb320lw0djzybas4if056c0ag42xl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cranelift-codegen-shared" ,rust-cranelift-codegen-shared-0.106))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Metaprogram for cranelift-codegen code generator library")
    (description
     "This package provides Metaprogram for cranelift-codegen code generator library.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-entity-0.106
  (package
    (name "rust-cranelift-entity")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-entity" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1m6462qrf2saq8l4cifyw043j7rkl38mqql7v8agb9kdhd30k4zi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Data structures using entity references as mapping keys")
    (description
     "This package provides Data structures using entity references as mapping keys.")
    (license (list license:asl2.0))))

(define-public rust-cranelift-bforest-0.106
  (package
    (name "rust-cranelift-bforest")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-bforest" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "175jgvcdjdfi4zhfz1vlz4r74w9606r50yyay5pbv2y2zzrx8mrv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cranelift-entity" ,rust-cranelift-entity-0.106))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "forest of B+-trees")
    (description "This package provides a forest of B+-trees.")
    (license (list license:asl2.0))))

(define-public rust-capstone-sys-0.16
  (package
    (name "rust-capstone-sys")
    (version "0.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "capstone-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qshi53z72yciyqskswyll6i9q40yjxf90347b3bgzqi2wkq6wgy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.59)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-regex" ,rust-regex-1))))
    (home-page
     "https://github.com/capstone-rust/capstone-rs/tree/master/capstone-sys")
    (synopsis "System bindings to the capstone disassembly library")
    (description
     "This package provides System bindings to the capstone disassembly library.")
    (license license:expat)))

(define-public rust-capstone-0.12
  (package
    (name "rust-capstone")
    (version "0.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "capstone" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0v2vfzpibdbbabi7nzqrbxn2i5p0a7m8hbhcdchjnnjqv4wa935h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-capstone-sys" ,rust-capstone-sys-0.16)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/capstone-rust/capstone-rs")
    (synopsis
     "High level bindings to capstone disassembly engine (https://capstone-engine.org/)")
    (description
     "This package provides High level bindings to capstone disassembly engine
(https://capstone-engine.org/).")
    (license license:expat)))

(define-public rust-cranelift-codegen-0.106
  (package
    (name "rust-cranelift-codegen")
    (version "0.106.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cranelift-codegen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xqdwwhiavpbmi16k3xamgi8nnpzyris1y9zvcljqgymgynd1xyi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-bumpalo" ,rust-bumpalo-3)
                       ("rust-capstone" ,rust-capstone-0.12)
                       ("rust-cranelift-bforest" ,rust-cranelift-bforest-0.106)
                       ("rust-cranelift-codegen-meta" ,rust-cranelift-codegen-meta-0.106)
                       ("rust-cranelift-codegen-shared" ,rust-cranelift-codegen-shared-0.106)
                       ("rust-cranelift-control" ,rust-cranelift-control-0.106)
                       ("rust-cranelift-entity" ,rust-cranelift-entity-0.106)
                       ("rust-cranelift-isle" ,rust-cranelift-isle-0.106)
                       ("rust-gimli" ,rust-gimli-0.28)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-regalloc2" ,rust-regalloc2-0.9)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-souper-ir" ,rust-souper-ir-2)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Low-level code generator library")
    (description "This package provides Low-level code generator library.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-cranelift-19
  (package
    (name "rust-wasmtime-cranelift")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-cranelift" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0f17b5zrqsrlhwcfm2g2f2s6sdanilrz2s9gw2gv7dd4a4j2c8z9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cranelift-codegen" ,rust-cranelift-codegen-0.106)
                       ("rust-cranelift-control" ,rust-cranelift-control-0.106)
                       ("rust-cranelift-entity" ,rust-cranelift-entity-0.106)
                       ("rust-cranelift-frontend" ,rust-cranelift-frontend-0.106)
                       ("rust-cranelift-native" ,rust-cranelift-native-0.106)
                       ("rust-cranelift-wasm" ,rust-cranelift-wasm-0.106)
                       ("rust-gimli" ,rust-gimli-0.28)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-object" ,rust-object-0.32)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-wasmparser" ,rust-wasmparser-0.201)
                       ("rust-wasmtime-cranelift-shared" ,rust-wasmtime-cranelift-shared-19)
                       ("rust-wasmtime-environ" ,rust-wasmtime-environ-19)
                       ("rust-wasmtime-versioned-export-macros" ,rust-wasmtime-versioned-export-macros-19))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Integration between Cranelift and Wasmtime")
    (description
     "This package provides Integration between Cranelift and Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmparser-0.215
  (package
    (name "rust-wasmparser")
    (version "0.215.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmparser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03nryws9f2awvfd47z5pn67aqif1z7w6z6zl3jw9jhgjh44dxysk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-semver" ,rust-semver-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasmparser")
    (synopsis
     "simple event-driven library for parsing WebAssembly binary files.")
    (description
     "This package provides a simple event-driven library for parsing
@code{WebAssembly} binary files.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-wasm-encoder-0.215
  (package
    (name "rust-wasm-encoder")
    (version "0.215.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasm-encoder" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0iw886v4jzvbwxakiswsk81824m51fjnjabxwdvnp3kbw3rnvdag"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-leb128" ,rust-leb128-0.2)
                       ("rust-wasmparser" ,rust-wasmparser-0.215))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasm-encoder")
    (synopsis "low-level WebAssembly encoder.")
    (description
     "This package provides a low-level @code{WebAssembly} encoder.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-gimli-0.30
  (package
    (name "rust-gimli")
    (version "0.30.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gimli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jfz1sj9h0rnlhjnmy315db2drsn54f0b5qcpndvl8lpprzxkqg2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-fallible-iterator" ,rust-fallible-iterator-0.3)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-stable-deref-trait" ,rust-stable-deref-trait-1))))
    (home-page "https://github.com/gimli-rs/gimli")
    (synopsis "library for reading and writing the DWARF debugging format.")
    (description
     "This package provides a library for reading and writing the DWARF debugging
format.")
    (license (list license:expat license:asl2.0))))

(define-public rust-bumpalo-3
  (package
    (name "rust-bumpalo")
    (version "3.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bumpalo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0b015qb4knwanbdlp1x48pkb4pm57b8gidbhhhxr900q2wb6fabr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-allocator-api2" ,rust-allocator-api2-0.2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/fitzgen/bumpalo")
    (synopsis "fast bump allocation arena for Rust.")
    (description
     "This package provides a fast bump allocation arena for Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wast-215
  (package
    (name "rust-wast")
    (version "215.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wast" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jslxdhsnrjfky3a41iqvk2g2hhzgi5f02vjc2g294rmi46x1w8z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bumpalo" ,rust-bumpalo-3)
                       ("rust-gimli" ,rust-gimli-0.30)
                       ("rust-leb128" ,rust-leb128-0.2)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-wasm-encoder" ,rust-wasm-encoder-0.215))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wast")
    (synopsis
     "Customizable Rust parsers for the WebAssembly Text formats WAT and WAST")
    (description
     "This package provides Customizable Rust parsers for the @code{WebAssembly} Text formats WAT and WAST.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-wat-1
  (package
    (name "rust-wat")
    (version "1.215.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wat" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gaf5fzl8lq6rfdiz1x6zbdbc9b5aiyd9pkh5ljawxngr3cz82v7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-wast" ,rust-wast-215))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wat")
    (synopsis "Rust parser for the WebAssembly Text format, WAT")
    (description
     "This package provides Rust parser for the @code{WebAssembly} Text format, WAT.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-id-arena-2
  (package
    (name "rust-id-arena")
    (version "2.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "id-arena" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01ch8jhpgnih8sawqs44fqsqpc7bzwgy0xpi6j0f4j0i5mkvr8i5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rayon" ,rust-rayon-1))))
    (home-page "https://github.com/fitzgen/id-arena")
    (synopsis "simple, id-based arena.")
    (description "This package provides a simple, id-based arena.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wit-parser-0.201
  (package
    (name "rust-wit-parser")
    (version "0.201.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wit-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19nwxzv7by2m2vl7sk1fffrh9cwni4zrnspq7dbshndpqk7kwv8r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-id-arena" ,rust-id-arena-2)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-semver" ,rust-semver-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2)
                       ("rust-wasmparser" ,rust-wasmparser-0.201)
                       ("rust-wat" ,rust-wat-1))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wit-parser")
    (synopsis
     "Tooling for parsing `*.wit` files and working with their contents.")
    (description
     "This package provides Tooling for parsing `*.wit` files and working with their contents.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-wit-bindgen-19
  (package
    (name "rust-wasmtime-wit-bindgen")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-wit-bindgen" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wmga6v328gzsn5ljaxzgl5pp4xgyfzlir836r4xgv85hly2aykw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-heck" ,rust-heck-0.4)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-wit-parser" ,rust-wit-parser-0.201))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Internal `*.wit` support for the `wasmtime` crate's macros")
    (description
     "This package provides Internal `*.wit` support for the `wasmtime` crate's macros.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-component-util-19
  (package
    (name "rust-wasmtime-component-util")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-component-util" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09cizbzb1y11sa7z13wi13ljmf2mixihg7bb9g98zcn0xg0pvl8d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis
     "Utility types and functions to support the component model in Wasmtime")
    (description
     "This package provides Utility types and functions to support the component model in Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-component-macro-19
  (package
    (name "rust-wasmtime-component-macro")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-component-macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01v0xlp1dfxsvphppr7z32ahs0avcvxqi4q10x6sqlb2b37347q9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-wasmtime-component-util" ,rust-wasmtime-component-util-19)
                       ("rust-wasmtime-wit-bindgen" ,rust-wasmtime-wit-bindgen-19)
                       ("rust-wit-parser" ,rust-wit-parser-0.201))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Macros for deriving component interface types from Rust types")
    (description
     "This package provides Macros for deriving component interface types from Rust types.")
    (license (list license:asl2.0))))

(define-public rust-wasmtime-cache-19
  (package
    (name "rust-wasmtime-cache")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-cache" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0970vavsgzppa6ffb11sk2v4h91x82fwrc3zj5vgrhhagd9n1rn4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-directories-next" ,rust-directories-next-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-sha2" ,rust-sha2-0.10)
                       ("rust-toml" ,rust-toml-0.8)
                       ("rust-windows-sys" ,rust-windows-sys-0.52)
                       ("rust-zstd" ,rust-zstd-0.13))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "Support for automatic module caching with Wasmtime")
    (description
     "This package provides Support for automatic module caching with Wasmtime.")
    (license (list license:asl2.0))))

(define-public rust-wasmparser-0.201
  (package
    (name "rust-wasmparser")
    (version "0.201.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmparser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "027pdclgl642hqzdi592nnhdf7j570bhyi9sqsppy3bcp9nxzrc4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-semver" ,rust-semver-1))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasmparser")
    (synopsis
     "simple event-driven library for parsing WebAssembly binary files.")
    (description
     "This package provides a simple event-driven library for parsing
@code{WebAssembly} binary files.")
    (license (list license:asl2.0))))

(define-public rust-wasm-encoder-0.201
  (package
    (name "rust-wasm-encoder")
    (version "0.201.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasm-encoder" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06lgfkb0r1dw0hc1mqgnrkg935h1qb668gq1kf0hc07n3mrx5ixr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-leb128" ,rust-leb128-0.2)
                       ("rust-wasmparser" ,rust-wasmparser-0.201))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasm-encoder")
    (synopsis "low-level WebAssembly encoder.")
    (description
     "This package provides a low-level @code{WebAssembly} encoder.")
    (license (list license:asl2.0))))

(define-public rust-ittapi-sys-0.4
  (package
    (name "rust-ittapi-sys")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ittapi-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z7lgc7gwlhcvkdk6bg9sf1ww4w0b41blp90hv4a4kq6ji9kixaj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1))))
    (home-page "https://github.com/intel/ittapi/tree/master/rust/ittapi-sys")
    (synopsis "Rust bindings for ittapi")
    (description "This package provides Rust bindings for ittapi.")
    (license (list license:gpl2 license:bsd-3))))

(define-public rust-ittapi-0.4
  (package
    (name "rust-ittapi")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ittapi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cb41dapbximlma0vnar144m2j2km44g8g6zmv6ra4y42kk6z6bb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-ittapi-sys" ,rust-ittapi-sys-0.4)
                       ("rust-log" ,rust-log-0.4))))
    (home-page "https://github.com/intel/ittapi/tree/master/rust/ittapi")
    (synopsis "High-level Rust bindings for ittapi")
    (description "This package provides High-level Rust bindings for ittapi.")
    (license (list license:gpl2 license:bsd-3))))

(define-public rust-fxprof-processed-profile-0.6
  (package
    (name "rust-fxprof-processed-profile")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fxprof-processed-profile" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ggsn3im2bfcnxic0jzk00qgiacfrg2as6i4d8kj87kzxl52rl97"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-debugid" ,rust-debugid-0.8)
                       ("rust-fxhash" ,rust-fxhash-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/mstange/samply/")
    (synopsis
     "Create profiles in the Firefox Profiler's processed profile JSON format")
    (description
     "This package provides Create profiles in the Firefox Profiler's processed profile JSON format.")
    (license (list license:expat license:asl2.0))))

(define-public rust-addr2line-0.21
  (package
    (inherit rust-addr2line-0.24)
    (name "rust-addr2line")
    (version "0.21.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "addr2line" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jx0k3iwyqr8klqbzk6kjvr496yd94aspis10vwsj5wy7gib4c4a"))))
    (arguments
     `(#:tests? #f      ; use of undeclared crate or module `auxiliary`
       #:cargo-inputs
       (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
        ("rust-cpp-demangle" ,rust-cpp-demangle-0.4)
        ("rust-fallible-iterator" ,rust-fallible-iterator-0.3)
        ("rust-gimli" ,rust-gimli-0.28)
        ("rust-memmap2" ,rust-memmap2-0.5)
        ("rust-object" ,rust-object-0.32)
        ("rust-rustc-demangle" ,rust-rustc-demangle-0.1)
        ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
        ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
        ("rust-smallvec" ,rust-smallvec-1))
       #:cargo-development-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                                   ("rust-clap" ,rust-clap-4)
                                   ("rust-findshlibs" ,rust-findshlibs-0.10)
                                   ("rust-libtest-mimic" ,rust-libtest-mimic-0.6)
                                   ("rust-typed-arena" ,rust-typed-arena-2))))))

(define-public rust-wasmtime-19
  (package
    (name "rust-wasmtime")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zfvb2x6ivbhcjsaldnypl6wfil611hycz5iwdj91p0r7w70qc2f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-addr2line" ,rust-addr2line-0.21)
                       ("rust-anyhow" ,rust-anyhow-1)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-bumpalo" ,rust-bumpalo-3)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-fxprof-processed-profile" ,rust-fxprof-processed-profile-0.6)
                       ("rust-gimli" ,rust-gimli-0.28)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-ittapi" ,rust-ittapi-0.4)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-object" ,rust-object-0.32)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-paste" ,rust-paste-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-semver" ,rust-semver-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-target-lexicon" ,rust-target-lexicon-0.12)
                       ("rust-wasm-encoder" ,rust-wasm-encoder-0.201)
                       ("rust-wasmparser" ,rust-wasmparser-0.201)
                       ("rust-wasmtime-cache" ,rust-wasmtime-cache-19)
                       ("rust-wasmtime-component-macro" ,rust-wasmtime-component-macro-19)
                       ("rust-wasmtime-component-util" ,rust-wasmtime-component-util-19)
                       ("rust-wasmtime-cranelift" ,rust-wasmtime-cranelift-19)
                       ("rust-wasmtime-environ" ,rust-wasmtime-environ-19)
                       ("rust-wasmtime-fiber" ,rust-wasmtime-fiber-19)
                       ("rust-wasmtime-jit-debug" ,rust-wasmtime-jit-debug-19)
                       ("rust-wasmtime-jit-icache-coherence" ,rust-wasmtime-jit-icache-coherence-19)
                       ("rust-wasmtime-runtime" ,rust-wasmtime-runtime-19)
                       ("rust-wasmtime-slab" ,rust-wasmtime-slab-19)
                       ("rust-wasmtime-winch" ,rust-wasmtime-winch-19)
                       ("rust-wat" ,rust-wat-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "High-level API to expose the Wasmtime runtime")
    (description
     "This package provides High-level API to expose the Wasmtime runtime.")
    (license (list license:asl2.0))))

(define-public rust-ssh2-0.9
  (package
    (name "rust-ssh2")
    (version "0.9.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ssh2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0malilb9lbzlh3i24nb6s61lmz5as801swy30ib6v7sm20cldzp7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libssh2-sys" ,rust-libssh2-sys-0.3)
                       ("rust-parking-lot" ,rust-parking-lot-0.11))))
    (home-page "https://github.com/alexcrichton/ssh2-rs")
    (synopsis
     "Bindings to libssh2 for interacting with SSH servers and executing remote
commands, forwarding local ports, etc.")
    (description
     "This package provides Bindings to libssh2 for interacting with SSH servers and executing remote
commands, forwarding local ports, etc.")
    (license (list license:expat license:asl2.0))))

(define-public rust-char-device-0.16
  (package
    (name "rust-char-device")
    (version "0.16.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "char-device" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lcvym9n8v01fwi2jmxx1rq51fqzls35jfxyxvdfyd3c1k3w804x"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-io-extras" ,rust-io-extras-0.18)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-2)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-winx" ,rust-winx-0.36))))
    (home-page "https://github.com/sunfishcode/char-device")
    (synopsis "Character Device I/O")
    (description "This package provides Character Device I/O.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-system-interface-0.27
  (package
    (name "rust-system-interface")
    (version "0.27.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "system-interface" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19hh608hj3f3c0lc1vmd2dzkgmgbmhm3qbngnflqh03m49nm4n5q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cap-fs-ext" ,rust-cap-fs-ext-3)
                       ("rust-cap-std" ,rust-cap-std-3)
                       ("rust-char-device" ,rust-char-device-0.16)
                       ("rust-fd-lock" ,rust-fd-lock-4)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-2)
                       ("rust-os-pipe" ,rust-os-pipe-1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-socketpair" ,rust-socketpair-0.19)
                       ("rust-ssh2" ,rust-ssh2-0.9)
                       ("rust-windows-sys" ,rust-windows-sys-0.52)
                       ("rust-winx" ,rust-winx-0.36))))
    (home-page "https://github.com/bytecodealliance/system-interface")
    (synopsis "Extensions to the Rust standard library")
    (description
     "This package provides Extensions to the Rust standard library.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-cap-time-ext-3
  (package
    (name "rust-cap-time-ext")
    (version "3.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cap-time-ext" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09bpjmw3wn2z7w3w2imspciaqpk9qgi8qmyaf34srdr53v2js531"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ambient-authority" ,rust-ambient-authority-0.0.2)
                       ("rust-cap-primitives" ,rust-cap-primitives-3)
                       ("rust-cap-std" ,rust-cap-std-3)
                       ("rust-iana-time-zone" ,rust-iana-time-zone-0.1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-winx" ,rust-winx-0.36))))
    (home-page "https://github.com/bytecodealliance/cap-std")
    (synopsis "Extension traits for `SystemClock` and `MonotonicClock`")
    (description
     "This package provides Extension traits for `@code{SystemClock`} and `@code{MonotonicClock`}.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-cap-rand-3
  (package
    (name "rust-cap-rand")
    (version "3.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cap-rand" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04aj5ylnz6f0gr0zi756fw9cf6ia1llvshhzsqg23f6q36k1djyv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ambient-authority" ,rust-ambient-authority-0.0.2)
                       ("rust-rand" ,rust-rand-0.8))))
    (home-page "https://github.com/bytecodealliance/cap-std")
    (synopsis "Capability-based random number generators")
    (description
     "This package provides Capability-based random number generators.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-cap-fs-ext-3
  (package
    (name "rust-cap-fs-ext")
    (version "3.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cap-fs-ext" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vp56jm43srrkhwmqnlzjm727rk8ww7hh4x7bkjd9sn4q4ghc8zb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arf-strings" ,rust-arf-strings-0.7)
                       ("rust-camino" ,rust-camino-1)
                       ("rust-cap-primitives" ,rust-cap-primitives-3)
                       ("rust-cap-std" ,rust-cap-std-3)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-2)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/cap-std")
    (synopsis "Extension traits for `Dir`, `File`, etc")
    (description
     "This package provides Extension traits for `Dir`, `File`, etc.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-wasi-common-19
  (package
    (name "rust-wasi-common")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasi-common" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1p4lq2lxg1l6kz25qf1p9vnjzgs528p9w3m8113ra6jicqrx8fff"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cap-fs-ext" ,rust-cap-fs-ext-3)
                       ("rust-cap-rand" ,rust-cap-rand-3)
                       ("rust-cap-std" ,rust-cap-std-3)
                       ("rust-cap-time-ext" ,rust-cap-time-ext-3)
                       ("rust-fs-set-times" ,rust-fs-set-times-0.20)
                       ("rust-io-extras" ,rust-io-extras-0.18)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-system-interface" ,rust-system-interface-0.27)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-wasmtime" ,rust-wasmtime-19)
                       ("rust-wiggle" ,rust-wiggle-19)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "WASI implementation in Rust")
    (description "This package provides WASI implementation in Rust.")
    (license (list license:asl2.0))))

(define-public rust-winx-0.36
  (package
    (name "rust-winx")
    (version "0.36.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winx" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ikk6cnlfiq7dm36jqwrczxa8jyh9m2zmrdbxi3d430cha1knr7r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/sunfishcode/winx")
    (synopsis "Windows API helper library")
    (description "This package provides Windows API helper library.")
    (license (list license:asl2.0))))

(define-public rust-rustix-0.38
  (package
    (name "rust-rustix")
    (version "0.38.34")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rustix" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03vkqa2ism7q56rkifyy8mns0wwqrk70f4i4fd53r97p8b05xp3h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-errno" ,rust-errno-0.3)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/rustix")
    (synopsis "Safe Rust bindings to POSIX/Unix/Linux/Winsock-like syscalls")
    (description
     "This package provides Safe Rust bindings to POSIX/Unix/Linux/Winsock-like syscalls.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-maybe-owned-0.3
  (package
    (name "rust-maybe-owned")
    (version "0.3.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "maybe-owned" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d3sqiv59i06k73x6p7mf294zgdfb2qkky127ipfnjj9mr9wgb2g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rustonaut/maybe-owned")
    (synopsis
     "provides a `MaybeOwned` (and `MaybeOwnedMut`) type similar to std's `Cow` but it implements `From<T>` and `From<&'a T>` and does not require `ToOwned`")
    (description
     "This package provides provides a `@code{MaybeOwned`} (and `@code{MaybeOwnedMut`}) type similar to
std's `Cow` but it implements `From<T>` and `From<&'a T>` and does not require
`@code{ToOwned`}.")
    (license (list license:expat license:asl2.0))))

(define-public rust-fs-set-times-0.20
  (package
    (name "rust-fs-set-times")
    (version "0.20.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fs-set-times" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yxqkl8khk1593ribn4s9v60vf375gi9sgw9hq6nk5svf9yk6fq3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-io-lifetimes" ,rust-io-lifetimes-2)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/bytecodealliance/fs-set-times")
    (synopsis "Set filesystem timestamps")
    (description "This package provides Set filesystem timestamps.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-ambient-authority-0.0.2
  (package
    (name "rust-ambient-authority")
    (version "0.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ambient-authority" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0fxsfyhy64jx7zrkb85h1vhr5nfqncja3pwpikid471d8w6yxm79"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/sunfishcode/ambient-authority")
    (synopsis "Ambient Authority")
    (description "This package provides Ambient Authority.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-cap-primitives-3
  (package
    (name "rust-cap-primitives")
    (version "3.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cap-primitives" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ccms8hk580z19lrld1w3jd0i8k4g4w3ga5a1sahs9y44s6vs03d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ambient-authority" ,rust-ambient-authority-0.0.2)
                       ("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-fs-set-times" ,rust-fs-set-times-0.20)
                       ("rust-io-extras" ,rust-io-extras-0.18)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-2)
                       ("rust-ipnet" ,rust-ipnet-2)
                       ("rust-maybe-owned" ,rust-maybe-owned-0.3)
                       ("rust-rustix" ,rust-rustix-0.38)
                       ("rust-windows-sys" ,rust-windows-sys-0.52)
                       ("rust-winx" ,rust-winx-0.36))))
    (home-page "https://github.com/bytecodealliance/cap-std")
    (synopsis "Capability-based primitives")
    (description "This package provides Capability-based primitives.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-arf-strings-0.7
  (package
    (name "rust-arf-strings")
    (version "0.7.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "arf-strings" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ncy11j7bk0ji94yb8nafyr5wvfg90q6vcbzcanpdbgyk4cy9szx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustix" ,rust-rustix-0.38))))
    (home-page "https://github.com/bytecodealliance/arf-strings")
    (synopsis "Encoding and decoding for ARF strings")
    (description
     "This package provides Encoding and decoding for ARF strings.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-cap-std-3
  (package
    (name "rust-cap-std")
    (version "3.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cap-std" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zxxbz0pzvv92kj79j5xqqm7afcn8f591lqy3isjhs4rf4yqxsqr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arf-strings" ,rust-arf-strings-0.7)
                       ("rust-camino" ,rust-camino-1)
                       ("rust-cap-primitives" ,rust-cap-primitives-3)
                       ("rust-io-extras" ,rust-io-extras-0.18)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-2)
                       ("rust-rustix" ,rust-rustix-0.38))))
    (home-page "https://github.com/bytecodealliance/cap-std")
    (synopsis "Capability-based version of the Rust standard library")
    (description
     "This package provides Capability-based version of the Rust standard library.")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-wasmtime-c-api-impl-19
  (package
    (name "rust-wasmtime-c-api-impl")
    (version "19.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmtime-c-api-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bp5pbdrq7q3fgg7mdl36kycwgrk6lhkb3w42w9kfbfwjsp4ss5y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-cap-std" ,rust-cap-std-3)
                       ("rust-env-logger" ,rust-env-logger-0.10)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-wasi-common" ,rust-wasi-common-19)
                       ("rust-wasmtime" ,rust-wasmtime-19)
                       ("rust-wasmtime-c-api-macros" ,rust-wasmtime-c-api-macros-19)
                       ("rust-wat" ,rust-wat-1))))
    (home-page "https://github.com/bytecodealliance/wasmtime")
    (synopsis "C API to expose the Wasmtime runtime")
    (description "This package provides C API to expose the Wasmtime runtime.")
    (license (list license:asl2.0))))

(define-public rust-tree-sitter-0.22
  (package
    (name "rust-tree-sitter")
    (version "0.22.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tree-sitter" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jkda5n43m7cxmx2h7l20zxc74nf9v1wpm66gvgxrm5drscw8z6z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.69)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-wasmtime-c-api-impl" ,rust-wasmtime-c-api-impl-19))))
    (home-page "https://tree-sitter.github.io/tree-sitter")
    (synopsis "Rust bindings to the Tree-sitter parsing library")
    (description
     "This package provides Rust bindings to the Tree-sitter parsing library.")
    (license license:expat)))

(define-public rust-tower-lsp-macros-0.9
  (package
    (name "rust-tower-lsp-macros")
    (version "0.9.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tower-lsp-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yi2ahsndbb1xkw05dx95237bq9lq26i0h7ly8klp6hb9qnr1zc4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/ebkalderon/tower-lsp")
    (synopsis "Internal procedural macros for tower-lsp")
    (description
     "This package provides Internal procedural macros for tower-lsp.")
    (license (list license:expat license:asl2.0))))

(define-public rust-lsp-types-0.94
  (package
    (name "rust-lsp-types")
    (version "0.94.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "lsp-types" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18aym1qfgyaf9f9504yz911gssck5rv190izzr3hdqbal12gssy6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-repr" ,rust-serde-repr-0.1)
                       ("rust-url" ,rust-url-2))))
    (home-page "https://github.com/gluon-lang/lsp-types")
    (synopsis
     "Types for interaction with a language server, using VSCode's Language Server Protocol")
    (description
     "This package provides Types for interaction with a language server, using VSCode's Language Server
Protocol.")
    (license license:expat)))

(define-public rust-auto-impl-1
  (package
    (name "rust-auto-impl")
    (version "1.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "auto_impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hmfcahj0vrnzq7rayk7r428zp54x9a8awgw6wil753pbvqz71rw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/auto-impl-rs/auto_impl/")
    (synopsis
     "Automatically implement traits for common smart pointers and closures")
    (description
     "This package provides Automatically implement traits for common smart pointers and closures.")
    (license (list license:expat license:asl2.0))))

(define-public rust-async-codec-lite-0.0.2
  (package
    (name "rust-async-codec-lite")
    (version "0.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "async-codec-lite" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "18v08w0mwv2gd1in1gjd2lm2bi18x3d2ac9mdcvgzn3j747c69r5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-cbor" ,rust-serde-cbor-0.11)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "")
    (synopsis
     "Adaptors from AsyncRead/AsyncWrite to Stream/Sink using futures.")
    (description
     "This package provides Adaptors from @code{AsyncRead/AsyncWrite} to Stream/Sink using futures.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-tower-lsp-0.20
  (package
    (name "rust-tower-lsp")
    (version "0.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tower-lsp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0245266rj84zgd4wv6nsnxcq7nkydqblrhxkv4l7cqm6ahmhbfnl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-codec-lite" ,rust-async-codec-lite-0.0.2)
                       ("rust-async-trait" ,rust-async-trait-0.1)
                       ("rust-auto-impl" ,rust-auto-impl-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-dashmap" ,rust-dashmap-5)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-httparse" ,rust-httparse-1)
                       ("rust-lsp-types" ,rust-lsp-types-0.94)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tower" ,rust-tower-0.4)
                       ("rust-tower-lsp-macros" ,rust-tower-lsp-macros-0.9)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/ebkalderon/tower-lsp")
    (synopsis "Language Server Protocol implementation based on Tower")
    (description
     "This package provides Language Server Protocol implementation based on Tower.")
    (license (list license:expat license:asl2.0))))

(define-public rust-winnow-0.6
  (package
    (name "rust-winnow")
    (version "0.6.18")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winnow" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vrsrnf2nm9jsk1161x1vacmi3ns4h3h10fib91rs28zd6jbvab8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anstream" ,rust-anstream-0.3)
                       ("rust-anstyle" ,rust-anstyle-1)
                       ("rust-is-terminal" ,rust-is-terminal-0.4)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-terminal-size" ,rust-terminal-size-0.2))))
    (home-page "https://github.com/winnow-rs/winnow")
    (synopsis "byte-oriented, zero-copy, parser combinators library")
    (description
     "This package provides a byte-oriented, zero-copy, parser combinators library.")
    (license license:expat)))

(define-public rust-toml-edit-0.22
  (package
    (name "rust-toml-edit")
    (version "0.22.20")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "toml_edit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07ffw4626k6abicjxb2idh12f1p5fn965zk660zhqsyj5b048g2q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-2)
                       ("rust-kstring" ,rust-kstring-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-spanned" ,rust-serde-spanned-0.6)
                       ("rust-toml-datetime" ,rust-toml-datetime-0.6)
                       ("rust-winnow" ,rust-winnow-0.6))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis "Yet another format-preserving TOML parser")
    (description
     "This package provides Yet another format-preserving TOML parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-toml-datetime-0.6
  (package
    (name "rust-toml-datetime")
    (version "0.6.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "toml_datetime" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hgv7v9g35d7y9r2afic58jvlwnf73vgd1mz2k8gihlgrf73bmqd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis "TOML-compatible datetime type")
    (description "This package provides a TOML-compatible datetime type.")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-spanned-0.6
  (package
    (name "rust-serde-spanned")
    (version "0.6.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde_spanned" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0v9h2nlg8r7n7dkbgj1aw59g35kl869l652wc6zi2f4zawqinnzb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis "Serde-compatible spanned Value")
    (description "This package provides Serde-compatible spanned Value.")
    (license (list license:expat license:asl2.0))))

(define-public rust-toml-0.8
  (package
    (name "rust-toml")
    (version "0.8.19")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "toml" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0knjd3mkxyb87qcs2dark3qkpadidap3frqfj5nqvhpxwfc1zvd1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-spanned" ,rust-serde-spanned-0.6)
                       ("rust-toml-datetime" ,rust-toml-datetime-0.6)
                       ("rust-toml-edit" ,rust-toml-edit-0.22))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis
     "native Rust encoder and decoder of TOML-formatted files and streams. Provides
implementations of the standard Serialize/Deserialize traits for TOML data to
facilitate deserializing and serializing Rust structures.")
    (description
     "This package provides a native Rust encoder and decoder of TOML-formatted files
and streams.  Provides implementations of the standard Serialize/Deserialize
traits for TOML data to facilitate deserializing and serializing Rust
structures.")
    (license (list license:expat license:asl2.0))))

(define-public rust-tokio-macros-2
  (package
    (name "rust-tokio-macros")
    (version "2.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lnpg14h1v3fh2jvnc8cz7cjf0m7z1xgkwfpcyy632g829imjgb9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://tokio.rs")
    (synopsis "Tokio's proc macros.")
    (description "This package provides Tokio's proc macros.")
    (license license:expat)))

(define-public rust-hermit-abi-0.3
  (package
    (name "rust-hermit-abi")
    (version "0.3.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "hermit-abi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "092hxjbjnq5fmz66grd9plxd0sh6ssg5fhgwwwqbrzgzkjwdycfj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/hermit-os/hermit-rs")
    (synopsis "Hermit system calls definitions")
    (description "This package provides Hermit system calls definitions.")
    (license (list license:expat license:asl2.0))))

(define-public rust-mio-1
  (package
    (name "rust-mio")
    (version "1.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mio" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1r5g65s5acsx440m0a3pylclbrd0dqz93hg15k9crpllsdbf8sa5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hermit-abi" ,rust-hermit-abi-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-wasi" ,rust-wasi-0.11)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://github.com/tokio-rs/mio")
    (synopsis "Lightweight non-blocking I/O")
    (description "This package provides Lightweight non-blocking I/O.")
    (license license:expat)))

(define-public rust-tokio-1
  (package
    (name "rust-tokio")
    (version "1.39.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tokio" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1cb7yhba7nnf00cylcywk7rai5kkdb8b4jzwrc26zgbqqwdzp96s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-signal-hook-registry" ,rust-signal-hook-registry-1)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-tokio-macros" ,rust-tokio-macros-2)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))))
    (home-page "https://tokio.rs")
    (synopsis
     "An event-driven, non-blocking I/O platform for writing asynchronous I/O
backed applications.")
    (description
     "This package provides An event-driven, non-blocking I/O platform for writing asynchronous I/O backed
applications.")
    (license license:expat)))

(define-public rust-trim-in-place-0.1
  (package
    (name "rust-trim-in-place")
    (version "0.1.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "trim-in-place" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z04g79xkrpf3h4g3cc8wax72dn6h6v9l4m39zg8rg39qrpr4gil"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://magiclen.org/trim-in-place")
    (synopsis "In-place trimming strings")
    (description "This package provides In-place trimming strings.")
    (license license:expat)))

(define-public rust-dlv-list-0.5
  (package
    (name "rust-dlv-list")
    (version "0.5.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "dlv-list" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pqvrinxzdz7bpy4a3p450h8krns3bd0mc3w0qqvm03l2kskj824"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-const-random" ,rust-const-random-0.1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/sgodwincs/dlv-list-rs")
    (synopsis "Semi-doubly linked list implemented using a vector")
    (description
     "This package provides Semi-doubly linked list implemented using a vector.")
    (license (list license:expat license:asl2.0))))

(define-public rust-ordered-multimap-0.7
  (package
    (name "rust-ordered-multimap")
    (version "0.7.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ordered-multimap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ygg08g2h381r3zbclba4zx4amm25zd2hsqqmlxljc00mvf3q829"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-dlv-list" ,rust-dlv-list-0.5)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/sgodwincs/ordered-multimap-rs")
    (synopsis "Insertion ordered multimap")
    (description "This package provides Insertion ordered multimap.")
    (license license:expat)))

(define-public rust-rust-ini-0.21
  (package
    (name "rust-rust-ini")
    (version "0.21.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rust-ini" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17s0fmfba05i9cnfwfy02wp7mf5wkapis5x1d68vgvmnw7q0wcaf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-ordered-multimap" ,rust-ordered-multimap-0.7)
                       ("rust-trim-in-place" ,rust-trim-in-place-0.1)
                       ("rust-unicase" ,rust-unicase-2))))
    (home-page "https://github.com/zonyitoo/rust-ini")
    (synopsis "An Ini configuration file parsing library in Rust")
    (description
     "This package provides An Ini configuration file parsing library in Rust.")
    (license license:expat)))

(define-public rust-unicode-width-0.1
  (package
    (name "rust-unicode-width")
    (version "0.1.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unicode-width" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0p92vl8n7qc8mxz45xn6qbgi0259z96n32a158l6vj5bywwdadh3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-rustc-std-workspace-std" ,rust-rustc-std-workspace-std-1))))
    (home-page "https://github.com/unicode-rs/unicode-width")
    (synopsis "Determine displayed width of `char` and `str` types
according to Unicode Standard Annex #11 rules.")
    (description
     "This package provides Determine displayed width of `char` and `str` types according to Unicode
Standard Annex #11 rules.")
    (license (list license:expat license:asl2.0))))

(define-public rust-termcolor-1
  (package
    (name "rust-termcolor")
    (version "1.4.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "termcolor" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mappjh3fj3p2nmrg4y7qv94rchwi9mzmgmfflr8p2awdj7lyy86"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-winapi-util" ,rust-winapi-util-0.1))))
    (home-page "https://github.com/BurntSushi/termcolor")
    (synopsis
     "simple cross platform library for writing colored text to a terminal.")
    (description
     "This package provides a simple cross platform library for writing colored text
to a terminal.")
    (license (list license:unlicense license:expat))))

(define-public rust-quote-1
  (package
    (name "rust-quote")
    (version "1.0.36")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "quote" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19xcmh445bg6simirnnd4fvkmp6v2qiwxh5f6rw4a70h76pnm9qg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "https://github.com/dtolnay/quote")
    (synopsis "Quasi-quoting macro quote!(...)")
    (description "This package provides Quasi-quoting macro quote!(...).")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-macro2-1
  (package
    (name "rust-proc-macro2")
    (version "1.0.86")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proc-macro2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xrv22p8lqlfdf1w0pj4si8n2ws4aw0kilmziwf0vpv5ys6rwway"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/dtolnay/proc-macro2")
    (synopsis
     "substitute implementation of the compiler's `proc_macro` API to decouple token-based libraries from the procedural macro use case.")
    (description
     "This package provides a substitute implementation of the compiler's `proc_macro`
API to decouple token-based libraries from the procedural macro use case.")
    (license (list license:expat license:asl2.0))))

(define-public rust-cli-table-derive-0.4
  (package
    (name "rust-cli-table-derive")
    (version "0.4.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cli-table-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "157vhagq20c7i148144692lrn8bfm97wwa3lxds7rbmaacrak0ry"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/devashishdxt/cli-table")
    (synopsis "crate for printing tables on command line")
    (description
     "This package provides a crate for printing tables on command line.")
    (license (list license:expat license:asl2.0))))

(define-public rust-cli-table-0.4
  (package
    (name "rust-cli-table")
    (version "0.4.9")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cli-table" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12bzv6s2i92cbljrjbfl4f4npazfxam08psnaqnb39w8y90r4gxm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cli-table-derive" ,rust-cli-table-derive-0.4)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-termcolor" ,rust-termcolor-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/devashishdxt/cli-table")
    (synopsis "crate for printing tables on command line")
    (description
     "This package provides a crate for printing tables on command line.")
    (license (list license:expat license:asl2.0))))

(define-public rust-clap-derive-4
  (package
    (name "rust-clap-derive")
    (version "4.5.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clap_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1860xq3rbgwsqwcj9rd14cky9iiywwx86j7fvvngdjixbyfka7ah"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.5)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/clap-rs/clap")
    (synopsis "Parse command line argument by defining a struct, derive crate")
    (description
     "This package provides Parse command line argument by defining a struct, derive crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustc-demangle-0.1
  (package
    (name "rust-rustc-demangle")
    (version "0.1.24")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rustc-demangle" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07zysaafgrkzy2rjgwqdj2a8qdpsm6zv6f5pgpk9x0lm40z9b6vi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/rust-lang/rustc-demangle")
    (synopsis "Rust compiler symbol demangling.")
    (description "This package provides Rust compiler symbol demangling.")
    (license (list license:expat license:asl2.0))))

(define-public rust-ahash-0.8
  (package
    (name "rust-ahash")
    (version "0.8.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ahash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04chdfkls5xmhp1d48gnjsmglbqibizs3bpbj6rsj604m10si7g8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-atomic-polyfill" ,rust-atomic-polyfill-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-const-random" ,rust-const-random-0.1)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-version-check" ,rust-version-check-0.9)
                       ("rust-zerocopy" ,rust-zerocopy-0.7))))
    (home-page "https://github.com/tkaitchuck/ahash")
    (synopsis
     "non-cryptographic hash function using AES-NI for high performance")
    (description
     "This package provides a non-cryptographic hash function using AES-NI for high
performance.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasmparser-0.214
  (package
    (name "rust-wasmparser")
    (version "0.214.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmparser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dnw7nkvxsph7718qikyp3nxlgwkx5j21x42sg8dm11y1q4w22ak"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-semver" ,rust-semver-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasmparser")
    (synopsis
     "simple event-driven library for parsing WebAssembly binary files.")
    (description
     "This package provides a simple event-driven library for parsing
@code{WebAssembly} binary files.")
    (license (list license:asl2.0))))

(define-public rust-ruzstd-0.7
  (package
    (name "rust-ruzstd")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ruzstd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13xz8iv0c96m4mrcx9zmn1rimvfqprv641a3yabsf6wvc59v48jh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-twox-hash" ,rust-twox-hash-1))))
    (home-page "https://github.com/KillingSpark/zstd-rs")
    (synopsis "decoder for the zstd compression format")
    (description
     "This package provides a decoder for the zstd compression format.")
    (license license:expat)))

(define-public rust-object-0.36
  (package
    (name "rust-object")
    (version "0.36.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "object" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "03hpcgwcsm5cfpvcmk8x0hbkvxlpw3c2pq8afrgiifx7val3y81z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-crc32fast" ,rust-crc32fast-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-ruzstd" ,rust-ruzstd-0.7)
                       ("rust-wasmparser" ,rust-wasmparser-0.214))))
    (home-page "https://github.com/gimli-rs/object")
    (synopsis "unified interface for reading and writing object file formats.")
    (description
     "This package provides a unified interface for reading and writing object file
formats.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-jobserver-0.1
  (package
    (name "rust-jobserver")
    (version "0.1.32")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "jobserver" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l2k50qmj84x9mn39ivjz76alqmx72jhm12rw33zx9xnpv5xpla8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/rust-lang/jobserver-rs")
    (synopsis "An implementation of the GNU Make jobserver for Rust.")
    (description
     "This package provides An implementation of the GNU Make jobserver for Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-cc-1
  (package
    (name "rust-cc")
    (version "1.1.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1g2w088mkhlyji5cpsw34mzppn5jcb9h2d9sga4y677sggyw7996"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-jobserver" ,rust-jobserver-0.1)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/rust-lang/cc-rs")
    (synopsis
     "build-time dependency for Cargo build scripts to assist in invoking the native
C compiler to compile native C code into a static archive to be linked into Rust
code.")
    (description
     "This package provides a build-time dependency for Cargo build scripts to assist
in invoking the native C compiler to compile native C code into a static archive
to be linked into Rust code.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasmparser-0.202
  (package
    (name "rust-wasmparser")
    (version "0.202.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wasmparser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04qljgwjv6a6nn9sx6bbz167s0dim4liphgp1sc8ngygscaqb6fn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-semver" ,rust-semver-1))))
    (home-page
     "https://github.com/bytecodealliance/wasm-tools/tree/main/crates/wasmparser")
    (synopsis
     "simple event-driven library for parsing WebAssembly binary files.")
    (description
     "This package provides a simple event-driven library for parsing
@code{WebAssembly} binary files.")
    (license (list license:asl2.0))))

(define-public rust-ruzstd-0.6
  (package
    (name "rust-ruzstd")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ruzstd" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0yygqpar2x910lnii4k5p43aj4943hlnxpczmqhsfddmxrqa8x2i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-derive-more" ,rust-derive-more-0.99)
                       ("rust-twox-hash" ,rust-twox-hash-1))))
    (home-page "https://github.com/KillingSpark/zstd-rs")
    (synopsis "decoder for the zstd compression format")
    (description
     "This package provides a decoder for the zstd compression format.")
    (license license:expat)))

(define-public rust-object-0.35
  (package
    (name "rust-object")
    (version "0.35.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "object" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pnv84mx3f3p847hfnsp4znivnwkc1x53maq459a92w42fw7mv5q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-crc32fast" ,rust-crc32fast-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-ruzstd" ,rust-ruzstd-0.6)
                       ("rust-wasmparser" ,rust-wasmparser-0.202))))
    (home-page "https://github.com/gimli-rs/object")
    (synopsis "unified interface for reading and writing object file formats.")
    (description
     "This package provides a unified interface for reading and writing object file
formats.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-memmap2-0.9
  (package
    (name "rust-memmap2")
    (version "0.9.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "memmap2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08hkmvri44j6h14lyq4yw5ipsp91a9jacgiww4bs9jm8whi18xgy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-stable-deref-trait" ,rust-stable-deref-trait-1))))
    (home-page "https://github.com/RazrFalcon/memmap2-rs")
    (synopsis "Cross-platform Rust API for memory-mapped file IO")
    (description
     "This package provides Cross-platform Rust API for memory-mapped file IO.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gimli-0.29
  (package
    (name "rust-gimli")
    (version "0.29.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gimli" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zgzprnjaawmg6zyic4f2q2hc39kdhn116qnkqpgvsasgc3x9v20"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-fallible-iterator" ,rust-fallible-iterator-0.3)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-stable-deref-trait" ,rust-stable-deref-trait-1))))
    (home-page "https://github.com/gimli-rs/gimli")
    (synopsis "library for reading and writing the DWARF debugging format.")
    (description
     "This package provides a library for reading and writing the DWARF debugging
format.")
    (license (list license:expat license:asl2.0))))

(define-public rust-addr2line-0.22
  (package
    (name "rust-addr2line")
    (version "0.22.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "addr2line" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0y66f1sa27i9kvmlh76ynk60rxfrmkba9ja8x527h32wdb206ibf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-cpp-demangle" ,rust-cpp-demangle-0.4)
                       ("rust-fallible-iterator" ,rust-fallible-iterator-0.3)
                       ("rust-gimli" ,rust-gimli-0.29)
                       ("rust-memmap2" ,rust-memmap2-0.9)
                       ("rust-object" ,rust-object-0.35)
                       ("rust-rustc-demangle" ,rust-rustc-demangle-0.1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-smallvec" ,rust-smallvec-1))))
    (home-page "https://github.com/gimli-rs/addr2line")
    (synopsis
     "cross-platform symbolication library written in Rust, using `gimli`")
    (description
     "This package provides a cross-platform symbolication library written in Rust,
using `gimli`.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-backtrace-0.3
  (package
    (name "rust-backtrace")
    (version "0.3.73")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "backtrace" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "02iffg2pkg5nc36pgml8il7f77s138hhjw9f9l56v5zqlilk5hjw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-addr2line" ,rust-addr2line-0.22)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-cpp-demangle" ,rust-cpp-demangle-0.4)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-miniz-oxide" ,rust-miniz-oxide-0.7)
                       ("rust-object" ,rust-object-0.36)
                       ("rust-rustc-demangle" ,rust-rustc-demangle-0.1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/rust-lang/backtrace-rs")
    (synopsis
     "library to acquire a stack trace (backtrace) at runtime in a Rust program.")
    (description
     "This package provides a library to acquire a stack trace (backtrace) at runtime
in a Rust program.")
    (license (list license:expat license:asl2.0))))

(define-public rust-clap-builder-4
  (package
    (name "rust-clap-builder")
    (version "4.5.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clap_builder" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16adkdf8jbxpfn4jly54xn1ngwign57vwb5zgly877sflxz7vcb4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anstream" ,rust-anstream-0.6)
                       ("rust-anstyle" ,rust-anstyle-1)
                       ("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-clap-lex" ,rust-clap-lex-0.7)
                       ("rust-strsim" ,rust-strsim-0.11)
                       ("rust-terminal-size" ,rust-terminal-size-0.3)
                       ("rust-unicase" ,rust-unicase-2)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/clap-rs/clap")
    (synopsis
     "simple to use, efficient, and full-featured Command Line Argument Parser")
    (description
     "This package provides a simple to use, efficient, and full-featured Command Line
Argument Parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-clap-4
  (package
    (name "rust-clap")
    (version "4.5.13")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "clap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1z5773cyvhb47rxflng7mi7vrkc4zw2f6xg47l7pja1l0l52dfqg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clap-builder" ,rust-clap-builder-4)
                       ("rust-clap-derive" ,rust-clap-derive-4))))
    (home-page "https://github.com/clap-rs/clap")
    (synopsis
     "simple to use, efficient, and full-featured Command Line Argument Parser")
    (description
     "This package provides a simple to use, efficient, and full-featured Command Line
Argument Parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-neocmakelsp-0.8
  (package
    (name "rust-neocmakelsp")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "neocmakelsp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "001cnm8j7dms5v0jrpv59qfppy6gvln29ibgmc5phicwq0ixb9mv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:rust ,rust-1.80
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-cli-table" ,rust-cli-table-0.4)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-ignore" ,rust-ignore-0.4)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-rust-ini" ,rust-rust-ini-0.21)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-toml" ,rust-toml-0.8)
                       ("rust-tower-lsp" ,rust-tower-lsp-0.20)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-tracing-subscriber" ,rust-tracing-subscriber-0.3)
                       ("rust-tree-sitter" ,rust-tree-sitter-0.22)
                       ("rust-tree-sitter-cmake" ,rust-tree-sitter-cmake-0.5))))
    (home-page "https://github.com/Decodetalkers/neocmakelsp")
    (synopsis "The Lsp for cmake")
    (description "This package provides The Lsp for cmake.")
    (license license:expat)))
