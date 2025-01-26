(define-module (roquix packages texlab)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (guix download)
  #:use-module (gnu packages gcc)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages crates-check)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-compression)
  #:use-module (gnu packages crates-crypto)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages crates-windows)
  #:use-module (gnu packages crates-apple))

(define-public rust-ron-0.7
  (package
    (name "rust-ron")
    (version "0.7.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ron" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "06iz51r6pyi197jjpfddq8h8884y85myaswfan07cnqylqwkj1w8"))))
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

(define-public rust-linked-hash-map-0.5
  (package
    (name "rust-linked-hash-map")
    (version "0.5.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "linked-hash-map" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "03vpgw7x507g524nx5i1jf5dl8k3kv0fzg8v3ip6qqwbpkqww5q7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heapsize" ,rust-heapsize-0.4)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/contain-rs/linked-hash-map")
    (synopsis
     "A HashMap wrapper that holds key-value pairs in insertion order")
    (description
     "This package provides a HashMap wrapper that holds key-value pairs in insertion
order")
    (license (list license:expat license:asl2.0))))

(define-public rust-console-0.15
  (package
    (name "rust-console")
    (version "0.15.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "console" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0q5dwppyn1zsj5h9zjxfzah8l91y7cyw270m6hz7x9vhi6z9zmy3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-encode-unicode" ,rust-encode-unicode-0.3)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))))
    (home-page "https://github.com/console-rs/console")
    (synopsis "A terminal and console abstraction for Rust")
    (description
     "This package provides a terminal and console abstraction for Rust")
    (license license:expat)))

(define-public rust-insta-1
  (package
    (name "rust-insta")
    (version "1.26.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "insta" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1zs6vqz0b0nc3z2asxg2lcfzsgyyyyl7mdiavr29fdz48s5z1w7n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-console" ,rust-console-0.15)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-globset" ,rust-globset-0.4)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-linked-hash-map" ,rust-linked-hash-map-0.5)
                       ("rust-pest" ,rust-pest-2)
                       ("rust-pest-derive" ,rust-pest-derive-2)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-ron" ,rust-ron-0.7)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-similar" ,rust-similar-2)
                       ("rust-toml" ,rust-toml-0.5)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-yaml-rust" ,rust-yaml-rust-0.4))))
    (home-page "https://insta.rs/")
    (synopsis "A snapshot testing library for Rust")
    (description "This package provides a snapshot testing library for Rust")
    (license license:asl2.0)))

