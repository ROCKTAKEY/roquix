(define-module
  (roquix packages tailscale)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix utils)
  #:use-module (guix build-system go)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages containers)
  #:use-module (gnu packages docker)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages golang-apps)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-compression)
  #:use-module (gnu packages golang-crypto)
  #:use-module (gnu packages golang-maths)
  #:use-module (gnu packages golang-vcs)
  #:use-module (gnu packages golang-web)
  #:use-module (gnu packages prometheus)
  #:use-module (gnu packages serialization))

(define azure-sdk-embed-files
  #~(list "assets\\.json"
          "sample\\.env"
          "test-resources\\.(bicep|json)"
          ".*testdata/.*\\.(json|xml|txt)"
          "tsp-location\\.yaml"))

(define-public go-filippo-io-mkcert
  (package
    (name "go-filippo-io-mkcert")
    (version "1.4.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/FiloSottile/mkcert")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0ms9mjspiwlsgsnir0ccj3w8vhvrphf5i6k9q3hrz47y2a6igh0l"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "filippo.io/mkcert"))
    (propagated-inputs (list go-golang-org-x-net go-howett-net-plist
                             go-software-sslmate-com-src-go-pkcs12))
    (home-page "https://filippo.io/mkcert")
    (synopsis "mkcert")
    (description
     "Command mkcert is a simple zero-config tool to make development certificates.")
    (license license:bsd-3)))

(define-public go-fyne-io-systray
  (package
    (name "go-fyne-io-systray")
    (version "1.12.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fyne-io/systray")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1nc08dir8abkpqfml48rpqpvfblb6l5jm91aknhq45fylzg8yg6b"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "fyne.io/systray"))
    (propagated-inputs (list go-github-com-godbus-dbus-v5 go-golang-org-x-sys))
    (home-page "https://fyne.io/systray")
    (synopsis "Systray")
    (description
     "Package systray is a cross-platform Go library to place an icon and menu in the
notification area.")
    (license license:asl2.0)))

(define-public go-github-com-kodeworks-golang-image-ico
  (package
    (name "go-github-com-kodeworks-golang-image-ico")
    (version "0.0.0-20141118225523-73f0f4cfade9")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Kodeworks/golang-image-ico")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zfcvpf6pdqismq9j8nvismln1dbz2i22d7c00a2ygjxldbmnd3k"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/Kodeworks/golang-image-ico"))
    (home-page "https://github.com/Kodeworks/golang-image-ico")
    (synopsis "golang-image-ico")
    (description "golang support for windows .ico file format.")
    (license license:bsd-3)))

(define-public go-github-com-akutz-memconn
  (package
    (name "go-github-com-akutz-memconn")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/akutz/memconn")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1mhghzcx2zxr4bpyf4wx3j7ph9srw38wxg78svwbjh930r2kzssq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/akutz/memconn"))
    (home-page "https://github.com/akutz/memconn")
    (synopsis "MemConn")
    (description
     "@code{MemConn} provides named, in-memory network connections for Go.")
    (license license:asl2.0)))

(define-public go-github-com-alexbrainman-sspi
  (package
    (name "go-github-com-alexbrainman-sspi")
    (version "0.0.0-20250919150558-7d374ff0d59e")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/alexbrainman/sspi")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1nahd0l0h42gbn3i0xgy6pv8c9z8gqp7i7n722jq1sl90wa5jd65"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/alexbrainman/sspi"))
    (home-page "https://github.com/alexbrainman/sspi")
    (synopsis #f)
    (description
     "This repository holds Go packages for accessing Security Support Provider
Interface on Windows.")
    (license license:bsd-3)))

(define-public go-github-com-bradfitz-go-tool-cache
  (package
    (name "go-github-com-bradfitz-go-tool-cache")
    (version "0.0.0-20260218131923-8ef59dd13462")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bradfitz/go-tool-cache")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1lr1730wyhifw3mvrf5hh7b1sgrvwj8vrbqwzcz427jdi9pvyyfv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/bradfitz/go-tool-cache"))
    (propagated-inputs (list go-github-com-go-jose-go-jose-v4
                             go-github-com-golang-jwt-jwt-v5
                             go-github-com-google-go-cmp
                             go-github-com-pierrec-lz4-v4
                             go-github-com-prometheus-client-golang
                             go-github-com-prometheus-client-model
                             go-modernc-org-sqlite))
    (home-page "https://github.com/bradfitz/go-tool-cache")
    (synopsis "go-tool-cache")
    (description
     "Do you like Go's built-in build & test caching but wish it weren't purely stored
on local disk in the @@code{$GOCACHE} directory?")
    (license license:bsd-3)))

(define-public go-github-com-bramvdbogaerde-go-scp
  (package
    (name "go-github-com-bramvdbogaerde-go-scp")
    (version "1.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bramvdbogaerde/go-scp")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "16rf7fzrfhqadlzcxfqi3q7dv73hjmnr4fgad33psrjan1kq5w78"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/bramvdbogaerde/go-scp"))
    (propagated-inputs (list go-golang-org-x-crypto))
    (home-page "https://github.com/bramvdbogaerde/go-scp")
    (synopsis "Copy files over SCP with Go")
    (description "Package scp.  Simple scp package to copy files over SSH.")
    (license license:mpl2.0)))

(define-public go-github-com-creachadair-taskgroup
  (package
    (name "go-github-com-creachadair-taskgroup")
    (version "0.14.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/creachadair/taskgroup")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0cc9w5v1iw8gwqz9w6ydr4hlw5wf3r9d1xi75hz11zz8ry4qraj5"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/creachadair/taskgroup"))
    (home-page "https://github.com/creachadair/taskgroup")
    (synopsis "taskgroup")
    (description
     "Package taskgroup manages collections of cooperating goroutines.  It defines a
@@url{#Group,Group} that handles waiting for goroutine termination and the
propagation of error values.  The caller may provide a callback to filter and
respond to task errors.")
    (license license:bsd-3)))

(define-public go-github-com-dblohm7-wingoes
  (package
    (name "go-github-com-dblohm7-wingoes")
    (version "0.0.0-20250822163801-6d8e6105c62d")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/dblohm7/wingoes")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0pqcjd3wzxp92144x4cxayz7qycqq7b2fb8lfk6l7cfraj5k0yhv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/dblohm7/wingoes"))
    (propagated-inputs (list go-github-com-tc-hib-winres go-golang-org-x-exp
                             go-golang-org-x-sys go-golang-org-x-tools))
    (home-page "https://github.com/dblohm7/wingoes")
    (synopsis
     "wingoes, an opinionated library for writing Win32 programs in Go")
    (description #f)
    (license license:bsd-3)))

(define-public go-github-com-elastic-crd-ref-docs
  (package
    (name "go-github-com-elastic-crd-ref-docs")
    (version "0.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/elastic/crd-ref-docs")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vg3zjcgcq04cbqc8sk638q9v5r62w8r8x22yl7g9blbbr13sj7s"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
            #:import-path "github.com/elastic/crd-ref-docs"))
    (propagated-inputs (list go-github-com-goccy-go-yaml
                             go-github-com-masterminds-sprig-v3
                             go-github-com-spf13-cobra
                             go-github-com-stretchr-testify
                             go-go-uber-org-zap
                             go-golang-org-x-tools
                             go-k8s-io-apimachinery
                             go-sigs-k8s-io-controller-tools))
    (home-page "https://github.com/elastic/crd-ref-docs")
    (synopsis "CRD Reference Documentation Generator")
    (description
     "Licensed to Elasticsearch B.V. under one or more contributor license agreements.
 See the NOTICE file distributed with this work for additional information
regarding copyright ownership.  Elasticsearch B.V. licenses this file to you
under the Apache License, Version 2.0 (the \"License\"); you may not use this file
except in compliance with the License.  You may obtain a copy of the License at.")
    (license license:asl2.0)))

(define-public go-github-com-go-json-experiment-json
  (package
    (name "go-github-com-go-json-experiment-json")
    (version "0.0.0-20250813024750-ebf49471dced")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-json-experiment/json")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13iapgkvclmlxxq5zc8q7c22kmvcdwd7h2jx080p062ffrzmqdi1"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/go-json-experiment/json"))
    (home-page "https://github.com/go-json-experiment/json")
    (synopsis "JSON Serialization (v2)")
    (description
     "Package json implements semantic processing of JSON as specified in
@@url{https://rfc-editor.org/rfc/rfc8259.html,RFC 8259}.  JSON is a simple data
interchange format that can represent primitive data types such as booleans,
strings, and numbers, in addition to structured data types such as objects and
arrays.")
    (license license:bsd-3)))

(define-public go-github-com-blakesmith-ar
  (package
    (name "go-github-com-blakesmith-ar")
    (version "0.0.0-20190502131153-809d4375e1fb")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/blakesmith/ar")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00fxkc04b9cb53xxzw5gdqqpwlqv9n5kk0yn2lb5w4rgj5gm8ph1"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/blakesmith/ar"))
    (home-page "https://github.com/blakesmith/ar")
    (synopsis "Golang ar (archive) file reader")
    (description "Copyright (c) 2013 Blake Smith <blakesmith0@@gmail.com>.")
    (license license:expat)))

(define-public go-github-com-caarlos0-go-version
  (package
    (name "go-github-com-caarlos0-go-version")
    (version "0.2.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/caarlos0/go-version")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0kp78am3yzffz8r70f1skq0m2vms0wk37f76hqbfg1r29hay1ban"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/caarlos0/go-version"))
    (home-page "https://github.com/caarlos0/go-version")
    (synopsis "go-version")
    (description
     "Package goversion provides utilities to get the Go module version information.")
    (license license:expat)))

(define-public go-github-com-cavaliergopher-cpio
  (package
    (name "go-github-com-cavaliergopher-cpio")
    (version "1.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cavaliergopher/cpio")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0b1ix8z9kwfpwqi0q08ivcfcimlqk781jbzbfw7qbqavh702w3m2"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/cavaliergopher/cpio"))
    (home-page "https://github.com/cavaliergopher/cpio")
    (synopsis "cpio")
    (description
     "Package cpio providers readers and writers for CPIO archives.  Currently, only
the SVR4 (New ASCII) format is supported, both with and without checksums.")
    (license license:bsd-3)))

(define-public go-github-com-google-rpmpack
  (package
    (name "go-github-com-google-rpmpack")
    (version "0.7.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/rpmpack")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17h2s1g191cvbs16fnclkpb42d9mx6mdmhd04kxzv8bss7m59pr4"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/google/rpmpack"))
    (propagated-inputs (list go-github-com-cavaliergopher-cpio
                             go-github-com-google-go-cmp
                             go-github-com-klauspost-compress
                             go-github-com-klauspost-pgzip
                             go-github-com-ulikunitz-xz))
    (home-page "https://github.com/google/rpmpack")
    (synopsis "rpmpack (tar2rpm) - package rpms the easy way")
    (description
     "Package rpmpack packs files to rpm files.  It is designed to be simple to use
and deploy, not requiring any filesystem access to create rpm files.")
    (license license:asl2.0)))

(define-public go-gitlab-com-digitalxero-go-conventional-commit
  (package
    (name "go-gitlab-com-digitalxero-go-conventional-commit")
    (version "1.0.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/digitalxero/go-conventional-commit.git")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1191j3k9ma5sv8w2zsw8gb1407561zll0ca8hwy0dja6s0b3z0xy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "gitlab.com/digitalxero/go-conventional-commit"))
    (home-page "https://gitlab.com/digitalxero/go-conventional-commit")
    (synopsis "go-conventional-commit")
    (description
     "golang parser for conventional-commit messages
@@url{https://www.conventionalcommits.org/,https://www.conventionalcommits.org/}.")
    (license license:expat)))

(define-public go-github-com-goreleaser-chglog
  (package
    (name "go-github-com-goreleaser-chglog")
    (version "0.7.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/goreleaser/chglog")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "09ni4y644zhp3bf9nwy9qc9wkxrn2hla6nczg3zpn0ls8qaxjd40"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/goreleaser/chglog"))
    (propagated-inputs (list go-github-com-go-git-go-billy-v5
                             go-github-com-go-git-go-git-v5
                             go-github-com-google-go-cmp
                             go-github-com-masterminds-semver-v3
                             go-github-com-masterminds-sprig-v3
                             go-github-com-smartystreets-goconvey
                             go-github-com-spf13-cobra
                             go-github-com-spf13-viper
                             go-gitlab-com-digitalxero-go-conventional-commit
                             go-go-yaml-in-yaml-v3))
    (home-page "https://github.com/goreleaser/chglog")
    (synopsis "chglog")
    (description
     "Package chglog contains the public API for working with a changlog.yml file.")
    (license license:expat)))

(define-public go-github-com-muesli-mango
  (package
    (name "go-github-com-muesli-mango")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/muesli/mango")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "16d0sga6cbdxzlqkibcgw0civkw11fpkcjpgv21i0q5j9mjbsjw4"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/muesli/mango"))
    (propagated-inputs (list go-github-com-muesli-roff))
    (home-page "https://github.com/muesli/mango")
    (synopsis "mango")
    (description
     "mango is a man-page generator for the Go flag, pflag, cobra, coral, and kong
packages.  It extracts commands, flags, and arguments from your program and
enables it to self-document.")
    (license license:expat)))

(define-public go-github-com-muesli-mango-pflag
  (package
    (name "go-github-com-muesli-mango-pflag")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/muesli/mango-pflag")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1k4m88i9shs36a8n86k3a1vlxmdf5vwavkih2f2j3xj718hnhpw0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/muesli/mango-pflag"))
    (propagated-inputs (list go-github-com-muesli-mango
                             go-github-com-muesli-roff
                             go-github-com-spf13-pflag))
    (home-page "https://github.com/muesli/mango-pflag")
    (synopsis "mango-pflag")
    (description
     "pflag adapter for @@url{https://github.com/muesli/mango,mango}.")
    (license license:expat)))

(define-public go-github-com-muesli-mango-cobra
  (package
    (name "go-github-com-muesli-mango-cobra")
    (version "1.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/muesli/mango-cobra")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "11vvm3f2mq8yaqbfrjbzdcyvkn9f75rp4kygxyvqwc5jsw1kdwal"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/muesli/mango-cobra"))
    (propagated-inputs (list go-github-com-muesli-mango
                             go-github-com-muesli-mango-pflag
                             go-github-com-muesli-roff
                             go-github-com-spf13-cobra))
    (home-page "https://github.com/muesli/mango-cobra")
    (synopsis "mango-cobra")
    (description
     "cobra adapter for @@url{https://github.com/muesli/mango,mango}.")
    (license license:expat)))

(define-public go-github-com-muesli-roff
  (package
    (name "go-github-com-muesli-roff")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/muesli/roff")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0l263rqwq2ccr1lpamsvs48dddsr70xim8mv6rsj2x9y3prcq3yh"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/muesli/roff"))
    (home-page "https://github.com/muesli/roff")
    (synopsis "roff")
    (description "roff lets you write roff documents in Go.")
    (license license:expat)))

