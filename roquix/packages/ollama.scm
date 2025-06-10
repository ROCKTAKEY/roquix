(define-module (roquix packages ollama)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build utils)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix profiles)
  #:use-module (guix build-system go)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-compression)
  #:use-module (gnu packages golang-crypto)
  #:use-module (gnu packages golang-web)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages golang-maths)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages syncthing)
  #:use-module (gnu packages prometheus)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-xyz)
  #:use-module (amd packages rocm-hip)
  #:use-module (amd packages rocm-base)
  #:use-module (amd packages rocm-libs))

(define-public go-github-com-d4l3k-go-bfloat16
  (package
    (name "go-github-com-d4l3k-go-bfloat16")
    (version "0.0.0-20211005043715-690c3bdd05f1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/d4l3k/go-bfloat16")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bshygdr5lcagznrh349r53whqhlg870j484zpsi3f7ilqv08rvy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/d4l3k/go-bfloat16"))
    (home-page "https://github.com/d4l3k/go-bfloat16")
    (synopsis "go-bfloat16")
    (description "BFloat16 conversion utilities for Go/Golang.")
    (license license:expat)))

(define-public go-github-com-emirpasic-gods-v2
  (package
    (name "go-github-com-emirpasic-gods-v2")
    (version "2.0.0-alpha")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/emirpasic/gods")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1qhjxv9rc1jjq57w84zz51lpx6baw3ywzj9ls491y1gkg5ycc765"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:import-path "github.com/emirpasic/gods/v2"))
    (home-page "https://github.com/emirpasic/gods")
    (synopsis "GoDS (Go Data Structures)")
    (description
     "Implementation of various data structures and algorithms in Go.")
    (license (list license:bsd-2 license:isc))))

(define-public go-github-com-nlpodyssey-gopickle
  (package
    (name "go-github-com-nlpodyssey-gopickle")
    (version "0.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/nlpodyssey/gopickle")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1fadbyq63i55g3k91knm7m1pl3j0krxdgpajrl78h27sl3mhnhal"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:import-path "github.com/nlpodyssey/gopickle"))
    (propagated-inputs (list go-golang-org-x-text))
    (home-page "https://github.com/nlpodyssey/gopickle")
    (synopsis "GoPickle")
    (description
     "@code{GoPickle} is a Go library for loading Python's data serialized with
@@code{pickle} and @code{PyTorch} module files.")
    (license license:bsd-2)))

(define-public go-github-com-envoyproxy-go-control-plane
  (package
    (name "go-github-com-envoyproxy-go-control-plane")
    (version "0.13.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/envoyproxy/go-control-plane")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0adyhxmld7i33v1dla7zpyx0ciq3ik412nxp4yvkfvdzyvihizrf"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.22
      #:skip-build? #t
      ;; Cycle: go-github-com-envoyproxy-go-control-plane@0.13.4 -> go-google-golang-org-grpc@1.72.1
      ;; -> go-github-com-envoyproxy-go-control-plane@0.13.4
      #:tests? #f
      #:import-path "github.com/envoyproxy/go-control-plane"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-genproto-googleapis
                             go-go-uber-org-goleak
                             go-github-com-stretchr-testify
                             go-github-com-google-go-cmp))
    (home-page "https://github.com/envoyproxy/go-control-plane")
    (synopsis "control-plane")
    (description
     "This repository contains a Go-based implementation of an API server that
implements the discovery service APIs defined in
@@url{https://github.com/envoyproxy/data-plane-api,data-plane-api}.")
    (license license:asl2.0)))

(define-public go-github-com-planetscale-vtprotobuf
  (package
    (name "go-github-com-planetscale-vtprotobuf")
    (version "0.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/planetscale/vtprotobuf")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0bms8rrg8wrm3x9mspqrzzix24vjgi3p5zzbw108ydr1rnarwblf"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:import-path "github.com/planetscale/vtprotobuf"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-github-com-stretchr-testify))
    (home-page "https://github.com/planetscale/vtprotobuf")
    (synopsis ", the Vitess Protocol Buffers compiler")
    (description
     "This repository provides the @@code{protoc-gen-go-vtproto} plug-in for
@@code{protoc}, which is used by Vitess to generate optimized marshall &
unmarshal code.")
    (license license:bsd-3)))

(define-public go-github-com-microsoft-go-winio
  (package
    (name "go-github-com-microsoft-go-winio")
    (version "0.6.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/microsoft/go-winio")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "09dxp536m15d3l9aibpfgs9ag55n7gqrgp5app4rcb888c6mclxm"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/Microsoft/go-winio"))
    (propagated-inputs (list go-golang-org-x-tools go-golang-org-x-sys
                             go-github-com-sirupsen-logrus))
    (home-page "https://github.com/Microsoft/go-winio")
    (synopsis "go-winio")
    (description
     "This package provides utilities for efficiently performing Win32 IO operations
in Go.  Currently, this package is provides support for genreal IO and
management of.")
    (license license:expat)))

(define-public go-github-com-zeebo-errs
  (package
    (name "go-github-com-zeebo-errs")
    (version "1.4.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/zeebo/errs")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bvmqpxr7gk38yl1wz6llwjgd5ys3ls0m150wjmmr61nggb5n7dy"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/zeebo/errs"))
    (home-page "https://github.com/zeebo/errs")
    (synopsis "errs")
    (description
     "Package errs provides a simple error package with stack traces.")
    (license license:expat)))

(define-public go-cel-dev-expr
  (package
    (name "go-cel-dev-expr")
    (version "0.24.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/cel-spec")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0fzy5njwzg48h1mqbfhczyq6hxmbq3yzdivkjh1x8ipj19v4hvfl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "cel.dev/expr"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-genproto-googleapis))
    (home-page "https://cel.dev/expr")
    (synopsis "Common Expression Language")
    (description
     "The Common Expression Language (CEL) implements common semantics for expression
evaluation, enabling different applications to more easily interoperate.")
    (license license:asl2.0)))