(define-public rust-env-logger-0.9
  (package
    (name "rust-env-logger")
    (version "0.9.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "env_logger" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1rq0kqpa8my6i1qcyhfqrn1g9xr5fbkwwbd42nqvlzn9qibncbm1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-atty" ,rust-atty-0.2)
                       ("rust-humantime" ,rust-humantime-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-termcolor" ,rust-termcolor-1))))
    (home-page "https://github.com/rust-cli/env_logger/")
    (synopsis
     "A logging implementation for `log` which is configured via an environment
variable.
")
    (description
     "This package provides a logging implementation for `log` which is configured via
an environment variable.")
    (license (list license:expat license:asl2.0))))

(define-public rust-assert-unordered-0.3
  (package
    (name "rust-assert-unordered")
    (version "0.3.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "assert_unordered" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0r123d4az6rhivpsymwmg0k4hn9iagp0hkhka6rkwcl1g0xk4x0w"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansi-term" ,rust-ansi-term-0.12))))
    (home-page "https://github.com/nu11ptr/assert_unordered")
    (synopsis "A direct replacement for `assert_eq` for unordered collections")
    (description
     "This package provides a direct replacement for `assert_eq` for unordered
collections")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-normalization-0.1
  (package
    (name "rust-unicode-normalization")
    (version "0.1.22")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-normalization" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "08d95g7b1irc578b2iyhzv4xhsa4pfvwsqxcl9lbcpabzkq16msw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-tinyvec" ,rust-tinyvec-1))))
    (home-page "https://github.com/unicode-rs/unicode-normalization")
    (synopsis "This crate provides functions for normalization of
Unicode strings, including Canonical and Compatible
Decomposition and Recomposition, as described in
Unicode Standard Annex #15.
")
    (description
     "This crate provides functions for normalization of Unicode strings, including
Canonical and Compatible Decomposition and Recomposition, as described in
Unicode Standard Annex #15.")
    (license (list license:expat license:asl2.0))))

(define-public rust-typed-builder-0.11
  (package
    (name "rust-typed-builder")
    (version "0.11.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "typed-builder" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "07nlizmjyya5f792qy0zdrqa4lz0ildxc34h421rxwxz1nj2d8a7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/idanarye/rust-typed-builder")
    (synopsis "Compile-time type-checked builder derive")
    (description "Compile-time type-checked builder derive")
    (license (list license:expat license:asl2.0))))

(define-public rust-joinery-2
  (package
    (name "rust-joinery")
    (version "2.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "joinery" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xg4cjnz8cd6ya9hynb9wx79ijd3j6307f47aijviqzwyml7s5kj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/Lucretiel/joinery")
    (synopsis
     "A small crate for generically joining iterators with a separator")
    (description
     "This package provides a small crate for generically joining iterators with a
separator")
    (license license:expat)))

(define-public rust-titlecase-2
  (package
    (name "rust-titlecase")
    (version "2.2.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "titlecase" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0hi0hkh2x78rvq7rhdgdzsgwcnlpvvb59hgnifsgwz01vf67lf9q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-joinery" ,rust-joinery-2)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-regex" ,rust-regex-1))))
    (home-page "https://github.com/wezm/titlecase")
    (synopsis
     "A tool and library that capitalizes text according to a style defined by John Gruber for post titles on his website Daring Fireball.")
    (description
     "This package provides a tool and library that capitalizes text according to a
style defined by John Gruber for post titles on his website Daring Fireball.")
    (license license:expat)))

(define-public rust-threadpool-1
  (package
    (name "rust-threadpool")
    (version "1.8.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "threadpool" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1amgfyzvynbm8pacniivzq9r0fh3chhs7kijic81j76l6c5ycl6h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-num-cpus" ,rust-num-cpus-1))))
    (home-page "https://github.com/rust-threadpool/rust-threadpool")
    (synopsis
     "A thread pool for running a number of jobs on a fixed set of worker threads.
")
    (description
     "This package provides a thread pool for running a number of jobs on a fixed set
of worker threads.")
    (license (list license:expat license:asl2.0))))

(define-public rust-strum-macros-0.24
  (package
    (name "rust-strum-macros")
    (version "0.24.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "strum_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0naxz2y38kwq5wgirmia64vvf6qhwy8j367rw966n62gsbh5nf0y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-rustversion" ,rust-rustversion-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/Peternator7/strum")
    (synopsis "Helpful macros for working with enums and strings")
    (description "Helpful macros for working with enums and strings")
    (license license:expat)))

(define-public rust-strum-0.24
  (package
    (name "rust-strum")
    (version "0.24.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "strum" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0gz6cjhlps5idwasznklxdh2zsas6mxf99vr0n27j876q12n0gh6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-phf" ,rust-phf-0.10)
                       ("rust-strum-macros" ,rust-strum-macros-0.24))))
    (home-page "https://github.com/Peternator7/strum")
    (synopsis "Helpful macros for working with enums and strings")
    (description "Helpful macros for working with enums and strings")
    (license license:expat)))

(define-public rust-smol-str-0.1
  (package
    (name "rust-smol-str")
    (version "0.1.23")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "smol_str" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0i5b6mm2hbmvyvch3rhfx6bfl9jmijx320ffazhs5qxp52512xbl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rust-analyzer/smol_str")
    (synopsis "small-string optimized string type with O(1) clone")
    (description "small-string optimized string type with O(1) clone")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-repr-0.1
  (package
    (name "rust-serde-repr")
    (version "0.1.10")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_repr" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0knbzc87nlrfnm1jh3zmx77hxflnzk0xl8xcv7jvn3m2fkxcjpls"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/dtolnay/serde-repr")
    (synopsis
     "Derive Serialize and Deserialize that delegates to the underlying repr of a C-like enum.")
    (description
     "Derive Serialize and Deserialize that delegates to the underlying repr of a
C-like enum.")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-regex-1
  (package
    (name "rust-serde-regex")
    (version "1.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_regex" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1pxsnxb8c198szghk1hvzvhva36w2q5zs70hqkmdf5d89qd6y4x8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/tailhook/serde-regex")
    (synopsis "    A serde wrapper that (de)serializes regex as strings
")
    (description
     "This package provides a serde wrapper that (de)serializes regex as strings")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-millis-0.1
  (package
    (name "rust-serde-millis")
    (version "0.1.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_millis" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "002d8dk3fwidh5j44aixjbzw80q24w0d208xklv2rvm51iwdrqp6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/tailhook/serde-millis")
    (synopsis
     "    A serde wrapper that stores integer millisecond value for timestamps
    and durations (used similarly to serde_bytes)
")
    (description
     "This package provides a serde wrapper that stores integer millisecond value for
timestamps and durations (used similarly to serde_bytes)")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-json-1
  (package
    (name "rust-serde-json")
    (version "1.0.91")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_json" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "10v8vb4959ayycw1zmqvxxi758djqkskchj6qal0fjbi6daj6z47"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/serde-rs/json")
    (synopsis "A JSON serialization file format")
    (description "This package provides a JSON serialization file format")
    (license (list license:expat license:asl2.0))))

(define-public rust-countme-3
  (package
    (name "rust-countme")
    (version "3.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "countme" version))
       (file-name
        (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "10z4r1xx77sr8axp3lsgc0azidazwgnhpzig2gcx5dfrdl66wx03"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs
       (("rust-dashmap" ,rust-dashmap-4)
        ("rust-once-cell" ,rust-once-cell-1)
        ("rust-rustc-hash" ,rust-rustc-hash-1))))
    (home-page "https://github.com/matklad/countme")
    (synopsis
     "Counts the number of live instances of types")
    (description
     "This package provides a counts the number of live instances of types.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rowan-0.15
  (package
    (name "rust-rowan")
    (version "0.15.10")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rowan" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0cpkf6m93kkwhhy5459x3w80mms01nqym34cwhzr07m3gdz584aq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-countme" ,rust-countme-3)
                       ("rust-hashbrown" ,rust-hashbrown-0.12)
                       ("rust-memoffset" ,rust-memoffset-0.6)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-text-size" ,rust-text-size-1))))
    (home-page "https://github.com/rust-analyzer/rowan")
    (synopsis "Library for generic lossless syntax trees")
    (description "Library for generic lossless syntax trees")
    (license (list license:expat license:asl2.0))))

(define-public rust-regex-1
  (package
    (name "rust-regex")
    (version "1.7.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "regex" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0czp6hxg02lm02hvlhp9xjkd65cjcagw119crnaznwd5idsabaj8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-aho-corasick" ,rust-aho-corasick-0.7)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.6))))
    (home-page "https://github.com/rust-lang/regex")
    (synopsis
     "An implementation of regular expressions for Rust. This implementation uses
finite automata and guarantees linear time matching on all inputs.
")
    (description
     "An implementation of regular expressions for Rust.  This implementation uses
finite automata and guarantees linear time matching on all inputs.")
    (license (list license:expat license:asl2.0))))

(define-public rust-petgraph-0.6
  (package
    (name "rust-petgraph")
    (version "0.6.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "petgraph" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0hw1i1s49f82sg34ngfhgmg8qraa7d26gak2rrwiacx1ad103mg6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fixedbitset" ,rust-fixedbitset-0.4)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-quickcheck" ,rust-quickcheck-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://github.com/petgraph/petgraph")
    (synopsis
     "Graph data structure library. Provides graph types and graph algorithms.")
    (description
     "Graph data structure library.  Provides graph types and graph algorithms.")
    (license (list license:expat license:asl2.0))))

(define-public rust-once-cell-1
  (package
    (name "rust-once-cell")
    (version "1.17.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "once_cell" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0rpackaf6ljxkcaa3svaiak1ddsbh0hqf5z3l7bb78hyfjhznqbg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-atomic-polyfill" ,rust-atomic-polyfill-1)
                       ("rust-critical-section" ,rust-critical-section-1)
                       ("rust-parking-lot-core" ,rust-parking-lot-core-0.9))))
    (home-page "https://github.com/matklad/once_cell")
    (synopsis "Single assignment cells and lazy values.")
    (description "Single assignment cells and lazy values.")
    (license (list license:expat license:asl2.0))))

(define-public rust-notify-5
  (package
    (name "rust-notify")
    (version "5.0.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "notify" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "02j9pxil0nf766dyj4ha0ss428s07qjkbmh19h11rbmb13d6cb7d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-filetime" ,rust-filetime-0.2)
                       ("rust-fsevent-sys" ,rust-fsevent-sys-4)
                       ("rust-inotify" ,rust-inotify-0.9)
                       ("rust-kqueue" ,rust-kqueue-1)
                       ("rust-kqueue" ,rust-kqueue-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/notify-rs/notify")
    (synopsis "Cross-platform filesystem notification library")
    (description "Cross-platform filesystem notification library")
    (license (list license:cc0 license:artistic2.0))))

(define-public rust-lsp-types-0.93
  (package
    (name "rust-lsp-types")
    (version "0.93.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "lsp-types" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0lfawrvxq3k6jpblyikfvzh1759zf3zpl39pfhcnb3yiwb3ykrlv"))))
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
     "Types for interaction with a language server, using VSCode's Language Server
Protocol")
    (license license:expat)))

(define-public rust-lsp-server-0.6
  (package
    (name "rust-lsp-server")
    (version "0.6.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "lsp-server" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0nkp6sy5dmvishsg5rjvv3q57h87ald21zmq5506bxlwqb0p01gp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page
     "https://github.com/rust-lang/rust-analyzer/tree/master/lib/lsp-server")
    (synopsis "Generic LSP server scaffold.")
    (description "Generic LSP server scaffold.")
    (license (list license:expat license:asl2.0))))

(define-public rust-logos-derive-0.12
  (package
    (name "rust-logos-derive")
    (version "0.12.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "logos-derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0v295x78vcskab88hshl530w9d1vn61cmlaic4d6dydsila4kn51"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-beef" ,rust-beef-0.5)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.6)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/maciejhirsz/logos")
    (synopsis "Create ridiculously fast Lexers")
    (description "Create ridiculously fast Lexers")
    (license (list license:expat license:asl2.0))))

(define-public rust-logos-0.12
  (package
    (name "rust-logos")
    (version "0.12.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "logos" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1w82qm3hck5cr6ax3j3yzrpf4zzbffahz126ahyqwyn6h8b072xz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-logos-derive" ,rust-logos-derive-0.12))))
    (home-page "https://github.com/maciejhirsz/logos")
    (synopsis "Create ridiculously fast Lexers")
    (description "Create ridiculously fast Lexers")
    (license (list license:expat license:asl2.0))))

(define-public rust-itertools-0.10
  (package
    (name "rust-itertools")
    (version "0.10.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "itertools" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ww45h7nxx5kj6z2y6chlskxd1igvs4j507anr6dzg99x1h25zdh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1))))
    (home-page "https://github.com/rust-itertools/itertools")
    (synopsis
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (description
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-isocountry-0.3
  (package
    (name "rust-isocountry")
    (version "0.3.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "isocountry" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "011y6sb6rs2i85g2jvifx5s54clw7nprinzzhfx08jgvy15xr88y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://github.com/sifton/isocountry-rs")
    (synopsis "ISO 3166-1 enumeration for Rust")
    (description "ISO 3166-1 enumeration for Rust")
    (license license:expat)))

(define-public rust-unidecode-0.3
  (package
    (name "rust-unidecode")
    (version "0.3.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unidecode" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1p0sm8j9223kw3iincv60s746s88k09xcaqf8nkx3w83isfv2as0"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/chowdhurya/rust-unidecode/")
    (synopsis "Provides pure ASCII transliterations of Unicode strings.")
    (description
     "This package provides pure ASCII transliterations of Unicode strings.")
    (license license:bsd-3)))

(define-public rust-unicode-segmentation-1
  (package
    (name "rust-unicode-segmentation")
    (version "1.10.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-segmentation" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0nks0izrlfrc26hkbs3v3rdjk7lkrflffv2ajhgf0gbql19g1nqg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/unicode-rs/unicode-segmentation")
    (synopsis
     "This crate provides Grapheme Cluster, Word and Sentence boundaries
according to Unicode Standard Annex #29 rules.
")
    (description
     "This crate provides Grapheme Cluster, Word and Sentence boundaries according to
Unicode Standard Annex #29 rules.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-case-mapping-0.4
  (package
    (name "rust-unicode-case-mapping")
    (version "0.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "unicode-case-mapping" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17rrnk7vbk995qdcm0jdj0hhslrvx59s7bzx41i5pg7zc8f3jsli"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/yeslogic/unicode-case-mapping")
    (synopsis
     "Fast lowercase, uppercase, and titlecase mapping for characters")
    (description
     "Fast lowercase, uppercase, and titlecase mapping for characters")
    (license license:asl2.0)))

(define-public rust-smallstr-0.3
  (package
    (name "rust-smallstr")
    (version "0.3.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "smallstr" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17fzs6nnp4hj5b002v11f0gsypdhm8qmzcfhvvw5yww0ygysxcb3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-smallvec" ,rust-smallvec-1))))
    (home-page "https://github.com/murarth/smallstr")
    (synopsis "String-like container based on smallvec")
    (description "String-like container based on smallvec")
    (license (list license:expat license:asl2.0))))

(define-public rust-phf-codegen-0.11
  (package
    (name "rust-phf-codegen")
    (version "0.11.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf_codegen" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0w274bcqbz499vpvd7isb252bc5mxmj9kagapn5mkjp3qn8chsm5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-phf-generator" ,rust-phf-generator-0.11)
                       ("rust-phf-shared" ,rust-phf-shared-0.11))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "Codegen library for PHF types")
    (description "Codegen library for PHF types")
    (license license:expat)))

(define-public rust-phf-shared-0.11
  (package
    (name "rust-phf-shared")
    (version "0.11.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf_shared" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0xp6krf3cd411rz9rbk7p6xprlz786a215039j6jlxvbh9pmzyz1"))))
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

(define-public rust-criterion-0.3
  (package
    (name "rust-criterion")
    (version "0.3.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "criterion" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "13yd64ah93gkbdv7qq4cr6rhgl9979jjcjk3gkhnav1b7glns7dh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-atty" ,rust-atty-0.2)
                       ("rust-cast" ,rust-cast-0.3)
                       ("rust-clap" ,rust-clap-2)
                       ("rust-criterion-plot" ,rust-criterion-plot-0.4)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-oorandom" ,rust-oorandom-11)
                       ("rust-plotters" ,rust-plotters-0.3)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-cbor" ,rust-serde-cbor-0.11)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smol" ,rust-smol-1)
                       ("rust-tinytemplate" ,rust-tinytemplate-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://bheisler.github.io/criterion.rs/book/index.html")
    (synopsis "Statistics-driven micro-benchmarking library")
    (description "Statistics-driven micro-benchmarking library")
    (license (list license:asl2.0 license:expat))))

(define-public rust-phf-generator-0.11
  (package
    (name "rust-phf-generator")
    (version "0.11.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf_generator" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1gsgy5k45y937qnwp58dc05d63lwlfm3imqr1zslb8qgb2a1q65i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-criterion" ,rust-criterion-0.3)
                       ("rust-phf-shared" ,rust-phf-shared-0.11)
                       ("rust-rand" ,rust-rand-0.8))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "PHF generation logic")
    (description "PHF generation logic")
    (license license:expat)))

(define-public rust-phf-macros-0.11
  (package
    (name "rust-phf-macros")
    (version "0.11.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf_macros" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0rncvjimjri2vancig85icbk8h03a5s3z4cyasd70s37y72wvalj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-phf-generator" ,rust-phf-generator-0.11)
                       ("rust-phf-shared" ,rust-phf-shared-0.11)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1)
                       ("rust-unicase" ,rust-unicase-2))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "Macros to generate types in the phf crate")
    (description "Macros to generate types in the phf crate")
    (license license:expat)))

(define-public rust-phf-0.11
  (package
    (name "rust-phf")
    (version "0.11.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "phf" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1354fbpb52cp9gs5mlkaygc5qhdx6r07rfv3xy482m4kvqsnb34j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-phf-macros" ,rust-phf-macros-0.11)
                       ("rust-phf-shared" ,rust-phf-shared-0.11)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "Runtime support for perfect hash function data structures")
    (description "Runtime support for perfect hash function data structures")
    (license license:expat)))

(define-public rust-human-name-2
  (package
    (name "rust-human-name")
    (version "2.0.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "human_name" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0pi5fchnsx1r5mvb1v32iqnafh0xg036bcdb642p416vhb77xbs2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-phf-codegen" ,rust-phf-codegen-0.11)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smallstr" ,rust-smallstr-0.3)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-unicode-case-mapping" ,rust-unicode-case-mapping-0.4)
                       ("rust-unicode-normalization" ,rust-unicode-normalization-0.1)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-unidecode" ,rust-unidecode-0.3))))
    (home-page "https://github.com/djudd/human-name")
    (synopsis "A library for parsing and comparing human names")
    (description
     "This package provides a library for parsing and comparing human names")
    (license license:asl2.0)))

(define-public rust-miniz-oxide-0.6
  (package
    (name "rust-miniz-oxide")
    (version "0.6.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "miniz_oxide" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1yp8z6yll5ypz1ldmgnv7zi0r78kbvmqmn2mii77jzmk5069axdj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-adler" ,rust-adler-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-simd-adler32" ,rust-simd-adler32-0.3))))
    (home-page "https://github.com/Frommi/miniz_oxide/tree/master/miniz_oxide")
    (synopsis
     "DEFLATE compression and decompression library rewritten in Rust based on miniz")
    (description
     "DEFLATE compression and decompression library rewritten in Rust based on miniz")
    (license (list license:expat license:zlib license:asl2.0))))

(define-public rust-libz-sys-1
  (package
    (name "rust-libz-sys")
    (version "1.1.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libz-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1gqb8nk7j4ngvlcll8plm2fvjwic40p2g4qp20pwry1m74f7c0lp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-cmake" ,rust-cmake-0.1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-pkg-config" ,rust-pkg-config-0.3)
                       ("rust-vcpkg" ,rust-vcpkg-0.2))))
    (home-page "https://github.com/rust-lang/libz-sys")
    (synopsis
     "Low-level bindings to the system libz library (also known as zlib).")
    (description
     "Low-level bindings to the system libz library (also known as zlib).")
    (license (list license:expat license:asl2.0))))

(define-public rust-libz-ng-sys-1
  (package
    (name "rust-libz-ng-sys")
    (version "1.1.8")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libz-ng-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1wp0aya5hh76h1acspvrrsvq2fl0kyb8dpi6wy0zaswnm6bax6a3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cmake" ,rust-cmake-0.1)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/rust-lang/libz-sys")
    (synopsis
     "Low-level bindings to zlib-ng (libz-ng), a high-performance zlib library.")
    (description
     "Low-level bindings to zlib-ng (libz-ng), a high-performance zlib library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-flate2-1
  (package
    (name "rust-flate2")
    (version "1.0.25")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "flate2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0hg8ih51lx5xkz2zlzpsy1j1xka8gs8vhk2964ppgj5ighwxp8m8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cloudflare-zlib-sys" ,rust-cloudflare-zlib-sys-0.3)
                       ("rust-crc32fast" ,rust-crc32fast-1)
                       ("rust-libz-ng-sys" ,rust-libz-ng-sys-1)
                       ("rust-libz-sys" ,rust-libz-sys-1)
                       ("rust-miniz-oxide" ,rust-miniz-oxide-0.6))))
    (home-page "https://github.com/rust-lang/flate2-rs")
    (synopsis
     "DEFLATE compression and decompression exposed as Read/BufRead/Write streams.
Supports miniz_oxide and multiple zlib implementations. Supports zlib, gzip,
and raw deflate streams.
")
    (description
     "DEFLATE compression and decompression exposed as Read/BufRead/Write streams.
Supports miniz_oxide and multiple zlib implementations.  Supports zlib, gzip,
and raw deflate streams.")
    (license (list license:expat license:asl2.0))))

(define-public rust-syslog-6
  (package
    (name "rust-syslog")
    (version "6.0.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "syslog" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1k0snk06c3gzq8g6kkqvpbbh5zg64nkzdjc303jda2hmd364904p"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-error-chain" ,rust-error-chain-0.12)
                       ("rust-hostname" ,rust-hostname-0.3)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-time" ,rust-time-0.3))))
    (home-page "https://github.com/Geal/rust-syslog")
    (synopsis "Send log messages to syslog")
    (description "Send log messages to syslog")
    (license license:expat)))

(define-public rust-reopen-1
  (package
    (name "rust-reopen")
    (version "1.0.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "reopen" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "14w2v7a4dav23jzfrxj9lgacp731xizvng4bn7slan7qmk1wwhpz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-signal-hook" ,rust-signal-hook-0.3))))
    (home-page "https://github.com/vorner/reopen")
    (synopsis "File reopening utility")
    (description "File reopening utility")
    (license (list license:asl2.0 license:expat))))

(define-public rust-fern-0.6
  (package
    (name "rust-fern")
    (version "0.6.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "fern" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ahys5fmc10vcgf6yyai0jiypl8pqwidydhqkbp7jph79447pp9v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-chrono" ,rust-chrono-0.4)
                       ("rust-colored" ,rust-colored-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-reopen" ,rust-reopen-0.3)
                       ("rust-reopen" ,rust-reopen-1)
                       ("rust-syslog" ,rust-syslog-3)
                       ("rust-syslog" ,rust-syslog-4)
                       ("rust-syslog" ,rust-syslog-6))))
    (home-page "https://github.com/daboross/fern")
    (synopsis "Simple, efficient logging")
    (description "Simple, efficient logging")
    (license license:expat)))

(define-public rust-encoding-rs-0.8
  (package
    (name "rust-encoding-rs")
    (version "0.8.31")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "encoding_rs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0azc6rblf75vd862ymjahdfch27j1sshb7zynshrx7ywi5an6llq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-packed-simd-2" ,rust-packed-simd-2-0.3)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://docs.rs/encoding_rs/")
    (synopsis "A Gecko-oriented implementation of the Encoding Standard")
    (description
     "This package provides a Gecko-oriented implementation of the Encoding Standard")
    (license (list license:bsd-3))))

(define-public rust-proc-macro2-1
  (package
    (name "rust-proc-macro2")
    (version "1.0.50")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "proc-macro2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1qmsy8372anynndlfa0qig5y73gjnyvxldsrxs52vbygx9xxbxvf"))))
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

(define-public rust-syn-1
  (package
    (name "rust-syn")
    (version "1.0.107")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "syn" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xg3315vx8civ8y0l5zxq5mkx07qskaqwnjak18aw0vfn6sn8h0z"))))
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

(define-public rust-serde-derive-1
  (package
    (name "rust-serde-derive")
    (version "1.0.152")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "07jlbk3khspawlqayr5lhzgqirv031ap4p8asw199l7ciq8psj5g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://serde.rs")
    (synopsis "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (description
     "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-1
  (package
    (name "rust-serde")
    (version "1.0.152")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ysykpc4a9f1yn7zikdwhyfs0bpa7mlc8vsm7sl4glr1606iyzdv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://serde.rs")
    (synopsis "A generic serialization/deserialization framework")
    (description
     "This package provides a generic serialization/deserialization framework")
    (license (list license:expat license:asl2.0))))

(define-public rust-crossbeam-deque-0.8
  (package
    (name "rust-crossbeam-deque")
    (version "0.8.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "crossbeam-deque" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1z6ifz35lyk0mw818xcl3brgss2k8islhgdmfk9s5fwjnr982pki"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-crossbeam-epoch" ,rust-crossbeam-epoch-0.9)
                       ("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8))))
    (home-page
     "https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-deque")
    (synopsis "Concurrent work-stealing deque")
    (description "Concurrent work-stealing deque")
    (license (list license:expat license:asl2.0))))

(define-public rust-rayon-core-1
  (package
    (name "rust-rayon-core")
    (version "1.10.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rayon-core" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0nw3ds7agdc9a3swyjhzw9ndr60ic54apk8108676kwmy4jhcsim"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-crossbeam-deque" ,rust-crossbeam-deque-0.8)
                       ("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8)
                       ("rust-num-cpus" ,rust-num-cpus-1))))
    (home-page "https://github.com/rayon-rs/rayon")
    (synopsis "Core APIs for Rayon")
    (description "Core APIs for Rayon")
    (license (list license:expat license:asl2.0))))

(define-public rust-rayon-1
  (package
    (name "rust-rayon")
    (version "1.6.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rayon" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1dsr0yyfgdsg8ggh37kq678mfa5j3js6p16ksb7knazhml9s5cvd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1)
                       ("rust-rayon-core" ,rust-rayon-core-1))))
    (home-page "https://github.com/rayon-rs/rayon")
    (synopsis "Simple work-stealing parallelism for Rust")
    (description "Simple work-stealing parallelism for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-lock-api-0.4
  (package
    (name "rust-lock-api")
    (version "0.4.9")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "lock_api" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1py41vk243hwk345nhkn5nw0bd4m03gzjmprdjqq6rg5dwv12l23"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-owning-ref" ,rust-owning-ref-0.4)
                       ("rust-scopeguard" ,rust-scopeguard-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Amanieu/parking_lot")
    (synopsis
     "Wrappers to create fully-featured Mutex and RwLock types. Compatible with no_std.")
    (description
     "Wrappers to create fully-featured Mutex and RwLock types.  Compatible with
no_std.")
    (license (list license:expat license:asl2.0))))

(define-public rust-dashmap-5
  (package
    (name "rust-dashmap")
    (version "5.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "dashmap" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1p2f5kr5hy7h4w3y2abprnxsaq36r685zfx1s8v0nfw2vbgpcw4h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.12)
                       ("rust-lock-api" ,rust-lock-api-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-parking-lot-core" ,rust-parking-lot-core-0.9)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/xacrimon/dashmap")
    (synopsis "Blazing fast concurrent HashMap for Rust.")
    (description "Blazing fast concurrent HashMap for Rust.")
    (license license:expat)))

(define-public rust-linux-raw-sys-0.1
  (package
    (name "rust-linux-raw-sys")
    (version "0.1.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "linux-raw-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1926520si5wkn4m6iz6ka97ya5q1dgr8ib3fd705fscfgixgflgh"))))
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

(define-public rust-rustix-0.36
  (package
    (name "rust-rustix")
    (version "0.36.7")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustix" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "00qvr05clvkp5h228bg42rxiw1fr1vi65r0imfwzpdwmng2fpzfl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-errno" ,rust-errno-0.2)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))))
    (home-page "https://github.com/bytecodealliance/rustix")
    (synopsis "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (description
     "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-io-lifetimes-1
  (package
    (name "rust-io-lifetimes")
    (version "1.0.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "io-lifetimes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17lfpl3p4ja0l217zkhgjqssyg1ris9imbc46ka9wjqvr7wcdmp7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-fs-err" ,rust-fs-err-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-os-pipe" ,rust-os-pipe-1)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))))
    (home-page "https://github.com/sunfishcode/io-lifetimes")
    (synopsis "A low-level I/O ownership and borrowing library")
    (description
     "This package provides a low-level I/O ownership and borrowing library")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-hermit-abi-0.2
  (package
    (name "rust-hermit-abi")
    (version "0.2.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hermit-abi" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1iz439yz9qzk3rh9pqx2rz5c4107v3qbd7bppfsbzb1mzr02clgf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/hermitcore/rusty-hermit")
    (synopsis
     "hermit-abi is small interface to call functions from the unikernel RustyHermit.
It is used to build the target `x86_64-unknown-hermit`.
")
    (description
     "hermit-abi is small interface to call functions from the unikernel RustyHermit.
It is used to build the target `x86_64-unknown-hermit`.")
    (license (list license:expat license:asl2.0))))

(define-public rust-is-terminal-0.4
  (package
    (name "rust-is-terminal")
    (version "0.4.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "is-terminal" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12c11c8iv2wwyadzajzffmy1fy9nphdpvdj54d367k0c234bdpr8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hermit-abi" ,rust-hermit-abi-0.2)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-1)
                       ("rust-rustix" ,rust-rustix-0.36)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))))
    (home-page "https://github.com/sunfishcode/is-terminal")
    (synopsis "Test whether a given stream is a terminal")
    (description "Test whether a given stream is a terminal")
    (license license:expat)))


(define-public rust-toml-datetime-0.5
  (package
    (name "rust-toml-datetime")
    (version "0.5.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "toml_datetime" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xcw3kyklh3s2gxp65ma26rgkl7505la4xx1r55kfgcfmikz8ls5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/toml-rs/toml")
    (synopsis "A TOML-compatible datetime type")
    (description "This package provides a TOML-compatible datetime type")
    (license (list license:expat license:asl2.0))))

(define-public rust-nom8-0.2
  (package
    (name "rust-nom8")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "nom8" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1y6jzabxyrl05vxnh63r66ac2fh0symg5fnynxm4ii3zkif580df"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-memchr" ,rust-memchr-2))))
    (home-page "https://github.com/epage/nom-experimental")
    (synopsis
     "A byte-oriented, zero-copy, parser combinators library (fork for proposals for v8)")
    (description
     "This package provides a byte-oriented, zero-copy, parser combinators library
(fork for proposals for v8)")
    (license license:expat)))

(define-public rust-itertools-0.10
  (package
    (name "rust-itertools")
    (version "0.10.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "itertools" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ww45h7nxx5kj6z2y6chlskxd1igvs4j507anr6dzg99x1h25zdh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-either" ,rust-either-1))))
    (home-page "https://github.com/rust-itertools/itertools")
    (synopsis
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (description
     "Extra iterator adaptors, iterator methods, free functions, and macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustc-rayon-core-0.4
  (package
    (name "rust-rustc-rayon-core")
    (version "0.4.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustc-rayon-core" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0c4cf58056ya3282c24bnyq39cwm1rd1m96lymfbb6yvl12929h2"))))
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

(define-public rust-crossbeam-deque-0.8
  (package
    (name "rust-crossbeam-deque")
    (version "0.8.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "crossbeam-deque" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1z6ifz35lyk0mw818xcl3brgss2k8islhgdmfk9s5fwjnr982pki"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-crossbeam-epoch" ,rust-crossbeam-epoch-0.9)
                       ("rust-crossbeam-utils" ,rust-crossbeam-utils-0.8))))
    (home-page
     "https://github.com/crossbeam-rs/crossbeam/tree/master/crossbeam-deque")
    (synopsis "Concurrent work-stealing deque")
    (description "Concurrent work-stealing deque")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustc-rayon-0.4
  (package
    (name "rust-rustc-rayon")
    (version "0.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustc-rayon" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ykjr1i56jmi8ykkcr7x555wnxki1vsi703mz6n2x7k0naqg0y8s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-autocfg" ,rust-autocfg-1)
                       ("rust-crossbeam-deque" ,rust-crossbeam-deque-0.8)
                       ("rust-either" ,rust-either-1)
                       ("rust-rustc-rayon-core" ,rust-rustc-rayon-core-0.4))))
    (home-page "https://github.com/rust-lang/rustc-rayon")
    (synopsis "Simple work-stealing parallelism for Rust - fork for rustc")
    (description "Simple work-stealing parallelism for Rust - fork for rustc")
    (license (list license:expat license:asl2.0))))

(define-public rust-indexmap-1
  (package
    (name "rust-indexmap")
    (version "1.9.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "indexmap" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "16dkr2h5p379jcr8rnb420396yvzid2myirc2w70zcf43yffg18q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-autocfg" ,rust-autocfg-1)
                       ("rust-hashbrown" ,rust-hashbrown-0.12)
                       ("rust-quickcheck" ,rust-quickcheck-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-rustc-rayon" ,rust-rustc-rayon-0.4)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/bluss/indexmap")
    (synopsis "A hash table with consistent order and fast iteration.")
    (description
     "This package provides a hash table with consistent order and fast iteration.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-toml-edit-0.17
  (package
    (name "rust-toml-edit")
    (version "0.17.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "toml_edit" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1insqwmqj73mbrlnyq578sxq12qky9nn5agdp647xzay6iccak53"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-1)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-kstring" ,rust-kstring-2)
                       ("rust-nom8" ,rust-nom8-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-toml-datetime" ,rust-toml-datetime-0.5))))
    (home-page "https://github.com/ordian/toml_edit")
    (synopsis "Yet another format-preserving TOML parser.")
    (description "Yet another format-preserving TOML parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-json-1
  (package
    (name "rust-serde-json")
    (version "1.0.91")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_json" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "10v8vb4959ayycw1zmqvxxi758djqkskchj6qal0fjbi6daj6z47"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-indexmap" ,rust-indexmap-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-ryu" ,rust-ryu-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/serde-rs/json")
    (synopsis "A JSON serialization file format")
    (description "This package provides a JSON serialization file format")
    (license (list license:expat license:asl2.0))))

(define-public rust-threadpool-1
  (package
    (name "rust-threadpool")
    (version "1.8.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "threadpool" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1amgfyzvynbm8pacniivzq9r0fh3chhs7kijic81j76l6c5ycl6h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-num-cpus" ,rust-num-cpus-1))))
    (home-page "https://github.com/rust-threadpool/rust-threadpool")
    (synopsis
     "A thread pool for running a number of jobs on a fixed set of worker threads.
")
    (description
     "This package provides a thread pool for running a number of jobs on a fixed set
of worker threads.")
    (license (list license:expat license:asl2.0))))

(define-public rust-libtest-mimic-0.6
  (package
    (name "rust-libtest-mimic")
    (version "0.6.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "libtest-mimic" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1yipifm9fgfg6my2jj3i5wrc6ri9wqix02fys0isplb7cx8h7dnp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clap" ,rust-clap-4)
                       ("rust-termcolor" ,rust-termcolor-1)
                       ("rust-threadpool" ,rust-threadpool-1))))
    (home-page "https://github.com/LukasKalbertodt/libtest-mimic")
    (synopsis
     "Write your own test harness that looks and behaves like the built-in test harness used by `rustc --test`
")
    (description
     "Write your own test harness that looks and behaves like the built-in test
harness used by `rustc --test`")
    (license (list license:expat license:asl2.0))))

(define-public rust-litrs-0.2
  (package
    (name "rust-litrs")
    (version "0.2.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "litrs" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1akrxglqv6dz41jrjr409pjjysd00z5w0949007v52yg6c4mw9zr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1))))
    (home-page "https://github.com/LukasKalbertodt/litrs/")
    (synopsis
     "Parse and inspect Rust literals (i.e. tokens in the Rust programming language
representing fixed values). Particularly useful for proc macros, but can also
be used outside of a proc-macro context.
")
    (description
     "Parse and inspect Rust literals (i.e.  tokens in the Rust programming language
representing fixed values).  Particularly useful for proc macros, but can also
be used outside of a proc-macro context.")
    (license (list license:expat license:asl2.0))))

(define-public rust-document-features-0.2
  (package
    (name "rust-document-features")
    (version "0.2.7")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "document-features" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0mv1xg386as8zndw6kdgs4bwxwwlg42srdhkmgf00zz1zirwb4z4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-litrs" ,rust-litrs-0.2))))
    (home-page "https://slint-ui.com")
    (synopsis
     "Extract documentation for the feature flags from comments in Cargo.toml")
    (description
     "Extract documentation for the feature flags from comments in Cargo.toml")
    (license (list license:expat license:asl2.0))))

(define-public rust-concolor-query-0.1
  (package
    (name "rust-concolor-query")
    (version "0.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "concolor-query" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "05ykng7pqhm7840yh07r27p90flwrrmwlk32wxbgdp6mncs0gac2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/rust-cli/concolor")
    (synopsis "Look up colored console capabilities")
    (description "Look up colored console capabilities")
    (license (list license:expat license:asl2.0))))

(define-public rust-concolor-0.0.11
  (package
    (name "rust-concolor")
    (version "0.0.11")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "concolor" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "05ja8yy5ar34k2cplk0qp1d8qabxzj16mb8jn8790fivwwb6r39i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-concolor-query" ,rust-concolor-query-0.1)
                       ("rust-is-terminal" ,rust-is-terminal-0.4))))
    (home-page "https://github.com/rust-cli/concolor")
    (synopsis "Control console coloring across all dependencies")
    (description "Control console coloring across all dependencies")
    (license (list license:expat license:asl2.0))))

(define-public rust-snapbox-0.4
  (package
    (name "rust-snapbox")
    (version "0.4.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "snapbox" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xdwlqn9wr9iycw52yx2z9kcc3gqclyai1kr0h05lvg7cmdfvv1l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-concolor" ,rust-concolor-0.0.11)
                       ("rust-content-inspector" ,rust-content-inspector-0.2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-dunce" ,rust-dunce-1)
                       ("rust-filetime" ,rust-filetime-0.2)
                       ("rust-ignore" ,rust-ignore-0.4)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libtest-mimic" ,rust-libtest-mimic-0.6)
                       ("rust-normalize-line-endings" ,rust-normalize-line-endings-0.3)
                       ("rust-os-pipe" ,rust-os-pipe-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-similar" ,rust-similar-2)
                       ("rust-snapbox-macros" ,rust-snapbox-macros-0.3)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-wait-timeout" ,rust-wait-timeout-0.2)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-windows-sys" ,rust-windows-sys-0.42)
                       ("rust-yansi" ,rust-yansi-0.5))))
    (home-page "https://github.com/assert-rs/trycmd/tree/main/crates/snapbox")
    (synopsis "Snapshot testing toolbox")
    (description "Snapshot testing toolbox")
    (license (list license:expat license:asl2.0))))

(define-public rust-trycmd-0.14
  (package
    (name "rust-trycmd")
    (version "0.14.10")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "trycmd" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1b3kaznam4m6qhkw96vzpdzqpa5256gxrqg7r95cs62x68hjsrh1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-escargot" ,rust-escargot-0.5)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-humantime" ,rust-humantime-2)
                       ("rust-humantime-serde" ,rust-humantime-serde-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-schemars" ,rust-schemars-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-shlex" ,rust-shlex-1)
                       ("rust-snapbox" ,rust-snapbox-0.4)
                       ("rust-toml-edit" ,rust-toml-edit-0.17))))
    (home-page "https://github.com/assert-rs/trycmd")
    (synopsis "Snapshot testing for a herd of CLI tests")
    (description "Snapshot testing for a herd of CLI tests")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-macro2-1
  (package
    (name "rust-proc-macro2")
    (version "1.0.50")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "proc-macro2" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1qmsy8372anynndlfa0qig5y73gjnyvxldsrxs52vbygx9xxbxvf"))))
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

(define-public rust-syn-1
  (package
    (name "rust-syn")
    (version "1.0.107")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "syn" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1xg3315vx8civ8y0l5zxq5mkx07qskaqwnjak18aw0vfn6sn8h0z"))))
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

(define-public rust-serde-derive-1
  (package
    (name "rust-serde-derive")
    (version "1.0.152")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "07jlbk3khspawlqayr5lhzgqirv031ap4p8asw199l7ciq8psj5g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://serde.rs")
    (synopsis "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (description
     "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-1
  (package
    (name "rust-serde")
    (version "1.0.152")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "serde" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ysykpc4a9f1yn7zikdwhyfs0bpa7mlc8vsm7sl4glr1606iyzdv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://serde.rs")
    (synopsis "A generic serialization/deserialization framework")
    (description
     "This package provides a generic serialization/deserialization framework")
    (license (list license:expat license:asl2.0))))

(define-public rust-trybuild-1
  (package
    (name "rust-trybuild")
    (version "1.0.76")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "trybuild" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1dkxdmw98n1k20x8b10lp4d8wp6mhmd2c51nsga4c5grarwwblkf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-dissimilar" ,rust-dissimilar-1)
                       ("rust-glob" ,rust-glob-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-termcolor" ,rust-termcolor-1)
                       ("rust-toml" ,rust-toml-0.5))))
    (home-page "https://github.com/dtolnay/trybuild")
    (synopsis "Test harness for ui tests of compiler diagnostics")
    (description "Test harness for ui tests of compiler diagnostics")
    (license (list license:expat license:asl2.0))))

(define-public rust-linux-raw-sys-0.1
  (package
    (name "rust-linux-raw-sys")
    (version "0.1.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "linux-raw-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1926520si5wkn4m6iz6ka97ya5q1dgr8ib3fd705fscfgixgflgh"))))
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

(define-public rust-rustix-0.36
  (package
    (name "rust-rustix")
    (version "0.36.7")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rustix" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "00qvr05clvkp5h228bg42rxiw1fr1vi65r0imfwzpdwmng2fpzfl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1)
                       ("rust-cc" ,rust-cc-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-errno" ,rust-errno-0.2)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-1)
                       ("rust-itoa" ,rust-itoa-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-linux-raw-sys" ,rust-linux-raw-sys-0.1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))))
    (home-page "https://github.com/bytecodealliance/rustix")
    (synopsis "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (description
     "Safe Rust bindings to POSIX/Unix/Linux/Winsock2-like syscalls")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-io-lifetimes-1
  (package
    (name "rust-io-lifetimes")
    (version "1.0.4")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "io-lifetimes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17lfpl3p4ja0l217zkhgjqssyg1ris9imbc46ka9wjqvr7wcdmp7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-std" ,rust-async-std-1)
                       ("rust-fs-err" ,rust-fs-err-2)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-mio" ,rust-mio-0.8)
                       ("rust-os-pipe" ,rust-os-pipe-1)
                       ("rust-socket2" ,rust-socket2-0.4)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))))
    (home-page "https://github.com/sunfishcode/io-lifetimes")
    (synopsis "A low-level I/O ownership and borrowing library")
    (description
     "This package provides a low-level I/O ownership and borrowing library")
    (license (list license:asl2.0 license:asl2.0
                   license:expat))))

(define-public rust-hermit-abi-0.2
  (package
    (name "rust-hermit-abi")
    (version "0.2.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "hermit-abi" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1iz439yz9qzk3rh9pqx2rz5c4107v3qbd7bppfsbzb1mzr02clgf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-rustc-std-workspace-alloc" ,rust-rustc-std-workspace-alloc-1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1))))
    (home-page "https://github.com/hermitcore/rusty-hermit")
    (synopsis
     "hermit-abi is small interface to call functions from the unikernel RustyHermit.
It is used to build the target `x86_64-unknown-hermit`.
")
    (description
     "hermit-abi is small interface to call functions from the unikernel RustyHermit.
It is used to build the target `x86_64-unknown-hermit`.")
    (license (list license:expat license:asl2.0))))

(define-public rust-is-terminal-0.4
  (package
    (name "rust-is-terminal")
    (version "0.4.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "is-terminal" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "12c11c8iv2wwyadzajzffmy1fy9nphdpvdj54d367k0c234bdpr8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-hermit-abi" ,rust-hermit-abi-0.2)
                       ("rust-io-lifetimes" ,rust-io-lifetimes-1)
                       ("rust-rustix" ,rust-rustix-0.36)
                       ("rust-windows-sys" ,rust-windows-sys-0.42))))
    (home-page "https://github.com/sunfishcode/is-terminal")
    (synopsis "Test whether a given stream is a terminal")
    (description "Test whether a given stream is a terminal")
    (license license:expat)))

(define-public rust-clap-lex-0.3
  (package
    (name "rust-clap-lex")
    (version "0.3.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "clap-lex" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1a4dzbnlxiamfsn0pnkhn7n9bdfjh66j9fxm6mmr7d227vvrhh8d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-os-str-bytes" ,rust-os-str-bytes-6))))
    (home-page "https://github.com/clap-rs/clap/tree/master/clap_lex")
    (synopsis "Minimal, flexible command line parser")
    (description "Minimal, flexible command line parser")
    (license (list license:expat license:asl2.0))))

