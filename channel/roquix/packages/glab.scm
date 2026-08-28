(define-module (roquix packages glab)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-compression)
  #:use-module (gnu packages golang-crypto)
  #:use-module (gnu packages golang-web)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages version-control)
  #:use-module (guix build-system go)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages))

(define-public go-github-com-spf13-cast
  (package
    (name "go-github-com-spf13-cast")
    (version "1.10.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/spf13/cast")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0h3dfii92rlrg779z0xwqjgkq9vzm3vnkqrjlf1yqf9nhi39m3k6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/spf13/cast"))
    (home-page "https://github.com/spf13/cast")
    (synopsis "Convert between Go types")
    (description
     "Cast converts values between common Go types in a consistent manner.")
    (license license:expat)))

(define-public go-github-com-spf13-viper
  (package
    (name "go-github-com-spf13-viper")
    (version "1.21.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/spf13/viper")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0sji97bg8cg9gr40msa02acib14yfj5qdc6vljms17w4y2cgka7i"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "github.com/spf13/viper"))
    (propagated-inputs (list go-github-com-fsnotify-fsnotify
                             go-github-com-go-viper-mapstructure-v2
                             go-github-com-pelletier-go-toml-v2
                             go-github-com-sagikazarmark-locafero
                             go-github-com-spf13-afero
                             go-github-com-spf13-cast
                             go-github-com-spf13-pflag
                             go-github-com-stretchr-testify
                             go-github-com-subosito-gotenv
                             go-go-yaml-in-yaml-v3))
    (home-page "https://github.com/spf13/viper")
    (synopsis "Configuration library for Go applications")
    (description
     "Viper provides a complete configuration solution for Go applications,
including files, environment variables, flags, and remote configuration.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-x-ansi
  (package
    (name "go-github-com-charmbracelet-x-ansi")
    (version "0.11.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/x")
             (commit (go-version->git-ref version
                                          #:subdir "ansi"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01s80fib0cjgbxardgkhpy40xn05wjqyz5ddp856gmsi35qac379"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/charmbracelet/x/ansi"
      #:unpack-path "github.com/charmbracelet/x"))
    (propagated-inputs (list go-github-com-bits-and-blooms-bitset
                             go-github-com-clipperhouse-displaywidth
                             go-github-com-clipperhouse-uax29-v2
                             go-github-com-lucasb-eyer-go-colorful
                             go-github-com-mattn-go-runewidth))
    (home-page "https://github.com/charmbracelet/x")
    (synopsis "ANSI escape sequence helpers for Go")
    (description
     "Package ansi defines common ANSI escape sequences based on the ECMA-48 specs.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-x-term
  (package
    (name "go-github-com-charmbracelet-x-term")
    (version "0.2.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/x")
             (commit (go-version->git-ref version
                                          #:subdir "term"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0sriiy8njbnwgn0ydnp3adq70ch489xi5v662c6h3zq1f6b981zy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/charmbracelet/x/term"
      #:unpack-path "github.com/charmbracelet/x"))
    (propagated-inputs (list go-golang-org-x-sys))
    (home-page "https://github.com/charmbracelet/x")
    (synopsis "Terminal helpers for Go")
    (description
     "Package term provides a platform-independent interfaces for interacting with
Terminal and TTY devices.")
    (license license:expat)))

(define go-github-com-charmbracelet-x-xpty-for-glab
  (package
    (inherit go-github-com-charmbracelet-x-xpty)
    (propagated-inputs (modify-inputs (package-propagated-inputs
                                       go-github-com-charmbracelet-x-xpty)
                         (replace "go-github-com-charmbracelet-x-term"
                                  go-github-com-charmbracelet-x-term)))))

(define-public go-github-com-charmbracelet-x-windows
  (package
    (name "go-github-com-charmbracelet-x-windows")
    (version "0.2.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/x")
             (commit (go-version->git-ref version
                                          #:subdir "windows"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01iba6qjgpxw2bik8331s71320vs0zr4x3fnpzkf9vhr91qkm6nv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/charmbracelet/x/windows"
      #:unpack-path "github.com/charmbracelet/x"))
    (propagated-inputs (list go-golang-org-x-sys))
    (home-page "https://github.com/charmbracelet/x")
    (synopsis "Windows system helpers for Go")
    (description "Package windows provides Windows-specific system utilities.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-colorprofile
  (package
    (name "go-github-com-charmbracelet-colorprofile")
    (version "0.4.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/colorprofile")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1gwylpqh0cfzz3pc9xf3z95c4dw11n0pbxaq3j0krw805pfz4j18"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/charmbracelet/colorprofile"))
    (propagated-inputs (list go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-term
                             go-github-com-lucasb-eyer-go-colorful
                             go-github-com-xo-terminfo go-golang-org-x-sys))
    (home-page "https://github.com/charmbracelet/colorprofile")
    (synopsis "Colorprofile")
    (description
     "Package colorprofile provides a way to downsample ANSI escape sequence colors
and styles automatically based on output, environment variables, and Terminfo
databases.")
    (license license:expat)))

(define go-github-com-charmbracelet-colorprofile-bootstrap
  (package
    (inherit go-github-com-charmbracelet-colorprofile)
    (name "go-github-com-charmbracelet-colorprofile-bootstrap")
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/charmbracelet/colorprofile"))
    (propagated-inputs (modify-inputs (package-propagated-inputs
                                       go-github-com-charmbracelet-colorprofile)
                         (delete "go-github-com-charmbracelet-x-ansi")
                         (delete "go-github-com-charmbracelet-x-term")))))

(define-public go-github-com-charmbracelet-x-exp-charmtone
  (package
    (name "go-github-com-charmbracelet-x-exp-charmtone")
    (version "0.0.0-20250603201427-c31516f43444")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/x")
             (commit (go-version->git-ref version
                                          #:subdir "exp/charmtone"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0rwbn90wdxkly1063mca4yzz1qpg3p26i5kz979gx62mj6a4wd79"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "github.com/charmbracelet/x/exp/charmtone"
      #:unpack-path "github.com/charmbracelet/x"))
    (propagated-inputs (list go-github-com-lucasb-eyer-go-colorful))
    (home-page "https://github.com/charmbracelet/x")
    (synopsis "Charm color palette for Go")
    (description
     "Package charmtone contains an API for the @code{CharmTone} color palette.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-x-exp-ordered
  (package
    (name "go-github-com-charmbracelet-x-exp-ordered")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/x")
             (commit (go-version->git-ref version
                                          #:subdir "exp/ordered"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01rr26pjhz2ms7bbqr21bs4vs1f60ix5y6gsp25sisvm36ds484l"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "github.com/charmbracelet/x/exp/ordered"
      #:unpack-path "github.com/charmbracelet/x"))
    (home-page "https://github.com/charmbracelet/x")
    (synopsis "Ordered collection helpers for Go")
    (description
     "This package provides experimental ordered collection helpers for Go.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-ultraviolet
  (package
    (name "go-github-com-charmbracelet-ultraviolet")
    (version "0.0.0-20260703014108-f5a850f9c2b7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/ultraviolet")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0psakkpv8vvvfsf2b9lyvlq9xcmpicky12yxdqrqn1rnmwpm4rki"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "" "internal/casso" "internal/lru" "layout" "screen")
      #:import-path "github.com/charmbracelet/ultraviolet"))
    (propagated-inputs (list go-github-com-charmbracelet-colorprofile
                             go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-term
                             go-github-com-charmbracelet-x-termios
                             go-github-com-charmbracelet-x-windows
                             go-github-com-clipperhouse-uax29-v2
                             go-github-com-lucasb-eyer-go-colorful
                             go-github-com-muesli-cancelreader
                             go-github-com-rivo-uniseg
                             go-github-com-xo-terminfo
                             go-golang-org-x-sync
                             go-golang-org-x-sys))
    (home-page "https://github.com/charmbracelet/ultraviolet")
    (synopsis "Ultraviolet")
    (description
     "Package uv (Ultraviolet) provides primitives for building terminal user
interfaces in Go.")
    (license license:expat)))

(define go-github-com-charmbracelet-ultraviolet-bootstrap
  (package
    (inherit go-github-com-charmbracelet-ultraviolet)
    (name "go-github-com-charmbracelet-ultraviolet-bootstrap")
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/charmbracelet/ultraviolet"))
    (propagated-inputs (modify-inputs (package-propagated-inputs
                                       go-github-com-charmbracelet-ultraviolet)
                         (replace "go-github-com-charmbracelet-colorprofile"
                          go-github-com-charmbracelet-colorprofile-bootstrap)
                         (delete "go-github-com-charmbracelet-x-ansi")
                         (delete "go-github-com-charmbracelet-x-term")
                         (delete "go-github-com-charmbracelet-x-termios")
                         (delete "go-github-com-charmbracelet-x-windows")))))

(define-public go-charm-land-bubbletea-v2
  (package
    (name "go-charm-land-bubbletea-v2")
    (version "2.0.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/bubbletea")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m0mb529gn47vy3j7nm6bx832hvq7sna9q1icl0cgw4r1afs3x0q"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "charm.land/bubbletea/v2"
      #:unpack-path "charm.land/bubbletea/v2"))
    (propagated-inputs (list go-github-com-charmbracelet-colorprofile
                             go-github-com-charmbracelet-ultraviolet
                             go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-exp-golden
                             go-github-com-charmbracelet-x-term
                             go-github-com-lucasb-eyer-go-colorful
                             go-github-com-muesli-cancelreader
                             go-golang-org-x-sys))
    (home-page "https://charm.land/bubbletea")
    (synopsis "Bubble Tea")
    (description
     "Package tea provides a framework for building rich terminal user interfaces
based on the paradigms of The Elm Architecture.  It's well-suited for simple and
complex terminal applications, either inline, full-window, or a mix of both.
It's been battle-tested in several large projects and is production-ready.")
    (license license:expat)))

(define-public go-charm-land-lipgloss-v2
  (package
    (name "go-charm-land-lipgloss-v2")
    (version "2.0.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/lipgloss")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wh7z2c6z4dv918qd78in48kp16nbqfgiw71f8fvnfhwm6crdwp0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "charm.land/lipgloss/v2"
      #:unpack-path "charm.land/lipgloss/v2"))
    (propagated-inputs (list go-github-com-aymanbagabas-go-udiff
                             go-github-com-charmbracelet-colorprofile
                             go-github-com-charmbracelet-ultraviolet
                             go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-exp-golden
                             go-github-com-charmbracelet-x-term
                             go-github-com-clipperhouse-displaywidth
                             go-github-com-lucasb-eyer-go-colorful
                             go-github-com-rivo-uniseg
                             go-golang-org-x-sys))
    (home-page "https://charm.land/lipgloss")
    (synopsis "Lip Gloss")
    (description
     "Package lipgloss provides style definitions for nice terminal layouts.  Built
with TUIs in mind.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-x-vt
  (package
    (name "go-github-com-charmbracelet-x-vt")
    (version "0.0.0-20260316093931-f2fb44ab3145")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/x")
             (commit (go-version->git-ref version
                                          #:subdir "vt"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0r4pw739vv6j6dc844crn0y6qg45p1qa5xqnmks9la3s4b6fyn33"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "github.com/charmbracelet/x/vt"
      #:unpack-path "github.com/charmbracelet/x"))
    ;; The vt checkout itself supplies the github.com/charmbracelet/x tree.
    ;; Bootstrap inputs avoid pre-populating that path with read-only links.
    (propagated-inputs (modify-inputs (package-propagated-inputs
                                       go-github-com-charmbracelet-x-ansi)
                         (append
                          go-github-com-charmbracelet-ultraviolet-bootstrap)))
    (home-page "https://github.com/charmbracelet/x")
    (synopsis "Virtual terminal implementation for Go")
    (description
     "Package vt provides a virtual terminal implementation for Go.")
    (license license:expat)))

(define-public go-charm-land-bubbles-v2
  (package
    (name "go-charm-land-bubbles-v2")
    (version "2.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/bubbles")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03ksng6l2py25vcgfnkkqmccbl5scdgw4bggmkci9y16grz6441j"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "charm.land/bubbles/v2"
      #:unpack-path "charm.land/bubbles/v2"))
    (propagated-inputs (list go-charm-land-bubbletea-v2
                             go-charm-land-lipgloss-v2
                             go-github-com-atotto-clipboard
                             go-github-com-charmbracelet-harmonica
                             go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-exp-golden
                             go-github-com-dustin-go-humanize
                             go-github-com-makenowjust-heredoc
                             go-github-com-mattn-go-runewidth
                             go-github-com-rivo-uniseg
                             go-github-com-sahilm-fuzzy))
    (home-page "https://charm.land/bubbles")
    (synopsis "Bubbles")
    (description
     "Package bubbles provides some components for Bubble Tea applications.  These
components are used in production in Glow, Charm and many other applications.")
    (license license:expat)))

(define-public go-charm-land-fang-v2
  (package
    (name "go-charm-land-fang-v2")
    (version "2.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/fang")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0w74ikysf2gphg9gmgx001krpkw8g29ikmwlqlsskxkc03fg2lgs"))))
    (build-system go-build-system)
    (arguments
     (list
      ;; Fang's help golden files depend on the exact Lip Gloss patch version
      ;; selected by the final module graph.
      #:tests? #f
      #:import-path "charm.land/fang/v2"
      #:unpack-path "charm.land/fang/v2"))
    (propagated-inputs (list go-charm-land-lipgloss-v2
                             go-github-com-charmbracelet-colorprofile
                             go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-exp-charmtone
                             go-github-com-charmbracelet-x-term
                             go-github-com-muesli-mango-cobra
                             go-github-com-muesli-roff
                             go-github-com-spf13-cobra
                             go-github-com-spf13-pflag
                             go-golang-org-x-sys
                             go-golang-org-x-text))
    (home-page "https://charm.land/fang")
    (synopsis "Fang")
    (description "Package fang provides styling for cobra commands.")
    (license license:expat)))

(define-public go-charm-land-glamour-v2
  (package
    (name "go-charm-land-glamour-v2")
    (version "2.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/glamour")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00szf25gbrzsacq7q1v247m2j7zgh4xl5q066fm7yc4vbwf3ihnv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:embed-files
      #~(list ".*\\.xml")
      ;; GLab's module graph selects lipgloss 2.0.5 while glamour's golden
      ;; tests were recorded with 2.0.4; the final GLab tests cover this
      ;; resolved combination.
      #:tests? #f
      #:import-path "charm.land/glamour/v2"
      #:unpack-path "charm.land/glamour/v2"))
    (propagated-inputs (list go-charm-land-lipgloss-v2
                             go-github-com-alecthomas-chroma-v2
                             go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-exp-golden
                             go-github-com-charmbracelet-x-exp-slice
                             go-github-com-microcosm-cc-bluemonday
                             go-github-com-yuin-goldmark
                             go-github-com-yuin-goldmark-emoji
                             go-golang-org-x-text))
    (home-page "https://charm.land/glamour")
    (synopsis "Glamour")
    (description
     "Package glamour lets you render markdown documents & templates on ANSI
compatible terminals.  You can create your own stylesheet or simply use one of
the stylish defaults.")
    (license license:expat)))

(define-public go-charm-land-huh-v2
  (package
    (name "go-charm-land-huh-v2")
    (version "2.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/huh")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0481sw95k1513r2n6jjcm75c61pmz0d4mpvzjgi1ca4y54w6k0q0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "charm.land/huh/v2"
      #:unpack-path "charm.land/huh/v2"))
    (propagated-inputs (list go-charm-land-bubbles-v2
                             go-charm-land-bubbletea-v2
                             go-charm-land-lipgloss-v2
                             go-github-com-catppuccin-go
                             go-github-com-charmbracelet-x-ansi
                             go-github-com-charmbracelet-x-exp-ordered
                             go-github-com-charmbracelet-x-exp-strings
                             go-github-com-charmbracelet-x-term
                             go-github-com-charmbracelet-x-xpty-for-glab
                             go-github-com-mitchellh-hashstructure-v2))
    (home-page "https://charm.land/huh")
    (synopsis "Huh?")
    (description
     "Package huh provides components to build terminal-based forms and prompts.")
    (license license:expat)))

(define-public go-git-sr-ht--timofurrer-ugh
  (package
    (name "go-git-sr-ht--timofurrer-ugh")
    (version "0.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.sr.ht/~timofurrer/ugh")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ag407h5ji6njgq24p12khcwwpn551kq9yk20cfis92hfsn67y89"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:test-flags
      #~(list "-skip" "TestSelect_Validate_RejectAndRetry")
      #:import-path "git.sr.ht/~timofurrer/ugh"))
    (propagated-inputs (list go-charm-land-bubbletea-v2 go-charm-land-huh-v2
                             go-github-com-charmbracelet-x-vt))
    (home-page "https://git.sr.ht/~timofurrer/ugh")
    (synopsis "Drive terminal UI forms in Go tests")
    (description
     "Package ugh is a Go testing library for driving huh terminal UI forms through
raw I/O streams using a virtual terminal emulator.")
    (license license:expat)))

(define-public go-github-com-avast-retry-go-v5
  (package
    (name "go-github-com-avast-retry-go-v5")
    (version "5.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/avast/retry-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0lm9sc7x1k3lsnx3gjzbjbcd5fyahppasyr25a915ajqbrhmnnka"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "github.com/avast/retry-go/v5"
      #:unpack-path "github.com/avast/retry-go/v5"))
    (propagated-inputs (list go-github-com-stretchr-testify))
    (home-page "https://github.com/avast/retry-go")
    (synopsis "Retry failed Go operations")
    (description "Simple library for retry mechanism.")
    (license license:expat)))

(define-public go-github-com-mazznoer-csscolorparser
  (package
    (name "go-github-com-mazznoer-csscolorparser")
    (version "0.1.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mazznoer/csscolorparser")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07g6ln9d3l407q8ndh46k2i28949g075zqnjpmdgj6xsp2gq1xz7"))))
    (build-system go-build-system)
    (arguments
     (list
      #:test-subdirs
      #~(list "")
      #:import-path "github.com/mazznoer/csscolorparser"))
    (home-page "https://github.com/mazznoer/csscolorparser")
    (synopsis "Go Language CSS Color Parser Library")
    (description
     "Package csscolorparser provides function for parsing CSS color string as defined
in the W3C's CSS color module level 4.")
    (license license:expat)))

(define-public go-oss-terrastruct-com-util-go
  (package
    (name "go-oss-terrastruct-com-util-go")
    (version "0.0.0-20250213174338-243d8661088a")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/d2lang/util-go-legacy")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1nnrghiwsp920xjlclakmyw25svss7smkdgzs0sn861aw6hq6ws6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "oss.terrastruct.com/util-go"))
    (propagated-inputs (list go-golang-org-x-exp go-golang-org-x-xerrors))
    (home-page "https://oss.terrastruct.com/util-go")
    (synopsis "General-purpose Go utilities")
    (description "Terrastruct's general purpose go libraries.")
    (license license:isc)))

(define-public go-oss-terrastruct-com-d2
  (package
    (name "go-oss-terrastruct-com-d2")
    (version "0.7.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/d2lang/d2-legacy")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1i1fvy35rqjxvmpa2rlfx96j0bb1hf17xxml0pf6nhjaq8qjy435"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "oss.terrastruct.com/d2"))
    (propagated-inputs (list go-github-com-alecthomas-chroma-v2
                             go-github-com-dop251-goja
                             go-github-com-golang-freetype
                             go-github-com-lucasb-eyer-go-colorful
                             go-github-com-mazznoer-csscolorparser
                             go-github-com-puerkitobio-goquery
                             go-github-com-rivo-uniseg
                             go-github-com-yuin-goldmark
                             go-golang-org-x-exp
                             go-golang-org-x-image
                             go-golang-org-x-net
                             go-golang-org-x-text
                             go-golang-org-x-xerrors
                             go-oss-terrastruct-com-util-go))
    (home-page "https://oss.terrastruct.com/d2")
    (synopsis "Declarative diagramming library")
    (description
     "D2 is a declarative diagramming language.  This package provides its Go
libraries for parsing, laying out, and rendering diagrams.")
    (license license:mpl2.0)))

(define-public go-gitlab-com-gitlab-org-api-client-go-v2
  (package
    (name "go-gitlab-com-gitlab-org-api-client-go-v2")
    (version "2.53.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/gitlab-org/api/client-go.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0a6m00asa5z5bh394660rfk1cpwgiifsjgxkhlwk839iafq199sb"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "gitlab.com/gitlab-org/api/client-go/v2"
      #:unpack-path "gitlab.com/gitlab-org/api/client-go/v2"))
    (propagated-inputs (list go-github-com-google-go-querystring
                             go-github-com-hashicorp-go-cleanhttp
                             go-github-com-hashicorp-go-retryablehttp
                             go-golang-org-x-oauth2 go-golang-org-x-time))
    (home-page "https://gitlab.com/gitlab-org/api/client-go")
    (synopsis "Go client for the GitLab API")
    (description "Package gitlab implements a @code{GitLab} API client.")
    (license license:asl2.0)))

(define-public go-gitlab-com-gitlab-org-cli
  (package
    (name "go-gitlab-com-gitlab-org-cli")
    (version "1.113.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/gitlab-org/cli.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "092nxmw4bmiqzb4vppg8dw98cgk7zmy30n2s06m6i0fxfsh6gb69"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.26
      #:skip-build? #t
      #:tests? #f
      #:import-path "gitlab.com/gitlab-org/cli"))
    (propagated-inputs (list go-charm-land-bubbletea-v2
                             go-charm-land-fang-v2
                             go-charm-land-glamour-v2
                             go-charm-land-huh-v2
                             go-charm-land-lipgloss-v2
                             go-git-sr-ht--timofurrer-ugh
                             go-github-com-acarl005-stripansi
                             go-github-com-adrg-xdg
                             go-github-com-avast-retry-go-v5
                             go-github-com-briandowns-spinner
                             go-github-com-coder-websocket
                             go-github-com-docker-cli
                             go-github-com-docker-docker-credential-helpers
                             go-github-com-dustin-go-humanize
                             go-github-com-gdamore-tcell-v2
                             go-github-com-golang-jwt-jwt-v5
                             go-github-com-google-renameio-v2
                             go-github-com-google-shlex
                             go-github-com-google-uuid
                             go-github-com-gosuri-uilive
                             go-github-com-hashicorp-go-multierror
                             go-github-com-hashicorp-go-retryablehttp
                             go-github-com-hashicorp-go-version
                             go-github-com-itchyny-gojq
                             go-github-com-lunixbochs-vtclean
                             go-github-com-makenowjust-heredoc-v2
                             go-github-com-mattn-go-colorable
                             go-github-com-mattn-go-isatty
                             go-github-com-mattn-go-runewidth
                             go-github-com-mgutz-ansi
                             go-github-com-modelcontextprotocol-go-sdk
                             go-github-com-muesli-termenv
                             go-github-com-otiai10-copy
                             go-github-com-pkg-browser
                             go-github-com-rivo-tview
                             go-github-com-spf13-cobra
                             go-github-com-spf13-pflag
                             go-github-com-spf13-viper
                             go-github-com-stretchr-testify
                             go-github-com-tidwall-pretty
                             go-github-com-zalando-go-keyring
                             go-gitlab-com-gitlab-org-api-client-go-v2
                             go-go-uber-org-goleak
                             go-go-uber-org-mock
                             go-go-yaml-in-yaml-v3
                             go-golang-org-x-crypto
                             go-golang-org-x-oauth2
                             go-golang-org-x-sync
                             go-golang-org-x-sys
                             go-golang-org-x-term
                             go-golang-org-x-text
                             go-k8s-io-apimachinery
                             go-k8s-io-client-go
                             go-mvdan-cc-xurls-v2
                             go-oss-terrastruct-com-d2))
    (home-page "https://gitlab.com/gitlab-org/cli")
    (synopsis "GitLab command-line interface source")
    (description
     "This package provides the Go source tree and source dependencies for
GLab, the GitLab command-line interface.")
    (license license:expat)))

(define-public glab
  (package
    (inherit go-gitlab-com-gitlab-org-cli)
    (name "glab")
    (propagated-inputs '())
    (native-inputs (modify-inputs (package-propagated-inputs
                                   go-gitlab-com-gitlab-org-cli)
                     (append git-minimal)))
    (arguments
     (list
      #:go go-1.26
      #:install-source? #f
      #:embed-files
      #~(list ".*\\.(css|html|js|svg|ttf|txt|xml)")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'fix-embed-files 'select-go-module-versions
            (lambda _
              ;; GOPATH cannot represent multiple versions of one import path.
              ;; Viper requires Cast 1.10, while Docker propagates Cast 1.7.
              (let ((cast-path "src/github.com/spf13/cast"))
                (delete-file-recursively cast-path)
                (copy-recursively #$(file-append go-github-com-spf13-cast
                                                 "/src/github.com/spf13/cast")
                                  cast-path))
              ;; Xurls selects Go Internal 1.14, while transitive test helpers
              ;; propagate 1.12 into the same import path.
              (let ((go-internal-path "src/github.com/rogpeppe/go-internal"))
                (delete-file-recursively go-internal-path)
                (copy-recursively #$(file-append
                                     go-github-com-rogpeppe-go-internal
                                     "/src/github.com/rogpeppe/go-internal")
                                  go-internal-path))))
          (add-before 'build 'enter-source
            (lambda* (#:key unpack-path #:allow-other-keys)
              (chdir (string-append "src/" unpack-path))
              (setenv "CGO_ENABLED" "0")))
          (add-before 'check 'initialize-test-repository
            (lambda _
              (setenv "HOME"
                      (getcwd))
              (invoke "git" "init" "--initial-branch=main" ".")))
          (add-after 'check 'leave-source
            (lambda _
              (chdir (getenv "GOPATH")))))
      #:build-flags
      #~(list (string-append "-ldflags=-s -w -X main.version="
               #$(package-version go-gitlab-com-gitlab-org-cli)
               " -X main.commit=d62881304ccba9e24d07bcfb2c5e8bcae3f17f75"))
      #:import-path "gitlab.com/gitlab-org/cli/cmd/glab"
      #:unpack-path "gitlab.com/gitlab-org/cli"))
    (synopsis "GitLab command-line interface")
    (description
     "GLab is a command-line interface for GitLab.  It supports working with
issues, merge requests, CI pipelines, releases, and other GitLab features from
the terminal.")))
