(define-module
  (roquix packages glab)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build utils)
  #:use-module (guix build-system go)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-web)
  #:use-module (gnu packages syncthing))

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
    (arguments
     (list
      #:import-path "github.com/Netflix/go-expect"))
    (propagated-inputs `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
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
    (arguments
     (list
      #:import-path "github.com/hinshun/vt10x"))
    (home-page "https://github.com/hinshun/vt10x")
    (synopsis "vt10x")
    (description
     "Package terminal is a vt10x terminal emulation backend, influenced largely by
st, rxvt, xterm, and @code{iTerm} as reference.  Use it for terminal muxing, a
terminal emulation frontend, or wherever else you need terminal emulation.")
    (license license:expat)))

(define-public go-github-com-alecaivazis-survey-v2
  (package
    (name "go-github-com-alecaivazis-survey-v2")
    (version "2.3.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/AlecAivazis/survey")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0l3wqphqvm0qxv33pj9f1r72z5fln99vg735fcigv8k513m2aw9l"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/AlecAivazis/survey/v2"))
    (propagated-inputs
     (list go-golang-org-x-text
           go-golang-org-x-term
           go-github-com-stretchr-testify
           go-github-com-mgutz-ansi
           go-github-com-mattn-go-colorable
           go-github-com-mattn-go-isatty
           go-github-com-kballard-go-shellquote
           go-github-com-hinshun-vt10x
           go-github-com-creack-pty
           go-github-com-netflix-go-expect))
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
    (arguments
     (list
      #:import-path "github.com/MakeNowJust/heredoc"))
    (home-page "https://github.com/MakeNowJust/heredoc")
    (synopsis "heredoc")
    (description
     "Package heredoc provides creation of here-documents from raw strings.")
    (license license:expat)))

(define-public go-github-com-acarl005-stripansi
  (package
    (name "go-github-com-acarl005-stripansi")
    (version "0.0.0-20180116102854-5a71ef0e047d")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/acarl005/stripansi")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02sxiishdixm791jqbkmhdcvc712l0fb8rqmibxzgc61h0qs6rs3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/acarl005/stripansi"))
    (home-page "https://github.com/acarl005/stripansi")
    (synopsis "Strip ANSI")
    (description "This Go package removes ANSI escape codes from strings.")
    (license license:expat)))

(define-public go-github-com-briandowns-spinner
  (package
    (name "go-github-com-briandowns-spinner")
    (version "1.23.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/briandowns/spinner")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "036r59m068k8grr0q77a6b1rqw4dyxm00fsxj7b9w1fjviq8djs6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/briandowns/spinner"))
    (propagated-inputs `(("go-golang-org-x-term" ,go-golang-org-x-term)
                         ("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
                         ("go-github-com-fatih-color" ,go-github-com-fatih-color)))
    (home-page "https://github.com/briandowns/spinner")
    (synopsis "Spinner")
    (description
     "Package spinner is a simple package to add a spinner / progress indicator to any
terminal application.")
    (license license:asl2.0)))

(define-public go-github-com-gdamore-tcell-v2
  (package
    (name "go-github-com-gdamore-tcell-v2")
    (version "2.7.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gdamore/tcell")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "14zbscxwc0d1dkz77f4y38zp21kndc3wik7mqn7gcizl9lbvq0f8"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gdamore/tcell/v2"))
    (propagated-inputs `(("go-golang-org-x-text" ,go-golang-org-x-text)
                         ("go-golang-org-x-term" ,go-golang-org-x-term)
                         ("go-golang-org-x-sys" ,go-golang-org-x-sys)
                         ("go-github-com-mattn-go-runewidth" ,go-github-com-mattn-go-runewidth)
                         ("go-github-com-lucasb-eyer-go-colorful" ,go-github-com-lucasb-eyer-go-colorful)
                         ("go-github-com-gdamore-encoding" ,go-github-com-gdamore-encoding)))
    (home-page "https://github.com/gdamore/tcell")
    (synopsis "Tcell")
    (description
     "Package tcell provides a lower-level, portable API for building programs that
interact with terminals or consoles.  It works with both common (and many
uncommon!) terminals or terminal emulators, and Windows console implementations.")
    (license license:asl2.0)))

(define-public go-github-com-gosuri-uilive
  (package
    (name "go-github-com-gosuri-uilive")
    (version "0.0.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gosuri/uilive")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0pwxx0w4mv908dascnxkdjq865ks01niqy71imv4kllz0a84zkag"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gosuri/uilive"))
    (home-page "https://github.com/gosuri/uilive")
    (synopsis "uilive")
    (description
     "Package uilive provides a writer that live updates the terminal.  It provides a
buffered io.Writer that is flushed at a timed interval.")
    (license license:expat)))

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
    (arguments
     (list
      #:import-path "github.com/hashicorp/errwrap"))
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
    (arguments
     (list
      #:import-path "github.com/hashicorp/go-multierror"))
    (propagated-inputs `(("go-github-com-hashicorp-errwrap" ,go-github-com-hashicorp-errwrap)))
    (home-page "https://github.com/hashicorp/go-multierror")
    (synopsis "go-multierror")
    (description
     "@@code{go-multierror} is a package for Go that provides a mechanism for
representing a list of @@code{error} values as a single @@code{error}.")
    (license license:mpl2.0)))

(define-public go-github-com-otiai10-mint
  (package
    (name "go-github-com-otiai10-mint")
    (version "1.6.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/otiai10/mint")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0g5zhz4znp68427p2a1yvrxbq90y7caagdd7zsb4iygnhdszfm7w"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.18
      #:import-path "github.com/otiai10/mint"))
    (home-page "https://github.com/otiai10/mint")
    (synopsis "mint")
    (description "The very minimum assertion for Go.")
    (license license:expat)))

(define-public go-github-com-otiai10-copy
  (package
    (name "go-github-com-otiai10-copy")
    (version "1.14.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/otiai10/copy")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0fv4cwk4k5fsd3hq5akqxrd5qxj9qm6a2wlp6s1knblhzkm1jxzb"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.18
      #:import-path "github.com/otiai10/copy"))
    (propagated-inputs `(("go-golang-org-x-sys" ,go-golang-org-x-sys)
                         ("go-golang-org-x-sync" ,go-golang-org-x-sync)
                         ("go-github-com-otiai10-mint" ,go-github-com-otiai10-mint)))
    (home-page "https://github.com/otiai10/copy")
    (synopsis "copy")
    (description "@@code{copy} copies directories recursively.")
    (license license:expat)))

(define-public go-github-com-tidwall-pretty
  (package
    (name "go-github-com-tidwall-pretty")
    (version "1.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tidwall/pretty")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0prj9vpjgrca70rvx40kkl566yf9lw4fsbcmszwamwl364696jsb"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/tidwall/pretty"))
    (home-page "https://github.com/tidwall/pretty")
    (synopsis "Pretty")
    (description
     "Pretty is a Go package that provides @@url{#readme-performance,fast} methods for
formatting JSON for human readability, or to compact JSON for smaller payloads.")
    (license license:expat)))

(define-public go-github-com-hashicorp-go-cleanhttp
  (package
    (name "go-github-com-hashicorp-go-cleanhttp")
    (version "0.5.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/go-cleanhttp")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1i5xslizzwd966w81bz6dxjwzgml4q9bwqa186bsxd1vi8lqxl9p"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/hashicorp/go-cleanhttp"))
    (home-page "https://github.com/hashicorp/go-cleanhttp")
    (synopsis "cleanhttp")
    (description
     "Package cleanhttp offers convenience utilities for acquiring \"clean\"
http.Transport and http.Client structs.")
    (license license:mpl2.0)))

(define-public go-github-com-hashicorp-go-hclog
  (package
    (name "go-github-com-hashicorp-go-hclog")
    (version "1.6.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/go-hclog")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1lvr4ga95a0xb62vgq1hy558x3r65hn2d0h7bf0a88lsfsrcik0n"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/hashicorp/go-hclog"))
    (propagated-inputs `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
                         ("go-github-com-mattn-go-colorable" ,go-github-com-mattn-go-colorable)
                         ("go-github-com-fatih-color" ,go-github-com-fatih-color)))
    (home-page "https://github.com/hashicorp/go-hclog")
    (synopsis "go-hclog")
    (description
     "@@code{go-hclog} is a package for Go that provides a simple key/value logging
interface for use in development and production environments.")
    (license license:expat)))

(define-public go-github-com-hashicorp-go-retryablehttp
  (package
    (name "go-github-com-hashicorp-go-retryablehttp")
    (version "0.7.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/go-retryablehttp")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "05p0b22mjq5cvqllxx7rjlb929523m48847nl4qj47dxcvdsn1p6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/hashicorp/go-retryablehttp"))
    (propagated-inputs `(("go-github-com-hashicorp-go-hclog" ,go-github-com-hashicorp-go-hclog)
                         ("go-github-com-hashicorp-go-cleanhttp" ,go-github-com-hashicorp-go-cleanhttp)))
    (home-page "https://github.com/hashicorp/go-retryablehttp")
    (synopsis "go-retryablehttp")
    (description
     "Package retryablehttp provides a familiar HTTP client interface with automatic
retries and exponential backoff.  It is a thin wrapper over the standard
net/http client library and exposes nearly the same public API. This makes
retryablehttp very easy to drop into existing programs.")
    (license license:mpl2.0)))

(define-public go-github-com-xanzy-go-gitlab
  (package
    (name "go-github-com-xanzy-go-gitlab")
    (version "0.97.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xanzy/go-gitlab")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jrb1lhf9sih4w4sfzzlh0bgdsgfvk9dq8b6fzfi5gq7zg0k3h9i"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.19
      #:import-path "github.com/xanzy/go-gitlab"))
    (propagated-inputs `(("go-golang-org-x-time" ,go-golang-org-x-time)
                         ("go-golang-org-x-oauth2" ,go-golang-org-x-oauth2)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-hashicorp-go-retryablehttp" ,go-github-com-hashicorp-go-retryablehttp)
                         ("go-github-com-hashicorp-go-cleanhttp" ,go-github-com-hashicorp-go-cleanhttp)
                         ("go-github-com-google-go-querystring" ,go-github-com-google-go-querystring)))
    (home-page "https://github.com/xanzy/go-gitlab")
    (synopsis "go-gitlab")
    (description "Copyright 2022, Daniela Filipe Bento")
    (license license:asl2.0)))

(define-public go-github-com-golang-groupcache
  (package
    (name "go-github-com-golang-groupcache")
    (version "0.0.0-20210331224755-41bb18bfe9da")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/golang/groupcache")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07amgr8ji4mnq91qbsw2jlcmw6hqiwdf4kzfdrj8c4b05w4knszc"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/golang/groupcache"))
    (propagated-inputs
     (list go-google-golang-org-protobuf))
    (home-page "https://github.com/golang/groupcache")
    (synopsis "groupcache")
    (description
     "Package groupcache provides a data loading mechanism with caching and
de-duplication that works across a set of peer processes.")
    (license license:asl2.0)))

(define-public go-k8s-io-api
  (package
    (name "go-k8s-io-api")
    (version "0.29.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/api")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0nb5qb0r3shfq397mspni06pfl50rylzfsgf3lgp7il4m99xvg1v"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.21
      #:import-path "k8s.io/api"))
    (propagated-inputs `(("go-k8s-io-apimachinery" ,go-k8s-io-apimachinery)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-gogo-protobuf" ,go-github-com-gogo-protobuf)))
    (home-page "https://k8s.io/api")
    (synopsis "api")
    (description
     "Schema of the external API types that are served by the Kubernetes API server.")
    (license license:asl2.0)))

(define-public go-github-com-armon-go-socks5
  (package
    (name "go-github-com-armon-go-socks5")
    (version "0.0.0-20160902184237-e75332964ef5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/armon/go-socks5")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "104w10jf0wlxyxi35hf6frndgf0ybz21h54xjmnkivpb6slycpyq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/armon/go-socks5"))
    (propagated-inputs
     (list go-golang-org-x-net))
    (home-page "https://github.com/armon/go-socks5")
    (synopsis "go-socks5")
    (description
     "This package provides the @@code{socks5} package that implements a
@@url{http://en.wikipedia.org/wiki/SOCKS,SOCKS5 server}.  SOCKS (Secure Sockets)
is used to route traffic between a client and server through an intermediate
proxy layer.  This can be used to bypass firewalls or NATs.")
    (license license:expat)))

(define-public go-github-com-jessevdk-go-flags
  (package
    (name "go-github-com-jessevdk-go-flags")
    (version "1.5.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jessevdk/go-flags")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13ixw1yx4bvcj66lkc8zgwf9j7gkvj686g991gycdsafvdvca0lj"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/jessevdk/go-flags"))
    (propagated-inputs `(("go-golang-org-x-sys" ,go-golang-org-x-sys)))
    (home-page "https://github.com/jessevdk/go-flags")
    (synopsis "go-flags: a go library for parsing command line arguments")
    (description
     "Package flags provides an extensive command line option parser.  The flags
package is similar in functionality to the go built-in flag package but provides
more options and uses reflection to provide a convenient and succinct way of
specifying command line options.")
    (license license:bsd-3)))

(define-public go-github-com-evanphx-json-patch
  (package
    (name "go-github-com-evanphx-json-patch")
    (version "0.5.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/evanphx/json-patch")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00sib9ba8j1h1n3r1cxx48zn8hs6sxwnrh78p6wbs28wcpz8nqxi"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/evanphx/json-patch"))
    (propagated-inputs `(("go-github-com-pkg-errors" ,go-github-com-pkg-errors)
                         ("go-github-com-jessevdk-go-flags" ,go-github-com-jessevdk-go-flags)))
    (home-page "https://github.com/evanphx/json-patch")
    (synopsis "JSON-Patch")
    (description
     "@@code{jsonpatch} is a library which provides functionality for both applying
@@url{http://tools.ietf.org/html/rfc6902,RFC6902 JSON patches} against
documents, as well as for calculating & applying
@@url{https://tools.ietf.org/html/rfc7396,RFC7396 JSON merge patches}.")
    (license license:bsd-3)))

(define-public go-github-com-moby-spdystream
  (package
    (name "go-github-com-moby-spdystream")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/moby/spdystream")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1p4vk251hsv7cf86qgv1ds104cyxs6ibdxlkbcdb3ayfxqsh5n1p"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/moby/spdystream"))
    (propagated-inputs `(("go-github-com-gorilla-websocket" ,go-github-com-gorilla-websocket)))
    (home-page "https://github.com/moby/spdystream")
    (synopsis "SpdyStream")
    (description
     "This package provides a multiplexed stream library using spdy")
    (license license:asl2.0)))

(define-public go-github-com-mxk-go-flowrate
  (package
    (name "go-github-com-mxk-go-flowrate")
    (version "0.0.0-20140419014527-cca7078d478f")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mxk/go-flowrate")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zqs39923ja0yypdmiqk6x8pgmfs3ms5x5sl1dqv9z6zyx2xy541"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/mxk/go-flowrate"))
    (home-page "https://github.com/mxk/go-flowrate")
    (synopsis #f)
    (description #f)
    (license license:bsd-3)))

(define-public go-gopkg-in-inf-v0
  (package
    (name "go-gopkg-in-inf-v0")
    (version "0.9.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gopkg.in/inf.v0")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00k5iqjcp371fllqxncv7jkf80hn1zww92zm78cclbcn4ybigkng"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "gopkg.in/inf.v0"
      #:unpack-path "gopkg.in/inf.v0"))
    (home-page "https://gopkg.in/inf.v0")
    (synopsis #f)
    (description
     "Package inf (type inf.Dec) implements \"infinite-precision\" decimal arithmetic.
\"Infinite precision\" describes two characteristics: practically unlimited
precision for decimal number representation and no support for calculating with
any specific fixed precision. (Although there is no practical limit on
precision, inf.Dec can only represent finite decimals.)")
    (license license:bsd-3)))

(define-public go-github-com-nytimes-gziphandler
  (package
    (name "go-github-com-nytimes-gziphandler")
    (version "1.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nytimes/gziphandler")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0rhrjlw220hnymzfccm0yir3pc9dpj7h3gwzhzq2cbsb3hhsqvyy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/NYTimes/gziphandler"))
    (propagated-inputs `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)))
    (home-page "https://github.com/NYTimes/gziphandler")
    (synopsis "Gzip Handler")
    (description
     "This is a tiny Go package which wraps HTTP handlers to transparently gzip the
response body, for clients which support it.  Although it's usually simpler to
leave that to a reverse proxy (like nginx or Varnish), this package is useful
when that's undesirable.")
    (license license:asl2.0)))

(define-public go-github-com-asaskevich-govalidator
  (package
    (name "go-github-com-asaskevich-govalidator")
    (version "0.0.0-20230301143203-a9d515a09cc2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/asaskevich/govalidator")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "05cgkp6qk2p0c5gq3dppaq641bs2w0qzpbx1b00ayjf47z01fqg4"))))
    (build-system go-build-system)
    (arguments
     (list
      ;; TODO: Somehow tests failed
      #:tests? #f
      #:import-path "github.com/asaskevich/govalidator"))
    (home-page "https://github.com/asaskevich/govalidator")
    (synopsis "govalidator")
    (description
     "Package govalidator is package of validators and sanitizers for strings, structs
and collections.")
    (license license:expat)))

(define-public go-github-com-emicklei-go-restful-v3
  (package
    (name "go-github-com-emicklei-go-restful-v3")
    (version "3.11.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/emicklei/go-restful")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0izfb28clb0chmpd45rviw6rdl4lsqlx100zvvssmlqmbqs7rk6l"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/emicklei/go-restful/v3"))
    (home-page "https://github.com/emicklei/go-restful")
    (synopsis "go-restful")
    (description
     "Package restful , a lean package for creating REST-style @code{WebServices}
without magic.")
    (license license:expat)))

(define-public go-github-com-go-openapi-jsonpointer
  (package
    (name "go-github-com-go-openapi-jsonpointer")
    (version "0.20.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-openapi/jsonpointer")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bwxrhab4xdd9gsf1miifgfqj2k5q2kfxi5iprb9vg49zz21klng"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.19
      #:import-path "github.com/go-openapi/jsonpointer"))
    (propagated-inputs `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-go-openapi-swag" ,go-github-com-go-openapi-swag)))
    (home-page "https://github.com/go-openapi/jsonpointer")
    (synopsis "gojsonpointer")
    (description "An implementation of JSON Pointer - Go language")
    (license license:asl2.0)))

(define-public go-github-com-go-openapi-jsonreference
  (package
    (name "go-github-com-go-openapi-jsonreference")
    (version "0.20.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-openapi/jsonreference")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12zc1fj8yg8mdrarggik9rh42is9l5pv6s3h50dhqyfh026qrzfv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.19
      #:import-path "github.com/go-openapi/jsonreference"))
    (propagated-inputs `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-go-openapi-jsonpointer" ,go-github-com-go-openapi-jsonpointer)))
    (home-page "https://github.com/go-openapi/jsonreference")
    (synopsis "gojsonreference")
    (description "An implementation of JSON Reference - Go language")
    (license license:asl2.0)))

(define-public go-github-com-go-openapi-swag
  (package
    (name "go-github-com-go-openapi-swag")
    (version "0.22.9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-openapi/swag")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "04gvy3lhjn4v8rj43k4gsrrr6sln4sa0lgis6rrah060w0r08zxc"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.19
      #:import-path "github.com/go-openapi/swag"))
    (propagated-inputs `(("go-gopkg-in-yaml-v3" ,go-gopkg-in-yaml-v3)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-mailru-easyjson" ,go-github-com-mailru-easyjson)))
    (home-page "https://github.com/go-openapi/swag")
    (synopsis "Swag")
    (description
     "Package swag contains a bunch of helper functions for go-openapi and go-swagger
projects.")
    (license license:asl2.0)))

(define-public go-github-com-golang-protobuf-proto-1.5.2
  (package
    (inherit go-github-com-golang-protobuf-proto)
    (name "go-github-com-golang-protobuf-proto-1.5.2")
    (version "1.5.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                     (url "https://github.com/golang/protobuf")
                     (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1mh5fyim42dn821nsd3afnmgscrzzhn3h8rag635d2jnr23r1zhk"))))
    (arguments
     (list #:import-path "github.com/golang/protobuf/proto"
           #:unpack-path "github.com/golang/protobuf"
           ;; Requires unpackaged golang.org/x/sync/errgroup
           #:tests? #f
           #:phases #~(modify-phases %standard-phases
                        ;; source-only package
                        (delete 'build))))))

(define-public go-github-com-golang-protobuf-ptypes-1.5.2
  (package
    (inherit go-github-com-golang-protobuf-proto-1.5.2)

    (arguments
     (list #:import-path "github.com/golang/protobuf/ptypes"
           #:unpack-path "github.com/golang/protobuf"
           ;; Requires unpackaged golang.org/x/sync/errgroup
           #:tests? #f
           #:phases #~(modify-phases %standard-phases
                        ;; source-only package
                        (delete 'build))))))

(define-public go-github-com-google-gnostic-models-openapiv2
  (package
    (name "go-github-com-google-gnostic-models-openapiv2")
    (version "0.6.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/gnostic-models")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "113ahqvd9qyrbghh21qd7px4yks23l2rhiwvjilzgjfgkdg3yc33"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.18
      #:import-path "github.com/google/gnostic-models/openapiv2"
      #:unpack-path "github.com/google/gnostic-models"))
    (propagated-inputs
     (list
      go-github-com-golang-protobuf-proto-1.5.2
      go-github-com-golang-protobuf-ptypes-1.5.2
      go-gopkg-in-yaml-v3
      go-gopkg-in-check-v1
      go-google-golang-org-protobuf))
    (home-page "https://github.com/google/gnostic-models")
    (synopsis "⨁ gnostic-models")
    (description
     "This repository contains Protocol Buffer models and associated libraries for
working with API description formats supported by
@@url{https://github.com/google/gnostic,gnostic}.  It exists to provide a
lightweight distribution of these models with minimal dependencies.  For more
information, please see the @@url{https://github.com/google/gnostic,gnostic}
repository.")
    (license license:asl2.0)))

(define-public go-github-com-google-gnostic-models-openapiv3
  (package
    (inherit go-github-com-google-gnostic-models-openapiv2)
    (name "go-github-com-google-gnostic-models-openapiv3")
    (arguments
     (list
      #:go go-1.18
      #:import-path "github.com/google/gnostic-models/openapiv3"
      #:unpack-path "github.com/google/gnostic-models"))))

(define-public go-github-com-munnerz-goautoneg
  (package
    (name "go-github-com-munnerz-goautoneg")
    (version "0.0.0-20191010083416-a7dc8b61c822")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/munnerz/goautoneg")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m4v6bw6yf1g0kvpc46isjp0qfhx2y8gnvlnyjf637jy64613mgg"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/munnerz/goautoneg"))
    (home-page "https://github.com/munnerz/goautoneg")
    (synopsis #f)
    (description #f)
    (license license:bsd-3)))

(define-public go-github-com-chromedp-sysutil
  (package
    (name "go-github-com-chromedp-sysutil")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chromedp/sysutil")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vczhxgnvfkw1h12rbyyllcgwa1rmhn5x4iq20sm7dld26rglh5b"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/chromedp/sysutil"))
    (home-page "https://github.com/chromedp/sysutil")
    (synopsis "About sysutil")
    (description
     "Package sysutil provides some utilities for working with cross platform systems.")
    (license license:expat)))

(define-public go-github-com-chromedp-cdproto
  (package
    (name "go-github-com-chromedp-cdproto")
    (version "0.0.0-20240214232516-ad4608604e9e")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chromedp/cdproto")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "169jdssnmz9krgd55jqw28lx783vmkw4207g41chl2jrwanxqk3m"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.19
      #:import-path "github.com/chromedp/cdproto"))
    (propagated-inputs `(("go-github-com-mailru-easyjson" ,go-github-com-mailru-easyjson)
                         ("go-github-com-chromedp-sysutil" ,go-github-com-chromedp-sysutil)))
    (home-page "https://github.com/chromedp/cdproto")
    (synopsis "About cdproto")
    (description
     "Package cdproto provides the Chrome @code{DevTools} Protocol commands, types,
and events for the cdproto domain.")
    (license license:expat)))

(define-public go-github-com-gobwas-httphead
  (package
    (name "go-github-com-gobwas-httphead")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gobwas/httphead")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "106l8ml5yihld3rrf45q5fhlsx64hrpj2dsvnnm62av4ya5nf0gb"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gobwas/httphead"))
    (home-page "https://github.com/gobwas/httphead")
    (synopsis "httphead.")
    (description
     "Package httphead contains utils for parsing HTTP and HTTP-grammar compatible
text protocols headers.")
    (license license:expat)))

(define-public go-github-com-gobwas-pool
  (package
    (name "go-github-com-gobwas-pool")
    (version "0.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gobwas/pool")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0imipsf8nslc78in78wcri2ir2zzajp2h543dp2cshrrdbwkybx7"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gobwas/pool"))
    (home-page "https://github.com/gobwas/pool")
    (synopsis "pool")
    (description
     "Package pool contains helpers for pooling structures distinguishable by size.")
    (license license:expat)))

(define-public go-github-com-gobwas-ws
  (package
    (name "go-github-com-gobwas-ws")
    (version "1.3.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gobwas/ws")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1fdx14lqzjin18n604b9mmr1dq7s19yz13zk7vrbvj7inwcjqzy6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gobwas/ws"))
    (propagated-inputs `(("go-github-com-gobwas-pool" ,go-github-com-gobwas-pool)
                         ("go-github-com-gobwas-httphead" ,go-github-com-gobwas-httphead)))
    (home-page "https://github.com/gobwas/ws")
    (synopsis "ws")
    (description
     "Package ws implements a client and server for the @code{WebSocket} protocol as
specified in @@url{https://rfc-editor.org/rfc/rfc6455.html,RFC 6455}.")
    (license license:expat)))

(define-public go-github-com-ledongthuc-pdf
  (package
    (name "go-github-com-ledongthuc-pdf")
    (version "0.0.0-20240201131950-da5b75280b06")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ledongthuc/pdf")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0c1b2sxvxwpvv9b5xawr8i2dl2d6xlcdi7bdjjg0nbvxgh74269f"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/ledongthuc/pdf"))
    (home-page "https://github.com/ledongthuc/pdf")
    (synopsis "PDF Reader")
    (description "Package pdf implements reading of PDF files.")
    (license license:bsd-3)))

(define-public go-github-com-josharian-intern
  (package
    (name "go-github-com-josharian-intern")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/josharian/intern")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1za48ppvwd5vg8vv25ldmwz1biwpb3p6qhf8vazhsfdg9m07951c"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/josharian/intern"))
    (home-page "https://github.com/josharian/intern")
    (synopsis #f)
    (description
     "Package intern interns strings.  Interning is best effort only.  Interned
strings may be removed automatically at any time without notification.  All
functions may be called concurrently with themselves and each other.")
    (license license:expat)))

(define-public go-github-com-mailru-easyjson
  (package
    (name "go-github-com-mailru-easyjson")
    (version "0.7.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mailru/easyjson")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0clifkvvy8f45rv3cdyv58dglzagyvfcqb63wl6rij30c5j2pzc1"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/mailru/easyjson"))
    (propagated-inputs `(("go-github-com-josharian-intern" ,go-github-com-josharian-intern)))
    (home-page "https://github.com/mailru/easyjson")
    (synopsis "easyjson")
    (description
     "Package easyjson contains marshaler/unmarshaler interfaces and helper functions.")
    (license license:expat)))

(define-public go-github-com-orisano-pixelmatch
  (package
    (name "go-github-com-orisano-pixelmatch")
    (version "0.0.0-20230914042517-fa304d1dc785")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/orisano/pixelmatch")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1lplxfif5mfqnd0jjph2vd25c3bpr3idfs2axh8z0ib0zdkwca32"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/orisano/pixelmatch"))
    (home-page "https://github.com/orisano/pixelmatch")
    (synopsis "pixelmatch")
    (description
     "@@url{https://github.com/mapbox/pixelmatch,mapbox/pixelmatch} ports for go.")
    (license license:expat)))

(define-public go-github-com-chromedp-chromedp
  (package
    (name "go-github-com-chromedp-chromedp")
    (version "0.9.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chromedp/chromedp")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ballxw8l0cy2z467nshfflwyf7lhy7ng2q9w6k7kgnrrg8mb351"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/chromedp/chromedp"))
    (propagated-inputs `(("go-github-com-orisano-pixelmatch" ,go-github-com-orisano-pixelmatch)
                         ("go-github-com-mailru-easyjson" ,go-github-com-mailru-easyjson)
                         ("go-github-com-ledongthuc-pdf" ,go-github-com-ledongthuc-pdf)
                         ("go-github-com-gobwas-ws" ,go-github-com-gobwas-ws)
                         ("go-github-com-chromedp-cdproto" ,go-github-com-chromedp-cdproto)))
    (home-page "https://github.com/chromedp/chromedp")
    (synopsis "About chromedp")
    (description
     "Package chromedp is a high level Chrome @code{DevTools} Protocol client that
simplifies driving browsers for scraping, unit testing, or profiling web pages
using the CDP.")
    (license license:expat)))

(define-public go-github-com-chzyer-test
  (package
    (name "go-github-com-chzyer-test")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chzyer/test")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1axdlcnx2qjsn5wsr2pr1m0w0a8k4nk5kkrngh742fgh81vzzy8s"))))
    (build-system go-build-system)
    (arguments
     (list
      ;; NOTE: Upstream should be fixed.
      ;;  See also https://github.com/chzyer/test/issues/4
      #:tests? #f
      #:import-path "github.com/chzyer/test"))
    (propagated-inputs `(("go-github-com-chzyer-logex" ,go-github-com-chzyer-logex)))
    (home-page "https://github.com/chzyer/test")
    (synopsis "test")
    (description #f)
    (license license:expat)))

(define-public go-github-com-chzyer-logex
  (package
    (name "go-github-com-chzyer-logex")
    (version "1.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chzyer/logex")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0c9yr3r7dl3lcs22cvmh9iknihi9568wzmdywmc2irkjdrn8bpxw"))))
    (build-system go-build-system)
    (arguments
     (list
      ;; NOTE: Upstream should be fixed
      #:tests? #f
      #:import-path "github.com/chzyer/logex"))
    (home-page "https://github.com/chzyer/logex")
    (synopsis "Logex")
    (description
     "An golang log lib, supports tracing and level, wrap by standard log lib")
    (license license:expat)))

(define-public go-github-com-chzyer-readline
  (package
    (name "go-github-com-chzyer-readline")
    (version "1.5.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chzyer/readline")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1msh9qcm7l1idpmfj4nradyprsr86yhk9ch42yxz7xsrybmrs0pb"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/chzyer/readline"))
    (propagated-inputs `(("go-github-com-chzyer-logex" ,go-github-com-chzyer-logex)
                         ("go-golang-org-x-sys" ,go-golang-org-x-sys)
                         ("go-github-com-chzyer-test" ,go-github-com-chzyer-test)))
    (home-page "https://github.com/chzyer/readline")
    (synopsis "Guide")
    (description
     "Readline is a pure go implementation for GNU-Readline kind library.")
    (license license:expat)))

(define-public go-github-com-ianlancetaylor-demangle
  (package
    (name "go-github-com-ianlancetaylor-demangle")
    (version "0.0.0-20240205174729-1f824a1a9b87")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ianlancetaylor/demangle")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wwcr8l95ncga792l9h7qnkydds4q19mrfswsfd47wwnd6g06309"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/ianlancetaylor/demangle"))
    (home-page "https://github.com/ianlancetaylor/demangle")
    (synopsis "github.com/ianlancetaylor/demangle")
    (description
     "Package demangle defines functions that demangle GCC/LLVM C++ and Rust symbol
names.  This package recognizes names that were mangled according to the C++ ABI
defined at
@@url{http://codesourcery.com/cxx-abi/,http://codesourcery.com/cxx-abi/} and the
Rust ABI defined at
@@url{https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.html,https://rust-lang.github.io/rfcs/2603-rust-symbol-name-mangling-v0.html}")
    (license license:bsd-3)))

(define-public go-github-com-google-pprof
  (package
    (name "go-github-com-google-pprof")
    (version "0.0.0-20240207164012-fb44976bdcd5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/pprof")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bc89ff9ild3zcbnkkjx8f9qia22iprllrhs8pg1fw79yalrfiww"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.19
      #:import-path "github.com/google/pprof"))
    (propagated-inputs `(("go-github-com-ianlancetaylor-demangle" ,go-github-com-ianlancetaylor-demangle)
                         ("go-github-com-chzyer-readline" ,go-github-com-chzyer-readline)
                         ("go-github-com-chromedp-chromedp" ,go-github-com-chromedp-chromedp)))
    (home-page "https://github.com/google/pprof")
    (synopsis "Introduction")
    (description
     "pprof is a tool for collection, manipulation and visualization of performance
profiles.")
    (license license:asl2.0)))

(define-public go-github-com-onsi-ginkgo-v2
  (package
    (name "go-github-com-onsi-ginkgo-v2")
    (version "2.15.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/onsi/ginkgo")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1f7c740ixc65gyqmhmfg0p55ffaywjj4cyzpp6dgji2fcpmjfp6h"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.20
      #:import-path "github.com/onsi/ginkgo/v2"))
    (propagated-inputs `(("go-golang-org-x-tools" ,go-golang-org-x-tools)
                         ("go-golang-org-x-sys" ,go-golang-org-x-sys)
                         ("go-golang-org-x-net" ,go-golang-org-x-net)
                         ("go-github-com-onsi-gomega" ,go-github-com-onsi-gomega)
                         ("go-github-com-google-pprof" ,go-github-com-google-pprof)
                         ("go-github-com-go-task-slim-sprig" ,go-github-com-go-task-slim-sprig)
                         ("go-github-com-go-logr-logr" ,go-github-com-go-logr-logr)))
    (home-page "https://github.com/onsi/ginkgo")
    (synopsis "Ginkgo")
    (description
     "Ginkgo is a testing framework for Go designed to help you write expressive
tests. @@url{https://github.com/onsi/ginkgo,https://github.com/onsi/ginkgo}
MIT-Licensed")
    (license license:expat)))

(define-public go-k8s-io-gengo
  (package
    (name "go-k8s-io-gengo")
    (version "0.0.0-20240129211411-f967bbeff4b4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/gengo")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wsmrf08m0f7fsqi9cjg6ai210ij1g1f0n5ghqi0kafdiclxc6r6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "k8s.io/gengo"))
    (propagated-inputs `(("go-golang-org-x-tools" ,go-golang-org-x-tools)
                         ("go-sigs-k8s-io-yaml" ,go-sigs-k8s-io-yaml)
                         ("go-k8s-io-klog-v2" ,go-k8s-io-klog-v2)
                         ("go-github-com-spf13-pflag" ,go-github-com-spf13-pflag)
                         ("go-github-com-google-gofuzz" ,go-github-com-google-gofuzz)
                         ("go-github-com-google-go-cmp-cmp" ,go-github-com-google-go-cmp-cmp)
                         ("go-github-com-davecgh-go-spew" ,go-github-com-davecgh-go-spew)))
    (home-page "https://k8s.io/gengo")
    (synopsis "gengo")
    (description
     "This package provides a package for generating things based on go files.  This
mechanism was first used in
@@url{https://github.com/kubernetes/kubernetes/tree/master/staging/src/k8s.io/code-generator,Kubernetes
code-generator} and is split out here for ease of reuse and maintainability.")
    (license license:asl2.0)))

(define-public go-k8s-io-kube-openapi
  (package
    (name "go-k8s-io-kube-openapi")
    (version "0.0.0-20240209001042-7a0d5b415232")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/kube-openapi")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0wb30jmz0y91z596zqli4lkfvwm349fv6rzpxr0n291b6zha7w7a"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.21
      #:import-path "k8s.io/kube-openapi"))
    (propagated-inputs `(("go-sigs-k8s-io-yaml" ,go-sigs-k8s-io-yaml)
                         ("go-sigs-k8s-io-structured-merge-diff-v4" ,go-sigs-k8s-io-structured-merge-diff-v4)
                         ("go-sigs-k8s-io-json" ,go-sigs-k8s-io-json)
                         ("go-k8s-io-utils" ,go-k8s-io-utils)
                         ("go-k8s-io-klog-v2" ,go-k8s-io-klog-v2)
                         ("go-k8s-io-gengo" ,go-k8s-io-gengo)
                         ("go-gopkg-in-yaml-v3" ,go-gopkg-in-yaml-v3)
                         ("go-gopkg-in-yaml-v2" ,go-gopkg-in-yaml-v2)
                         ("go-google-golang-org-protobuf" ,go-google-golang-org-protobuf)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-spf13-pflag" ,go-github-com-spf13-pflag)
                         ("go-github-com-onsi-gomega" ,go-github-com-onsi-gomega)
                         ("go-github-com-onsi-ginkgo-v2" ,go-github-com-onsi-ginkgo-v2)
                         ("go-github-com-munnerz-goautoneg" ,go-github-com-munnerz-goautoneg)
                         ("go-github-com-google-uuid" ,go-github-com-google-uuid)
                         ("go-github-com-google-gofuzz" ,go-github-com-google-gofuzz)
                         ("go-github-com-google-go-cmp-cmp" ,go-github-com-google-go-cmp-cmp)
                         ("go-github-com-google-gnostic-models-openapiv2" ,go-github-com-google-gnostic-models-openapiv2)
                         ("go-github-com-google-gnostic-models-openapiv3" ,go-github-com-google-gnostic-models-openapiv3)
                         ("go-github-com-golang-protobuf-proto" ,go-github-com-golang-protobuf-proto)
                         ("go-github-com-go-openapi-swag" ,go-github-com-go-openapi-swag)
                         ("go-github-com-go-openapi-jsonreference" ,go-github-com-go-openapi-jsonreference)
                         ("go-github-com-emicklei-go-restful-v3" ,go-github-com-emicklei-go-restful-v3)
                         ("go-github-com-asaskevich-govalidator" ,go-github-com-asaskevich-govalidator)
                         ("go-github-com-nytimes-gziphandler" ,go-github-com-nytimes-gziphandler)))
    (home-page "https://k8s.io/kube-openapi")
    (synopsis "Kube OpenAPI")
    (description
     "This repo is the home for Kubernetes @code{OpenAPI} discovery spec generation.
The goal is to support a subset of @code{OpenAPI} features to satisfy kubernetes
use-cases but implement that subset with little to no assumption about the
structure of the code or routes.  Thus, there should be no kubernetes specific
code in this repo.")
    (license license:asl2.0)))

(define-public go-github-com-go-logr-logr
  (package
    (name "go-github-com-go-logr-logr")
    (version "1.4.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-logr/logr")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0x0q9jkk2p5pz4lii1qs8ifnsib4ib5s8pigmjwdmagl976g8nhm"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.18
      #:import-path "github.com/go-logr/logr"))
    (home-page "https://github.com/go-logr/logr")
    (synopsis "A minimal logging API for Go")
    (description
     "Package logr defines a general-purpose logging API and abstract interfaces to
back that API. Packages in the Go ecosystem can depend on this package, while
callers can implement logging with whatever backend is appropriate.")
    (license license:asl2.0)))

(define-public go-k8s-io-klog-v2
  (package
    (name "go-k8s-io-klog-v2")
    (version "2.120.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/klog")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0gqr1adz7s484z5jqvzmk99qz2zg46aa9drl9v8pdpn4aswv7p7h"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.18
      #:import-path "k8s.io/klog/v2"
      #:unpack-path "k8s.io/klog/v2"))
    (propagated-inputs `(("go-github-com-go-logr-logr" ,go-github-com-go-logr-logr)))
    (home-page "https://k8s.io/klog/v2")
    (synopsis "klog")
    (description "Package klog contains the following functionality:")
    (license license:asl2.0)))

(define-public go-k8s-io-utils
  (package
    (name "go-k8s-io-utils")
    (version "0.0.0-20240102154912-e7106e64919e")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/utils")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1xzjiammsh2k649dwpd7ls4c6p9fzbhphsd4nfbxlvm5ys47n038"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.18
      #:import-path "k8s.io/utils"))
    (propagated-inputs `(("go-k8s-io-klog-v2" ,go-k8s-io-klog-v2)
                         ("go-github-com-davecgh-go-spew" ,go-github-com-davecgh-go-spew)))
    (home-page "https://k8s.io/utils")
    (synopsis "Utils")
    (description
     "This package provides a set of Go libraries that provide low-level,
kubernetes-independent packages supplementing the
@@url{https://pkg.go.dev/std#stdlib,Go standard libs}.")
    (license license:asl2.0)))

(define-public go-sigs-k8s-io-json
  (package
    (name "go-sigs-k8s-io-json")
    (version "0.0.0-20221116044647-bc3834ca7abd")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes-sigs/json")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1iaya66dcaqffz168avjhdp0m3fd10lz73qw7k04p5777is735ll"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.18
      #:import-path "sigs.k8s.io/json"))
    (home-page "https://sigs.k8s.io/json")
    (synopsis "sigs.k8s.io/json")
    (description
     "This library is a subproject of
@@url{https://github.com/kubernetes/community/tree/master/sig-api-machinery#json,sig-api-machinery}.
 It provides case-sensitive, integer-preserving JSON unmarshaling functions
based on @@code{encoding/json} @@code{Unmarshal()}.")
    (license (list license:bsd-3
                   license:asl2.0))))

(define-public go-github-com-modern-go-concurrent
  (package
    (name "go-github-com-modern-go-concurrent")
    (version "0.0.0-20180306012644-bacd9c7ef1dd")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/modern-go/concurrent")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0s0fxccsyb8icjmiym5k7prcqx36hvgdwl588y0491gi18k5i4zs"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/modern-go/concurrent"))
    (home-page "https://github.com/modern-go/concurrent")
    (synopsis "concurrent")
    (description
     "because sync.Map is only available in go 1.9, we can use concurrent.Map to make
code portable")
    (license license:asl2.0)))

(define-public go-github-com-modern-go-reflect2
  (package
    (name "go-github-com-modern-go-reflect2")
    (version "1.0.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/modern-go/reflect2")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "05a89f9j4nj8v1bchfkv2sy8piz746ikj831ilbp54g8dqhl8vzr"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/modern-go/reflect2"))
    (home-page "https://github.com/modern-go/reflect2")
    (synopsis "reflect2")
    (description "reflect api that avoids runtime reflect.Value cost")
    (license license:asl2.0)))

(define-public go-github-com-json-iterator-go
  (package
    (name "go-github-com-json-iterator-go")
    (version "1.1.12")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/json-iterator/go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1c8f0hxm18wivx31bs615x3vxs2j3ba0v6vxchsjhldc8kl311bz"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/json-iterator/go"))
    (propagated-inputs `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-modern-go-reflect2" ,go-github-com-modern-go-reflect2)
                         ("go-github-com-modern-go-concurrent" ,go-github-com-modern-go-concurrent)
                         ("go-github-com-google-gofuzz" ,go-github-com-google-gofuzz)
                         ("go-github-com-davecgh-go-spew" ,go-github-com-davecgh-go-spew)))
    (home-page "https://github.com/json-iterator/go")
    (synopsis "Benchmark")
    (description
     "Package jsoniter implements encoding and decoding of JSON as defined in
@@url{https://rfc-editor.org/rfc/rfc4627.html,RFC 4627} and provides interfaces
with identical syntax of standard lib encoding/json.  Converting from
encoding/json to jsoniter is no more than replacing the package with jsoniter
and variable type declarations (if any).  jsoniter interfaces gives 100%
compatibility with code using standard lib.")
    (license license:expat)))

(define-public go-sigs-k8s-io-structured-merge-diff-v4
  (package
    (name "go-sigs-k8s-io-structured-merge-diff-v4")
    (version "4.4.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes-sigs/structured-merge-diff")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1kzig3im1abjlkwp6cdldn4kmnpgv7ha7gm81ks2fsl6n55zb88v"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "sigs.k8s.io/structured-merge-diff/v4"
      #:unpack-path "sigs.k8s.io/structured-merge-diff/v4"))
    (propagated-inputs `(("go-github-com-json-iterator-go" ,go-github-com-json-iterator-go)
                         ("go-github-com-google-gofuzz" ,go-github-com-google-gofuzz)
                         ("go-gopkg-in-yaml-v2" ,go-gopkg-in-yaml-v2)))
    (home-page "https://sigs.k8s.io/structured-merge-diff/v4")
    (synopsis "Structured Merge and Diff")
    (description
     "This repo contains code which implements the Kubernetes \"apply\" operation.")
    (license license:asl2.0)))

(define-public go-k8s-io-apimachinery
  (package
    (name "go-k8s-io-apimachinery")
    (version "0.29.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/apimachinery")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "15sibzb4j1zglsfs3yb8y9j1m4xm9va6xilbin2qrspn5ni30kad"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.21
      #:import-path "k8s.io/apimachinery"))
    (propagated-inputs `(("go-sigs-k8s-io-yaml" ,go-sigs-k8s-io-yaml)
                         ("go-sigs-k8s-io-structured-merge-diff-v4" ,go-sigs-k8s-io-structured-merge-diff-v4)
                         ("go-sigs-k8s-io-json" ,go-sigs-k8s-io-json)
                         ("go-k8s-io-utils" ,go-k8s-io-utils)
                         ("go-k8s-io-kube-openapi" ,go-k8s-io-kube-openapi)
                         ("go-k8s-io-klog-v2" ,go-k8s-io-klog-v2)
                         ("go-gopkg-in-inf-v0" ,go-gopkg-in-inf-v0)
                         ("go-golang-org-x-time" ,go-golang-org-x-time)
                         ("go-golang-org-x-net" ,go-golang-org-x-net)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-spf13-pflag" ,go-github-com-spf13-pflag)
                         ("go-github-com-onsi-ginkgo-v2" ,go-github-com-onsi-ginkgo-v2)
                         ("go-github-com-mxk-go-flowrate" ,go-github-com-mxk-go-flowrate)
                         ("go-github-com-moby-spdystream" ,go-github-com-moby-spdystream)
                         ("go-github-com-google-uuid" ,go-github-com-google-uuid)
                         ("go-github-com-google-gofuzz" ,go-github-com-google-gofuzz)
                         ("go-github-com-google-go-cmp-cmp" ,go-github-com-google-go-cmp-cmp)
                         ("go-github-com-google-gnostic-models-openapiv2" ,go-github-com-google-gnostic-models-openapiv2)
                         ("go-github-com-google-gnostic-models-openapiv3" ,go-github-com-google-gnostic-models-openapiv3)
                         ("go-github-com-golang-protobuf-proto" ,go-github-com-golang-protobuf-proto)
                         ("go-github-com-gogo-protobuf" ,go-github-com-gogo-protobuf)
                         ("go-github-com-evanphx-json-patch" ,go-github-com-evanphx-json-patch)
                         ("go-github-com-davecgh-go-spew" ,go-github-com-davecgh-go-spew)
                         ("go-github-com-armon-go-socks5" ,go-github-com-armon-go-socks5)))
    (home-page "https://k8s.io/apimachinery")
    (synopsis "apimachinery")
    (description
     "Scheme, typing, encoding, decoding, and conversion packages for Kubernetes and
Kubernetes-like API objects.")
    (license license:asl2.0)))

(define-public go-k8s-io-client-go
  (package
    (name "go-k8s-io-client-go")
    (version "0.29.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/client-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0i0k888896zc5f5nbfvhx0v5xzcfq6x4zg5pszhj7ar9b72gh77k"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.21
      #:import-path "k8s.io/client-go"))
    (propagated-inputs `(("go-k8s-io-apimachinery" ,go-k8s-io-apimachinery)
                         ("go-k8s-io-api" ,go-k8s-io-api)
                         ("go-sigs-k8s-io-yaml" ,go-sigs-k8s-io-yaml)
                         ("go-sigs-k8s-io-structured-merge-diff-v4" ,go-sigs-k8s-io-structured-merge-diff-v4)
                         ("go-sigs-k8s-io-json" ,go-sigs-k8s-io-json)
                         ("go-k8s-io-utils" ,go-k8s-io-utils)
                         ("go-k8s-io-kube-openapi" ,go-k8s-io-kube-openapi)
                         ("go-k8s-io-klog-v2" ,go-k8s-io-klog-v2)
                         ("go-google-golang-org-protobuf" ,go-google-golang-org-protobuf)
                         ("go-golang-org-x-time" ,go-golang-org-x-time)
                         ("go-golang-org-x-term" ,go-golang-org-x-term)
                         ("go-golang-org-x-oauth2" ,go-golang-org-x-oauth2)
                         ("go-golang-org-x-net" ,go-golang-org-x-net)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-spf13-pflag" ,go-github-com-spf13-pflag)
                         ("go-github-com-peterbourgon-diskv" ,go-github-com-peterbourgon-diskv)
                         ("go-github-com-imdario-mergo" ,go-github-com-imdario-mergo)
                         ("go-github-com-gregjones-httpcache" ,go-github-com-gregjones-httpcache)
                         ("go-github-com-gorilla-websocket" ,go-github-com-gorilla-websocket)
                         ("go-github-com-google-uuid" ,go-github-com-google-uuid)
                         ("go-github-com-google-gofuzz" ,go-github-com-google-gofuzz)
                         ("go-github-com-google-go-cmp-cmp" ,go-github-com-google-go-cmp-cmp)
                         ("go-github-com-google-gnostic-models-openapiv2" ,go-github-com-google-gnostic-models-openapiv2)
                         ("go-github-com-google-gnostic-models-openapiv3" ,go-github-com-google-gnostic-models-openapiv3)
                         ("go-github-com-golang-protobuf-proto" ,go-github-com-golang-protobuf-proto)
                         ("go-github-com-golang-groupcache" ,go-github-com-golang-groupcache)
                         ("go-github-com-gogo-protobuf" ,go-github-com-gogo-protobuf)
                         ("go-github-com-evanphx-json-patch" ,go-github-com-evanphx-json-patch)))
    (home-page "https://k8s.io/client-go")
    (synopsis "client-go")
    (description
     "Go clients for talking to a @@url{http://kubernetes.io/,kubernetes} cluster.")
    (license license:asl2.0)))

(define-public go-github-com-yuin-goldmark-emoji-1.0.2
  (package
    (name "go-github-com-yuin-goldmark-emoji")
    (version "1.0.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/yuin/goldmark-emoji")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1plswhgqdw54wz6vm1qinzhm3jr4ppvldzr0yppcgxs5g4sy3z26"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/yuin/goldmark-emoji"))
    (propagated-inputs `(("go-github-com-yuin-goldmark" ,go-github-com-yuin-goldmark)))
    (home-page "https://github.com/yuin/goldmark-emoji")
    (synopsis "goldmark-emoji")
    (description
     "package emoji is a extension for the
goldmark(@@url{http://github.com/yuin/goldmark,http://github.com/yuin/goldmark}).")
    (license license:expat)))

(define-public go-github-com-alecthomas-chroma-0.10.0
  (package
    (name "go-github-com-alecthomas-chroma")
    (version "0.10.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/alecthomas/chroma")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0hjzb61m5lzx95xss82wil9s8f9hbw1zb3jj73ljfwkq5lqk76zq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/alecthomas/chroma"))
    (propagated-inputs `(("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-dlclark-regexp2" ,go-github-com-dlclark-regexp2)))
    (home-page "https://github.com/alecthomas/chroma")
    (synopsis "Chroma — A general purpose syntax highlighter in pure Go")
    (description
     "Package chroma takes source code and other structured text and converts it into
syntax highlighted HTML, ANSI- coloured text, etc.")
    (license license:expat)))

(define-public go-github-com-charmbracelet-glamour-0.6.0
  (package
    (name "go-github-com-charmbracelet-glamour")
    (version "0.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/charmbracelet/glamour")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07yww6b74ymp5il6dxns2ibl2im7534l44dg8aqmlsddjysv4zx2"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/charmbracelet/glamour"))
    (propagated-inputs
     (list go-github-com-yuin-goldmark-emoji-1.0.2
           go-github-com-yuin-goldmark
           go-github-com-olekukonko-tablewriter
           go-github-com-muesli-termenv

           go-github-com-muesli-reflow-wordwrap
           go-github-com-muesli-reflow-ansi
           go-github-com-muesli-reflow-indent
           go-github-com-muesli-reflow-padding
           go-github-com-muesli-reflow-truncate

           go-github-com-microcosm-cc-bluemonday
           go-github-com-alecthomas-chroma-0.10.0))
    (home-page "https://github.com/charmbracelet/glamour")
    (synopsis "Glamour")
    (description "Stylesheet-based markdown rendering for your CLI apps.")
    (license license:expat)))

(define-public go-gitlab-com-gitlab-org-cli
  (package
    (name "go-gitlab-com-gitlab-org-cli")
    (version "1.36.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/gitlab-org/cli.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ib0hpwgxkbhyh5dbql8j0njphxlxrisz74l6p5l5an33pwnybh5"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.19
      #:import-path "gitlab.com/gitlab-org/cli"))
    (propagated-inputs `(("go-k8s-io-client-go" ,go-k8s-io-client-go)
                         ("go-k8s-io-apimachinery" ,go-k8s-io-apimachinery)
                         ("go-gopkg-in-yaml-v3" ,go-gopkg-in-yaml-v3)
                         ("go-golang-org-x-text" ,go-golang-org-x-text)
                         ("go-golang-org-x-term" ,go-golang-org-x-term)
                         ("go-golang-org-x-sync" ,go-golang-org-x-sync)
                         ("go-github-com-zalando-go-keyring" ,go-github-com-zalando-go-keyring)
                         ("go-github-com-xanzy-go-gitlab" ,go-github-com-xanzy-go-gitlab)
                         ("go-github-com-tidwall-pretty" ,go-github-com-tidwall-pretty)
                         ("go-github-com-stretchr-testify" ,go-github-com-stretchr-testify)
                         ("go-github-com-spf13-viper" ,go-github-com-spf13-viper)
                         ("go-github-com-spf13-pflag" ,go-github-com-spf13-pflag)
                         ("go-github-com-spf13-cobra" ,go-github-com-spf13-cobra)
                         ("go-github-com-spf13-cast" ,go-github-com-spf13-cast)
                         ("go-github-com-rivo-tview" ,go-github-com-rivo-tview)
                         ("go-github-com-pkg-errors" ,go-github-com-pkg-errors)
                         ("go-github-com-otiai10-copy" ,go-github-com-otiai10-copy)
                         ("go-github-com-muesli-termenv" ,go-github-com-muesli-termenv)
                         ("go-github-com-mitchellh-go-homedir" ,go-github-com-mitchellh-go-homedir)
                         ("go-github-com-mgutz-ansi" ,go-github-com-mgutz-ansi)
                         ("go-github-com-mattn-go-runewidth" ,go-github-com-mattn-go-runewidth)
                         ("go-github-com-mattn-go-isatty" ,go-github-com-mattn-go-isatty)
                         ("go-github-com-mattn-go-colorable" ,go-github-com-mattn-go-colorable)
                         ("go-github-com-lunixbochs-vtclean" ,go-github-com-lunixbochs-vtclean)
                         ("go-github-com-kballard-go-shellquote" ,go-github-com-kballard-go-shellquote)
                         ("go-github-com-hashicorp-go-version" ,go-github-com-hashicorp-go-version)
                         ("go-github-com-hashicorp-go-retryablehttp" ,go-github-com-hashicorp-go-retryablehttp)
                         ("go-github-com-hashicorp-go-multierror" ,go-github-com-hashicorp-go-multierror)
                         ("go-github-com-gosuri-uilive" ,go-github-com-gosuri-uilive)
                         ("go-github-com-google-shlex" ,go-github-com-google-shlex)
                         ("go-github-com-google-renameio" ,go-github-com-google-renameio)
                         ("go-github-com-gdamore-tcell-v2" ,go-github-com-gdamore-tcell-v2)
                         ("go-github-com-dustin-go-humanize" ,go-github-com-dustin-go-humanize)
                         ("go-github-com-charmbracelet-glamour-0.6.0" ,go-github-com-charmbracelet-glamour-0.6.0)
                         ("go-github-com-briandowns-spinner" ,go-github-com-briandowns-spinner)
                         ("go-github-com-avast-retry-go" ,go-github-com-avast-retry-go)
                         ("go-github-com-acarl005-stripansi" ,go-github-com-acarl005-stripansi)
                         ("go-github-com-makenowjust-heredoc" ,go-github-com-makenowjust-heredoc)
                         ("go-github-com-alecaivazis-survey-v2" ,go-github-com-alecaivazis-survey-v2)))
    (home-page "https://gitlab.com/gitlab-org/cli")
    (synopsis "GLab")
    (description
     "GLab is an open source @code{GitLab} CLI tool bringing @code{GitLab} to your
terminal next to where you are already working with @@code{git} and your code
without switching between windows and browser tabs.  Work with issues, merge
requests, @@strong{watch running pipelines directly from your CLI} among other
features.")
    (license license:expat)))

(define-public glab
  (package
   (name "glab")
   (version "1.35.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://gitlab.com/gitlab-org/cli/-/releases/v"
                                version "/downloads/glab_" version "_Linux_x86_64.tar.gz"))
            (sha256
             (base32
              "19n0wg5qjg6ixsk3ysjkx2dl432riijyaazs8vwyjngbx3813fn9"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("glab" "/bin/"))))
   (home-page "https://gitlab.com/gitlab-org/cli")
   (synopsis "A GitLab CLI tool bringing GitLab to your command line")
   (description
    "GLab is an open source GitLab CLI tool bringing GitLab to your terminal
next to where you are already working with @code{git} and your code without switching
between windows and browser tabs. Work with issues, merge requests, watch
running pipelines directly from your CLI among other features.")
   (license license:expat)))
