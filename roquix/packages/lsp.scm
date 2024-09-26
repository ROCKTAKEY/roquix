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

(define-public python-lsprotocol
  (package
    (name "python-lsprotocol")
    (version "2023.0.0a1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "lsprotocol" version))
              (sha256
               (base32
                "1l42dxwjj9j79dja7yqsjn374gav8ikha1sspx4i7fmbar4gvv9j"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-flit-core python-attrs python-cattrs))
    (arguments
     '(#:tests? #f))
    (home-page "")
    (synopsis "Python implementation of the Language Server Protocol.")
    (description "Python implementation of the Language Server Protocol.")
    (license #f)))

(define-public python-pygls
  (package
    (name "python-pygls")
    (version "1.0.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "pygls" version))
              (sha256
               (base32
                "1clcnx1s9knh6dgmf4ykrca7yq19w6kjphsvfmffp426pgfrivpk"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-lsprotocol python-typeguard python-toml))
    (native-inputs (list python-bandit
                         python-flake8
                         python-mock
                         python-mypy
                         python-pytest
                         python-pytest-asyncio))
    ;; (arguments
    ;;  `(#:phases
    ;;    (modify-phases %standard-phases
    ;;      ;; FIXME: Without this, "In procedure rename-file: Directory not empty" is occured
    ;;      ;;   because "lib" directory already exists
    ;;      (add-before 'install 'remove-conflict
    ;;        (lambda* (#:key inputs outputs python #:allow-other-keys)
    ;;          (let* ((out (assoc-ref outputs "out"))
    ;;                 (python (assoc-ref inputs "python"))
    ;;                 (source-dir (string-append out "/lib/python" (python-version python) "/site-packages/pygls-" ,version ".data/data/lib/site-packages"))
    ;;                 (destination-dir (string-append out "/lib/site-packages")))
    ;;            (format #t "~a -> ~a~%"
    ;;                       source-dir destination-dir)
    ;;            (rename-file source-dir )
    ;;            (rmdir source-dir)))))))
    (home-page "https://github.com/openlawlibrary/pygls/tree/master/")
    (synopsis
     "a pythonic generic language server (pronounced like \"pie glass\").")
    (description
     "a pythonic generic language server (pronounced like \"pie glass\").")
    (license license:asl2.0))
  ;; (package
  ;;   (name "python-pygls")
  ;;   ;; Use older one for `python-cmake-language-server'
  ;;   (version "0.12.1")
  ;;   (source (origin
  ;;             (method url-fetch)
  ;;             (uri (pypi-uri "pygls" version))
  ;;             (sha256
  ;;              (base32
  ;;               "040nq6a2a0ddv9lq7d6m84a1qixbnv5w5pj7s2p28xkfzlis579v"))))
  ;;   (build-system python-build-system)
  ;;   (propagated-inputs (list python-pydantic python-typeguard python-wheel))
  ;;   (native-inputs (list python-bandit
  ;;                        python-flake8
  ;;                        python-mock
  ;;                        python-mypy
  ;;                        python-pytest
  ;;                        python-pytest-asyncio
  ;;                        python-setuptools-scm))
  ;;   (arguments
  ;;    '(#:tests? #f
  ;;      #:phases (modify-phases %standard-phases
  ;;                 (delete 'sanity-check))))
  ;;   (home-page "https://github.com/openlawlibrary/pygls/tree/master/")
  ;;   (synopsis
  ;;    "Pythonic generic language server (pronounced like \"pie glass\")")
  ;;   (description
  ;;    "Pythonic generic language server (pronounced like \"pie glass\").")
  ;;   (license license:asl2.0))
  )

;; (define-public python-cmake-language-server
;;   (package
;;     (name "python-cmake-language-server")
;;     (version "0.1.6")
;;     (source (origin
;;               (method url-fetch)
;;               (uri (pypi-uri "cmake-language-server" version))
;;               (sha256
;;                (base32
;;                 "1vgp4cd9dpidib3znjph0j53yinzwqcxq9jm2x1y5lhq2n93ymy1"))))
;;     (build-system pyproject-build-system)
;;     (propagated-inputs (list python-importlib-metadata python-pygls
;;                              python-poetry-core))
;;     (arguments
;;      '(#:tests? #f
;;        #:phases (modify-phases %standard-phases
;;                   (delete 'sanity-check))))
;;     (home-page "https://github.com/regen100/cmake-language-server")
;;     (synopsis "CMake LSP Implementation")
;;     (description "CMake LSP Implementation.")
;;     (license license:expat)))

(define-public python-cmake-language-server
  (package
    (name "python-cmake-language-server")
    (version "0.1.7")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "cmake-language-server" version))
              (sha256
               (base32
                "1ibgsyifznlf2zfpj9y5c927l1vlz23bw8s226cqs9yl87rkv520"))))
    (build-system python-build-system)
    (propagated-inputs (list python-pygls))
    (home-page "")
    (synopsis "CMake LSP Implementation")
    (description "CMake LSP Implementation")
    (license license:expat)))
