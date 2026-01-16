(define-module
  (roquix packages firefox)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix store)
  #:use-module (gnu packages)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages cpio)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages pkg-config)
  #:use-module (nongnu packages mozilla)
  #:use-module (roquix packages texlab))

(define-public rust-data-url-impl-std-error
  (let ((commit "0032b9e8328f1a7ce2773f71adf316542ee8ddc9")
        (revision "0"))
    (package
      (name "rust-data-url-impl-std-error")
      (version (git-version "0.1.0-a" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/filips123/rust-url")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1n01yyzv20jhcn5yd51xrm9dwcnr2lh49np449gradp3k37r0i5c"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             (let ((package-name "data-url"))
               (for-each
                (lambda (file)
                  (when (file-exists? file)
                    (delete-file-recursively file)))
                (find-files "."
                            (lambda (file _)
                              (not (regexp-exec (make-regexp (string-append "^\\.$|\\./LICENSE|" package-name)) file)))
                            #:directories? #t))
               ;; NOTE: Remove symlink of LICENSE-* because root LICENSE-* still exists.
               (for-each
                delete-file
                (find-files package-name "LICENSE"))
               (copy-recursively package-name ".")
               (delete-file-recursively package-name))
             ;; NOTE: Change version because this package is not upstream package.
             (substitute* "Cargo.toml"
               (("version = \"0.1.0\"") "version = \"0.1.0-a\""))))))
      (build-system cargo-build-system)
      (arguments
       `(#:cargo-inputs
         (("rust-matches" ,rust-matches-0.1))
         #:cargo-development-inputs
         (("rust-rustc-test" ,rust-rustc-test-0.3)
          ("rust-serde" ,rust-serde-1)
          ("rust-serde-json" ,rust-serde-json-1))))
      (home-page "https://github.com/filips123/rust-url")
      (synopsis "Processing of data: URL according to WHATWG's Fetch Standard")
      (description
       "Processing of data: URL according to WHATWG's Fetch Standard.")
      (license (list license:expat license:asl2.0)))))

(define-public rust-quoted-string-0.2
  (package
    (name "rust-quoted-string")
    (version "0.2.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quoted-string" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0rzmypcqf776qffic8ghil0il8mmkh53863cg671v51rgy3gi1lm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-quick-error" ,rust-quick-error-1))))
    (home-page "https://github.com/dac-gmbh/quoted-string")
    (synopsis
     "Specification independent utilities to handle quoted strings (in Mail, MIME types, ..)")
    (description
     "Specification independent utilities to handle quoted strings (in Mail, MIME
types, ..)")
    (license (list license:expat license:asl2.0))))

(define-public rust-parameterized-macro-1
  (package
    (name "rust-parameterized-macro")
    (version "1.0.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "parameterized-macro" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "055cgxnq23k9mm4y2bg0fx7j1ajygd0aijsjsgrdmycvvc56xvqx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/foresterre/parameterized")
    (synopsis "Attribute macro crate for parameterized tests.")
    (description "Attribute macro crate for parameterized tests.")
    (license (list license:expat license:asl2.0))))

(define-public rust-parameterized-1
  (package
    (name "rust-parameterized")
    (version "1.0.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "parameterized" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "06xikpnkr8zai5iv5d4sl5fb1gk2kh4rvbxdrcyvna8qrrxcirds"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-parameterized-macro" ,rust-parameterized-macro-1))))
    (home-page "https://github.com/foresterre/parameterized")
    (synopsis
     "Procedural macro which brings a compact parameterized testing implementation to Rust (inspired by JUnit @ParameterizedTest)")
    (description
     "Procedural macro which brings a compact parameterized testing implementation to
Rust (inspired by JUnit @@ParameterizedTest)")
    (license (list license:expat license:asl2.0))))

(define-public rust-syn-2
  (package
    (name "rust-syn")
    (version "2.0.22")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "syn" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "05j6n81lm86idf0cgv9rfpddscajyj91rlfbrmmvvsplmkkymyrf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/dtolnay/syn")
    (synopsis "Parser for Rust source code")
    (description "Parser for Rust source code")
    (license (list license:expat license:asl2.0))))

(define-public rust-structmeta-derive-0.2
  (package
    (name "rust-structmeta-derive")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "structmeta-derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "005ybz4ha874w81pg15n00p01m9hir1dpl8p0352s1wpfgzwl2x6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/frozenlib/structmeta")
    (synopsis "derive macro for structmeta crate.")
    (description "derive macro for structmeta crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-structmeta-0.2
  (package
    (name "rust-structmeta")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "structmeta" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0bcj4c2p2j091mn9ld2hbcx77flqjx65ihb9gbb5c12gal4rxbbq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-structmeta-derive" ,rust-structmeta-derive-0.2)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/frozenlib/structmeta")
    (synopsis "Parse Rust's attribute arguments by defining a struct.")
    (description "Parse Rust's attribute arguments by defining a struct.")
    (license (list license:expat license:asl2.0))))

(define-public rust-regex-syntax-0.6
  (package
    (name "rust-regex-syntax")
    (version "0.6.29")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "regex-syntax" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1qgj49vm6y3zn1hi09x91jvgkl2b1fiaq402skj83280ggfwcqpi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rust-lang/regex")
    (synopsis "A regular expression parser.")
    (description "This package provides a regular expression parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-regex-syntax-0.7
  (package
    (name "rust-regex-syntax")
    (version "0.7.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "regex-syntax" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0y4czjqxlw97j9bw5lpa18drxf8y3iv5jah3dwih6agdfq70ass3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rust-lang/regex")
    (synopsis "A regular expression parser.")
    (description "This package provides a regular expression parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-aho-corasick-1
  (package
    (name "rust-aho-corasick")
    (version "1.0.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "aho-corasick" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0has59a3571irggpk5z8c0lpnx8kdx12qf4g2x0560i2y8dwpxj3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-memchr" ,rust-memchr-2))))
    (home-page "https://github.com/BurntSushi/aho-corasick")
    (synopsis "Fast multiple substring searching.")
    (description "Fast multiple substring searching.")
    (license (list license:unlicense license:expat))))

(define-public rust-regex-1
  (package
    (name "rust-regex")
    (version "1.8.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "regex" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03rh0yfyizqxsshqvxy3cxg07yxl5rkcvj58y90ixfsmask3rayh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-1)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.7))))
    (home-page "https://github.com/rust-lang/regex")
    (synopsis
     "An implementation of regular expressions for Rust. This implementation uses
finite automata and guarantees linear time matching on all inputs.
")
    (description
     "An implementation of regular expressions for Rust.  This implementation uses
finite automata and guarantees linear time matching on all inputs.")
    (license (list license:expat license:asl2.0))))

(define-public rust-quote-1
  (package
    (name "rust-quote")
    (version "1.0.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quote" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "122lh886x0p5xh87015wbknl0dfimsjg273g00cxzn6zxb3vk6hv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "https://github.com/dtolnay/quote")
    (synopsis "Quasi-quoting macro quote!(...)")
    (description "Quasi-quoting macro quote!(...)")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-macro2-1
  (package
    (name "rust-proc-macro2")
    (version "1.0.63")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "proc-macro2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ssr3643nwfhw7yvqhibjw1k6nsnbv0lxq7mc1zcw38vjax8ydkv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/dtolnay/proc-macro2")
    (synopsis
     "A substitute implementation of the compiler's `proc_macro` API to decouple token-based libraries from the procedural macro use case.")
    (description
     "This package provides a substitute implementation of the compiler's `proc_macro`
API to decouple token-based libraries from the procedural macro use case.")
    (license (list license:expat license:asl2.0))))

(define-public rust-parse-display-derive-0.8
  (package
    (name "rust-parse-display-derive")
    (version "0.8.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "parse-display-derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "10x9pkybibc1gzwf39sk2p0myn8g7cy90gf6ddbggnynyy034l3f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-once-cell" ,rust-once-cell-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.6)
                       ("rust-structmeta" ,rust-structmeta-0.2)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/frozenlib/parse-display")
    (synopsis
     "Procedural macro to implement Display and FromStr using common settings.")
    (description
     "Procedural macro to implement Display and FromStr using common settings.")
    (license (list license:expat license:asl2.0))))

(define-public rust-parse-display-0.8
  (package
    (name "rust-parse-display")
    (version "0.8.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "parse-display" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1a33sdpiyl3a1aid5s5dvfvv9ibankzq2rhcg24km85aqb6wdjnx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-once-cell" ,rust-once-cell-1)
                       ("rust-parse-display-derive" ,rust-parse-display-derive-0.8)
                       ("rust-regex" ,rust-regex-1))))
    (home-page "https://github.com/frozenlib/parse-display")
    (synopsis
     "Procedural macro to implement Display and FromStr using common settings.")
    (description
     "Procedural macro to implement Display and FromStr using common settings.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unsafe-libyaml-0.2
  (package
    (name "rust-unsafe-libyaml")
    (version "0.2.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unsafe-libyaml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "19l0v20x83dvxbr68rqvs9hvawaqd929hia1nldfahlhamm80r8q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/dtolnay/unsafe-libyaml")
    (synopsis "libyaml transpiled to rust by c2rust")
    (description "libyaml transpiled to rust by c2rust")
    (license license:expat)))

(define-public rust-rustc-rayon-core-0.5
  (package
    (name "rust-rustc-rayon-core")
    (version "0.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustc-rayon-core" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0zqbr87x58j2g9rgm2lc0254b6yqabb41jvddw99qd8fy2m8srk7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-crossbeam-deque" ,rust-crossbeam-deque-0.8)
                       ("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8)
                       ("rust-num-cpus" ,rust-num-cpus-1))))
    (home-page "https://github.com/rust-lang/rustc-rayon")
    (synopsis "Core APIs for Rayon - fork for rustc")
    (description "Core APIs for Rayon - fork for rustc")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustc-rayon-0.5
  (package
    (name "rust-rustc-rayon")
    (version "0.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustc-rayon" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "040p2am25g3isnpsixrcrjrv70yz2lzkbq8gpv76xjipi3fam0gb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-rustc-rayon-core" ,rust-rustc-rayon-core-0.5))))
    (home-page "https://github.com/rust-lang/rustc-rayon")
    (synopsis "Simple work-stealing parallelism for Rust - fork for rustc")
    (description "Simple work-stealing parallelism for Rust - fork for rustc")
    (license (list license:expat license:asl2.0))))

(define-public rust-rkyv-derive-0.7
  (package
    (name "rust-rkyv-derive")
    (version "0.7.42")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rkyv_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "07alynj16yqlyprlwqd8av157rrywvid2dm7swbhl8swbf8npq5j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/rkyv/rkyv")
    (synopsis "Derive macro for rkyv")
    (description "Derive macro for rkyv")
    (license license:expat)))

(define-public rust-bytecheck-derive-0.6
  (package
    (name "rust-bytecheck-derive")
    (version "0.6.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bytecheck_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0qdgfqx23gbjp5scbc8fhqc5kd014bpxn8hc9i9ssd8r4rplrv57"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/djkoloski/bytecheck")
    (synopsis "Derive macro for bytecheck")
    (description "Derive macro for bytecheck")
    (license license:expat)))

(define-public rust-bytecheck-0.6
  (package
    (name "rust-bytecheck")
    (version "0.6.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bytecheck" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "09xnpjfhw36a973dpdd2mcmb93rrix539j49vkkgcqf878174qwb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytecheck-derive" ,rust-bytecheck-derive-0.6)
                       ("rust-ptr-meta" ,rust-ptr-meta-0.1)
                       ("rust-simdutf8" ,rust-simdutf8-0.1)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://github.com/djkoloski/bytecheck")
    (synopsis "Derive macro for bytecheck")
    (description "Derive macro for bytecheck")
    (license license:expat)))

(define-public rust-rkyv-0.7
  (package
    (name "rust-rkyv")
    (version "0.7.42")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rkyv" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0n2wzwnghkr2ny16c08f5szbkljfqrp3s8fnnb096f011ciwh002"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-bitvec" ,rust-bitvec-1)
                       ("rust-bytecheck" ,rust-bytecheck-0.6)
                       ("rust-hashbrown" ,rust-hashbrown-0.12)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-ptr-meta" ,rust-ptr-meta-0.1)
                       ("rust-rend" ,rust-rend-0.4)
                       ("rust-rkyv-derive" ,rust-rkyv-derive-0.7)
                       ("rust-seahash" ,rust-seahash-4)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tinyvec" ,rust-tinyvec-1)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://github.com/rkyv/rkyv")
    (synopsis "Zero-copy deserialization framework for Rust")
    (description "Zero-copy deserialization framework for Rust")
    (license license:expat)))

(define-public rust-allocator-api2-0.2
  (package
    (name "rust-allocator-api2")
    (version "0.2.15")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "allocator-api2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1sdgkqs0pyk61m4yjksl5fv8wld11s5rp7v4v3p5hhccvkw6rz2n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/zakarumych/allocator-api2")
    (synopsis "Mirror of Rust's allocator API")
    (description "Mirror of Rust's allocator API")
    (license (list license:expat license:asl2.0))))

(define-public rust-hashbrown-0.14
  (package
    (name "rust-hashbrown")
    (version "0.14.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hashbrown" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0yj3nf0w30pf30w503kgaw4sbjnh62l5cbmc7dd0mnczzywh2qic"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-allocator-api2" ,rust-allocator-api2-0.2)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-rkyv" ,rust-rkyv-0.7)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rust-lang/hashbrown")
    (synopsis "A Rust port of Google's SwissTable hash map")
    (description
     "This package provides a Rust port of Google's SwissTable hash map")
    (license (list license:expat license:asl2.0))))

(define-public rust-equivalent-1
  (package
    (name "rust-equivalent")
    (version "1.0.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "equivalent" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "18f0q7vd4awiv9bv5mda5yv8lfhpzxspiq8f2jdjqhw0bnygxgw8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/cuviper/equivalent")
    (synopsis "Traits for key comparison in maps.")
    (description "Traits for key comparison in maps.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-indexmap-2
  (package
    (name "rust-indexmap")
    (version "2.0.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "indexmap" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0pdnbvv6gnyxx2li8mks8p00fya3ynmhx3n6infpcy8a4gi7yiym"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-equivalent" ,rust-equivalent-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.14)
                       ("rust-quickcheck" ,rust-quickcheck-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-rustc-rayon" ,rust-rustc-rayon-0.5)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/bluss/indexmap")
    (synopsis "A hash table with consistent order and fast iteration.")
    (description
     "This package provides a hash table with consistent order and fast iteration.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-serde-yaml-0.9
  (package
    (name "rust-serde-yaml")
    (version "0.9.22")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_yaml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "11bxmbysjp2qrarr5glvxn310r9r7301s82kvxwzldqcqawnfbj5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-2)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-unsafe-libyaml" ,rust-unsafe-libyaml-0.2))))
    (home-page "https://github.com/dtolnay/serde-yaml")
    (synopsis "YAML data format for Serde")
    (description "YAML data format for Serde")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-xml-rs-0.6
  (package
    (name "rust-serde-xml-rs")
    (version "0.6.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde-xml-rs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "10i7dvd0c1clj4jbljd08qs8466nlymx7ma7k3ncksx1rn7affpv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-xml-rs" ,rust-xml-rs-0.8))))
    (home-page "https://github.com/RReverser/serde-xml-rs")
    (synopsis "xml-rs based deserializer for Serde (compatible with 0.9+)")
    (description "xml-rs based deserializer for Serde (compatible with 0.9+)")
    (license license:expat)))

(define-public rust-ron-0.8
  (package
    (name "rust-ron")
    (version "0.8.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ron" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1zvb2gxn4vv24swwp8a1l9fg5p960w9f9zd9ny05rd8w7c2m22ih"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/ron-rs/ron")
    (synopsis "Rusty Object Notation")
    (description "Rusty Object Notation")
    (license (list license:expat license:asl2.0))))

(define-public rust-rmp-0.8
  (package
    (name "rust-rmp")
    (version "0.8.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rmp" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17rw803xv84csxgd654g7q64kqf9zgkvhsn8as3dbmlg6mr92la4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-paste" ,rust-paste-1))))
    (home-page "https://github.com/3Hren/msgpack-rust")
    (synopsis "Pure Rust MessagePack serialization implementation")
    (description "Pure Rust MessagePack serialization implementation")
    (license license:expat)))

(define-public rust-rmp-serde-1
  (package
    (name "rust-rmp-serde")
    (version "1.1.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rmp-serde" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0glisa0pcj56dhsaqp5vkqkcqqnb2dcal8kjzf50n8p0jbhkpcf5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-rmp" ,rust-rmp-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/3Hren/msgpack-rust")
    (synopsis "Serde bindings for RMP")
    (description "Serde bindings for RMP")
    (license license:expat)))

(define-public rust-expect-test-1
  (package
    (name "rust-expect-test")
    (version "1.4.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "expect-test" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1lzqx5hqh1g4llzqby4z1d18xmrjjx63c5l0na7ycf6mmpzfmn9h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-dissimilar" ,rust-dissimilar-1)
                       ("rust-once-cell" ,rust-once-cell-1))))
    (home-page "https://github.com/rust-analyzer/expect-test")
    (synopsis "Minimalistic snapshot testing library")
    (description "Minimalistic snapshot testing library")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-with-macros-2
  (package
    (name "rust-serde-with-macros")
    (version "2.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_with_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0pikbhf7fk5c5fa5c2nf67ny7l8mahpk2dy5jxb0jpy0yc4n15m1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-darling" ,rust-darling-0.14)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/jonasbb/serde_with/")
    (synopsis "proc-macro library for serde_with")
    (description "proc-macro library for serde_with")
    (license (list license:expat license:asl2.0))))

(define-public rust-doc-comment-0.3
  (package
    (name "rust-doc-comment")
    (version "0.3.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "doc-comment" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "043sprsf3wl926zmck1bm7gw0jq50mb76lkpk49vasfr6ax1p97y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/GuillaumeGomez/doc-comment")
    (synopsis "Macro to generate doc comments")
    (description "Macro to generate doc comments")
    (license license:expat)))

(define-public rust-serde-with-2
  (package
    (name "rust-serde-with")
    (version "2.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde-with" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "174075pyhd9wkk5xm1xn5lav7129rbv3lgf9yhd3ipj6j4bh9n9h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-doc-comment" ,rust-doc-comment-0.3)
                       ("rust-hex" ,rust-hex-0.4)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-with-macros" ,rust-serde-with-macros-2)
                       ("rust-time" ,rust-time-0.3))
       #:cargo-development-inputs (("rust-expect-test" ,rust-expect-test-1)
                                   ("rust-fnv" ,rust-fnv-1)
                                   ("rust-glob" ,rust-glob-0.3)
                                   ("rust-mime" ,rust-mime-0.3)
                                   ("rust-pretty-assertions" ,rust-pretty-assertions-1)
                                   ("rust-regex" ,rust-regex-1)
                                   ("rust-rmp-serde" ,rust-rmp-serde-1)
                                   ("rust-ron" ,rust-ron-0.8)
                                   ("rust-rustversion" ,rust-rustversion-1)
                                   ("rust-serde-xml-rs" ,rust-serde-xml-rs-0.6)
                                   ("rust-serde-json" ,rust-serde-json-1)
                                   ("rust-serde-test" ,rust-serde-test-1)
                                   ("rust-serde-yaml" ,rust-serde-yaml-0.9)
                                   ("rust-version-sync" ,rust-version-sync-0.9))))
    (home-page "https://github.com/jonasbb/serde_with")
    (synopsis "Custom de/serialization functions for Rust's serde")
    (description "Custom de/serialization functions for Rust's serde")
    (license (list license:expat license:asl2.0))))

(define-public rust-cint-0.3
  (package
    (name "rust-cint")
    (version "0.3.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "cint" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "16l9glvaxshbp3awcga3s8cdfv00gb1n2s7ixzxxjwc5yz6qf3ks"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck" ,rust-bytemuck-1))))
    (home-page "https://github.com/termhn/cint")
    (synopsis
     "A lean, minimal, and stable set of types for color interoperation between crates in Rust.")
    (description
     "This package provides a lean, minimal, and stable set of types for color
interoperation between crates in Rust.")
    (license (list license:expat license:asl2.0 license:zlib))))

(define-public rust-csscolorparser-0.6
  (package
    (name "rust-csscolorparser")
    (version "0.6.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "csscolorparser" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1gxh11hajx96mf5sd0az6mfsxdryfqvcfcphny3yfbfscqq7sapb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-cint" ,rust-cint-0.3)
                       ("rust-lab" ,rust-lab-0.11)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-rgb" ,rust-rgb-0.8)
                       ("rust-serde" ,rust-serde-1))
       #:cargo-development-inputs (("rust-serde-test" ,rust-serde-test-1))))
    (home-page "https://github.com/mazznoer/csscolorparser-rs")
    (synopsis "CSS color parser library")
    (description "CSS color parser library")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-derive-internals-0.26
  (package
    (name "rust-serde-derive-internals")
    (version "0.26.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_derive_internals" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0g2zdr6s8i0r29yy7pdl6ahimq8w6ck70hvrciiry2ljwwlq5gw5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://serde.rs")
    (synopsis "AST representation used by Serde derive macros. Unstable.")
    (description "AST representation used by Serde derive macros.  Unstable.")
    (license (list license:expat license:asl2.0))))

(define-public rust-schemars-derive-0.8
  (package
    (name "rust-schemars-derive")
    (version "0.8.12")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "schemars_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0z2yahra4mbxf29zz02bg5r9b5bz1jcm56drdpmqshwpn7ka378h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-serde-derive-internals" ,rust-serde-derive-internals-0.26)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://graham.cool/schemars/")
    (synopsis "Macros for #[derive(JsonSchema)], for use with schemars")
    (description "Macros for #[derive(JsonSchema)], for use with schemars")
    (license license:expat)))

(define-public rust-schemars-0.8.12
  (package
    (name "rust-schemars")
    (version "0.8.12")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "schemars" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kz41p88zdrh0rmabldi8qkpbgjz3kdx9ny5zp1z1r92hql17ih2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.5)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-bigdecimal" ,rust-bigdecimal-0.3)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-dyn-clone" ,rust-dyn-clone-1)
                       ("rust-either" ,rust-either-1)
                       ("rust-enumset" ,rust-enumset-1)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-rust-decimal" ,rust-rust-decimal-1)
                       ("rust-schemars-derive" ,rust-schemars-derive-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-smol-str" ,rust-smol-str-0.1)
                       ("rust-url" ,rust-url-2)
                       ("rust-uuid" ,rust-uuid-0.8)
                       ("rust-uuid" ,rust-uuid-1))
       #:cargo-development-inputs (("rust-pretty-assertions" ,rust-pretty-assertions-1)
                                   ("rust-trybuild" ,rust-trybuild-1))))
    (home-page "https://graham.cool/schemars/")
    (synopsis "Generate JSON Schemas from Rust code")
    (description "Generate JSON Schemas from Rust code")
    (license license:expat)))

(define-public rust-configparser-3
  (package
    (name "rust-configparser")
    (version "3.0.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "configparser" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ypq3phwrlx2c7agdj1rlivkhsk9k795jb30j58azvw7lp8xjn2l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-indexmap" ,rust-indexmap-1))))
    (home-page "https://github.com/QEDK/configparser-rs")
    (synopsis
     "A simple configuration parsing utility with no dependencies that allows you to parse INI and ini-style syntax. You can use this to write Rust programs which can be customized by end users easily.")
    (description
     "This package provides a simple configuration parsing utility with no
dependencies that allows you to parse INI and ini-style syntax.  You can use
this to write Rust programs which can be customized by end users easily.")
    (license (list license:expat license:lgpl3+))))

(define-public rust-konst-proc-macros-0.2
  (package
    (name "rust-konst-proc-macros")
    (version "0.2.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "konst_proc_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0dxp8mdh3q9d044ql203way4fgbc50n3j3pi2j1x2snlcaa10klq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis "Implementation detail of the `konst` crate")
    (description "Implementation detail of the `konst` crate")
    (license license:zlib)))

(define-public rust-konst-macro-rules-0.2
  (package
    (name "rust-konst-macro-rules")
    (version "0.2.19")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "konst_macro_rules" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0dswja0dqcww4x3fwjnirc0azv2n6cazn8yv0kddksd8awzkz4x4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis "Implementation detail of the konst crate")
    (description "Implementation detail of the konst crate")
    (license license:zlib)))

(define-public rust-konst-0.2
  (package
    (name "rust-konst")
    (version "0.2.19")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "konst" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1x3lxxk9vjaiiaabngv7ki2bv9xi36gnqzjzi0s8qfs8wq9hw3rk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-konst-macro-rules" ,rust-konst-macro-rules-0.2)
                       ("rust-konst-proc-macros" ,rust-konst-proc-macros-0.2)
                       ("rust-trybuild" ,rust-trybuild-1))))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis
     "Const equivalents of std functions, compile-time comparison, and parsing")
    (description
     "Const equivalents of std functions, compile-time comparison, and parsing")
    (license license:zlib)))

(define-public rust-const-format-proc-macros-0.2
  (package
    (name "rust-const-format-proc-macros")
    (version "0.2.31")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "const_format_proc_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xibiffpmwvlina6amybiz66g5zgs5r5gk9jrywlr1sa377bc9p0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://github.com/rodrimati1992/const_format_crates/")
    (synopsis "Implementation detail of the `const_format` crate")
    (description "Implementation detail of the `const_format` crate")
    (license license:zlib)))

(define-public rust-const-format-0.2
  (package
    (name "rust-const-format")
    (version "0.2.31")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "const-format" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0j7zs1aar3daic7yy18sg34a518f5zzimn3q8fd1yww5lb3yz469"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-const-format-proc-macros" ,rust-const-format-proc-macros-0.2)
                       ("rust-konst" ,rust-konst-0.2))
       #:cargo-development-inputs (("rust-arrayvec" ,rust-arrayvec-0.5)
                                   ("rust-fastrand" ,rust-fastrand-1))))
    (home-page "https://github.com/rodrimati1992/const_format_crates/")
    (synopsis "Compile-time string formatting")
    (description "Compile-time string formatting")
    (license license:zlib)))

(define-public rust-fs-extra-1.3
  (package
    (name "rust-fs-extra")
    (version "1.3.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "fs-extra" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "075i25z70j2mz9r7i9p9r521y8xdj81q7skslyb7zhqnnw33fw22"))))
    (build-system cargo-build-system)
    (home-page "https://github.com/webdesus/fs_extra")
    (synopsis
     "Expanding std::fs and std::io. Recursively copy folders with information about process and much more.")
    (description
     "Expanding std::fs and std::io.  Recursively copy folders with information about
process and much more.")
    (license license:expat)))

(define-public rust-filedescriptor-0.8
  (package
    (name "rust-filedescriptor")
    (version "0.8.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "filedescriptor" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0vplyh0cw35kzq7smmp2ablq0zsknk5rkvvrywqsqfrchmjxk6bi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/wez/wezterm")
    (synopsis "More ergonomic wrappers around RawFd and RawHandle")
    (description "More ergonomic wrappers around RawFd and RawHandle")
    (license license:expat)))

(define-public rust-gag-1
  (package
    (name "rust-gag")
    (version "1.0.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gag" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0wjr02svx7jir7b7r69lpfh3assasmqsz4vivzzzpsb677hvw4x7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-filedescriptor" ,rust-filedescriptor-0.8)
                       ("rust-tempfile" ,rust-tempfile-3))
       #:cargo-development-inputs (("rust-dirs" ,rust-dirs-3)
                                   ("rust-lazy-static" ,rust-lazy-static-1))))
    (home-page "https://github.com/Stebalien/gag-rs")
    (synopsis
     "Gag, redirect, or hold stdout/stderr output. Currently only *nix operating systems are supported.")
    (description
     "Gag, redirect, or hold stdout/stderr output.  Currently only *nix operating
systems are supported.")
    (license license:expat)))

(define-public rust-xmlwriter-0.1
  (package
    (name "rust-xmlwriter")
    (version "0.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "xmlwriter" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1fg0ldmkgiis6hnxpi1c9gy7v23y0lpi824bp8yp12fi3r82lypc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/xmlwriter")
    (synopsis "A simple, streaming XML writer.")
    (description "This package provides a simple, streaming XML writer.")
    (license license:expat)))

(define-public rust-unicode-vo-0.1
  (package
    (name "rust-unicode-vo")
    (version "0.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-vo" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "151sha088v9jyfvbg5164xh4dk72g53b82xm4zzbf5dlagzqdlxi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/unicode-vo")
    (synopsis "Unicode vertical orientation detection")
    (description "Unicode vertical orientation detection")
    (license (list license:expat license:asl2.0))))

(define-public rust-simplecss-0.2
  (package
    (name "rust-simplecss")
    (version "0.2.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "simplecss" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17g8q1z9xrkd27ic9nrfirj6in4rai6l9ws0kxz45n97573ff6x1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4))))
    (home-page "https://github.com/RazrFalcon/simplecss")
    (synopsis "A simple CSS 2 parser and selector.")
    (description "This package provides a simple CSS 2 parser and selector.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-script-0.5
  (package
    (name "rust-unicode-script")
    (version "0.5.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-script" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1k4fgc2lhn5x34w9xp2gqvxxqasds62qc9a7rbadzmmyw5ap50bx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-rustc-std-workspace-std" ,rust-rustc-std-workspace-std-1))))
    (home-page "https://github.com/unicode-rs/unicode-script")
    (synopsis
     "This crate exposes the Unicode `Script` and `Script_Extension` properties from [UAX #24](http://www.unicode.org/reports/tr24/)
")
    (description
     "This crate exposes the Unicode `Script` and `Script_Extension` properties from
[UAX #24](http://www.unicode.org/reports/tr24/)")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-general-category-0.6
  (package
    (name "rust-unicode-general-category")
    (version "0.6.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-general-category" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1rv9715c94gfl0hzy4f2a9lw7i499756bq2968vqwhr1sb0wi092"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/yeslogic/unicode-general-category")
    (synopsis "Fast lookup of the Unicode General Category property for char")
    (description
     "Fast lookup of the Unicode General Category property for char")
    (license license:asl2.0)))

(define-public rust-unicode-ccc-0.1
  (package
    (name "rust-unicode-ccc")
    (version "0.1.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-ccc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1wbwny92wzmck2cix5h3r97h9z57x9831kadrs6jdy24lvpj09fc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/unicode-ccc")
    (synopsis "Unicode Canonical Combining Class detection")
    (description "Unicode Canonical Combining Class detection")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-bidi-mirroring-0.1
  (package
    (name "rust-unicode-bidi-mirroring")
    (version "0.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-bidi-mirroring" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "150navn2n6barkzchv96n877i17m1754nzmy1282zmcjzdh25lan"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/unicode-bidi-mirroring")
    (synopsis "Unicode Bidi Mirroring propery detection")
    (description "Unicode Bidi Mirroring propery detection")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustybuzz-0.6
  (package
    (name "rust-rustybuzz")
    (version "0.6.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustybuzz" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12g40lnfsjjygv30grsdczz9k06n1gd1p9jm4d0ja1lhyvn397mb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-libm" ,rust-libm-0.2)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-ttf-parser" ,rust-ttf-parser-0.17)
                       ("rust-unicode-bidi-mirroring" ,rust-unicode-bidi-mirroring-0.1)
                       ("rust-unicode-ccc" ,rust-unicode-ccc-0.1)
                       ("rust-unicode-general-category" ,rust-unicode-general-category-0.6)
                       ("rust-unicode-script" ,rust-unicode-script-0.5))))
    (home-page "https://github.com/RazrFalcon/rustybuzz")
    (synopsis "A complete harfbuzz shaping algorithm port to Rust.")
    (description
     "This package provides a complete harfbuzz shaping algorithm port to Rust.")
    (license license:expat)))

(define-public rust-roxmltree-0.15
  (package
    (name "rust-roxmltree")
    (version "0.15.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "roxmltree" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12p4vyg6c906pclhpgq8h21x1acza3dl5wk1gqp156qj3a1yk7bb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-xmlparser" ,rust-xmlparser-0.13))))
    (home-page "https://github.com/RazrFalcon/roxmltree")
    (synopsis "Represent an XML as a read-only tree.")
    (description "Represent an XML as a read-only tree.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rctree-0.5
  (package
    (name "rust-rctree")
    (version "0.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rctree" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kvzahkwriawhjjb08ai7rfi77px7rpx5h83hjcx6dccyxzf4hiv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/rctree")
    (synopsis "A 'DOM-like' tree implemented using reference counting")
    (description
     "This package provides a DOM-like tree implemented using reference counting")
    (license license:expat)))

(define-public rust-kurbo-0.8
  (package
    (name "rust-kurbo")
    (version "0.8.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "kurbo" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0jgl678sygzs93lz6dr8qnpqhp24k01ay6662wxqgyqw4xnpflvs"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-mint" ,rust-mint-0.5)
                       ("rust-schemars" ,rust-schemars-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/linebender/kurbo")
    (synopsis "A 2D curves library")
    (description "This package provides a 2D curves library")
    (license (list license:expat license:asl2.0))))

(define-public rust-imagesize-0.10
  (package
    (name "rust-imagesize")
    (version "0.10.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "imagesize" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0lfrrjqk3pqjk6cyr051fbpg7cc1afaj5mlpr91w1zpvj8gdl6fz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/Roughsketch/imagesize")
    (synopsis
     "Quick probing of image dimensions without loading the entire file.")
    (description
     "Quick probing of image dimensions without loading the entire file.")
    (license license:expat)))

(define-public rust-ttf-parser-0.17
  (package
    (name "rust-ttf-parser")
    (version "0.17.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ttf-parser" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1zrbcjmyz3280wlbdbxskz0gd25lxizjzkcmq50xzdns8kx14n1p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/ttf-parser")
    (synopsis "A high-level, safe, zero-allocation TrueType font parser.")
    (description
     "This package provides a high-level, safe, zero-allocation TrueType font parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-xmlparser-0.13
  (package
    (name "rust-xmlparser")
    (version "0.13.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "xmlparser" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1z8kkbbhq5mg8k02szi8cvivrfv88wajky4p182c84paz5dwf9ad"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/xmlparser")
    (synopsis "Pull-based, zero-allocation XML parser.")
    (description "Pull-based, zero-allocation XML parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-roxmltree-0.18
  (package
    (name "rust-roxmltree")
    (version "0.18.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "roxmltree" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1n5ikvn00ciqkkr4hnch5ws1k3gfj8z50j3alv6wdf5nayj9bxfq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-xmlparser" ,rust-xmlparser-0.13))))
    (home-page "https://github.com/RazrFalcon/roxmltree")
    (synopsis "Represent an XML as a read-only tree.")
    (description "Represent an XML as a read-only tree.")
    (license (list license:expat license:asl2.0))))

(define-public rust-fontconfig-parser-0.5
  (package
    (name "rust-fontconfig-parser")
    (version "0.5.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "fontconfig-parser" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ak7ank5p2q0ky8pa1c9rpfrfizs1ip8pavnp3f6c4vnc8ky3cja"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-roxmltree" ,rust-roxmltree-0.18)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Riey/fontconfig-parser")
    (synopsis "fontconfig file parser in pure Rust")
    (description "fontconfig file parser in pure Rust")
    (license license:expat)))

(define-public rust-fontdb-0.10
  (package
    (name "rust-fontdb")
    (version "0.10.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "fontdb" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1r8v0w0s52a4jnkal63dxkkxcxyi78ihhg9byhh6m1rv7wmpacc1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fontconfig-parser" ,rust-fontconfig-parser-0.5)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memmap2" ,rust-memmap2-0.5)
                       ("rust-ttf-parser" ,rust-ttf-parser-0.17))))
    (home-page "https://github.com/RazrFalcon/fontdb")
    (synopsis "A simple, in-memory font database with CSS-like queries.")
    (description
     "This package provides a simple, in-memory font database with CSS-like queries.")
    (license license:expat)))

(define-public rust-data-url-0.2
  (package
    (name "rust-data-url")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "data-url" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "19828d6jby17ghi7vr0zia9sy3hlvvjbngrcsllmfh2zfg1kjx4d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/servo/rust-url")
    (synopsis "Processing of data: URL according to WHATWGâs Fetch Standard")
    (description
     "Processing of data: URL according to WHATWGâs Fetch Standard")
    (license (list license:expat license:asl2.0))))

(define-public rust-usvg-0.27
  (package
    (name "rust-usvg")
    (version "0.27.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "usvg" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ax86ak1zdj65lz83sl02kplc6a90h5ggjfm7xvv3apbp8wi9whq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.13)
                       ("rust-data-url" ,rust-data-url-0.2)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-fontdb" ,rust-fontdb-0.10)
                       ("rust-imagesize" ,rust-imagesize-0.10)
                       ("rust-kurbo" ,rust-kurbo-0.8)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-pico-args" ,rust-pico-args-0.5)
                       ("rust-rctree" ,rust-rctree-0.5)
                       ("rust-roxmltree" ,rust-roxmltree-0.15)
                       ("rust-rustybuzz" ,rust-rustybuzz-0.6)
                       ("rust-simplecss" ,rust-simplecss-0.2)
                       ("rust-siphasher" ,rust-siphasher-0.3)
                       ("rust-strict-num" ,rust-strict-num-0.1)
                       ("rust-svgtypes" ,rust-svgtypes-0.8)
                       ("rust-unicode-bidi" ,rust-unicode-bidi-0.3)
                       ("rust-unicode-script" ,rust-unicode-script-0.5)
                       ("rust-unicode-vo" ,rust-unicode-vo-0.1)
                       ("rust-xmlwriter" ,rust-xmlwriter-0.1))))
    (home-page "https://github.com/RazrFalcon/resvg")
    (synopsis "An SVG simplification library.")
    (description "An SVG simplification library.")
    (license license:mpl2.0)))

(define-public rust-svgtypes-0.8
  (package
    (name "rust-svgtypes")
    (version "0.8.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "svgtypes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0r2mjyrsyrczd05hycw0ww03nqv4hyqsd67qajxpcsmc5f55x5r2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-siphasher" ,rust-siphasher-0.3))))
    (home-page "https://github.com/RazrFalcon/svgtypes")
    (synopsis "SVG types parser.")
    (description "SVG types parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-svgfilters-0.4
  (package
    (name "rust-svgfilters")
    (version "0.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "svgfilters" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1kjbl0khhq548ciw2lnmkk3w2q6ncda6yzgkg7qjvp2zq7mvr6k3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-float-cmp" ,rust-float-cmp-0.9)
                       ("rust-rgb" ,rust-rgb-0.8))))
    (home-page "https://github.com/RazrFalcon/resvg/tree/master/svgfilters")
    (synopsis "Implementation of various SVG filters.")
    (description "Implementation of various SVG filters.")
    (license license:mpl2.0)))

(define-public rust-png-0.17
  (package
    (name "rust-png")
    (version "0.17.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "png" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "077hkp7az7w1hhlvibw03g4xcf9644a66l7fkhhgy9pcji67y3lg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-crc32fast" ,rust-crc32fast-1)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-miniz-oxide" ,rust-miniz-oxide-0.5))))
    (home-page "https://github.com/image-rs/image-png.git")
    (synopsis "PNG decoding and encoding library in pure Rust")
    (description "PNG decoding and encoding library in pure Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-pico-args-0.5
  (package
    (name "rust-pico-args")
    (version "0.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pico-args" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "05d30pvxd6zlnkg2i3ilr5a70v3f3z2in18m67z25vinmykngqav"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/pico-args")
    (synopsis "An ultra simple CLI arguments parser.")
    (description "An ultra simple CLI arguments parser.")
    (license license:expat)))

(define-public rust-resvg-0.27
  (package
    (name "rust-resvg")
    (version "0.27.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "resvg" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0jb8w7h8n6ffyzjkgnhff71dgxsr1ycf7c8vdxqbgh171b334s45"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-gif" ,rust-gif-0.11)
                       ("rust-jpeg-decoder" ,rust-jpeg-decoder-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-pico-args" ,rust-pico-args-0.5)
                       ("rust-png" ,rust-png-0.17)
                       ("rust-rgb" ,rust-rgb-0.8)
                       ("rust-svgfilters" ,rust-svgfilters-0.4)
                       ("rust-svgtypes" ,rust-svgtypes-0.8)
                       ("rust-tiny-skia" ,rust-tiny-skia-0.8)
                       ("rust-usvg" ,rust-usvg-0.27))
       #:cargo-development-inputs (("rust-once-cell" ,rust-once-cell-1))))
    (home-page "https://github.com/RazrFalcon/resvg")
    (synopsis "An SVG rendering library.")
    (description "An SVG rendering library.")
    (license license:mpl2.0)))

(define-public rust-tiny-skia-path-0.10
  (package
    (name "rust-tiny-skia-path")
    (version "0.10.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tiny-skia-path" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0718wy4s962wgwz2x2j08w6qr3m6mvm5c98srrx6ihlsr0sslq1g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayref" ,rust-arrayref-0.3)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-libm" ,rust-libm-0.2)
                       ("rust-strict-num" ,rust-strict-num-0.1))))
    (home-page "https://github.com/RazrFalcon/tiny-skia/tree/master/path")
    (synopsis "A tiny-skia Bezier path implementation")
    (description
     "This package provides a tiny-skia Bezier path implementation")
    (license license:bsd-3)))

(define-public rust-tiny-skia-0.10
  (package
    (name "rust-tiny-skia")
    (version "0.10.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tiny-skia" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1g1pdyf962a16bmv8m6xmz9qdpn6lz64qy8c97jw79azjjc1gcbx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayref" ,rust-arrayref-0.3)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-png" ,rust-png-0.17)
                       ("rust-tiny-skia-path" ,rust-tiny-skia-path-0.10))))
    (home-page "https://github.com/RazrFalcon/tiny-skia")
    (synopsis "A tiny Skia subset ported to Rust.")
    (description "This package provides a tiny Skia subset ported to Rust.")
    (license license:bsd-3)))

(define-public rust-kurbo-0.9
  (package
    (name "rust-kurbo")
    (version "0.9.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "kurbo" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "16w4k313z8smic4zifpwnxk8alh17dncgj2r40p0ql6rdivsb1dx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-libm" ,rust-libm-0.2)
                       ("rust-mint" ,rust-mint-0.5)
                       ("rust-schemars" ,rust-schemars-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/linebender/kurbo")
    (synopsis "A 2D curves library")
    (description "This package provides a 2D curves library")
    (license (list license:expat license:asl2.0))))

(define-public rust-svgtypes-0.11
  (package
    (name "rust-svgtypes")
    (version "0.11.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "svgtypes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "19q2xxy8d3sl7406jy8kd4inklp2v62y667sq1l7y9zkww8hcjzd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-kurbo" ,rust-kurbo-0.9)
                       ("rust-siphasher" ,rust-siphasher-0.3))))
    (home-page "https://github.com/RazrFalcon/svgtypes")
    (synopsis "SVG types parser.")
    (description "SVG types parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-pico-args-0.5
  (package
    (name "rust-pico-args")
    (version "0.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pico-args" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "05d30pvxd6zlnkg2i3ilr5a70v3f3z2in18m67z25vinmykngqav"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/pico-args")
    (synopsis "An ultra simple CLI arguments parser.")
    (description "An ultra simple CLI arguments parser.")
    (license license:expat)))

(define-public rust-gif-0.12
  (package
    (name "rust-gif")
    (version "0.12.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "gif" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ibhjyrslfv9qm400gp4hd50v9ibva01j4ab9bwiq1aycy9jayc0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-color-quant" ,rust-color-quant-1)
                       ("rust-weezl" ,rust-weezl-0.1))))
    (home-page "https://github.com/image-rs/image-gif")
    (synopsis "GIF de- and encoder")
    (description "GIF de- and encoder")
    (license (list license:expat license:asl2.0))))

(define-public rust-resvg-0.35
  (package
    (name "rust-resvg")
    (version "0.35.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "resvg" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1w9qwf5h0g430p0mq68f5vhv861h59f2hzzags15djlfqd3lymdn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-gif" ,rust-gif-0.12)
                       ("rust-jpeg-decoder" ,rust-jpeg-decoder-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-pico-args" ,rust-pico-args-0.5)
                       ("rust-png" ,rust-png-0.17)
                       ("rust-rgb" ,rust-rgb-0.8)
                       ("rust-svgtypes" ,rust-svgtypes-0.11)
                       ("rust-tiny-skia" ,rust-tiny-skia-0.10)
                       ("rust-usvg" ,rust-usvg-0.35))
       #:cargo-development-inputs (("rust-once-cell" ,rust-once-cell-1))))
    (home-page "https://github.com/RazrFalcon/resvg")
    (synopsis "An SVG rendering library.")
    (description "An SVG rendering library.")
    (license license:mpl2.0)))

(define-public rust-simplelog-0.12
  (package
    (name "rust-simplelog")
    (version "0.12.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "simplelog" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "11m7f2djih4413fdjk9lkkhwxq7lsqf86z00bd4xsx6ym82gzps8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-ansi-term" ,rust-ansi-term-0.12)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-paris" ,rust-paris-1)
                       ("rust-termcolor" ,rust-termcolor-1)
                       ("rust-time" ,rust-time-0.3))))
    (home-page "https://github.com/drakulix/simplelog.rs")
    (synopsis "A simple and easy-to-use logging facility for Rust's log crate")
    (description
     "This package provides a simple and easy-to-use logging facility for Rust's log
crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-linux-raw-sys-0.3
  (package
    (name "rust-linux-raw-sys")
    (version "0.3.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "linux-raw-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "068mbigb3frrxvbi5g61lx25kksy98f2qgkvc4xg8zxznwp98lzg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/sunfishcode/linux-raw-sys")
    (synopsis "Generated bindings for Linux's userspace API")
    (description "Generated bindings for Linux's userspace API")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-libc-0.2
  (package
    (name "rust-libc")
    (version "0.2.147")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1cwv2lkzk3p5lby79fm42qhsh29lvbqwayhjjkq1s746xaq8yrml"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/rust-lang/libc")
    (synopsis "Raw FFI bindings to platform libraries like libc.
")
    (description "Raw FFI bindings to platform libraries like libc.")
    (license (list license:expat license:asl2.0))))

(define-public rust-hermit-abi-0.3
  (package
    (name "rust-hermit-abi")
    (version "0.3.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hermit-abi" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "11j2v3q58kmi5mhjvh6hfrb7il2yzg7gmdf5lpwnwwv6qj04im7y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/hermitcore/rusty-hermit")
    (synopsis "Hermit system calls definitions.")
    (description "Hermit system calls definitions.")
    (license (list license:expat license:asl2.0))))

(define-public rust-io-lifetimes-1
  (package
    (name "rust-io-lifetimes")
    (version "1.0.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "io-lifetimes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1hph5lz4wd3drnn6saakwxr497liznpfnv70via6s0v8x6pbkrza"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-fs-err" ,rust-fs-err-2)
                       ("rust-hermit-abi" ,rust-hermit-abi-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-os-pipe" ,rust-os-pipe-1)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/sunfishcode/io-lifetimes")
    (synopsis "A low-level I/O ownership and borrowing library")
    (description
     "This package provides a low-level I/O ownership and borrowing library")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-windows-x86-64-msvc-0.48
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12ipr1knzj2rwjygyllfi5mkd0ihnbi3r61gag5n2jgyk5bmyl8s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnullvm-0.48
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_gnullvm" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0lxryz3ysx0145bf3i38jkr7f9nxiym8p3syklp8f20yyk0xp5kq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnu-0.48
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_gnu" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1cblz5m6a8q6ha09bz4lz233dnq5sw2hpra06k9cna3n3xk8laya"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-msvc-0.48
  (package
    (name "rust-windows-i686-msvc")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_i686_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "004fkyqv3if178xx9ksqc4qqv8sz8n72mpczsr2vy8ffckiwchj5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-gnu-0.48
  (package
    (name "rust-windows-i686-gnu")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_i686_gnu" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0hd2v9kp8fss0rzl83wzhw0s5z8q1b4875m6s1phv0yvlxi1jak2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-msvc-0.48
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_aarch64_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1wvwipchhywcjaw73h998vzachf668fpqccbhrxzrz5xszh2gvxj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-gnullvm-0.48
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_aarch64_gnullvm" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1g71yxi61c410pwzq05ld7si4p9hyx6lf5fkw21sinvr3cp5gbli"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-targets-0.48
  (package
    (name "rust-windows-targets")
    (version "0.48.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-targets" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0pz9ad4mpp06h80hkmzlib78b5r9db7isycy1gr9j17pj1sb3m05"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-aarch64-gnullvm" ,rust-windows-aarch64-gnullvm-0.48)
                       ("rust-windows-aarch64-msvc" ,rust-windows-aarch64-msvc-0.48)
                       ("rust-windows-i686-gnu" ,rust-windows-i686-gnu-0.48)
                       ("rust-windows-i686-msvc" ,rust-windows-i686-msvc-0.48)
                       ("rust-windows-x86-64-gnu" ,rust-windows-x86-64-gnu-0.48)
                       ("rust-windows-x86-64-gnullvm" ,rust-windows-x86-64-gnullvm-0.48)
                       ("rust-windows-x86-64-msvc" ,rust-windows-x86-64-msvc-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import libs for Windows")
    (description "Import libs for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-sys-0.48
  (package
    (name "rust-windows-sys")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1aan23v5gs7gya1lc46hqn9mdh8yph3fhxmhxlw36pn6pqc28zb7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-errno-0.3
  (package
    (name "rust-errno")
    (version "0.3.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "errno" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0fp7qy6fwagrnmi45msqnl01vksqwdb2qbbv60n9cz7rf0xfrksb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-errno-dragonfly" ,rust-errno-dragonfly-0.1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/lambda-fairy/rust-errno")
    (synopsis "Cross-platform interface to the `errno` variable.")
    (description "Cross-platform interface to the `errno` variable.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustix-0.37
  (package
    (name "rust-rustix")
    (version "0.37.20")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustix" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1h5j9d3rnz06rq56c9p1hkddzixipiqjg39i3xnnll5a0hfqjvmr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-errno" ,rust-errno-0.3)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/bytecodealliance/rustix")
    (synopsis "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (description
     "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-tempfile-3.4
  (package
    (name "rust-tempfile")
    (version "3.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tempfile" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "158y3iq92s7pb7pwp7d7v0y6k79mcicfrs824jclndfd3apgf65g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-fastrand" ,rust-fastrand-1)
                       ("rust-redox-syscall" ,rust-redox-syscall-0.2)
                       ("rust-rustix" ,rust-rustix-0.36)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))
       #:cargo-development-inputs (("rust-doc-comment" ,rust-doc-comment-0.3))))
    (home-page "https://stebalien.com/projects/tempfile-rs/")
    (synopsis "A library for managing temporary files and directories.")
    (description
     "This package provides a library for managing temporary files and directories.")
    (license (list license:expat license:asl2.0))))

(define-public rust-ulid-1
  (package
    (name "rust-ulid")
    (version "1.0.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ulid" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1zblm4xff0pim9yxd1r3c69kb8lyaq5722bkq9nbdr84kfkam8qk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-uuid" ,rust-uuid-1))
       #:cargo-development-inputs (("rust-bencher" ,rust-bencher-0.1))))
    (home-page "https://github.com/dylanhart/ulid-rs")
    (synopsis
     "a Universally Unique Lexicographically Sortable Identifier implementation")
    (description
     "a Universally Unique Lexicographically Sortable Identifier implementation")
    (license license:expat)))

(define-public rust-urlencoding-2
  (package
    (name "rust-urlencoding")
    (version "2.1.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "urlencoding" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1agfwfzw66krnpqjiv4mhjqq1fcqgwdzikd7x9v835inz4kp9nz8"))))
    (build-system cargo-build-system)
    (home-page "https://lib.rs/urlencoding")
    (synopsis "A Rust library for doing URL percentage encoding.")
    (description
     "This package provides a Rust library for doing URL percentage encoding.")
    (license license:expat)))

(define-public rust-phf-shared-0.11
  (package
    (name "rust-phf-shared")
    (version "0.11.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf_shared" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0azphb0a330ypqx3qvyffal5saqnks0xvl8rj73jlk3qxxgbkz4h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-siphasher" ,rust-siphasher-0.3)
                       ("rust-uncased" ,rust-uncased-0.9)
                       ("rust-unicase" ,rust-unicase-2))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "Support code shared by PHF libraries")
    (description "Support code shared by PHF libraries")
    (license license:expat)))

(define-public rust-phf-macros-0.11
  (package
    (name "rust-phf-macros")
    (version "0.11.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0js61lc0bhzzrbd9vhpcqp11vvwckdkz3g7k95z5h1k651p68i1l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-phf-generator" ,rust-phf-generator-0.11)
                       ("rust-phf-shared" ,rust-phf-shared-0.11)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-unicase" ,rust-unicase-2))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "Macros to generate types in the phf crate")
    (description "Macros to generate types in the phf crate")
    (license license:expat)))

(define-public rust-phf-0.11
  (package
    (name "rust-phf")
    (version "0.11.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1p03rsw66l7naqhpgr1a34r9yzi1gv9jh16g3fsk6wrwyfwdiqmd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-phf-macros" ,rust-phf-macros-0.11)
                       ("rust-phf-shared" ,rust-phf-shared-0.11)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "Runtime support for perfect hash function data structures")
    (description "Runtime support for perfect hash function data structures")
    (license license:expat)))

(define-public rust-ttf-parser-0.17
  (package
    (name "rust-ttf-parser")
    (version "0.17.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ttf-parser" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1zrbcjmyz3280wlbdbxskz0gd25lxizjzkcmq50xzdns8kx14n1p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/ttf-parser")
    (synopsis "A high-level, safe, zero-allocation TrueType font parser.")
    (description
     "This package provides a high-level, safe, zero-allocation TrueType font parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-owned-ttf-parser-0.17
  (package
    (name "rust-owned-ttf-parser")
    (version "0.17.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "owned_ttf_parser" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1igdfw2qprf3dpsg97kbk8qdrgv9gwd3saa2fl6ryfj9cly4v40q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ttf-parser" ,rust-ttf-parser-0.17))))
    (home-page "https://github.com/alexheretic/owned-ttf-parser")
    (synopsis "ttf-parser plus support for owned data")
    (description "ttf-parser plus support for owned data")
    (license license:asl2.0)))

(define-public rust-ab-glyph-0.2.18
  (package
    (name "rust-ab-glyph")
    (version "0.2.18")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ab_glyph" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ngymx51w97q4s4imy8wpjaq00jblbl6yhsdhr1kjrab09lbrkad"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-ab-glyph-rasterizer" ,rust-ab-glyph-rasterizer-0.1)
                       ("rust-libm" ,rust-libm-0.2)
                       ("rust-owned-ttf-parser" ,rust-owned-ttf-parser-0.17))))
    (home-page "https://github.com/alexheretic/ab-glyph")
    (synopsis
     "API for loading, scaling, positioning and rasterizing OpenType font glyphs.")
    (description
     "API for loading, scaling, positioning and rasterizing OpenType font glyphs.")
    (license license:asl2.0)))

(define-public rust-konst-proc-macros-0.2
  (package
    (name "rust-konst-proc-macros")
    (version "0.2.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "konst_proc_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0dxp8mdh3q9d044ql203way4fgbc50n3j3pi2j1x2snlcaa10klq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis "Implementation detail of the `konst` crate")
    (description "Implementation detail of the `konst` crate")
    (license license:zlib)))

(define-public rust-konst-macro-rules-0.2
  (package
    (name "rust-konst-macro-rules")
    (version "0.2.19")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "konst_macro_rules" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0dswja0dqcww4x3fwjnirc0azv2n6cazn8yv0kddksd8awzkz4x4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis "Implementation detail of the konst crate")
    (description "Implementation detail of the konst crate")
    (license license:zlib)))

(define-public rust-konst-0.2
  (package
    (name "rust-konst")
    (version "0.2.19")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "konst" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1x3lxxk9vjaiiaabngv7ki2bv9xi36gnqzjzi0s8qfs8wq9hw3rk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-konst-macro-rules" ,rust-konst-macro-rules-0.2)
                       ("rust-konst-proc-macros" ,rust-konst-proc-macros-0.2)
                       ("rust-trybuild" ,rust-trybuild-1))))
    (home-page "https://github.com/rodrimati1992/konst/")
    (synopsis
     "Const equivalents of std functions, compile-time comparison, and parsing")
    (description
     "Const equivalents of std functions, compile-time comparison, and parsing")
    (license license:zlib)))

(define-public rust-const-format-proc-macros-0.2
  (package
    (name "rust-const-format-proc-macros")
    (version "0.2.29")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "const_format_proc_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0l46av391ysvw0q5v156c37x9lmnmg0ri3qg6w6zf317yxxz95yq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://github.com/rodrimati1992/const_format_crates/")
    (synopsis "Implementation detail of the `const_format` crate")
    (description "Implementation detail of the `const_format` crate")
    (license license:zlib)))

(define-public rust-const-format-0.2.30
  (package
    (name "rust-const-format")
    (version "0.2.30")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "const_format" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03lcici19g1xglapy4rwjci1p3z2y8r94i4d04g69h6jsfsdj2bk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-const-format-proc-macros" ,rust-const-format-proc-macros-0.2)
                       ("rust-konst" ,rust-konst-0.2))
       #:cargo-development-inputs (("rust-arrayvec" ,rust-arrayvec-0.5)
                                   ("rust-fastrand" ,rust-fastrand-1))))
    (home-page "https://github.com/rodrimati1992/const_format_crates/")
    (synopsis "Compile-time string formatting")
    (description "Compile-time string formatting")
    (license license:zlib)))

(define-public rust-webpki-roots-0.23
  (package
    (name "rust-webpki-roots")
    (version "0.23.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "webpki-roots" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0f4k8nng542iilxbibh1nhrdf5wbyi9is4fr219zzrc6hgw5hc5h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustls-webpki" ,rust-rustls-webpki-0.100))))
    (home-page "https://github.com/rustls/webpki-roots")
    (synopsis "Mozilla's CA root certificates for use with webpki")
    (description "Mozilla's CA root certificates for use with webpki")
    (license license:mpl2.0)))

(define-public rust-tokio-rustls-0.24
  (package
    (name "rust-tokio-rustls")
    (version "0.24.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tokio-rustls" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "10bhibg57mqir7xjhb2xmf24xgfpx6fzpyw720a4ih8a737jg0y2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustls" ,rust-rustls-0.21)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/rustls/tokio-rustls")
    (synopsis "Asynchronous TLS/SSL streams for Tokio using Rustls.")
    (description "Asynchronous TLS/SSL streams for Tokio using Rustls.")
    (license (list license:expat license:asl2.0))))

(define-public rust-hyper-rustls-0.24
  (package
    (name "rust-hyper-rustls")
    (version "0.24.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hyper-rustls" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ds8scrn8klgd4a1lnqh7mqhgk79bkm14yd4kg6s9vmkn5p04ih6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-http" ,rust-http-0.2)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.23))))
    (home-page "https://github.com/ctz/hyper-rustls")
    (synopsis "Rustls+hyper integration for pure rust HTTPS")
    (description "Rustls+hyper integration for pure rust HTTPS")
    (license (list license:asl2.0 license:isc license:expat))))

(define-public rust-tokio-util-0.7
  (package
    (name "rust-tokio-util")
    (version "0.7.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tokio-util" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0zfvblvskaj65rianw6agz9hnbdbsfgf5fkw4srwik3yr31fhvw0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-hashbrown" ,rust-hashbrown-0.12)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://tokio.rs")
    (synopsis "Additional utilities for working with Tokio.
")
    (description "Additional utilities for working with Tokio.")
    (license license:expat)))

(define-public rust-tokio-macros-2
  (package
    (name "rust-tokio-macros")
    (version "2.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tokio-macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0pk7y9dfanab886iaqwcbri39jkw33kgl7y07v0kg1pp8prdq2v3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://tokio.rs")
    (synopsis "Tokio's proc macros.
")
    (description "Tokio's proc macros.")
    (license license:expat)))

(define-public rust-socket2-0.4
  (package
    (name "rust-socket2")
    (version "0.4.9")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "socket2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0qnn1r41jqj20m0a2nzzjgzndlmpg5maiyjchccaypfqxq8sk934"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/rust-lang/socket2")
    (synopsis
     "Utilities for handling networking sockets with a maximal amount of configuration
possible intended.
")
    (description
     "Utilities for handling networking sockets with a maximal amount of configuration
possible intended.")
    (license (list license:expat license:asl2.0))))

(define-public rust-mio-0.8
  (package
    (name "rust-mio")
    (version "0.8.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "mio" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1lhrdgcmcy8f0qy1n7357q0aprfkm5gld5mjcrp209pwsdf7cylj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-wasi" ,rust-wasi-0.11)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/tokio-rs/mio")
    (synopsis "Lightweight non-blocking I/O.")
    (description "Lightweight non-blocking I/O.")
    (license license:expat)))

(define-public rust-tokio-1
  (package
    (name "rust-tokio")
    (version "1.29.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tokio" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kyqfy77fq9jkhkk36xrqrcpbvbgb6i037zwm0l3m774dvq44i1p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-num-cpus" ,rust-num-cpus-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-signal-hook-registry" ,rust-signal-hook-registry-1)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-tokio-macros" ,rust-tokio-macros-2)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://tokio.rs")
    (synopsis
     "An event-driven, non-blocking I/O platform for writing asynchronous I/O
backed applications.
")
    (description
     "An event-driven, non-blocking I/O platform for writing asynchronous I/O backed
applications.")
    (license license:expat)))

(define-public rust-socket2-0.5
  (package
    (name "rust-socket2")
    (version "0.5.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "socket2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0xzq0mkg3x345wbjzrp2i19s6lrjdlbh48ra6bh805kl063v2f15"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/rust-lang/socket2")
    (synopsis
     "Utilities for handling networking sockets with a maximal amount of configuration
possible intended.
")
    (description
     "Utilities for handling networking sockets with a maximal amount of configuration
possible intended.")
    (license (list license:expat license:asl2.0))))

(define-public rust-quinn-udp-0.4
  (package
    (name "rust-quinn-udp")
    (version "0.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quinn-udp" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1h60xcfhfqq03jfv17b6d8j2kca1fwpnfqqxp6gplxck9ll9xwbd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-socket2" ,rust-socket2-0.5)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/quinn-rs/quinn")
    (synopsis
     "UDP sockets with ECN information for the QUIC transport protocol")
    (description
     "UDP sockets with ECN information for the QUIC transport protocol")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustls-webpki-0.100
  (package
    (name "rust-rustls-webpki")
    (version "0.100.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustls-webpki" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0sxlgpcczd1wihmnbgv5qz00jim32dap5wzq2rwcm39xxpapq86n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ring" ,rust-ring-0.16)
                       ("rust-untrusted" ,rust-untrusted-0.7))))
    (home-page "https://github.com/rustls/webpki")
    (synopsis "Web PKI X.509 Certificate Verification.")
    (description "Web PKI X.509 Certificate Verification.")
    (license (list
              license:asl2.0
              license:isc
              license:expat))))

(define-public rust-rustls-0.21
  (package
    (name "rust-rustls")
    (version "0.21.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustls" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0pvz4ji4m0sgq8mkrcla1c4r076zvcbaacww76zipg4lys5a4b73"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-rustls-webpki" ,rust-rustls-webpki-0.100)
                       ("rust-rustversion" ,rust-rustversion-1)
                       ("rust-sct" ,rust-sct-0.7))))
    (home-page "https://github.com/rustls/rustls")
    (synopsis "Rustls is a modern TLS library written in Rust.")
    (description "Rustls is a modern TLS library written in Rust.")
    (license (list license:asl2.0 license:isc license:expat))))

(define-public rust-quinn-proto-0.10
  (package
    (name "rust-quinn-proto")
    (version "0.10.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quinn-proto" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1cw453vyn9ink925hl829ia50dk4ls4r0vh84rmg52asxvb4xbw5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-ring" ,rust-ring-0.16)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tinyvec" ,rust-tinyvec-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/quinn-rs/quinn")
    (synopsis "State machine for the QUIC transport protocol")
    (description "State machine for the QUIC transport protocol")
    (license (list license:expat license:asl2.0))))

(define-public rust-linux-raw-sys-0.3
  (package
    (name "rust-linux-raw-sys")
    (version "0.3.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "linux-raw-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "068mbigb3frrxvbi5g61lx25kksy98f2qgkvc4xg8zxznwp98lzg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/sunfishcode/linux-raw-sys")
    (synopsis "Generated bindings for Linux's userspace API")
    (description "Generated bindings for Linux's userspace API")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-libc-0.2
  (package
    (name "rust-libc")
    (version "0.2.147")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1cwv2lkzk3p5lby79fm42qhsh29lvbqwayhjjkq1s746xaq8yrml"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/rust-lang/libc")
    (synopsis "Raw FFI bindings to platform libraries like libc.
")
    (description "Raw FFI bindings to platform libraries like libc.")
    (license (list license:expat license:asl2.0))))

(define-public rust-hermit-abi-0.3
  (package
    (name "rust-hermit-abi")
    (version "0.3.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hermit-abi" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "11j2v3q58kmi5mhjvh6hfrb7il2yzg7gmdf5lpwnwwv6qj04im7y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/hermitcore/rusty-hermit")
    (synopsis "Hermit system calls definitions.")
    (description "Hermit system calls definitions.")
    (license (list license:expat license:asl2.0))))

(define-public rust-io-lifetimes-1
  (package
    (name "rust-io-lifetimes")
    (version "1.0.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "io-lifetimes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1hph5lz4wd3drnn6saakwxr497liznpfnv70via6s0v8x6pbkrza"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-fs-err" ,rust-fs-err-2)
                       ("rust-hermit-abi" ,rust-hermit-abi-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-os-pipe" ,rust-os-pipe-1)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/sunfishcode/io-lifetimes")
    (synopsis "A low-level I/O ownership and borrowing library")
    (description
     "This package provides a low-level I/O ownership and borrowing library")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-windows-x86-64-msvc-0.48
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12ipr1knzj2rwjygyllfi5mkd0ihnbi3r61gag5n2jgyk5bmyl8s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnullvm-0.48
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_gnullvm" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0lxryz3ysx0145bf3i38jkr7f9nxiym8p3syklp8f20yyk0xp5kq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnu-0.48
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_gnu" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1cblz5m6a8q6ha09bz4lz233dnq5sw2hpra06k9cna3n3xk8laya"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-msvc-0.48
  (package
    (name "rust-windows-i686-msvc")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_i686_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "004fkyqv3if178xx9ksqc4qqv8sz8n72mpczsr2vy8ffckiwchj5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-gnu-0.48
  (package
    (name "rust-windows-i686-gnu")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_i686_gnu" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0hd2v9kp8fss0rzl83wzhw0s5z8q1b4875m6s1phv0yvlxi1jak2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-msvc-0.48
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_aarch64_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1wvwipchhywcjaw73h998vzachf668fpqccbhrxzrz5xszh2gvxj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-gnullvm-0.48
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_aarch64_gnullvm" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1g71yxi61c410pwzq05ld7si4p9hyx6lf5fkw21sinvr3cp5gbli"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import lib for Windows")
    (description "Import lib for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-targets-0.48
  (package
    (name "rust-windows-targets")
    (version "0.48.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-targets" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0pz9ad4mpp06h80hkmzlib78b5r9db7isycy1gr9j17pj1sb3m05"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-aarch64-gnullvm" ,rust-windows-aarch64-gnullvm-0.48)
                       ("rust-windows-aarch64-msvc" ,rust-windows-aarch64-msvc-0.48)
                       ("rust-windows-i686-gnu" ,rust-windows-i686-gnu-0.48)
                       ("rust-windows-i686-msvc" ,rust-windows-i686-msvc-0.48)
                       ("rust-windows-x86-64-gnu" ,rust-windows-x86-64-gnu-0.48)
                       ("rust-windows-x86-64-gnullvm" ,rust-windows-x86-64-gnullvm-0.48)
                       ("rust-windows-x86-64-msvc" ,rust-windows-x86-64-msvc-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Import libs for Windows")
    (description "Import libs for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-sys-0.48
  (package
    (name "rust-windows-sys")
    (version "0.48.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1aan23v5gs7gya1lc46hqn9mdh8yph3fhxmhxlw36pn6pqc28zb7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-targets" ,rust-windows-targets-0.48))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-errno-0.3
  (package
    (name "rust-errno")
    (version "0.3.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "errno" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0fp7qy6fwagrnmi45msqnl01vksqwdb2qbbv60n9cz7rf0xfrksb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-errno-dragonfly" ,rust-errno-dragonfly-0.1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/lambda-fairy/rust-errno")
    (synopsis "Cross-platform interface to the `errno` variable.")
    (description "Cross-platform interface to the `errno` variable.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustix-0.37
  (package
    (name "rust-rustix")
    (version "0.37.20")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustix" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1h5j9d3rnz06rq56c9p1hkddzixipiqjg39i3xnnll5a0hfqjvmr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-errno" ,rust-errno-0.3)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.48))))
    (home-page "https://github.com/bytecodealliance/rustix")
    (synopsis "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (description
     "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (license (list license:asl2.0
                   license:expat))))

(define-public rust-concurrent-queue-2
  (package
    (name "rust-concurrent-queue")
    (version "2.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "concurrent-queue" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0z0bnpgcblhrms6gph7x78yplj3qmlr5mvl38v9641zsxiqngv32"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8)
                       ("rust-loom" ,rust-loom-0.5)
                       ("rust-portable-atomic" ,rust-portable-atomic-1))))
    (home-page "https://github.com/smol-rs/concurrent-queue")
    (synopsis "Concurrent multi-producer multi-consumer queue")
    (description "Concurrent multi-producer multi-consumer queue")
    (license (list license:asl2.0 license:expat))))

(define-public rust-async-lock-2
  (package
    (name "rust-async-lock")
    (version "2.7.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "async-lock" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1mrd4kai92fcgl9974dpmibiq6ja9drz41v3crvv0c27a8kzf97s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-event-listener" ,rust-event-listener-2))))
    (home-page "https://github.com/smol-rs/async-lock")
    (synopsis "Async synchronization primitives")
    (description "Async synchronization primitives")
    (license (list license:asl2.0 license:expat))))

(define-public rust-async-io-1
  (package
    (name "rust-async-io")
    (version "1.13.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "async-io" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1byj7lpw0ahk6k63sbc9859v68f28hpaab41dxsjj1ggjdfv9i8g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-lock" ,rust-async-lock-2)
                       ("rust-autocfg" ,rust-autocfg-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-concurrent-queue" ,rust-concurrent-queue-2)
                       ("rust-futures-lite" ,rust-futures-lite-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-parking" ,rust-parking-2)
                       ("rust-polling" ,rust-polling-2)
                       ("rust-rustix" ,rust-rustix-0.37)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-waker-fn" ,rust-waker-fn-1))))
    (home-page "https://github.com/smol-rs/async-io")
    (synopsis "Async I/O and timers")
    (description "Async I/O and timers")
    (license (list license:asl2.0 license:expat))))

(define-public rust-quinn-0.10
  (package
    (name "rust-quinn")
    (version "0.10.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quinn" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0963302vxa9navvxylc2gdrnk2kyhcs8znw2j6vg2cf11wf2y991"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-io" ,rust-async-io-1)
                       ("rust-async-std" ,rust-async-std-1)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-quinn-proto" ,rust-quinn-proto-0.10)
                       ("rust-quinn-udp" ,rust-quinn-udp-0.4)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/quinn-rs/quinn")
    (synopsis "Versatile QUIC transport protocol implementation")
    (description "Versatile QUIC transport protocol implementation")
    (license (list license:expat license:asl2.0))))

(define-public rust-quote-1
  (package
    (name "rust-quote")
    (version "1.0.29")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quote" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "019ij5fwp56ydww6zr46dhmzsf078qkdq9vz6mw1cri7mgl1ac2p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "https://github.com/dtolnay/quote")
    (synopsis "Quasi-quoting macro quote!(...)")
    (description "Quasi-quoting macro quote!(...)")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-macro2-1
  (package
    (name "rust-proc-macro2")
    (version "1.0.63")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "proc-macro2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ssr3643nwfhw7yvqhibjw1k6nsnbv0lxq7mc1zcw38vjax8ydkv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/dtolnay/proc-macro2")
    (synopsis
     "A substitute implementation of the compiler's `proc_macro` API to decouple token-based libraries from the procedural macro use case.")
    (description
     "This package provides a substitute implementation of the compiler's `proc_macro`
API to decouple token-based libraries from the procedural macro use case.")
    (license (list license:expat license:asl2.0))))

(define-public rust-syn-2
  (package
    (name "rust-syn")
    (version "2.0.22")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "syn" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "05j6n81lm86idf0cgv9rfpddscajyj91rlfbrmmvvsplmkkymyrf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-unicode-ident" ,rust-unicode-ident-1))))
    (home-page "https://github.com/dtolnay/syn")
    (synopsis "Parser for Rust source code")
    (description "Parser for Rust source code")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-macro-0.3
  (package
    (name "rust-futures-macro")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-macro" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0wpfsqxwqk5k569xl0jzz4zxy85x695mndf7y9jn66q6jid59jl9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis "The futures-rs procedural macro implementations.
")
    (description "The futures-rs procedural macro implementations.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-io-0.3
  (package
    (name "rust-futures-io")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-io" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0r4rhkdhq1my4fahlhz59barqa511bylq813w3w4gvbidq4p9zsg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis
     "The `AsyncRead`, `AsyncWrite`, `AsyncSeek`, and `AsyncBufRead` traits for the futures-rs library.
")
    (description
     "The `AsyncRead`, `AsyncWrite`, `AsyncSeek`, and `AsyncBufRead` traits for the
futures-rs library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-util-0.3
  (package
    (name "rust-futures-util")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-util" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0cwmls9369w6q6hwlbm10q0plr6hmg8w28fpqvv4rmbjnx01xc16"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.1)
                       ("rust-futures-channel" ,rust-futures-channel-0.3)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-macro" ,rust-futures-macro-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-futures-task" ,rust-futures-task-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-pin-utils" ,rust-pin-utils-0.1)
                       ("rust-slab" ,rust-slab-0.4)
                       ("rust-tokio-io" ,rust-tokio-io-0.1))))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis
     "Common utilities and extension traits for the futures-rs library.
")
    (description
     "Common utilities and extension traits for the futures-rs library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-task-0.3
  (package
    (name "rust-futures-task")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-task" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ravgihyarbplj32zp60asirfnaalw2wfsa0afhnl3kcpqrd3lvn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis "Tools for working with tasks.
")
    (description "Tools for working with tasks.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-executor-0.3
  (package
    (name "rust-futures-executor")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-executor" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1q468di96knnla72xdvswic1ir2qkrf5czsdigc5n4l86a1fxv6c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-task" ,rust-futures-task-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-num-cpus" ,rust-num-cpus-1))))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis
     "Executors for asynchronous tasks based on the futures-rs library.
")
    (description
     "Executors for asynchronous tasks based on the futures-rs library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-sink-0.3
  (package
    (name "rust-futures-sink")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-sink" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0vkv4frf4c6gm1ag9imjz8d0xvpnn22lkylsls0rffx147zf8fzl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis "The asynchronous `Sink` trait for the futures-rs library.
")
    (description "The asynchronous `Sink` trait for the futures-rs library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-core-0.3
  (package
    (name "rust-futures-core")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-core" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "137fdxy5amg9zkpa1kqnj7bnha6b94fmddz59w973x96gqxmijjb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-portable-atomic" ,rust-portable-atomic-1))))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis "The core traits and types in for the `futures` library.
")
    (description "The core traits and types in for the `futures` library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-channel-0.3
  (package
    (name "rust-futures-channel")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures-channel" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1wmm9wm5zjigxz61qkscmxp7c30zp08dy63spjz5pch9gva1hmcm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3))))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis "Channels for asynchronous communication using futures-rs.
")
    (description "Channels for asynchronous communication using futures-rs.")
    (license (list license:expat license:asl2.0))))

(define-public rust-futures-0.3
  (package
    (name "rust-futures")
    (version "0.3.28")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "futures" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0h7c1xvxk751c7xlnph6fh3rb77z4lig4qif7f8q79db2az2ld13"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures-channel" ,rust-futures-channel-0.3)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-executor" ,rust-futures-executor-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-futures-sink" ,rust-futures-sink-0.3)
                       ("rust-futures-task" ,rust-futures-task-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3))))
    (home-page "https://rust-lang.github.io/futures-rs")
    (synopsis
     "An implementation of futures and streams featuring zero allocations,
composability, and iterator-like interfaces.
")
    (description
     "An implementation of futures and streams featuring zero allocations,
composability, and iterator-like interfaces.")
    (license (list license:expat license:asl2.0))))

(define-public rust-h3-quinn-0.0.3
  (package
    (name "rust-h3-quinn")
    (version "0.0.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "h3-quinn" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kf6bqmm751gwj24dqgb2rrwq8ibhv7z5v7ix4pfiwz4ccbiljid"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-h3" ,rust-h3-0.0.2)
                       ("rust-quinn" ,rust-quinn-0.10)
                       ("rust-quinn-proto" ,rust-quinn-proto-0.10)
                       ("rust-tokio-util" ,rust-tokio-util-0.7))))
    (home-page "https://github.com/hyperium/h3")
    (synopsis "QUIC transport implementation based on Quinn.")
    (description "QUIC transport implementation based on Quinn.")
    (license license:expat)))

(define-public rust-tracing-core-0.1
  (package
    (name "rust-tracing-core")
    (version "0.1.31")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tracing-core" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "16pp28izw9c41m7c55qsghlz07r9ark8lzd3x6ig3xhxg89vhm89"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-once-cell" ,rust-once-cell-1)
                       ("rust-valuable" ,rust-valuable-0.1))))
    (home-page "https://tokio.rs")
    (synopsis "Core primitives for application-level tracing.
")
    (description "Core primitives for application-level tracing.")
    (license license:expat)))

(define-public rust-tracing-attributes-0.1
  (package
    (name "rust-tracing-attributes")
    (version "0.1.26")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tracing-attributes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ax44ldpbcb7dsvpljiv2krnx6xp0hs85zcyv8385sarc7sk2ksz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://tokio.rs")
    (synopsis
     "Procedural macro attributes for automatically instrumenting functions.
")
    (description
     "Procedural macro attributes for automatically instrumenting functions.")
    (license license:expat)))

(define-public rust-tracing-0.1
  (package
    (name "rust-tracing")
    (version "0.1.38")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tracing" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0kc1mpsh00l2zd9wryf1jyzwvilmbjdg5dmnn240rx6k2flgd76g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-tracing-attributes" ,rust-tracing-attributes-0.1)
                       ("rust-tracing-core" ,rust-tracing-core-0.1))))
    (home-page "https://tokio.rs")
    (synopsis "Application-level tracing for Rust.
")
    (description "Application-level tracing for Rust.")
    (license license:expat)))

(define-public rust-h3-0.0.2
  (package
    (name "rust-h3")
    (version "0.0.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "h3" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17nbmkz6xs848257xv7gdhrnhyhagfb0dbqla82zv1nixr1wmrkd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytes" ,rust-bytes-1)
                       ("rust-fastrand" ,rust-fastrand-1)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/hyperium/h3")
    (synopsis "An async HTTP/3 implementation.")
    (description "An async HTTP/3 implementation.")
    (license license:expat)))

(define-public rust-zstd-safe-6
  (package
    (name "rust-zstd-safe")
    (version "6.0.5+zstd.1.5.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "zstd-safe" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0fyj55jkyik3qjaf6i0pn0vwmqyazdjh389qq8384xdinih9wvfm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-zstd-sys" ,rust-zstd-sys-2))))
    (home-page "https://github.com/gyscos/zstd-rs")
    (synopsis "Safe low-level bindings for the zstd compression library.")
    (description "Safe low-level bindings for the zstd compression library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-zstd-0.12
  (package
    (name "rust-zstd")
    (version "0.12.3+zstd.1.5.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "zstd" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "01h8zmdckz1rklpsr0i3lxx9d2jxb5fmsbwwzl9hwkh2zcra3vkn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-zstd-safe" ,rust-zstd-safe-6))))
    (home-page "https://github.com/gyscos/zstd-rs")
    (synopsis "Binding for the zstd compression library.")
    (description "Binding for the zstd compression library.")
    (license license:expat)))

(define-public rust-async-compression-0.4
  (package
    (name "rust-async-compression")
    (version "0.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "async-compression" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "04gz61rbi7gsjwil66g79qwa4mhh9pi3ksgc4g4qqf91b24240av"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-brotli" ,rust-brotli-3)
                       ("rust-bzip2" ,rust-bzip2-0.4)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-io" ,rust-futures-io-0.3)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-xz2" ,rust-xz2-0.1)
                       ("rust-zstd" ,rust-zstd-0.12)
                       ("rust-zstd-safe" ,rust-zstd-safe-6))))
    (home-page "https://github.com/Nullus157/async-compression")
    (synopsis
     "Adaptors between compression crates and Rust's modern asynchronous IO types.
")
    (description
     "Adaptors between compression crates and Rust's modern asynchronous IO types.")
    (license (list license:expat license:asl2.0))))

(define-public rust-reqwest-0.11.18
  (package
    (name "rust-reqwest")
    (version "0.11.18")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "reqwest" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0m8w3hmp8hqlyiq1dx0k415c1b7s27s2a4pqmxfgh53w9fhj9s6d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-async-compression" ,rust-async-compression-0.4)
                       ("rust-base64" ,rust-base64-0.21)
                       ("rust-bytes" ,rust-bytes-1)
                       ("rust-cookie" ,rust-cookie-0.16)
                       ("rust-cookie-store" ,rust-cookie-store-0.16)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-futures-channel" ,rust-futures-channel-0.3)
                       ("rust-futures-core" ,rust-futures-core-0.3)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-h2" ,rust-h2-0.3)
                       ("rust-h3" ,rust-h3-0.0.2)
                       ("rust-h3-quinn" ,rust-h3-quinn-0.0.3)
                       ("rust-http" ,rust-http-0.2)
                       ("rust-http-body" ,rust-http-body-0.4)
                       ("rust-hyper" ,rust-hyper-0.14)
                       ("rust-hyper-rustls" ,rust-hyper-rustls-0.24)
                       ("rust-hyper-tls" ,rust-hyper-tls-0.5)
                       ("rust-ipnet" ,rust-ipnet-2)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-native-tls" ,rust-native-tls-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pin-project-lite" ,rust-pin-project-lite-0.2)
                       ("rust-quinn" ,rust-quinn-0.10)
                       ("rust-rustls" ,rust-rustls-0.21)
                       ("rust-rustls-native-certs" ,rust-rustls-native-certs-0.6)
                       ("rust-rustls-pemfile" ,rust-rustls-pemfile-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-urlencoded" ,rust-serde-urlencoded-0.7)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-native-tls" ,rust-tokio-native-tls-0.3)
                       ("rust-tokio-rustls" ,rust-tokio-rustls-0.24)
                       ("rust-tokio-socks" ,rust-tokio-socks-0.5)
                       ("rust-tokio-util" ,rust-tokio-util-0.7)
                       ("rust-tower-service" ,rust-tower-service-0.3)
                       ("rust-trust-dns-resolver" ,rust-trust-dns-resolver-0.22)
                       ("rust-url" ,rust-url-2)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-wasm-bindgen-futures" ,rust-wasm-bindgen-futures-0.4)
                       ("rust-wasm-streams" ,rust-wasm-streams-0.2)
                       ("rust-web-sys" ,rust-web-sys-0.3)
                       ("rust-webpki-roots" ,rust-webpki-roots-0.22)
                       ("rust-winreg" ,rust-winreg-0.10))
       #:cargo-development-inputs (("rust-brotli" ,rust-brotli-3)
                                   ("rust-doc-comment" ,rust-doc-comment-0.3)
                                   ("rust-env-logger" ,rust-env-logger-0.8)
                                   ("rust-hyper" ,rust-hyper-0.14)
                                   ("rust-libflate" ,rust-libflate-1)
                                   ("rust-serde" ,rust-serde-1)
                                   ("rust-tokio" ,rust-tokio-1)
                                   ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                                   ("rust-wasm-bindgen-test" ,rust-wasm-bindgen-test-0.3))))
    (home-page "https://github.com/seanmonstar/reqwest")
    (synopsis "higher level HTTP client library")
    (description "higher level HTTP client library")
    (license (list license:expat license:asl2.0))))

(define-public rust-quick-xml-0.28
  (package
    (name "rust-quick-xml")
    (version "0.28.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quick-xml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1lfr3512x0s0i9kbyglyzn0rq0i1bvd2mqqfi8gs685808rfgr8c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/tafia/quick-xml")
    (synopsis "High performance xml reader and writer")
    (description "High performance xml reader and writer")
    (license license:expat)))

(define-public rust-dmg-0.1
  (package
    (name "rust-dmg")
    (version "0.1.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "dmg" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "08j7ghx54j7bp6yqk7wc6crb4ggnf51pf3vmnhipz0rp0csqrhmb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-plist" ,rust-plist-1))
       #:cargo-development-inputs (("rust-env-logger" ,rust-env-logger-0.10))))
    (home-page "https://github.com/mgoszcz2/dmg")
    (synopsis "Simple attaching/detaching of macOS disk images")
    (description "Simple attaching/detaching of macOS disk images")
    (license (list license:expat license:asl2.0))))

(define-public rust-plist-1
  (package
    (name "rust-plist")
    (version "1.4.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "plist" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1405zsm4cwlc72vjpc4dcnf5hqis2c0k5hh9zwa3wgca4rxn9ncv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.21)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-line-wrap" ,rust-line-wrap-0.1)
                       ("rust-quick-xml" ,rust-quick-xml-0.28)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-time" ,rust-time-0.3))))
    (home-page "https://github.com/ebarnard/rust-plist/")
    (synopsis "A rusty plist parser. Supports Serde serialization.")
    (description
     "This package provides a rusty plist parser.  Supports Serde serialization.")
    (license license:expat)))

(define-public rust-pix-0.13
  (package
    (name "rust-pix")
    (version "0.13.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "pix" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ha8is78vqpj0iapnl3h3zksjyr0m2yhhiqd51802s3pnf96jaqc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-development-inputs (("rust-criterion" ,rust-criterion-0.3))))
    (home-page "https://github.com/DougLau/pix")
    (synopsis "Pixel / raster image library")
    (description "Pixel / raster image library")
    (license (list license:expat license:asl2.0))))

(define-public rust-quick-xml-0.28
  (package
    (name "rust-quick-xml")
    (version "0.28.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quick-xml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1lfr3512x0s0i9kbyglyzn0rq0i1bvd2mqqfi8gs685808rfgr8c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/tafia/quick-xml")
    (synopsis "High performance xml reader and writer")
    (description "High performance xml reader and writer")
    (license license:expat)))

(define-public rust-sanitize-filename-0.4
  (package
    (name "rust-sanitize-filename")
    (version "0.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "sanitize-filename" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0v19h0928a29v3jl6pawlji9mcpk1rcb0z2615jkkw9qnsyh5i88"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-regex" ,rust-regex-1))))
    (home-page "https://github.com/kardeiz/sanitize-filename")
    (synopsis "A simple filename sanitizer, based on Node's sanitize-filename")
    (description
     "This package provides a simple filename sanitizer, based on Node's
sanitize-filename")
    (license license:expat)))

(define-public rust-icns-0.3
  (package
    (name "rust-icns")
    (version "0.3.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "icns" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0h4slnysg38bpaqa6iaxrqjk3ndglna4k4lanjjp1nh8gsnzpk55"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-png" ,rust-png-0.16))))
    (home-page "https://github.com/mdsteele/rust-icns")
    (synopsis
     "A library for encoding/decoding Apple Icon Image (.icns) files.")
    (description
     "This package provides a library for encoding/decoding Apple Icon Image (.icns)
files.")
    (license license:expat)))

(define-public rust-windows-interface-0.43
  (package
    (name "rust-windows-interface")
    (version "0.43.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-interface" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "06drakcacg4d680qa2sk62kqn7ini00xw3zz0hwqwx1my2z4z3dw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The interface macro for the windows crate")
    (description "The interface macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-implement-0.43
  (package
    (name "rust-windows-implement")
    (version "0.43.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-implement" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "01zqmrdnz2j5qd4ahqjsz724mdabi577f400yywcahy7dl2rpqmp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "The implement macro for the windows crate")
    (description "The implement macro for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-0.43
  (package
    (name "rust-windows")
    (version "0.43.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0i32alvc4n4l7abmv1fsvnd1lzw17f1cpr16kgx0sqz5wg82wrh4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-windows-implement" ,rust-windows-implement-0.43)
                       ("rust-windows-interface" ,rust-windows-interface-0.43)
                       ("rust-windows-aarch64-gnullvm" ,rust-windows-aarch64-gnullvm-0.42)
                       ("rust-windows-aarch64-msvc" ,rust-windows-aarch64-msvc-0.42)
                       ("rust-windows-i686-gnu" ,rust-windows-i686-gnu-0.42)
                       ("rust-windows-i686-msvc" ,rust-windows-i686-msvc-0.42)
                       ("rust-windows-x86-64-gnu" ,rust-windows-x86-64-gnu-0.42)
                       ("rust-windows-x86-64-gnullvm" ,rust-windows-x86-64-gnullvm-0.42)
                       ("rust-windows-x86-64-msvc" ,rust-windows-x86-64-msvc-0.42))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-mime-macro-0.0.0
  (let ((commit "57416f447a10c3343df7fe80deb0ae8a7c77cf0a")
        (revision "0"))
    (package
      (name "rust-mime-macro")
      (version "0.0.0")
      ;; (source (origin
      ;;           (method url-fetch)
      ;;           (uri (crate-uri "mime-macro" version))
      ;;           (file-name (string-append name "-" version ".tar.gz"))
      ;;           (sha256
      ;;            (base32
      ;;             "0vh2w8n2x9lms8m9jpx5s0vzyava1jdxlsjdzba6j1s6sjpgl2cm"))))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/filips123/mime")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1lb400ra9gbnm0mm5pyqgdz6bgshj47v0mdc12l7jbxbgqn3ncrf"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             (let ((package-name "mime-macro"))
               (for-each
                (lambda (file)
                  (when (file-exists? file)
                      (delete-file-recursively file)))
                (find-files "."
                            (lambda (file _)
                              (not (regexp-exec (make-regexp (string-append "^\\.$|LICENSE|" package-name)) file)))
                            #:directories? #t))
               (copy-recursively package-name ".")
               (delete-file-recursively package-name))

             (substitute* "Cargo.toml"
               ;; NOTE: All dependencies, including path dependencies, should specify version to run "cargo package",
               (("mime-parse = \\{ path = \"../mime-parse\" \\}") "mime-parse = { version = \"0.0.0\" }"))))))
      (arguments `(#:cargo-inputs
                   (("rust-mime-parse"
                     ;; HACK: Use output of the package instead of the package itself.
                     ;;   cargo-build-system extract source of package in cargo-inputs.
                     ,(with-store %store
                        (package-output %store rust-mime-parse-0.0.0)))
                    ("rust-proc-macro2" ,rust-proc-macro2-0.4)
                    ("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                    ("rust-quote" ,rust-quote-0.6)
                    ("rust-syn" ,rust-syn-0.15))))
      (build-system cargo-build-system)
      (home-page "")
      (synopsis "mime procedural macros")
      (description "mime procedural macros")
      (license license:expat))))

(define-public rust-mime-parse-0.0.0
  (let ((commit "57416f447a10c3343df7fe80deb0ae8a7c77cf0a")
        (revision "0"))
    (package
      (name "rust-mime-parse")
      (version "0.0.0")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/filips123/mime")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1lb400ra9gbnm0mm5pyqgdz6bgshj47v0mdc12l7jbxbgqn3ncrf"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             (let ((package-name "mime-parse"))
               (for-each
                (lambda (file)
                  (when (file-exists? file)
                    (delete-file-recursively file)))
                (find-files "."
                            (lambda (file _)
                              (not (regexp-exec (make-regexp (string-append "^\\.$|LICENSE|" package-name)) file)))
                            #:directories? #t))
               (copy-recursively package-name ".")
               (delete-file-recursively package-name))))))
      (build-system cargo-build-system)
      (home-page "")
      (synopsis "mime parsing internals")
      (description "mime parsing internals")
      (license license:expat))))

