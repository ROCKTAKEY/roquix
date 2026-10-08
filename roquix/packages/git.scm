(define-module (roquix packages git)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages crates-io)
  #:use-module (roquix packages texlab))

(define-public rust-vte-0.10
  (package
    (name "rust-vte")
    (version "0.10.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "vte" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "10srmy9ssircrwsb5lpx3fbhx71460j77kvz0krz38jcmf9fdg3c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.5)
                       ("rust-utf8parse" ,rust-utf8parse-0.2)
                       ("rust-vte-generate-state-changes" ,rust-vte-generate-state-changes-0.1))))
    (home-page "https://github.com/alacritty/vte")
    (synopsis "Parser for implementing terminal emulators")
    (description "Parser for implementing terminal emulators")
    (license (list license:asl2.0 license:expat))))

(define-public rust-sysinfo-0.24
  (package
    (name "rust-sysinfo")
    (version "0.24.7")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "sysinfo" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "07004ylrpf0bvcwprxp4231bvzg2i7lrbp79wscqnc297nzlxjsl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-core-foundation-sys" ,rust-core-foundation-sys-0.8)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-ntapi" ,rust-ntapi-0.3)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/GuillaumeGomez/sysinfo")
    (synopsis
     "Library to get system information such as processes, CPUs, disks, components and networks")
    (description
     "Library to get system information such as processes, CPUs, disks, components and
networks")
    (license license:expat)))

