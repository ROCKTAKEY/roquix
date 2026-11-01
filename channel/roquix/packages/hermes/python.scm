(define-module (roquix packages hermes python)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages web)
  #:use-module (gnu packages perl)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system cargo)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages image)
  #:use-module (gnu packages compression)
  #:use-module (roquix packages hermes interpreter)
  #:re-export (hermes-python))

;; Definitions originate from guix import pypi at the versions in uv.lock.
;; Runtime dependencies follow the lock's CPython 3.14 Linux selection.
(define* (python-arguments #:key cargo-group restore-cargo-lock?)
  (list #:python hermes-python-wrapper
        ;; The installed Hermes check exercises this locked dependency set together.
        #:tests? #f
        #:configure-flags
        (if cargo-group
            #~'(("maturin.build-args" . "--offline --compatibility linux"))
            #~'())
        #:imported-modules (append %pyproject-build-system-modules
                                   %cargo-build-system-modules
                                   (source-module-closure '((roquix build
                                                             hermes
                                                             python-build))
                                                          #:select? (lambda (name)
                                                                      (memq (car
                                                                             name)
                                                                            '(guix
                                                                              roquix)))))
        #:modules '((guix build pyproject-build-system)
                    ((guix build cargo-build-system)
                     #:prefix cargo:)
                    (guix build utils)
                    (roquix build hermes python-build))
        #:phases #~(modify-phases %standard-phases
                     (add-after 'unpack 'prepare-build-environment
                       prepare-python-build-environment)
                     #$@(if cargo-group
                            (list #~(add-before 'build
                                                'configure-cargo
                                                (lambda args
                                                  (setenv "CARGO_BUILD_JOBS"
                                                          (number->string (parallel-job-count)))
                                                  (setenv
                                                   "CARGO_PROFILE_RELEASE_DEBUG"
                                                   "0")
                                                  (setenv "OPENSSL_NO_VENDOR"
                                                          "1")
                                                  (setenv "PYO3_PYTHON"
                                                          (which "python"))
                                                  (for-each (lambda (phase)
                                                              (apply (assoc-ref
                                                                      cargo:%standard-phases
                                                                      phase)
                                                                     #:cargo-target #$
                                                                     (cargo-triplet)
                                                                     args))
                                                            '(unpack-rust-crates
                                                              configure
                                                              check-for-pregenerated-files
                                                              patch-cargo-checksums)))))
                            '())
                     #$@(if restore-cargo-lock?
                            (list #~(add-before 'build
                                                'restore-cargo-lock
                                                (lambda _
                                                  (invoke "cargo"
                                                          "generate-lockfile"
                                                          "--offline"))))
                            '()))))

(define-public hermes-python-annotated-doc
  (package
    (name "hermes-python-annotated-doc")
    (version "0.0.5")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fastapi/annotated-doc")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12nrlrrbp6vnmv11845zrcflbk6d8ndcmjv239x3lankbrpjw61a"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-pdm-backend))
    (home-page "https://github.com/fastapi/annotated-doc")
    (synopsis "Documentation metadata for Python type annotations")
    (description
     "Document parameters, class attributes, return types, and variables inline, with
Annotated.")
    (license license:expat)))

(define-public hermes-python-annotated-types
  (package
    (name "hermes-python-annotated-types")
    (version "0.8.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/annotated-types/annotated-types")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0pnz8fpyp0fdz2jzc8rlqrmvzja4jrm0jm6d2mxk5qs5w0p40fyz"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-hatchling))
    (home-page "https://github.com/annotated-types/annotated-types")
    (synopsis "Reusable constraint types to use with typing.Annotated")
    (description "Reusable constraint types to use with typing.Annotated.")
    (license license:expat)))

(define-public hermes-python-anyio
  (package
    (name "hermes-python-anyio")
    (version "4.14.2")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "anyio" version))
       (sha256
        (base32 "0zrw66s8ngffsynbm4l5znxvh1bnmjsxsid1i27yw8qsxprkk8fg"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-idna
                             hermes-python-typing-extensions))
    (native-inputs (list python-setuptools python-setuptools-scm python-wheel))
    (home-page "https://pypi.org/project/anyio/")
    (synopsis "High-level concurrency and networking framework on top of asyncio or Trio")
    (description
     "High-level concurrency and networking framework on top of asyncio or Trio.")
    (license license:expat)))

