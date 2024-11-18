(define-module
  (roquix packages cmake)
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

(define-public python-cmakelang
  (package
    (name "python-cmakelang")
    (version "0.6.13")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cheshirekow/cmake_format")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "12q9gg5sh4ab7954yq3b9qqjkiaf0jwm3axr38rlbmpj53x0x4vc"))))
    (build-system python-build-system)
    (arguments
     `(#:phases (modify-phases %standard-phases
                  (add-before 'check 'disable-tests
                    (lambda _
                      ;; Requires the Internet to download signatures.
                      (substitute* "cmakelang/contrib/validate_database.py"
                        (("  def test_signatures\\(self\\):")
                         "  def disable_test_signatures(self):"))
                      ;; Test that this package regognize all CMake commands.
                      ;; It fails because it is not updated yet.
                      (substitute* "cmakelang/test/command_db_test.py"
                        (("  def test_all_commands_in_db\\(self\\)")
                         "  def disable_test_all_commands_in_db(self)"))))
                  (add-after 'unpack 'fix-tests
                    (lambda _
                      ;; Requires GUIX_PYTHONPATH because these tests call
                      ;; Python as subprocess.
                      (substitute* "cmakelang/format/invocation_tests.py"
                        (("    self.env = \\{")
                         "    self.env = {
        'GUIX_PYTHONPATH': os.environ['GUIX_PYTHONPATH'],"))))
                  (replace 'check
                    (lambda* (#:key tests? #:allow-other-keys)
                      (when tests?
                        (setenv "PYTHONPATH"
                                (string-append (getcwd) ":"
                                               (getenv "GUIX_PYTHONPATH")))
                        (invoke "python" "-Bm" "cmakelang.tests")))))))
    (propagated-inputs (list python-six python-pyyaml))
    (home-page "https://cmake-format.readthedocs.io/")
    (synopsis "Quality Assurance (QA) tools for cmake")
    (description
     "@code{cmakelang} is QA tools for cmake, including:
@itemize
@item @code{cmake-annotate} can generate pretty HTML from your listfiles
@item @code{cmake-format} can format your listfiles nicely
      so that they don't look like crap.
@item @code{cmake-lint} can check your listfiles for problems
@item @code{ctest-to} can parse a @code{ctest} output tree
      and translate it into a more structured format (either JSON or XML).
@end itemize")
    (license license:gpl3)))
