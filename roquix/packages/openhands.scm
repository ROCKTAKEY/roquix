(define-module
  (roquix packages openhands)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web))

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
                             python-browsergym-core
                             python-daytona-sdk
                             python-dirhash
                             python-docker
                             python-e2b
                             python-fastapi
                             python-fastmcp
                             python-google-api-python-client
                             python-google-auth-httplib2
                             python-google-auth-oauthlib
                             python-google-cloud-aiplatform
                             python-google-generativeai
                             python-html2text
                             python-ipywidgets
                             python-jinja2
                             python-joblib
                             python-json-repair
                             python-libtmux
                             python-litellm
                             python-minio
                             python-modal
                             python-numpy
                             python-openhands-aci
                             python-opentelemetry-api
                             python-opentelemetry-exporter-otlp-proto-grpc
                             python-pathspec
                             python-pexpect
                             python-poetry
                             python-prompt-toolkit
                             python-protobuf
                             python-psutil
                             python-pygithub
                             python-pyjwt
                             python-pylatexenc
                             python-pypdf2
                             python-docx
                             python-dotenv
                             python-frontmatter
                             python-json-logger
                             python-multipart
                             python-pptx
                             python-socketio
                             python-pythonnet
                             python-qtconsole
                             python-rapidfuzz
                             python-redis
                             python-runloop-api-client
                             python-sse-starlette
                             python-stripe
                             python-tenacity
                             python-termcolor
                             python-toml
                             python-tornado
                             python-types-toml
                             python-uvicorn
                             python-whatthepatch
                             python-zope-interface))
    (native-inputs (list python-poetry-core))
    (home-page "https://github.com/All-Hands-AI/OpenHands")
    (synopsis "OpenHands: Code Less, Make More")
    (description "@code{OpenHands}: Code Less, Make More.")
    (license license:expat)))