(define-public rust-clap-derive-4
  (package
    (name "rust-clap-derive")
    (version "4.0.21")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "clap_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "054h5c62jy5c5li58696ymly0avyjvcbn1krcaawkbq2kwzk2xq1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heck" ,rust-heck-0.4)
                       ("rust-proc-macro-error" ,rust-proc-macro-error-1)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/clap-rs/clap/tree/master/clap_derive")
    (synopsis
     "Parse command line argument by defining a struct, derive crate.")
    (description
     "Parse command line argument by defining a struct, derive crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-clap-4
  (package
    (name "rust-clap")
    (version "4.0.32")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "clap" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0fcsz3zggk0g0y76vv7v7ivn72p1v980h2yhi0zf9y9mr45p1nx7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-clap-derive" ,rust-clap-derive-4)
                       ("rust-clap-lex" ,rust-clap-lex-0.3)
                       ("rust-is-terminal" ,rust-is-terminal-0.4)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-strsim" ,rust-strsim-0.10)
                       ("rust-termcolor" ,rust-termcolor-1)
                       ("rust-terminal-size" ,rust-terminal-size-0.2)
                       ("rust-unicase" ,rust-unicase-2)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))
       #:cargo-development-inputs (("rust-humantime" ,rust-humantime-2)
                                   ("rust-rustversion" ,rust-rustversion-1)
                                   ("rust-shlex" ,rust-shlex-1)
                                   ("rust-snapbox" ,rust-snapbox-0.4)
                                   ("rust-static-assertions" ,rust-static-assertions-1)
                                   ("rust-trybuild" ,rust-trybuild-1)
                                   ("rust-trycmd" ,rust-trycmd-0.14)
                                   ("rust-unic-emoji-char" ,rust-unic-emoji-char-0.9))))
    (home-page "https://github.com/clap-rs/clap")
    (synopsis
     "A simple to use, efficient, and full-featured Command Line Argument Parser")
    (description
     "This package provides a simple to use, efficient, and full-featured Command Line
Argument Parser")
    (license (list license:expat license:asl2.0))))



