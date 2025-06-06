(define-module
  (roquix packages amdgpu-top)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages crates-io)
  #:use-module (gnu packages crates-windows)
  #:use-module (gnu packages crates-apple)
  #:use-module (gnu packages crates-graphics)
  #:use-module (gnu packages crates-compression)
  #:use-module (gnu packages crates-vcs)
  #:use-module (gnu packages crates-check)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages xdisorg)
  #:use-module (rustup packages rust)
  #:use-module (rustup build toolchain)
  #:use-module ((roquix licenses) #:prefix license:))

(define-public rust-winreg-0.5
  (package
    (name "rust-winreg")
    (version "0.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "winreg" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0jkh4jj2g8g0bl7r1xvq9vv9hr4gdzphg9ndqm65q6f1jn9paym2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-clippy" ,rust-clippy-0.0.302)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-winapi" ,rust-winapi-0.3))))
    (home-page "https://github.com/gentoo90/winreg-rs")
    (synopsis "Rust bindings to MS Windows Registry API")
    (description
     "This package provides Rust bindings to MS Windows Registry API.")
    (license license:expat)))

(define-public rust-pdcurses-sys-0.7
  (package
    (name "rust-pdcurses-sys")
    (version "0.7.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pdcurses-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0sqn552nz33bmd0d8lcx862lrbxg6fgk5djfblig2q7zjqkx4k88"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/ihalila/pdcurses-sys")
    (synopsis
     "FFI bindings for PDCurses, specifically the win32a implementation")
    (description
     "This package provides FFI bindings for PDCurses, specifically the win32a implementation.")
    (license license:expat)))

(define-public rust-ncurses-5
  (package
    (name "rust-ncurses")
    (version "5.101.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ncurses" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ci0flh7j8v7yir2y1lrqvqy90df1ba2a74acd5xqmr6sws5sb2y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (home-page "https://github.com/jeaye/ncurses-rs")
    (synopsis "very thin wrapper around the ncurses TUI library")
    (description
     "This package provides a very thin wrapper around the ncurses TUI library.")
    (license license:expat)))

(define-public rust-pancurses-0.17
  (package
    (name "rust-pancurses")
    (version "0.17.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pancurses" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1nqkkmsljdk3z2bifxapmx1yv2w1vfwhkdxzk7pbkb6b6rf9flh3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-ncurses" ,rust-ncurses-5)
                       ("rust-pdcurses-sys" ,rust-pdcurses-sys-0.7)
                       ("rust-winreg" ,rust-winreg-0.5))))
    (home-page "https://github.com/ihalila/pancurses")
    (synopsis
     "pancurses is a curses libary for Rust that supports both Unix and Windows
platforms by abstracting away the backend that it uses
(ncurses-rs and pdcurses-sys respectively).")
    (description
     "This package provides pancurses is a curses libary for Rust that supports both Unix and Windows
platforms by abstracting away the backend that it uses (ncurses-rs and
pdcurses-sys respectively).")
    (license license:expat)))

(define-public rust-ncurses-6
  (package
    (name "rust-ncurses")
    (version "6.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ncurses" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zq2i235c3yh06ylgprb6gmh8h3n7r4fh89m2wfq83kijpx1mmzv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (home-page "https://github.com/jeaye/ncurses-rs")
    (synopsis "very thin wrapper around the ncurses TUI library")
    (description
     "This package provides a very thin wrapper around the ncurses TUI library.")
    (license license:expat)))

(define-public rust-cursive-macros-0.1
  (package
    (name "rust-cursive-macros")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cursive-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gm7l3xzqsgwh4sd0py2g45p6np0ahiz5mglxggxzqzd1kmw0ymc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-find-crate" ,rust-find-crate-0.6)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/gyscos/cursive")
    (synopsis "Proc-macros for the cursive TUI library")
    (description
     "This package provides Proc-macros for the cursive TUI library.")
    (license license:expat)))

(define-public rust-ansi-parser-0.9
  (package
    (name "rust-ansi-parser")
    (version "0.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ansi-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wwicv3sx7sw3qhkkpjvnmynkpzc31b8bhj3s45ms0jg53c7ygn4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-heapless" ,rust-heapless-0.8)
                       ("rust-nom" ,rust-nom-7))))
    (home-page "https://gitlab.com/DavidBittner/ansi-parser")
    (synopsis "library using nom for parsing ANSI Escape Codes")
    (description
     "This package provides a library using nom for parsing ANSI Escape Codes.")
    (license license:mpl2.0)))

(define-public rust-cursive-core-0.4
  (package
    (name "rust-cursive-core")
    (version "0.4.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cursive_core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0my2kjghn3i0zkw4yc4mj1yvsn48bw1d0d10h5pcdbvzs9scf7ij"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-ansi-parser" ,rust-ansi-parser-0.9)
                       ("rust-compact-str" ,rust-compact-str-0.8)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-cursive-macros" ,rust-cursive-macros-0.1)
                       ("rust-enum-map" ,rust-enum-map-2)
                       ("rust-enumset" ,rust-enumset-1)
                       ("rust-inventory" ,rust-inventory-0.3)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-num" ,rust-num-0.4)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-pulldown-cmark" ,rust-pulldown-cmark-0.11)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-time" ,rust-time-0.3)
                       ("rust-toml" ,rust-toml-0.8)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1)
                       ("rust-xi-unicode" ,rust-xi-unicode-0.3))))
    (home-page "https://github.com/gyscos/cursive")
    (synopsis "Core components for the Cursive TUI")
    (description "This package provides Core components for the Cursive TUI.")
    (license license:expat)))

(define-public rust-bear-lib-terminal-sys-1
  (package
    (name "rust-bear-lib-terminal-sys")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bear-lib-terminal-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17r71abbdz4l0vkwwv9p3lsmvy21sai8xabz2wl73w025hxwh11s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2))))
    (home-page "https://github.com/nabijaczleweli/BearLibTerminal-sys.rs")
    (synopsis "Pure BearLibTerminal FFI for Rust")
    (description
     "This package provides Pure @code{BearLibTerminal} FFI for Rust.")
    (license license:expat)))

(define-public rust-bear-lib-terminal-2
  (package
    (name "rust-bear-lib-terminal")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bear-lib-terminal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "05kij0gr0i0phikh1qc5mdgi73f3ly9x1fhy3snzizm3jpv4jm9i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bear-lib-terminal-sys" ,rust-bear-lib-terminal-sys-1))))
    (home-page "https://github.com/nabijaczleweli/BearLibTerminal.rs")
    (synopsis "BearLibTerminal FFI for Rust")
    (description "This package provides @code{BearLibTerminal} FFI for Rust.")
    (license license:expat)))

(define-public rust-cursive-0.21
  (package
    (name "rust-cursive")
    (version "0.21.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "cursive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bjkmbyy5ivvvgjblmqq5lkb1mlvdi78mjsflglmdf0b08v5lv9q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bear-lib-terminal" ,rust-bear-lib-terminal-2)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-crossterm" ,rust-crossterm-0.28)
                       ("rust-cursive-core" ,rust-cursive-core-0.4)
                       ("rust-lazy-static" ,rust-lazy-static-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-maplit" ,rust-maplit-1)
                       ("rust-ncurses" ,rust-ncurses-6)
                       ("rust-pancurses" ,rust-pancurses-0.17)
                       ("rust-signal-hook" ,rust-signal-hook-0.3)
                       ("rust-termion" ,rust-termion-4)
                       ("rust-unicode-segmentation" ,rust-unicode-segmentation-1)
                       ("rust-unicode-width" ,rust-unicode-width-0.1))))
    (home-page "https://github.com/gyscos/cursive")
    (synopsis "TUI (Text User Interface) library focused on ease-of-use.")
    (description
     "This package provides a TUI (Text User Interface) library focused on
ease-of-use.")
    (license license:expat)))

(define-public rust-amdgpu-top-tui-0.10
  (package
    (name "rust-amdgpu-top-tui")
    (version "0.10.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "amdgpu_top_tui" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qfb3zxz9dpqng7kjv4mbq94yminhifihn6yg0xwi555wawy4ndr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cursive" ,rust-cursive-0.21)
                       ("rust-libamdgpu-top" ,rust-libamdgpu-top-0.10)
                       ("rust-termsize" ,rust-termsize-0.1))))
    (home-page "https://github.com/Umio-Yasuno/amdgpu_top")
    (synopsis "TUI library for amdgpu_top")
    (description "This package provides TUI library for amdgpu_top.")
    (license license:expat)))

(define-public rust-amdgpu-top-json-0.10
  (package
    (name "rust-amdgpu-top-json")
    (version "0.10.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "amdgpu_top_json" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cy0sqnm6dnvhyp90c447kcj3zyix6lb8j60sn910pphwpqd37ib"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libamdgpu-top" ,rust-libamdgpu-top-0.10)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://github.com/Umio-Yasuno/amdgpu_top")
    (synopsis "Library for JSON output function of amdgpu_top")
    (description
     "This package provides Library for JSON output function of amdgpu_top.")
    (license license:expat)))

(define-public rust-libdrm-amdgpu-sys-0.8
  (package
    (name "rust-libdrm-amdgpu-sys")
    (version "0.8.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libdrm_amdgpu_sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "02s0npm1fkapcq2091j3q7s6jxs6cps8xsr28dxwhrmrxww23ill"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.71)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libloading" ,rust-libloading-0.8)
                       ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (home-page "https://github.com/Umio-Yasuno/libdrm-amdgpu-sys-rs")
    (synopsis
     "libdrm_amdgpu bindings for Rust, and some methods ported from Mesa3D")
    (description
     "This package provides libdrm_amdgpu bindings for Rust, and some methods ported from Mesa3D.")
    (license license:expat)))

(define-public rust-libamdgpu-top-0.10
  (package
    (name "rust-libamdgpu-top")
    (version "0.10.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "libamdgpu_top" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1324qcvyz0kn3vlzzbimwl0qn4f733rb8zik1zkli3bj40mwva31"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-libdrm-amdgpu-sys" ,rust-libdrm-amdgpu-sys-0.8)
                       ("rust-nix" ,rust-nix-0.29))))
    (home-page "https://github.com/Umio-Yasuno/amdgpu_top")
    (synopsis "library for amdgpu_top")
    (description "This package provides a library for amdgpu_top.")
    (license license:expat)))

(define-public rust-proc-macro-error-attr2-2
  (package
    (name "rust-proc-macro-error-attr2")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proc-macro-error-attr2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ifzi763l7swl258d8ar4wbpxj4c9c2im7zy89avm6xv6vgl5pln"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1))))
    (home-page "https://github.com/GnomedDev/proc-macro-error-2")
    (synopsis "Attribute macro for the proc-macro-error2 crate")
    (description
     "This package provides Attribute macro for the proc-macro-error2 crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-proc-macro-error2-2
  (package
    (name "rust-proc-macro-error2")
    (version "2.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "proc-macro-error2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "00lq21vgh7mvyx51nwxwf822w2fpww1x0z8z0q47p8705g2hbv0i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-error-attr2" ,rust-proc-macro-error-attr2-2)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/GnomedDev/proc-macro-error-2")
    (synopsis "Almost drop-in replacement to panics in proc-macros")
    (description
     "This package provides Almost drop-in replacement to panics in proc-macros.")
    (license (list license:expat license:asl2.0))))

(define-public rust-i18n-embed-fl-0.9
  (package
    (name "rust-i18n-embed-fl")
    (version "0.9.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "i18n-embed-fl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0b9wqnp8zy531xqjsr3a7ss3483j3561hdf5fqvi9iiz1ffrdch4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-dashmap" ,rust-dashmap-6)
                       ("rust-find-crate" ,rust-find-crate-0.6)
                       ("rust-fluent" ,rust-fluent-0.16)
                       ("rust-fluent-syntax" ,rust-fluent-syntax-0.11)
                       ("rust-i18n-config" ,rust-i18n-config-0.4)
                       ("rust-i18n-embed" ,rust-i18n-embed-0.15)
                       ("rust-proc-macro-error2" ,rust-proc-macro-error2-2)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-strsim" ,rust-strsim-0.11)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page
     "https://github.com/kellpossible/cargo-i18n/tree/master/i18n-embed-fl")
    (synopsis
     "Macro to perform compile time checks when using the i18n-embed crate and the fluent localization system")
    (description
     "This package provides Macro to perform compile time checks when using the i18n-embed crate and the
fluent localization system.")
    (license license:expat)))

(define-public rust-tr-0.1
  (package
    (name "rust-tr")
    (version "0.1.10")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lc1iwhn2gkqvnmpim473hmli60hsnk8z44cgcradrdjgizqg4m5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-gettext" ,rust-gettext-0.4)
                       ("rust-gettext-rs" ,rust-gettext-rs-0.7)
                       ("rust-lazy-static" ,rust-lazy-static-1))))
    (home-page "https://github.com/woboq/tr")
    (synopsis "tr! macro for localisation")
    (description "This package provides tr! macro for localisation.")
    (license license:expat)))

