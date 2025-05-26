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

(define-public go-github-com-emirpasic-gods
  (package
    (name "go-github-com-emirpasic-gods")
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
      #:import-path "github.com/emirpasic/gods/v2"
      #:unpack-path "github.com/emirpasic/gods"))
    (home-page "https://github.com/emirpasic/gods")
    (synopsis "GoDS (Go Data Structures)")
    (description
     "Implementation of various data structures and algorithms in Go.")
    (license unknown-license!)))

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
      #:import-path "github.com/envoyproxy/go-control-plane"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-google-golang-org-genproto-googleapis-rpc
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

(define-public go-github-com-grpc-ecosystem-grpc-gateway
  (package
    (name "go-github-com-grpc-ecosystem-grpc-gateway")
    (version "2.26.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/grpc-ecosystem/grpc-gateway")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1pw845x9bqhj64pxvyaafacq0mmmblbf5z4r2arprhdnb05czx3v"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "github.com/grpc-ecosystem/grpc-gateway/v2"
      #:unpack-path "github.com/grpc-ecosystem/grpc-gateway"))
    (propagated-inputs (list go-gopkg-in-yaml-v3
                             go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-google-golang-org-genproto-googleapis-rpc
                             go-google-golang-org-genproto-googleapis-api
                             go-golang-org-x-text
                             go-golang-org-x-oauth2
                             go-github-com-rogpeppe-fastuuid
                             go-github-com-google-go-cmp
                             go-github-com-antihax-optional))
    (home-page "https://github.com/grpc-ecosystem/grpc-gateway")
    (synopsis "About")
    (description
     "The @code{gRPC-Gateway} is a plugin of the Google protocol buffers compiler
@@url{https://github.com/protocolbuffers/protobuf,protoc}.  It reads protobuf
service definitions and generates a reverse-proxy server which translates a
RESTful HTTP API into @code{gRPC}.  This server is generated according to the
@@url{https://github.com/googleapis/googleapis/raw/master/google/api/http.proto#L46,(code
google.api.http)} annotations in your service definitions.")
    (license license:bsd-3)))

(define-public go-go-opentelemetry-io-proto-otlp
  (package
    (name "go-go-opentelemetry-io-proto-otlp")
    (version "1.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-proto-go")
             (commit (go-version->git-ref version
                                          #:subdir "otlp"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "17hajnwi070dvsqcnhn0rlx4h59bn0cgc7364qii34vjhpa665ms"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "go.opentelemetry.io/proto/otlp"
      #:unpack-path "go.opentelemetry.io/proto"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-github-com-grpc-ecosystem-grpc-gateway-v2))
    (home-page "https://go.opentelemetry.io/proto")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-github-com-envoyproxy-go-control-plane-envoy
  (package
    (name "go-github-com-envoyproxy-go-control-plane-envoy")
    (version "1.32.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/envoyproxy/go-control-plane")
             (commit (go-version->git-ref version
                                          #:subdir "envoy"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "08zijpn9bf3dm2arp3z8ssm6wd3vbyfc57vg8ayw7rfh8h8kdaw3"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.22
      #:import-path "github.com/envoyproxy/go-control-plane/envoy"
      #:unpack-path "github.com/envoyproxy/go-control-plane"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-google-golang-org-genproto-googleapis-rpc
                             go-google-golang-org-genproto-googleapis-api
                             go-go-opentelemetry-io-proto-otlp
                             go-github-com-prometheus-client-model
                             go-github-com-planetscale-vtprotobuf
                             go-github-com-envoyproxy-protoc-gen-validate
                             go-github-com-envoyproxy-go-control-plane
                             go-github-com-cncf-xds-go))
    (home-page "https://github.com/envoyproxy/go-control-plane")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

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
      #:go #{go-#f}#
      #:import-path "cel.dev/expr"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-genproto-googleapis-rpc))
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

(define-public go-google-golang-org-genproto-googleapis-api
  (package
    (name "go-google-golang-org-genproto-googleapis-api")
    (version "0.0.0-20250519155744-55703ea1f237")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/googleapis/go-genproto")
             (commit (go-version->git-ref version
                                          #:subdir "googleapis/api"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ilf95lhx7930cqx2hmswxasxyxjz3xmbznd0cfcglzdl3d9k4rk"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "google.golang.org/genproto/googleapis/api"
      #:unpack-path "google.golang.org/genproto"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-google-golang-org-genproto-googleapis-rpc))
    (home-page "https://google.golang.org/genproto")
    (synopsis #f)
    (description #f)
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
      #:import-path "github.com/cncf/xds/go"
      #:unpack-path "github.com/cncf/xds"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-google-golang-org-genproto-googleapis-api
                             go-github-com-envoyproxy-protoc-gen-validate
                             go-cel-dev-expr))
    (home-page "https://github.com/cncf/xds")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

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
        (base32 "1kvfbqc56p1h9rh9cvgn37ya6k10613r0f2rhjiwrrkgs2mszk30"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "go.opentelemetry.io/otel/exporters/prometheus"
      #:unpack-path "go.opentelemetry.io/otel"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-github-com-stretchr-testify
                             go-github-com-prometheus-common
                             go-github-com-prometheus-client-model
                             go-github-com-prometheus-client-golang))
    (home-page "https://go.opentelemetry.io/otel")
    (synopsis "Prometheus Exporter")
    (description
     "Package prometheus provides a Prometheus Exporter that converts OTLP metrics
into the Prometheus exposition format and implements prometheus.Collector to
provide a handler for these metrics.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-otel-exporters-stdout-stdouttrace
  (package
    (name "go-go-opentelemetry-io-otel-exporters-stdout-stdouttrace")
    (version "1.36.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-go")
             (commit (go-version->git-ref version
                                          #:subdir
                                          "exporters/stdout/stdouttrace"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1kvfbqc56p1h9rh9cvgn37ya6k10613r0f2rhjiwrrkgs2mszk30"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "go.opentelemetry.io/otel/exporters/stdout/stdouttrace"
      #:unpack-path "go.opentelemetry.io/otel"))
    (propagated-inputs (list go-github-com-stretchr-testify))
    (home-page "https://go.opentelemetry.io/otel")
    (synopsis "STDOUT Trace Exporter")
    (description
     "Package stdouttrace contains an @code{OpenTelemetry} exporter for tracing
telemetry to be written to an output destination as JSON.")
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

(define-public go-google-golang-org-grpc-examples
  (package
    (name "go-google-golang-org-grpc-examples")
    (version "0.0.0-20250526043511-e3ca7f9077fc")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/grpc/grpc-go")
             (commit (go-version->git-ref version
                                          #:subdir "examples"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "11796dkq7y0ll0w9pbihmn9b9nrcrdfp1g6mv8101wn5bmk28xwl"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "google.golang.org/grpc/examples"
      #:unpack-path "google.golang.org/grpc"))
    (propagated-inputs (list go-google-golang-org-protobuf
                        go-google-golang-org-grpc-security-advancedtls
                        go-google-golang-org-genproto-googleapis-rpc
                        go-golang-org-x-oauth2
                        go-go-opentelemetry-io-otel-sdk-metric
                        go-go-opentelemetry-io-otel-sdk
                        go-go-opentelemetry-io-otel-exporters-stdout-stdouttrace
                        go-go-opentelemetry-io-otel-exporters-prometheus
                        go-go-opentelemetry-io-otel
                        go-github-com-prometheus-client-golang
                        go-github-com-cncf-xds-go))
    (home-page "https://google.golang.org/grpc")
    (synopsis "Examples")
    (description
     "The following examples are provided to help users get started with
@code{gRPC-Go}.  They are arranged as follows:.")
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
      #:go #{go-#f}#
      #:import-path "github.com/spiffe/go-spiffe/v2"
      #:unpack-path "github.com/spiffe/go-spiffe"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc-examples
                             go-google-golang-org-grpc
                             go-github-com-zeebo-errs
                             go-github-com-stretchr-testify
                             go-github-com-go-jose-go-jose-v4
                             go-github-com-microsoft-go-winio))
    (home-page "https://github.com/spiffe/go-spiffe")
    (synopsis #f)
    (description #f)
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
                             go-cloud-google-com-go-compute-metadata))
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
      #:go #{go-#f}#
      #:import-path "go.opentelemetry.io/contrib/detectors/gcp"
      #:unpack-path "go.opentelemetry.io/contrib"))
    (propagated-inputs (list go-go-opentelemetry-io-otel-sdk
                        go-go-opentelemetry-io-otel
                        go-github-com-stretchr-testify
                        go-github-com-google-go-cmp
                        go-github-com-googlecloudplatform-opentelemetry-operations-go-detectors-gcp
                        go-cloud-google-com-go-compute-metadata))
    (home-page "https://go.opentelemetry.io/contrib")
    (synopsis "GCP Resource detector")
    (description "The GCP resource detector supports detecting resources on:.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-otel-metric
  (package
    (name "go-go-opentelemetry-io-otel-metric")
    (version "1.36.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-go")
             (commit (go-version->git-ref version
                                          #:subdir "metric"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1kvfbqc56p1h9rh9cvgn37ya6k10613r0f2rhjiwrrkgs2mszk30"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "go.opentelemetry.io/otel/metric"
      #:unpack-path "go.opentelemetry.io/otel"))
    (propagated-inputs (list go-github-com-stretchr-testify))
    (home-page "https://go.opentelemetry.io/otel")
    (synopsis "Metric API")
    (description
     "Package metric provides the @code{OpenTelemetry} API used to measure metrics
about source code operation.")
    (license license:asl2.0)))

(define-public go-go-opentelemetry-io-otel-trace
  (package
    (name "go-go-opentelemetry-io-otel-trace")
    (version "1.36.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/open-telemetry/opentelemetry-go")
             (commit (go-version->git-ref version
                                          #:subdir "trace"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1kvfbqc56p1h9rh9cvgn37ya6k10613r0f2rhjiwrrkgs2mszk30"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "go.opentelemetry.io/otel/trace"
      #:unpack-path "go.opentelemetry.io/otel"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-github-com-google-go-cmp))
    (home-page "https://go.opentelemetry.io/otel")
    (synopsis "Trace API")
    (description
     "Package trace provides an implementation of the tracing part of the
@code{OpenTelemetry} API.")
    (license license:asl2.0)))

(define-public go-google-golang-org-genproto-googleapis-rpc
  (package
    (name "go-google-golang-org-genproto-googleapis-rpc")
    (version "0.0.0-20250519155744-55703ea1f237")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/googleapis/go-genproto")
             (commit (go-version->git-ref version
                                          #:subdir "googleapis/rpc"))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1ilf95lhx7930cqx2hmswxasxyxjz3xmbznd0cfcglzdl3d9k4rk"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go #{go-#f}#
      #:import-path "google.golang.org/genproto/googleapis/rpc"
      #:unpack-path "google.golang.org/genproto"))
    (propagated-inputs (list go-google-golang-org-protobuf))
    (home-page "https://google.golang.org/genproto")
    (synopsis #f)
    (description #f)
    (license license:asl2.0)))

(define-public go-google-golang-org-grpc
  (package
    (name "go-google-golang-org-grpc")
    (version "1.72.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/grpc/grpc-go")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0m561i99rfjlzfljbm7j2l5a3birakdl92jpkrlpnyg54zq9gqzx"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.23
      #:import-path "google.golang.org/grpc"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-genproto-googleapis-rpc
                             go-golang-org-x-sys
                             go-golang-org-x-sync
                             go-golang-org-x-oauth2
                             go-golang-org-x-net
                             go-go-opentelemetry-io-otel-trace
                             go-go-opentelemetry-io-otel-sdk-metric
                             go-go-opentelemetry-io-otel-sdk
                             go-go-opentelemetry-io-otel-metric
                             go-go-opentelemetry-io-otel
                             go-go-opentelemetry-io-contrib-detectors-gcp
                             go-github-com-spiffe-go-spiffe-v2
                             go-github-com-google-uuid
                             go-github-com-google-go-cmp
                             go-github-com-golang-protobuf
                             go-github-com-golang-glog
                             go-github-com-envoyproxy-go-control-plane-envoy
                             go-github-com-envoyproxy-go-control-plane
                             go-github-com-cncf-xds-go
                             go-github-com-cespare-xxhash-v2))
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
      #:import-path "github.com/apache/arrow/go/arrow"
      #:unpack-path "github.com/apache/arrow"))
    (propagated-inputs (list go-google-golang-org-protobuf
                             go-google-golang-org-grpc
                             go-gonum-org-v1-gonum
                             go-golang-org-x-xerrors
                             go-golang-org-x-exp
                             go-github-com-stretchr-testify
                             go-github-com-pierrec-lz4-v4
                             go-github-com-klauspost-compress
                             go-github-com-google-flatbuffers
                             go-github-com-golang-protobuf))
    (home-page "https://github.com/apache/arrow")
    (synopsis #f)
    (description "Package arrow provides an implementation of Apache Arrow.")
    (license unknown-license!)))

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
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wcpaj4k9dwccb752pl8p54pqwajr51sxjym32q2bpm9ny6ib45v"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/google/flatbuffers"))
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
      #:import-path "gorgonia.org/vecf64"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-github-com-pmezard-go-difflib
                             go-github-com-davecgh-go-spew))
    (home-page "https://gorgonia.org/vecf64")
    (synopsis "vecf64")
    (description
     "Package vecf64 provides common functions and methods for slices of float64.")
    (license license:expat)))

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
      #:go #{go-#f}#
      #:import-path "github.com/pdevine/tensor"))
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
      #:go #{go-#f}#
      #:import-path "github.com/gin-contrib/cors"))
    (propagated-inputs (list go-github-com-stretchr-testify
                             go-github-com-gin-gonic-gin))
    (home-page "https://github.com/gin-contrib/cors")
    (synopsis "CORS gin's middleware")
    (description "Gin middleware/handler to enable CORS support.")
    (license license:expat)))

(define-public go-github-com-ollama-ollama
  (package
    (name "go-github-com-ollama-ollama")
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
      #:go #{go-#f}#
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
                             go-github-com-dlclark-regexp2
                             go-github-com-d4l3k-go-bfloat16
                             go-github-com-agnivade-levenshtein
                             go-golang-org-x-sync
                             go-github-com-x448-float16
                             go-github-com-stretchr-testify
                             go-github-com-spf13-cobra
                             go-github-com-olekukonko-tablewriter
                             go-github-com-google-uuid
                             go-github-com-gin-gonic-gin
                             go-github-com-containerd-console))
    (home-page "https://github.com/ollama/ollama")
    (synopsis "Ollama")
    (description "Get up and running with large language models.")
    (license license:expat)))