(define-public go-github-com-envoyproxy-protoc-gen-validate
  (package
    (name "go-github-com-envoyproxy-protoc-gen-validate")
    (version "1.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bufbuild/protoc-gen-validate")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0yd77gnsn9bbiihbkdyn9klwbv314l6ar83z4kivpn9mr93xysch"))))
    (build-system go-build-system)
    (arguments
     (list
      ;; FIXME: Tests needs file generation by protoc and protoc-gen-go
      #:tests? #f
      #:import-path "github.com/envoyproxy/protoc-gen-validate"))
    (propagated-inputs (list go-google-golang-org-protobuf go-golang-org-x-net
                             go-github-com-lyft-protoc-gen-star-v2
                             go-github-com-iancoleman-strcase))
    (home-page "https://github.com/envoyproxy/protoc-gen-validate")
    (synopsis "protoc-gen-validate (PGV)")
    (description
     "PGV is a protoc plugin to generate polyglot message validators.  While protocol
buffers effectively guarantee the types of structured data, they cannot enforce
semantic rules for values.  This plugin adds support to protoc-generated code to
validate such constraints.")
    (license license:asl2.0)))

(define-public go-google-golang-org-genproto-googleapis
  (package
    (name "go-google-golang-org-genproto-googleapis")
    (version "0.0.0-20250519155744-55703ea1f237")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/googleapis/go-genproto")
             (commit (go-version->git-ref version
                                          #:subdir "googleapis"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ilf95lhx7930cqx2hmswxasxyxjz3xmbznd0cfcglzdl3d9k4rk"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      ;; Cycle: go-google-golang-org-genproto-googleapis@0.0.0-20250519155744-55703ea1f237 -> go-google-golang-org-grpc@1.72.1
      ;; -> go-google-golang-org-genproto-googleapis@0.0.0-20250519155744-55703ea1f237
      #:tests? #f
      #:import-path "google.golang.org/genproto/googleapis"
      #:unpack-path "google.golang.org/genproto"))
    (propagated-inputs (list go-google-golang-org-protobuf))
    (home-page "https://google.golang.org/genproto")
    (synopsis " Generated code for Google Cloud client libraries.")
    (description
     "This repository contains the generated Go packages for common protocol buffer types,
and the generated gRPC code necessary for interacting with Google's gRPC APIs.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-collector-pdata
  (package
    (name "go-go-opentelemetry-io-collector-pdata")
    (version "1.32.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-collector")
             (commit (go-version->git-ref version
                                          #:subdir "pdata"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0cqnvacj52js79nyd4vkmk992xr44ywcr2j7ywx7q5iy2vknh4v3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.23
      ;; Cycle: go-go-opentelemetry-io-collector-pdata@1.32.0 -> go-go-opentelemetry-io-auto-sdk@1.1.0
      ;; -> go-go-opentelemetry-io-otel-exporters-prometheus@0.58.0 -> go-google-golang-org-grpc@1.72.1
      ;; -> go-go-opentelemetry-io-collector-pdata@1.32.0
      #:tests? #f
      #:import-path "go.opentelemetry.io/collector/pdata"
      #:unpack-path "go.opentelemetry.io/collector"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-go-uber-org-multierr
                             go-go-uber-org-goleak
                             go-github-com-stretchr-testify
                             go-github-com-json-iterator-go
                             go-github-com-gogo-protobuf))
    (home-page "https://go.opentelemetry.io/collector")
    (synopsis "Pipeline data (pdata)")
    (description
     "Package pdata provides the data model definitions for all supported pipeline
data.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-auto-sdk
  (package
    (name "go-go-opentelemetry-io-auto-sdk")
    (version "1.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url
              "https://github.com/open-telemetry/opentelemetry-go-instrumentation")
             (commit (go-version->git-ref version
                                          #:subdir "sdk"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "155qcbl84bwy7m9k221w75yakfv71fbxpfn9g3d7nnq6cl30fbfw"))))
    (build-system go-build-system)
    (arguments
     (list
      ;; Cycle: go-go-opentelemetry-io-auto-sdk@1.1.0 -> go-go-opentelemetry-io-otel-exporters-prometheus@0.58.0
      ;; -> go-google-golang-org-grpc@1.72.1 -> go-go-opentelemetry-io-auto-sdk@1.1.0
      #:tests? #f
      #:go go-1.23
      #:import-path "go.opentelemetry.io/auto/sdk"
      #:unpack-path "go.opentelemetry.io/auto"))
    (propagated-inputs (list go-go-opentelemetry-io-otel
                             go-github-com-stretchr-testify
                             go-go-opentelemetry-io-collector-pdata))
    (home-page "https://go.opentelemetry.io/auto")
    (synopsis #f)
    (description
     "Package sdk provides an auto-instrumentable @code{OpenTelemetry} SDK.")
    (license license:asl2.0)))

(define-public go-github-com-cncf-xds-go
  (package
    (name "go-github-com-cncf-xds-go")
    (version "0.0.0-20250501225837-2ac532fd4443")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cncf/xds")
             (commit (go-version->git-ref version
                                          #:subdir "go"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0snccl7rrx2f07131s0n8z3d1p5v2nvcg7v3dhq1a5sl46b1x78b"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      ;; Cycle: go-github-com-cncf-xds-go@0.0.0-20250501225837-2ac532fd4443 -> go-google-golang-org-grpc@1.72.1
      ;; -> go-github-com-cncf-xds-go@0.0.0-20250501225837-2ac532fd4443
      #:tests? #f
      #:import-path "github.com/cncf/xds/go"
      #:unpack-path "github.com/cncf/xds"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-genproto-googleapis
                             go-github-com-envoyproxy-protoc-gen-validate
                             go-cel-dev-expr))
    (home-page "https://github.com/cncf/xds")
    (synopsis "Implementation of the xDS suite of protocols")
    (description
     "Package xds contains an implementation of the xDS suite of protocols,
to be used by gRPC client and server applications.
On the client-side, users simply need to import this package to get all xDS functionality.
On the server-side, users need to use the GRPCServer type exported by this package instead
of the regular grpc.Server. ")
    (license license:asl2.0)))

;; Needed by go-go-opentelemetry-io-otel-exporters-prometheus for prometheus.NewConstNativeHistogram
(define-public go-github-com-prometheus-client-golang-1.22.0
  (package
    (inherit go-github-com-prometheus-client-golang)
    (name "go-github-com-prometheus-client-golang")
    (version "1.22.0")
    ;; Copied from go-github-com-prometheus-client-golang
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/prometheus/client_golang")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "08japwfsl7wlw6z8dkfdrhpgxr2w6frbinn96ksn0izab2h9s5gd"))
       (modules '((guix build utils)))
       (snippet #~(begin
                    ;; Submodules with their own go.mod files and packaged separately:
                    ;;
                    ;; - .bingo - fake module
                    (delete-file-recursively ".bingo")))))))

(define-public go-go-opentelemetry-io-otel-exporters-prometheus
  (package
    (name "go-go-opentelemetry-io-otel-exporters-prometheus")
    (version "0.58.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-go")
             (commit (go-version->git-ref version
                                          #:subdir "exporters/prometheus"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1kvfbqc56p1h9rh9cvgn37ya6k10613r0f2rhjiwrrkgs2mszk30"))

       ;; Copied from go-go-opentelemetry-io-otel-sdk
       (modules '((guix build utils)
                  (ice-9 ftw)
                  (srfi srfi-26)))
       (snippet #~(begin
                    ;; XXX: 'delete-all-but' is copied from the turbovnc package.
                    ;; Consider to implement it as re-usable procedure in
                    ;; guix/build/utils or guix/build-system/go.
                    (define (delete-all-but directory . preserve)
                      (define (directory? x)
                        (and=> (stat x #f)
                               (compose (cut eq?
                                             'directory <>) stat:type)))
                      (with-directory-excursion directory
                        (let* ((pred (negate (cut member <>
                                                  (append '("." "..") preserve))))
                               (items (scandir "." pred)))
                          (for-each (lambda (item)
                                      (if (directory? item)
                                          (delete-file-recursively item)
                                          (delete-file item))) items))))

                    ;; These are adjusted
                    (delete-all-but "." "exporters")
                    (delete-all-but "exporters" "prometheus")))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go.opentelemetry.io/otel/exporters/prometheus"
      #:unpack-path "go.opentelemetry.io/otel"
      #:test-flags
      #~(list "-skip"
              (string-join (list
                            ;; FIXME: The namespace is expected to "test/_" but is "test_"
                            "TestNewConfig/with_unsanitized_namespace"
                            ;; FIXME: Each key of target_info is expected to "xxx.yyy" but is xxx_yyy
                            "TestPrometheusExporter/counter"
                            "TestPrometheusExporter/counter_that_already_has_the_unit_suffix"
                            "TestPrometheusExporter/counter_that_already_has_a_total_suffix"
                            "TestPrometheusExporter/counter_with_suffixes_disabled"
                            "TestPrometheusExporter/gauge"
                            "TestPrometheusExporter/exponential_histogram"
                            "TestPrometheusExporter/histogram") "|"))))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-github-com-stretchr-testify
                             go-github-com-prometheus-common
                             go-github-com-prometheus-client-model
                             go-github-com-prometheus-client-golang-1.22.0
                             go-github-com-go-logr-logr
                             go-github-com-go-logr-stdr
                             go-github-com-google-uuid
                             go-go-opentelemetry-io-auto-sdk
                             go-go-opentelemetry-io-otel-sdk
                             go-go-opentelemetry-io-otel-sdk-metric))
    (home-page "https://go.opentelemetry.io/otel")
    (synopsis "Prometheus Exporter")
    (description
     "Package prometheus provides a Prometheus Exporter that converts OTLP metrics
into the Prometheus exposition format and implements prometheus.Collector to
provide a handler for these metrics.")
    (license license:asl2.0)))

(define-public go-google-golang-org-grpc-security-advancedtls
  (package
    (name "go-google-golang-org-grpc-security-advancedtls")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/grpc/grpc-go")
             (commit (go-version->git-ref version
                                          #:subdir "security/advancedtls"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1xkqjian41falr0h8sicx2vdajf1zxcrkqiz5p2g7mmm8gcb6l4w"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "google.golang.org/grpc/security/advancedtls"
      #:unpack-path "google.golang.org/grpc"))
    (propagated-inputs (list go-golang-org-x-crypto
                             go-github-com-google-go-cmp))
    (home-page "https://google.golang.org/grpc")
    (synopsis #f)
    (description
     "Package advancedtls provides @code{gRPC} transport credentials that allow easy
configuration of advanced TLS features.  The APIs here give the user more
customizable control to fit their security landscape, thus the \"advanced\"
moniker.  This package provides both interfaces and generally useful
implementations of those interfaces, for example periodic credential reloading,
support for certificate revocation lists, and customizable certificate
verification behaviors.  If the provided implementations do not fit a given use
case, a custom implementation of the interface can be injected.")
    (license license:asl2.0)))

(define-public go-github-com-spiffe-go-spiffe
  (package
    (name "go-github-com-spiffe-go-spiffe")
    (version "2.5.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/spiffe/go-spiffe")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "076fx3xbazk3r3h8a5pc0z40i0d7hxiqccc7lzi317k87kf284rq"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      ;; Cycle: go-github-com-spiffe-go-spiffe@2.5.0 -> go-google-golang-org-grpc@1.72.1
      ;; -> go-github-com-spiffe-go-spiffe@2.5.0
      #:tests? #f
      #:import-path "github.com/spiffe/go-spiffe/v2"
      #:unpack-path "github.com/spiffe/go-spiffe/v2"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-github-com-zeebo-errs
                             go-github-com-stretchr-testify
                             go-github-com-go-jose-go-jose-v4
                             go-github-com-microsoft-go-winio))
    (home-page "https://github.com/spiffe/go-spiffe")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-cloud-google-com-go-compute-metadata-0.121.2
  (package
    (inherit go-cloud-google-com-go-compute-metadata)
    (name "go-cloud-google-com-go-compute-metadata-0.121.2")
    ;; Version should be equal to or more than 0.113.0,
    ;; though 0.6.0 is pointed by go.mod in go-github-com-googlecloudplatform-opentelemetry-operations-go-detectors-gcp
    (version "0.121.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/googleapis/google-cloud-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1dl179xpx9xb0k3s23m49k1mw5krrl20cs6026g7rmz584b54nsh"))))
    (build-system go-build-system)
    (arguments
     '(#:unpack-path "cloud.google.com/go"
       #:import-path "cloud.google.com/go/compute/metadata"))
    (propagated-inputs (list go-github-com-google-go-cmp))
    (home-page "https://pkg.go.dev/cloud.google.com/go/compute/metadata")
    (synopsis "Go wrapper for Google Compute Engine metadata service")
    (description
     "This package provides access to Google Compute Engine (GCE) metadata and
API service accounts for Go.")
    (license license:asl2.0)))

(define-public go-github-com-googlecloudplatform-opentelemetry-operations-go-detectors-gcp
  (package
    (name
     "go-github-com-googlecloudplatform-opentelemetry-operations-go-detectors-gcp")
    (version "1.27.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url
              "https://github.com/GoogleCloudPlatform/opentelemetry-operations-go")
             (commit (go-version->git-ref version
                                          #:subdir "detectors/gcp"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vbabwma278457zkszwa9185y40kg4d7zpijc4q4cmsffnxv0gix"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.22
      #:import-path
      "github.com/GoogleCloudPlatform/opentelemetry-operations-go/detectors/gcp"
      #:unpack-path
      "github.com/GoogleCloudPlatform/opentelemetry-operations-go"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-cloud-google-com-go-compute-metadata-0.121.2))
    (home-page
     "https://github.com/GoogleCloudPlatform/opentelemetry-operations-go")
    (synopsis "GCP Resource detection library")
    (description
     "This is a library intended to be used by Upstream @code{OpenTelemetry} resource
detectors.  It exists within this repository to allow for integration testing of
the detection functions in real GCP environments.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-contrib-detectors-gcp
  (package
    (name "go-go-opentelemetry-io-contrib-detectors-gcp")
    (version "1.36.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-go-contrib")
             (commit (go-version->git-ref version
                                          #:subdir "detectors/gcp"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "15k2xps4qv37pw3ml6pj98kihl6a04bbr005px5hhckl23s40w2c"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go.opentelemetry.io/contrib/detectors/gcp"
      #:unpack-path "go.opentelemetry.io/contrib"))
    (propagated-inputs (list go-go-opentelemetry-io-otel-sdk
                        go-go-opentelemetry-io-otel
                        go-github-com-stretchr-testify
                        go-github-com-google-go-cmp
                        go-github-com-googlecloudplatform-opentelemetry-operations-go-detectors-gcp
                        go-cloud-google-com-go-compute-metadata-0.121.2))
    (home-page "https://go.opentelemetry.io/contrib")
    (synopsis "GCP Resource detector")
    (description "The GCP resource detector supports detecting resources on:.")
    (license license:asl2.0)))

(define-public go-google-golang-org-grpc
  (package
    (name "go-google-golang-org-grpc")
    (version "1.72.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/grpc/grpc-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0lxllrw23psd910krbrgzyrmh6calf42wg9fwkmybv2fn5liq73v"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.23
      ;; src/google.golang.org/grpc/credentials/tls/certprovider/provider.go:33:2: cannot find package "github.com/spiffe/go-spiffe/v2/bundle/spiffebundle" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/github.com/spiffe/go-spiffe/v2/bundle/spiffebundle (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/github.com/spiffe/go-spiffe/v2/bundle/spiffebundle (from $GOPATH)
      ;; src/google.golang.org/grpc/internal/credentials/spiffe/spiffe.go:29:2: cannot find package "github.com/spiffe/go-spiffe/v2/spiffeid" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/github.com/spiffe/go-spiffe/v2/spiffeid (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/github.com/spiffe/go-spiffe/v2/spiffeid (from $GOPATH)
      ;; src/google.golang.org/grpc/gcp/observability/config.go:29:2: cannot find package "cloud.google.com/go/logging" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/cloud.google.com/go/logging (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/cloud.google.com/go/logging (from $GOPATH)
      ;; src/google.golang.org/grpc/gcp/observability/opencensus.go:27:2: cannot find package "contrib.go.opencensus.io/exporter/stackdriver" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/contrib.go.opencensus.io/exporter/stackdriver (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/contrib.go.opencensus.io/exporter/stackdriver (from $GOPATH)
      ;; src/google.golang.org/grpc/gcp/observability/opencensus.go:28:2: cannot find package "contrib.go.opencensus.io/exporter/stackdriver/monitoredresource" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/contrib.go.opencensus.io/exporter/stackdriver/monitoredresource (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/contrib.go.opencensus.io/exporter/stackdriver/monitoredresource (from $GOPATH)
      ;; src/google.golang.org/grpc/gcp/observability/opencensus.go:30:2: cannot find package "go.opencensus.io/stats/view" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/go.opencensus.io/stats/view (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/go.opencensus.io/stats/view (from $GOPATH)
      ;; src/google.golang.org/grpc/gcp/observability/logging.go:32:2: cannot find package "go.opencensus.io/trace" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/go.opencensus.io/trace (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/go.opencensus.io/trace (from $GOPATH)
      ;; src/google.golang.org/grpc/gcp/observability/exporting.go:26:2: cannot find package "google.golang.org/api/option" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/google.golang.org/api/option (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/google.golang.org/api/option (from $GOPATH)
      ;; src/google.golang.org/grpc/stats/opencensus/client_metrics.go:20:2: cannot find package "go.opencensus.io/stats" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/go.opencensus.io/stats (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/go.opencensus.io/stats (from $GOPATH)
      ;; src/google.golang.org/grpc/stats/opencensus/client_metrics.go:22:2: cannot find package "go.opencensus.io/tag" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/go.opencensus.io/tag (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/go.opencensus.io/tag (from $GOPATH)
      ;; src/google.golang.org/grpc/stats/opencensus/trace.go:25:2: cannot find package "go.opencensus.io/trace/propagation" in any of:
      ;; /gnu/store/mbp2fpgmgdhbmg8kw69hd864szvnni7g-go-1.23.5/lib/go/src/go.opencensus.io/trace/propagation (from $GOROOT)
      ;; /tmp/guix-build-go-google-golang-org-grpc-1.72.1.drv-0/src/go.opencensus.io/trace/propagation (from $GOPATH)
      #:tests? #f
      #:import-path "google.golang.org/grpc"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-genproto-googleapis
                             go-golang-org-x-sys
                             go-golang-org-x-sync
                             go-golang-org-x-oauth2
                             go-golang-org-x-net
                             go-go-opentelemetry-io-otel-sdk-metric
                             go-go-opentelemetry-io-otel-sdk
                             go-go-opentelemetry-io-otel
                             go-go-opentelemetry-io-contrib-detectors-gcp
                             go-github-com-spiffe-go-spiffe
                             go-github-com-google-uuid
                             go-github-com-google-go-cmp
                             go-github-com-golang-protobuf
                             go-github-com-golang-glog
                             go-github-com-envoyproxy-go-control-plane
                             go-github-com-cncf-xds-go
                             go-github-com-cespare-xxhash-v2
                             go-github-com-spiffe-go-spiffe
                             go-go-opentelemetry-io-otel-exporters-prometheus))
    (home-page "https://google.golang.org/grpc")
    (synopsis "gRPC-Go")
    (description "Package grpc implements an RPC system called @code{gRPC}.")
    (license license:asl2.0)))

(define-public go-github-com-apache-arrow-go-arrow
  (package
    (name "go-github-com-apache-arrow-go-arrow")
    (version "0.0.0-20211112161151-bc219186db40")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/apache/arrow")
             (commit (go-version->git-ref version
                                          #:subdir "go/arrow"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "03nh7c0i3y9rkkzw428knalkrlpb8syr459i00mwp072ijn8v4hx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.22
      #:test-flags ''("-skip" "TestReadWrite/extension")
      #:import-path "github.com/apache/arrow/go/arrow"
      #:unpack-path "github.com/apache/arrow"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-gonum-org-v1-gonum
                             go-golang-org-x-xerrors
                             go-golang-org-x-exp
                             go-github-com-stretchr-testify
                             go-github-com-pierrec-lz4-v4
                             go-github-com-klauspost-compress
                             go-github-com-google-flatbuffers
                             go-github-com-golang-protobuf
                             go-google-golang-org-grpc))
    (home-page "https://github.com/apache/arrow")
    (synopsis #f)
    (description "Package arrow provides an implementation of Apache Arrow.")
    (license license:asl2.0)))

(define-public go-github-com-xtgo-set
  (package
    (name "go-github-com-xtgo-set")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/xtgo/set")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "148jb5f87lf7090jg8340f24r29818krydajkm75vpzylaw6yd8w"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/xtgo/set"))
    (home-page "https://github.com/xtgo/set")
    (synopsis "set")
    (description
     "Package set implements type-safe, non-allocating algorithms that operate on
ordered sets.")
    (license license:bsd-2)))

(define-public go-github-com-chewxy-hm
  (package
    (name "go-github-com-chewxy-hm")
    (version "1.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chewxy/hm")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0f4qwg1q2lc9y64wrl9qxyimqnnandlqg78gn3yv4vsmyci025r7"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/chewxy/hm"))
    (propagated-inputs (list go-github-com-pkg-errors go-github-com-xtgo-set
                             go-github-com-stretchr-testify))
    (home-page "https://github.com/chewxy/hm")
    (synopsis "hm")
    (description
     "Package hm is a simple Hindley-Milner type inference system in Go.  It provides
the necessary data structures and functions for creating such a system.")
    (license license:expat)))

(define-public go-github-com-google-flatbuffers
  (package
    (name "go-github-com-google-flatbuffers")
    (version "25.2.10+incompatible")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/flatbuffers")
             (commit (go-version->git-ref version
                                          #:subdir "go"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wcpaj4k9dwccb752pl8p54pqwajr51sxjym32q2bpm9ny6ib45v"))))
    (build-system go-build-system)
    (arguments
     (list
      #:skip-build? #t
      #:import-path "github.com/google/flatbuffers/go"
      #:unpack-path "github.com/google/flatbuffers"))
    (home-page "https://github.com/google/flatbuffers")
    (synopsis "FlatBuffers")
    (description
     "@@strong{@code{FlatBuffers}} is a cross platform serialization library
architected for maximum memory efficiency.  It allows you to directly access
serialized data without parsing/unpacking it first, while still having great
forwards/backwards compatibility.")
    (license license:asl2.0)))

(define-public go-go4-org-unsafe-assume-no-moving-gc
  (package
    (name "go-go4-org-unsafe-assume-no-moving-gc")
    (version "0.0.0-20231121144256-b99613f794b6")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/go4org/unsafe-assume-no-moving-gc")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "00ny3qha8k9nnx37ryvls2n5r7lw3bnldz6kwdmjxk8s19mxqim7"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "go4.org/unsafe/assume-no-moving-gc"))
    (home-page "https://go4.org/unsafe/assume-no-moving-gc")
    (synopsis "go4.org/unsafe/assume-no-moving-gc")
    (description
     "Package go4.org/unsafe/assume-no-moving-gc exists so you can depend on it from
unsafe code that wants to declare that it assumes that the Go runtime does not
use a moving garbage collector.  Specifically, it asserts that the caller is
playing stupid games with the addresses of heap-allocated values.  It says
nothing about values that Go's escape analysis keeps on the stack.  Ensuring
things aren't stack-allocated is the caller's responsibility.")
    (license license:bsd-3)))

(define-public go-github-com-chewxy-math32
  (package
    (name "go-github-com-chewxy-math32")
    (version "1.11.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/chewxy/math32")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0i7jssi872mv7h4rc4y0xa88a0hsr03mydqyrd6mrm8n7q8rfml9"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/chewxy/math32"))
    (home-page "https://github.com/chewxy/math32")
    (synopsis "math32")
    (description
     "Package math32 provides basic constants and mathematical functions for float32
types.")
    (license license:bsd-2)))

(define-public go-gorgonia-org-vecf32
  (package
    (name "go-gorgonia-org-vecf32")
    (version "0.9.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gorgonia/vecf32")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jggbf98fbbip7znx5m4n2lqqsnw5kqycj3gcbs62ypirr1pp0m9"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "gorgonia.org/vecf32"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-github-com-pmezard-go-difflib
                             go-github-com-davecgh-go-spew
                             go-github-com-chewxy-math32))
    (home-page "https://gorgonia.org/vecf32")
    (synopsis "vecf32")
    (description
     "Package vecf32 provides common functions and methods for slices of float32.")
    (license license:expat)))

(define-public go-gorgonia-org-vecf64
  (package
    (name "go-gorgonia-org-vecf64")
    (version "0.9.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gorgonia/vecf64")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0a8v65cy6gyh7ww2g8q4p6dmjhcd6k7lm7z8ly4vmi4k0vq1w187"))))
    (build-system go-build-system)
    (arguments
     (list
      ;; FIXME: "misplaced +build comment" occured
      #:tests? #f
      #:import-path "gorgonia.org/vecf64"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-github-com-pmezard-go-difflib
                             go-github-com-davecgh-go-spew))
    (home-page "https://gorgonia.org/vecf64")
    (synopsis "vecf64")
    (description
     "Package vecf64 provides common functions and methods for slices of float64.")
    (license license:expat)))

(define-public go-gorgonia-org-tensor
  (package
    (name "go-gorgonia-org-tensor")
    (version "0.9.24")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gorgonia/tensor")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13dk1gmplik5z8x27khgk5aja480znq4ryx3j0csp2j9vnwccpl3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "gorgonia.org/tensor"
      #:phases '(modify-phases %standard-phases
                  ;; Need python for tests
                  (add-before 'check 'add-python-path
                    (lambda* (#:key inputs #:allow-other-keys)
                      (setenv "PYTHON_COMMAND"
                              (string-append (assoc-ref inputs "python")
                                             "/bin/python3")))))))
    (propagated-inputs (list go-gorgonia-org-vecf64
                             go-gorgonia-org-vecf32
                             go-gonum-org-v1-gonum
                             go-go4-org-unsafe-assume-no-moving-gc
                             go-github-com-stretchr-testify
                             go-github-com-pkg-errors
                             go-github-com-google-flatbuffers
                             go-github-com-golang-protobuf
                             go-github-com-gogo-protobuf
                             go-github-com-chewxy-math32
                             go-github-com-chewxy-hm
                             go-github-com-apache-arrow-go-arrow))
    (native-inputs (list
                    ;; Need for test
                    python python-numpy))
    (home-page "https://gorgonia.org/tensor")
    (synopsis "Package")
    (description
     "Package tensor is a package that provides efficient, generic n-dimensional
arrays in Go.  Also in this package are functions and methods that are used
commonly in arithmetic, comparison and linear algebra operations.")
    (license license:asl2.0)))

(define-public go-github-com-pdevine-tensor
  (package
    (name "go-github-com-pdevine-tensor")
    (version "0.0.0-20250402003834-09d804610a08")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pdevine/tensor")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1vxzrlars1ml8n0acc7f2ja8c5d4kbair8ryfm5s29i5i5b7p7z2"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/pdevine/tensor"
      #:phases '(modify-phases %standard-phases
                  ;; Need python for tests
                  (add-before 'check 'add-python-path
                    (lambda* (#:key inputs #:allow-other-keys)
                      (setenv "PYTHON_COMMAND"
                              (string-append (assoc-ref inputs "python")
                                             "/bin/python3"))))
                  (add-after 'unpack 'remove-import-path-comment
                    ;; This package is a fork, but import path comments are not fixed.
                    (lambda _
                      (substitute* (find-files "." "\\.go$")
                        (("// *import .*$")
                         "")))))))
    (propagated-inputs (list go-gorgonia-org-vecf64
                             go-gorgonia-org-vecf32
                             go-gonum-org-v1-gonum
                             go-go4-org-unsafe-assume-no-moving-gc
                             go-github-com-stretchr-testify
                             go-github-com-pkg-errors
                             go-github-com-google-flatbuffers
                             go-github-com-golang-protobuf
                             go-github-com-gogo-protobuf
                             go-github-com-chewxy-math32
                             go-github-com-chewxy-hm
                             go-github-com-apache-arrow-go-arrow))
    (native-inputs (list
                    ;; Need for test
                    python python-numpy))
    (home-page "https://github.com/pdevine/tensor")
    (synopsis "Package")
    (description
     "Package tensor is a package that provides efficient, generic n-dimensional
arrays in Go.  Also in this package are functions and methods that are used
commonly in arithmetic, comparison and linear algebra operations.")
    (license license:asl2.0)))

(define-public go-github-com-gin-contrib-cors
  (package
    (name "go-github-com-gin-contrib-cors")
    (version "1.7.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/gin-contrib/cors")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1k38fd5qc0p4b6qjzs7cby8lfk6vxlf14f9xp9wi460zbzwbcmx9"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/gin-contrib/cors"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-github-com-gin-gonic-gin))
    (home-page "https://github.com/gin-contrib/cors")
    (synopsis "CORS gin's middleware")
    (description "Gin middleware/handler to enable CORS support.")
    (license license:expat)))

;; Ollama needs 1.11.5
;; https://github.com/ollama/ollama/issues/9656#issuecomment-2717522554
(define-public go-github-com-dlclark-regexp2-1.11.5
  (package
    (inherit go-github-com-dlclark-regexp2)
    (name "go-github-com-dlclark-regexp2")
    (version "1.11.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/dlclark/regexp2")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0i5c7ak8r4wwlyrx5f1mdipqk6p6ms1jgclb7hlb4qgy83c7xplc"))))
    (arguments
     (cons* #:test-flags #~(list "-skip"
                                 (string-join
                                  ;; These tests are flaky
                                  (list "TestDeadline/.*"
                                        "TestStopTimeoutClock/.*"
                                        "TestIncorrectDeadline/.*") "|"))
            (package-arguments go-github-com-dlclark-regexp2)))))

;; Ollama needs os.OpenRoot
(define-public go-1.24
  (package
    (inherit go-1.23)
    (name "go")
    (version "1.24.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/golang/go")
             (commit (string-append "go" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1b24pdsxrarw22gffv85sghpgvgamafvwwrvvhmyv3hqf89m97zk"))))
    (native-inputs
     ;; Go 1.22 and later requires Go 1.20 (min. 1.20.6, which we don't have)
     ;; as the bootstrap toolchain.
     (alist-replace "go"
                    (list go-1.23)
                    (package-native-inputs go-1.23)))))

(define-public ollama
  (package
    (name "ollama")
    (version "0.7.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ollama/ollama")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1h1gkcd4fvcygq4775ylc03qxnkr61qvkhwh2j90c3amyy98rvbr"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.24
      #:import-path "github.com/ollama/ollama"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-golang-org-x-text
                             go-golang-org-x-term
                             go-golang-org-x-sys
                             go-golang-org-x-exp
                             go-golang-org-x-crypto
                             go-github-com-gin-contrib-cors
                             go-golang-org-x-tools
                             go-golang-org-x-image
                             go-github-com-pdevine-tensor
                             go-github-com-nlpodyssey-gopickle
                             go-github-com-mattn-go-runewidth
                             go-github-com-google-go-cmp
                             go-github-com-emirpasic-gods-v2
                             go-github-com-dlclark-regexp2-1.11.5
                             go-github-com-d4l3k-go-bfloat16
                             go-github-com-agnivade-levenshtein
                             go-golang-org-x-sync
                             go-github-com-x448-float16
                             go-github-com-stretchr-testify
                             go-github-com-spf13-cobra
                             go-github-com-olekukonko-tablewriter
                             go-github-com-google-uuid
                             go-github-com-gin-gonic-gin
                             go-github-com-containerd-console
                             go-modernc-org-mathutil))
    (home-page "https://github.com/ollama/ollama")
    (synopsis "Ollama")
    (description "Get up and running with large language models.")
    (license license:expat)))

(define hip-union
  (directory-union "hip-union"
                   (list rocm-toolchain
                         hipamd)))

(define-public ollama-rocm
  (package
    (inherit ollama)
    (name "ollama-rocm")
    (build-system cmake-build-system)
    (arguments
     (list
      #:configure-flags
      #~(list (string-append "-DCMAKE_HIP_COMPILER=" #$hip-union "/bin/clang++")
              "-DCMAKE_HIP_PLATFORM=amd"
              "-DAMDGPU_TARGETS=gfx900;gfx940;gfx941;gfx942;gfx1010;gfx1012;gfx1030;gfx1100;gfx1101;gfx1102;gfx1151;gfx1200;gfx1201;gfx906:xnack-;gfx908:xnack-;gfx90a:xnack+;gfx90a:xnack-")
      #:imported-modules
      `(,@%cmake-build-system-modules
        ,@%go-build-system-modules)
      #:modules
      '((guix build cmake-build-system)
        ((guix build go-build-system) #:prefix go:)
        (guix build union)
        (guix build utils))
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'check 'setup-go-environment
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let ((go-build-system-phases
                     (@ (guix build go-build-system) %standard-phases)))
                ((assoc-ref go-build-system-phases 'setup-go-environment)
                 #:inputs inputs #:outputs outputs))))
          (replace 'check
            (lambda* (#:key tests? import-path test-flags test-subdirs parallel-tests? #:allow-other-keys)
              (when tests?
                (let ((go-check (@ (guix build go-build-system) check)))
                  (go-check #:tests? tests?
                           #:import-path "github.com/ollama/ollama"
                           #:test-flags (or test-flags '())
                           #:test-subdirs (or test-subdirs '(""))
                           #:parallel-tests? (if (unspecified? parallel-tests?) #t parallel-tests?)))))))))
    (native-inputs
     (list go-1.24))
    (inputs
     (list
      rocm-cmake
      rocm-toolchain
      hipamd
      hipblas
      rocblas))
    (home-page "https://github.com/ollama/ollama")
    (synopsis "Ollama")
    (description "Get up and running with large language models.")
    (license license:expat)))