(define-public rust-notify-types-2
  (package
    (name "rust-notify-types")
    (version "2.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "notify-types" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pcjm3wnvb7pvzw6mn89csv64ip0xhx857kr8jic5vddi6ljc22y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-web-time" ,rust-web-time-1))))
    (home-page "https://github.com/notify-rs/notify")
    (synopsis "Types used by the notify crate")
    (description "This package provides Types used by the notify crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-notify-8
  (package
    (name "rust-notify")
    (version "8.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "notify" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0hz9ab68gsbkidms6kgl4v7capfqjyl40vpfdarcfsnnnc1q9vig"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-crossbeam-channel" ,rust-crossbeam-channel-0.5)
                       ("rust-filetime" ,rust-filetime-0.2)
                       ("rust-fsevent-sys" ,rust-fsevent-sys-4)
                       ("rust-inotify" ,rust-inotify-0.11)
                       ("rust-kqueue" ,rust-kqueue-1)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mio" ,rust-mio-1)
                       ("rust-notify-types" ,rust-notify-types-2)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-windows-sys" ,rust-windows-sys-0.59))))
    (home-page "https://github.com/notify-rs/notify")
    (synopsis "Cross-platform filesystem notification library")
    (description
     "This package provides Cross-platform filesystem notification library.")
    (license license:cc0)))

(define-public rust-i18n-config-0.4
  (package
    (name "rust-i18n-config")
    (version "0.4.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "i18n-config" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1j89hnd1d2zqfb1s9jgcd5vzf5a9iisfc18v324mpgn06540g24f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-basic-toml" ,rust-basic-toml-0.1)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page
     "https://github.com/kellpossible/cargo-i18n/tree/master/i18n-config")
    (synopsis
     "This library contains the configuration stucts (along with their parsing functions) for the cargo-i18n tool/system")
    (description
     "This library contains the configuration stucts (along with their parsing
functions) for the cargo-i18n tool/system.")
    (license license:expat)))

(define-public rust-i18n-embed-impl-0.8
  (package
    (name "rust-i18n-embed-impl")
    (version "0.8.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "i18n-embed-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hmnimlv310cirg8nx77nf8q1si4hq1yarkg5kyfc7rxabhc0b0g"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-find-crate" ,rust-find-crate-0.6)
                       ("rust-i18n-config" ,rust-i18n-config-0.4)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page
     "https://github.com/kellpossible/cargo-i18n/tree/master/i18n-embed")
    (synopsis "Macro implementations for i18n-embed")
    (description "This package provides Macro implementations for i18n-embed.")
    (license license:expat)))

(define-public rust-gettext-0.4
  (package
    (name "rust-gettext")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gettext" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wd9kfy7nmbrqx2znw186la99as8y265lvh3pvj9fn9xfm75kfwy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-byteorder" ,rust-byteorder-1)
                       ("rust-encoding" ,rust-encoding-0.2))))
    (home-page "https://github.com/justinas/gettext")
    (synopsis "An implementation of Gettext translation framework for Rust")
    (description
     "This package provides An implementation of Gettext translation framework for Rust.")
    (license license:expat)))

(define-public rust-once-cell-1
  (package
    (name "rust-once-cell")
    (version "1.21.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "once_cell" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0b9x77lb9f1j6nqgf5aka4s2qj0nly176bpbrv6f9iakk5ff3xa2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-critical-section" ,rust-critical-section-1)
                       ("rust-parking-lot-core" ,rust-parking-lot-core-0.9)
                       ("rust-portable-atomic" ,rust-portable-atomic-1))))
    (home-page "https://github.com/matklad/once_cell")
    (synopsis "Single assignment cells and lazy values")
    (description
     "This package provides Single assignment cells and lazy values.")
    (license (list license:expat license:asl2.0))))

(define-public rust-fluent-pseudo-0.3
  (package
    (name "rust-fluent-pseudo")
    (version "0.3.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-pseudo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bmzhqbh0z208xj7hfpwj36hjlz10n1nr0iyl3vf8a3zkcjvbwc6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-once-cell" ,rust-once-cell-1)
                       ("rust-regex" ,rust-regex-1))))
    (home-page "https://www.projectfluent.org")
    (synopsis
     "pseudolocalization and transformation API for Project Fluent,
a localization system designed to unleash the entire expressive power of natural language translations.")
    (description
     "This package provides a pseudolocalization and transformation API for Project
Fluent, a localization system designed to unleash the entire expressive power of
natural language translations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-self-cell-0.10
  (package
    (name "rust-self-cell")
    (version "0.10.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "self_cell" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pci3zh23b7dg6jmlxbn8k4plb7hcg5jprd1qiz0rp04p1ilskp1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-self-cell" ,rust-self-cell-1))))
    (home-page "https://github.com/Voultapher/self_cell")
    (synopsis
     "Safe-to-use proc-macro-free self-referential structs in stable Rust")
    (description
     "This package provides Safe-to-use proc-macro-free self-referential structs in stable Rust.")
    (license license:asl2.0)))

