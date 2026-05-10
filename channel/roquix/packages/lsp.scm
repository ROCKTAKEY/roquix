(define-module (roquix packages lsp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages node-xyz)
  #:use-module (guix download)
  #:use-module (gnu packages gcc)
  #:use-module (guix build-system node)
  #:use-module (guix build-system pyproject)
  #:use-module (guix build-system python)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
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
                         python-setuptools-scm
                         python-toml))
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

(define-public typescript-language-server
  (package
    (name "typescript-language-server")
    (version "5.1.3")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://registry.npmjs.org/typescript-language-server"
                           "/-/typescript-language-server-" version ".tgz"))
       (sha256
        (base32
         "031iglrwqb5cyriixhpg21f1lxd2ya2rshy9vi5184p7gzpcmjfj"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'keep-only-typescript-dependency
            (lambda _
              (modify-json
               (lambda (package-json)
                 (let* ((dev-dependencies
                         (assoc-ref package-json "devDependencies"))
                        (typescript
                         (assoc-ref dev-dependencies "typescript"))
                        (package-json
                         (filter
                          (lambda (field)
                            (not (member (car field)
                                         '("devDependencies"
                                           "eslintIgnore"
                                           "husky"
                                           "resolutions"))))
                          package-json)))
                   (assoc-set! package-json
                               "dependencies"
                               `(("typescript" . ,typescript)))))))))))
    (inputs (list node-typescript))
    (home-page
     "https://github.com/typescript-language-server/typescript-language-server")
    (synopsis "TypeScript and JavaScript language server")
    (description
     "TypeScript Language Server provides a Language Server Protocol
implementation for TypeScript and JavaScript using TypeScript's tsserver.")
    (license (list license:asl2.0 license:expat))))