(define-public go-github-com-sassoftware-go-rpmutils
  (package
    (name "go-github-com-sassoftware-go-rpmutils")
    (version "0.4.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/sassoftware/go-rpmutils")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "06ymwjn6xvc4cpxcsh5achwgma4i075ikbzq8jm143m0pck4pmfi"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/sassoftware/go-rpmutils"))
    (propagated-inputs (list go-github-com-datadog-zstd
                             go-github-com-klauspost-compress
                             go-github-com-protonmail-go-crypto
                             go-github-com-stretchr-testify
                             go-github-com-ulikunitz-xz
                             go-github-com-xi2-xz
                             go-go-uber-org-goleak
                             go-golang-org-x-sys))
    (home-page "https://github.com/sassoftware/go-rpmutils")
    (synopsis "Go RPM Utils")
    (description
     "go-rpmutils is a library written in @@url{http://golang.org,go} for parsing and
extracting content from @@url{http://www.rpm.org,RPMs}.")
    (license license:asl2.0)))

(define-public go-github-com-goreleaser-nfpm-v2
  (package
    (name "go-github-com-goreleaser-nfpm-v2")
    (version "2.45.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/goreleaser/nfpm")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qrkkzjc5z4cchrh5glsj2dvsgyriykiswdl52c7i2y49fhvwgmk"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.25
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/goreleaser/nfpm/v2"
      #:unpack-path "github.com/goreleaser/nfpm/v2"))
    (propagated-inputs (list go-dario-cat-mergo
                             go-github-com-aleksi-pointer
                             go-github-com-blakesmith-ar
                             go-github-com-caarlos0-go-version
                             go-github-com-google-rpmpack
                             go-github-com-goreleaser-chglog
                             go-github-com-goreleaser-fileglob
                             go-github-com-invopop-jsonschema
                             go-github-com-klauspost-compress
                             go-github-com-klauspost-pgzip
                             go-github-com-masterminds-semver-v3
                             go-github-com-muesli-mango-cobra
                             go-github-com-muesli-roff
                             go-github-com-protonmail-go-crypto
                             go-github-com-protonmail-gopenpgp-v2
                             go-github-com-sassoftware-go-rpmutils
                             go-github-com-spf13-cobra
                             go-github-com-stretchr-testify
                             go-github-com-ulikunitz-xz
                             go-go-yaml-in-yaml-v3))
    (home-page "https://github.com/goreleaser/nfpm")
    (synopsis "Why")
    (description
     "Package nfpm provides ways to package programs in some linux packaging formats.")
    (license license:expat)))

(define-public go-github-com-hdevalence-ed25519consensus
  (package
    (name "go-github-com-hdevalence-ed25519consensus")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hdevalence/ed25519consensus")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1dmkl3hnv0h0r4apvs34jf1cz4wcj34cksiiij4p1z4kqcldwdi9"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/hdevalence/ed25519consensus"))
    (propagated-inputs (list go-filippo-io-edwards25519))
    (home-page "https://github.com/hdevalence/ed25519consensus")
    (synopsis "Ed25519 for consensus-critical contexts")
    (description
     "Package ed25519consensus implements Ed25519 verification according to ZIP215.")
    (license license:bsd-3)))

(define-public go-github-com-illarion-gonotify-v3
  (package
    (name "go-github-com-illarion-gonotify-v3")
    (version "3.0.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/illarion/gonotify")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07bym2ybs4kga422y7i3vs7zskyxwsv0psv18ds8pp00yybv6vc3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/illarion/gonotify/v3"
      #:unpack-path "github.com/illarion/gonotify/v3"))
    (home-page "https://github.com/illarion/gonotify")
    (synopsis "Gonotify")
    (description "Simple Golang inotify wrapper.")
    (license license:expat)))

(define-public go-github-com-jellydator-ttlcache-v3
  (package
    (name "go-github-com-jellydator-ttlcache-v3")
    (version "3.4.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jellydator/ttlcache")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0c7k99d0km5vplfikb58j2wbriy3mzzrrfrc0d85x50km0y4g4ln"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/jellydator/ttlcache/v3"
      #:unpack-path "github.com/jellydator/ttlcache/v3"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-go-uber-org-goleak go-golang-org-x-sync))
    (home-page "https://github.com/jellydator/ttlcache")
    (synopsis
     "TTLCache - an in-memory cache with item expiration and generics")
    (description
     "The @@code{ttlcache} package is stable and used by
@@url{https://jellydator.com/,Jellydator}, as well as thousands of other
projects and organizations in production.")
    (license license:expat)))

(define-public go-github-com-mdlayher-sdnotify
  (package
    (name "go-github-com-mdlayher-sdnotify")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mdlayher/sdnotify")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0nxpbjba4n4vfkwfy9q2x5djv8agfnvd6pp7l7a6d6ssl2vhkcrv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/mdlayher/sdnotify"))
    (propagated-inputs (list go-github-com-google-go-cmp))
    (home-page "https://github.com/mdlayher/sdnotify")
    (synopsis "sdnotify")
    (description
     "Package sdnotify implements systemd readiness notifications as described in
@@url{https://www.freedesktop.org/software/systemd/man/sd_notify.html,https://www.freedesktop.org/software/systemd/man/sd_notify.html}.")
    (license license:expat)))

(define-public go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-compute-armcompute-v5
  (package
    (name
     "go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-compute-armcompute-v5")
    (version "5.7.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Azure/azure-sdk-for-go")
             (commit (go-version->git-ref version
                                          #:subdir "sdk/resourcemanager/compute/armcompute"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1dj61g9azlmfmkg649ggd8fz36hvlinvdprhgmj5q3njp4kv4gvv"))
       (modules '((guix build utils)
                  (ice-9 ftw)
                  (srfi srfi-26)))
       (snippet
        #~(begin
            (define (delete-all-but directory . preserve)
              (with-directory-excursion directory
                (let* ((pred (negate (cut member <>
                                          (cons* "." ".." preserve))))
                       (items (scandir "." pred)))
                  (for-each (cut delete-file-recursively <>) items))))
            (define (move-contents-into-version directory version)
              (with-directory-excursion directory
                (mkdir-p version)
                (for-each
                 (lambda (entry)
                   (unless (member entry (list "." ".." version))
                     (rename-file entry (string-append version "/" entry))))
                 (scandir "."))))
            (delete-all-but "sdk/resourcemanager/compute" "armcompute")
            (delete-all-but "sdk/resourcemanager" "compute")
            (delete-all-but "sdk" "resourcemanager")
            (move-contents-into-version "sdk/resourcemanager/compute/armcompute"
                                        "v5")
            (delete-all-but "." "sdk")))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:embed-files azure-sdk-embed-files
      #:import-path
      "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/compute/armcompute/v5"
      #:unpack-path
      "github.com/Azure/azure-sdk-for-go"))
    (propagated-inputs (list go-github-com-azure-azure-sdk-for-go-sdk-azcore
                        go-github-com-azure-azure-sdk-for-go-sdk-azidentity
                        go-github-com-azure-azure-sdk-for-go-sdk-internal
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-internal-v2
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-resources-armresources
                        go-github-com-stretchr-testify))
    (home-page "https://github.com/Azure/azure-sdk-for-go")
    (synopsis "Azure Compute Module for Go")
    (description
     "The @@code{armcompute} module provides operations for working with Azure
Compute.")
    (license license:expat)))

(define-public go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-managementgroups-armmanagementgroups
  (package
    (name
     "go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-managementgroups-armmanagementgroups")
    (version "1.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Azure/azure-sdk-for-go")
             (commit (go-version->git-ref version
                                          #:subdir "sdk/resourcemanager/managementgroups/armmanagementgroups"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0l6jdkkgc2fhf43qd3d1s1llnv40skmql6zf9vjbyrc73qad44cj"))
       (modules '((guix build utils)
                  (ice-9 ftw)
                  (srfi srfi-26)))
       (snippet
        #~(begin
            (define (delete-all-but directory . preserve)
              (with-directory-excursion directory
                (let* ((pred (negate (cut member <>
                                          (cons* "." ".." preserve))))
                       (items (scandir "." pred)))
                  (for-each (cut delete-file-recursively <>) items))))
            (delete-all-but "sdk/resourcemanager/managementgroups"
                            "armmanagementgroups")
            (delete-all-but "sdk/resourcemanager" "managementgroups")
            (delete-all-but "sdk" "resourcemanager")
            (delete-all-but "." "sdk")))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:embed-files azure-sdk-embed-files
      #:import-path
      "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/managementgroups/armmanagementgroups"
      #:unpack-path
      "github.com/Azure/azure-sdk-for-go"))
    (propagated-inputs (list go-github-com-azure-azure-sdk-for-go-sdk-azcore
                        go-github-com-azure-azure-sdk-for-go-sdk-azidentity
                        go-github-com-azure-azure-sdk-for-go-sdk-internal
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-internal-v2
                        go-github-com-stretchr-testify))
    (home-page "https://github.com/Azure/azure-sdk-for-go")
    (synopsis "Azure Management Groups Module for Go")
    (description
     "The @@code{armmanagementgroups} module provides operations for working with
Azure Management Groups.")
    (license license:expat)))

(define-public go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-resources-armresources
  (package
    (name
     "go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-resources-armresources")
    (version "1.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Azure/azure-sdk-for-go")
             (commit (go-version->git-ref version
                                          #:subdir "sdk/resourcemanager/resources/armresources"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01r351rl6w0gdpgpllq692yip5c761l8f8098hfnw4bgsk625qc7"))
       (modules '((guix build utils)
                  (ice-9 ftw)
                  (srfi srfi-26)))
       (snippet
        #~(begin
            (define (delete-all-but directory . preserve)
              (with-directory-excursion directory
                (let* ((pred (negate (cut member <>
                                          (cons* "." ".." preserve))))
                       (items (scandir "." pred)))
                  (for-each (cut delete-file-recursively <>) items))))
            (delete-all-but "sdk/resourcemanager/resources" "armresources")
            (delete-all-but "sdk/resourcemanager" "resources")
            (delete-all-but "sdk" "resourcemanager")
            (delete-all-but "." "sdk")))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:embed-files azure-sdk-embed-files
      #:import-path
      "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/resources/armresources"
      #:unpack-path
      "github.com/Azure/azure-sdk-for-go"))
    (propagated-inputs (list go-github-com-azure-azure-sdk-for-go-sdk-azcore
                        go-github-com-azure-azure-sdk-for-go-sdk-azidentity
                        go-github-com-azure-azure-sdk-for-go-sdk-internal
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-internal-v2
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-managementgroups-armmanagementgroups
                        go-github-com-stretchr-testify))
    (home-page "https://github.com/Azure/azure-sdk-for-go")
    (synopsis "Azure Resources Module for Go")
    (description
     "The @@code{armresources} module provides operations for working with Azure
Resources.")
    (license license:expat)))

(define-public go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-internal-v2
  (package
    (name "go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-internal-v2")
    (version "2.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Azure/azure-sdk-for-go")
             (commit (go-version->git-ref version
                                          #:subdir "sdk/resourcemanager/internal"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0db2hxq8wigvmqkj8h5gfq9lw6bp0k13hvcyi0hxgnriz1mdvpx5"))
       (modules '((guix build utils)
                  (ice-9 ftw)
                  (srfi srfi-26)))
       (snippet
        #~(begin
            (define (delete-all-but directory . preserve)
              (with-directory-excursion directory
                (let* ((pred (negate (cut member <>
                                          (cons* "." ".." preserve))))
                       (items (scandir "." pred)))
                  (for-each (cut delete-file-recursively <>) items))))
            (define (move-contents-into-version directory version)
              (with-directory-excursion directory
                (mkdir-p version)
                (for-each
                 (lambda (entry)
                   (unless (member entry (list "." ".." version))
                     (rename-file entry (string-append version "/" entry))))
                 (scandir "."))))
            (delete-all-but "sdk/resourcemanager" "internal")
            (delete-all-but "sdk" "resourcemanager")
            (move-contents-into-version "sdk/resourcemanager/internal" "v2")
            (delete-all-but "." "sdk")))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:embed-files azure-sdk-embed-files
      #:import-path
      "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/internal/v2"
      #:unpack-path
      "github.com/Azure/azure-sdk-for-go"))
    (propagated-inputs (list go-github-com-stretchr-testify))
    (home-page "https://github.com/Azure/azure-sdk-for-go")
    (synopsis #f)
    (description #f)
    (license license:expat)))

(define-public go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-network-armnetwork-v4
  (package
    (name
     "go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-network-armnetwork-v4")
    (version "4.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Azure/azure-sdk-for-go")
             (commit (go-version->git-ref version
                                          #:subdir "sdk/resourcemanager/network/armnetwork"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "16ffwdw8di79canc1v00gfpg6shn1wqd9fbfxyss16m5d8fsxlyy"))
       (modules '((guix build utils)
                  (ice-9 ftw)
                  (srfi srfi-26)))
       (snippet
        #~(begin
            (define (delete-all-but directory . preserve)
              (with-directory-excursion directory
                (let* ((pred (negate (cut member <>
                                          (cons* "." ".." preserve))))
                       (items (scandir "." pred)))
                  (for-each (cut delete-file-recursively <>) items))))
            (define (move-contents-into-version directory version)
              (with-directory-excursion directory
                (mkdir-p version)
                (for-each
                 (lambda (entry)
                   (unless (member entry (list "." ".." version))
                     (rename-file entry (string-append version "/" entry))))
                 (scandir "."))))
            (delete-all-but "sdk/resourcemanager/network" "armnetwork")
            (delete-all-but "sdk/resourcemanager" "network")
            (delete-all-but "sdk" "resourcemanager")
            (move-contents-into-version "sdk/resourcemanager/network/armnetwork"
                                        "v4")
            (delete-all-but "." "sdk")))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:embed-files azure-sdk-embed-files
      #:import-path
      "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/network/armnetwork/v4"
      #:unpack-path
      "github.com/Azure/azure-sdk-for-go"))
    (propagated-inputs (list go-github-com-azure-azure-sdk-for-go-sdk-azcore
                        go-github-com-azure-azure-sdk-for-go-sdk-azidentity
                        go-github-com-azure-azure-sdk-for-go-sdk-internal
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-internal-v2
                        go-github-com-stretchr-testify))
    (home-page "https://github.com/Azure/azure-sdk-for-go")
    (synopsis "Azure Network Module for Go")
    (description
     "The @@code{armnetwork} module provides operations for working with Azure
Network.")
    (license license:expat)))