(define-public rust-tinyvec-1
  (package
    (name "rust-tinyvec")
    (version "1.6.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "tinyvec" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0l6bl2h62a5m44jdnpn7lmj14rd44via8180i7121fvm73mmrk47"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tinyvec-macros" ,rust-tinyvec-macros-0.1))))
    (home-page "https://github.com/Lokathor/tinyvec")
    (synopsis "`tinyvec` provides 100% safe vec-like data structures.")
    (description "`tinyvec` provides 100% safe vec-like data structures.")
    (license (list license:zlib license:asl2.0 license:expat))))

(define-public rust-rkyv-derive-0.7
  (package
    (name "rust-rkyv-derive")
    (version "0.7.39")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rkyv_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1i1lmir3lm8zj8k1an7j2rchv1admqhysh6r6bfkcgmmi3fdmbkf"))))
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

(define-public rust-rend-0.3
  (package
    (name "rust-rend")
    (version "0.3.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rend" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "15fz3rw8c74586kxl6dcdn4s864ph884wfpg9shgnbrnnss69bvr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytecheck" ,rust-bytecheck-0.6))))
    (home-page "https://github.com/djkoloski/rend")
    (synopsis "Endian-aware primitives for Rust")
    (description "Endian-aware primitives for Rust")
    (license license:expat)))