(define-public rust-find-crate-0.6
  (package
    (name "rust-find-crate")
    (version "0.6.3")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "find-crate" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1ljpkh11gj7940xwz47xjhsvfbl93c2q0ql7l2v0w77amjx8paar"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-toml" ,rust-toml-0.5))))
    (home-page "https://github.com/taiki-e/find-crate")
    (synopsis "Find the crate name from the current Cargo.toml.
")
    (description "Find the crate name from the current Cargo.toml.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-palette-derive-0.6
  (package
    (name "rust-palette-derive")
    (version "0.6.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "palette_derive" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "09z4nd4sbmzqd1pqr48vrdca3v2c03dzr70cmxs7zhp7m13dzvh5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-find-crate" ,rust-find-crate-0.6)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-1))))
    (home-page "https://github.com/Ogeon/palette")
    (synopsis "Automatically implement traits from the palette crate.")
    (description "Automatically implement traits from the palette crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-palette-0.6
  (package
    (name "rust-palette")
    (version "0.6.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "palette" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0jay4zbxfnz6hj9f78inb3n3hmaamivnrrapy4ri0n0jf67xd74g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-approx" ,rust-approx-0.5)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-num-traits" ,rust-num-traits-0.2)
                       ("rust-palette-derive" ,rust-palette-derive-0.6)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Ogeon/palette")
    (synopsis
     "Convert and manage colors with a focus on correctness, flexibility and ease of use.")
    (description
     "Convert and manage colors with a focus on correctness, flexibility and ease of
use.")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-msvc-0.42
  (package
    (name "rust-windows-x86-64-msvc")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1zfgzsmc0j5p9yx25j15lb1yh45mazl4hhjdvfqqhcm16snn0xj4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnullvm-0.42
  (package
    (name "rust-windows-x86-64-gnullvm")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_gnullvm" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0qq41m3zkakkmch9x4x30lgv0sy3zh4jpdpxch6jp8ns6brgv2v2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-x86-64-gnu-0.42
  (package
    (name "rust-windows-x86-64-gnu")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_x86_64_gnu" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0icwd66wd6p9hhzds93333wy2knlqbyiynf2rfy7xqc528i0y161"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-msvc-0.42
  (package
    (name "rust-windows-i686-msvc")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_i686_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "01966w2707qrw183lqg62i1as614i88m5a0s6pzxdpby64i12kdz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-i686-gnu-0.42
  (package
    (name "rust-windows-i686-gnu")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_i686_gnu" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0h6n8mqjfq1rk4vpr9gz8md1b8f7bqksiymivdxvlc6mi998ff6y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-msvc-0.42
  (package
    (name "rust-windows-aarch64-msvc")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_aarch64_msvc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1iy6adiaz2956f0kcl2wfdjx49ayv2lp11glkxxc85pw7xkip2sc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-aarch64-gnullvm-0.42
  (package
    (name "rust-windows-aarch64-gnullvm")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows_aarch64_gnullvm" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0256d14kqpiniwcm6y2yfj7jbzdvvj4l6i65r5zyrza36bl6964c"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-targets-0.42
  (package
    (name "rust-windows-targets")
    (version "0.42.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-targets" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1rwh2d1yvfjvlfidi8p9ha4lp34lb0lynynlhk65ikdz3x4j49cf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-aarch64-gnullvm" ,rust-windows-aarch64-gnullvm-0.42)
                       ("rust-windows-aarch64-msvc" ,rust-windows-aarch64-msvc-0.42)
                       ("rust-windows-i686-gnu" ,rust-windows-i686-gnu-0.42)
                       ("rust-windows-i686-msvc" ,rust-windows-i686-msvc-0.42)
                       ("rust-windows-x86-64-gnu" ,rust-windows-x86-64-gnu-0.42)
                       ("rust-windows-x86-64-gnullvm" ,rust-windows-x86-64-gnullvm-0.42)
                       ("rust-windows-x86-64-msvc" ,rust-windows-x86-64-msvc-0.42))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Code gen support for the windows crate")
    (description "Code gen support for the windows crate")
    (license (list license:expat license:asl2.0))))

(define-public rust-windows-sys-0.45
  (package
    (name "rust-windows-sys")
    (version "0.45.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "windows-sys" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1l36bcqm4g89pknfp8r9rl1w4bn017q6a8qlx8viv0xjxzjkna3m"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-windows-targets" ,rust-windows-targets-0.42))))
    (home-page "https://github.com/microsoft/windows-rs")
    (synopsis "Rust for Windows")
    (description "Rust for Windows")
    (license (list license:expat license:asl2.0))))

(define-public rust-ctrlc-3
  (package
    (name "rust-ctrlc")
    (version "3.2.5")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "ctrlc" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0fgng4k7d3bx2q86z2djkngwss43wkrfkriswhgf9jqqlv137kxv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-nix" ,rust-nix-0.26)
                       ("rust-windows-sys" ,rust-windows-sys-0.45))))
    (home-page "https://github.com/Detegr/rust-ctrlc")
    (synopsis "Easy Ctrl-C handler for Rust projects")
    (description "Easy Ctrl-C handler for Rust projects")
    (license (list license:expat license:asl2.0))))

(define-public rust-bytelines-2
  (package
    (name "rust-bytelines")
    (version "2.4.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bytelines" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "17x55pg0k30wjqfk8mqbcjh3x98afbx34rj5l7czqdf547isqkvq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-futures" ,rust-futures-0.3)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/whitfin/bytelines")
    (synopsis "Read input lines as byte slices for high efficiency")
    (description "Read input lines as byte slices for high efficiency")
    (license license:expat)))

(define-public rust-box-drawing-0.1
  (package
    (name "rust-box-drawing")
    (version "0.1.2")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "box_drawing" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0jx4rrxy4xmgmplmgl398vrng67sfl8qny7n7d91fyw6zpaxh9za"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://gitlab.com/chronos.alfa/box_drawing.git")
    (synopsis
     "A very simple library containing constants for UTF-8 box drawing.")
    (description
     "This package provides a very simple library containing constants for UTF-8 box
drawing.")
    (license license:expat)))

(define-public rust-quick-xml-0.26
  (package
    (name "rust-quick-xml")
    (version "0.26.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "quick-xml" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1kckgj8qscpi23y62zrfmni73k6h78nvhs3z9myiwq9q7g3b2l3z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-document-features" ,rust-document-features-0.2)
                       ("rust-encoding-rs" ,rust-encoding-rs-0.8)
                       ("rust-memchr" ,rust-memchr-2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tokio" ,rust-tokio-1))))
    (home-page "https://github.com/tafia/quick-xml")
    (synopsis "High performance xml reader and writer")
    (description "High performance xml reader and writer")
    (license license:expat)))

(define-public rust-base64-0.21
  (package
    (name "rust-base64")
    (version "0.21.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "base64" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0sidjip5b33sr6w7kasfj9qxpbda41nw0x4gjjk55g55a6mdv954"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/marshallpierce/rust-base64")
    (synopsis "encodes and decodes base64 as bytes or utf8")
    (description "encodes and decodes base64 as bytes or utf8")
    (license (list license:expat license:asl2.0))))

(define-public rust-plist-1
  (package
    (name "rust-plist")
    (version "1.4.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "plist" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "0ikz7abkr2c3pahgnb30apzrq3cr267wnvwgyrva74q2m6f7jscl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.21)
                       ("rust-indexmap" ,rust-indexmap-1)
                       ("rust-line-wrap" ,rust-line-wrap-0.1)
                       ("rust-quick-xml" ,rust-quick-xml-0.26)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-time" ,rust-time-0.3))))
    (home-page "https://github.com/ebarnard/rust-plist/")
    (synopsis "A rusty plist parser. Supports Serde serialization.")
    (description
     "This package provides a rusty plist parser.  Supports Serde serialization.")
    (license license:expat)))

(define-public rust-syntect-5
  (package
    (name "rust-syntect")
    (version "5.0.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "syntect" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1a3n6mial29jv916wg7y0qlqs26da0yalfl0qy29lzcxgp159i66"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bincode" ,rust-bincode-1)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-fancy-regex" ,rust-fancy-regex-0.7)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-fnv" ,rust-fnv-1)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-onig" ,rust-onig-6)
                       ("rust-plist" ,rust-plist-1)
                       ("rust-regex-syntax" ,rust-regex-syntax-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-yaml-rust" ,rust-yaml-rust-0.4))))
    (home-page "https://github.com/trishume/syntect")
    (synopsis
     "library for high quality syntax highlighting and code intelligence using Sublime Text's grammars")
    (description
     "library for high quality syntax highlighting and code intelligence using Sublime
Text's grammars")
    (license license:expat)))

(define-public rust-shell-words-1
  (package
    (name "rust-shell-words")
    (version "1.1.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "shell-words" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1plgwx8r0h5ismbbp6cp03740wmzgzhip85k5hxqrrkaddkql614"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/tmiasko/shell-words")
    (synopsis "Process command line according to parsing rules of UNIX shell")
    (description
     "Process command line according to parsing rules of UNIX shell")
    (license (list license:expat license:asl2.0))))

(define-public rust-bugreport-0.5
  (package
    (name "rust-bugreport")
    (version "0.5.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bugreport" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "1jcq9ywxyd7fw1ing8ixna0cfcs5lrviyvx6h6080ir532w20lak"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-git-version" ,rust-git-version-0.3)
                       ("rust-shell-escape" ,rust-shell-escape-0.1)
                       ("rust-sys-info" ,rust-sys-info-0.9))))
    (home-page "https://github.com/sharkdp/bugreport")
    (synopsis "Collect system and environment information for bug reports")
    (description "Collect system and environment information for bug reports")
    (license (list license:expat license:asl2.0))))

(define-public rust-bat-0.21
  (package
    (name "rust-bat")
    (version "0.21.0")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "bat" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "01b3f1pzmj30ar5xa1a892vv4i9vxsrf099p9dhxgcq013c144px"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ansi-colours" ,rust-ansi-colours-1)
                       ("rust-ansi-term" ,rust-ansi-term-0.12)
                       ("rust-atty" ,rust-atty-0.2)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-bugreport" ,rust-bugreport-0.5)
                       ("rust-bytesize" ,rust-bytesize-1)
                       ("rust-clap" ,rust-clap-2)
                       ("rust-clap" ,rust-clap-2)
                       ("rust-clircle" ,rust-clircle-0.3)
                       ("rust-console" ,rust-console-0.15)
                       ("rust-content-inspector" ,rust-content-inspector-0.2)
                       ("rust-dirs-next" ,rust-dirs-next-2)
                       ("rust-encoding" ,rust-encoding-0.2)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-git2" ,rust-git2-0.14)
                       ("rust-globset" ,rust-globset-0.4)
                       ("rust-grep-cli" ,rust-grep-cli-0.1)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-path-abs" ,rust-path-abs-0.5)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-semver" ,rust-semver-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-yaml" ,rust-serde-yaml-0.8)
                       ("rust-shell-words" ,rust-shell-words-1)
                       ("rust-syntect" ,rust-syntect-5)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-wild" ,rust-wild-2))))
    (home-page "https://github.com/sharkdp/bat")
    (synopsis "A cat(1) clone with wings.")
    (description "This package provides a cat(1) clone with wings.")
    (license (list license:expat license:asl2.0))))

(define-public rust-git-delta-0.15
  (package
    (name "rust-git-delta")
    (version "0.15.1")
    (source (origin
              (method url-fetch)
              (uri (crate-uri "git-delta" version))
              (file-name (string-append name "-" version ".tar.gz"))
              (sha256
               (base32
                "18ra4af2n1h9v9wplswciz34jl0k8i1fgbxffng1mykhzin3bmxd"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-ansi-colours" ,rust-ansi-colours-1)
                       ("rust-ansi-term" ,rust-ansi-term-0.12)
                       ("rust-atty" ,rust-atty-0.2)
                       ("rust-bat" ,rust-bat-0.21)
                       ("rust-bitflags" ,rust-bitflags-1)
                       ("rust-box-drawing" ,rust-box-drawing-0.1)
                       ("rust-bytelines" ,rust-bytelines-2)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-chrono-humanize" ,rust-chrono-humanize-0.2)
                       ("rust-clap" ,rust-clap-3)
                       ("rust-console" ,rust-console-0.15)
                       ("rust-ctrlc" ,rust-ctrlc-3)
                       ("rust-dirs-next" ,rust-dirs-next-2)
                       ("rust-error-chain" ,rust-error-chain-0.12)
                       ("rust-git2" ,rust-git2-0.14)
                       ("rust-grep-cli" ,rust-grep-cli-0.1)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-palette" ,rust-palette-0.6)
                       ("rust-pathdiff" ,rust-pathdiff-0.2)
                       ("rust-regex" ,rust-regex-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-shell-words" ,rust-shell-words-1)
                       ("rust-smol-str" ,rust-smol-str-0.1)
                       ("rust-syntect" ,rust-syntect-5)
                       ("rust-sysinfo" ,rust-sysinfo-0.24)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-vte" ,rust-vte-0.10)
                       ("rust-xdg" ,rust-xdg-2))))
    (home-page "https://github.com/dandavison/delta")
    (synopsis "A syntax-highlighting pager for git")
    (description "This package provides a syntax-highlighting pager for git")
    (license license:expat)))