(define-public go-github-com-aws-aws-sdk-go-v2-service-ec2
  (package
    (name "go-github-com-aws-aws-sdk-go-v2-service-ec2")
    (version "1.291.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/aws/aws-sdk-go-v2")
             (commit (go-version->git-ref version
                                          #:subdir "service/ec2"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0g5hhg95gdmh6bhfchhdgw6gnl3zvxqbfbbnd51mibwjgz2ib646"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/aws/aws-sdk-go-v2/service/ec2"
      #:unpack-path "github.com/aws/aws-sdk-go-v2"))
    (propagated-inputs (list go-github-com-aws-smithy-go))
    (home-page "https://github.com/aws/aws-sdk-go-v2")
    (synopsis #f)
    (description
     "Package ec2 provides the API client, operations, and parameter types for Amazon
Elastic Compute Cloud.")
    (license license:asl2.0)))

(define-public go-github-com-aws-aws-sdk-go-v2-service-ecs
  (package
    (name "go-github-com-aws-aws-sdk-go-v2-service-ecs")
    (version "1.72.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/aws/aws-sdk-go-v2")
             (commit (go-version->git-ref version
                                          #:subdir "service/ecs"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yv4dnx28dblf5mp5fj81bpghvk5qlx7qsid285x64gy1swrlczx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/aws/aws-sdk-go-v2/service/ecs"
      #:unpack-path "github.com/aws/aws-sdk-go-v2"))
    (propagated-inputs (list go-github-com-aws-smithy-go))
    (home-page "https://github.com/aws/aws-sdk-go-v2")
    (synopsis #f)
    (description
     "Package ecs provides the API client, operations, and parameter types for Amazon
EC2 Container Service.")
    (license license:asl2.0)))

(define-public go-github-com-aws-aws-sdk-go-v2-service-lightsail
  (package
    (name "go-github-com-aws-aws-sdk-go-v2-service-lightsail")
    (version "1.50.12")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/aws/aws-sdk-go-v2")
             (commit (go-version->git-ref version
                                          #:subdir "service/lightsail"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yv4dnx28dblf5mp5fj81bpghvk5qlx7qsid285x64gy1swrlczx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/aws/aws-sdk-go-v2/service/lightsail"
      #:unpack-path "github.com/aws/aws-sdk-go-v2"))
    (propagated-inputs (list go-github-com-aws-smithy-go))
    (home-page "https://github.com/aws/aws-sdk-go-v2")
    (synopsis #f)
    (description
     "Package lightsail provides the API client, operations, and parameter types for
Amazon Lightsail.")
    (license license:asl2.0)))

(define-public go-github-com-bboreham-go-loser
  (package
    (name "go-github-com-bboreham-go-loser")
    (version "0.0.0-20230920113527-fcc2c21820a3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bboreham/go-loser")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vphqyyda0gbnf9glnfjvmkv7g1za0rqir8jv9lv40fhs3qr8bv3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/bboreham/go-loser"))
    (propagated-inputs (list go-golang-org-x-exp))
    (home-page "https://github.com/bboreham/go-loser")
    (synopsis "go-loser")
    (description "Loser Tree data structure, for fast k-way merge.")
    (license license:asl2.0)))

(define-public go-github-com-go-zookeeper-zk
  (package
    (name "go-github-com-go-zookeeper-zk")
    (version "1.0.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-zookeeper/zk")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1znpz4xl7bpp855sajabmqm98zv7ma0bj9s8icpvjw9s16fqfdg9"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/go-zookeeper/zk"))
    (home-page "https://github.com/go-zookeeper/zk")
    (synopsis "Native Go Zookeeper Client Library")
    (description
     "Package zk is a native Go client library for the @code{ZooKeeper} orchestration
service.")
    (license license:bsd-3)))

(define-public go-github-com-gophercloud-gophercloud-v2
  (package
    (name "go-github-com-gophercloud-gophercloud-v2")
    (version "2.10.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gophercloud/gophercloud")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0lz9vjgfzflwbrihv4rnl5d2l4lkwyjyfzvqca53d3c0akjkfzvh"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gophercloud/gophercloud/v2"
      #:unpack-path "github.com/gophercloud/gophercloud/v2"))
    (propagated-inputs (list go-golang-org-x-crypto go-gopkg-in-yaml-v2))
    (home-page "https://github.com/gophercloud/gophercloud")
    (synopsis "Gophercloud: an OpenStack SDK for Go")
    (description "Gophercloud is a Go SDK for @code{OpenStack}.")
    (license license:asl2.0)))

(define-public go-github-com-hashicorp-consul-api
  (package
    (name "go-github-com-hashicorp-consul-api")
    (version "1.33.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/consul")
             (commit (go-version->git-ref version
                                          #:subdir "api"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1q10af6rm61mz3mm5rwma6lgh1jn0h6y2d98zprckwr73wxgh37p"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
            #:import-path "github.com/hashicorp/consul/api"
      #:unpack-path "github.com/hashicorp/consul"))
    (propagated-inputs (list go-github-com-go-viper-mapstructure-v2
                             go-github-com-google-go-cmp
                             ;; go-github-com-hashicorp-consul-sdk
                             go-github-com-hashicorp-go-cleanhttp
                             go-github-com-hashicorp-go-hclog
                             go-github-com-hashicorp-go-multierror
                             go-github-com-hashicorp-go-rootcerts
                             go-github-com-hashicorp-go-uuid
                             go-github-com-hashicorp-serf
                             go-github-com-stretchr-testify
                             go-golang-org-x-exp))
    (home-page "https://github.com/hashicorp/consul")
    (synopsis "Consul API Client")
    (description
     "This package provides the @@code{api} package which provides programmatic access
to the full Consul API.")
    (license license:mpl2.0)))

(define-public go-github-com-hashicorp-cronexpr
  (package
    (name "go-github-com-hashicorp-cronexpr")
    (version "1.1.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/cronexpr")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0h9s5kkjvcpbrswmf2shyvm2i0gda0rdqrxw2cs9hvlhd2y6maij"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/hashicorp/cronexpr"))
    (home-page "https://github.com/hashicorp/cronexpr")
    (synopsis "Golang Cron expression parser")
    (description "Package cronexpr parses cron time expressions.")
    (license license:asl2.0)))

(define-public go-github-com-hashicorp-go-rootcerts
  (package
    (name "go-github-com-hashicorp-go-rootcerts")
    (version "1.0.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/go-rootcerts")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "06z1bxcnr0rma02b6r52m6y0q7niikqjs090vm1i8xi3scyaw1qa"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/hashicorp/go-rootcerts"))
    (propagated-inputs (list go-github-com-mitchellh-go-homedir))
    (home-page "https://github.com/hashicorp/go-rootcerts")
    (synopsis "rootcerts")
    (description
     "Package rootcerts contains functions to aid in loading CA certificates for TLS
connections.")
    (license license:mpl2.0)))

(define-public go-github-com-shoenig-test
  (package
    (name "go-github-com-shoenig-test")
    (version "1.12.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/shoenig/test")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1f1xcps70i96xr04cgq66api1rc2rxpbfy80pv9z3yawbsbqfniv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/shoenig/test"))
    (propagated-inputs (list go-github-com-google-go-cmp))
    (home-page "https://github.com/shoenig/test")
    (synopsis "test")
    (description
     "Package test provides a modern generic testing assertions library.")
    (license license:mpl2.0)))

(define-public go-github-com-hashicorp-nomad-api
  (package
    (name "go-github-com-hashicorp-nomad-api")
    (version "0.0.0-20260225141726-ea153dbcad6f")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/nomad")
             (commit (go-version->git-ref version
                                          #:subdir "api"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1p10hy7zzmr1hqpznm8hkdsz1x98097pfqbc7wnpx369c1zw9f5m"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/hashicorp/nomad/api"
      #:unpack-path "github.com/hashicorp/nomad"))
    (propagated-inputs (list go-github-com-docker-go-units
                             go-github-com-felixge-httpsnoop
                             go-github-com-go-viper-mapstructure-v2
                             go-github-com-gorilla-websocket
                             go-github-com-hashicorp-cronexpr
                             go-github-com-hashicorp-go-cleanhttp
                             go-github-com-hashicorp-go-multierror
                             go-github-com-hashicorp-go-rootcerts
                             go-github-com-shoenig-test))
    (home-page "https://github.com/hashicorp/nomad")
    (synopsis #f)
    (description #f)
    (license license:mpl2.0)))

(define-public go-github-com-ionos-cloud-sdk-go-v6
  (package
    (name "go-github-com-ionos-cloud-sdk-go-v6")
    (version "6.3.6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ionos-cloud/sdk-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bky8sj7kss1flind9jyzqajamv8bg6n3i1ca335mdd5nh9svpmy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/ionos-cloud/sdk-go/v6"
      #:unpack-path "github.com/ionos-cloud/sdk-go"))
    (propagated-inputs (list go-golang-org-x-oauth2))
    (home-page "https://github.com/ionos-cloud/sdk-go")
    (synopsis "Go API client for ionoscloud")
    (description
     "IONOS Enterprise-grade Infrastructure as a Service (@code{IaaS}) solutions can
be managed through the Cloud API, in addition or as an alternative to the \"Data
Center Designer\" (DCD) browser-based tool.")
    (license license:asl2.0)))

(define-public go-github-com-linode-linodego
  (package
    (name "go-github-com-linode-linodego")
    (version "1.65.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/linode/linodego")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0d7adg481a3ai4cqpxcihh78vij0imn1i7am1566ryaj1fq7r8k0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:embed-files
      #~(list
         "children"
         "nodes"
         "text")
      #:import-path "github.com/linode/linodego"))
    (propagated-inputs (list go-github-com-go-resty-resty-v2
                             go-github-com-google-go-cmp
                             go-github-com-google-go-querystring
                             go-github-com-jarcoal-httpmock
                             go-github-com-stretchr-testify
                             go-golang-org-x-net
                             go-golang-org-x-oauth2
                             go-golang-org-x-text
                             go-gopkg-in-ini-v1))
    (home-page "https://github.com/linode/linodego")
    (synopsis "linodego")
    (description
     "Go client for @@url{https://techdocs.akamai.com/linode-api/reference/api,Linode
REST v4 API}.")
    (license license:expat)))

(define-public go-github-com-nsf-jsondiff
  (package
    (name "go-github-com-nsf-jsondiff")
    (version "0.0.0-20260207060731-8e8d90c4c0ac")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nsf/jsondiff")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vxh3qpks929yvxiffx3sf7n113fr5sk93figj0v1ck4raf0zzpf"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/nsf/jsondiff"))
    (home-page "https://github.com/nsf/jsondiff")
    (synopsis "JsonDiff library")
    (description
     "The main purpose of the library is integration into tests which use json and
providing human-readable output of test results.")
    (license license:expat)))

(define-public go-go-opentelemetry-io-collector-featuregate
  (package
    (name "go-go-opentelemetry-io-collector-featuregate")
    (version "1.53.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "featuregate"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wxlqrk8sipjy2sabf2i3y8l57l7x7gklzj1rh1mv296c4r048va"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go.opentelemetry.io/collector/featuregate"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-hashicorp-go-version
                             go-github-com-stretchr-testify
                             go-go-uber-org-goleak go-go-uber-org-multierr))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis "Collector Feature Gates")
    (description
     "This package provides a mechanism that allows operators to enable and disable
experimental or transitional features at deployment time.  These flags should be
able to govern the behavior of the application starting as early as possible and
should be available to every component such that decisions may be made based on
flags at the component level.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-component-componenttest
  (package
    (name "go-go-opentelemetry-io-collector-component-componenttest")
    (version "0.146.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "component/componenttest"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go.opentelemetry.io/collector/component/componenttest"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-go-opentelemetry-io-otel-metric
                             go-go-opentelemetry-io-otel-sdk
                             go-go-opentelemetry-io-otel-sdk-metric
                             go-go-opentelemetry-io-otel-trace
                             go-go-uber-org-goleak
                             go-go-uber-org-multierr
                             go-go-uber-org-zap

                             go-github-com-hashicorp-go-version
                             go-github-com-json-iterator-go))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis #f)
    (description
     "Package componenttest define types and functions used to help test packages
implementing the component package interfaces.")
    (license license:asl2.0)))

(define-public go-github-com-knadh-koanf-providers-confmap
  (package
    (name "go-github-com-knadh-koanf-providers-confmap")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/knadh/koanf")
             (commit (go-version->git-ref version
                                          #:subdir "providers/confmap"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0a5cd3rpby1ymzpfc2shd1c1jhkkm92pdizqqsn4gfabc61kyyb5"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/knadh/koanf/providers/confmap"
      #:unpack-path "github.com/knadh/koanf"))
    (propagated-inputs (list ;; go-github-com-knadh-koanf-maps
                        go-github-com-mitchellh-copystructure

                        go-github-com-hashicorp-go-version))
    (home-page "https://github.com/knadh/koanf")
    (synopsis #f)
    (description
     "Package confmap implements a koanf.Provider that takes nested and flat
map[string]interface{} config maps and provides them to koanf.")
    (license license:expat)))

(define-public go-github-com-knadh-koanf-maps
  (package
    (name "go-github-com-knadh-koanf-maps")
    (version "0.1.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/knadh/koanf")
             (commit (go-version->git-ref version
                                          #:subdir "maps"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "128gahbkxggchr914m9s270zqwcsi4qxkwjpdlppl70lx1igcwbm"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/knadh/koanf/maps"
      #:unpack-path "github.com/knadh/koanf"))
    (propagated-inputs (list go-github-com-mitchellh-copystructure))
    (home-page "https://github.com/knadh/koanf")
    (synopsis #f)
    (description
     "Package maps provides reusable functions for manipulating nested
map[string]interface{} maps are common unmarshal products from various
serializers such as json, yaml etc.")
    (license license:expat)))

(define-public go-github-com-knadh-koanf-v2
  (package
    (name "go-github-com-knadh-koanf-v2")
    (version "2.3.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/knadh/koanf")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0nbvnqn2pf6jc9x2mdgbjvmpjj22p9v8mkycapgl4jk92cdclyvn"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/knadh/koanf/v2"))
    (propagated-inputs (list go-github-com-go-viper-mapstructure-v2
                             ;; go-github-com-knadh-koanf-maps
                             go-github-com-mitchellh-copystructure))
    (home-page "https://github.com/knadh/koanf")
    (synopsis "Installation")
    (description
     "@@strong{koanf} is a library for reading configuration from different sources in
different formats in Go applications.  It is a cleaner, lighter
@@url{#readme-alternative-to-viper,alternative to spf13/viper} with better
abstractions and extensibility and far fewer dependencies.")
    (license license:expat)))

(define-public go-go-opentelemetry-io-collector-confmap
  (package
    (name "go-go-opentelemetry-io-collector-confmap")
    (version "1.52.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "confmap"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "go.opentelemetry.io/collector/confmap"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-go-viper-mapstructure-v2
                             go-github-com-gobwas-glob
                             go-github-com-knadh-koanf-maps
                             go-github-com-knadh-koanf-providers-confmap
                             go-github-com-knadh-koanf-v2
                             go-github-com-stretchr-testify
                             go-go-uber-org-goleak
                             go-go-uber-org-multierr
                             go-go-uber-org-zap
                             go-go-yaml-in-yaml-v3))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis "Confmap")
    (description
     "The
@@url{https://github.com/open-telemetry/opentelemetry-collector/blob/confmap/v1.52.0/confmap/confmap.go,Conf}
represents the raw configuration for a service (e.g. @code{OpenTelemetry}
Collector).")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-confmap-xconfmap
  (package
    (name "go-go-opentelemetry-io-collector-confmap-xconfmap")
    (version "0.146.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "confmap/xconfmap"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
            #:import-path "go.opentelemetry.io/collector/confmap/xconfmap"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-stretchr-testify

                             go-github-com-go-viper-mapstructure-v2
                             go-github-com-gobwas-glob
                             go-github-com-knadh-koanf-maps
                             go-github-com-knadh-koanf-providers-confmap
                             go-github-com-knadh-koanf-v2
                             go-github-com-stretchr-testify
                             go-go-uber-org-goleak
                             go-go-uber-org-multierr
                             go-go-uber-org-zap
                             go-go-yaml-in-yaml-v3))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-consumer-consumertest
  (package
    (name "go-go-opentelemetry-io-collector-consumer-consumertest")
    (version "0.146.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "consumer/consumertest"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
            #:import-path "go.opentelemetry.io/collector/consumer/consumertest"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-go-uber-org-goleak

                             go-github-com-hashicorp-go-version
                             go-github-com-json-iterator-go
                             go-go-uber-org-multierr
                             go-go-uber-org-zap))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis #f)
    (description
     "Package consumertest defines types and functions used to help test packages
implementing the consumer package interfaces.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-processor-processortest
  (package
    (name "go-go-opentelemetry-io-collector-processor-processortest")
    (version "0.146.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "processor/processortest"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
            #:import-path "go.opentelemetry.io/collector/processor/processortest"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-go-uber-org-goleak

                             go-github-com-hashicorp-go-version
                             go-github-com-json-iterator-go
                             go-go-uber-org-multierr
                             go-go-uber-org-zap
                             go-go-opentelemetry-io-otel
                             go-go-opentelemetry-io-otel-sdk-metric))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-github-com-open-telemetry-opentelemetry-collector-contrib-processor-deltatocumulativeprocessor
  (package
    (name
     "go-github-com-open-telemetry-opentelemetry-collector-contrib-processor-deltatocumulativeprocessor")
    (version "0.146.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url
              "https://github.com/open-telemetry/opentelemetry-collector-contrib")
             (commit (go-version->git-ref version
                                          #:subdir "processor/deltatocumulativeprocessor"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1amkx4an4dvjrngppqcci6smyv2jwibajs6lajj5f55mi3ry62jc"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path
      "github.com/open-telemetry/opentelemetry-collector-contrib/processor/deltatocumulativeprocessor"
      #:unpack-path
      "github.com/open-telemetry/opentelemetry-collector-contrib"))
    (propagated-inputs (list go-github-com-google-go-cmp
                             go-github-com-puzpuzpuz-xsync-v3
                             go-github-com-stretchr-testify
                             go-go-opentelemetry-io-collector-component
                             go-go-opentelemetry-io-collector-component-componenttest
                             go-go-opentelemetry-io-collector-confmap
                             go-go-opentelemetry-io-collector-confmap-xconfmap
                             go-go-opentelemetry-io-collector-consumer
                             go-go-opentelemetry-io-collector-consumer-consumertest
                             go-go-opentelemetry-io-collector-pdata
                             go-go-opentelemetry-io-collector-processor
                             go-go-opentelemetry-io-collector-processor-processortest
                             go-go-opentelemetry-io-collector-featuregate
                             go-go-opentelemetry-io-otel
                             go-go-opentelemetry-io-otel-metric
                             go-go-opentelemetry-io-otel-sdk-metric
                             go-go-opentelemetry-io-otel-trace
                             go-go-uber-org-goleak
                             go-golang-org-x-tools
                             go-gopkg-in-yaml-v3

                             go-github-com-puzpuzpuz-xsync-v4))
    (home-page
     "https://github.com/open-telemetry/opentelemetry-collector-contrib")
    (synopsis "Delta to Cumulative Processor")
    (description
     "package deltatocumulativeprocessor implements a processor which converts metrics
from delta temporality to cumulative.")
    (license license:asl2.0)))

(define-public go-github-com-ovh-go-ovh
  (package
    (name "go-github-com-ovh-go-ovh")
    (version "1.9.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ovh/go-ovh")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00a1pr0zjs1q62zx3dvc28rkw00gj205g0r0k3vbj0pc5llspm20"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/ovh/go-ovh"))
    (propagated-inputs (list go-github-com-jarcoal-httpmock
                             go-github-com-maxatome-go-testdeep
                             go-golang-org-x-oauth2 go-gopkg-in-ini-v1))
    (home-page "https://github.com/ovh/go-ovh")
    (synopsis "go-ovh")
    (description
     "Lightweight Go wrapper around OVHcloud's APIs.  Handles all the hard work
including credential creation and requests signing.")
    (license license:bsd-3)))

(define-public go-github-com-prometheus-client-golang-exp
  (package
    (name "go-github-com-prometheus-client-golang-exp")
    (version "0.0.0-20260220084850-54a0d198e7b0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/prometheus/client_golang")
             (commit (go-version->git-ref version
                                          #:subdir "exp"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03qs29ya2k5xzjsi6man8p53dc3l307m0gfqmrwnjs53ajhd5s3j"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/prometheus/client_golang/exp"
      #:unpack-path "github.com/prometheus/client_golang"))
    (propagated-inputs (list go-github-com-google-go-cmp
                             go-github-com-klauspost-compress
                             go-github-com-prometheus-common
                             go-google-golang-org-protobuf))
    (home-page "https://github.com/prometheus/client_golang")
    (synopsis "client_golang experimental module")
    (description
     "package exp contains experimental utilities and APIs for Prometheus.")
    (license license:asl2.0)))

(define-public go-github-com-scaleway-scaleway-sdk-go
  (package
    (name "go-github-com-scaleway-scaleway-sdk-go")
    (version "1.0.0-beta.36")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/scaleway/scaleway-sdk-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "08hpg1qz4npkwzqwqijjwprary0c8xbhq8xhydzxk58zs010lr9i"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/scaleway/scaleway-sdk-go"))
    (propagated-inputs (list go-golang-org-x-text go-gopkg-in-dnaeon-go-vcr-v4
                             go-gopkg-in-yaml-v2))
    (home-page "https://github.com/scaleway/scaleway-sdk-go")
    (synopsis "Scaleway GO SDK")
    (description "Package scalewaysdkgo is the Scaleway API SDK for Go.")
    (license license:asl2.0)))

(define-public go-github-com-stackitcloud-stackit-sdk-go-core
  (package
    (name "go-github-com-stackitcloud-stackit-sdk-go-core")
    (version "0.21.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/stackitcloud/stackit-sdk-go")
             (commit (go-version->git-ref version
                                          #:subdir "core"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1rdxizb7rndrdwnskn2bw7hzas2yialg8ah6fc6pf2xr2bbr5d17"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/stackitcloud/stackit-sdk-go/core"
      #:unpack-path "github.com/stackitcloud/stackit-sdk-go"))
    (propagated-inputs (list go-github-com-golang-jwt-jwt-v5
                             go-github-com-google-go-cmp
                             go-github-com-google-uuid))
    (home-page "https://github.com/stackitcloud/stackit-sdk-go")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-github-com-vultr-govultr-v2
  (package
    (name "go-github-com-vultr-govultr-v2")
    (version "2.17.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/vultr/govultr")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0crl56lx2djxwgp784hzis7invyxmw6xy32p713ch95qafrddi61"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/vultr/govultr/v2"
      #:unpack-path "github.com/vultr/govultr"))
    (propagated-inputs (list go-github-com-google-go-querystring
                             go-github-com-hashicorp-go-retryablehttp))
    (home-page "https://github.com/vultr/govultr")
    (synopsis "GoVultr")
    (description
     "The official Vultr Go client - @code{GoVultr} allows you to interact with the
Vultr V2 API.")
    (license license:expat)))

(define-public go-go-opentelemetry-io-collector-component
  (package
    (name "go-go-opentelemetry-io-collector-component")
    (version "1.52.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "component"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "go.opentelemetry.io/collector/component"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-go-opentelemetry-io-otel-metric
                             go-go-opentelemetry-io-otel-trace
                             go-go-uber-org-goleak go-go-uber-org-zap

                             ;; go-go-opentelemetry-io-collector-pdata
                             go-github-com-hashicorp-go-version
                             go-github-com-json-iterator-go
                             go-go-uber-org-multierr
                             go-go-opentelemetry-io-otel))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis #f)
    (description
     "Package component outlines the abstraction of components within the
@code{OpenTelemetry} Collector.  It provides details on the component lifecycle
as well as defining the interface that components must fulfill.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-consumer
  (package
    (name "go-go-opentelemetry-io-collector-consumer")
    (version "1.52.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "consumer"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "go.opentelemetry.io/collector/consumer"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-go-uber-org-goleak

                             go-github-com-hashicorp-go-version
                             go-go-uber-org-multierr
                             go-github-com-json-iterator-go))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis #f)
    (description
     "Package consumer contains interfaces that receive and process data.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-proto-slim-otlp
  (package
    (name "go-go-opentelemetry-io-proto-slim-otlp")
    (version "1.9.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-proto-go")
             (commit (go-version->git-ref version
                                          #:subdir "slim/otlp"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hv5sqsp6r539nwbhyapwnqcpx1wipxlsgpp2w9di6zva0irvjb0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "go.opentelemetry.io/proto/slim/otlp"
      #:unpack-path "go.opentelemetry.io/proto"))
    (propagated-inputs (list go-google-golang-org-protobuf))
    (home-page "https://go.opentelemetry.io/proto")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-proto-slim-otlp-collector-profiles-v1development
  (package
    (name
     "go-go-opentelemetry-io-proto-slim-otlp-collector-profiles-v1development")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-proto-go")
             (commit (go-version->git-ref version
                                          #:subdir "slim/otlp/collector/profiles/v1development"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hv5sqsp6r539nwbhyapwnqcpx1wipxlsgpp2w9di6zva0irvjb0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path
      "go.opentelemetry.io/proto/slim/otlp/collector/profiles/v1development"
      #:unpack-path "go.opentelemetry.io/proto"))
    (propagated-inputs (list go-google-golang-org-protobuf))
    (home-page "https://go.opentelemetry.io/proto")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-proto-slim-otlp-profiles-v1development
  (package
    (name "go-go-opentelemetry-io-proto-slim-otlp-profiles-v1development")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-proto-go")
             (commit (go-version->git-ref version
                                          #:subdir "slim/otlp/profiles/v1development"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1hv5sqsp6r539nwbhyapwnqcpx1wipxlsgpp2w9di6zva0irvjb0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path
      "go.opentelemetry.io/proto/slim/otlp/profiles/v1development"
      #:unpack-path "go.opentelemetry.io/proto"))
    (propagated-inputs (list go-google-golang-org-protobuf))
    (home-page "https://go.opentelemetry.io/proto")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-pdata
  (package
    (name "go-go-opentelemetry-io-collector-pdata")
    (version "1.52.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "pdata"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "go.opentelemetry.io/collector/pdata"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-json-iterator-go
                        go-github-com-stretchr-testify
                        go-go-opentelemetry-io-proto-slim-otlp
                        go-go-opentelemetry-io-proto-slim-otlp-collector-profiles-v1development
                        go-go-opentelemetry-io-proto-slim-otlp-profiles-v1development
                        go-go-uber-org-goleak
                        go-go-uber-org-multierr
                        go-google-golang-org-grpc
                        go-google-golang-org-protobuf))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis "Pipeline data (pdata)")
    (description
     "Package pdata provides the data model definitions for all supported pipeline
data.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-processor
  (package
    (name "go-go-opentelemetry-io-collector-processor")
    (version "1.52.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "processor"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wvk5nmg08b1yp37gac8nxqm337nmc86ydq683hxlpkc4wrhzkmq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "go.opentelemetry.io/collector/processor"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-go-uber-org-goleak

                             go-github-com-hashicorp-go-version
                             go-go-uber-org-multierr
                             go-go-uber-org-zap
                             go-github-com-json-iterator-go

                             go-go-opentelemetry-io-otel
                             ;; go-go-opentelemetry-io-otel-metric
                             ;; go-go-opentelemetry-io-otel-trace
                             ;; go-go-opentelemetry-io-otel
                             ))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis "General Information")
    (description
     "Processors are used at various stages of a pipeline.  Generally, a processor
pre-processes data before it is exported (e.g. modify attributes or sample).")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-semconv
  (package
    (name "go-go-opentelemetry-io-collector-semconv")
    (version "0.128.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "semconv"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1p06k1lvxz6llgkdbpsrbdivzmxyh5cs9k2vm227isfbgp3j2k40"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "go.opentelemetry.io/collector/semconv"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-github-com-hashicorp-go-version
                             go-github-com-stretchr-testify
                             go-go-uber-org-goleak))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis "Semantic Convention Constants")
    (description
     "This package contains constants representing the @code{OpenTelemetry} semantic
conventions.  They are automatically generated from definitions in the
specification.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-contrib-instrumentation-net-http-httptrace-otelhttptrace
  (package
    (name
     "go-go-opentelemetry-io-contrib-instrumentation-net-http-httptrace-otelhttptrace")
    (version "0.65.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-go-contrib")
             (commit (go-version->git-ref version
                                          #:subdir "instrumentation/net/http/httptrace/otelhttptrace"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yhgycwiclnlh3py1bwsbcnp2caz7prbjwxfl9blim746rzjika1"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path
      "go.opentelemetry.io/contrib/instrumentation/net/http/httptrace/otelhttptrace"
      #:unpack-path "go.opentelemetry.io/contrib"))
    (propagated-inputs (list go-github-com-google-go-cmp
                             go-github-com-stretchr-testify
                             go-go-opentelemetry-io-otel
                             go-go-opentelemetry-io-otel-metric
                             go-go-opentelemetry-io-otel-sdk
                             go-go-opentelemetry-io-otel-sdk-metric
                             go-go-opentelemetry-io-otel-trace))
    (home-page "https://go.opentelemetry.io/contrib")
    (synopsis #f)
    (description "Package otelhttptrace provides instrumentation for the
@@url{/net/http/httptrace,net/http/httptrace} package.")
    (license #f ; unknown-license!
)))

(define-public go-k8s-io-klog
  (package
    (name "go-k8s-io-klog")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/klog")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1cgannfmldcrcksb2wqdn2b5qabqyxl9r25w9y4qbljw24hhnlvn"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "k8s.io/klog"))
    (propagated-inputs (list go-github-com-go-logr-logr))
    (home-page "https://k8s.io/klog")
    (synopsis "klog")
    (description
     "Package klog implements logging analogous to the Google-internal C++
INFO/ERROR/V setup.  It provides functions Info, Warning, Error, Fatal, plus
formatting variants such as Infof.  It also provides V-style logging controlled
by the -v and -vmodule=file=2 flags.")
    (license license:asl2.0)))

(define-public go-github-com-prometheus-prometheus
  (package
    (name "go-github-com-prometheus-prometheus")
    (version "0.309.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/prometheus/prometheus")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qs0lwmv22f4rjmvlx4s8yrlvx0k9b7rdqpfgfz92zn4zhb9dalj"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/prometheus/prometheus"))
    (propagated-inputs (list go-github-com-alecthomas-kingpin-v2
                        go-github-com-alecthomas-units
                        go-github-com-aws-aws-sdk-go-v2
                        go-github-com-aws-aws-sdk-go-v2-config
                        go-github-com-aws-aws-sdk-go-v2-credentials
                        go-github-com-aws-aws-sdk-go-v2-feature-ec2-imds
                        go-github-com-aws-aws-sdk-go-v2-service-ec2
                        go-github-com-aws-aws-sdk-go-v2-service-ecs
                        go-github-com-aws-aws-sdk-go-v2-service-lightsail
                        go-github-com-aws-aws-sdk-go-v2-service-sts
                        go-github-com-aws-smithy-go
                        go-github-com-azure-azure-sdk-for-go-sdk-azcore
                        go-github-com-azure-azure-sdk-for-go-sdk-azidentity
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-compute-armcompute-v5
                        go-github-com-azure-azure-sdk-for-go-sdk-resourcemanager-network-armnetwork-v4
                        go-github-com-bboreham-go-loser
                        go-github-com-cespare-xxhash-v2
                        go-github-com-code-hex-go-generics-cache
                        go-github-com-dennwc-varint
                        go-github-com-digitalocean-godo
                        go-github-com-docker-docker
                        go-github-com-edsrzf-mmap-go
                        ;; go-github-com-envoyproxy-go-control-plane-envoy
                        go-github-com-envoyproxy-go-control-plane
                        go-github-com-envoyproxy-protoc-gen-validate
                        go-github-com-facette-natsort
                        go-github-com-fsnotify-fsnotify
                        go-github-com-go-openapi-strfmt
                        go-github-com-go-zookeeper-zk
                        go-github-com-gogo-protobuf
                        go-github-com-golang-snappy
                        go-github-com-google-go-cmp
                        go-github-com-google-pprof
                        go-github-com-google-uuid
                        go-github-com-gophercloud-gophercloud-v2
                        go-github-com-grafana-regexp
                        go-github-com-hashicorp-consul-api
                        go-github-com-hashicorp-nomad-api
                        go-github-com-hetznercloud-hcloud-go-v2
                        go-github-com-ionos-cloud-sdk-go-v6
                        go-github-com-json-iterator-go
                        go-github-com-kimmachinegun-automemlimit
                        go-github-com-klauspost-compress
                        go-github-com-kolo-xmlrpc
                        go-github-com-linode-linodego
                        go-github-com-miekg-dns
                        go-github-com-munnerz-goautoneg
                        go-github-com-mwitkow-go-conntrack
                        go-github-com-nsf-jsondiff
                        go-github-com-oklog-run
                        go-github-com-oklog-ulid-v2
                        go-github-com-open-telemetry-opentelemetry-collector-contrib-processor-deltatocumulativeprocessor
                        go-github-com-ovh-go-ovh
                        go-github-com-prometheus-alertmanager
                        go-github-com-prometheus-client-golang
                        go-github-com-prometheus-client-golang-exp
                        go-github-com-prometheus-client-model
                        go-github-com-prometheus-common
                        go-github-com-prometheus-common-assets
                        go-github-com-prometheus-exporter-toolkit
                        go-github-com-prometheus-otlptranslator
                        go-github-com-prometheus-sigv4
                        go-github-com-scaleway-scaleway-sdk-go
                        go-github-com-shurcool-httpfs
                        go-github-com-stackitcloud-stackit-sdk-go-core
                        go-github-com-stretchr-testify
                        go-github-com-vultr-govultr-v2
                        go-go-opentelemetry-io-collector-component
                        go-go-opentelemetry-io-collector-consumer
                        go-go-opentelemetry-io-collector-pdata
                        go-go-opentelemetry-io-collector-processor
                        go-go-opentelemetry-io-collector-semconv
                        go-go-opentelemetry-io-contrib-instrumentation-net-http-httptrace-otelhttptrace
                        go-go-opentelemetry-io-contrib-instrumentation-net-http-otelhttp
                        go-go-opentelemetry-io-otel
                        go-go-opentelemetry-io-otel-exporters-otlp-otlptrace
                        go-go-opentelemetry-io-otel-exporters-otlp-otlptrace-otlptracegrpc
                        go-go-opentelemetry-io-otel-exporters-otlp-otlptrace-otlptracehttp
                        go-go-opentelemetry-io-otel-metric
                        go-go-opentelemetry-io-otel-sdk
                        go-go-opentelemetry-io-otel-trace
                        go-go-uber-org-atomic
                        go-go-uber-org-automaxprocs
                        go-go-uber-org-goleak
                        go-go-uber-org-multierr
                        go-go-yaml-in-yaml-v2
                        go-golang-org-x-oauth2
                        go-golang-org-x-sync
                        go-golang-org-x-sys
                        go-golang-org-x-text
                        go-google-golang-org-api
                        go-google-golang-org-genproto-googleapis-api
                        go-google-golang-org-grpc
                        go-google-golang-org-protobuf
                        go-gopkg-in-yaml-v3
                        go-k8s-io-api
                        go-k8s-io-apimachinery
                        go-k8s-io-client-go
                        go-k8s-io-klog
                        go-k8s-io-klog-v2))
    (home-page "https://github.com/prometheus/prometheus")
    (synopsis "Architecture overview")
    (description
     "Visit @@url{https://prometheus.io,prometheus.io} for the full documentation,
examples and guides.")
    (license license:asl2.0)))

(define-public go-github-com-studio-b12-gowebdav
  (package
    (name "go-github-com-studio-b12-gowebdav")
    (version "0.12.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/studio-b12/gowebdav")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0wa69g86vm61xr7kxvj6v6902h39xbdakkwk8z6lv883vm7mh2x4"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/studio-b12/gowebdav"))
    (home-page "https://github.com/studio-b12/gowebdav")
    (synopsis "GoWebDAV")
    (description
     "Package gowebdav is a @code{WebDAV} client library with a command line tool
included.")
    (license license:bsd-3)))

(define-public go-github-com-github-fakeca
  (package
    (name "go-github-com-github-fakeca")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/github/fakeca")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1v35lrgcc23rd2f5baa7sini11ap1cb1n07kasvicsg5qb58ypbq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/github/fakeca"))
    (home-page "https://github.com/github/fakeca")
    (synopsis "fakeca")
    (description
     "This is a package for creating fake certificate authorities for test fixtures.")
    (license license:expat)))

(define-public go-github-com-tailscale-certstore
  (package
    (name "go-github-com-tailscale-certstore")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/certstore")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "192d6bpby4nyqk8b8xflpabcz7b3y256ny4dfzfqr9pkp9zy6cmp"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/tailscale/certstore"))
    (propagated-inputs (list go-github-com-github-fakeca
                             go-github-com-pkg-errors))
    (home-page "https://github.com/tailscale/certstore")
    (synopsis "certstore")
    (description
     "Certstore is a Go library for accessing user identities stored in platform
certificate stores.  On Windows and @code{macOS}, certstore can enumerate user
identities and sign messages with their private keys.")
    (license license:expat)))

(define-public go-github-com-ziutek-telnet
  (package
    (name "go-github-com-ziutek-telnet")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ziutek/telnet")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0w0zn8yhpmhrph41dlf9pn5h1zzhgajxwbx85fk4d0m55xp0r680"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/ziutek/telnet"))
    (home-page "https://github.com/ziutek/telnet")
    (synopsis #f)
    (description
     "Package telnet provides simple interface for interacting with Telnet connection.")
    (license license:bsd-3)))

(define-public go-github-com-tailscale-goexpect
  (package
    (name "go-github-com-tailscale-goexpect")
    (version "0.0.0-20210902213824-6e8c725cea41")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/goexpect")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1q3npn5n51p3cxi1p87i8iqjw3mldwdg08wp1fk0y47m57m59yhh"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/tailscale/goexpect"))
    (propagated-inputs (list go-github-com-google-goterm
                             go-github-com-ziutek-telnet
                             go-golang-org-x-crypto))
    (home-page "https://github.com/tailscale/goexpect")
    (synopsis "Features:")
    (description "Package expect is a Go version of the classic TCL Expect.")
    (license license:bsd-3)))

(define-public go-github-com-tailscale-golang-x-crypto
  (package
    (name "go-github-com-tailscale-golang-x-crypto")
    (version "0.91.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/golang-x-crypto")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0m9qkk48mihrkmfh1fzfhc39l8957qkpfx8qbw4xdjws7dy4vzbz"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/tailscale/golang-x-crypto"))
    (propagated-inputs (list go-golang-org-x-crypto go-golang-org-x-net
                             go-golang-org-x-sys go-golang-org-x-term))
    (home-page "https://github.com/tailscale/golang-x-crypto")
    (synopsis "Go Cryptography")
    (description
     "This repository holds supplementary Go cryptography libraries.")
    (license license:bsd-3)))

(define-public go-github-com-tailscale-hujson
  (package
    (name "go-github-com-tailscale-hujson")
    (version "0.0.0-20250605163823-992244df8c5a")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/hujson")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "14adnvmdfm2i8nnan3bidgsqshq55z0rys5h55lfwlxi41d2ylg6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/tailscale/hujson"))
    (propagated-inputs (list go-github-com-google-go-cmp))
    (home-page "https://github.com/tailscale/hujson")
    (synopsis "HuJSON - \"Human JSON\" (")
    (description
     "Package hujson contains a parser and packer for the JWCC format: JSON With
Commas and Comments (or \"human JSON\").")
    (license license:bsd-3)))

(define-public go-github-com-tailscale-mkctr
  (package
    (name "go-github-com-tailscale-mkctr")
    (version "0.0.0-20260107121656-ea857e3e500b")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/mkctr")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "028b1cxlw8hf3qpg6pj178lfdmr43kav1b2bxxd7c6nrjgxnwm4g"))))
    (build-system go-build-system)
    (arguments
     (list
            #:import-path "github.com/tailscale/mkctr"))
    (propagated-inputs (list go-github-com-google-go-containerregistry))
    (home-page "https://github.com/tailscale/mkctr")
    (synopsis ": cross platform container builder for go")
    (description "mkctr builds the Tailscale OCI containers.")
    (license license:bsd-3)))

(define-public go-github-com-tailscale-netlink
  (package
    (name "go-github-com-tailscale-netlink")
    (version "1.1.1-0.20240822203006-4d49adab4de7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/netlink")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zf45fnkmw89wf7r2pakxanwk4khqzivrnc170v4dwn5lh5wvlwm"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/tailscale/netlink"))
    (propagated-inputs (list go-github-com-vishvananda-netns
                             go-golang-org-x-sys))
    (home-page "https://github.com/tailscale/netlink")
    (synopsis "netlink - netlink library for go")
    (description
     "Package netlink provides a simple library for netlink.  Netlink is the interface
a user-space program in linux uses to communicate with the kernel.  It can be
used to add and remove interfaces, set up ip addresses and routes, and confiugre
ipsec.  Netlink communication requires elevated privileges, so in most cases
this code needs to be run as root.  The low level primitives for netlink are
contained in the nl subpackage.  This package attempts to provide a high-level
interface that is loosly modeled on the iproute2 cli.")
    (license license:asl2.0)))

(define-public go-github-com-creachadair-mds
  (package
    (name "go-github-com-creachadair-mds")
    (version "0.26.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/creachadair/mds")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "167bp59idkc26qhhqrp4ypxikijyq8zgag9z1g0vmp44jhi73vcz"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.25
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/creachadair/mds"))
    (propagated-inputs (list go-github-com-google-go-cmp))
    (home-page "https://github.com/creachadair/mds")
    (synopsis "mds")
    (description
     "This repository defines generic data structures and utility types in Go.")
    (license license:bsd-3)))

(define-public go-github-com-creachadair-msync
  (package
    (name "go-github-com-creachadair-msync")
    (version "0.8.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/creachadair/msync")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1z797dc0s99l7xf8zsbynwh1rjqw2w9119n81kjx39zkwrbmnc2w"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.25
      #:tests? #f
      #:import-path "github.com/creachadair/msync"))
    (propagated-inputs (list go-github-com-creachadair-mds))
    (home-page "https://github.com/creachadair/msync")
    (synopsis "msync")
    (description
     "Package msync defines some helpful types for managing concurrency.")
    (license license:bsd-3)))

(define-public go-github-com-tailscale-web-client-prebuilt
  (package
    (name "go-github-com-tailscale-web-client-prebuilt")
    (version "0.0.0-20251127225136-f19339b67368")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/web-client-prebuilt")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1q597ndz7m8sip3bxqxfjd7lm6h9wcrb3yl7lv9prrj2qlj79i01"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/tailscale/web-client-prebuilt"))
    (home-page "https://github.com/tailscale/web-client-prebuilt")
    (synopsis "web-client-prebuilt")
    (description
     "Package prebuilt provides the pre-built artifacts for the web client.")
    (license license:bsd-3)))

(define-public go-github-com-tailscale-wf
  (package
    (name "go-github-com-tailscale-wf")
    (version "0.0.0-20240214030419-6fbb0a674ee6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/wf")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07brxgalcg0kqwmywb9953a50zxmsg32zpx3d1sy7zb5dz020kv3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/tailscale/wf"))
    (propagated-inputs (list go-github-com-google-go-cmp
                             go-github-com-peterbourgon-ff-v3
                             go-go4-org-netipx go-golang-org-x-sys
                             go-honnef-co-go-tools))
    (home-page "https://github.com/tailscale/wf")
    (synopsis "wf")
    (description
     "This is a package for controlling the Windows Filtering Platform (WFP), also
known as the Windows firewall.")
    (license license:bsd-3)))

;; Tailscale 1.96.4 needs a newer gVisor than Guix's go-gvisor-dev-gvisor.
(define-public go-gvisor-dev-gvisor-for-tailscale
  (package
    (inherit go-gvisor-dev-gvisor)
    (version "0.0.0-20260224225140-573d5e7127a8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/gvisor")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name "go-gvisor-dev-gvisor" version))
       (sha256
        (base32 "1by1fblmbbg7kbqh4hciysg2jqj87plmfpyyn92ba6aivb1szbyr"))))))

(define-public go-github-com-tailscale-wireguard-go
  (package
    (name "go-github-com-tailscale-wireguard-go")
    (version "0.0.0-20251121194102-c6fd943bb437")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/wireguard-go")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02w9hc6vd7ynlgnwmfxbiqfbrw4zzddajz111fkr879d4ssrr8gy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.25
      #:tests? #f
      #:import-path "github.com/tailscale/wireguard-go"))
    (propagated-inputs (list go-golang-org-x-crypto go-golang-org-x-net
                             go-golang-org-x-sys go-golang-zx2c4-com-wintun
                             go-gvisor-dev-gvisor-for-tailscale))
    (home-page "https://github.com/tailscale/wireguard-go")
    (synopsis "Go Implementation of")
    (description "This is an implementation of @code{WireGuard} in Go.")
    (license license:gpl2)))

(define-public go-github-com-tc-hib-winres
  (package
    (name "go-github-com-tc-hib-winres")
    (version "0.3.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tc-hib/winres")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1sr4x8391jv96xv6b2ak2dlfl7p7fka5njz1p3y26bigw2420pxx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/tc-hib/winres"))
    (propagated-inputs (list go-github-com-nfnt-resize go-golang-org-x-image))
    (home-page "https://github.com/tc-hib/winres")
    (synopsis "winres")
    (description
     "Package winres provides functions to create a resource section for Windows
executables.  This is where the application's icon, manifest, and version
information are stored.")
    (license license:bsd-0)))

(define-public go-github-com-tcnksm-go-httpstat
  (package
    (name "go-github-com-tcnksm-go-httpstat")
    (version "0.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tcnksm/go-httpstat")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "18jn40ra97waxx1mf23pkh6rq46y0nqd7vi3zcx9cwc39zqaf9bc"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/tcnksm/go-httpstat"))
    (home-page "https://github.com/tcnksm/go-httpstat")
    (synopsis "go-httpstat")
    (description
     "Package httpstat traces HTTP latency infomation (DNSLookup, TCP Connection and
so on) on any golang HTTP request.  It uses `httptrace` package.  Just create
`go-httpstat` powered `context.Context` and give it your `http.Request` (no big
code modification is required).")
    (license license:expat)))

(define-public go-github-com-toqueteos-webbrowser
  (package
    (name "go-github-com-toqueteos-webbrowser")
    (version "1.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/toqueteos/webbrowser")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0bnn02zcfc9xkxc2qvv4q6wy5sipcwc0hwmx7hdhvv3lsw177flw"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/toqueteos/webbrowser"))
    (home-page "https://github.com/toqueteos/webbrowser")
    (synopsis "webbrowser")
    (description
     "Package webbrowser provides a simple API for opening web pages on your default
browser.")
    (license license:expat)))

(define-public go-github-com-bobuhiro11-gokvm
  (package
    (name "go-github-com-bobuhiro11-gokvm")
    (version "0.0.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bobuhiro11/gokvm")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1rg8zvi68lvyp3p943lzqjr9zqrwqbp2wjszwvc93gimhsky8x38"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/bobuhiro11/gokvm"))
    (home-page "https://github.com/bobuhiro11/gokvm")
    (synopsis "gokvm")
    (description
     "gokvm is a hypervisor that uses KVM as an acceleration.  It is implemented
completely in the Go language and has no dependencies other than the standard
library.  With @@strong{only 1.5k lines of code}, it can @@strong{boot Linux
5.10}, the latest version at the time, without any modifications (see
@@url{https://github.com/bobuhiro11/gokvm/releases/tag/v0.0.1,v0.0.1}).  It
includes naive and simple device emulation for serial console, virtio-net, and
virtio-blk.  The execution environment is limited to the x86-64 Linux
environment.  This should be useful for those who are interested in how to use
KVM from userland.  The latest version supports the following features:.")
    (license license:expat)))

(define-public go-github-com-florianl-go-tc
  (package
    (name "go-github-com-florianl-go-tc")
    (version "0.4.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/florianl/go-tc")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0nzy0yv3p9sl83n7s8x65df461i9wnn73gpm0qb8r46ia21qv197"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/florianl/go-tc"))
    (propagated-inputs (list go-github-com-cilium-ebpf
                             go-github-com-google-go-cmp
                             go-github-com-josharian-native
                             go-github-com-jsimonetti-rtnetlink
                             go-github-com-mdlayher-netlink
                             go-golang-org-x-sys))
    (home-page "https://github.com/florianl/go-tc")
    (synopsis "tc")
    (description
     "Package tc allows to show and alter traffic control settings in the Linux
kernel.")
    (license license:expat)))

(define-public go-github-com-hexdigest-gowrap
  (package
    (name "go-github-com-hexdigest-gowrap")
    (version "1.4.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hexdigest/gowrap")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ifid6hg0m67pjsbrchk3nnzwphh4m02plkff8bkaa0b3a7zb1jl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/hexdigest/gowrap"))
    (propagated-inputs (list go-github-com-masterminds-sprig-v3
                             go-github-com-pkg-errors
                             go-github-com-stretchr-testify
                             go-golang-org-x-text
                             go-golang-org-x-tools))
    (home-page "https://github.com/hexdigest/gowrap")
    (synopsis "GoWrap")
    (description
     "@code{GoWrap} is a command line tool that generates decorators for Go interface
types using simple templates.  With @code{GoWrap} you can easily add metrics,
tracing, fallbacks, pools, and many other features into your existing code in a
few seconds.")
    (license license:expat)))

(define-public go-github-com-gojuno-minimock-v3
  (package
    (name "go-github-com-gojuno-minimock-v3")
    (version "3.4.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gojuno/minimock")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0y9945x1iyl0h2xjh9wps1sgdg82jyiww0szd5iff67vpbbjc7hg"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gojuno/minimock/v3"
      #:unpack-path "github.com/gojuno/minimock"))
    (propagated-inputs (list go-github-com-davecgh-go-spew
                             go-github-com-gofrs-uuid-v5
                             go-github-com-hexdigest-gowrap
                             go-github-com-pkg-errors
                             go-github-com-pmezard-go-difflib
                             go-github-com-stretchr-testify
                             go-golang-org-x-text
                             go-golang-org-x-tools
                             go-google-golang-org-protobuf))
    (home-page "https://github.com/gojuno/minimock")
    (synopsis "Summary")
    (description
     "Package minimock is a command line tool that parses the input Go source file
that contains an interface declaration and generates implementation of this
interface that can be used as a mock.")
    (license license:expat)))

(define-public go-github-com-knz-catwalk
  (package
    (name "go-github-com-knz-catwalk")
    (version "0.1.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/knz/catwalk")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yn5n9b3a1rvdmliri5bs9wh6slbhdpj0s1qpw33k862v53a0gzw"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/knz/catwalk"))
    (propagated-inputs (list go-github-com-charmbracelet-bubbles
                             go-github-com-charmbracelet-bubbletea
                             go-github-com-charmbracelet-lipgloss
                             go-github-com-cockroachdb-datadriven
                             go-github-com-knz-lipgloss-convert
                             go-github-com-kr-pretty))
    (home-page "https://github.com/knz/catwalk")
    (synopsis "catwalk")
    (description
     "@@strong{catwalk} is a unit test library for
@@url{https://github.com/charmbracelet/bubbletea,Bubbletea} TUI models (a.k.a.
“bubbles”).")
    (license license:asl2.0)))

(define-public go-github-com-knz-bubbline
  (package
    (name "go-github-com-knz-bubbline")
    (version "0.0.0-20251201090646-433e881e9884")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/knz/bubbline")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "19xczfsrvcv6kq7pzs12vgmzqzgklpln13q0ih3wwg29b95dmiwx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/knz/bubbline"))
    (propagated-inputs (list go-github-com-atotto-clipboard
                             go-github-com-charmbracelet-bubbles
                             go-github-com-charmbracelet-bubbletea
                             go-github-com-charmbracelet-lipgloss
                             go-github-com-cockroachdb-datadriven
                             go-github-com-knz-catwalk
                             go-github-com-mattn-go-runewidth
                             go-github-com-muesli-reflow
                             go-github-com-muesli-termenv
                             go-golang-org-x-sys))
    (home-page "https://github.com/knz/bubbline")
    (synopsis "Bubbline")
    (description
     "An input line editor for line-oriented terminal applications.")
    (license license:asl2.0)))

(define-public go-github-com-nanmu42-limitio
  (package
    (name "go-github-com-nanmu42-limitio")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nanmu42/limitio")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "18by77hz7zmky1q0lx2v6xww695wmks45fbb4hjxs2zs4xjkgnca"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/nanmu42/limitio"))
    (home-page "https://github.com/nanmu42/limitio")
    (synopsis "LimitIO")
    (description
     "Package limitio brings `io.Reader` and `io.Writer` with limit.")
    (license license:expat)))

(define-public go-github-com-orangecms-go-framebuffer
  (package
    (name "go-github-com-orangecms-go-framebuffer")
    (version "0.0.0-20200613202404-a0700d90c330")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/orangecms/go-framebuffer")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "19n3mi5ghnyhjw8qjwcj3708bdvqvw124vch4g305yvilfsgfnn5"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/orangecms/go-framebuffer"))
    (home-page "https://github.com/orangecms/go-framebuffer")
    (synopsis "framebuffer")
    (description "Library for linux framebuffer device.")
    (license license:bsd-3)))

(define-public go-github-com-packetcap-go-pcap
  (package
    (name "go-github-com-packetcap-go-pcap")
    (version "0.0.0-20251215121130-f2cf9f991e7c")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/packetcap/go-pcap")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ksgvm8dlbx12bfwidcrm3ln7i388mv095vfbs6xrsl3fw86d01m"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/packetcap/go-pcap"))
    (propagated-inputs (list go-github-com-gopacket-gopacket
                             go-github-com-sirupsen-logrus
                             go-github-com-spf13-cobra go-golang-org-x-net
                             go-golang-org-x-sys))
    (home-page "https://github.com/packetcap/go-pcap")
    (synopsis "go-pcap")
    (description
     "This is a native go packet processing library.  It performs a function very
similar to @@url{https://github.com/the-tcpdump-group/libpcap,libpcap}, or, for
that matter,
@@url{https://github.com/packetcap/go-pcap/blob/f2cf9f991e7c/github.com/gopacket/gopacket/pcap,github.com/gopacket/gopacket/pcap},
except that it is 100% native go.  This means that:.")
    (license license:asl2.0)))

(define-public go-github-com-rck-unit
  (package
    (name "go-github-com-rck-unit")
    (version "0.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rck/unit")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qx0ri11p4rq93817wc992rk1d5brpab3q5yb0fxd4jshnhgdjgz"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/rck/unit"))
    (home-page "https://github.com/rck/unit")
    (synopsis "unit")
    (description
     "Package unit implements parsing for string values with units.")
    (license license:bsd-3)))

(define-public go-github-com-rekby-gpt
  (package
    (name "go-github-com-rekby-gpt")
    (version "0.0.0-20200614112001-7da10aec5566")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rekby/gpt")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m44xmsrgpd7836myqnyk6ffy3k2hpwhx4ri5mc7s0w6a1fkg904"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/rekby/gpt"))
    (home-page "https://github.com/rekby/gpt")
    (synopsis #f)
    (description #f)
    (license license:expat)))

(define-public go-github-com-ceph-go-ceph
  (package
    (name "go-github-com-ceph-go-ceph")
    (version "0.38.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ceph/go-ceph")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0iimxq1kxm9pdkwxc3r9jxbf7mzr2y6jn1zavwz36q3rrxak02ji"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/ceph/go-ceph"))
    (propagated-inputs (list go-github-com-aws-aws-sdk-go-v2
                             go-github-com-aws-aws-sdk-go-v2-config
                             go-github-com-aws-aws-sdk-go-v2-credentials
                             go-github-com-aws-aws-sdk-go-v2-service-s3
                             go-github-com-aws-smithy-go
                             go-github-com-gofrs-uuid-v5
                             go-github-com-stretchr-testify
                             go-golang-org-x-sys))
    (home-page "https://github.com/ceph/go-ceph")
    (synopsis "go-ceph - Go bindings for Ceph APIs")
    (description
     "Package ceph is the root of a set of packages that wrap the Ceph APIs.")
    (license license:expat)))

(define-public go-github-com-coreos-go-systemd
  (package
    (name "go-github-com-coreos-go-systemd")
    (version "0.0.0-20191104093116-d3cd4ed1dbcf")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/coreos/go-systemd")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "193mgqn7n4gbb8jb5kyn6ml4lbvh4xs55qpjnisaz7j945ik3kd8"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/coreos/go-systemd"))
    (home-page "https://github.com/coreos/go-systemd")
    (synopsis "go-systemd")
    (description "Go bindings to systemd.  The project has several packages:.")
    (license license:asl2.0)))

(define-public go-github-com-gostor-gotgt
  (package
    (name "go-github-com-gostor-gotgt")
    (version "0.2.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gostor/gotgt")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qr8aj6pq33f5xgr64dlrbvqgll9b3nyzk71w9hvw8d4z7sm3ap7"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gostor/gotgt"))
    (propagated-inputs (list go-github-com-ceph-go-ceph
                             go-github-com-coreos-go-systemd
                             go-github-com-docker-go-connections
                             go-github-com-gorilla-mux
                             go-github-com-satori-go-uuid
                             go-github-com-sirupsen-logrus
                             go-github-com-spf13-cobra
                             go-golang-org-x-net))
    (home-page "https://github.com/gostor/gotgt")
    (synopsis "gotgt")
    (description "SCSI target command line.")
    (license license:asl2.0)))

(define-public go-github-com-u-root-iscsinl
  (package
    (name "go-github-com-u-root-iscsinl")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/u-root/iscsinl")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17gpj08kzb6p980psx7f1zswdm0jl8andgsb7zhllrhpadsr9dy0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/u-root/iscsinl"))
    (propagated-inputs (list go-github-com-gostor-gotgt
                             go-github-com-vishvananda-netlink
                             go-golang-org-x-sys))
    (home-page "https://github.com/u-root/iscsinl")
    (synopsis "iscsinl")
    (description
     "Package iscsinl acts as an initiator for bootstrapping an iscsi connection
Partial implementation of RFC3720 login and NETLINK_ISCSI, just enough to get a
connection going.")
    (license license:bsd-3)))

(define-public go-github-com-vtolstov-go-ioctl
  (package
    (name "go-github-com-vtolstov-go-ioctl")
    (version "0.0.0-20151206205506-6be9cced4810")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/vtolstov/go-ioctl")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "11z60qlwci1vf08f5sibaw5hc0r3qh58cpq04886wr09kiipvnrv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/vtolstov/go-ioctl"))
    (home-page "https://github.com/vtolstov/go-ioctl")
    (synopsis "go-ioctl")
    (description
     "Documentation @@url{http://godoc.org/github.com/vtolstov/go-ioctl,(img (@@ (src
https://godoc.org/github.com/vtolstov/go-ioctl?status.svg) (alt
@code{GoDoc})))}.")
    (license license:expat)))

(define-public go-pack-ag-tftp
  (package
    (name "go-pack-ag-tftp")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/vcabbage/go-tftp")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "06sds166nw8486i81v5divclzj3ngfc91ii552xda82dvvy06g0z"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "pack.ag/tftp"))
    (home-page "https://pack.ag/tftp")
    (synopsis #f)
    (description
     "Package tftp provides TFTP client and server implementations.")
    (license license:expat)))

(define-public go-github-com-yusufpapurcu-wmi
  (package
    (name "go-github-com-yusufpapurcu-wmi")
    (version "1.2.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/yusufpapurcu/wmi")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1c6xjjad3zxddw8x910aiy5h9h8ndlal99cxn47ddrwn6c307rip"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/yusufpapurcu/wmi"))
    (propagated-inputs (list go-github-com-go-ole-go-ole))
    (home-page "https://github.com/yusufpapurcu/wmi")
    (synopsis "wmi")
    (description "Package wmi provides a WQL interface for WMI on Windows.")
    (license license:expat)))

(define-public go-github-com-jaypipes-ghw
  (package
    (name "go-github-com-jaypipes-ghw")
    (version "0.23.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jaypipes/ghw")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1sig4rd9a5dnmvlabgph969cbmd78bycxdwdvjw85yavw15hllx2"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/jaypipes/ghw"))
    (propagated-inputs (list go-github-com-jaypipes-pcidb
                             go-github-com-pkg-errors
                             go-github-com-spf13-cobra
                             go-github-com-stretchr-testify
                             go-github-com-yusufpapurcu-wmi
                             go-gopkg-in-yaml-v3
                             go-howett-net-plist))
    (home-page "https://github.com/jaypipes/ghw")
    (synopsis "- Go HardWare discovery/inspection library")
    (description
     "package ghw discovers hardware-related information about the host computer,
including CPU, memory, block storage, NUMA topology, network devices, PCI, GPU,
and baseboard/BIOS/chassis/product information.")
    (license license:asl2.0)))

(define-public go-github-com-u-root-cpuid
  (package
    (name "go-github-com-u-root-cpuid")
    (version "0.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/u-root/cpuid")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "18kpb807a81nhdqbhxc1nsy4ar9q66gw7k5rw1f333w5x5bdyaz3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/u-root/cpuid"))
    (home-page "https://github.com/u-root/cpuid")
    (synopsis "cpuid")
    (description
     "Package cpuid provides access to the information available through the CPUID
instruction.  All information is gathered during package initialization phase so
package's public interface doesn't call CPUID instruction.")
    (license license:bsd-3)))

(define-public go-github-com-hugelgupf-go-shlex
  (package
    (name "go-github-com-hugelgupf-go-shlex")
    (version "0.0.0-20200702092117-c80c9d0918fa")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hugelgupf/go-shlex")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02yx22myaz6w05m5xxfivbzxmljj1wzcj6hnni52jm44xc79hqp7"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/hugelgupf/go-shlex"))
    (home-page "https://github.com/hugelgupf/go-shlex")
    (synopsis "go-shlex")
    (description
     "Package shlex is a Unicode-supporting POSIX command-line argument parser.")
    (license license:bsd-3)))

(define-public go-github-com-u-root-gobusybox-src
  (package
    (name "go-github-com-u-root-gobusybox-src")
    (version "0.0.0-20250101170133-2e884e4509c7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/u-root/gobusybox")
             (commit (go-version->git-ref version
                                          #:subdir "src"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "184zh88q5f749cqb1c7ghsr2amxd89p26hh4n8xlrda87fj3aw4b"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/u-root/gobusybox/src"
      #:unpack-path "github.com/u-root/gobusybox"))
    (propagated-inputs (list go-github-com-dustin-go-humanize
                             go-github-com-hashicorp-go-version
                             go-github-com-u-root-uio
                             go-golang-org-x-exp
                             go-golang-org-x-tools
                             go-mvdan-cc-sh-v3))
    (home-page "https://github.com/u-root/gobusybox")
    (synopsis #f)
    (description #f)
    (license license:bsd-3)))

(define-public go-github-com-u-root-mkuimage
  (package
    (name "go-github-com-u-root-mkuimage")
    (version "0.0.0-20250905073043-9a40452f5d3b")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/u-root/mkuimage")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m5wpnrdsaknd1mjrl599vd8q9l57h8bfrqnx3qhk4fpc27vih3a"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/u-root/mkuimage"))
    (propagated-inputs (list go-github-com-dustin-go-humanize
                             go-github-com-google-go-cmp
                             go-github-com-hugelgupf-go-shlex
                             go-github-com-u-root-gobusybox-src
                             go-github-com-u-root-uio
                             go-golang-org-x-exp
                             go-golang-org-x-sync
                             go-golang-org-x-sys
                             go-gopkg-in-yaml-v3))
    (home-page "https://github.com/u-root/mkuimage")
    (synopsis "uimage")
    (description
     "uimage builds initramfs images composed of arbitrary Go commands and files.")
    (license license:bsd-3)))

(define-public go-github-com-creack-goselect
  (package
    (name "go-github-com-creack-goselect")
    (version "0.1.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/creack/goselect")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0h2a8nip8gzw9c6wkgdgxw1v86hcafmb7iihhxcxb4571mnzl7zc"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/creack/goselect"))
    (home-page "https://github.com/creack/goselect")
    (synopsis "go-select")
    (description "select(2) implementation in Go.")
    (license license:expat)))

(define-public go-go-bug-st-serial
  (package
    (name "go-go-bug-st-serial")
    (version "1.6.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bugst/go-serial")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "062iqzvfn1nvji6fd8053xlsfh9favxwkpgyhyxsk9r4gnv06xw9"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go.bug.st/serial"))
    (propagated-inputs (list go-github-com-creack-goselect
                             go-github-com-stretchr-testify
                             go-golang-org-x-sys))
    (home-page "https://go.bug.st/serial")
    (synopsis "go.bug.st/serial")
    (description
     "Package serial is a cross-platform serial library for the go language.")
    (license license:bsd-3)))

(define-public go-github-com-therootcompany-xz
  (package
    (name "go-github-com-therootcompany-xz")
    (version "1.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/therootcompany/xz")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1kzzgifx0n6rln7mv9z8naqf2dxdb3j2lp992g59adj86hpyvs2a"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/therootcompany/xz"))
    (home-page "https://github.com/therootcompany/xz")
    (synopsis "Xz")
    (description "Package xz implements XZ decompression natively in Go.")
    (license license:cc0)))

(define-public go-github-com-u-root-u-root
  (package
    (name "go-github-com-u-root-u-root")
    (version "0.15.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/u-root/u-root")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "09c3wmkgng143yab0qgc8li0sfaxn816pc3r37h8k7f847wqq6g4"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/u-root/u-root"))
    (propagated-inputs (list go-github-com-beevik-ntp
                             go-github-com-bobuhiro11-gokvm
                             go-github-com-cenkalti-backoff-v4
                             go-github-com-creack-pty
                             go-github-com-davecgh-go-spew
                             go-github-com-dustin-go-humanize
                             go-github-com-florianl-go-tc
                             go-github-com-gliderlabs-ssh
                             go-github-com-gojuno-minimock-v3
                             go-github-com-google-go-cmp
                             go-github-com-google-go-tpm
                             go-github-com-google-uuid
                             go-github-com-gopacket-gopacket
                             go-github-com-insomniacslk-dhcp
                             go-github-com-ishidawataru-sctp
                             go-github-com-jaypipes-ghw
                             go-github-com-kevinburke-ssh-config
                             go-github-com-klauspost-compress
                             go-github-com-klauspost-pgzip
                             go-github-com-knz-bubbline
                             go-github-com-mdlayher-vsock
                             go-github-com-nanmu42-limitio
                             go-github-com-netflix-go-expect
                             go-github-com-orangecms-go-framebuffer
                             go-github-com-packetcap-go-pcap
                             go-github-com-peterh-liner
                             go-github-com-pierrec-lz4-v4
                             go-github-com-pkg-sftp
                             go-github-com-protonmail-go-crypto
                             go-github-com-rck-unit
                             go-github-com-rekby-gpt
                             go-github-com-safchain-ethtool
                             go-github-com-sirupsen-logrus
                             go-github-com-spf13-pflag
                             go-github-com-therootcompany-xz
                             go-github-com-tklauser-go-sysconf
                             go-github-com-u-root-cpuid
                             go-github-com-u-root-gobusybox-src
                             go-github-com-u-root-iscsinl
                             go-github-com-u-root-mkuimage
                             go-github-com-u-root-uio
                             go-github-com-ulikunitz-xz
                             go-github-com-vishvananda-netlink
                             go-github-com-vishvananda-netns
                             go-github-com-vtolstov-go-ioctl
                             go-go-bug-st-serial
                             go-golang-org-x-crypto
                             go-golang-org-x-exp
                             go-golang-org-x-net
                             go-golang-org-x-sync
                             go-golang-org-x-sys
                             go-golang-org-x-term
                             go-golang-org-x-text
                             go-golang-org-x-tools
                             go-gopkg-in-yaml-v2
                             go-mvdan-cc-sh-v3
                             go-pack-ag-tftp))
    (home-page "https://github.com/u-root/u-root")
    (synopsis "u-root")
    (description
     "Command u-root builds CPIO archives with the given files and Go commands.")
    (license license:bsd-3)))

(define-public go-github-com-u-root-u-root-pkg-termios-0.14.0
  (package
    (inherit go-github-com-u-root-u-root)
    (name "go-github-com-u-root-u-root-pkg-termios-0.14.0")
    (version "0.14.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/u-root/u-root")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02iy126828psafg7i23g3p29786hkzwh7k5gf9acgr7qfyj3fc7k"))))
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/u-root/u-root/pkg/termios"
      #:unpack-path "github.com/u-root/u-root"))
    (propagated-inputs '())))

(define-public go-github-com-google-go-tpm-0.9.4
  (package
    (inherit go-github-com-google-go-tpm)
    (name "go-github-com-google-go-tpm-0.9.4")
    (version "0.9.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/go-tpm")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1sp1mbr6vz36zy9w36iksirbsj5p2jslsl8zs1cdj8s4ig4lkd9d"))))
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/google/go-tpm"))))

(define-public go-go4-org-mem
  (package
    (name "go-go4-org-mem")
    (version "0.0.0-20240501181205-ae6ca9944745")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go4org/mem")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1h2bam1h6xi0lx9s0k44fvd28vkb6rh9vndz3srhwi6axvm8ir0s"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go4.org/mem"))
    (home-page "https://go4.org/mem")
    (synopsis "go4.org/mem")
    (description
     "Package mem provides the mem.RO type that allows you to cheaply pass & access
either a read-only []byte or a string.")
    (license license:asl2.0)))

(define-public go-go4-org-netipx
  (package
    (name "go-go4-org-netipx")
    (version "0.0.0-20231129151722-fdeea329fbba")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go4org/netipx")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1g45hmdsgy6c73277j4i0mdi6031qbh5il1i5ab6bkywnpwhy9p4"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go4.org/netipx"))
    (propagated-inputs (list go-github-com-dvyukov-go-fuzz
                             go-honnef-co-go-tools))
    (home-page "https://go4.org/netipx")
    (synopsis "netipx")
    (description
     "Package netipx contains code and types that were left behind when the old
inet.af/netaddr package moved to the standard library in Go 1.18 as net/netip.")
    (license license:bsd-3)))

(define-public go-golang-zx2c4-com-wintun
  (package
    (name "go-golang-zx2c4-com-wintun")
    (version "0.0.0-20230126152724-0fa3db229ce2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://git.zx2c4.com/wintun-go")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "16ha3dpwq1bpbxrqfyb2pw09wn25iq27i9p58iaym7m768v0ncvj"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "golang.zx2c4.com/wintun"))
    (propagated-inputs (list go-golang-org-x-sys))
    (home-page "https://golang.zx2c4.com/wintun")
    (synopsis "wintun-go")
    (description
     "This contains bindings to use @@url{https://www.wintun.net,Wintun} from Go.")
    (license license:expat)))

(define-public go-github-com-go-ole-go-ole
  (package
    (name "go-github-com-go-ole-go-ole")
    (version "1.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-ole/go-ole")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1vr62wwjp206sxah2l79l007s7n187fjzkrnwb85ivqmazfjspxl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/go-ole/go-ole"))
    (propagated-inputs (list go-golang-org-x-sys))
    (home-page "https://github.com/go-ole/go-ole")
    (synopsis "Go OLE")
    (description
     "Go bindings for Windows COM using shared libraries instead of cgo.")
    (license license:expat)))

(define-public go-github-com-puzpuzpuz-xsync-v3
  (package
    (name "go-github-com-puzpuzpuz-xsync-v3")
    (version "3.5.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/puzpuzpuz/xsync")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0k2ir8ixr5h0rwfd4i0nxlgmcrklld06jcbp5ghxk6hpxrhzs1y8"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/puzpuzpuz/xsync/v3"
      #:unpack-path "github.com/puzpuzpuz/xsync/v3"))
    (home-page "https://github.com/puzpuzpuz/xsync")
    (synopsis "xsync")
    (description
     "Concurrent data structures for Go.  Aims to provide more scalable alternatives
for some of the data structures from the standard @@code{sync} package, but not
only.")
    (license license:asl2.0)))

(define-public go-github-com-hashicorp-raft
  (package
    (name "go-github-com-hashicorp-raft")
    (version "1.7.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/hashicorp/raft")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0yynmxqqc98vz3gfckky9wz0r9a4rw0mpdhw8w5nzj272wl6rjxl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/hashicorp/raft"))
    (propagated-inputs (list go-github-com-hashicorp-go-hclog
                             go-github-com-hashicorp-go-metrics
                             go-github-com-hashicorp-go-msgpack-v2
                             go-github-com-stretchr-testify))
    (home-page "https://github.com/hashicorp/raft")
    (synopsis "raft")
    (description
     "raft is a @@url{http://www.golang.org,Go} library that manages a replicated log
and can be used with an FSM to manage replicated state machines.  It is a
library for providing
@@url{http://en.wikipedia.org/wiki/Consensus_(computer_science),consensus}.")
    (license license:mpl2.0)))

(define-public go-github-com-puzpuzpuz-xsync-v4
  (package
    (name "go-github-com-puzpuzpuz-xsync-v4")
    (version "4.4.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/puzpuzpuz/xsync")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1r1lbfn82vgy3bybjslfkhmffs39yqy81r0za4bzqxhky73ff24x"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/puzpuzpuz/xsync/v4"
      #:unpack-path "github.com/puzpuzpuz/xsync/v4"))
    (home-page "https://github.com/puzpuzpuz/xsync")
    (synopsis "xsync")
    (description
     "Concurrent data structures for Go.  Aims to provide more scalable alternatives
for some of the data structures from the standard @@code{sync} package, but not
only.")
    (license license:asl2.0)))

(define-public go-github-com-aws-aws-sdk-go-v2-service-ssm
  (package
    (name "go-github-com-aws-aws-sdk-go-v2-service-ssm")
    (version "1.68.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/aws/aws-sdk-go-v2")
             (commit (go-version->git-ref version
                                          #:subdir "service/ssm"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yv4dnx28dblf5mp5fj81bpghvk5qlx7qsid285x64gy1swrlczx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/aws/aws-sdk-go-v2/service/ssm"
      #:unpack-path "github.com/aws/aws-sdk-go-v2"))
    (propagated-inputs (list go-github-com-aws-smithy-go))
    (home-page "https://github.com/aws/aws-sdk-go-v2")
    (synopsis #f)
    (description
     "Package ssm provides the API client, operations, and parameter types for Amazon
Simple Systems Manager (SSM).")
    (license license:asl2.0)))

(define-public go-github-com-envoyproxy-go-control-plane
  (package
    (name "go-github-com-envoyproxy-go-control-plane")
    (version "0.14.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/envoyproxy/go-control-plane")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "153z0jdbyhbcadiipl5631vnsg74m0fx7h1dmak4mqfjgdahxdvk"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/envoyproxy/go-control-plane"))
    (propagated-inputs (list go-github-com-google-go-cmp
                             go-github-com-stretchr-testify
                             go-go-uber-org-goleak
                             go-google-golang-org-genproto-googleapis-rpc
                             go-google-golang-org-grpc
                             go-google-golang-org-protobuf))
    (home-page "https://github.com/envoyproxy/go-control-plane")
    (synopsis "control-plane")
    (description
     "This repository contains a Go-based implementation of an API server that
implements the discovery service APIs defined in
@@url{https://github.com/envoyproxy/data-plane-api,data-plane-api}.")
    (license license:asl2.0)))

(define-public go-github-com-tailscale-peercred
  (package
    (name "go-github-com-tailscale-peercred")
    (version "0.0.0-20250107143737-35a0c7bd7edc")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/peercred")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0lcks6xxf1d6860h0x5bagjmbsbkycwhgg7y95qnzl2qvrv2zh4v"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/tailscale/peercred"))
    (propagated-inputs (list go-golang-org-x-sys))
    (home-page "https://github.com/tailscale/peercred")
    (synopsis "peercred")
    (description
     "Package peercred maps from a net.Conn to information about the other side of the
connection, using various OS-specific facilities.")
    (license license:bsd-3)))

(define-public go-github-com-invopop-jsonschema
  (package
    (name "go-github-com-invopop-jsonschema")
    (version "0.13.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/invopop/jsonschema")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0my5j2fycl0xf3vn02xzy6fr7dkf8nkn62f8y5i2xish69007vhm"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/invopop/jsonschema"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-github-com-wk8-go-ordered-map-v2))
    (home-page "https://github.com/invopop/jsonschema")
    (synopsis "Go JSON Schema Reflection")
    (description
     "Package jsonschema uses reflection to generate JSON Schemas from Go types [1].")
    (license license:expat)))

(define-public go-github-com-evanw-esbuild
  (package
    (name "go-github-com-evanw-esbuild")
    (version "0.27.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/evanw/esbuild")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vyhgq4fza72yw6hlczm8zw9fzgqx5xw85n1f55hbpwl325vq1s8"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:import-path "github.com/evanw/esbuild"))
    (propagated-inputs (list go-golang-org-x-sys))
    (home-page "https://github.com/evanw/esbuild")
    (synopsis "Why?")
    (description
     "@@url{https://esbuild.github.io/,Website} |
@@url{https://esbuild.github.io/getting-started/,Getting started} |
@@url{https://esbuild.github.io/api/,Documentation} |
@@url{https://esbuild.github.io/plugins/,Plugins} |
@@url{https://esbuild.github.io/faq/,FAQ}.")
    (license license:expat)))

(define-public go-gomodules-xyz-jsonpatch-v2
  (package
    (name "go-gomodules-xyz-jsonpatch-v2")
    (version "2.5.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gomodules/jsonpatch")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1a4f7q7lfpwq1ky1k3sfrvmskc64b9wizfn94wqa9kwb6v6j8b0l"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "gomodules.xyz/jsonpatch/v2"
      #:unpack-path "gomodules.xyz/jsonpatch"))
    (propagated-inputs (list go-github-com-evanphx-json-patch
                             go-github-com-stretchr-testify))
    (home-page "https://gomodules.xyz/jsonpatch")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-sigs-k8s-io-controller-runtime
  (package
    (name "go-sigs-k8s-io-controller-runtime")
    (version "0.23.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes-sigs/controller-runtime")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zqjphgmdadlj01p0s80ig0hpwb3y45fkmzca7bd9gpxlzbs0fjd"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
            #:import-path "sigs.k8s.io/controller-runtime"))
    (propagated-inputs (list go-github-com-evanphx-json-patch-v5
                             go-github-com-fsnotify-fsnotify
                             go-github-com-go-logr-logr
                             go-github-com-go-logr-zapr
                             go-github-com-google-btree
                             go-github-com-google-go-cmp
                             go-github-com-google-gofuzz
                             go-github-com-onsi-ginkgo-v2
                             go-github-com-onsi-gomega
                             go-github-com-prometheus-client-golang
                             go-github-com-prometheus-client-model
                             go-go-uber-org-goleak
                             go-go-uber-org-zap
                             go-golang-org-x-mod
                             go-golang-org-x-sync
                             go-golang-org-x-sys
                             go-gomodules-xyz-jsonpatch-v2
                             go-gopkg-in-evanphx-json-patch-v4
                             go-k8s-io-api
                             go-k8s-io-apiextensions-apiserver
                             go-k8s-io-apimachinery
                             go-k8s-io-apiserver
                             go-k8s-io-client-go
                             go-k8s-io-klog-v2
                             go-k8s-io-utils
                             go-sigs-k8s-io-structured-merge-diff-v6
                             go-sigs-k8s-io-yaml))
    (home-page "https://sigs.k8s.io/controller-runtime")
    (synopsis "Kubernetes controller-runtime Project")
    (description
     "Package controllerruntime provides tools to construct Kubernetes-style
controllers that manipulate both Kubernetes CRDs and aggregated/built-in
Kubernetes APIs.")
    (license license:asl2.0)))

(define-public go-github-com-gobuffalo-flect
  (package
    (name "go-github-com-gobuffalo-flect")
    (version "1.0.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gobuffalo/flect")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0lyb1876byv9q52y6dlq17aahwl108mhp67cmxykckjpxxykb442"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gobuffalo/flect"))
    (propagated-inputs (list go-github-com-stretchr-testify))
    (home-page "https://github.com/gobuffalo/flect")
    (synopsis "Flect")
    (description
     "Package flect is a new inflection engine to replace
[@@url{https://github.com/markbates/inflect,https://github.com/markbates/inflect}](@@url{https://github.com/markbates/inflect,https://github.com/markbates/inflect})
designed to be more modular, more readable, and easier to fix issues on than the
original.")
    (license license:expat)))

(define-public go-sigs-k8s-io-controller-tools
  (package
    (name "go-sigs-k8s-io-controller-tools")
    (version "0.20.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes-sigs/controller-tools")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0smkx8g65w5qmwyp6fri284aplzp1qdwl1pf9f3bigy6awb7nmvk"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
            #:import-path "sigs.k8s.io/controller-tools"))
    (propagated-inputs (list go-github-com-fatih-color
                             go-github-com-gobuffalo-flect
                             go-github-com-google-go-cmp
                             go-github-com-onsi-ginkgo
                             go-github-com-onsi-gomega
                             go-github-com-spf13-cobra
                             go-github-com-spf13-pflag
                             go-golang-org-x-tools
                             go-golang-org-x-tools-go-packages-packagestest
                             go-gopkg-in-yaml-v2
                             go-gopkg-in-yaml-v3
                             go-k8s-io-api
                             go-k8s-io-apiextensions-apiserver
                             go-k8s-io-apimachinery
                             go-k8s-io-apiserver
                             go-k8s-io-code-generator
                             go-k8s-io-gengo-v2
                             go-k8s-io-utils
                             go-sigs-k8s-io-yaml))
    (home-page "https://sigs.k8s.io/controller-tools")
    (synopsis "Kubernetes controller-tools Project")
    (description
     "The Kubernetes controller-tools Project is a set of go libraries for building
Controllers.")
    (license license:asl2.0)))

(define-public go-sigs-k8s-io-kind
  (package
    (name "go-sigs-k8s-io-kind")
    (version "0.31.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes-sigs/kind")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1mswyqpp0zla97cii7359nscwbi4994cqnqg2c74cji5zjsk09yy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "sigs.k8s.io/kind"))
    (propagated-inputs (list go-al-essio-dev-pkg-shellescape
                             go-github-com-burntsushi-toml
                             go-github-com-evanphx-json-patch-v5
                             go-github-com-mattn-go-isatty
                             go-github-com-pelletier-go-toml
                             go-github-com-pkg-errors
                             go-github-com-spf13-cobra
                             go-github-com-spf13-pflag
                             go-go-yaml-in-yaml-v3
                             go-sigs-k8s-io-yaml))
    (home-page "https://sigs.k8s.io/kind")
    (synopsis "Please see")
    (description
     "This package is a stub main wrapping @code{cmd/kind.Main()}.")
    (license license:asl2.0)))

(define-public go-github-com-aleksi-pointer
  (package
    (name "go-github-com-aleksi-pointer")
    (version "1.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/AlekSi/pointer")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0rncmanv62wwy7ihvjhvb695mkvy4kdzhgnn90zygs9yrfzzk0wk"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/AlekSi/pointer"))
    (home-page "https://github.com/AlekSi/pointer")
    (synopsis "pointer")
    (description
     "Package pointer provides helpers to convert between pointers and values of
built-in (and, with generics, of any) types.")
    (license license:expat)))

(define-public go-github-com-aws-aws-sdk-go-v2-feature-ec2-imds
  (package
    (name "go-github-com-aws-aws-sdk-go-v2-feature-ec2-imds")
    (version "1.18.18")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/aws/aws-sdk-go-v2")
             (commit (go-version->git-ref version
                                          #:subdir "feature/ec2/imds"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1yv4dnx28dblf5mp5fj81bpghvk5qlx7qsid285x64gy1swrlczx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/aws/aws-sdk-go-v2/feature/ec2/imds"
      #:unpack-path "github.com/aws/aws-sdk-go-v2"))
    (propagated-inputs (list go-github-com-aws-smithy-go))
    (home-page "https://github.com/aws/aws-sdk-go-v2")
    (synopsis #f)
    (description
     "Package imds provides the API client for interacting with the Amazon EC2
Instance Metadata Service.")
    (license license:asl2.0)))

(define-public go-github-com-tailscale-go-winio
  (package
    (name "go-github-com-tailscale-go-winio")
    (version "0.0.0-20231025203758-c4f33415bf55")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/go-winio")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "01hskfb66xiphhnfhrfgriz95nf99mapk7qn68v8k01nrp8vcmaq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/tailscale/go-winio"))
    (propagated-inputs (list go-github-com-sirupsen-logrus go-golang-org-x-sys
                             go-golang-org-x-tools))
    (home-page "https://github.com/tailscale/go-winio")
    (synopsis "go-winio")
    (description
     "This package provides utilities for efficiently performing Win32 IO operations
in Go.  Currently, this package is provides support for genreal IO and
management of.")
    (license license:expat)))

(define-public go-go-etcd-io-etcd-api-v3
  (package
    (name "go-go-etcd-io-etcd-api")
    (version "3.6.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/etcd-io/etcd")
             (commit (go-version->git-ref version
                                          #:subdir "api"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0dzcqr4k48pk55nks845vv058hm4rsiwi8qa32yqhrl7lbw11nkl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "go.etcd.io/etcd/api/v3"
      #:unpack-path "go.etcd.io/etcd"))
    (propagated-inputs (list go-github-com-coreos-go-semver
                             go-github-com-gogo-protobuf
                             go-github-com-golang-protobuf
                             go-github-com-grpc-ecosystem-grpc-gateway-v2
                             go-github-com-stretchr-testify
                             go-google-golang-org-genproto-googleapis-api
                             go-google-golang-org-grpc
                             go-google-golang-org-protobuf))
    (home-page "https://go.etcd.io/etcd")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-go-etcd-io-etcd-client-pkg-v3
  (package
    (name "go-go-etcd-io-etcd-client-pkg-v3")
    (version "3.6.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/etcd-io/etcd")
             (commit (go-version->git-ref version
                                          #:subdir "client/pkg"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0dzcqr4k48pk55nks845vv058hm4rsiwi8qa32yqhrl7lbw11nkl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "go.etcd.io/etcd/client/pkg/v3"
      #:unpack-path "go.etcd.io/etcd"))
    (propagated-inputs (list go-github-com-coreos-go-systemd-v22
                             go-github-com-stretchr-testify go-go-uber-org-zap
                             go-golang-org-x-sys))
    (home-page "https://go.etcd.io/etcd")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-go-etcd-io-etcd-client-v3
  (package
    (name "go-go-etcd-io-etcd-client-v3")
    (version "3.6.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/etcd-io/etcd")
             (commit (go-version->git-ref version
                                          #:subdir "client"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0dzcqr4k48pk55nks845vv058hm4rsiwi8qa32yqhrl7lbw11nkl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "go.etcd.io/etcd/client/v3"
      #:unpack-path "go.etcd.io/etcd"))
    (propagated-inputs (list go-github-com-coreos-go-semver
                        go-github-com-dustin-go-humanize
                        go-github-com-grpc-ecosystem-go-grpc-middleware-providers-prometheus
                        go-github-com-prometheus-client-golang
                        go-github-com-stretchr-testify
                        go-go-uber-org-zap
                        go-google-golang-org-grpc
                        go-sigs-k8s-io-yaml

                         go-github-com-coreos-go-semver
                             go-github-com-gogo-protobuf
                             go-github-com-golang-protobuf
                             go-github-com-grpc-ecosystem-grpc-gateway-v2
                             go-github-com-stretchr-testify
                             go-google-golang-org-genproto-googleapis-api
                             go-google-golang-org-grpc
                             go-google-golang-org-protobuf

                             go-github-com-coreos-go-systemd-v22
                             go-github-com-stretchr-testify go-go-uber-org-zap
                             go-golang-org-x-sys))
    (home-page "https://go.etcd.io/etcd")
    (synopsis "etcd/client/v3")
    (description
     "Package clientv3 implements the official Go etcd client for v3.")
    (license license:asl2.0)))

(define-public go-al-essio-dev-pkg-shellescape
  (package
    (name "go-al-essio-dev-pkg-shellescape")
    (version "1.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/alessio/shellescape")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0w9bzfl33115ddiswyfkxzli4pchyi96xlmy5rbya3issvcbgdkn"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "al.essio.dev/pkg/shellescape"))
    (propagated-inputs (list go-github-com-google-shlex))
    (home-page "https://al.essio.dev/pkg/shellescape")
    (synopsis "shellescape")
    (description
     "Package shellescape provides the shellescape.Quote to escape arbitrary strings
for a safe use as command line arguments in the most common POSIX shells.")
    (license license:expat)))

(define-public go-github-com-brianvoe-gofakeit-v6
  (package
    (name "go-github-com-brianvoe-gofakeit-v6")
    (version "6.28.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/brianvoe/gofakeit")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0yg33zl0vf54g0lhb4qvhl3ncicfcj2mij111wh5wzwydsqyqzk7"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/brianvoe/gofakeit/v6"
      #:unpack-path "github.com/brianvoe/gofakeit/v6"))
    (home-page "https://github.com/brianvoe/gofakeit")
    (synopsis "Gofakeit")
    (description
     "Package gofakeit provides a set of functions that generate random data.")
    (license license:expat)))

(define-public go-github-com-rodaine-protogofakeit
  (package
    (name "go-github-com-rodaine-protogofakeit")
    (version "0.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rodaine/protogofakeit")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0rk5bxbrl7q9jljw78ksxn7l45nsvry574bf98mcpxmwbx8f9izc"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/rodaine/protogofakeit"))
    (propagated-inputs (list go-github-com-brianvoe-gofakeit-v6
                             go-github-com-stretchr-testify
                             go-google-golang-org-protobuf))
    (home-page "https://github.com/rodaine/protogofakeit")
    (synopsis "protogofakeit")
    (description
     "Package protogofakeit provides a utility for producing fake data into Protocol
Buffer messages.")
    (license license:asl2.0)))

(define-public go-buf-build-go-protovalidate
  (package
    (name "go-buf-build-go-protovalidate")
    (version "1.1.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bufbuild/protovalidate-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0fz0fpj2b8k9pm3x1psms5cqp5cqs9m9qvqmvf5bvq9lz2gsgcvp"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:embed-files
      #~(list "authoring\\.tmpl")
      #:import-path "buf.build/go/protovalidate"))
    (propagated-inputs (list
                        go-buf-build-gen-go-bufbuild-protovalidate-protocolbuffers-go
                        ;; NOTE: Cyclic
                        ;; go-buf-build-go-hyperpb
                        go-github-com-brianvoe-gofakeit-v6
                        go-github-com-google-cel-go
                        go-github-com-google-go-cmp
                        go-github-com-rodaine-protogofakeit
                        go-github-com-stretchr-testify
                        go-google-golang-org-protobuf))
    (home-page "https://buf.build/go/protovalidate")
    (synopsis "protovalidate-go")
    (description
     "@@url{https://protovalidate.com/,Protovalidate} is the semantic validation
library for Protobuf.  It provides standard annotations to validate common rules
on messages and fields, as well as the ability to use @@url{https://cel.dev,CEL}
to write custom rules.  It's the next generation of
@@url{https://github.com/bufbuild/protoc-gen-validate,protoc-gen-validate}.")
    (license license:asl2.0)))

(define-public go-github-com-grpc-ecosystem-go-grpc-middleware-v2
  (package
    (name "go-github-com-grpc-ecosystem-go-grpc-middleware-v2")
    (version "2.3.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/grpc-ecosystem/go-grpc-middleware")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0qbh34r44sfw9s05kdipmz49fcgvlpnns20d0lbwvw9g3qwa095r"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/grpc-ecosystem/go-grpc-middleware/v2"
      #:unpack-path "github.com/grpc-ecosystem/go-grpc-middleware"))
    (propagated-inputs (list
                        go-buf-build-gen-go-bufbuild-protovalidate-protocolbuffers-go
                        go-buf-build-go-protovalidate
                        go-github-com-stretchr-testify
                        go-golang-org-x-net
                        go-golang-org-x-oauth2
                        go-google-golang-org-grpc
                        go-google-golang-org-protobuf))
    (home-page "https://github.com/grpc-ecosystem/go-grpc-middleware")
    (synopsis "Go gRPC Middleware")
    (description "Package middleware.")
    (license license:asl2.0)))

(define-public go-github-com-grpc-ecosystem-go-grpc-middleware-providers-prometheus
  (package
    (name
     "go-github-com-grpc-ecosystem-go-grpc-middleware-providers-prometheus")
    (version "1.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/grpc-ecosystem/go-grpc-middleware")
             (commit (go-version->git-ref version
                                          #:subdir "providers/prometheus"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0fr8z4dr9n1x6zgs2n7m2wd1j2wnnmig0xq099xcg5lvcxiqjv73"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path
      "github.com/grpc-ecosystem/go-grpc-middleware/providers/prometheus"
      #:unpack-path "github.com/grpc-ecosystem/go-grpc-middleware"))
    (propagated-inputs (list
                        go-github-com-grpc-ecosystem-go-grpc-middleware-v2
                        go-github-com-prometheus-client-golang
                        go-github-com-prometheus-client-model
                        go-github-com-stretchr-testify
                        go-google-golang-org-grpc))
    (home-page "https://github.com/grpc-ecosystem/go-grpc-middleware")
    (synopsis #f)
    (description
     "Package prometheus provides a standalone interceptor for metrics.  It's next
iteration of deprecated
@@url{https://github.com/grpc-ecosystem/go-grpc-prometheus,https://github.com/grpc-ecosystem/go-grpc-prometheus}.
 See
@@url{https://github.com/grpc-ecosystem/go-grpc-middleware/tree/main/examples,https://github.com/grpc-ecosystem/go-grpc-middleware/tree/main/examples}
for example.")
    (license license:asl2.0)))

(define-public go-github-com-soheilhy-cmux
  (package
    (name "go-github-com-soheilhy-cmux")
    (version "0.1.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/soheilhy/cmux")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17zpa45xvmk3jl1qqx3lkqdyxs6hdczpv7hwg4s7x0895jx3zl5y"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/soheilhy/cmux"))
    (propagated-inputs (list go-golang-org-x-net))
    (home-page "https://github.com/soheilhy/cmux")
    (synopsis "cmux: Connection Mux")
    (description
     "Package cmux is a library to multiplex network connections based on their
payload.  Using cmux, you can serve different protocols from the same listener.")
    (license license:asl2.0)))

(define-public go-github-com-tmc-grpc-websocket-proxy
  (package
    (name "go-github-com-tmc-grpc-websocket-proxy")
    (version "0.0.0-20220101234140-673ab2c3ae75")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tmc/grpc-websocket-proxy")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0299q3njcs6smrac6734xfjslpvwvsc8jyh5fq5849cdlp5a8290"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/tmc/grpc-websocket-proxy"))
    (propagated-inputs (list go-github-com-gorilla-websocket
                             go-github-com-sirupsen-logrus go-golang-org-x-net))
    (home-page "https://github.com/tmc/grpc-websocket-proxy")
    (synopsis "grpc-websocket-proxy")
    (description
     "Wrap your grpc-gateway mux with this helper to expose streaming endpoints over
websockets.")
    (license license:expat)))

(define-public go-github-com-xiang90-probing
  (package
    (name "go-github-com-xiang90-probing")
    (version "0.0.0-20221125231312-a49e3df8f510")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xiang90/probing")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1w0pwy8fzxfqnsjzl28jy08di58kwag48vlj4yj9hls77qgbr9ar"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/xiang90/probing"))
    (home-page "https://github.com/xiang90/probing")
    (synopsis "Getting Started")
    (description "We first need to serve the probing HTTP handler.")
    (license license:expat)))

(define-public go-go-etcd-io-raft-v3
  (package
    (name "go-go-etcd-io-raft-v3")
    (version "3.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/etcd-io/raft")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "18d9l8739irzgl0860qrrmdn3aqhc92lhc9brv8lkq7n59gxqd6i"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "go.etcd.io/raft/v3"
      #:unpack-path "go.etcd.io/raft"))
    (propagated-inputs (list go-github-com-cockroachdb-datadriven
                             go-github-com-gogo-protobuf
                             go-github-com-golang-protobuf
                             go-github-com-stretchr-testify))
    (home-page "https://go.etcd.io/raft")
    (synopsis "Raft library")
    (description
     "Package raft sends and receives messages in the Protocol Buffer format defined
in the raftpb package.")
    (license license:asl2.0)))

(define-public go-go-etcd-io-etcd-server-v3
  (package
    (name "go-go-etcd-io-etcd-server-v3")
    (version "3.6.8")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/etcd-io/etcd")
             (commit (go-version->git-ref version
                                          #:subdir "server"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0dzcqr4k48pk55nks845vv058hm4rsiwi8qa32yqhrl7lbw11nkl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "go.etcd.io/etcd/server/v3"
      #:unpack-path "go.etcd.io/etcd"))
    (propagated-inputs (list go-github-com-coreos-go-semver
                        go-github-com-coreos-go-systemd-v22
                        go-github-com-dustin-go-humanize
                        go-github-com-gogo-protobuf
                        go-github-com-golang-groupcache
                        go-github-com-golang-jwt-jwt-v5
                        go-github-com-golang-protobuf
                        go-github-com-google-btree
                        go-github-com-google-go-cmp
                        go-github-com-grpc-ecosystem-go-grpc-middleware-v2
                        go-github-com-grpc-ecosystem-go-grpc-middleware-providers-prometheus
                        go-github-com-grpc-ecosystem-grpc-gateway-v2
                        go-github-com-jonboulle-clockwork
                        go-github-com-prometheus-client-golang
                        go-github-com-prometheus-client-model
                        go-github-com-soheilhy-cmux
                        go-github-com-spf13-cobra
                        go-github-com-stretchr-testify
                        go-github-com-tmc-grpc-websocket-proxy
                        go-github-com-xiang90-probing
                        go-go-etcd-io-bbolt
                        go-go-etcd-io-raft-v3
                        go-go-opentelemetry-io-contrib-instrumentation-google-golang-org-grpc-otelgrpc
                        go-go-opentelemetry-io-otel
                        go-go-opentelemetry-io-otel-exporters-otlp-otlptrace-otlptracegrpc
                        go-go-opentelemetry-io-otel-sdk
                        go-go-uber-org-zap
                        go-golang-org-x-crypto
                        go-golang-org-x-net
                        go-golang-org-x-time
                        go-google-golang-org-genproto-googleapis-api
                        go-google-golang-org-grpc
                        go-google-golang-org-protobuf
                        go-gopkg-in-natefinch-lumberjack-v2
                        go-sigs-k8s-io-json
                        go-sigs-k8s-io-yaml))
    (home-page "https://go.etcd.io/etcd")
    (synopsis #f)
    (description
     "Package main is a simple wrapper of the real etcd entrypoint package (located at
go.etcd.io/etcd/etcdmain) to ensure that etcd is still \"go getable\"; e.g. `go
get go.etcd.io/etcd` works as expected and builds a binary in $GOBIN/etcd.")
    (license license:asl2.0)))

(define-public go-k8s-io-kms
  (package
    (name "go-k8s-io-kms")
    (version "0.35.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/kms")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03xq8scdg4qjhc4gjnl3z3b1f4lv75i07jx7klpcmzr6cdws3kk8"))))
    (build-system go-build-system)
    (arguments
     (list
            #:import-path "k8s.io/kms"))
    (propagated-inputs (list go-google-golang-org-grpc
                             go-google-golang-org-protobuf))
    (home-page "https://k8s.io/kms")
    (synopsis "KMS")
    (description "Package kms contains the proto definitions for the kms API.")
    (license license:asl2.0)))

(define-public go-sigs-k8s-io-apiserver-network-proxy-konnectivity-client
  (package
    (name "go-sigs-k8s-io-apiserver-network-proxy-konnectivity-client")
    (version "0.34.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes-sigs/apiserver-network-proxy")
             (commit (go-version->git-ref version
                                          #:subdir "konnectivity-client"
))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1kh92blfpmrmklxqg5j0p07yz534gjzhm44xj8bh5pad3y5zw5m0"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "sigs.k8s.io/apiserver-network-proxy/konnectivity-client"
      #:unpack-path "sigs.k8s.io/apiserver-network-proxy"))
    (propagated-inputs (list go-github-com-prometheus-client-golang
                             go-go-uber-org-goleak go-google-golang-org-grpc
                             go-google-golang-org-protobuf go-k8s-io-klog-v2))
    (home-page "https://sigs.k8s.io/apiserver-network-proxy")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-k8s-io-apiserver
  (package
    (name "go-k8s-io-apiserver")
    (version "0.35.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/apiserver")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03l54mif0c25w2z9m7dgmjf3j3x7ha8sfiih9yxkbd6kg1lxkgqv"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
            #:import-path "k8s.io/apiserver"))
    (propagated-inputs (list go-github-com-blang-semver-v4
                        go-github-com-coreos-go-oidc
                        go-github-com-coreos-go-systemd-v22
                        go-github-com-emicklei-go-restful-v3
                        go-github-com-fsnotify-fsnotify
                        go-github-com-go-logr-logr
                        go-github-com-google-btree
                        go-github-com-google-cel-go
                        go-github-com-google-gnostic-models
                        go-github-com-google-go-cmp
                        go-github-com-google-uuid
                        go-github-com-gorilla-websocket
                        go-github-com-grpc-ecosystem-go-grpc-prometheus
                        go-github-com-munnerz-goautoneg
                        go-github-com-mxk-go-flowrate
                        go-github-com-spf13-pflag
                        go-github-com-stretchr-testify
                        go-go-etcd-io-etcd-api-v3
                        go-go-etcd-io-etcd-client-pkg-v3
                        go-go-etcd-io-etcd-client-v3
                        go-go-etcd-io-etcd-server-v3
                        go-go-opentelemetry-io-contrib-instrumentation-google-golang-org-grpc-otelgrpc
                        go-go-opentelemetry-io-contrib-instrumentation-net-http-otelhttp
                        go-go-opentelemetry-io-otel
                        go-go-opentelemetry-io-otel-exporters-otlp-otlptrace-otlptracegrpc
                        go-go-opentelemetry-io-otel-metric
                        go-go-opentelemetry-io-otel-sdk
                        go-go-opentelemetry-io-otel-trace
                        go-go-uber-org-zap
                        go-golang-org-x-crypto
                        go-golang-org-x-net
                        go-golang-org-x-sync
                        go-golang-org-x-sys
                        go-golang-org-x-text
                        go-golang-org-x-time
                        go-google-golang-org-genproto-googleapis-api
                        go-google-golang-org-grpc
                        go-google-golang-org-protobuf
                        go-gopkg-in-evanphx-json-patch-v4
                        go-gopkg-in-go-jose-go-jose-v2
                        go-gopkg-in-natefinch-lumberjack-v2
                        go-k8s-io-api
                        go-k8s-io-apimachinery
                        go-k8s-io-client-go
                        go-k8s-io-component-base
                        go-k8s-io-klog-v2
                        go-k8s-io-kms
                        go-k8s-io-kube-openapi
                        go-k8s-io-utils
                        go-sigs-k8s-io-apiserver-network-proxy-konnectivity-client
                        go-sigs-k8s-io-json
                        go-sigs-k8s-io-randfill
                        go-sigs-k8s-io-structured-merge-diff-v6
                        go-sigs-k8s-io-yaml))
    (home-page "https://k8s.io/apiserver")
    (synopsis "apiserver")
    (description
     "Package apiserver provides the machinery for building Kubernetes-style API
servers.")
    (license license:asl2.0)))

(define-public go-k8s-io-code-generator
  (package
    (name "go-k8s-io-code-generator")
    (version "0.35.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/code-generator")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0yqyvzpivxgg6772i5cs2n9wd9c6cq8amy7yl95hdw9jsp9q659n"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
            #:import-path "k8s.io/code-generator"))
    (propagated-inputs (list go-github-com-gogo-protobuf
                             go-github-com-google-gnostic-models
                             go-github-com-google-go-cmp
                             go-github-com-spf13-pflag
                             go-go-yaml-in-yaml-v2
                             go-golang-org-x-text
                             go-k8s-io-apimachinery
                             go-k8s-io-gengo-v2
                             go-k8s-io-klog-v2
                             go-k8s-io-kube-openapi
                             go-k8s-io-utils
                             go-sigs-k8s-io-randfill))
    (home-page "https://k8s.io/code-generator")
    (synopsis "code-generator")
    (description
     "Golang code-generators used to implement
@@url{https://git.k8s.io/community/contributors/devel/sig-architecture/api-conventions.md,Kubernetes-style
API types}.")
    (license license:asl2.0)))

(define-public go-github-com-go-logr-zapr
  (package
    (name "go-github-com-go-logr-zapr")
    (version "1.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go-logr/zapr")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07kg9h853jijfc86zm07856sisac6jwvn06gbk694fg00mj1806f"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/go-logr/zapr"))
    (propagated-inputs (list go-github-com-go-logr-logr
                             go-github-com-stretchr-testify go-go-uber-org-zap))
    (home-page "https://github.com/go-logr/zapr")
    (synopsis "Zapr ⚡")
    (description
     "Package zapr defines an implementation of the github.com/go-logr/logr interfaces
built on top of Zap (go.uber.org/zap).")
    (license license:asl2.0)))

(define-public go-k8s-io-component-base
  (package
    (name "go-k8s-io-component-base")
    (version "0.35.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/component-base")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0xy49sxji6zy8ym327zqp2rx6l1sisbi09k4d63gvvnm2ljnj7i6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
            #:import-path "k8s.io/component-base"))
    (propagated-inputs (list go-github-com-blang-semver-v4
                        go-github-com-go-logr-logr
                        go-github-com-go-logr-zapr
                        go-github-com-google-go-cmp
                        go-github-com-moby-term
                        go-github-com-prometheus-client-golang
                        go-github-com-prometheus-client-model
                        go-github-com-prometheus-common
                        go-github-com-prometheus-procfs
                        go-github-com-spf13-cobra
                        go-github-com-spf13-pflag
                        go-github-com-stretchr-testify
                        go-go-opentelemetry-io-contrib-instrumentation-net-http-otelhttp
                        go-go-opentelemetry-io-otel
                        go-go-opentelemetry-io-otel-exporters-otlp-otlptrace-otlptracegrpc
                        go-go-opentelemetry-io-otel-sdk
                        go-go-opentelemetry-io-otel-trace
                        go-go-uber-org-zap
                        go-go-yaml-in-yaml-v2
                        go-golang-org-x-sys
                        go-golang-org-x-text
                        go-k8s-io-apimachinery
                        go-k8s-io-client-go
                        go-k8s-io-klog-v2
                        go-k8s-io-utils
                        go-sigs-k8s-io-json))
    (home-page "https://k8s.io/component-base")
    (synopsis "component-base")
    (description
     "Implement KEP 32:
@@url{https://github.com/kubernetes/enhancements/blob/master/keps/sig-cluster-lifecycle/wgs/783-component-base/README.md,https://github.com/kubernetes/enhancements/blob/master/keps/sig-cluster-lifecycle/wgs/783-component-base/README.md}.")
    (license license:asl2.0)))

(define-public go-k8s-io-apiextensions-apiserver
  (package
    (name "go-k8s-io-apiextensions-apiserver")
    (version "0.35.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kubernetes/apiextensions-apiserver")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1z2knn2xqkhlnph1qfw0682v0xq508q36pmp8rcgq97dj9wjf8y8"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
            #:import-path "k8s.io/apiextensions-apiserver"))
    (propagated-inputs (list go-github-com-emicklei-go-restful-v3
                             go-github-com-fxamacker-cbor-v2
                             go-github-com-google-cel-go
                             go-github-com-google-gnostic-models
                             go-github-com-google-go-cmp
                             go-github-com-google-uuid
                             go-github-com-spf13-cobra
                             go-github-com-spf13-pflag
                             go-github-com-stretchr-testify
                             go-go-etcd-io-etcd-client-pkg-v3
                             go-go-etcd-io-etcd-client-v3
                             go-go-opentelemetry-io-otel
                             go-go-opentelemetry-io-otel-trace
                             go-go-yaml-in-yaml-v2
                             go-golang-org-x-sync
                             go-golang-org-x-text
                             go-google-golang-org-grpc
                             go-google-golang-org-protobuf
                             go-gopkg-in-evanphx-json-patch-v4
                             go-k8s-io-api
                             go-k8s-io-apimachinery
                             go-k8s-io-apiserver
                             go-k8s-io-client-go
                             go-k8s-io-code-generator
                             go-k8s-io-component-base
                             go-k8s-io-klog-v2
                             go-k8s-io-kube-openapi
                             go-k8s-io-utils
                             go-sigs-k8s-io-json
                             go-sigs-k8s-io-randfill
                             go-sigs-k8s-io-structured-merge-diff-v6
                             go-sigs-k8s-io-yaml))
    (home-page "https://k8s.io/apiextensions-apiserver")
    (synopsis "apiextensions-apiserver")
    (description
     "Implements:
@@url{https://github.com/kubernetes/design-proposals-archive/blob/main/api-machinery/thirdpartyresources.md,https://github.com/kubernetes/design-proposals-archive/blob/main/api-machinery/thirdpartyresources.md}.")
    (license license:asl2.0)))

(define-public go-github-com-go4org-plan9netshell
  (package
    (name "go-github-com-go4org-plan9netshell")
    (version "0.0.0-20250324183649-788daa080737")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go4org/plan9netshell")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bf4z97hlmrny3yq7rjm2srl03gdnpqc0f6c7b966amnx8ivhlk3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/go4org/plan9netshell"))
    (propagated-inputs (list go-9fans-net-go))
    (home-page "https://github.com/go4org/plan9netshell")
    (synopsis "plan9netshell")
    (description
     "Package plan9netshell is a fork of 9fans net shell example turned into a Go
library package.")
    (license license:bsd-3)))

(define-public go-github-com-prometheus-community-pro-bing
  (package
    (name "go-github-com-prometheus-community-pro-bing")
    (version "0.4.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/prometheus-community/pro-bing")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1n0vyrrb53l408ndyzydm0bh8iyqv95p1lzcvvq88f1r3z0g8cfx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "github.com/prometheus-community/pro-bing"))
    (propagated-inputs (list go-github-com-google-uuid go-golang-org-x-net
                             go-golang-org-x-sync))
    (home-page "https://github.com/prometheus-community/pro-bing")
    (synopsis "pro-bing")
    (description
     "Package probing is a simple but powerful ICMP echo (ping) library.")
    (license license:expat)))

(define-public go-github-com-tailscale-xnet
  (package
    (name "go-github-com-tailscale-xnet")
    (version "0.0.0-20240729143630-8497ac4dab2e")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/xnet")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0rca6xkmkf8ax50dgb165xm0kd20r39vp3xklfc15pfwachj9hw5"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
      #:import-path "github.com/tailscale/xnet"))
    (propagated-inputs (list go-golang-org-x-crypto
                             go-golang-org-x-sys
                             go-golang-org-x-term
                             go-golang-org-x-text))
    (home-page "https://github.com/tailscale/xnet")
    (synopsis "Temporary dev fork of golang.org/x/net")
    (description
     "This package is a temporary development fork of @code{golang.org/x/net}.")
    (license license:bsd-3)))

(define-public go-gopkg-in-square-go-jose-v2
  (package
    (name "go-gopkg-in-square-go-jose-v2")
    (version "2.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/square/go-jose")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1b1nhqxfmhzwrfk7pkvp2w3z3d0pf5ir00vizmy2d4xdbnldn70r"))))
    (build-system go-build-system)
    (arguments
     (list
      #:tests? #f
      #:import-path "gopkg.in/square/go-jose.v2"))
    (propagated-inputs (list go-golang-org-x-crypto
                             go-gopkg-in-alecthomas-kingpin-v2))
    (home-page "https://github.com/square/go-jose")
    (synopsis "Implementation of JOSE standards (JWE, JWS, JWT) in Go")
    (description
     "This package provides a Golang implementation of JOSE standards, including
JSON Web Encryption, JSON Web Signature, and JSON Web Token.")
    (license license:asl2.0)))

;; Additional package definitions required by existing propagated-inputs.

(define-public go-buf-build-gen-go-bufbuild-protovalidate-protocolbuffers-go
  (package
    (inherit go-google-golang-org-protobuf)
    (name "go-buf-build-gen-go-bufbuild-protovalidate-protocolbuffers-go")))

(define-public go-tailscale-com
  (package
    (name "go-tailscale-com")
    (version "1.96.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/tailscale/tailscale")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0qqlj6cq43h0pr8jg9g956yz5xgg81959vq2kl7n9yqnixyh8w2n"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:tests? #f
            #:import-path "tailscale.com"))
    (propagated-inputs (list go-filippo-io-mkcert
                        go-fyne-io-systray
                        go-github-com-akutz-memconn
                        go-github-com-aleksi-pointer
                        go-github-com-alexbrainman-sspi
                        go-github-com-andybalholm-brotli
                        go-github-com-anmitsu-go-shlex
                        go-github-com-atotto-clipboard
                        go-github-com-aws-aws-sdk-go-v2
                        go-github-com-aws-aws-sdk-go-v2-config
                        go-github-com-aws-aws-sdk-go-v2-feature-ec2-imds
                        go-github-com-aws-aws-sdk-go-v2-feature-s3-manager
                        go-github-com-aws-aws-sdk-go-v2-service-s3
                        go-github-com-aws-aws-sdk-go-v2-service-ssm
                        go-github-com-aws-aws-sdk-go-v2-service-sts
                        go-github-com-aws-smithy-go
                        go-github-com-axiomhq-hyperloglog
                        go-github-com-bradfitz-go-tool-cache
                        go-github-com-bramvdbogaerde-go-scp
                        go-github-com-cilium-ebpf
                        go-github-com-coder-websocket
                        go-github-com-coreos-go-iptables
                        go-github-com-coreos-go-systemd
                        go-github-com-creachadair-msync
                        go-github-com-creachadair-taskgroup
                        go-github-com-creack-pty
                        go-github-com-dblohm7-wingoes
                        go-github-com-digitalocean-go-smbios
                        go-github-com-distribution-reference
                        go-github-com-djherbis-times
                        go-github-com-dsnet-try
                        go-github-com-elastic-crd-ref-docs
                        go-github-com-evanw-esbuild
                        go-github-com-fogleman-gg
                        go-github-com-frankban-quicktest
                        go-github-com-fsnotify-fsnotify
                        go-github-com-fxamacker-cbor-v2
                        go-github-com-gaissmai-bart
                        go-github-com-go-json-experiment-json
                        go-github-com-go-logr-zapr
                        go-github-com-go-ole-go-ole
                        go-github-com-go4org-plan9netshell
                        go-github-com-godbus-dbus-v5
                        go-github-com-golang-groupcache
                        go-github-com-golang-snappy
                        go-github-com-google-go-cmp
                        go-github-com-google-go-containerregistry
                        go-github-com-google-go-tpm-0.9.4
                        go-github-com-google-gopacket
                        go-github-com-google-nftables
                        go-github-com-google-uuid
                        go-github-com-goreleaser-nfpm-v2
                        go-github-com-gorilla-csrf
                        go-github-com-hashicorp-go-hclog
                        go-github-com-hashicorp-raft
                        go-github-com-hdevalence-ed25519consensus
                        go-github-com-huin-goupnp
                        go-github-com-illarion-gonotify-v3
                        go-github-com-inetaf-tcpproxy
                        go-github-com-insomniacslk-dhcp
                        go-github-com-jellydator-ttlcache-v3
                        go-github-com-jsimonetti-rtnetlink
                        go-github-com-kballard-go-shellquote
                        go-github-com-klauspost-compress
                        go-github-com-kodeworks-golang-image-ico
                        go-github-com-kortschak-wol
                        go-github-com-mattn-go-colorable
                        go-github-com-mattn-go-isatty
                        go-github-com-mdlayher-genetlink
                        go-github-com-mdlayher-netlink
                        go-github-com-mdlayher-sdnotify
                        go-github-com-mdlayher-socket
                        go-github-com-miekg-dns
                        go-github-com-mitchellh-go-ps
                        go-github-com-peterbourgon-ff-v3
                        go-github-com-pires-go-proxyproto
                        go-github-com-pkg-errors
                        go-github-com-pkg-sftp
                        go-github-com-prometheus-client-golang
                        go-github-com-prometheus-client-model
                        go-github-com-prometheus-common
                        go-github-com-prometheus-community-pro-bing
                        go-github-com-prometheus-prometheus
                        go-github-com-safchain-ethtool
                        go-github-com-skip2-go-qrcode
                        go-github-com-stretchr-testify
                        go-github-com-studio-b12-gowebdav
                        go-github-com-tailscale-certstore
                        go-github-com-tailscale-depaware
                        go-github-com-tailscale-go-winio
                        go-github-com-tailscale-goexpect
                        go-github-com-tailscale-golang-x-crypto
                        go-github-com-tailscale-hujson
                        go-github-com-tailscale-mkctr
                        go-github-com-tailscale-netlink
                        go-github-com-tailscale-peercred
                        go-github-com-tailscale-web-client-prebuilt
                        go-github-com-tailscale-wf
                        go-github-com-tailscale-wireguard-go
                        go-github-com-tailscale-xnet
                        go-github-com-tc-hib-winres
                        go-github-com-tcnksm-go-httpstat
                        go-github-com-toqueteos-webbrowser
                        go-github-com-vishvananda-netns
                        go-go-uber-org-zap
                        go-go4-org-mem
                        go-go4-org-netipx
                        go-golang-org-x-crypto
                        go-golang-org-x-exp
                        go-golang-org-x-mod
                        go-golang-org-x-net
                        go-golang-org-x-oauth2
                        go-golang-org-x-sync
                        go-golang-org-x-sys
                        go-golang-org-x-term
                        go-golang-org-x-time
                        go-golang-org-x-tools
                        go-golang-zx2c4-com-wintun
                        go-gopkg-in-square-go-jose-v2
                        go-gopkg-in-yaml-v3
                        go-gvisor-dev-gvisor-for-tailscale
                        go-honnef-co-go-tools
                        go-k8s-io-api
                        go-k8s-io-apiextensions-apiserver
                        go-k8s-io-apimachinery
                        go-k8s-io-apiserver
                        go-k8s-io-client-go
                        go-k8s-io-utils
                        go-sigs-k8s-io-controller-runtime
                        go-sigs-k8s-io-controller-tools
                        go-sigs-k8s-io-kind
                        go-sigs-k8s-io-yaml
                        go-software-sslmate-com-src-go-pkcs12))
    (home-page "https://tailscale.com")
    (synopsis "Tailscale")
    (description "Package tailscaleroot embeds VERSION.txt into the binary.")
    (license license:bsd-3)))

(define (tailscale-version-build-flags version)
  ;; Guix builds outside a Git checkout, so Tailscale cannot infer this from
  ;; Go's VCS build info.
  #~(list (string-append "-ldflags=-X tailscale.com/version.longStamp=" #$version
                         " -X tailscale.com/version.shortStamp=" #$version)))

(define-public tailscale
  (package
    (inherit go-tailscale-com)
    (name "tailscale")
    ;; Match official Guix command packages such as go-staticcheck and
    ;; protoc-gen-go-grpc: move the repo-root source package's propagated Go
    ;; graph to native-inputs for the end-user command package, or the
    ;; build-time closure leaks into profile hooks and can even reproduce the
    ;; "gdk-pixbuf-loaders-cache-file.drv' failed due to signal 11" crash we
    ;; saw from the oversized generated builder here.
    (native-inputs (package-propagated-inputs go-tailscale-com))
    (propagated-inputs '())
    (inputs '())
    (arguments (list
                #:go go-1.26
                #:tests? #f
                #:install-source? #f
                #:build-flags
                (tailscale-version-build-flags
                 (package-version go-tailscale-com))
                #:embed-files #~(list ".*\\.html" ".*\\.gz" ".*\\.woff2")
                #:import-path "tailscale.com/cmd/tailscale"
                #:unpack-path "tailscale.com"))
    (synopsis "Tailscale client")
    (description
     "Build the @code{tailscale} CLI from the Tailscale source tree.")))

(define-public tailscaled
  (package
    (inherit go-tailscale-com)
    (name "tailscaled")
    ;; Same split as the official CLI packages above, plus tailscaled's
    ;; daemon-only termios source dependency.
    (native-inputs
     (modify-inputs (package-propagated-inputs go-tailscale-com)
       (append go-github-com-u-root-u-root-pkg-termios-0.14.0)))
    (propagated-inputs '())
    (inputs '())
    (arguments (list
                #:go go-1.26
                #:tests? #f
                #:install-source? #f
                #:build-flags
                (tailscale-version-build-flags
                 (package-version go-tailscale-com))
                #:embed-files #~(list ".*\\.html" ".*\\.gz" ".*\\.woff2")
                #:import-path "tailscale.com/cmd/tailscaled"
                #:unpack-path "tailscale.com"))
    (synopsis "Tailscale daemon")
    (description
     "Build the @code{tailscaled} daemon from the Tailscale source tree.")))
