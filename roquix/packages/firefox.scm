(define-module
  (roquix packages firefox)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (gnu packages)
  #:use-module (guix build-system cargo)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages cpio)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-graphics)
  #:use-module (nongnu packages mozilla)
  #:use-module (roquix packages texlab))

(define-public rust-data-url-impl-std-error
  (let((commit "0032b9e8328f1a7ce2773f71adf316542ee8ddc9")
       (revision "0"))
    (package
      (name "rust-data-url-impl-std-error")
      (version (git-version "2.2.2" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/filips123/rust-url")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "1n01yyzv20jhcn5yd51xrm9dwcnr2lh49np449gradp3k37r0i5c"))))
      (build-system cargo-build-system)
      (arguments
       `(#:cargo-inputs
         (("rust-matches" ,rust-matches-0.1))
         #:cargo-development-inputs
         (("rust-rustc-test" ,rust-rustc-test-0.3)
          ("rust-serde" ,rust-serde-1)
          ("rust-serde-json" ,rust-serde-json-1))
         #:phases
         (modify-phases %standard-phases
           (add-after 'unpack 'chdir
             (lambda _
               ;; HACK: Remove root Cargo.toml to force guix to use ./data-url/Cargo.toml
               (delete-file "Cargo.toml")
               (chdir "data-url"))))))
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

(define-public rust-mime-0.3.6
  (package
    (name "rust-mime")
    (version "0.3.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mime" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "16hkibgvb9klh0w0jk5crr5xv90l3wlf77ggymzjmvl1818vnxv8"))
       ;; (patches
       ;;  (parameterize
       ;;      ((%patch-path
       ;;        (map (lambda (directory)
       ;;               (string-append directory "/roquix/packages/patches"))
       ;;             %load-path)))
       ;;    (search-patches "rust-mime-Implement-derive-Eq-PartialEq-for-more-types.patch")))
       ))
    (build-system cargo-build-system)
    (arguments '(#:features '("serde1")))
    (home-page "https://github.com/hyperium/mime")
    (synopsis "Strongly Typed Mimes")
    (description
     "Support MIME (HTTP Media Types) as strong types in Rust.")
    (license (list license:asl2.0
                   license:expat))))

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
           ;; Allow older versions of the serde crates.
           (substitute* "Cargo.toml"
             (("name = \"mime\"") "name = \"mime-implement-eq\""))))))
     (build-system cargo-build-system)
     (arguments `(;; #:cargo-package-flags '("--no-metadata" "--no-verify" "--package" "mime")
                  #:skip-build? #t
                  #:cargo-inputs
                 (("rust-quoted-string" ,rust-quoted-string-0.2))
                 #:cargo-development-inputs
                 (("rust-assert-matches" ,rust-assert-matches-1)
                  ("rust-parameterized" ,rust-parameterized-1)
                  ("rust-serde-json" ,rust-serde-json-1))))
     (home-page "https://github.com/filips123/mime")
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
          ;; Allow older versions of the serde crates.
          (substitute* "Cargo.toml"
            (("git = \"https://github.com/filips123/mime\", branch = \"implement-eq-partialeq\"") "version = \"0.3.6\"")
            ;; (("mime") "mime-implement-eq")
            )))))
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
                  ;; ("rust-mime" ,rust-mime-implement-eq-partialeq-0.4)
                  ("rust-mime" ,rust-mime-0.3)
                  ("rust-url" ,rust-url-2))
                 #:cargo-development-inputs
                 (("rust-assert-matches" ,rust-assert-matches-1)
                  ("rust-parameterized" ,rust-parameterized-1)
                  ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/filips123/WebAppManifestRS")
    (synopsis "Rust data structure and utilities for (de)serialization and storage of Web Application Manifests")
    (description "Rust data structure and utilities for (de)serialization and storage of Web Application Manifests")
    (license license:expat))))

(define-public pwas-for-firefox
  (package
    (name "pwas-for-firefox")
    (version "2.6.1")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/filips123/PWAsForFirefox/releases/download/v"
                    version "/firefoxpwa-" version "-1.x86_64.rpm"))
              (sha256
               (base32
                "00n8n8rbk13ljmdz6j0rbf4g7sjh8ykld4zva1zkrqrqy2fvxaw3"))))
    (build-system binary-build-system)
    (arguments
     '(#:patchelf-plan '(("usr/libexec/firefoxpwa-connector" ("gcc"))
                         ("usr/bin/firefoxpwa" ("gcc")))
       #:install-plan '(("usr/" "/"
                         #:exclude-regexp ("\\.build-id/")))
       #:phases (modify-phases %standard-phases
                  (replace 'unpack
                    (lambda* (#:key source #:allow-other-keys)
                      (system (format #f "rpm2cpio ~a | cpio -idv" source)) #t))
                  (add-after 'unpack 'fix-hardcorded-path
                    (lambda _
                      (substitute* "usr/lib/mozilla/native-messaging-hosts/firefoxpwa.json"
                        (("/usr/libexec/firefoxpwa-connector") "firefoxpwa-connector")))))))
    (native-inputs (list rpm cpio))
    (inputs
     (list
      ;; Universal dependencies
      rust-ab-glyph
      rust-anyhow
      rust-byteorder
      rust-cfg-if
      rust-clap
      rust-configparser
      rust-const-format
      rust-data-url-impl-std-error
      rust-directories
      rust-fs-extra
      rust-gag
      rust-image
      rust-log
      rust-reqwest-0.11
      rust-resvg
      rust-serde
      rust-serde-json
      rust-simplelog
      rust-smart-default
      rust-tempfile
      rust-ulid
      rust-url
      rust-urlencoding
      rust-web-app-manifest             ; TODO: Undefined

      ;; Linux-specific dependencies
      rust-bzip2
      rust-glob
      rust-phf
      rust-tar


      `(,gcc "lib")))
    (home-page "https://github.com/filips123/PWAsForFirefox")
    (synopsis
     "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox")
    (description
     "A tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox.")
    (license license:mpl2.0)))