(define-public rust-uuid-macro-internal-1
  (package
    (name "rust-uuid-macro-internal")
    (version "1.2.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "uuid-macro-internal" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1n3nw8vydhm5l3d32j3wgdwfd68rg71m400y4ijyd4s5i7r8kg3k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "")
    (synopsis "Private implementation details of the uuid! macro.")
    (description "Private implementation details of the uuid! macro.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-derive-arbitrary-1
  (package
    (name "rust-derive-arbitrary")
    (version "1.2.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "derive_arbitrary" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "005x40g2k89g31lx4dzi4biw76s42b5cvpmvk209w8if3rqf9vlb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/rust-fuzz/arbitrary")
    (synopsis "Derives arbitrary traits")
    (description "Derives arbitrary traits")
    (license (list license:expat license:asl2.0))))

(define-public rust-arbitrary-1
  (package
    (name "rust-arbitrary")
    (version "1.2.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "arbitrary" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1bdd7s3jvj02mkhy5pcfymab47jhi3zxl29dxy9v59sswr6sz41y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-derive-arbitrary" ,rust-derive-arbitrary-1))))
    (home-page "https://github.com/rust-fuzz/arbitrary/")
    (synopsis
     "The trait for generating structured data from unstructured data")
    (description
     "The trait for generating structured data from unstructured data")
    (license (list license:expat license:asl2.0))))

(define-public rust-uuid-1
  (package
    (name "rust-uuid")
    (version "1.2.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "uuid" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0k6fchay62ryjhkxsbbj38030lm3797c13vsp54bkd9ij3gf0bj2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-atomic" ,rust-atomic-0.5)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-md-5" ,rust-md-5-0.10)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-sha1-smol" ,rust-sha1-smol-1)
                       ("rust-slog" ,rust-slog-2)
                       ("rust-uuid-macro-internal" ,rust-uuid-macro-internal-1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-zerocopy" ,rust-zerocopy-0.6))))
    (home-page "https://github.com/uuid-rs/uuid")
    (synopsis "A library to generate and parse UUIDs.")
    (description
     "This package provides a library to generate and parse UUIDs.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-bytecheck-derive-0.6
  (package
    (name "rust-bytecheck-derive")
    (version "0.6.9")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bytecheck_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1gxr63mi91rrjzfzcb8pfwsnarp9i2w1n168nc05aq4fx7mpdr8k"))))
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
    (version "0.6.9")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bytecheck" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0vs0a8p3bpaz3vc15zknqkd5ajgzgswf2bmd1mbwdbdm28naq76i"))))
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
    (version "0.7.39")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "rkyv" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "05gdspzw03hq6l58si4ixfj5xd27ljw6fiqksggnvn87bd4b7hnf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytecheck" ,rust-bytecheck-0.6)
                       ("rust-hashbrown" ,rust-hashbrown-0.12)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-ptr-meta" ,rust-ptr-meta-0.1)
                       ("rust-rend" ,rust-rend-0.3)
                       ("rust-rkyv-derive" ,rust-rkyv-derive-0.7)
                       ("rust-seahash" ,rust-seahash-4)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-tinyvec" ,rust-tinyvec-1)
                       ("rust-uuid" ,rust-uuid-1))))
    (home-page "https://github.com/rkyv/rkyv")
    (synopsis "Zero-copy deserialization framework for Rust")
    (description "Zero-copy deserialization framework for Rust")
    (license license:expat)))