(define-public hermes-python-browser-harness
  (package
    (name "hermes-python-browser-harness")
    (version "0.1.13")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/browser-use/browser-harness")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "13lch5dfn61q250637k3k8viw6nyw9hl1v1126kh7rnc15wkfn5h"))))
    (build-system pyproject-build-system)
    (arguments
     (substitute-keyword-arguments (python-arguments)
       ((#:phases phases)
        #~(modify-phases #$phases
            ;; mcp_server belongs to the optional MCP extra.  Hermes's core
            ;; lock selects the browser API and lazy CLI entry points only.
            (replace 'sanity-check
              (lambda _
                (with-directory-excursion "/tmp"
                  (invoke "python" "-c"
                   "import browser_harness, browser_harness.run, browser_harness.mcp_cli; import pkg_resources; pkg_resources.require('browser-harness')"))))
            ;; Hermes's [tool.uv].override-dependencies selects Pillow 13 for
            ;; this release; match that contract in the installed metadata too.
            (add-before 'build 'apply-hermes-pillow-override
              (lambda _
                (substitute* "pyproject.toml"
                  (("pillow==12.3.0")
                   "pillow==13.0.0"))))))))
    (propagated-inputs (list hermes-python-cdp-use hermes-python-fetch-use
                             hermes-python-pillow hermes-python-websockets))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/browser-use/browser-harness")
    (synopsis "Browser control API for agents")
    (description "This package provides browser automation helpers and command-line entry points for agents.")
    (license license:expat)))

(define-public hermes-python-cdp-use
  (package
    (name "hermes-python-cdp-use")
    (version "1.4.5")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "cdp_use" version))
       (sha256
        (base32 "1816dmzx6abghpa8y48asprd5mrc8jyccax2ylzs0dk3yhns78qd"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-httpx
                             hermes-python-typing-extensions
                             hermes-python-websockets))
    (native-inputs (list python-hatchling))
    (home-page "https://pypi.org/project/cdp-use/")
    (synopsis "Type safe generator/client library for CDP")
    (description "Type safe generator/client library for CDP.")
    (license license:expat)))

(define-public hermes-python-certifi
  (package
    (name "hermes-python-certifi")
    (version "2026.10.19")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/certifi/python-certifi")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bslxg80asld9ymyv1r3blx1grd0nk7hkr3g3psfls2w4k9ll8vs"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/certifi/python-certifi")
    (synopsis "Python package for providing Mozilla's CA Bundle")
    (description "Python package for providing Mozilla's CA Bundle.")
    (license license:mpl2.0)))