(define-public rust-intl-pluralrules-7
  (package
    (name "rust-intl-pluralrules")
    (version "7.0.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "intl_pluralrules" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0wprd3h6h8nfj62d8xk71h178q7zfn3srxm787w4sawsqavsg3h7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "https://github.com/zbraniecki/pluralrules")
    (synopsis "Unicode Plural Rules categorizer for numeric input")
    (description
     "This package provides Unicode Plural Rules categorizer for numeric input.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-intl-memoizer-0.5
  (package
    (name "rust-intl-memoizer")
    (version "0.5.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "intl-memoizer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gqn5wwhzacvj0z25r5r3l2pajg9c8i1ivh7g8g8dszm8pis439i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-type-map" ,rust-type-map-0.5)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "https://www.projectfluent.org")
    (synopsis
     "memoizer specifically tailored for storing lazy-initialized intl formatters for Project Fluent,
a localization system designed to unleash the entire expressive power of natural language translations.")
    (description
     "This package provides a memoizer specifically tailored for storing
lazy-initialized intl formatters for Project Fluent, a localization system
designed to unleash the entire expressive power of natural language
translations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-fluent-syntax-0.11
  (package
    (name "rust-fluent-syntax")
    (version "0.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-syntax" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0gd3cdvsx9ymbb8hijcsc9wyf8h1pbcbpsafg4ldba56ji30qlra"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-thiserror" ,rust-thiserror-1))))
    (home-page "https://www.projectfluent.org")
    (synopsis
     "low-level parser, AST, and serializer API for the syntax used by Project Fluent,
a localization system designed to unleash the entire expressive power of natural language translations.")
    (description
     "This package provides a low-level parser, AST, and serializer API for the syntax
used by Project Fluent, a localization system designed to unleash the entire
expressive power of natural language translations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-unic-langid-macros-impl-0.9
  (package
    (name "rust-unic-langid-macros-impl")
    (version "0.9.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid-macros-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dbmgybjxn4b3a7mb21grc5r98xwal9h1cgc46w39bg3imi9l951"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-unic-langid-impl" ,rust-unic-langid-impl-0.9))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description
     "This package provides API for managing Unicode Language Identifiers.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unic-langid-macros-0.9
  (package
    (name "rust-unic-langid-macros")
    (version "0.9.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "09gwlpdzxnzhywvarfm43d7g1672lwak6ahq2kfplv9l5sw7x5fm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro-hack" ,rust-proc-macro-hack-0.5)
                       ("rust-tinystr" ,rust-tinystr-0.8)
                       ("rust-unic-langid-impl" ,rust-unic-langid-impl-0.9)
                       ("rust-unic-langid-macros-impl" ,rust-unic-langid-macros-impl-0.9))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description
     "This package provides API for managing Unicode Language Identifiers.")
    (license (list license:expat license:asl2.0))))

(define-public rust-zerovec-derive-0.11
  (package
    (name "rust-zerovec-derive")
    (version "0.11.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zerovec-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13zms8hj7vzpfswypwggyfr4ckmyc7v3di49pmj8r1qcz9z275jv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Custom derive for the zerovec crate")
    (description "This package provides Custom derive for the zerovec crate.")
    (license license:unicode3)))

(define-public rust-yoke-derive-0.8
  (package
    (name "rust-yoke-derive")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yoke-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dha5jrjz9jaq8kmxq1aag86b98zbnm9lyjrihy5sv716sbkrniq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-synstructure" ,rust-synstructure-0.13))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Custom derive for the yoke crate")
    (description "This package provides Custom derive for the yoke crate.")
    (license license:unicode3)))

(define-public rust-yoke-0.8
  (package
    (name "rust-yoke")
    (version "0.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "yoke" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1k4mfr48vgi7wh066y11b7v1ilakghlnlhw9snzz8vi2p00vnhaz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-stable-deref-trait" ,rust-stable-deref-trait-1)
                       ("rust-yoke-derive" ,rust-yoke-derive-0.8)
                       ("rust-zerofrom" ,rust-zerofrom-0.1))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis
     "Abstraction allowing borrowed data to be carried along with the backing data it borrows from")
    (description
     "This package provides Abstraction allowing borrowed data to be carried along with the backing data it
borrows from.")
    (license license:unicode3)))

(define-public rust-zerovec-0.11
  (package
    (name "rust-zerovec")
    (version "0.11.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zerovec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0a2457fmz39k9vrrj3rm82q5ykdhgxgbwfz2r6fa6nq11q4fn1aa"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-databake" ,rust-databake-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-twox-hash" ,rust-twox-hash-2)
                       ("rust-yoke" ,rust-yoke-0.8)
                       ("rust-zerofrom" ,rust-zerofrom-0.1)
                       ("rust-zerovec-derive" ,rust-zerovec-derive-0.11))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Zero-copy vector backed by a byte array")
    (description
     "This package provides Zero-copy vector backed by a byte array.")
    (license license:unicode3)))

(define-public rust-databake-derive-0.2
  (package
    (name "rust-databake-derive")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "databake-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0d61lil2kxjhmm576plivz277qnxq277ajbyc0il5f67b04pfd38"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-synstructure" ,rust-synstructure-0.13))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "Custom derive for the databake crate")
    (description "This package provides Custom derive for the databake crate.")
    (license license:unicode3)))

(define-public rust-databake-0.2
  (package
    (name "rust-databake")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "databake" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vw3iysw45gwfhvr7jcidyr1ld7ci5696igfvsy77cdgsbifjvpz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-databake-derive" ,rust-databake-derive-0.2)
                       ("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis
     "Trait that lets structs represent themselves as (const) Rust expressions")
    (description
     "This package provides Trait that lets structs represent themselves as (const) Rust expressions.")
    (license license:unicode3)))

(define-public rust-tinystr-0.8
  (package
    (name "rust-tinystr")
    (version "0.8.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tinystr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "12sc6h3hnn6x78iycm5v6wrs2xhxph0ydm43yyn7gdfw8l8nsksx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-databake" ,rust-databake-0.2)
                       ("rust-displaydoc" ,rust-displaydoc-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-zerovec" ,rust-zerovec-0.11))))
    (home-page "https://github.com/unicode-org/icu4x")
    (synopsis "small ASCII-only bounded length string representation.")
    (description
     "This package provides a small ASCII-only bounded length string representation.")
    (license license:unicode3)))

(define-public rust-unic-langid-impl-0.9
  (package
    (name "rust-unic-langid-impl")
    (version "0.9.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid-impl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0n66kdan4cz99n8ra18i27f7w136hmppi4wc0aa7ljsd0h4bzqfw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-tinystr" ,rust-tinystr-0.8))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description
     "This package provides API for managing Unicode Language Identifiers.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unic-langid-0.9
  (package
    (name "rust-unic-langid")
    (version "0.9.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unic-langid" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "01bx59sqsx2jz4z7ppxq9kldcjq9dzadkmb2dr7iyc85kcnab2x2"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unic-langid-impl" ,rust-unic-langid-impl-0.9)
                       ("rust-unic-langid-macros" ,rust-unic-langid-macros-0.9))))
    (home-page "https://github.com/zbraniecki/unic-locale")
    (synopsis "API for managing Unicode Language Identifiers")
    (description
     "This package provides API for managing Unicode Language Identifiers.")
    (license (list license:expat license:asl2.0))))

(define-public rust-fluent-langneg-0.13
  (package
    (name "rust-fluent-langneg")
    (version "0.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-langneg" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "152yxplc11vmxkslvmaqak9x86xnavnhdqyhrh38ym37jscd0jic"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "http://projectfluent.org/")
    (synopsis "library for language and locale negotiation.")
    (description
     "This package provides a library for language and locale negotiation.")
    (license license:asl2.0)))

(define-public rust-fluent-bundle-0.15
  (package
    (name "rust-fluent-bundle")
    (version "0.15.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent-bundle" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14zl0cjn361is69pb1zry4k2zzh5nzsfv0iz05wccl00x0ga5q3z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fluent-langneg" ,rust-fluent-langneg-0.13)
                       ("rust-fluent-syntax" ,rust-fluent-syntax-0.11)
                       ("rust-intl-memoizer" ,rust-intl-memoizer-0.5)
                       ("rust-intl-pluralrules" ,rust-intl-pluralrules-7)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-self-cell" ,rust-self-cell-0.10)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "https://www.projectfluent.org")
    (synopsis
     "low-level implementation of a collection of localization messages for a single locale for Project Fluent,
a localization system designed to unleash the entire expressive power of natural language translations.")
    (description
     "This package provides a low-level implementation of a collection of localization
messages for a single locale for Project Fluent, a localization system designed
to unleash the entire expressive power of natural language translations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-fluent-0.16
  (package
    (name "rust-fluent")
    (version "0.16.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fluent" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0njmdpwz52yjzyp55iik9k6vrixqiy7190d98pk0rgdy0x3n6x5v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fluent-bundle" ,rust-fluent-bundle-0.15)
                       ("rust-fluent-pseudo" ,rust-fluent-pseudo-0.3)
                       ("rust-unic-langid" ,rust-unic-langid-0.9))))
    (home-page "https://www.projectfluent.org")
    (synopsis
     "An umbrella crate exposing the combined features of fluent-rs crates with additional convenience macros for Project Fluent,
a localization system designed to unleash the entire expressive power of natural language translations.")
    (description
     "This package provides An umbrella crate exposing the combined features of fluent-rs crates with
additional convenience macros for Project Fluent, a localization system designed
to unleash the entire expressive power of natural language translations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-i18n-embed-0.15
  (package
    (name "rust-i18n-embed")
    (version "0.15.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "i18n-embed" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1i04hjbwg1y0sgvqbfvq54sf70k7rngrkgnx0vgnszprjcngr7v6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arc-swap" ,rust-arc-swap-1)
                       ("rust-fluent" ,rust-fluent-0.16)
                       ("rust-fluent-langneg" ,rust-fluent-langneg-0.13)
                       ("rust-fluent-syntax" ,rust-fluent-syntax-0.11)
                       ("rust-gettext" ,rust-gettext-0.4)
                       ("rust-i18n-embed-impl" ,rust-i18n-embed-impl-0.8)
                       ("rust-intl-memoizer" ,rust-intl-memoizer-0.5)
                       ("rust-locale-config" ,rust-locale-config-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-notify" ,rust-notify-8)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-rust-embed" ,rust-rust-embed-8)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-tr" ,rust-tr-0.1)
                       ("rust-unic-langid" ,rust-unic-langid-0.9)
                       ("rust-walkdir" ,rust-walkdir-2)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page
     "https://github.com/kellpossible/cargo-i18n/tree/master/i18n-embed")
    (synopsis
     "Traits and macros to conveniently embed localization assets into your application binary or library in order to localize it at runtime")
    (description
     "This package provides Traits and macros to conveniently embed localization assets into your
application binary or library in order to localize it at runtime.")
    (license license:expat)))

(define-public rust-egui-plot-0.32
  (package
    (name "rust-egui-plot")
    (version "0.32.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "egui_plot" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rj3msl52w6i8cg2m76h1z88ys1vzcv11rykd5n2ylza8qmhkbhl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-egui" ,rust-egui-0.31)
                       ("rust-emath" ,rust-emath-0.31)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui_plot")
    (synopsis "Immediate mode plotting for the egui GUI library")
    (description
     "This package provides Immediate mode plotting for the egui GUI library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-pollster-macro-0.4
  (package
    (name "rust-pollster-macro")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pollster-macro" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04y1w09aj005xrwg9b3bp3xpgcvxhq30iljibdy8hl3a20hs8pdc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/zesterer/pollster")
    (synopsis "Proc-macro crate for pollster")
    (description "This package provides Proc-macro crate for pollster.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-pollster-0.4
  (package
    (name "rust-pollster")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pollster" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qqcn0h2bvmgm9rlhfrdk7lfaiw1ad86g9500bhx1rj1s0c9yfig"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-pollster-macro" ,rust-pollster-macro-0.4))))
    (home-page "https://github.com/zesterer/pollster")
    (synopsis "Synchronously block the thread until a future completes")
    (description
     "This package provides Synchronously block the thread until a future completes.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-glutin-winit-0.5
  (package
    (name "rust-glutin-winit")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "glutin-winit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "13vqsdsyn9ww7sg3cx05jfgbihwn388vp3yb527p5z7qfmqcmvc5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cfg-aliases" ,rust-cfg-aliases-0.2)
                       ("rust-glutin" ,rust-glutin-0.32)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.6)
                       ("rust-winit" ,rust-winit-0.30))))
    (home-page "https://github.com/rust-windowing/glutin")
    (synopsis "Glutin bootstrapping helpers with winit")
    (description
     "This package provides Glutin bootstrapping helpers with winit.")
    (license license:expat)))

(define-public rust-egui-glow-0.31
  (package
    (name "rust-egui-glow")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "egui_glow" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17mb7akl9sgz37cd5bk8mvfi93k90zysc4pcg0invsj2y3ihc2ci"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-egui" ,rust-egui-0.31)
                       ("rust-egui-winit" ,rust-egui-winit-0.31)
                       ("rust-glow" ,rust-glow-0.16)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memoffset" ,rust-memoffset-0.9)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-web-sys" ,rust-web-sys-0.3)
                       ("rust-winit" ,rust-winit-0.30))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/egui_glow")
    (synopsis "Bindings for using egui natively using the glow library")
    (description
     "This package provides Bindings for using egui natively using the glow library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-accesskit-windows-0.24
  (package
    (name "rust-accesskit-windows")
    (version "0.24.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit_windows" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "10axvfzdhfxx6bfxigqj7m56jk9pb7l3brr3p290jrvh7p9dbz14"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.17)
                       ("rust-accesskit-consumer" ,rust-accesskit-consumer-0.26)
                       ("rust-hashbrown" ,rust-hashbrown-0.15)
                       ("rust-paste" ,rust-paste-1)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-windows" ,rust-windows-0.58)
                       ("rust-windows-core" ,rust-windows-core-0.58))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis "AccessKit UI accessibility infrastructure: Windows adapter")
    (description
     "This package provides @code{AccessKit} UI accessibility infrastructure: Windows adapter.")
    (license (list license:expat license:asl2.0))))

(define-public rust-atspi-proxies-0.6
  (package
    (name "rust-atspi-proxies")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "atspi-proxies" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "15klmd0v0wkxgnhxjm456hr513a5rmml88lparkzjk2j7vgcbrm5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-atspi-common" ,rust-atspi-common-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-zbus" ,rust-zbus-4)
                       ("rust-zvariant" ,rust-zvariant-4))))
    (home-page "https://github.com/odilia-app/atspi")
    (synopsis "AT-SPI2 proxies to query or manipulate UI objects")
    (description
     "This package provides AT-SPI2 proxies to query or manipulate UI objects.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-atspi-connection-0.6
  (package
    (name "rust-atspi-connection")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "atspi-connection" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0crkhx5k9vmg1hcyciycvgsmhfwf471grh6926jsljsac9h5j323"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-atspi-common" ,rust-atspi-common-0.6)
                       ("rust-atspi-proxies" ,rust-atspi-proxies-0.6)
                       ("rust-futures-lite" ,rust-futures-lite-2)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-zbus" ,rust-zbus-4))))
    (home-page "https://github.com/odilia-app/atspi/")
    (synopsis
     "method of connecting, querying, sending and receiving over AT-SPI.")
    (description
     "This package provides a method of connecting, querying, sending and receiving
over AT-SPI.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-atspi-0.22
  (package
    (name "rust-atspi")
    (version "0.22.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "atspi" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1gzcbibkifim95pwd16ci1gfcv5qmai9n67dn5xj6d8fclb4nlxy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-atspi-common" ,rust-atspi-common-0.6)
                       ("rust-atspi-connection" ,rust-atspi-connection-0.6)
                       ("rust-atspi-proxies" ,rust-atspi-proxies-0.6)
                       ("rust-zbus" ,rust-zbus-4))))
    (home-page "https://github.com/odilia-app/atspi")
    (synopsis "Pure-Rust, zbus-based AT-SPI2 protocol implementation")
    (description
     "This package provides Pure-Rust, zbus-based AT-SPI2 protocol implementation.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-zbus-lockstep-macros-0.4
  (package
    (name "rust-zbus-lockstep-macros")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zbus-lockstep-macros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kpcwcm5m74pif6z7k0b8dc94833jlin1cz7bgw2mckwql7v56kh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2)
                       ("rust-zbus-lockstep" ,rust-zbus-lockstep-0.4)
                       ("rust-zbus-xml" ,rust-zbus-xml-4)
                       ("rust-zvariant" ,rust-zvariant-4))))
    (home-page "https://github.com/luukvanderduim/zbus-lockstep")
    (synopsis "Macros to keep types in lockstep with DBus XML definitions")
    (description
     "This package provides Macros to keep types in lockstep with DBus XML definitions.")
    (license license:expat)))

(define-public rust-zbus-lockstep-0.4
  (package
    (name "rust-zbus-lockstep")
    (version "0.4.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "zbus-lockstep" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07gdv18ppzb3i4fvlml7l43yb2mv4v4mah0mvsmdv6q9xgfcb8jc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-zbus-xml" ,rust-zbus-xml-4)
                       ("rust-zvariant" ,rust-zvariant-4))))
    (home-page "https://github.com/luukvanderduim/zbus-lockstep")
    (synopsis "Keep types in lockstep with DBus XML definitions")
    (description
     "This package provides Keep types in lockstep with DBus XML definitions.")
    (license license:expat)))

(define-public rust-atspi-common-0.6
  (package
    (name "rust-atspi-common")
    (version "0.6.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "atspi-common" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "19vbpgkzbzlq6n718j3a0n57wl0q4lciscc9bm81f2hxq0nys28r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-enumflags2" ,rust-enumflags2-0.7)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-zbus" ,rust-zbus-4)
                       ("rust-zbus-lockstep" ,rust-zbus-lockstep-0.4)
                       ("rust-zbus-lockstep-macros" ,rust-zbus-lockstep-macros-0.4)
                       ("rust-zbus-names" ,rust-zbus-names-3)
                       ("rust-zvariant" ,rust-zvariant-4))))
    (home-page "https://github.com/odilia-app/atspi")
    (synopsis
     "Primitive types used for sending and receiving Linux accessibility events")
    (description
     "This package provides Primitive types used for sending and receiving Linux accessibility events.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-accesskit-atspi-common-0.10
  (package
    (name "rust-accesskit-atspi-common")
    (version "0.10.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit_atspi_common" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0kwxz7m6qrc980whvv5bswjfhnanzd44vbwdd6c9954ldrgdapbw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.17)
                       ("rust-accesskit-consumer" ,rust-accesskit-consumer-0.26)
                       ("rust-atspi-common" ,rust-atspi-common-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-zvariant" ,rust-zvariant-4))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis
     "AccessKit UI accessibility infrastructure: core AT-SPI translation layer")
    (description
     "This package provides @code{AccessKit} UI accessibility infrastructure: core AT-SPI translation layer.")
    (license (list license:expat license:asl2.0))))

(define-public rust-accesskit-unix-0.13
  (package
    (name "rust-accesskit-unix")
    (version "0.13.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit_unix" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xbk494i6lvgfx9r1s4zh41cv4xnx03rrbzd6f66g20dq8f7bvpw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.17)
                       ("rust-accesskit-atspi-common" ,rust-accesskit-atspi-common-0.10)
                       ("rust-async-channel" ,rust-async-channel-2)
                       ("rust-async-executor" ,rust-async-executor-1)
                       ("rust-async-task" ,rust-async-task-4)
                       ("rust-atspi" ,rust-atspi-0.22)
                       ("rust-futures-lite" ,rust-futures-lite-2)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tokio" ,rust-tokio-1)
                       ("rust-tokio-stream" ,rust-tokio-stream-0.1)
                       ("rust-zbus" ,rust-zbus-4))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis "AccessKit UI accessibility infrastructure: Linux adapter")
    (description
     "This package provides @code{AccessKit} UI accessibility infrastructure: Linux adapter.")
    (license (list license:expat license:asl2.0))))