(define-public rust-mime-implement-eq-partialeq-0.4
  (let ((commit "57416f447a10c3343df7fe80deb0ae8a7c77cf0a")
        (revision "0"))
    (package
      (name "rust-mime-implement-eq-partialeq")
      (version (git-version "0.4.0-a.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/filips123/mime")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "1lb400ra9gbnm0mm5pyqgdz6bgshj47v0mdc12l7jbxbgqn3ncrf"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             (substitute* "Cargo.toml"
               ;; NOTE: All dependencies, including path dependencies, should specify version to run "cargo package",
               (("mime-macro = \\{ path = \"./mime-macro\", ") "mime-macro = { version = \"0.0.0\", ")
               (("mime-parse = \\{ path = \"./mime-parse\" \\}") "mime-parse = { version = \"0.0.0\" }"))))))
      (build-system cargo-build-system)
      (arguments `(#:features
                   '("serde1")
                   #:cargo-inputs
                   (("rust-quoted-string" ,rust-quoted-string-0.2)
                    ("rust-serde" ,rust-serde-1)
                    ("rust-mime-parse"
                     ;; HACK: Use output of the package instead of the package itself.
                     ;;   cargo-build-system extract source of package in cargo-inputs.
                     ,(with-store %store
                        (package-output %store rust-mime-parse-0.0.0)))
                    ("rust-mime-macro"
                     ;; HACK: Use output of the package instead of the package itself.
                     ;;   cargo-build-system extract source of package in cargo-inputs.
                     ,(with-store %store
                        (package-output %store rust-mime-macro-0.0.0))))
                   #:cargo-development-inputs
                   (("rust-assert-matches" ,rust-assert-matches-1)
                    ("rust-parameterized" ,rust-parameterized-1)
                    ("rust-serde-json" ,rust-serde-json-1))))
      (home-page "https://github.com/ROCKTAKEY/mime-filips123-patched")
      (synopsis "Strongly Typed Mimes")
      (description "Strongly Typed Mimes")
      (license (list license:expat license:asl2.0)))))

(define-public rust-web-app-manifest
  (let ((commit "138672b3811594be8ecc5a17a7006dd59a03dd09")
        (revision "0"))
    (package
      (name "rust-web-app-manifest")
      (version (git-version "0.0.0" revision commit))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/filips123/WebAppManifestRS")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32
           "0wbryiaw2160qar866m5bcafhc2rlfsixi8xbwad2bsw9jxmkzn3"))
         (modules '((guix build utils)))
         (snippet
          '(begin
             (substitute* "Cargo.toml"
               (("git = \"https://github.com/filips123/mime\", branch = \"implement-eq-partialeq\"")
                "version = \"0.4.0-a.0\""))))))
      (build-system cargo-build-system)
      (arguments `(#:cargo-inputs
                   (("rust-parse-display" ,rust-parse-display-0.8)
                    ("rust-serde" ,rust-serde-1)
                    ("rust-serde-with" ,rust-serde-with-2)
                    ("rust-smart-default" ,rust-smart-default-0.6)
                    ("rust-thiserror" ,rust-thiserror-1)

                    ("rust-schemars" ,rust-schemars-0.8.12)

                    ("rust-csscolorparser" ,rust-csscolorparser-0.6)
                    ("rust-language-tags" ,rust-language-tags-0.3)

                    ("rust-mime-implement-eq-partialeq"
                     ;; HACK: Use output of the package instead of the package itself.
                     ;;   cargo-build-system extract source of package in cargo-inputs.
                     ,(with-store %store
                        (package-output %store rust-mime-implement-eq-partialeq-0.4)))
                    ("rust-url" ,rust-url-2)

                    ("rust-quoted-string" ,rust-quoted-string-0.2)
                    ("rust-mime-parse" ,rust-mime-parse-0.0.0)
                    ("rust-mime-macro" ,rust-mime-macro-0.0.0))
                   #:cargo-development-inputs
                   (("rust-assert-matches" ,rust-assert-matches-1)
                    ("rust-parameterized" ,rust-parameterized-1)
                    ("rust-serde-json" ,rust-serde-json-1))))
      ;; (inputs
      ;;  (list rust-mime-implement-eq-partialeq-0.4))
      (home-page "https://github.com/filips123/WebAppManifestRS")
      (synopsis "Rust data structure and utilities for (de)serialization and storage of Web Application Manifests")
      (description "Rust data structure and utilities for (de)serialization and storage of Web Application Manifests")
      (license license:expat))))

