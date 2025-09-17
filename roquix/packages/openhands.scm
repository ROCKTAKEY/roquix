(define-module
  (roquix packages openhands)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-science)
  #:use-module (gnu packages terminals)
  #:use-module (gnu packages time)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages docker)
  #:use-module (gnu packages protobuf)
  #:use-module (gnu packages databases))

;; Additional required packages

(define-public python-anthropic
  (package
    (name "python-anthropic")
    (version "0.54.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "anthropic" version))
       (sha256
        (base32 "05d8dfxn41a335mvgfrzjpzxxb93gwpfrhq3qvm713nfjxyrjvsy"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f))
    (propagated-inputs (list python-anyio
                             python-distro
                             python-httpx
                             python-pydantic
                             python-sniffio
                             python-typing-extensions))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://www.anthropic.com")
    (synopsis "The official Python library for the anthropic API")
    (description "The official Python library for the anthropic API.")
    (license license:expat)))

(define-public python-bashlex
  (package
    (name "python-bashlex")
    (version "0.18")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "bashlex" version))
       (sha256
        (base32 "1vln4zszzdqkypiir2hxsvkhgbf816005lbgqcw66rymqq0kmc2v"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/idank/bashlex")
    (synopsis "Python parser for bash")
    (description "Python parser for bash.")
    (license license:gpl3)))

(define-public python-dirhash
  (package
    (name "python-dirhash")
    (version "0.5.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "dirhash" version))
       (sha256
        (base32 "11jkrpa5z63qyxfpiv1clkf9h8s9qsi3x4l8n265v4rfmgq601z6"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/andhus/dirhash-python")
    (synopsis "Python module and CLI for hashing of file system directories")
    (description
     "Python module and CLI for hashing of file system directories.")
    (license license:expat)))

(define-public python-json-repair
  (package
    (name "python-json-repair")
    (version "0.47.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "json_repair" version))
       (sha256
        (base32 "0188fmpg5bh6anlfpirfpm4b3jh51a6clx0gj00cxd9cxx6swcp2"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/manie4ever/json-repair")
    (synopsis "A package to repair broken json strings")
    (description
     "This package provides a package to repair broken json strings.")
    (license license:expat)))

(define-public python-libtmux
  (package
    (name "python-libtmux")
    (version "0.46.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "libtmux" version))
       (sha256
        (base32 "1njxbjrcxa3mpsm0gfj1yz0dy0x9w5kd8ma56k42jhbibpn8yfcs"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://libtmux.git-pull.com")
    (synopsis
     "Typed library that provides an ORM wrapper for tmux, a terminal multiplexer")
    (description
     "Typed library that provides an ORM wrapper for tmux, a terminal multiplexer.")
    (license license:expat)))

(define-public python-whatthepatch
  (package
    (name "python-whatthepatch")
    (version "1.0.7")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "whatthepatch" version))
       (sha256
        (base32 "1pvygmgj9xqs8d9lsjxvg1mymni8pjsd44yl0a74002jxbmv9vwy"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/cscorley/whatthepatch")
    (synopsis "A patch parsing and application library")
    (description
     "This package provides a patch parsing and application library.")
    (license license:expat)))

(define-public python-sse-starlette
  (package
    (name "python-sse-starlette")
    (version "2.3.6")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "sse_starlette" version))
       (sha256
        (base32 "1qrnnh1sgq1ia6ciqv1dnxlinplhca4m384wrxh03hsfgmpk70h3"))))
    (build-system pyproject-build-system)
    (arguments
     (list #:tests? #f      ; Tests not available or failing
           #:phases
           #~(modify-phases %standard-phases
               (delete 'sanity-check))))  ; Skip sanity check due to version conflicts
    (propagated-inputs (list python-anyio))
    (native-inputs (list python-setuptools python-wheel))
    (home-page #f)
    (synopsis "SSE plugin for Starlette")
    (description "SSE plugin for Starlette.")
    (license license:expat)))

(define-public python-openhands-ai
  (package
    (name "python-openhands-ai")
    (version "0.44.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "openhands_ai" version))
       (sha256
        (base32 "0zmyjr1lwxcp9js3fd8w9qsmah6cym41mvqy3alxavq3vvga5x8w"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-aiohttp
                             python-anthropic
                             python-anyio
                             python-bashlex
                             python-boto3
                             python-browsergym-core  ; Complex dependencies
                             python-daytona-sdk  ; Complex dependencies
                             python-dirhash
                             python-docker
                             python-e2b  ; Not available
                             python-fastapi
                             python-fastmcp  ; Not available
                             python-google-api-python-client  ; Not available
                             python-google-auth-httplib2  ; Not available
                             python-google-auth-oauthlib  ; Not available
                             python-google-cloud-aiplatform  ; Not available
                             python-google-generativeai  ; Not available
                             python-html2text
                             python-ipywidgets
                             python-jinja2
                             python-joblib
                             python-json-repair
                             python-libtmux
                             python-litellm  ; Not available
                             python-minio  ; Not available
                             python-modal  ; Not available
                             python-numpy
                             python-openhands-aci  ; Not available
                             python-opentelemetry-api  ; Not available
                             python-opentelemetry-exporter-otlp-proto-grpc  ; Not available
                             python-pathspec
                             python-pexpect
                             python-poetry  ; Not available
                             python-prompt-toolkit
                             python-protobuf
                             python-psutil
                             python-pygithub
                             python-pyjwt
                             python-pylatexenc  ; Available as python-pylatex
                             python-pypdf2  ; May be available as python-pypdf
                             python-docx
                             python-dotenv
                             python-frontmatter  ; Not available
                             python-json-logger
                             python-multipart
                             python-pptx  ; Not available
                             python-socketio
                             python-pythonnet  ; Not available
                             python-qtconsole  ; Available
                             python-rapidfuzz
                             python-redis
                             python-runloop-api-client  ; Not available
                             python-sse-starlette
                             python-stripe  ; Not available
                             python-tenacity
                             python-termcolor
                             python-toml
                             python-tornado
                             python-types-toml  ; Not available
                             python-uvicorn
                             python-whatthepatch
                             python-zope-interface))
    (native-inputs (list python-poetry-core))
    (home-page "https://github.com/All-Hands-AI/OpenHands")
    (synopsis "OpenHands: Code Less, Make More")
    (description "@code{OpenHands}: Code Less, Make More.")
    (license license:expat)))