(define-public rust-immutable-chunkmap-2
  (package
    (name "rust-immutable-chunkmap")
    (version "2.0.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "immutable-chunkmap" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0y75vr21qpik3apifqkvhhlddk72xri7i5dqia7lzm88ynb71y8j"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/estokes/immutable-chunkmap")
    (synopsis
     "fast immutable map and set with batch insert and update methods, COW operations, and big O efficient implementations of set and merge operations")
    (description
     "This package provides a fast immutable map and set with batch insert and update
methods, COW operations, and big O efficient implementations of set and merge
operations.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-accesskit-consumer-0.26
  (package
    (name "rust-accesskit-consumer")
    (version "0.26.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit_consumer" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0n9lwv8znk409k06liz5icw1kijm7v3ahxy076dblh2912hq6ygl"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.17)
                       ("rust-hashbrown" ,rust-hashbrown-0.15)
                       ("rust-immutable-chunkmap" ,rust-immutable-chunkmap-2))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis "AccessKit consumer library (internal)")
    (description
     "This package provides @code{AccessKit} consumer library (internal).")
    (license (list license:expat license:asl2.0))))

(define-public rust-accesskit-macos-0.18
  (package
    (name "rust-accesskit-macos")
    (version "0.18.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit_macos" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1qgcinxf6j8rmvwwkd3h9k30vb73779kpq6jlw1iw46i7cgq4abk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.17)
                       ("rust-accesskit-consumer" ,rust-accesskit-consumer-0.26)
                       ("rust-hashbrown" ,rust-hashbrown-0.15)
                       ("rust-objc2" ,rust-objc2-0.5)
                       ("rust-objc2-app-kit" ,rust-objc2-app-kit-0.2)
                       ("rust-objc2-foundation" ,rust-objc2-foundation-0.2))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis "AccessKit UI accessibility infrastructure: macOS adapter")
    (description
     "This package provides @code{AccessKit} UI accessibility infrastructure: @code{macOS} adapter.")
    (license (list license:expat license:asl2.0))))

(define-public rust-accesskit-winit-0.23
  (package
    (name "rust-accesskit-winit")
    (version "0.23.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit_winit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0yg8llkj97yn6afsqmw1xgcwswmzqg32r9f7kzmns2skspd4hska"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.17)
                       ("rust-accesskit-macos" ,rust-accesskit-macos-0.18)
                       ("rust-accesskit-unix" ,rust-accesskit-unix-0.13)
                       ("rust-accesskit-windows" ,rust-accesskit-windows-0.24)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.6)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.5)
                       ("rust-winit" ,rust-winit-0.30))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis "AccessKit UI accessibility infrastructure: winit adapter")
    (description
     "This package provides @code{AccessKit} UI accessibility infrastructure: winit adapter.")
    (license license:asl2.0)))

(define-public rust-egui-winit-0.31
  (package
    (name "rust-egui-winit")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "egui-winit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "04vynqd58xn5xgabkfkvwx9c45arxs88nlmd74x9rsz4iyvzp7bx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit-winit" ,rust-accesskit-winit-0.23)
                       ("rust-ahash" ,rust-ahash-0.8)
                       ("rust-arboard" ,rust-arboard-3)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-egui" ,rust-egui-0.31)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-smithay-clipboard" ,rust-smithay-clipboard-0.7)
                       ("rust-wayland-cursor" ,rust-wayland-cursor-0.31)
                       ("rust-web-time" ,rust-web-time-1)
                       ("rust-webbrowser" ,rust-webbrowser-1)
                       ("rust-winit" ,rust-winit-0.30))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/egui-winit")
    (synopsis "Bindings for using egui with winit")
    (description "This package provides Bindings for using egui with winit.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wgpu-types-24
  (package
    (name "rust-wgpu-types")
    (version "24.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wgpu-types" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1766glidvy6g7lw52baycrrsh46h0p2nly77g01kmh3n1r609b2h"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://wgpu.rs/")
    (synopsis
     "Common types and utilities for wgpu, the cross-platform, safe, pure-rust graphics API")
    (description
     "This package provides Common types and utilities for wgpu, the cross-platform, safe, pure-rust
graphics API.")
    (license (list license:expat license:asl2.0))))

(define-public rust-renderdoc-sys-1
  (package
    (name "rust-renderdoc-sys")
    (version "1.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "renderdoc-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cj8zjs7k0gvchcx3jhpg8r9bbqy8b1hsgbz0flcq2ydn12hmcqr"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page
     "https://github.com/ebkalderon/renderdoc-rs/tree/master/renderdoc-sys")
    (synopsis "Low-level bindings to the RenderDoc API")
    (description
     "This package provides Low-level bindings to the @code{RenderDoc} API.")
    (license (list license:expat license:asl2.0))))

(define-public rust-range-alloc-0.1
  (package
    (name "rust-range-alloc")
    (version "0.1.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "range-alloc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1plvrb6gaaa5in2fjv67wgs9aki8qrczz77qcjhqw2d5ccb87mn3"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/gfx-rs/range-alloc")
    (synopsis "Generic range allocator")
    (description "This package provides Generic range allocator.")
    (license (list license:expat license:asl2.0))))

(define-public rust-metal-0.31
  (package
    (name "rust-metal")
    (version "0.31.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "metal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17pr30nl0djac4qvwjh3fj9wwc4ic8cwn4wqsqx79dchcjagnsgm"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-block" ,rust-block-0.1)
                       ("rust-core-graphics-types" ,rust-core-graphics-types-0.1)
                       ("rust-dispatch" ,rust-dispatch-0.2)
                       ("rust-foreign-types" ,rust-foreign-types-0.5)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-objc" ,rust-objc-0.2)
                       ("rust-paste" ,rust-paste-1))))
    (home-page "https://github.com/gfx-rs/metal-rs")
    (synopsis "Rust bindings for Metal")
    (description "This package provides Rust bindings for Metal.")
    (license (list license:expat license:asl2.0))))

(define-public rust-mach-dxcompiler-rs-0.1
  (package
    (name "rust-mach-dxcompiler-rs")
    (version "0.1.4+2024.11.22-df583a3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mach-dxcompiler-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1y0qn2j37hfbg49f65vd9jj0pipi5ia7028m749hdfm2irzdcg0f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bindgen" ,rust-bindgen-0.71)
                       ("rust-cc" ,rust-cc-1))))
    (home-page "https://github.com/DouglasDwyer/mach-dxcompiler-rs")
    (synopsis "Prebuilt, statically-linked DXC.")
    (description "This package provides Prebuilt, statically-linked DXC.")
    (license license:expat)))

(define-public rust-khronos-egl-6
  (package
    (name "rust-khronos-egl")
    (version "6.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "khronos-egl" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xnzdx0n1bil06xmh8i1x6dbxvk7kd2m70bbm6nw1qzc43r1vbka"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libc" ,rust-libc-0.2)
                       ("rust-libloading" ,rust-libloading-0.8)
                       ("rust-pkg-config" ,rust-pkg-config-0.3))))
    (home-page "https://github.com/timothee-haudebourg/khronos-egl")
    (synopsis "Rust bindings for EGL")
    (description "This package provides Rust bindings for EGL.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gpu-descriptor-types-0.2
  (package
    (name "rust-gpu-descriptor-types")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gpu-descriptor-types" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "14ab90klss7w0ybj95fcnqxjsjya17xjhf576dpvi4zq5ml45wpx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2))))
    (home-page "https://github.com/zakarumych/gpu-descriptor")
    (synopsis "Core types of gpu-descriptor crate")
    (description "This package provides Core types of gpu-descriptor crate.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gpu-descriptor-0.3
  (package
    (name "rust-gpu-descriptor")
    (version "0.3.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gpu-descriptor" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jm0acxkw9lrzzcbvjqynwdr53qsqz7vx5d8c8h77qq5j4s8775q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-gpu-descriptor-types" ,rust-gpu-descriptor-types-0.2)
                       ("rust-hashbrown" ,rust-hashbrown-0.15)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-tracing" ,rust-tracing-0.1))))
    (home-page "https://github.com/zakarumych/gpu-descriptor")
    (synopsis
     "Implementation agnostic descriptor allocator for Vulkan like APIs")
    (description
     "This package provides Implementation agnostic descriptor allocator for Vulkan like APIs.")
    (license (list license:expat license:asl2.0))))

(define-public rust-presser-0.3
  (package
    (name "rust-presser")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "presser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ykvqx861sjmhkdh540aafqba7i7li7gqgwrcczy6v56i9m8xkz8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/EmbarkStudios/presser")
    (synopsis
     "crate to help you copy things into raw buffers without invoking spooky action at a distance (undefined behavior).")
    (description
     "This package provides a crate to help you copy things into raw buffers without
invoking spooky action at a distance (undefined behavior).")
    (license (list license:expat license:asl2.0))))

(define-public rust-metal-0.29
  (package
    (name "rust-metal")
    (version "0.29.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "metal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "08gsqxnj0pq1018c8l4q0377i7gsrrqkrb7vyv0vfmlcdwlx7kvy"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-block" ,rust-block-0.1)
                       ("rust-core-graphics-types" ,rust-core-graphics-types-0.1)
                       ("rust-dispatch" ,rust-dispatch-0.2)
                       ("rust-foreign-types" ,rust-foreign-types-0.5)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-objc" ,rust-objc-0.2)
                       ("rust-paste" ,rust-paste-1))))
    (home-page "https://github.com/gfx-rs/metal-rs")
    (synopsis "Rust bindings for Metal")
    (description "This package provides Rust bindings for Metal.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-vo-0.1
  (package
    (name "rust-unicode-vo")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unicode-vo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "151sha088v9jyfvbg5164xh4dk72g53b82xm4zzbf5dlagzqdlxi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/unicode-vo")
    (synopsis "Unicode vertical orientation detection")
    (description
     "This package provides Unicode vertical orientation detection.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-script-0.5
  (package
    (name "rust-unicode-script")
    (version "0.5.7")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unicode-script" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07vwr9iddw5xwrj57hc6ig0mwmlzjdajj9lyfxqz9by9a2rj3d4z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-rustc-std-workspace-std" ,rust-rustc-std-workspace-std-1))))
    (home-page "https://github.com/unicode-rs/unicode-script")
    (synopsis
     "This crate exposes the Unicode `Script` and `Script_Extension` properties from [UAX #24](http://www.unicode.org/reports/tr24/)")
    (description
     "This crate exposes the Unicode `Script` and `Script_Extension` properties from
[UAX #24](http://www.unicode.org/reports/tr24/).")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-properties-0.1
  (package
    (name "rust-unicode-properties")
    (version "0.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unicode-properties" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l3mbgzwz8g14xcs09p4ww3hjkjcf0i1ih13nsg72bhj8n5jl3z7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/unicode-rs/unicode-properties")
    (synopsis "Query character Unicode properties according to
UAX #44 and UTR #51.")
    (description
     "This package provides Query character Unicode properties according to UAX #44 and UTR #51.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-ccc-0.1
  (package
    (name "rust-unicode-ccc")
    (version "0.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unicode-ccc" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1wbwny92wzmck2cix5h3r97h9z57x9831kadrs6jdy24lvpj09fc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/unicode-ccc")
    (synopsis "Unicode Canonical Combining Class detection")
    (description
     "This package provides Unicode Canonical Combining Class detection.")
    (license (list license:expat license:asl2.0))))

(define-public rust-unicode-bidi-mirroring-0.1
  (package
    (name "rust-unicode-bidi-mirroring")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "unicode-bidi-mirroring" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "150navn2n6barkzchv96n877i17m1754nzmy1282zmcjzdh25lan"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/unicode-bidi-mirroring")
    (synopsis "Unicode Bidi Mirroring property detection")
    (description
     "This package provides Unicode Bidi Mirroring property detection.")
    (license (list license:expat license:asl2.0))))

(define-public rust-rustybuzz-0.12
  (package
    (name "rust-rustybuzz")
    (version "0.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rustybuzz" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0b12arlca4lfniphg91v9s5awkl7szpdwc18walxdamyqn95dbph"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-libm" ,rust-libm-0.2)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-ttf-parser" ,rust-ttf-parser-0.20)
                       ("rust-unicode-bidi-mirroring" ,rust-unicode-bidi-mirroring-0.1)
                       ("rust-unicode-ccc" ,rust-unicode-ccc-0.1)
                       ("rust-unicode-properties" ,rust-unicode-properties-0.1)
                       ("rust-unicode-script" ,rust-unicode-script-0.5))))
    (home-page "https://github.com/harfbuzz/rustybuzz")
    (synopsis "complete harfbuzz shaping algorithm port to Rust.")
    (description
     "This package provides a complete harfbuzz shaping algorithm port to Rust.")
    (license license:expat)))

(define-public rust-ttf-parser-0.20
  (package
    (name "rust-ttf-parser")
    (version "0.20.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ttf-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1d4n3p9ccjvy4mj72700i0c2q6d49dxjpwflw47q79rpv1v7vxqp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/harfbuzz/ttf-parser")
    (synopsis
     "high-level, safe, zero-allocation font parser for TrueType, OpenType, and AAT.")
    (description
     "This package provides a high-level, safe, zero-allocation font parser for
@code{TrueType}, @code{OpenType}, and AAT.")
    (license (list license:expat license:asl2.0))))

(define-public rust-fontconfig-parser-0.5
  (package
    (name "rust-fontconfig-parser")
    (version "0.5.8")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fontconfig-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ijnbzg31sl6v49g7q2l7sl76hjj8z0hvlsz77cdvm029vi77ixv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4)
                       ("rust-roxmltree" ,rust-roxmltree-0.20)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/Riey/fontconfig-parser")
    (synopsis "fontconfig file parser in pure Rust")
    (description "This package provides fontconfig file parser in pure Rust.")
    (license license:expat)))

(define-public rust-fontdb-0.16
  (package
    (name "rust-fontdb")
    (version "0.16.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "fontdb" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hqxv3jnh06s4bflrwnb39mi3knllfs4mxm44vsn0gzgqch90adh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fontconfig-parser" ,rust-fontconfig-parser-0.5)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-memmap2" ,rust-memmap2-0.9)
                       ("rust-slotmap" ,rust-slotmap-1)
                       ("rust-tinyvec" ,rust-tinyvec-1)
                       ("rust-ttf-parser" ,rust-ttf-parser-0.20))))
    (home-page "https://github.com/RazrFalcon/fontdb")
    (synopsis "simple, in-memory font database with CSS-like queries.")
    (description
     "This package provides a simple, in-memory font database with CSS-like queries.")
    (license license:expat)))

