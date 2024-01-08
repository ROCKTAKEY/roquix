(define-module
  (roquix packages gh)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system go)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-web)
  #:use-module (gnu packages syncthing)
  #:use-module (gnu packages version-control))

(define-public go-github-com-spf13-cobra-v1.2
  (package
    (name "go-github-com-spf13-cobra-v1.2")
    (version "1.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/spf13/cobra")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1dq7pmbl0360az3a25wvghk8g6hdzkp24inq61sihwd1flz776ki"))))
    (build-system go-build-system)
    (arguments
     `(#:import-path "github.com/spf13/cobra"))
    (propagated-inputs
     `(("github.com/spf13/pflag" ,go-github-com-spf13-pflag)))
    (home-page "https://github.com/spf13/cobra")
    (synopsis "Go library for creating CLI applications")
    (description "Cobra is both a library for creating powerful modern CLI
applications as well as a program to generate applications and command files.")
    (license license:asl2.0)))

(define-public go-github-com-muesli-reflow-wrap
  (package
    (inherit go-github-com-muesli-reflow-wordwrap)
    (name "go-github-com-muesli-reflow-wrap")
    (arguments
     `(#:import-path "github.com/muesli/reflow/wrap"
       #:unpack-path "github.com/muesli/reflow"))))

(define-public go-github-com-yuin-goldmark
  (package
    (name "go-github-com-yuin-goldmark")
    (version "1.4.11")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/yuin/goldmark")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0cniw751xq60l51m7299wzr20z6bkr3j69f5kcaz2zh2hp9cfmma"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/yuin/goldmark"))
    (home-page "https://github.com/yuin/goldmark")
    (synopsis "goldmark")
    (description
      "Package goldmark implements functions to convert markdown text to a desired
format.")
    (license license:expat)))

(define-public go-github-com-yuin-goldmark-emoji
  (package
    (name "go-github-com-yuin-goldmark-emoji")
    (version "1.0.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/yuin/goldmark-emoji")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0jl0w0hnfhfm4wvlxbbkyzfxyr9sk8q0nxaydql6wq64my5h49ln"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/yuin/goldmark-emoji"))
    (propagated-inputs
      `(("go-github-com-yuin-goldmark" ,go-github-com-yuin-goldmark)))
    (home-page "https://github.com/yuin/goldmark-emoji")
    (synopsis "goldmark-emoji")
    (description
      "package emoji is a extension for the
goldmark(@url{http://github.com/yuin/goldmark,http://github.com/yuin/goldmark}).")
    (license license:expat)))

(define-public go-github-com-charmbracelet-glamour-without-test
  (package
    (name "go-github-com-charmbracelet-glamour-without-test")
    (version "0.4.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/charmbracelet/glamour")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1c5ba14xxk03lbc7q69rl2bsri8pm1wr3jp7y36jvdr9g8r4g5kj"))))
    (build-system go-build-system)
    (arguments
     `(#:import-path "github.com/charmbracelet/glamour" #:tests? #f))
    (propagated-inputs
     (list go-github-com-alecthomas-chroma
           go-github-com-danwakefield-fnmatch
           go-github-com-dlclark-regexp2
           go-github-com-microcosm-cc-bluemonday
           go-github-com-chris-ramon-douceur
           go-github-com-aymerick-douceur
           go-github-com-gorilla-css
           go-github-com-muesli-reflow-ansi
           go-github-com-muesli-reflow-wordwrap
           go-github-com-muesli-reflow-indent
           go-github-com-muesli-reflow-padding
           go-github-com-muesli-reflow-truncate
           go-github-com-muesli-reflow-wrap
           go-github-com-mattn-go-runewidth
           go-github-com-muesli-termenv
           go-github-com-google-goterm
           go-golang-org-colorful
           go-github-com-mattn-go-isatty
           go-github-com-olekukonko-tablewriter
           go-github-com-yuin-goldmark
           go-golang-org-x-net
           go-github-com-yuin-goldmark
           go-github-com-yuin-goldmark-emoji))
    (home-page "https://github.com/charmbracelet/glamour/")
    (synopsis "Write handsome command-line tools with glamour")
    (description "@code{glamour} lets you render markdown documents and
templates on ANSI compatible terminals.  You can create your own stylesheet or
use one of our glamorous default themes.")
    (license license:expat)))

(define-public go-github-com-cli-crypto
  (package
   (name "go-github-com-cli-crypto")
   (version "0.0.0-20210929142629-6be313f59b03")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/cli/crypto")
           (commit (go-version->git-ref version))))
     (file-name (git-file-name name version))
     (sha256
      (base32 "0g2afj5c1y2l80nsag2jc10vrqxll796fj15pkw0n1v4d8w1gm2n"))))
   (build-system go-build-system)
   (arguments '(#:phases
                (modify-phases %standard-phases
                               (delete 'build))
                #:import-path "github.com/cli/crypto"
                #:tests? #f))
   (propagated-inputs
    `(("go-golang-org-x-oauth2" ,go-golang-org-x-oauth2)))
   (home-page "https://github.com/cli/crypto")
   (synopsis "Fork of crypto.")
   (description "This repository holds supplementary Go cryptography libraries.")
   (license license:bsd-3)))

(define-public go-github-com-netflix-go-expect
  (package
    (name "go-github-com-netflix-go-expect")
    (version "0.0.0-20220104043353-73e0943537d2")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/Netflix/go-expect")
               (commit (go-version->git-ref version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0zkvhnc4ii6ygvcsj54ng0kql26rnny7l3hy1w61g88mxjsww1b9"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/Netflix/go-expect"))
    (propagated-inputs
      `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
        ("go-github-com-creack-pty" ,go-github-com-creack-pty)))
    (home-page "https://github.com/Netflix/go-expect")
    (synopsis "go-expect")
    (description
      "Package expect provides an expect-like interface to automate control of
applications.  It is unlike expect in that it does not spawn or manage process
lifecycle.  This package only focuses on expecting output and sending input
through it's psuedoterminal.")
    (license license:asl2.0)))

(define-public go-github-com-hinshun-vt10x
  (package
    (name "go-github-com-hinshun-vt10x")
    (version "0.0.0-20220301184237-5011da428d02")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/hinshun/vt10x")
               (commit (go-version->git-ref version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0pzdwwbzxrsqjb8xfzmfpkyb1gbcszrrimr70cz75jjk2535r26b"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/hinshun/vt10x"))
    (home-page "https://github.com/hinshun/vt10x")
    (synopsis "vt10x")
    (description
      "Package terminal is a vt10x terminal emulation backend, influenced largely by
st, rxvt, xterm, and iTerm as reference.  Use it for terminal muxing, a terminal
emulation frontend, or wherever else you need terminal emulation.")
    (license license:expat)))

(define-public go-github-com-alecaivazis-survey-v2
  (package
    (name "go-github-com-alecaivazis-survey-v2")
    (version "2.3.4")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/AlecAivazis/survey")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0mazpw1yb5ri9mk3mf5fkcsf6pbhrk4ch4z6kwb6vx27300wyzc7"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/AlecAivazis/survey/v2"))
    (propagated-inputs
      `(("go-golang-org-x-text" ,go-golang-org-x-text)
        ("go-golang-org-x-term" ,go-golang-org-x-term)
        ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
        ("go-github-com-mgutz-ansi" ,go-github-com-mgutz-ansi)
        ("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
        ("go-github-com-mattn-go-colorable" ,go-github-com-mattn-go-colorable)
        ("go-github-com-kballard-go-shellquote"
         ,go-github-com-kballard-go-shellquote)
        ("go-github-com-hinshun-vt10x" ,go-github-com-hinshun-vt10x)
        ("go-github-com-davecgh-go-spew" ,go-github-com-davecgh-go-spew)
        ("go-github-com-creack-pty" ,go-github-com-creack-pty)
        ("go-github-com-netflix-go-expect" ,go-github-com-netflix-go-expect)))
    (home-page "https://github.com/AlecAivazis/survey")
    (synopsis "Survey")
    (description
      "This package provides a library for building interactive and accessible prompts
on terminals supporting ANSI escape sequences.")
    (license license:expat)))

(define-public go-github-com-makenowjust-heredoc
  (package
    (name "go-github-com-makenowjust-heredoc")
    (version "1.0.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/makenowjust/heredoc")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "18f21zm8n2wlnkz1ylw8rcxmqxyv2rlz8749yfqggm2m0m2884pj"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/MakeNowJust/heredoc"))
    (home-page "https://github.com/MakeNowJust/heredoc")
    (synopsis "heredoc")
    (description
      "Package heredoc provides creation of here-documents from raw strings.")
    (license license:expat)))

(define-public go-github-com-briandowns-spinner
  (package
    (name "go-github-com-briandowns-spinner")
    (version "1.18.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/briandowns/spinner")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "068m7158rmh370j43dkdm7fd91mfcqj3h4n8h47411ppw8bpfhj2"))))
    (build-system go-build-system)
    (arguments
     '(#:import-path "github.com/briandowns/spinner"
       #:tests? #f))
    (propagated-inputs
      `(("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
        ("go-github-com-mattn-go-colorable" ,go-github-com-mattn-go-colorable)
        ("go-github-com-fatih-color" ,go-github-com-fatih-color)))
    (home-page "https://github.com/briandowns/spinner")
    (synopsis "Spinner")
    (description
      "Package spinner is a simple package to add a spinner / progress indicator to any
terminal application.")
    (license license:asl2.0)))

(define-public go-github-com-lucasb-eyer-go-colorful
  (package
    (name "go-github-com-lucasb-eyer-go-colorful")
    (version "1.2.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/lucasb-eyer/go-colorful")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "08c3fkf27r16izjjd4w94xd1z7w1r4mdalbl53ms2ka2j465s3qs"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/lucasb-eyer/go-colorful"))
    (home-page "https://github.com/lucasb-eyer/go-colorful")
    (synopsis "go-colorful")
    (description
      "The colorful package provides all kinds of functions for working with colors.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-lipgloss
  (package
    (name "go-github-com-charmbracelet-lipgloss")
    (version "0.5.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/charmbracelet/lipgloss")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "17qp0zsbjk9g76vy5xg2h487a6f5mj5i6ksjrz75lz68d2gcbj59"))))
    (build-system go-build-system)
    (arguments '(#:phases
                 (modify-phases %standard-phases
                                (delete 'build))
                 #:import-path "github.com/charmbracelet/lipgloss"
                 #:tests? #f))
    (propagated-inputs
      `(("go-golang-org-x-sys" ,go-golang-org-x-sys)
        ("go-github-com-muesli-termenv" ,go-github-com-muesli-termenv)
        ("go-github-com-muesli-reflow-ansi" ,go-github-com-muesli-reflow-ansi)
        ("go-github-com-muesli-reflow-wordwrap" ,go-github-com-muesli-reflow-wordwrap)
        ("go-github-com-muesli-reflow-indent" ,go-github-com-muesli-reflow-indent)
        ("go-github-com-muesli-reflow-padding" ,go-github-com-muesli-reflow-padding)
        ("go-github-com-muesli-reflow-wrap" ,go-github-com-muesli-reflow-wrap)
        ("go-github-com-mattn-go-runewidth" ,go-github-com-mattn-go-runewidth)
        ("go-github-com-lucasb-eyer-go-colorful"
         ,go-github-com-lucasb-eyer-go-colorful)))
    (home-page "https://github.com/charmbracelet/lipgloss")
    (synopsis "Lip Gloss")
    (description
      "Style definitions for nice terminal layouts.  Built with TUIs in mind.")
    (license license:expat)))

(define-public go-github-com-cli-browser
  (package
    (name "go-github-com-cli-browser")
    (version "1.1.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/cli/browser")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "13z27cc0a184bhprspwclzbvrzsrfd5qyk5r2djfx5nm85igxr0n"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/cli/browser"))
    (propagated-inputs `(("go-golang-org-x-sys" ,go-golang-org-x-sys)))
    (home-page "https://github.com/cli/browser")
    (synopsis "browser")
    (description
      "Package browser provides helpers to open files, readers, and urls in a browser
window.")
    (license license:bsd-2)))

(define-public go-github-com-cli-oauth
  (package
    (name "go-github-com-cli-oauth")
    (version "0.9.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/cli/oauth")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1h45ms2772mcbki0pj1i396i77w7j3jbcbzi7zpn7i6hsmj1rvd3"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/cli/oauth"))
    (propagated-inputs
      `(("go-github-com-cli-browser" ,go-github-com-cli-browser)))
    (home-page "https://github.com/cli/oauth")
    (synopsis "oauth")
    (description
      "Package oauth is a library for Go client applications that need to perform OAuth
authorization against a server, typically GitHub.com.")
    (license license:expat)))

(define-public go-github-com-cli-safeexec
  (package
    (name "go-github-com-cli-safeexec")
    (version "1.0.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/cli/safeexec")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1q80va3721dyw33lrnv7x3gd66kcnbsm38dv3lk7xqhii2adawmk"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/cli/safeexec"))
    (home-page "https://github.com/cli/safeexec")
    (synopsis "safeexec")
    (description
      "This package provides a Go module that provides a safer alternative to
@code{exec.LookPath()} on Windows.")
    (license license:bsd-2)))

(define-public go-github-com-cli-shurcool-graphql
  (package
    (name "go-github-com-cli-shurcool-graphql")
    (version "0.0.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/cli/shurcooL-graphql")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0vjh14w6q66lkxjsrcav1rb6n2scyblib71x2gr47pz0y5g69lrv"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/cli/shurcooL-graphql"))
    (propagated-inputs `(("go-golang-org-x-net" ,go-golang-org-x-net)))
    (home-page "https://github.com/cli/shurcooL-graphql")
    (synopsis "graphql")
    (description
      "Package @code{graphql} provides a GraphQL client implementation, and is forked
from @code{https://github.com/shurcooL/graphql}.")
    (license license:expat)))

(define-public go-github-com-russross-blackfriday-v2
  (package
    (name "go-github-com-russross-blackfriday-v2")
    (version "2.1.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/russross/blackfriday")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0d1rg1drrfmabilqjjayklsz5d0n3hkf979sr3wsrw92bfbkivs7"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/russross/blackfriday/v2"
                 #:tests? #f))
    (home-page "https://github.com/russross/blackfriday")
    (synopsis "Blackfriday")
    (description "Package blackfriday is a markdown processor.")
    (license license:bsd-2)))

(define-public go-github-com-cpuguy83-go-md2man-v2
  (package
    (name "go-github-com-cpuguy83-go-md2man-v2")
    (version "2.0.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/cpuguy83/go-md2man")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "051ljpzf1f5nh631lvn53ziclkzmx5lza8545mkk6wxdfnfdcx8f"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/cpuguy83/go-md2man/v2"))
    (propagated-inputs
      `(("go-github-com-russross-blackfriday-v2"
         ,go-github-com-russross-blackfriday-v2)))
    (home-page "https://github.com/cpuguy83/go-md2man")
    (synopsis "go-md2man")
    (description "Converts markdown into roff (man pages).")
    (license license:expat)))

(define-public go-github-com-creack-pty
  (package
    (name "go-github-com-creack-pty")
    (version "1.1.18")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/creack/pty")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1qqhcgfym0napz8damj7dhfw28g2qn2f5h3lr93i0sxawq926yzc"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/creack/pty"))
    (home-page "https://github.com/creack/pty")
    (synopsis "pty")
    (description
      "Package pty provides functions for working with Unix terminals.")
    (license license:expat)))

(define-public go-github-com-gabriel-vasile-mimetype
  (package
    (name "go-github-com-gabriel-vasile-mimetype")
    (version "1.4.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/gabriel-vasile/mimetype")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0ivxwgb62dyvj8viyszn7p74lmykcplfgz38qrv5hwdf8i5xd53a"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/gabriel-vasile/mimetype" #:tests? #f))
    (propagated-inputs `(("go-golang-org-x-net" ,go-golang-org-x-net)))
    (home-page "https://github.com/gabriel-vasile/mimetype")
    (synopsis "Features")
    (description
      "Package mimetype uses magic number signatures to detect the MIME type of a file.")
    (license license:expat)))

(define-public go-github-com-google-shlex
  (package
    (name "go-github-com-google-shlex")
    (version "0.0.0-20191202100458-e7afc7fbc510")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/google/shlex")
               (commit (go-version->git-ref version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "14z8hqyik910wk2qwnzgz8mjsmiamxa0pj55ahbv0jx6j3dgvzfm"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/google/shlex"))
    (home-page "https://github.com/google/shlex")
    (synopsis #f)
    (description
      "Package shlex implements a simple lexer which splits input in to tokens using
shell-style rules for quoting and commenting.")
    (license license:asl2.0)))

(define-public go-github-com-hashicorp-errwrap
  (package
    (name "go-github-com-hashicorp-errwrap")
    (version "1.1.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/hashicorp/errwrap")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0p5wdz8p7dmwphmb33gwhy3iwci5k9wkfqmmfa6ay1lz0cqjwp7a"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/hashicorp/errwrap"))
    (home-page "https://github.com/hashicorp/errwrap")
    (synopsis "errwrap")
    (description
      "Package errwrap implements methods to formalize error wrapping in Go.")
    (license license:mpl2.0)))

(define-public go-github-com-hashicorp-go-multierror
  (package
    (name "go-github-com-hashicorp-go-multierror")
    (version "1.1.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/hashicorp/go-multierror")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0l4s41skdpifndn9s8y6s9vzgghdzg4z8z0lld9qjr28888wzp00"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/hashicorp/go-multierror"))
    (propagated-inputs
      `(("go-github-com-hashicorp-errwrap" ,go-github-com-hashicorp-errwrap)))
    (home-page "https://github.com/hashicorp/go-multierror")
    (synopsis "go-multierror")
    (description
      "@code{go-multierror} is a package for Go that provides a mechanism for
representing a list of @code{error} values as a single @code{error}.")
    (license license:mpl2.0)))

(define-public go-github-com-henvic-httpretty
  (package
    (name "go-github-com-henvic-httpretty")
    (version "0.0.6")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/henvic/httpretty")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1jbnj1x8wribayx65ssxigs9p88pi0cxg36h8qhqvqz1pqiygksa"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/henvic/httpretty"))
    (home-page "https://github.com/henvic/httpretty")
    (synopsis "httpretty")
    (description
      "Package httpretty prints your HTTP requests pretty on your terminal screen.  You
can use this package both on the client-side and on the server-side.")
    (license license:expat)))

(define-public go-github-com-itchyny-timefmt-go
  (package
    (name "go-github-com-itchyny-timefmt-go")
    (version "0.1.3")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/itchyny/timefmt-go")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1gn2rpbm5s25ns537lr7blr5y0xywi5146j314b2wyrhr3ks4nbk"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/itchyny/timefmt-go"))
    (home-page "https://github.com/itchyny/timefmt-go")
    (synopsis "timefmt-go")
    (description
      "This is a Go language package for formatting and parsing date time strings.")
    (license license:expat)))

(define-public go-github-com-itchyny-gojq
  (package
    (name "go-github-com-itchyny-gojq")
    (version "0.12.7")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/itchyny/gojq")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0viv5kr852qssnnf1kw0v5p558h4hsi16nknq0nhi7h50fxln1k9"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/itchyny/gojq"))
    (propagated-inputs
      `(("go-gopkg-in-yaml-v3" ,go-gopkg-in-yaml-v3)
        ("go-golang-org-x-sys" ,go-golang-org-x-sys)
        ("go-github-com-mattn-go-runewidth" ,go-github-com-mattn-go-runewidth)
        ("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
        ("go-github-com-itchyny-timefmt-go" ,go-github-com-itchyny-timefmt-go)
        ("go-github-com-google-go-cmp-cmp" ,go-github-com-google-go-cmp-cmp)))
    (home-page "https://github.com/itchyny/gojq")
    (synopsis "gojq")
    (description "Package gojq provides the parser and interpreter of gojq.")
    (license license:expat)))

(define-public go-github-com-joho-godotenv
  (package
    (name "go-github-com-joho-godotenv")
    (version "1.4.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/joho/godotenv")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1036h59vyhb58n817az6yg0zw5wa87yb86i7fnbdq8cw46mnjgw8"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/joho/godotenv"))
    (home-page "https://github.com/joho/godotenv")
    (synopsis "GoDotEnv")
    (description
      "Package godotenv is a go port of the ruby dotenv library
(@url{https://github.com/bkeepers/dotenv,https://github.com/bkeepers/dotenv})")
    (license license:expat)))

(define-public go-github-com-muhammadmuzzammil1998-jsonc
  (package
    (name "go-github-com-muhammadmuzzammil1998-jsonc")
    (version "1.0.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/muhammadmuzzammil1998/jsonc")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "037xi03p46hnfwwh5ylnkzm859h9bi3yn451647y4ghzjbwii1g4"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/muhammadmuzzammil1998/jsonc"))
    (home-page "https://github.com/muhammadmuzzammil1998/jsonc")
    (synopsis #f)
    (description
      "JSONC is a superset of JSON which supports comments.  JSON formatted files are
readable to humans but the lack of comments decreases readability.  With JSONC,
you can use block (@code{/* */}) and single line (@code{//} of @code{#})
comments to describe the functionality.  Microsoft VS Code also uses this format
in their configuration files like @code{settings.json}, @code{keybindings.json},
@code{launch.json}, etc.")
    (license license:expat)))

(define-public go-github-com-shurcool-githubv4
  (package
    (name "go-github-com-shurcool-githubv4")
    (version "0.0.0-20220115235240-a14260e6f8a2")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/shurcooL/githubv4")
               (commit (go-version->git-ref version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1p44ijy0cfxdfx0myfkyi0m9x12drsf1p7ssqvh019dk9m8x0388"))))
    (build-system go-build-system)
    (arguments '(#:phases
                 (modify-phases %standard-phases
                                (delete 'build))
                 #:import-path "github.com/shurcooL/githubv4"
                 #:tests? #f))
    (home-page "https://github.com/shurcooL/githubv4")
    (synopsis "githubv4")
    (description
      "Package githubv4 is a client library for accessing GitHub GraphQL API v4
(@url{https://docs.github.com/en/graphql,https://docs.github.com/en/graphql}).")
    (license license:expat)))

(define-public go-github-com-shurcool-graphql
  (package
    (name "go-github-com-shurcool-graphql")
    (version "0.0.0-20200928012149-18c5c3165e3a")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/shurcooL/graphql")
               (commit (go-version->git-ref version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0psxc2q3qsh1lfag11m2gz54fzzvlss5znyf34aars94igsjywzx"))))
    (build-system go-build-system)
    (arguments '(#:phases
                 (modify-phases %standard-phases
                                (delete 'build))
                 #:import-path "github.com/shurcooL/graphql"
                 #:tests? #f))
    (home-page "https://github.com/shurcooL/graphql")
    (synopsis "graphql")
    (description "Package graphql provides a GraphQL client implementation.")
    (license license:expat)))

(define-public go-github-com-gorilla-websocket
  (package
    (name "go-github-com-gorilla-websocket")
    (version "1.5.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/gorilla/websocket")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1xrr6snvs9g1nzxxg05w4i4pq6k1xjljl5mvavd838qc468n118i"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/gorilla/websocket"))
    (home-page "https://github.com/gorilla/websocket")
    (synopsis "Gorilla WebSocket")
    (description
      "Package websocket implements the WebSocket protocol defined in
@url{https://rfc-editor.org/rfc/rfc6455.html,RFC 6455}.")
    (license license:bsd-2)))

(define-public go-github-com-sourcegraph-jsonrpc2
  (package
    (name "go-github-com-sourcegraph-jsonrpc2")
    (version "0.1.0")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/sourcegraph/jsonrpc2")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "1dk0w32k96vxrwnmm24wqx337dn8ylch65qwrbc3wh7whw2xx71q"))))
    (build-system go-build-system)
    (arguments '(#:import-path "github.com/sourcegraph/jsonrpc2"))
    (propagated-inputs
      `(("go-github-com-gorilla-websocket" ,go-github-com-gorilla-websocket)))
    (home-page "https://github.com/sourcegraph/jsonrpc2")
    (synopsis "jsonrpc2: JSON-RPC 2.0 implementation for Go")
    (description
      "Package jsonrpc2 provides a client and server implementation of [JSON-RPC
2.0](@url{http://www.jsonrpc.org/specification,http://www.jsonrpc.org/specification}).")
    (license license:expat)))

(define-public go-github-com-cli-cli-v2
  (package
    (name "go-github-com-cli-cli-v2")
    (version "2.10.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/cli/cli")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
          (base32 "0bxahv9vv32jq9xba1aqljbpb4n1jmcvllmm1dz6z89yxq80flns"))))
    (build-system go-build-system)
    (arguments '(#:phases
                 (modify-phases %standard-phases
                   (replace 'build
                     (lambda* (#:key import-path #:allow-other-keys)
                       (with-directory-excursion (string-append (getenv "GOPATH") "/src/" import-path)
                         (invoke "make"))))
                   (replace 'install
                     (lambda* (#:key import-path outputs #:allow-other-keys)
                       (with-directory-excursion (string-append (getenv "GOPATH") "/src/" import-path)
                         (invoke "make" "install"
                                 (string-append "prefix=" (assoc-ref outputs "out"))))))
                   (replace 'check
                     (lambda* (#:key tests? #:allow-other-keys)
                       (when tests? (invoke "make" "test")))))
                 #:import-path "github.com/cli/cli"
                 #:tests? #f))
    (propagated-inputs
      `(("go-github-com-cli-crypto" ,go-github-com-cli-crypto)
        ("go-gopkg-in-yaml-v3" ,go-gopkg-in-yaml-v3)
        ("go-golang-org-x-term" ,go-golang-org-x-term)
        ("go-golang-org-x-sys" ,go-golang-org-x-sys)
        ("go-golang-org-x-sync" ,go-golang-org-x-sync)
        ("go-golang-org-x-oauth2" ,go-golang-org-x-oauth2)
        ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
        ("go-github-com-spf13-pflag" ,go-github-com-spf13-pflag)
        ("go-github-com-spf13-cobra-v1.2" ,go-github-com-spf13-cobra-v1.2)
        ("go-github-com-sourcegraph-jsonrpc2"
         ,go-github-com-sourcegraph-jsonrpc2)
        ("go-github-com-shurcool-graphql" ,go-github-com-shurcool-graphql)
        ("go-github-com-shurcool-githubv4" ,go-github-com-shurcool-githubv4)
        ("go-github-com-opentracing-opentracing-go"
         ,go-github-com-opentracing-opentracing-go)
        ("go-github-com-muhammadmuzzammil1998-jsonc"
         ,go-github-com-muhammadmuzzammil1998-jsonc)
        ("go-github-com-muesli-termenv" ,go-github-com-muesli-termenv)
        ("go-github-com-muesli-reflow-ansi" ,go-github-com-muesli-reflow-ansi)
        ("go-github-com-muesli-reflow-wordwrap" ,go-github-com-muesli-reflow-wordwrap)
        ("go-github-com-muesli-reflow-indent" ,go-github-com-muesli-reflow-indent)
        ("go-github-com-muesli-reflow-padding" ,go-github-com-muesli-reflow-padding)
        ("go-github-com-muesli-reflow-wrap" ,go-github-com-muesli-reflow-wrap)
        ("go-github-com-mgutz-ansi" ,go-github-com-mgutz-ansi)
        ("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
        ("go-github-com-mattn-go-colorable" ,go-github-com-mattn-go-colorable)
        ("go-github-com-kballard-go-shellquote"
         ,go-github-com-kballard-go-shellquote)
        ("go-github-com-joho-godotenv" ,go-github-com-joho-godotenv)
        ("go-github-com-itchyny-gojq" ,go-github-com-itchyny-gojq)
        ("go-github-com-henvic-httpretty" ,go-github-com-henvic-httpretty)
        ("go-github-com-hashicorp-go-version"
         ,go-github-com-hashicorp-go-version)
        ("go-github-com-hashicorp-go-multierror"
         ,go-github-com-hashicorp-go-multierror)
        ("go-github-com-gorilla-websocket" ,go-github-com-gorilla-websocket)
        ("go-github-com-google-shlex" ,go-github-com-google-shlex)
        ("go-github-com-google-go-cmp-cmp" ,go-github-com-google-go-cmp-cmp)
        ("go-github-com-gabriel-vasile-mimetype"
         ,go-github-com-gabriel-vasile-mimetype)
        ("go-github-com-creack-pty" ,go-github-com-creack-pty)
        ("go-github-com-cpuguy83-go-md2man-v2"
         ,go-github-com-cpuguy83-go-md2man-v2)
        ("go-github-com-cli-shurcool-graphql"
         ,go-github-com-cli-shurcool-graphql)
        ("go-github-com-cli-safeexec" ,go-github-com-cli-safeexec)
        ("go-github-com-cli-oauth" ,go-github-com-cli-oauth)
        ("go-github-com-cli-browser" ,go-github-com-cli-browser)
        ("go-github-com-charmbracelet-lipgloss"
         ,go-github-com-charmbracelet-lipgloss)
        ("go-github-com-charmbracelet-glamour-without-test"
         ,go-github-com-charmbracelet-glamour-without-test)
        ("go-github-com-briandowns-spinner" ,go-github-com-briandowns-spinner)
        ("go-github-com-makenowjust-heredoc"
         ,go-github-com-makenowjust-heredoc)
        ("go-github-com-alecaivazis-survey-v2"
         ,go-github-com-alecaivazis-survey-v2)
        ("go-golang-org-x-crypto" ,go-golang-org-x-crypto)))
    (native-inputs
     (list go git))
    (home-page "https://github.com/cli/cli")
    (synopsis "GitHub CLI")
    (description
      "@code{gh} is GitHub on the command line.  It brings pull requests, issues, and
other GitHub concepts to the terminal next to where you are already working with
@code{git} and your code.")
    (license license:expat)))
