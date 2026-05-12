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

(define-public go-github-com-u-root-u-root-pkg-termios-0.14.0
  (package
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
    (build-system go-build-system)
    (home-page "https://github.com/u-root/u-root")
    (synopsis "Termios source package from u-root")
    (description
     "Source-only package for @code{github.com/u-root/u-root/pkg/termios},
which @code{tailscaled} imports through @code{tailscale.com/ssh/tailssh}.")
    (license license:bsd-3)))

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

;; Additional package definitions required by existing propagated-inputs.

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
    (propagated-inputs (list go-fyne-io-systray
                        go-github-com-anmitsu-go-shlex
                        go-github-com-atotto-clipboard
                        go-github-com-aws-aws-sdk-go-v2
                        go-github-com-aws-aws-sdk-go-v2-config
                        go-github-com-aws-aws-sdk-go-v2-feature-ec2-imds
                        go-github-com-aws-aws-sdk-go-v2-service-ssm
                        go-github-com-aws-aws-sdk-go-v2-service-sts
                        go-github-com-aws-smithy-go
                        go-github-com-coder-websocket
                        go-github-com-coreos-go-iptables
                        go-github-com-creachadair-msync
                        go-github-com-creack-pty
                        go-github-com-digitalocean-go-smbios
                        go-github-com-djherbis-times
                        go-github-com-fogleman-gg
                        go-github-com-fxamacker-cbor-v2
                        go-github-com-gaissmai-bart
                        go-github-com-go-json-experiment-json
                        go-github-com-godbus-dbus-v5
                        go-github-com-golang-groupcache
                        go-github-com-google-go-tpm-0.9.4
                        go-github-com-google-nftables
                        go-github-com-hdevalence-ed25519consensus
                        go-github-com-huin-goupnp
                        go-github-com-illarion-gonotify-v3
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
                        go-github-com-mitchellh-go-ps
                        go-github-com-peterbourgon-ff-v3
                        go-github-com-pires-go-proxyproto
                        go-github-com-pkg-sftp
                        go-github-com-safchain-ethtool
                        go-github-com-skip2-go-qrcode
                        go-github-com-tailscale-hujson
                        go-github-com-tailscale-netlink
                        go-github-com-tailscale-peercred
                        go-github-com-tailscale-web-client-prebuilt
                        go-github-com-tailscale-wireguard-go
                        go-github-com-tailscale-xnet
                        go-github-com-toqueteos-webbrowser
                        go-github-com-vishvananda-netns
                        go-go4-org-mem
                        go-go4-org-netipx
                        go-golang-org-x-crypto
                        go-golang-org-x-exp
                        go-golang-org-x-net
                        go-golang-org-x-oauth2
                        go-golang-org-x-sync
                        go-golang-org-x-sys
                        go-golang-org-x-term
                        go-golang-org-x-time
                        go-gvisor-dev-gvisor-for-tailscale
                        go-k8s-io-client-go
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