(define-public rust-usvg-text-layout-0.37
  (package
    (name "rust-usvg-text-layout")
    (version "0.37.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "usvg-text-layout" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0z53l1fn10mz76dclgbzvs36xx2rv16s84afdpwxg6g1bnba70yk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-fontdb" ,rust-fontdb-0.16)
                       ("rust-kurbo" ,rust-kurbo-0.9)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-rustybuzz" ,rust-rustybuzz-0.12)
                       ("rust-unicode-bidi" ,rust-unicode-bidi-0.3)
                       ("rust-unicode-script" ,rust-unicode-script-0.5)
                       ("rust-unicode-vo" ,rust-unicode-vo-0.1)
                       ("rust-usvg-tree" ,rust-usvg-tree-0.37))))
    (home-page "https://github.com/RazrFalcon/resvg")
    (synopsis "An SVG text layout implementation")
    (description "This package provides An SVG text layout implementation.")
    (license license:mpl2.0)))

(define-public rust-strict-num-0.1
  (package
    (name "rust-strict-num")
    (version "0.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "strict-num" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0cb7l1vhb8zj90mzm8avlk815k40sql9515s865rqdrdfavvldv6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-float-cmp" ,rust-float-cmp-0.9))))
    (home-page "https://github.com/RazrFalcon/strict-num")
    (synopsis "collection of bounded numeric types")
    (description
     "This package provides a collection of bounded numeric types.")
    (license license:expat)))

(define-public rust-rctree-0.5
  (package
    (name "rust-rctree")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "rctree" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0kvzahkwriawhjjb08ai7rfi77px7rpx5h83hjcx6dccyxzf4hiv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/RazrFalcon/rctree")
    (synopsis "'DOM-like' tree implemented using reference counting")
    (description
     "This package provides a DOM-like tree implemented using reference counting.")
    (license license:expat)))

(define-public rust-usvg-tree-0.37
  (package
    (name "rust-usvg-tree")
    (version "0.37.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "usvg-tree" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ly7dsbvl5k478vjxkr3svpj947gsssgbf04aqhsd5yvxc1d5qwf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rctree" ,rust-rctree-0.5)
                       ("rust-strict-num" ,rust-strict-num-0.1)
                       ("rust-svgtypes" ,rust-svgtypes-0.13)
                       ("rust-tiny-skia-path" ,rust-tiny-skia-path-0.11))))
    (home-page "https://github.com/RazrFalcon/resvg")
    (synopsis "An SVG tree representation used by usvg")
    (description
     "This package provides An SVG tree representation used by usvg.")
    (license license:mpl2.0)))

(define-public rust-simplecss-0.2
  (package
    (name "rust-simplecss")
    (version "0.2.2")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "simplecss" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0v0kid7b2602kcka2x2xs9wwfjf8lnvpgpl8x287qg4wra1ni73s"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-log" ,rust-log-0.4))))
    (home-page "https://github.com/linebender/simplecss")
    (synopsis "simple CSS 2 parser and selector.")
    (description "This package provides a simple CSS 2 parser and selector.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-imagesize-0.12
  (package
    (name "rust-imagesize")
    (version "0.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "imagesize" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "114jvqiyv13il1qghv2xm0xqrcjm68fh282hdlzdds6qfgsp7782"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/Roughsketch/imagesize")
    (synopsis
     "Quick probing of image dimensions without loading the entire file")
    (description
     "This package provides Quick probing of image dimensions without loading the entire file.")
    (license license:expat)))

(define-public rust-usvg-parser-0.37
  (package
    (name "rust-usvg-parser")
    (version "0.37.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "usvg-parser" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1p1bkbrrl6i0j6yyf0gx3f9f4icjh5n0y7x354liapglj71f7m4v"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-data-url" ,rust-data-url-0.3)
                       ("rust-flate2" ,rust-flate2-1)
                       ("rust-imagesize" ,rust-imagesize-0.12)
                       ("rust-kurbo" ,rust-kurbo-0.9)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-roxmltree" ,rust-roxmltree-0.19)
                       ("rust-simplecss" ,rust-simplecss-0.2)
                       ("rust-siphasher" ,rust-siphasher-0.3)
                       ("rust-svgtypes" ,rust-svgtypes-0.13)
                       ("rust-usvg-tree" ,rust-usvg-tree-0.37))))
    (home-page "https://github.com/RazrFalcon/resvg")
    (synopsis "An SVG parser used by usvg")
    (description "This package provides An SVG parser used by usvg.")
    (license license:mpl2.0)))

(define-public rust-usvg-0.37
  (package
    (name "rust-usvg")
    (version "0.37.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "usvg" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0mm7c70ssc5czrhkwrb44ybixyxlxvz7fsqj3m8wm05bf8dsbc1q"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-base64" ,rust-base64-0.21)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-pico-args" ,rust-pico-args-0.5)
                       ("rust-usvg-parser" ,rust-usvg-parser-0.37)
                       ("rust-usvg-text-layout" ,rust-usvg-text-layout-0.37)
                       ("rust-usvg-tree" ,rust-usvg-tree-0.37)
                       ("rust-xmlwriter" ,rust-xmlwriter-0.1))))
    (home-page "https://github.com/linebender/resvg")
    (synopsis "An SVG simplification library")
    (description "This package provides An SVG simplification library.")
    (license license:mpl2.0)))

(define-public rust-kurbo-0.9
  (package
    (name "rust-kurbo")
    (version "0.9.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "kurbo" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "16w4k313z8smic4zifpwnxk8alh17dncgj2r40p0ql6rdivsb1dx"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-libm" ,rust-libm-0.2)
                       ("rust-mint" ,rust-mint-0.5)
                       ("rust-schemars" ,rust-schemars-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/linebender/kurbo")
    (synopsis "2D curves library")
    (description "This package provides a 2D curves library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-svgtypes-0.13
  (package
    (name "rust-svgtypes")
    (version "0.13.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "svgtypes" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0w4xknlff1np8l9if7y8ig6bx44bjr006m5xgj8ih0wnrn4f4i3f"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-kurbo" ,rust-kurbo-0.9)
                       ("rust-siphasher" ,rust-siphasher-0.3))))
    (home-page "https://github.com/linebender/svgtypes")
    (synopsis "SVG types parser")
    (description "This package provides SVG types parser.")
    (license (list license:expat license:asl2.0))))

(define-public rust-resvg-0.37
  (package
    (name "rust-resvg")
    (version "0.37.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "resvg" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1x7idkc9fzgfjx301z675vdh1r6b6avzn5hcw3jvivx9k4ywpp6a"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-gif" ,rust-gif-0.12)
                       ("rust-jpeg-decoder" ,rust-jpeg-decoder-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-pico-args" ,rust-pico-args-0.5)
                       ("rust-png" ,rust-png-0.17)
                       ("rust-rgb" ,rust-rgb-0.8)
                       ("rust-svgtypes" ,rust-svgtypes-0.13)
                       ("rust-tiny-skia" ,rust-tiny-skia-0.11)
                       ("rust-usvg" ,rust-usvg-0.37))))
    (home-page "https://github.com/linebender/resvg")
    (synopsis "An SVG rendering library")
    (description "This package provides An SVG rendering library.")
    (license license:mpl2.0)))

(define-public rust-siphasher-1
  (package
    (name "rust-siphasher")
    (version "1.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "siphasher" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "17f35782ma3fn6sh21c027kjmd227xyrx06ffi8gw4xzv9yry6an"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1))))
    (home-page "https://docs.rs/siphasher")
    (synopsis "SipHash-2-4, SipHash-1-3 and 128-bit variants in pure Rust")
    (description
     "This package provides @code{SipHash-2-4}, @code{SipHash-1-3} and 128-bit variants in pure Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-phf-shared-0.11
  (package
    (name "rust-phf-shared")
    (version "0.11.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "phf_shared" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rallyvh28jqd9i916gk5gk2igdmzlgvv5q0l3xbf3m6y8pbrsk7"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-siphasher" ,rust-siphasher-1)
                       ("rust-uncased" ,rust-uncased-0.9)
                       ("rust-unicase" ,rust-unicase-2))))
    (home-page "https://github.com/rust-phf/rust-phf")
    (synopsis "Support code shared by PHF libraries")
    (description "This package provides Support code shared by PHF libraries.")
    (license license:expat)))

(define-public rust-mime-guess2-2
  (package
    (name "rust-mime-guess2")
    (version "2.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "mime_guess2" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1jphmmvrl93bj05wdmjvx20hp2fmlgchjwd0lz0dwh71l8adq1hp"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-mime" ,rust-mime-0.3)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-phf" ,rust-phf-0.11)
                       ("rust-phf-codegen" ,rust-phf-codegen-0.11)
                       ("rust-phf-shared" ,rust-phf-shared-0.11)
                       ("rust-unicase" ,rust-unicase-2)
                       ("rust-unicase" ,rust-unicase-2))))
    (home-page "https://github.com/ttys3/mime_guess2")
    (synopsis
     "simple crate for detection of a file's MIME type by its extension.")
    (description
     "This package provides a simple crate for detection of a file's MIME type by its
extension.")
    (license license:expat)))

(define-public rust-enum-map-derive-0.17
  (package
    (name "rust-enum-map-derive")
    (version "0.17.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "enum-map-derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1sv4mb343rsz4lc3rh7cyn0pdhf7fk18k1dgq8kfn5i5x7gwz0pj"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://codeberg.org/xfix/enum-map")
    (synopsis "Macros 1.1 implementation of #[derive(Enum)]")
    (description
     "This package provides Macros 1.1 implementation of #[derive(Enum)].")
    (license (list license:expat license:asl2.0))))