(define-public rust-iana-time-zone-haiku-0.1
  (package
    (name "rust-iana-time-zone-haiku")
    (version "0.1.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "iana-time-zone-haiku" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1jix9qrqxclj9r4wkg7d3fr987d77vdg3qy2c5hl4ry19wlaw0q7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cxx" ,rust-cxx-1)
                       ("rust-cxx-build" ,rust-cxx-build-1))))
    (home-page "https://github.com/strawlab/iana-time-zone")
    (synopsis "iana-time-zone support crate for Haiku OS")
    (description "iana-time-zone support crate for Haiku OS")
    (license (list license:expat license:asl2.0))))

(define-public rust-core-foundation-sys-0.8
  (package
    (name "rust-core-foundation-sys")
    (version "0.8.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "core-foundation-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1p5r2wckarkpkyc4z83q08dwpvcafrb1h6fxfa3qnikh8szww9sq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/servo/core-foundation-rs")
    (synopsis "Bindings to Core Foundation for macOS")
    (description "Bindings to Core Foundation for macOS")
    (license (list license:expat license:asl2.0))))

(define-public rust-android-system-properties-0.1
  (package
    (name "rust-android-system-properties")
    (version "0.1.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "android_system_properties" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "04b3wrz12837j7mdczqd95b732gw5q7q66cv4yn4646lvccp57l1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/nical/android_system_properties")
    (synopsis "Minimal Android system properties wrapper")
    (description "Minimal Android system properties wrapper")
    (license (list license:expat license:asl2.0))))

(define-public rust-iana-time-zone-0.1
  (package
    (name "rust-iana-time-zone")
    (version "0.1.53")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "iana-time-zone" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ra7nvai8n3alvljswacjbnhfcpivpi7xqbc5n048w18gdk25hb4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-android-system-properties" ,rust-android-system-properties-0.1)
                       ("rust-core-foundation-sys" ,rust-core-foundation-sys-0.8)
                       ("rust-iana-time-zone-haiku" ,rust-iana-time-zone-haiku-0.1)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/strawlab/iana-time-zone")
    (synopsis "get the IANA time zone for the current system")
    (description "get the IANA time zone for the current system")
    (license (list license:expat license:asl2.0))))

(define-public rust-criterion-plot-0.5
  (package
    (name "rust-criterion-plot")
    (version "0.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "criterion-plot" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1c866xkjqqhzg4cjvg01f8w6xc1j3j7s58rdksl52skq89iq4l3b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cast" ,rust-cast-0.3)
                       ("rust-itertools" ,rust-itertools-0.10))))
    (home-page "https://github.com/bheisler/criterion.rs")
    (synopsis "Criterion's plotting library")
    (description "Criterion's plotting library")
    (license (list license:expat license:asl2.0))))

