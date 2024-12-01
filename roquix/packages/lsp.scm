(define-module (roquix packages lsp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (guix download)
  #:use-module (gnu packages gcc)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (gnu packages openstack)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-build)
  #:use-module (guix utils))

(define-public python-pygls
  (package
    (name "python-pygls")
    ;; Use older one for `python-cmake-language-server'
    (version "0.12.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pygls" version))
       (sha256
        (base32 "040nq6a2a0ddv9lq7d6m84a1qixbnv5w5pj7s2p28xkfzlis579v"))))
    (build-system python-build-system)
    (propagated-inputs (list python-pydantic python-typeguard python-wheel))
    (native-inputs (list python-bandit
                         python-flake8
                         python-mock
                         python-mypy
                         python-pytest
                         python-pytest-asyncio
                         python-setuptools-scm))
    (arguments
     '(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'sanity-check))))
    (home-page "https://github.com/openlawlibrary/pygls/tree/master/")
    (synopsis
     "Pythonic generic language server (pronounced like \"pie glass\")")
    (description
     "Pythonic generic language server (pronounced like \"pie glass\").")
    (license license:asl2.0)))

(define-public python-cmake-language-server
  (package
    (name "python-cmake-language-server")
    (version "0.1.6")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "cmake-language-server" version))
       (sha256
        (base32 "1vgp4cd9dpidib3znjph0j53yinzwqcxq9jm2x1y5lhq2n93ymy1"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-importlib-metadata python-pygls
                             python-poetry-core))
    (arguments
     '(#:tests? #f
       #:phases (modify-phases %standard-phases
                  (delete 'sanity-check))))
    (home-page "https://github.com/regen100/cmake-language-server")
    (synopsis "CMake LSP Implementation")
    (description "CMake LSP Implementation.")
    (license license:expat)))