(define-public rust-enum-map-2
  (package
    (name "rust-enum-map")
    (version "2.7.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "enum-map" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1sgjgl4mmz93jdkfdsmapc3dmaq8gddagw9s0fd501w2vyzz6rk8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-enum-map-derive" ,rust-enum-map-derive-0.17)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://codeberg.org/xfix/enum-map")
    (synopsis "map with C-like enum keys represented internally as an array")
    (description
     "This package provides a map with C-like enum keys represented internally as an
array.")
    (license (list license:expat license:asl2.0))))

(define-public rust-ehttp-0.5
  (package
    (name "rust-ehttp")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ehttp" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xpq5c9ni4465pa8qkh8x9g3l6d1mqcyp7cwrc3ask8y38i1ra2r"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-async-channel" ,rust-async-channel-2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-futures-util" ,rust-futures-util-0.3)
                       ("rust-getrandom" ,rust-getrandom-0.2)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-mime" ,rust-mime-0.3)
                       ("rust-mime-guess" ,rust-mime-guess-2)
                       ("rust-rand" ,rust-rand-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-serde-json" ,rust-serde-json-1)
                       ("rust-ureq" ,rust-ureq-2)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-wasm-bindgen-futures" ,rust-wasm-bindgen-futures-0.4)
                       ("rust-wasm-streams" ,rust-wasm-streams-0.4)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://github.com/emilk/ehttp")
    (synopsis "Minimal HTTP client for both native and WASM")
    (description
     "This package provides Minimal HTTP client for both native and WASM.")
    (license (list license:expat license:asl2.0))))

(define-public rust-egui-0.28
  (package
    (name "rust-egui")
    (version "0.28.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "egui" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "165pdkh84bh01vgi93w6fb7lz1ykrf957fv1y4qfd3bnl9q7xj90"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.12)
                       ("rust-ahash" ,rust-ahash-0.8)
                       ("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-emath" ,rust-emath-0.28)
                       ("rust-epaint" ,rust-epaint-0.28)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
                       ("rust-puffin" ,rust-puffin-0.19)
                       ("rust-ron" ,rust-ron-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui")
    (synopsis
     "An easy-to-use immediate mode GUI that runs on both web and native")
    (description
     "This package provides An easy-to-use immediate mode GUI that runs on both web and native.")
    (license (list license:expat license:asl2.0))))

(define-public rust-egui-extras-0.28
  (package
    (name "rust-egui-extras")
    (version "0.28.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "egui_extras" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0s0kz134fzhfb9175rwc3r0vfr5qgxildfvzcd70hx9d5qbam76y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-chrono" ,rust-chrono-0.4)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-egui" ,rust-egui-0.28)
                       ("rust-ehttp" ,rust-ehttp-0.5)
                       ("rust-enum-map" ,rust-enum-map-2)
                       ("rust-image" ,rust-image-0.25)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mime-guess2" ,rust-mime-guess2-2)
                       ("rust-puffin" ,rust-puffin-0.19)
                       ("rust-resvg" ,rust-resvg-0.37)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-syntect" ,rust-syntect-5))))
    (home-page "https://github.com/emilk/egui")
    (synopsis "Extra functionality and widgets for the egui GUI library")
    (description
     "This package provides Extra functionality and widgets for the egui GUI library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-ecolor-0.28
  (package
    (name "rust-ecolor")
    (version "0.28.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ecolor" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1y4naczxw525dklls43fw1yjrzgciyvg3irzygh6sgqly4glasrf"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-cint" ,rust-cint-0.3)
                       ("rust-color-hex" ,rust-color-hex-0.2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-emath" ,rust-emath-0.28)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui")
    (synopsis "Color structs and color conversion utilities")
    (description
     "This package provides Color structs and color conversion utilities.")
    (license (list license:expat license:asl2.0))))

(define-public rust-epaint-0.28
  (package
    (name "rust-epaint")
    (version "0.28.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "epaint" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "00gsnxicbjz24k4c7g89jhxz5j8kpnbvf76djh751rvi0w5cq39z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ab-glyph" ,rust-ab-glyph-0.2)
                       ("rust-ahash" ,rust-ahash-0.8)
                       ("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-ecolor" ,rust-ecolor-0.28)
                       ("rust-emath" ,rust-emath-0.28)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-puffin" ,rust-puffin-0.19)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/epaint")
    (synopsis "Minimal 2D graphics library for GUI work")
    (description
     "This package provides Minimal 2D graphics library for GUI work.")
    (license (list license:expat license:asl2.0))))

(define-public rust-emath-0.28
  (package
    (name "rust-emath")
    (version "0.28.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "emath" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1rj92asn6fbxyzkdifcgq95iyhvp9l5na2c37pv8ish5hiq22sha"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-mint" ,rust-mint-0.5)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/emath")
    (synopsis "Minimal 2D math library for GUI work")
    (description "This package provides Minimal 2D math library for GUI work.")
    (license (list license:expat license:asl2.0))))

(define-public rust-accesskit-0.12
  (package
    (name "rust-accesskit")
    (version "0.12.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0szw1d6ml049779m55h0l107abhsmchmdx58rdfjbhcr7m7v393l"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-enumn" ,rust-enumn-0.1)
                       ("rust-pyo3" ,rust-pyo3-0.20)
                       ("rust-schemars" ,rust-schemars-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis "UI accessibility infrastructure across platforms")
    (description
     "This package provides UI accessibility infrastructure across platforms.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gpu-allocator-0.27
  (package
    (name "rust-gpu-allocator")
    (version "0.27.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gpu-allocator" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1kfa6kvvslmrr63p4n5fsm8myp03xi5lzylywys9f0l0xyjs4lf1"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ash" ,rust-ash-0.38)
                       ("rust-egui" ,rust-egui-0.28)
                       ("rust-egui-extras" ,rust-egui-extras-0.28)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-metal" ,rust-metal-0.29)
                       ("rust-presser" ,rust-presser-0.3)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-winapi" ,rust-winapi-0.3)
                       ("rust-windows" ,rust-windows-0.58))))
    (home-page "https://github.com/Traverse-Research/gpu-allocator")
    (synopsis "Memory allocator for GPU memory in Vulkan and DirectX 12")
    (description
     "This package provides Memory allocator for GPU memory in Vulkan and @code{DirectX} 12.")
    (license (list license:expat license:asl2.0))))

(define-public rust-glow-0.16
  (package
    (name "rust-glow")
    (version "0.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "glow" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "022z12nlyfpy36fvp2szq792xix1xbgkznpmicf1c404sxhfmrf5"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-slotmap" ,rust-slotmap-1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-web-sys" ,rust-web-sys-0.3))))
    (home-page "https://github.com/grovesNL/glow.git")
    (synopsis
     "GL on Whatever: a set of bindings to run GL (Open GL, OpenGL ES, and WebGL) anywhere, and avoid target-specific code")
    (description
     "This package provides GL on Whatever: a set of bindings to run GL (Open GL, @code{OpenGL} ES, and
@code{WebGL}) anywhere, and avoid target-specific code.")
    (license (list license:expat license:asl2.0 license:zlib))))

(define-public rust-ash-0.38
  (package
    (name "rust-ash")
    (version "0.38.0+1.3.281")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ash" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vx4yf689v1rc680jvy8bnysx5sgd8f33wnp2vqaizh0v0v4kd0b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-libloading" ,rust-libloading-0.8))))
    (home-page "https://github.com/ash-rs/ash")
    (synopsis "Vulkan bindings for Rust")
    (description "This package provides Vulkan bindings for Rust.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wgpu-hal-24
  (package
    (name "rust-wgpu-hal")
    (version "24.0.4")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wgpu-hal" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ng2jh15wpv801lgy9bcy1ycd16b63p0i1946csrz9jccxjg84pi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-android-system-properties" ,rust-android-system-properties-0.1)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-ash" ,rust-ash-0.38)
                       ("rust-bit-set" ,rust-bit-set-0.8)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-block" ,rust-block-0.1)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-cfg-aliases" ,rust-cfg-aliases-0.2)
                       ("rust-core-graphics-types" ,rust-core-graphics-types-0.1)
                       ("rust-glow" ,rust-glow-0.16)
                       ("rust-glutin-wgl-sys" ,rust-glutin-wgl-sys-0.6)
                       ("rust-gpu-alloc" ,rust-gpu-alloc-0.6)
                       ("rust-gpu-allocator" ,rust-gpu-allocator-0.27)
                       ("rust-gpu-descriptor" ,rust-gpu-descriptor-0.3)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-khronos-egl" ,rust-khronos-egl-6)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-libloading" ,rust-libloading-0.8)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-mach-dxcompiler-rs" ,rust-mach-dxcompiler-rs-0.1)
                       ("rust-metal" ,rust-metal-0.31)
                       ("rust-naga" ,rust-naga-24)
                       ("rust-ndk-sys" ,rust-ndk-sys-0.5)
                       ("rust-objc" ,rust-objc-0.2)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-ordered-float" ,rust-ordered-float-4)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-range-alloc" ,rust-range-alloc-0.1)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.6)
                       ("rust-renderdoc-sys" ,rust-renderdoc-sys-1)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-thiserror" ,rust-thiserror-2)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-web-sys" ,rust-web-sys-0.3)
                       ("rust-wgpu-types" ,rust-wgpu-types-24)
                       ("rust-windows" ,rust-windows-0.58)
                       ("rust-windows-core" ,rust-windows-core-0.58))))
    (home-page "https://wgpu.rs/")
    (synopsis
     "Hardware abstraction layer for wgpu, the cross-platform, safe, pure-rust graphics API")
    (description
     "This package provides Hardware abstraction layer for wgpu, the cross-platform, safe, pure-rust
graphics API.")
    (license (list license:expat license:asl2.0))))

(define-public rust-bytemuck-1
  (package
    (name "rust-bytemuck")
    (version "1.23.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bytemuck" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "134mywp7bqm252c851h3bny75g0l5kw99738a1mkcjyf07pscd4i"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck-derive" ,rust-bytemuck-derive-1))))
    (home-page "https://github.com/Lokathor/bytemuck")
    (synopsis "crate for mucking around with piles of bytes.")
    (description
     "This package provides a crate for mucking around with piles of bytes.")
    (license (list license:zlib license:asl2.0 license:expat))))

(define-public rust-wgpu-core-24
  (package
    (name "rust-wgpu-core")
    (version "24.0.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wgpu-core" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "168l5qj1j5x89ia98j53b5l0jjjv21chdiwxkcb8s8vs943a62kz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-bit-vec" ,rust-bit-vec-0.8)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-cfg-aliases" ,rust-cfg-aliases-0.2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-naga" ,rust-naga-24)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.6)
                       ("rust-ron" ,rust-ron-0.8)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-thiserror" ,rust-thiserror-2)
                       ("rust-wgpu-hal" ,rust-wgpu-hal-24)
                       ("rust-wgpu-types" ,rust-wgpu-types-24))))
    (home-page "https://wgpu.rs/")
    (synopsis
     "Core implementation logic of wgpu, the cross-platform, safe, pure-rust graphics API")
    (description
     "This package provides Core implementation logic of wgpu, the cross-platform, safe, pure-rust graphics
API.")
    (license (list license:expat license:asl2.0))))

(define-public rust-spirv-0.3
  (package
    (name "rust-spirv")
    (version "0.3.0+sdk-1.3.268.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "spirv" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0i3qj7yvvprai1s03dvll2gkfy8398nl64wvllkhaaa4vh1i197d"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/gfx-rs/rspirv")
    (synopsis "Rust definition of SPIR-V structs and enums")
    (description
     "This package provides Rust definition of SPIR-V structs and enums.")
    (license license:asl2.0)))

(define-public rust-serde-derive-1
  (package
    (name "rust-serde-derive")
    (version "1.0.219")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde_derive" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "001azhjmj7ya52pmfiw4ppxm16nd44y15j2pf5gkcwrcgz7pc0jv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://serde.rs")
    (synopsis "Macros 1.1 implementation of #[derive(Serialize, Deserialize)]")
    (description
     "This package provides Macros 1.1 implementation of #[derive(Serialize, Deserialize)].")
    (license (list license:expat license:asl2.0))))

(define-public rust-serde-1
  (package
    (name "rust-serde")
    (version "1.0.219")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "serde" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1dl6nyxnsi82a197sd752128a4avm6mxnscywas1jq30srp2q3jz"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-serde-derive" ,rust-serde-derive-1)
                       ("rust-serde-derive" ,rust-serde-derive-1))))
    (home-page "https://serde.rs")
    (synopsis "generic serialization/deserialization framework")
    (description
     "This package provides a generic serialization/deserialization framework.")
    (license (list license:expat license:asl2.0))))