(define-public rust-ciborium-ll-0.2
  (package
    (name "rust-ciborium-ll")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ciborium-ll" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "06ygqh33k3hp9r9mma43gf189b6cyq62clk65f4w1q54nni30c11"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ciborium-io" ,rust-ciborium-io-0.2)
                       ("rust-half" ,rust-half-1))))
    (home-page "https://github.com/enarx/ciborium")
    (synopsis "Low-level CBOR codec primitives")
    (description "Low-level CBOR codec primitives")
    (license license:asl2.0)))

(define-public rust-ciborium-io-0.2
  (package
    (name "rust-ciborium-io")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ciborium-io" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0sdkk7l7pqi2nsbm9c6g8im1gb1qdd83l25ja9xwhg07mx9yfv9l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/enarx/ciborium")
    (synopsis "Simplified Read/Write traits for no_std usage")
    (description "Simplified Read/Write traits for no_std usage")
    (license license:asl2.0)))

(define-public rust-ciborium-0.2
  (package
    (name "rust-ciborium")
    (version "0.2.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ciborium" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "13vqkm88kaq8nvxhaj6qsl0gsc16rqsin014fx5902y6iib3ghdh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ciborium-io" ,rust-ciborium-io-0.2)
                       ("rust-ciborium-ll" ,rust-ciborium-ll-0.2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/enarx/ciborium")
    (synopsis "serde implementation of CBOR using ciborium-basic")
    (description "serde implementation of CBOR using ciborium-basic")
    (license license:asl2.0)))

(define-public rust-anes-0.1
  (package
    (name "rust-anes")
    (version "0.1.6")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "anes" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "16bj1ww1xkwzbckk32j2pnbn5vk6wgsl3q4p3j9551xbcarwnijb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-1))))
    (home-page "https://github.com/zrzka/anes-rs")
    (synopsis "ANSI Escape Sequences provider & parser")
    (description "ANSI Escape Sequences provider & parser")
    (license (list license:expat license:asl2.0))))

(define-public rust-criterion-0.4
  (package
    (name "rust-criterion")
    (version "0.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "criterion" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1jsl4r0yc3fpkyjbi8aa1jrm69apqq9rxwnjnd9brqmaq44nxiz7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anes" ,rust-anes-0.1)
                       ("rust-async-std" ,rust-async-std-1)
                       ("rust-atty" ,rust-atty-0.2)
                       ("rust-cast" ,rust-cast-0.3)
                       ("rust-ciborium" ,rust-ciborium-0.2)
                       ("rust-clap" ,rust-clap-3)
                       ("rust-criterion-plot" ,rust-criterion-plot-0.5)
                       ("rust-csv" ,rust-csv-1)
                       ("rust-futures" ,rust-futures-0.3)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-oorandom" ,rust-oorandom-11)
                       ("rust-plotters" ,rust-plotters-0.3)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-smol" ,rust-smol-1)
                       ("rust-tinytemplate" ,rust-tinytemplate-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-walkdir" ,rust-walkdir-2))))
    (home-page "https://bheisler.github.io/criterion.rs/book/index.html")
    (synopsis "Statistics-driven micro-benchmarking library")
    (description "Statistics-driven micro-benchmarking library")
    (license (list license:asl2.0 license:expat))))

(define-public rust-chrono-0.4
  (package
    (name "rust-chrono")
    (version "0.4.23")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "chrono" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "07s1hnrw8zpmgf76fj5sx0dzxny5p1xs703p0li4n8h1xpcs7c0n"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-criterion" ,rust-criterion-0.4)
                       ("rust-iana-time-zone" ,rust-iana-time-zone-0.1)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-num-integer" ,rust-num-integer-0.1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-pure-rust-locales" ,rust-pure-rust-locales-0.8)
                       ("rust-rkyv" ,rust-rkyv-0.7)
                       ("rust-rustc-serialize" ,rust-rustc-serialize-0.3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-time" ,rust-time-0.1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/chronotope/chrono")
    (synopsis "Date and time library for Rust")
    (description "Date and time library for Rust")
    (license (list license:expat license:asl2.0))))

(define-public rust-anyhow-1
  (package
    (name "rust-anyhow")
    (version "1.0.68")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "anyhow" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0qdb5x89jpngjrl40fpp8047xlydm38n8bz8iaml3lcds64zkcic"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-backtrace" ,rust-backtrace-0.3))))
    (home-page "https://github.com/dtolnay/anyhow")
    (synopsis "Flexible concrete Error type built on std::error::Error")
    (description "Flexible concrete Error type built on std::error::Error")
    (license (list license:expat license:asl2.0))))