(define-public pwas-for-firefox
  (package
    (name "pwas-for-firefox")
    (version "2.6.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/filips123/PWAsForFirefox")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1d3vzgspxf1jgbxn0qcrmj9s3wpzgah2cv06ajmdgq07g77if3z6"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           (substitute* "native/Cargo.toml"
             (("git = \"https://github.com/filips123/rust-url\", branch = \"impl-std-error\"")
              "version = \"0.1.0-a\"")
             (("web_app_manifest = \\{ git = \"https://github.com/filips123/WebAppManifestRS\", branch = \"main\" }")
              "web_app_manifest = { version = \"0.0.0\" }"))
           (delete-file "native/Cargo.lock")))))
    (build-system cargo-build-system)
    (arguments `(#:cargo-inputs
                 (
                  ;; Universal dependencies
                  ("rust-ab-glyph" ,rust-ab-glyph-0.2.18)
                  ("rust-anyhow" ,rust-anyhow-1)
                  ("rust-byteorder" ,rust-byteorder-1)
                  ("rust-cfg-if" ,rust-cfg-if-1)
                  ("rust-clap" ,rust-clap-4)
                  ("rust-configparser" ,rust-configparser-3)
                  ("rust-const-format" ,rust-const-format-0.2.30)
                  ("rust-data-url-impl-std-error"
                   ;; HACK: Use output of the package instead of the package itself.
                   ;;   cargo-build-system extract source of package in cargo-inputs.
                   ,(with-store %store
                      (package-output %store rust-data-url-impl-std-error)))
                  ("rust-directories" ,rust-directories-4)
                  ("rust-fs-extra" ,rust-fs-extra-1.3)
                  ("rust-gag" ,rust-gag-1)
                  ("rust-image" ,rust-image-0.24)
                  ("rust-log" ,rust-log-0.4)
                  ("rust-reqwest-0.11" ,rust-reqwest-0.11.18)
                  ("rust-resvg" ,rust-resvg-0.27)
                  ("rust-serde" ,rust-serde-1)
                  ("rust-serde-json" ,rust-serde-json-1)
                  ("rust-simplelog" ,rust-simplelog-0.12)
                  ("rust-smart-default" ,rust-smart-default-0.6)
                  ("rust-tempfile" ,rust-tempfile-3.4)
                  ("rust-ulid" ,rust-ulid-1)
                  ("rust-url" ,rust-url-2)
                  ("rust-urlencoding" ,rust-urlencoding-2)

                  ("rust-web-app-manifest"
                   ;; HACK: Use output of the package instead of the package itself.
                   ;;   cargo-build-system extract source of package in cargo-inputs.
                   ,(with-store %store
                      (package-output %store rust-web-app-manifest)))
                  ;; HACK: Need inputs of rust-web-app-manifest
                  ("rust-parse-display" ,rust-parse-display-0.8)
                  ("rust-serde" ,rust-serde-1)
                  ("rust-serde-with" ,rust-serde-with-2)
                  ("rust-smart-default" ,rust-smart-default-0.6)
                  ("rust-thiserror" ,rust-thiserror-1)
                  ("rust-schemars" ,rust-schemars-0.8.12)
                  ("rust-csscolorparser" ,rust-csscolorparser-0.6)
                  ("rust-language-tags" ,rust-language-tags-0.3)
                  ("rust-url" ,rust-url-2)
                  ("rust-mime-implement-eq-partialeq"
                   ;; HACK: Use output of the package instead of the package itself.
                   ;;   cargo-build-system extract source of package in cargo-inputs.
                   ,(with-store %store
                      (package-output %store rust-mime-implement-eq-partialeq-0.4)))
                  ("rust-quoted-string" ,rust-quoted-string-0.2)
                  ("rust-mime-parse" ,rust-mime-parse-0.0.0)
                  ("rust-mime-macro" ,rust-mime-macro-0.0.0)

                  ;; Linux-specific dependencies
                  ("rust-bzip2" ,rust-bzip2-0.4)
                  ("rust-glob" ,rust-glob-0.3)
                  ("rust-phf" ,rust-phf-0.11)
                  ("rust-tar" ,rust-tar-0.4)
                  ;; MacOS-specific dependencies
                  ("rust-dmg" ,rust-dmg-0.1)
                  ("rust-icns" ,rust-icns-0.3)
                  ("rust-pix" ,rust-pix-0.13)
                  ("rust-plist" ,rust-plist-1)
                  ("rust-sanitize-filename" ,rust-sanitize-filename-0.4)

                  ;; HACK: Unknown dependencies
                  ("rust-windows" ,rust-windows-0.43))
                 #:cargo-development-inputs
                 (("rust-assert-matches" ,rust-assert-matches-1)
                  ("rust-parameterized" ,rust-parameterized-1)
                  ("rust-serde-json" ,rust-serde-json-1))
                 #:phases
                 (modify-phases %standard-phases
                   (add-before 'build 'change-working-directory
                     (lambda* _
                       ;; NOTE: Cargo.toml is here
                       (chdir "native")))
                   (add-after 'unpack 'set-env
                     (lambda* (#:key outputs #:allow-other-keys)
                       (setenv "FFPWA_EXECUTABLES"
                               ;; (string-append (assoc-ref outputs "out") "/bin")
                               "")
                       (setenv "FFPWA_SYSDATA"
                               (string-append (assoc-ref outputs "out") "/share/firefoxpwa"))
                       #t))
                   (add-after 'install 'additional-install
                     (lambda* (#:key inputs outputs #:allow-other-keys)
                       (let ((out (assoc-ref outputs "out")))
                         (let ((destination (string-append out "/share/firefoxpwa/userchrome/")))
                           (mkdir-p destination)
                           (copy-recursively
                            "userchrome"
                            destination))

                         (substitute* "manifests/linux.json"
                           (("/usr/libexec/firefoxpwa-connector")
                            (string-append out "/bin/firefoxpwa-connector")))
                         (for-each
                          (lambda (dir)
                            (mkdir-p (string-append out "/" dir "/mozilla/native-messaging-hosts/"))
                            (copy-file "manifests/linux.json"
                                       (string-append out "/" dir "/mozilla/native-messaging-hosts/firefoxpwa.json")))
                          '("lib" "lib64"))
                         (mkdir-p (string-append out "/usr/share/bash-completion/completions"))
                         (copy-file "target/release/completions/firefoxpwa.bash"
                                    (string-append out "/usr/share/bash-completion/completions/firefoxwpa"))
                         (mkdir-p (string-append out "/usr/share/fish/vendor_completions.d"))
                         (copy-file "target/release/completions/firefoxpwa.fish"
                                    (string-append out "/usr/share/fish/vendor_completions.d/firefoxpwa.fish"))
                         (mkdir-p (string-append out "/usr/share/zsh/vendor-completions"))
                         (copy-file "target/release/completions/_firefoxpwa"
                                    (string-append out "/usr/share/zsh/vendor-completions/_firefoxpwa")))
                       #t)))))
    (native-inputs
     (list
      pkg-config))
    (inputs
     (list openssl))
    (home-page "https://github.com/filips123/PWAsForFirefox")
    (synopsis
     "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox")
    (description
     "A tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox.")
    (license license:mpl2.0)))