(define-public rust-pp-rs-0.2
  (package
    (name "rust-pp-rs")
    (version "0.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "pp-rs" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vkd9lgwf5rxy7qgzl8mka7vnghaq6nnn0nmg7mycl72ysvqnidv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://github.com/Kangz/glslpp-rs")
    (synopsis "Shader preprocessor")
    (description "This package provides Shader preprocessor.")
    (license license:bsd-3)))

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
     `(#:cargo-inputs (("rust-winapi-util" ,rust-winapi-util-0.1))))
    (home-page "https://github.com/BurntSushi/termcolor")
    (synopsis
     "simple cross platform library for writing colored text to a terminal.")
    (description
     "This package provides a simple cross platform library for writing colored text
to a terminal.")
    (license (list license:unlicense license:expat))))

(define-public rust-naga-24
  (package
    (name "rust-naga")
    (version "24.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "naga" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0klrfvqaj6h4xlv76hghqciw1c0ks07dxz6x9rrfybp5f8q9k073"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-bit-set" ,rust-bit-set-0.8)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cfg-aliases" ,rust-cfg-aliases-0.2)
                       ("rust-codespan-reporting" ,rust-codespan-reporting-0.11)
                       ("rust-hexf-parse" ,rust-hexf-parse-0.2)
                       ("rust-indexmap" ,rust-indexmap-2)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-petgraph" ,rust-petgraph-0.7)
                       ("rust-pp-rs" ,rust-pp-rs-0.2)
                       ("rust-rustc-hash" ,rust-rustc-hash-1)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-spirv" ,rust-spirv-0.3)
                       ("rust-strum" ,rust-strum-0.26)
                       ("rust-termcolor" ,rust-termcolor-1)
                       ("rust-thiserror" ,rust-thiserror-2)
                       ("rust-unicode-xid" ,rust-unicode-xid-0.2))))
    (home-page "https://github.com/gfx-rs/wgpu/tree/trunk/naga")
    (synopsis "Shader translator and validator. Part of the wgpu project")
    (description
     "This package provides Shader translator and validator.  Part of the wgpu project.")
    (license (list license:expat license:asl2.0))))

(define-public rust-bitflags-2
  (package
    (name "rust-bitflags")
    (version "2.9.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bitflags" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0rz9rpp5wywwqb3mxfkywh4drmzci2fch780q7lifbf6bsc5d3hv"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arbitrary" ,rust-arbitrary-1)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-compiler-builtins" ,rust-compiler-builtins-0.1)
                       ("rust-rustc-std-workspace-core" ,rust-rustc-std-workspace-core-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/bitflags/bitflags")
    (synopsis "macro to generate structures which behave like bitflags.")
    (description
     "This package provides a macro to generate structures which behave like bitflags.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wgpu-24
  (package
    (name "rust-wgpu")
    (version "24.0.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "wgpu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lwkafs1hyfh3rn847fnz89mijcxsgrh34kf5vgnr7vjy0v382vb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-arrayvec" ,rust-arrayvec-0.7)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-cfg-aliases" ,rust-cfg-aliases-0.2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-naga" ,rust-naga-24)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.6)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-smallvec" ,rust-smallvec-1)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-wasm-bindgen-futures" ,rust-wasm-bindgen-futures-0.4)
                       ("rust-web-sys" ,rust-web-sys-0.3)
                       ("rust-wgpu-core" ,rust-wgpu-core-24)
                       ("rust-wgpu-hal" ,rust-wgpu-hal-24)
                       ("rust-wgpu-types" ,rust-wgpu-types-24))))
    (home-page "https://wgpu.rs/")
    (synopsis "Cross-platform, safe, pure-rust graphics API")
    (description
     "This package provides Cross-platform, safe, pure-rust graphics API.")
    (license (list license:expat license:asl2.0))))

(define-public rust-type-map-0.5
  (package
    (name "rust-type-map")
    (version "0.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "type-map" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "143v32wwgpymxfy4y8s694vyq0wdi7li4s5dmms5w59nj2yxnc6b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-rustc-hash" ,rust-rustc-hash-2))))
    (home-page "https://github.com/kardeiz/type-map")
    (synopsis "Provides a typemap container with FxHashMap")
    (description
     "This package provides a typemap container with @code{FxHashMap}.")
    (license (list license:expat license:asl2.0))))

(define-public rust-egui-wgpu-0.31
  (package
    (name "rust-egui-wgpu")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "egui-wgpu" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "086q8qhxja0kkvg6386iy1swzpd2cbl3bqhlj5p9ns8gazpxy6fk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-egui" ,rust-egui-0.31)
                       ("rust-epaint" ,rust-epaint-0.31)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-thiserror" ,rust-thiserror-1)
                       ("rust-type-map" ,rust-type-map-0.5)
                       ("rust-web-time" ,rust-web-time-1)
                       ("rust-wgpu" ,rust-wgpu-24)
                       ("rust-winit" ,rust-winit-0.30))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/egui-wgpu")
    (synopsis "Bindings for using egui natively using the wgpu library")
    (description
     "This package provides Bindings for using egui natively using the wgpu library.")
    (license (list license:expat license:asl2.0))))

(define-public rust-tracy-client-sys-0.24
  (package
    (name "rust-tracy-client-sys")
    (version "0.24.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tracy-client-sys" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ps3iwb7q1fzs9pir6b0nqi8n7i67lci4jp6z4xrq8s8lmyz7zv9"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-windows-targets" ,rust-windows-targets-0.52))))
    (home-page "https://github.com/nagisa/rust_tracy_client")
    (synopsis
     "Low level bindings to the client libraries for the Tracy profiler")
    (description
     "This package provides Low level bindings to the client libraries for the Tracy profiler.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-tracy-client-0.17
  (package
    (name "rust-tracy-client")
    (version "0.17.6")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "tracy-client" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0zkwz9aq97znyal3hz9wmxya97pj01ddpv92ha7l39a6fdw2s83k"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-loom" ,rust-loom-0.7)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-rustc-demangle" ,rust-rustc-demangle-0.1)
                       ("rust-tracy-client-sys" ,rust-tracy-client-sys-0.24))))
    (home-page "https://github.com/nagisa/rust_tracy_client")
    (synopsis
     "High level bindings to the client libraries for the Tracy profiler")
    (description
     "This package provides High level bindings to the client libraries for the Tracy profiler.")
    (license (list license:expat license:asl2.0))))

(define-public rust-puffin-0.19
  (package
    (name "rust-puffin")
    (version "0.19.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "puffin" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "07vlkf4i88475a80fhckayzxr9v4pkc21kwvpjkc2bn00mxsx7gs"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-anyhow" ,rust-anyhow-1)
                       ("rust-bincode" ,rust-bincode-1)
                       ("rust-byteorder" ,rust-byteorder-1)
                       ("rust-cfg-if" ,rust-cfg-if-1)
                       ("rust-itertools" ,rust-itertools-0.10)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-lz4-flex" ,rust-lz4-flex-0.11)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-ruzstd" ,rust-ruzstd-0.4)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-web-time" ,rust-web-time-0.2)
                       ("rust-zstd" ,rust-zstd-0.12))))
    (home-page "https://github.com/EmbarkStudios/puffin")
    (synopsis "Simple instrumentation profiler for games")
    (description
     "This package provides Simple instrumentation profiler for games.")
    (license (list license:expat license:asl2.0))))

(define-public rust-profiling-procmacros-1
  (package
    (name "rust-profiling-procmacros")
    (version "1.0.16")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "profiling-procmacros" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0c7y2k4mz5dp2ksj1h4zbxsxq4plmjzccscdaml3h1pizdh2wpx6"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/aclysma/profiling")
    (synopsis
     "This crate provides a very thin abstraction over other profiler crates")
    (description
     "This crate provides a very thin abstraction over other profiler crates.")
    (license (list license:expat license:asl2.0))))

(define-public rust-profiling-1
  (package
    (name "rust-profiling")
    (version "1.0.16")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "profiling" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0kcz2xzg4qx01r5az8cf9ffjasi2srj56sna32igddh0vi7cggdg"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-optick" ,rust-optick-1)
                       ("rust-profiling-procmacros" ,rust-profiling-procmacros-1)
                       ("rust-puffin" ,rust-puffin-0.19)
                       ("rust-superluminal-perf" ,rust-superluminal-perf-0.1)
                       ("rust-tracing" ,rust-tracing-0.1)
                       ("rust-tracy-client" ,rust-tracy-client-0.17))))
    (home-page "https://github.com/aclysma/profiling")
    (synopsis
     "This crate provides a very thin abstraction over other profiler crates")
    (description
     "This crate provides a very thin abstraction over other profiler crates.")
    (license (list license:expat license:asl2.0))))

(define-public rust-nohash-hasher-0.2
  (package
    (name "rust-nohash-hasher")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "nohash-hasher" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0lf4p6k01w4wm7zn4grnihzj8s7zd5qczjmzng7wviwxawih5x9b"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/paritytech/nohash-hasher")
    (synopsis
     "An implementation of `std::hash::Hasher` which does not hash at all")
    (description
     "This package provides An implementation of `std::hash::Hasher` which does not hash at all.")
    (license (list license:asl2.0 license:expat))))

(define-public rust-epaint-default-fonts-0.31
  (package
    (name "rust-epaint-default-fonts")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "epaint_default_fonts" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0bq8yliykcwpsfwkihjiy63a4q06yr2rwnkl3sssbxrcq1j7lzpw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page
     "https://github.com/emilk/egui/tree/master/crates/epaint_default_fonts")
    (synopsis "Default fonts for use in epaint / egui")
    (description
     "This package provides Default fonts for use in epaint / egui.")
    (license (list license:expat license:asl2.0))))

(define-public rust-color-hex-0.2
  (package
    (name "rust-color-hex")
    (version "0.2.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "color-hex" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1yacshskcjybr727rh6d38lrfrcdivnd184h49j6qsrj7a8zppzc"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t))
    (home-page "https://github.com/newcomb-luke/color-hex")
    (synopsis
     "Procedural macro for converting hexadecimal strings to an RGB or RGBA byte array at compile time")
    (description
     "This package provides Procedural macro for converting hexadecimal strings to an RGB or RGBA byte array
at compile time.")
    (license license:expat)))

(define-public rust-ecolor-0.31
  (package
    (name "rust-ecolor")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "ecolor" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1l9gcwlh48c5qha87krf8gpq0kpqzd9483ja00dd7pj0cwvfnkxw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-cint" ,rust-cint-0.3)
                       ("rust-color-hex" ,rust-color-hex-0.2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-emath" ,rust-emath-0.31)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui")
    (synopsis "Color structs and color conversion utilities")
    (description
     "This package provides Color structs and color conversion utilities.")
    (license (list license:expat license:asl2.0))))

(define-public rust-epaint-0.31
  (package
    (name "rust-epaint")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "epaint" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0qn5cy5707w1d1hb1vghss5gpjka7q6b7r75vv9ay4y6lzsw1z21"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ab-glyph" ,rust-ab-glyph-0.2)
                       ("rust-ahash" ,rust-ahash-0.8)
                       ("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-ecolor" ,rust-ecolor-0.31)
                       ("rust-emath" ,rust-emath-0.31)
                       ("rust-epaint-default-fonts" ,rust-epaint-default-fonts-0.31)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-rayon" ,rust-rayon-1)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/epaint")
    (synopsis "Minimal 2D graphics library for GUI work")
    (description
     "This package provides Minimal 2D graphics library for GUI work.")
    (license (list license:expat license:asl2.0))))

(define-public rust-emath-0.31
  (package
    (name "rust-emath")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "emath" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "06zyhc0akpnzasm5b0cfqvdypd9246zpdskz5fkkndd5yz7ssk4y"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-mint" ,rust-mint-0.5)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/emath")
    (synopsis "Minimal 2D math library for GUI work")
    (description "This package provides Minimal 2D math library for GUI work.")
    (license (list license:expat license:asl2.0))))

(define-public rust-enumn-0.1
  (package
    (name "rust-enumn")
    (version "0.1.14")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "enumn" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0f1gagm6841sih4ipw46c7gn1idjgqfay1f5q6hchdwjg2rxd7ig"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-proc-macro2" ,rust-proc-macro2-1)
                       ("rust-quote" ,rust-quote-1)
                       ("rust-syn" ,rust-syn-2))))
    (home-page "https://github.com/dtolnay/enumn")
    (synopsis "Convert number to enum")
    (description "This package provides Convert number to enum.")
    (license (list license:expat license:asl2.0))))

(define-public rust-accesskit-0.17
  (package
    (name "rust-accesskit")
    (version "0.17.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "accesskit" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nhwqffh399k242y83fhddhnvvfl2pl06jmwd61r8sp4pbwvilyk"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-enumn" ,rust-enumn-0.1)
                       ("rust-pyo3" ,rust-pyo3-0.20)
                       ("rust-schemars" ,rust-schemars-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/AccessKit/accesskit")
    (synopsis "UI accessibility infrastructure across platforms")
    (description
     "This package provides UI accessibility infrastructure across platforms.")
    (license (list license:expat license:asl2.0))))

(define-public rust-egui-0.31
  (package
    (name "rust-egui")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "egui" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1wwyxrvni7a8hpza8svbxxvwjafd3k5kj0gpxf2mvdcsqk739p95"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-accesskit" ,rust-accesskit-0.17)
                       ("rust-ahash" ,rust-ahash-0.8)
                       ("rust-backtrace" ,rust-backtrace-0.3)
                       ("rust-bitflags" ,rust-bitflags-2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-emath" ,rust-emath-0.31)
                       ("rust-epaint" ,rust-epaint-0.31)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-nohash-hasher" ,rust-nohash-hasher-0.2)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-ron" ,rust-ron-0.8)
                       ("rust-serde" ,rust-serde-1))))
    (home-page "https://github.com/emilk/egui")
    (synopsis
     "An easy-to-use immediate mode GUI that runs on both web and native")
    (description
     "This package provides An easy-to-use immediate mode GUI that runs on both web and native.")
    (license (list license:expat license:asl2.0))))

(define-public rust-eframe-0.31
  (package
    (name "rust-eframe")
    (version "0.31.1")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "eframe" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0p4idlrjyb1788g6jss2iy9zx4wh1vhl2zf54ijbrc9zky2y1pyh"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-ahash" ,rust-ahash-0.8)
                       ("rust-bytemuck" ,rust-bytemuck-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-egui" ,rust-egui-0.31)
                       ("rust-egui-wgpu" ,rust-egui-wgpu-0.31)
                       ("rust-egui-winit" ,rust-egui-winit-0.31)
                       ("rust-egui-glow" ,rust-egui-glow-0.31)
                       ("rust-glow" ,rust-glow-0.16)
                       ("rust-glutin" ,rust-glutin-0.32)
                       ("rust-glutin-winit" ,rust-glutin-winit-0.5)
                       ("rust-home" ,rust-home-0.5)
                       ("rust-image" ,rust-image-0.25)
                       ("rust-js-sys" ,rust-js-sys-0.3)
                       ("rust-log" ,rust-log-0.4)
                       ("rust-objc2" ,rust-objc2-0.5)
                       ("rust-objc2-app-kit" ,rust-objc2-app-kit-0.2)
                       ("rust-objc2-foundation" ,rust-objc2-foundation-0.2)
                       ("rust-parking-lot" ,rust-parking-lot-0.12)
                       ("rust-percent-encoding" ,rust-percent-encoding-2)
                       ("rust-pollster" ,rust-pollster-0.4)
                       ("rust-profiling" ,rust-profiling-1)
                       ("rust-raw-window-handle" ,rust-raw-window-handle-0.6)
                       ("rust-ron" ,rust-ron-0.8)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-static-assertions" ,rust-static-assertions-1)
                       ("rust-wasm-bindgen" ,rust-wasm-bindgen-0.2)
                       ("rust-wasm-bindgen-futures" ,rust-wasm-bindgen-futures-0.4)
                       ("rust-web-sys" ,rust-web-sys-0.3)
                       ("rust-web-time" ,rust-web-time-1)
                       ("rust-wgpu" ,rust-wgpu-24)
                       ("rust-winapi" ,rust-winapi-0.3)
                       ("rust-windows-sys" ,rust-windows-sys-0.59)
                       ("rust-winit" ,rust-winit-0.30))))
    (home-page "https://github.com/emilk/egui/tree/master/crates/eframe")
    (synopsis
     "egui framework - write GUI apps that compiles to web and/or natively")
    (description
     "This package provides egui framework - write GUI apps that compiles to web and/or natively.")
    (license (list license:expat license:asl2.0))))

(define-public rust-amdgpu-top-gui-0.10
  (package
    (name "rust-amdgpu-top-gui")
    (version "0.10.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "amdgpu_top_gui" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xa18s909vk7rbf2s2yhdl60ki0hpdnj082pk4nw9xkkm95ciym8"))))
    (build-system cargo-build-system)
    (arguments
     `(#:skip-build? #t
       #:cargo-inputs (("rust-eframe" ,rust-eframe-0.31)
                       ("rust-egui-plot" ,rust-egui-plot-0.32)
                       ("rust-i18n-embed" ,rust-i18n-embed-0.15)
                       ("rust-i18n-embed-fl" ,rust-i18n-embed-fl-0.9)
                       ("rust-libamdgpu-top" ,rust-libamdgpu-top-0.10)
                       ("rust-rust-embed" ,rust-rust-embed-8))))
    (home-page "https://github.com/Umio-Yasuno/amdgpu_top")
    (synopsis "GUI Library for amdgpu_top")
    (description "This package provides GUI Library for amdgpu_top.")
    (license (list license:expat license:silofl1.1))))

