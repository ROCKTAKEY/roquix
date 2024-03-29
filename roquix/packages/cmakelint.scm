(define-module
  (roquix packages cmakelint)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages check)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-compression))

(define-public python-tox-pyenv
  (package
    (name "python-tox-pyenv")
    (version "1.1.0")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "tox-pyenv" version))
              (sha256
               (base32
                "1r4r4pyg6zkxsldahl3g36iz6xyh5yrvziajahxhpv3saw9j4v4i"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-tox))
    (native-inputs
     (list
      ;; Needed for test
      python-pylint
      python-pycodestyle
      python-mock
      python-tomli))
    (home-page "https://github.com/samstav/tox-pyenv")
    (synopsis
     "tox plugin that makes tox use `pyenv which` to find python executables")
    (description
     "tox plugin that makes tox use `pyenv which` to find python executables")
    (license license:asl2.0)))

(define-public python-flake8-polyfill
  (package
    (name "python-flake8-polyfill")
    (version "1.0.2")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "flake8-polyfill" version))
              (sha256
               (base32
                "1nlf1mkqw856vi6782qcglqhaacb23khk9wkcgn55npnjxshhjz4"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-flake8))
    (home-page "https://gitlab.com/pycqa/flake8-polyfill")
    (synopsis "Polyfill package for Flake8 plugins")
    (description "Polyfill package for Flake8 plugins")
    (license license:expat)))

(define-public python-cmakelint
  (package
    (name "python-cmakelint")
    (version "1.4.2")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "cmakelint" version))
              (sha256
               (base32
                "0abk3d2n3wpi0phsp3kiaa0hmfdfybnlvxmf48ardg3lpgv9y1w7"))))
    (arguments
     '(#:tests? #f))
    (build-system pyproject-build-system)
    (native-inputs (list python-configparser
                         python-flake8
                         python-flake8-polyfill
                         python-importlib-metadata
                         python-mock
                         python-pylint
                         python-pyparsing
                         python-pytest
                         python-pytest-cov
                         python-testfixtures
                         python-tox
                         python-tox-pyenv
                         python-zipp))
    (home-page "https://github.com/cmake-lint/cmake-lint")
    (synopsis "Static code checker for CMake files")
    (description "Static code checker for CMake files")
    (license license:asl2.0)))