(define-public hermes-python-cffi
  (package
    (name "hermes-python-cffi")
    (version "2.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "cffi" version))
       (sha256
        (base32 "1ghj0w06m0mwg1dksyh6mqiq74dqx778y3zkknxi6r88l4pgacfx"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-pycparser))
    (native-inputs (list python-setuptools python-wheel python-pycparser
                         pkg-config))
    (inputs (list libffi))
    (home-page "https://pypi.org/project/cffi/")
    (synopsis "Foreign Function Interface for Python calling C code")
    (description "Foreign Function Interface for Python calling C code.")
    (license license:expat-0)))

(define-public hermes-python-charset-normalizer
  (package
    (name "hermes-python-charset-normalizer")
    (version "3.5.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "charset_normalizer" version))
       (sha256
        (base32 "1hzay0ypbz9lnjkmyds3p8h0khw52h9gady7dlsyadc4li7bh5v1"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://pypi.org/project/charset-normalizer/")
    (synopsis "Character encoding detection for Python")
    (description
     "The Real First Universal Charset Detector.  Open, modern and actively maintained
alternative to Chardet.")
    (license license:expat)))

(define-public hermes-python-click
  (package
    (name "hermes-python-click")
    (version "8.4.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pallets/click/")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "123jdgpkwn363955csqymgmay26y5axv5sjnxjaf0p8gdhc4b8pb"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-flit-core))
    (home-page "https://github.com/pallets/click/")
    (synopsis "Composable command line interface toolkit")
    (description "Composable command line interface toolkit.")
    (license license:bsd-3)))

(define-public hermes-python-croniter
  (package
    (name "hermes-python-croniter")
    (version "6.0.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pallets-eco/croniter")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0kb2439py599vjr9fi90h7b2hv2k2cpsjciv3ayxj6zdiwsxn0hc"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-python-dateutil hermes-python-pytz))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/pallets-eco/croniter")
    (synopsis "Croniter provides iteration for datetime object with cron like format")
    (description
     "croniter provides iteration for datetime object with cron like format.")
    (license license:expat)))

(define-public hermes-python-cryptography
  (package
    (name "hermes-python-cryptography")
    (version "50.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "cryptography" version))
       (sha256
        (base32 "087z2kaa4qwazrf8fvj02j6w4mpr1xgfp3jnzzv64h9bq6hvvnax"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments #:cargo-group "hermes-cryptography-50.0.1"
                       #:restore-cargo-lock? #t))
    (propagated-inputs (list hermes-python-cffi
                             hermes-python-typing-extensions))
    (native-inputs (list maturin
                         hermes-python-cffi
                         python-setuptools
                         python-wheel
                         rust-1.96
                         (list rust-1.96 "cargo")
                         pkg-config))
    (inputs (append (list openssl)
                    (cargo-inputs 'hermes-cryptography-50.0.1
                                  #:module '(roquix packages rust-crates))))
    (home-page "https://pypi.org/project/cryptography/")
    (synopsis "Cryptographic recipes and primitives for Python")
    (description
     "cryptography is a package which provides cryptographic recipes and primitives to
Python developers.")
    (license (list license:asl2.0 license:bsd-3))))

(define hermes-python-distro
  (specification->package "python-distro@1.9.0"))

(define-public hermes-python-fastapi
  (package
    (name "hermes-python-fastapi")
    (version "0.133.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/fastapi/fastapi")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1rj31cdcj7rjwpr5wsmp0421b405finn3clidrjny5vi159rw8sc"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-annotated-doc
                             hermes-python-httpx
                             hermes-python-jinja2
                             hermes-python-pydantic
                             hermes-python-python-multipart
                             hermes-python-starlette
                             hermes-python-typing-extensions
                             hermes-python-typing-inspection
                             hermes-python-uvicorn))
    (native-inputs (list python-pdm-backend))
    (home-page "https://github.com/fastapi/fastapi")
    (synopsis "ASGI web framework for building APIs with Python type hints")
    (description
     "@code{FastAPI} framework, high performance, easy to learn, fast to code, ready
for production.")
    (license license:expat)))

(define-public hermes-python-fetch-use
  (package
    (name "hermes-python-fetch-use")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "fetch_use" version))
       (sha256
        (base32 "16hqpa0wv2a1p8mbq8axdgv9h06i8rlxc88ya2n6vv0795yrh4cm"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-hatchling))
    (home-page "https://browser-use.com")
    (synopsis "Python client for Browser-Use Fetch HTTP service")
    (description "Python client for Browser-Use Fetch HTTP service.")
    (license license:expat)))

(define-public hermes-python-fire
  (package
    (name "hermes-python-fire")
    (version "0.7.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/google/python-fire")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12plzm3xdhgpxk3s96i3van8g5zpfxgdwr7z0zni7wypkkpcp4jd"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-termcolor))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/google/python-fire")
    (synopsis "Library for automatically generating command line interfaces")
    (description
     "This package provides a library for automatically generating command line
interfaces.")
    (license license:asl2.0)))

(define-public hermes-python-firecrawl-anydoc
  (package
    (name "hermes-python-firecrawl-anydoc")
    (version "0.2.4")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://files.pythonhosted.org/packages/35/54/ee43b1661a954e53eaed85878a7ccc37ed73e02e6577bb26437ec5f9de94/firecrawl_anydoc-0.2.4.tar.gz")
       (sha256
        (base32 "0cihr1i27xv7k29xqk9135cz07qgdcgz2npx13g1ra7yf814ca9y"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments #:cargo-group "hermes-firecrawl_anydoc-0.2.4"))
    (native-inputs (list maturin rust-1.96
                         (list rust-1.96 "cargo") pkg-config))
    (inputs (append (list openssl)
                    (cargo-inputs 'hermes-firecrawl_anydoc-0.2.4
                                  #:module '(roquix packages rust-crates))))
    (home-page "https://github.com/firecrawl/anydoc")
    (synopsis "Document parsing bindings")
    (description
     "This package provides Python bindings for AnyDoc document parsing.")
    (license license:expat)))

(define hermes-python-h11
  (specification->package "python-h11@0.16.0"))

(define hermes-python-httpcore
  (specification->package "python-httpcore@1.0.9"))

(define-public hermes-python-httptools
  (package
    (name "hermes-python-httptools")
    (version "0.8.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/MagicStack/httptools")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1q9siap8m2k82m0ppd95fr0qmsjkmxib5afhc4kz2m4iij0lxvpm"))))
    (build-system pyproject-build-system)
    (arguments
     (substitute-keyword-arguments (python-arguments)
       ((#:phases phases)
        #~(modify-phases #$phases
            ;; Git omits the vendored submodules; use Guix's parser libraries.
            (add-before 'build 'use-system-parsers
              (lambda _
                (call-with-output-file "setup.cfg"
                  (lambda (port)
                    (display "[build_ext]
use-system-llhttp = 1
use-system-http-parser = 1
" port)))))))))
    (inputs (list llhttp http-parser))
    (native-inputs (list python-setuptools python-wheel python-cython))
    (home-page "https://github.com/MagicStack/httptools")
    (synopsis "Collection of framework independent HTTP protocol utils")
    (description
     "This package provides a collection of framework independent HTTP protocol utils.")
    (license license:expat)))

(define hermes-python-httpx
  (specification->package "python-httpx@0.28.1"))

(define-public hermes-python-idna
  (package
    (name "hermes-python-idna")
    (version "3.19")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/kjd/idna")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02k8m08n4zhx8jnkr2z6xf2ac3c9hb4hsxknip8s4ki758fa52pp"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-flit-core))
    (home-page "https://github.com/kjd/idna")
    (synopsis "Internationalized Domain Names in Applications (IDNA)")
    (description "Internationalized Domain Names in Applications (IDNA).")
    (license license:bsd-3)))

(define hermes-python-jinja2
  (specification->package "python-jinja2@3.1.6"))

(define-public hermes-python-jiter
  (package
    (name "hermes-python-jiter")
    (version "0.16.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pydantic/jiter/")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0vd5vgs6ld0r980b9ly8kg5q2sc9nj3h530ypcf0sghxnz1hr40j"))))
    (build-system pyproject-build-system)
    (arguments
     (substitute-keyword-arguments
         (python-arguments #:cargo-group "hermes-jiter-0.16.0")
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build 'enter-python-workspace
              (lambda _ (chdir "crates/jiter-python")))))))
    (native-inputs (list maturin rust-1.96
                         (list rust-1.96 "cargo") pkg-config))
    (inputs (append (list openssl)
                    (cargo-inputs 'hermes-jiter-0.16.0
                                  #:module '(roquix packages rust-crates))))
    (home-page "https://github.com/pydantic/jiter/")
    (synopsis "Fast iterable JSON parser")
    (description "Fast iterable JSON parser.")
    (license license:expat)))

(define hermes-python-markdown
  (specification->package "python-markdown@3.10.2"))

(define-public hermes-python-markdown-it-py
  (package
    (name "hermes-python-markdown-it-py")
    (version "4.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/executablebooks/markdown-it-py")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "148fkbdvswna5k7kgyx2rrv27bnxgz0sq705qhnaraf6z4z46z2b"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-markdown hermes-python-mdurl
                             hermes-python-psutil hermes-python-requests))
    (native-inputs (list python-flit-core))
    (home-page "https://github.com/executablebooks/markdown-it-py")
    (synopsis "Python port of markdown-it. Markdown parsing, done right!")
    (description "Python port of markdown-it.  Markdown parsing, done right!.")
    (license license:expat)))

(define-public hermes-python-markupsafe
  (package
    (inherit (specification->package "python-markupsafe@3.0.3"))
    (name "hermes-python-markupsafe")
    (arguments (python-arguments))
    (native-inputs (list python-setuptools python-wheel))))

(define hermes-python-mdurl
  (specification->package "python-mdurl@0.1.2"))

(define-public hermes-python-nemo-relay
  (package
    (name "hermes-python-nemo-relay")
    (version "0.10.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/NVIDIA/NeMo-Relay")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1v48nxn8brx3i3n52mqk23jp1awi0z69d5v7pwizphwccwgk2c61"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments #:cargo-group "hermes-nemo_relay-0.10.0"))
    (native-inputs (list maturin rust-1.96
                         (list rust-1.96 "cargo") pkg-config))
    (inputs (append (list openssl
                          (list zstd "lib"))
                    (cargo-inputs 'hermes-nemo_relay-0.10.0
                                  #:module '(roquix packages rust-crates))))
    (home-page "https://github.com/NVIDIA/NeMo-Relay")
    (synopsis "Python bindings for the NeMo Relay agent runtime")
    (description "Python bindings for the @code{NeMo} Relay agent runtime.")
    (license license:asl2.0)))

(define-public hermes-python-openai
  (package
    (name "hermes-python-openai")
    (version "2.24.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openai/openai-python")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "102pj6iac28z05xj07d5hlka34920nx2m241silm1x9kph2hsnn4"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-anyio
                             hermes-python-distro
                             hermes-python-httpx
                             hermes-python-jiter
                             hermes-python-pydantic
                             hermes-python-sniffio
                             hermes-python-tqdm
                             hermes-python-typing-extensions))
    (native-inputs (list python-hatchling python-hatch-fancy-pypi-readme))
    (home-page "https://github.com/openai/openai-python")
    (synopsis "Official Python library for the openai API")
    (description "The official Python library for the openai API.")
    (license license:asl2.0)))

(define-public hermes-python-packaging
  (package
    (name "hermes-python-packaging")
    (version "26.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pypa/packaging")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1vsb5sw43jbfk1rm80rxw4fdaz7rsqcmp045fpd3b2bi5w5yvyr6"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-flit-core))
    (home-page "https://github.com/pypa/packaging")
    (synopsis "Core utilities for Python packages")
    (description "Core utilities for Python packages.")
    (license (list license:asl2.0 license:bsd-2))))

(define hermes-python-pathspec
  (specification->package "python-pathspec@1.1.1"))

(define-public hermes-python-pillow
  (package
    (name "hermes-python-pillow")
    (version "13.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pillow" version))
       (sha256
        (base32 "041mpvk6yajs590bqj2psnjvdsm43flcjw21sxb773qpb2i1pkfd"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list pybind11 python-setuptools python-wheel))
    (inputs (package-inputs python-pillow))
    (home-page "https://python-pillow.org")
    (synopsis "Python Imaging Library (fork)")
    (description "Python Imaging Library (fork).")
    (license (license:non-copyleft "https://spdx.org/licenses/MIT-CMU.html"))))

(define-public hermes-python-pillow-heif
  (package
    (name "hermes-python-pillow-heif")
    (version "1.6.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/bigcat88/pillow_heif")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0ajfwzyaba5fgnlf7r4gdk7fd4dx15z959wv1q39bq6jwvzlli7r"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-pillow))
    (native-inputs (list python-setuptools python-wheel python-cython))
    (inputs (list libheif))
    (home-page "https://github.com/bigcat88/pillow_heif")
    (synopsis "Python interface for libheif library")
    (description "Python interface for libheif library.")
    (license license:bsd-3)))

(define-public hermes-python-prompt-toolkit
  (package
    (name "hermes-python-prompt-toolkit")
    (version "3.0.52")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/prompt-toolkit/python-prompt-toolkit")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m50wa0r1vqs9awc53h51q0j5m1nrzx3nb1qx3r4hfpg2kpv4042"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-wcwidth))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/prompt-toolkit/python-prompt-toolkit")
    (synopsis "Library for building powerful interactive command lines in Python")
    (description
     "Library for building powerful interactive command lines in Python.")
    (license license:bsd-3)))

(define-public hermes-python-psutil
  (package
    (inherit (specification->package "python-psutil@7.2.2"))
    (name "hermes-python-psutil")
    (arguments (python-arguments))
    (native-inputs (list python-setuptools python-wheel))))

(define hermes-python-ptyprocess
  (specification->package "python-ptyprocess@0.7.0"))

(define-public hermes-python-pycparser
  (package
    (name "hermes-python-pycparser")
    (version "3.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pycparser" version))
       (sha256
        (base32 "0abbzkywvi84jlx69pl90i6lxscz3hlf2drwmh15jjih2z94j3v0"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/eliben/pycparser")
    (synopsis "C parser in Python")
    (description "C parser in Python.")
    (license license:bsd-3)))

(define-public hermes-python-pydantic
  (package
    (name "hermes-python-pydantic")
    (version "2.13.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pydantic/pydantic")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "083ihr9sskhx00vyqfn2i6azwzrz8c9xv1pshgwfkd3s27lfi18v"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-annotated-types
                             hermes-python-pydantic-core
                             hermes-python-typing-extensions
                             hermes-python-typing-inspection))
    (native-inputs (list python-hatchling python-hatch-fancy-pypi-readme))
    (home-page "https://github.com/pydantic/pydantic")
    (synopsis "Data validation using Python type hints")
    (description "Data validation using Python type hints.")
    (license license:expat)))

(define-public hermes-python-pydantic-core
  (package
    (name "hermes-python-pydantic-core")
    (version "2.46.4")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pydantic_core" version))
       (sha256
        (base32 "1hg1nrj1z9sfnsr6vmlj4b4br0ph54pds8q5y98hh9vz7lwpby32"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments #:cargo-group "hermes-pydantic_core-2.46.4"))
    (propagated-inputs (list hermes-python-typing-extensions))
    (native-inputs (list maturin rust-1.96
                         (list rust-1.96 "cargo") pkg-config))
    (inputs (append (list openssl)
                    (cargo-inputs 'hermes-pydantic_core-2.46.4
                                  #:module '(roquix packages rust-crates))))
    (home-page "https://github.com/pydantic/pydantic")
    (synopsis "Core functionality for Pydantic validation and serialization")
    (description
     "Core functionality for Pydantic validation and serialization.")
    (license license:expat)))

(define-public hermes-python-pygments
  (package
    (name "hermes-python-pygments")
    (version "2.21.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pygments" version))
       (sha256
        (base32 "132wxqylkbk69vrxlbhqsyrbpvckpizqm8xrisrr495wr58sf331"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-hatchling))
    (home-page "https://pygments.org")
    (synopsis "Pygments is a syntax highlighting package written in Python")
    (description
     "Pygments is a syntax highlighting package written in Python.")
    (license license:bsd-2)))

(define-public hermes-python-pyjwt
  (package
    (name "hermes-python-pyjwt")
    (version "2.15.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jpadilla/pyjwt")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0gwyr7vpdd9jhci3g0msxh18nbm4wggpr03qbaj6b0qmvx078s8b"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-typing-extensions))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/jpadilla/pyjwt")
    (synopsis "JSON Web Token implementation in Python")
    (description "JSON Web Token implementation in Python.")
    (license license:expat)))

(define-public hermes-python-python-dateutil
  (package
    (name "hermes-python-python-dateutil")
    (version "2.9.0.post0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/dateutil/dateutil")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0ak1clqazvzvbg84bs5kixw7rmlpisfpzkfs6hxbfpghwlqkz831"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-six))
    (native-inputs (list python-setuptools python-wheel python-setuptools-scm))
    (home-page "https://github.com/dateutil/dateutil")
    (synopsis "Extensions to the standard Python datetime module")
    (description "Extensions to the standard Python datetime module.")
    (license (list license:asl2.0 license:bsd-3))))

(define hermes-python-python-dotenv
  (specification->package "python-dotenv@1.2.2"))

(define hermes-python-python-multipart
  (specification->package "python-multipart@0.0.32"))

(define-public hermes-python-pytz
  (package
    (name "hermes-python-pytz")
    (version "2026.3.post1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pytz" version))
       (sha256
        (base32 "0p8c06ifhbr80yb318vj9xj6l3nqc5zsr5mcbi0d75x7z7yd6492"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://pythonhosted.org/pytz")
    (synopsis "World timezone definitions, modern and historical")
    (description "World timezone definitions, modern and historical.")
    (license license:expat)))

(define-public hermes-python-requests
  (package
    (name "hermes-python-requests")
    (version "2.33.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/psf/requests")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0xmm5yw6s8ndj57n17y5vcqhhl5182h0hfddv7jqhfi6w364d8k1"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-certifi
                             hermes-python-charset-normalizer
                             hermes-python-idna hermes-python-urllib3))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/psf/requests")
    (synopsis "Python HTTP for Humans")
    (description "Python HTTP for Humans.")
    (license license:asl2.0)))

(define-public hermes-python-resvg-py
  (package
    (name "hermes-python-resvg-py")
    (version "0.4.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "resvg_py" version))
       (sha256
        (base32 "0hvw2n5nvbvz22idqdbykgnwwfxd05idqlc43r0j7fvr44zii4vv"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments #:cargo-group "hermes-resvg_py-0.4.0"))
    (native-inputs (list maturin rust-1.96
                         (list rust-1.96 "cargo") pkg-config))
    (inputs (append (list openssl)
                    (cargo-inputs 'hermes-resvg_py-0.4.0
                                  #:module '(roquix packages rust-crates))))
    (home-page "https://pypi.org/project/resvg-py/")
    (synopsis "SVG rendering bindings")
    (description
     "This package provides Python bindings to the resvg SVG renderer.")
    (license license:expat)))

(define-public hermes-python-rich
  (package
    (name "hermes-python-rich")
    (version "14.3.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Textualize/rich")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1g8mb51ffn3bw2dhmmimpyhwkn13xmphircc8bg2kvkmncxmbrza"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-markdown-it-py
                             hermes-python-pygments))
    (native-inputs (list python-poetry-core))
    (home-page "https://github.com/Textualize/rich")
    (synopsis "Rich text and structured output in terminals")
    (description
     "Render rich text, tables, progress bars, syntax highlighting, markdown and more
to the terminal.")
    (license license:expat)))

(define-public hermes-python-ruamel-yaml
  (package
    (name "hermes-python-ruamel-yaml")
    (version "0.18.16")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ruamel.yaml" version))
       (sha256
        (base32 "0njyxhlvgykkdsi63mdf2jnrzhhia7rs32nn4li8p69w5x8qgrd6"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree/")
    (synopsis "YAML parser and emitter preserving comments and ordering")
    (description
     "This package provides a YAML parser/emitter that supports roundtrip preservation of
comments, seq/map flow style, and map key order.")
    (license license:expat)))

(define-public hermes-python-ruamel-yaml-clib
  (package
    (name "hermes-python-ruamel-yaml-clib")
    (version "0.2.15")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "ruamel_yaml_clib" version))
       (sha256
        (base32 "000640h0sjzd6id5ag3df254l4c2wja20lbjby498spg8f6crr26"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list hermes-python-ruamel-yaml python-setuptools
                         python-wheel))
    (home-page
     "https://sourceforge.net/p/ruamel-yaml-clib/code/ci/default/tree/")
    (synopsis "C version of reader, parser and emitter for ruamel.yaml derived from libyaml")
    (description
     "C version of reader, parser and emitter for ruamel.yaml derived from libyaml.")
    (license license:expat)))

(define hermes-python-six
  (specification->package "python-six@1.17.0"))

(define hermes-python-sniffio
  (specification->package "python-sniffio@1.3.1"))

(define-public hermes-python-snowballstemmer
  (package
    (name "hermes-python-snowballstemmer")
    (version "3.1.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/snowballstem/snowball")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1bsdw8430g4y3za11x1k8mfnnqdmgmrsq9pijwzmv3p9pbcxb6qn"))))
    (build-system pyproject-build-system)
    (arguments
     (substitute-keyword-arguments (python-arguments)
       ((#:phases phases)
        #~(modify-phases #$phases
            ;; Snowball generates its Python modules from algorithm sources.
            (replace 'build
              (lambda* (#:key outputs #:allow-other-keys)
                (substitute* "GNUmakefile"
                  (("-m build")
                   "-m build --no-isolation"))
                (invoke "make" "dist_libstemmer_python" "python=python" "CC=gcc" "CXX=g++")))))))
    (native-inputs (list perl python-pypa-build python-setuptools python-wheel))
    (home-page "https://github.com/snowballstem/snowball")
    (synopsis "Stemming algorithms for natural language processing")
    (description
     "This package provides 36 stemmers for 34 languages generated from Snowball
algorithms.")
    (license license:bsd-3)))

(define hermes-python-socksio
  (specification->package "python-socksio@1.0.0"))

(define-public hermes-python-starlette
  (package
    (name "hermes-python-starlette")
    (version "1.3.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Kludex/starlette")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "10mnn2fw4zbnc81k4c1097ifimv6wwjakdgzab7ncly8q3hz5rni"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-anyio
                             hermes-python-typing-extensions))
    (native-inputs (list python-hatchling))
    (home-page "https://github.com/Kludex/starlette")
    (synopsis "Little ASGI library that shines")
    (description "The little ASGI library that shines.")
    (license license:bsd-3)))

(define hermes-python-tenacity
  (specification->package "python-tenacity@9.1.4"))

(define-public hermes-python-termcolor
  (package
    (name "hermes-python-termcolor")
    (version "3.3.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/termcolor/termcolor")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0280lafz2z5aalln9zl0n8xk8clxcy7h53m97kfi0msxafmg7q75"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-hatch-vcs python-hatchling))
    (home-page "https://github.com/termcolor/termcolor")
    (synopsis "ANSI color formatting for output in terminal")
    (description "ANSI color formatting for output in terminal.")
    (license license:expat)))

(define hermes-python-tomli-w
  (specification->package "python-tomli-w@1.2.0"))

(define-public hermes-python-tqdm
  (package
    (name "hermes-python-tqdm")
    (version "4.70.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "tqdm" version))
       (sha256
        (base32 "0852rq47xln1wq3lzcl2pq14fkgd4jn4s7p9prpd0qklv7dv1c2m"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-setuptools python-setuptools-scm python-wheel))
    (home-page "https://pypi.org/project/tqdm/")
    (synopsis "Fast, Extensible Progress Meter")
    (description "Fast, Extensible Progress Meter.")
    (license (list license:mpl2.0 license:expat))))

(define hermes-python-truststore
  (specification->package "python-truststore@0.10.4"))

(define-public hermes-python-typing-extensions
  (package
    (name "hermes-python-typing-extensions")
    (version "4.16.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "typing_extensions" version))
       (sha256
        (base32 "1ra339pxpd3yj1zc8hz2i5dc1xs0779spriffax4vj89llckv66w"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-flit-core))
    (home-page "https://pypi.org/project/typing-extensions/")
    (synopsis "Backported and Experimental Type Hints for Python 3.9+")
    (description "Backported and Experimental Type Hints for Python 3.9+.")
    (license license:psfl)))

(define-public hermes-python-typing-inspection
  (package
    (name "hermes-python-typing-inspection")
    (version "0.4.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/pydantic/typing-inspection")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1vrjcs6hf3y05npxs8axl0b98fp4qsh4kdfwh3yw0cdvdzx6g92n"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-typing-extensions))
    (native-inputs (list python-hatchling))
    (home-page "https://github.com/pydantic/typing-inspection")
    (synopsis "Runtime typing introspection tools")
    (description "Runtime typing introspection tools.")
    (license license:expat)))

(define-public hermes-python-urllib3
  (package
    (name "hermes-python-urllib3")
    (version "2.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "urllib3" version))
       (sha256
        (base32 "0qwvpgapys7q0ral784qwx53pamlxs0sgwifybmjd5479jnjxgv3"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-hatchling python-hatch-vcs
                         python-setuptools-scm))
    (home-page "https://pypi.org/project/urllib3/")
    (synopsis "HTTP library with thread-safe connection pooling, file post, and more")
    (description
     "HTTP library with thread-safe connection pooling, file post, and more.")
    (license license:expat)))

(define-public hermes-python-uvicorn
  (package
    (name "hermes-python-uvicorn")
    (version "0.41.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "uvicorn" version))
       (sha256
        (base32 "06jpifmpzj1lkbb40ra7zz1gp29d8b3a3rafh89k38wd03virl89"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (propagated-inputs (list hermes-python-click
                             hermes-python-h11
                             hermes-python-typing-extensions))
    (native-inputs (list python-hatchling))
    (home-page "https://uvicorn.dev/")
    (synopsis "Lightning-fast ASGI server")
    (description "The lightning-fast ASGI server.")
    (license license:bsd-3)))

(define-public hermes-python-watchfiles
  (package
    (name "hermes-python-watchfiles")
    (version "1.2.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/samuelcolvin/watchfiles")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "065nv1rj49i2x98kp0a7rs9z40m5sqd93fa88bw65c6niprgzwc1"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments #:cargo-group "hermes-watchfiles-1.2.0"))
    (propagated-inputs (list hermes-python-anyio))
    (native-inputs (list maturin rust-1.96
                         (list rust-1.96 "cargo") pkg-config))
    (inputs (append (list openssl)
                    (cargo-inputs 'hermes-watchfiles-1.2.0
                                  #:module '(roquix packages rust-crates))))
    (home-page "https://github.com/samuelcolvin/watchfiles")
    (synopsis "Simple, modern and high performance file watching and code reload in python")
    (description
     "Simple, modern and high performance file watching and code reload in python.")
    (license license:expat)))

(define-public hermes-python-wcwidth
  (package
    (name "hermes-python-wcwidth")
    (version "0.8.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/jquast/wcwidth")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0b0x2y3ab3xkzbbhbx3cakrg47q4k84x7rvbzc284kavmhp0diiw"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-hatchling))
    (home-page "https://github.com/jquast/wcwidth")
    (synopsis "Measures the displayed width of unicode strings in a terminal")
    (description
     "Measures the displayed width of unicode strings in a terminal.")
    (license license:expat)))

(define-public hermes-python-websockets
  (package
    (name "hermes-python-websockets")
    (version "15.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/python-websockets/websockets")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0jm8mpyam4vrxmp2qpnq8j17hjg1jgn295hwfam802pgwhmnfb8c"))))
    (build-system pyproject-build-system)
    (arguments
     (python-arguments))
    (native-inputs (list python-setuptools python-wheel))
    (home-page "https://github.com/python-websockets/websockets")
    (synopsis "Implementation of the WebSocket Protocol (RFC 6455 & 7692)")
    (description
     "An implementation of the @code{WebSocket} Protocol (RFC 6455 & 7692).")
    (license license:bsd-3)))

(define-public hermes-python-dependencies
  (list hermes-python-annotated-doc
        hermes-python-annotated-types
        hermes-python-anyio
        hermes-python-browser-harness
        hermes-python-cdp-use
        hermes-python-certifi
        hermes-python-cffi
        hermes-python-charset-normalizer
        hermes-python-click
        hermes-python-croniter
        hermes-python-cryptography
        hermes-python-distro
        hermes-python-fastapi
        hermes-python-fetch-use
        hermes-python-fire
        hermes-python-firecrawl-anydoc
        hermes-python-h11
        hermes-python-httpcore
        hermes-python-httptools
        hermes-python-httpx
        hermes-python-idna
        hermes-python-jinja2
        hermes-python-jiter
        hermes-python-markdown
        hermes-python-markdown-it-py
        hermes-python-markupsafe
        hermes-python-mdurl
        hermes-python-nemo-relay
        hermes-python-openai
        hermes-python-packaging
        hermes-python-pathspec
        hermes-python-pillow
        hermes-python-pillow-heif
        hermes-python-prompt-toolkit
        hermes-python-psutil
        hermes-python-ptyprocess
        hermes-python-pycparser
        hermes-python-pydantic
        hermes-python-pydantic-core
        hermes-python-pygments
        hermes-python-pyjwt
        hermes-python-python-dateutil
        hermes-python-python-dotenv
        hermes-python-python-multipart
        hermes-python-pytz
        hermes-python-requests
        hermes-python-resvg-py
        hermes-python-rich
        hermes-python-ruamel-yaml
        hermes-python-ruamel-yaml-clib
        hermes-python-six
        hermes-python-sniffio
        hermes-python-snowballstemmer
        hermes-python-socksio
        hermes-python-starlette
        hermes-python-tenacity
        hermes-python-termcolor
        hermes-python-tomli-w
        hermes-python-tqdm
        hermes-python-truststore
        hermes-python-typing-extensions
        hermes-python-typing-inspection
        hermes-python-urllib3
        hermes-python-uvicorn
        hermes-python-watchfiles
        hermes-python-wcwidth
        hermes-python-websockets))