(define-public rust-gix-path-0.10
  (package
    (name "rust-gix-path")
    (version "0.10.18")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-path" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nxn7zzl272mb250ryg3p3kpykgx4xmg4wdfjymxy47gqkz6azsn"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bstr" ,rust-bstr-1)
                       ("rust-gix-trace" ,rust-gix-trace-0.1)
                       ("rust-gix-validate" ,rust-gix-validate-0.10)
                       ("rust-home" ,rust-home-0.5)
                       ("rust-once-cell" ,rust-once-cell-1)
                       ("rust-thiserror" ,rust-thiserror-2))
       #:cargo-development-inputs (("rust-known-folders" ,rust-known-folders-1)
                                   ("rust-serial-test" ,rust-serial-test-3)
                                   ("rust-windows" ,rust-windows-0.61)
                                   ("rust-winreg" ,rust-winreg-0.55))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis
     "crate of the gitoxide project dealing paths and their conversions")
    (description
     "This package provides a crate of the gitoxide project dealing paths and their
conversions.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gix-sec-0.10
  (package
    (name "rust-gix-sec")
    (version "0.10.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-sec" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0xcqckdfbbwcqhqzsbryqg3nijalgvr6n5hasvw16hqz4w9swkfq"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-gix-path" ,rust-gix-path-0.10)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-windows-sys" ,rust-windows-sys-0.52))
       #:cargo-development-inputs (("rust-tempfile" ,rust-tempfile-3))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis "crate of the gitoxide project providing a shared trust model")
    (description
     "This package provides a crate of the gitoxide project providing a shared trust
model.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gix-trace-0.1
  (package
    (name "rust-gix-trace")
    (version "0.1.12")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-trace" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xv54v5y91vxjx351wl3yk66fwk7ybkna2knbxlnj34j6qh6lfbw"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-cc" ,rust-cc-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-tracing-core" ,rust-tracing-core-0.1))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis
     "crate to provide minimal `tracing` support that can be turned off to zero cost")
    (description
     "This package provides a crate to provide minimal `tracing` support that can be
turned off to zero cost.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gix-utils-0.1
  (package
    (name "rust-gix-utils")
    (version "0.1.14")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-utils" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0pykxyp0cm2x8lj4ryj1pflksf9k7iyrshf8g321d2dc0d7g427z"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bstr" ,rust-bstr-1)
                       ("rust-fastrand" ,rust-fastrand-2)
                       ("rust-unicode-normalization" ,rust-unicode-normalization-0.1))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis
     "crate with `gitoxide` utilities that don't need feature toggles")
    (description
     "This package provides a crate with `gitoxide` utilities that don't need feature
toggles.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gix-validate-0.9
  (package
    (name "rust-gix-validate")
    (version "0.9.3")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-validate" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "145xmpf2n047zvkarbjc3yksx8i276194bm4q0bmd23x6g1h3aly"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bstr" ,rust-bstr-1)
                       ("rust-thiserror" ,rust-thiserror-2))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis "Validation functions for various kinds of names in git")
    (description
     "This package provides Validation functions for various kinds of names in git.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gix-chunk-0.4
  (package
    (name "rust-gix-chunk")
    (version "0.4.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-chunk" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0vxxq4q5pn5cz2xhghcjpp8z83r8xxy74gsffvf9k1lmcj3is7qb"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-thiserror" ,rust-thiserror-2))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis
     "Interact with the git chunk file format used in multi-pack index and commit-graph files")
    (description
     "This package provides Interact with the git chunk file format used in multi-pack index and
commit-graph files.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gix-config-value-0.14
  (package
    (name "rust-gix-config-value")
    (version "0.14.11")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-config-value" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1vjckx1is9csf5h9bnrvfir5wjzy9jlvl7a70cs2y24kxx252dhi"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bitflags" ,rust-bitflags-2)
                       ("rust-bstr" ,rust-bstr-1)
                       ("rust-document-features" ,rust-document-features-0.2)
                       ("rust-gix-path" ,rust-gix-path-0.10)
                       ("rust-libc" ,rust-libc-0.2)
                       ("rust-serde" ,rust-serde-1)
                       ("rust-thiserror" ,rust-thiserror-2))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis
     "crate of the gitoxide project providing git-config value parsing")
    (description
     "This package provides a crate of the gitoxide project providing git-config value
parsing.")
    (license (list license:expat license:asl2.0))))

(define-public rust-gix-quote-0.4
  (package
    (name "rust-gix-quote")
    (version "0.4.15")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "gix-quote" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1ik6l3s0hjb2p4dlgdarb59v7n9jvgvak4ij786mrj5hrpy5g4z4"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-bstr" ,rust-bstr-1)
                       ("rust-gix-utils" ,rust-gix-utils-0.1)
                       ("rust-thiserror" ,rust-thiserror-2))))
    (home-page "https://github.com/GitoxideLabs/gitoxide")
    (synopsis
     "crate of the gitoxide project dealing with various quotations used by git")
    (description
     "This package provides a crate of the gitoxide project dealing with various
quotations used by git.")
    (license (list license:expat license:asl2.0))))

(define-public rust-bstr-1
  (package
    (name "rust-bstr")
    (version "1.12.0")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "bstr" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "195i0gd7r7jg7a8spkmw08492n7rmiabcvz880xn2z8dkp8i6h93"))))
    (build-system cargo-build-system)
    (arguments
     `(#:cargo-inputs (("rust-memchr" ,rust-memchr-2)
                       ("rust-regex-automata" ,rust-regex-automata-0.4)
                       ("rust-serde" ,rust-serde-1))
       #:cargo-development-inputs (("rust-quickcheck" ,rust-quickcheck-1)
                                   ("rust-ucd-parse" ,rust-ucd-parse-0.1)
                                   ("rust-unicode-segmentation" ,rust-unicode-segmentation-1))))
    (home-page "https://github.com/BurntSushi/bstr")
    (synopsis "string type that is not required to be valid UTF-8.")
    (description
     "This package provides a string type that is not required to be valid UTF-8.")
    (license (list license:expat license:asl2.0))))

(define-public amdgpu-top
  (package
    (name "amdgpu-top")
    (version "0.10.5")
    (source
     (origin
       (method url-fetch)
       (uri (crate-uri "amdgpu_top" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0ypmkfis2flk4fy1vvq1cmsj6zj08yk1hmrcjyzkrxi41hvkmjn0"))))
    (build-system (make-cargo-build-system "1.85.1"))
    (arguments
     (list #:cargo-inputs `(("rust-amdgpu-top-gui" ,rust-amdgpu-top-gui-0.10)
                            ("rust-amdgpu-top-json" ,rust-amdgpu-top-json-0.10)
                            ("rust-amdgpu-top-tui" ,rust-amdgpu-top-tui-0.10)
                            ("rust-gix-path" ,rust-gix-path-0.10)
                            ("rust-gix-sec" ,rust-gix-sec-0.10)
                            ("rust-gix-trace" ,rust-gix-trace-0.1)
                            ("rust-gix-utils" ,rust-gix-utils-0.1)
                            ("rust-gix-validate" ,rust-gix-validate-0.9)
                            ("rust-gix-chunk" ,rust-gix-chunk-0.4)
                            ("rust-gix-config-value" ,rust-gix-config-value-0.14)
                            ("rust-gix-quote" ,rust-gix-quote-0.4)
                            ("rust-gix" ,rust-gix-0.70)
                            ("rust-bstr" ,rust-bstr-1)
                            ("rust-libamdgpu-top" ,rust-libamdgpu-top-0.10)
                            ("rust-libc" ,rust-libc-0.2))))
    (inputs (list
             libdrm
             ;; https://github.com/declantsien/guix-rustup/issues/3
             clang-toolchain))
    (home-page "https://github.com/Umio-Yasuno/amdgpu_top")
    (synopsis
     "Tool to displays AMDGPU usage.
The tool displays information gathered from performance counters (GRBM, GRBM2), sensors, fdinfo, gpu_metrics and AMDGPU driver.")
    (description
     "This package provides Tool to displays AMDGPU usage.  The tool displays information gathered from
performance counters (GRBM, GRBM2), sensors, fdinfo, gpu_metrics and AMDGPU
driver.")
    (license license:expat)))
