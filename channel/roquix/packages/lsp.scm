(define-module (roquix packages lsp)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages base)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages node-xyz)
  #:use-module (guix download)
  #:use-module (gnu packages gcc)
  #:use-module (guix build-system node)
  #:use-module (guix build-system pyproject)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (gnu packages openstack)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-build)
  #:use-module (guix utils))

(define python-lsprotocol-for-cmake
  (package
    (inherit python-lsprotocol)
    (version "2023.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "lsprotocol" version))
       (sha256
        (base32 "07c6476y1mla347pskswl0c30b94a6g36123ff5w20r41l9iap6c"))))
    ;; The release archive contains no tests.
    (arguments (list #:tests? #f))
    (native-inputs (list python-flit-core python-setuptools))))

;; CMake Language Server uses the pygls 1.x server API.
;; https://github.com/regen100/cmake-language-server/blob/v0.1.11/cmake_language_server/server.py
(define python-pygls-for-cmake
  (package
    (inherit python-pygls)
    (version "1.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "pygls" version))
       (sha256
        (base32 "062hlmkd4lqc6f689bhpjbyx59s25a4pqm1kqnryk80dzbpdq3hl"))))
    ;; The release archive contains no tests; the consumer exercises the API.
    (arguments (list #:tests? #f))
    (native-inputs (list python-poetry-core python-setuptools))
    (propagated-inputs
     (list python-cattrs python-lsprotocol-for-cmake))))

(define-public cmake-language-server
  (package
    (name "cmake-language-server")
    (version "0.1.11")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "cmake_language_server" version))
       (patches
        (list (search-path %load-path
                           "roquix/packages/patches/cmake-language-server-help-sections.patch")))
       (sha256
        (base32 "0nv9rnry4nkjknrmhy34mjndskq4c9kqz999f9x4asf5gqv4hpq0"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'wrap 'wrap-cmake-tools
            (lambda _
              (wrap-program (string-append #$output "/bin/cmake-language-server")
                `("PATH" prefix
                  (,(string-append #$cmake "/bin")
                   ,(string-append #$cmakelang "/bin")))))))))
    (inputs (list bash-minimal cmake cmakelang))
    (propagated-inputs (list python-pygls-for-cmake))
    (native-inputs (list python-pdm-backend python-pytest
                         python-pytest-datadir python-setuptools))
    (home-page "https://github.com/regen100/cmake-language-server")
    (synopsis "Language server for CMake")
    (description
     "This package provides a CMake implementation of the Language Server
Protocol, with command completion, documentation on hover, and formatting
through cmake-format.  It uses the CMake file API to inspect build targets
and cached variables.")
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