(define-public rust-jod-thread-0.1
  (package
    (name "rust-jod-thread")
    (version "0.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "jod-thread" version))
       (file-name
        (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1bj7g6l59ybcf33znf80ccqbxvs1cmd8ynd4m8h7ywdqk473c8wb"))))
    (build-system cargo-build-system)
    (arguments `(#:skip-build? #t))
    (home-page
     "https://github.com/matklad/jod-thread")
    (synopsis
     "Thin wrapper around @code{std::thread} which joins on drop by default")
    (description
     "Join On Drop thread (jod_thread) is a thin wrapper around
@code{std::thread}, which makes sure that by default all threads are joined.")
    (license (list license:expat license:asl2.0))))

(define-public rust-texlab-4
  (package
    (name "rust-texlab")
    (version "4.3.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "texlab" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0laxg7qprbixp20cqdy824vrxq692c2x92aqigw5a84s0b69dbrn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-clap" ,rust-clap-4)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-dashmap" ,rust-dashmap-5)
                       ("rust-derive-more" ,rust-derive-more-0.99)
                       ("rust-dirs" ,rust-dirs-4)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-encoding-rs-io" ,rust-encoding-rs-io-0.1)
                       ("rust-fern" ,rust-fern-0.6)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-fuzzy-matcher" ,rust-fuzzy-matcher-0.3)
                       ("rust-human-name" ,rust-human-name-2)
                       ("rust-isocountry" ,rust-isocountry-0.3)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-logos" ,rust-logos-0.12)
                       ("rust-lsp-server" ,rust-lsp-server-0.6)
                       ("rust-lsp-types" ,rust-lsp-types-0.93)
                       ("rust-notify" ,rust-notify-5)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-petgraph" ,rust-petgraph-0.6)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-rowan" ,rust-rowan-0.15)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-serde-millis" ,rust-serde-millis-0.1)
                       ("rust-serde-regex" ,rust-serde-regex-1)
                       ("rust-serde-repr" ,rust-serde-repr-0.1)
                       ("rust-smol-str" ,rust-smol-str-0.1)
                       ("rust-strum" ,rust-strum-0.24)
                       ("rust-tempfile" ,rust-tempfile-3)
                       ("rust-threadpool" ,rust-threadpool-1)
                       ("rust-titlecase" ,rust-titlecase-2)
                       ("rust-typed-builder" ,rust-typed-builder-0.11)
                       ("rust-unicode-normalization" ,rust-unicode-normalization-0.1)
                       ("rust-url" ,rust-url-2)
                       ("rust-uuid" ,rust-uuid-1))
       #:cargo-development-inputs (("rust-assert-unordered" ,rust-assert-unordered-0.3)
                                   ("rust-criterion" ,rust-criterion-0.4)
                                   ("rust-env-logger" ,rust-env-logger-0.9)
                                   ("rust-insta" ,rust-insta-1)
                                   ("rust-jod-thread" ,rust-jod-thread-0.1))
       #:tests? #f))
    (home-page "https://github.com/latex-lsp/texlab")
    (synopsis "LaTeX Language Server")
    (description "LaTeX Language Server")
    (license license:gpl3)))



(define-public texlab-latest
  (package
   (name "rust-texlab")
   (version "5.22.0")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/latex-lsp/texlab/releases/download/v"
           version
           "/texlab-x86_64-linux.tar.gz"))
     (sha256
      (base32
       "0b4pn8yin1p1n4j8y7dqhsj9b4dx5cw0vcwgck40ckjh2wykl3hs"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("texlab" "/bin/"))
                #:patchelf-plan
                '(("texlab" ("gcc:lib" "glibc")))))
   (inputs
    `(("gcc:lib" ,gcc "lib")
      ("glibc" ,glibc)))
   (synopsis "An implementation of the Language Server Protocol for LaTeX")
   (description
    "A cross-platform implementation of the Language Server Protocol providing rich cross-editing support for the LaTeX typesetting system.
The server may be used with any editor that implements the Language Server Protocol.")
   (home-page "https://github.com/latex-lsp/texlab")
   (license license:gpl3)))
