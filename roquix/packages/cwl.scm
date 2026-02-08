(define-module
  (roquix packages cwl)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix hg-download)
  #:use-module (guix build-system python)
  #:use-module (guix build-system pyproject)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages graphviz)
  #:use-module (gnu packages rdf)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages bioinformatics)
  #:use-module (gnu packages check)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages time))

(define-public python-ruamel.yaml.clib-0.2.7
  (package
    (name "python-ruamel.yaml.clib")
    (version "0.2.7")
    (source
      (origin
        ;; pypi release code has cythonized code without corresponding source.
        (method hg-fetch)
        (uri (hg-reference
               (url "http://hg.code.sf.net/p/ruamel-yaml-clib/code")
               (changeset version)))
        (file-name (string-append name "-" version "-checkout"))
        (sha256
         (base32
          "119vvz2f6m5i0443r82j2r4hqqlmryffp25spv2cqky2cwjp5lj0"))
        (modules '((guix build utils)))
        (snippet
         '(begin
            (delete-file "_ruamel_yaml.c")))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f  ; This package is split from python-ruamel.yaml and
                    ; depends on modules from it for the test suite.
       #:phases
       (modify-phases %standard-phases
         (delete 'sanity-check) ; Depends on python-ruamel.yaml
         (add-after 'unpack 'cythonize-code
           (lambda _
             (invoke "cython" "_ruamel_yaml.pyx"))))))
    (native-inputs
     (list python-cython))
    (home-page "https://sourceforge.net/p/ruamel-yaml-clib/code/ci/default/tree")
    (synopsis "C version of reader, parser and emitter for ruamel.yaml")
    (description
     "This package provides a C version of the reader, parser and emitter for
@code{ruamel.yaml} derived from libyaml.")
    (license license:expat)))

(define-public python-ruamel.yaml-0.17
  (package
    (name "python-ruamel.yaml")
    (version "0.17.32")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "ruamel.yaml" version))
              (sha256
               (base32
                "1hpg033cyw7h3kv44qxbb443phikdnx5qalp892y250rfrir14zc"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-ruamel.yaml.clib-0.2.7))

    (home-page "https://sourceforge.net/p/ruamel-yaml/code/ci/default/tree")
    (synopsis
     "ruamel.yaml is a YAML parser/emitter that supports roundtrip preservation of comments, seq/map flow style, and map key order")
    (description
     "ruamel.yaml is a YAML parser/emitter that supports roundtrip preservation of
comments, seq/map flow style, and map key order")
    (license license:expat)))

(define-public python-rdflib-jsonld
  (package
    (name "python-rdflib-jsonld")
    (version "0.6.2")
    (source
      (origin
        (method url-fetch)
        (uri (pypi-uri "rdflib-jsonld" version))
        (sha256
         (base32
          "0qrshlqzv5g5bign7kjja3xf7hyk7xgayr3yd0qlqda1kl0x6z0h"))))
    (build-system python-build-system)
    (native-inputs
     (list python-nose))
    (propagated-inputs
     (list python-rdflib))
    (home-page "https://github.com/RDFLib/rdflib-jsonld")
    (synopsis "rdflib extension adding JSON-LD parser and serializer")
    (description "This package provides an rdflib extension adding JSON-LD
parser and serializer.")
    (license license:bsd-3)))

(define-public python-schema-salad-8.4
  (package
    (name "python-schema-salad")
    (version "8.4.20230808163024")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "schema-salad" version))
              (sha256
               (base32
                "1p99psx5zilkjk475wqsr9mkrqqvcb54c86b8y9qqpq5l6zjybka"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-cachecontrol
                             python-importlib-metadata
                             python-importlib-resources
                             python-mistune
                             python-mypy-extensions
                             python-rdflib
                             python-rdflib-jsonld
                             python-requests
                             python-ruamel.yaml-0.17
                             python-urllib3))
    (native-inputs
     (list python-black python-pytest python-pytest-runner))
    ;; (arguments
    ;;  `(#:phases
    ;;    (modify-phases %standard-phases
    ;;      (add-before 'check 'skip-failing-tests
    ;;        (lambda _
    ;;          ;; Skip tests that require network access.
    ;;          (substitute* "schema_salad/tests/test_cwl11.py"
    ;;            (("^def test_(secondaryFiles|outputBinding)" all)
    ;;             (string-append "@pytest.mark.skip(reason="
    ;;                            "\"test requires network access\")\n"
    ;;                            all))))))))
    (arguments
     '(#:tests? #f))
    (home-page "https://github.com/common-workflow-language/schema_salad")
    (synopsis "Schema Annotations for Linked Avro Data (SALAD)")
    (description "Schema Annotations for Linked Avro Data (SALAD)")
    (license license:asl2.0)))

(define-public python-cwl-upgrader
  (package
    (name "python-cwl-upgrader")
    (version "1.2.9")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "cwl-upgrader" version))
              (sha256
               (base32
                "017nfxrrnrf1bacryyigqgx9pprw6g5m4n2wf69j6pfihl10426a"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-ruamel.yaml-0.17 python-schema-salad-8.4
                             python-setuptools))
    (native-inputs
     (list
      python-pytest-cov))
    (home-page "https://github.com/common-workflow-language/cwl-upgrader")
    (synopsis "Common Workflow Language standalone document upgrader")
    (description "Common Workflow Language standalone document upgrader")
    (license license:asl2.0)))

(define-public python-cwlformat
  (package
    (name "python-cwlformat")
    (version "2022.02.18")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/rabix/cwl-format")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "0agkz2w86k91rc9m5vx5hsqi5nm6fcmzkng6j99hjapz0r9233ql"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-importlib-resources python-ruamel.yaml-0.17))
    (home-page "https://github.com/rabix/cwl-format")
    (synopsis "A prettifier for CWL code")
    (description "This package provides a prettifier for CWL code")
    (license #f)))

(define-public python-cwl-utils
  (package
    (name "python-cwl-utils")
    (version "0.29")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "cwl-utils" version))
              (sha256
               (base32
                "0rfm49wwnn4bcalkfrhvlmn7bhdf6nnwcr8fvx5gqxqyd4b5izf5"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-cwl-upgrader
                             python-cwlformat
                             python-packaging
                             python-rdflib
                             python-requests
                             python-ruamel.yaml-0.17
                             python-schema-salad-8.4))
    (native-inputs
     (list
      python-pytest-cov))
    (arguments
     '(#:tests? #f))
    (home-page "https://github.com/common-workflow-language/cwl-utils")
    (synopsis "")
    (description "")
    (license license:asl2.0)))

(define-public python-prov-1.5.1
  (package
    (name "python-prov")
    (version "1.5.1")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "prov" version))
              (sha256
               (base32
                "0k7fib4zrj9shlvzi62gsmqs6p6dwf65r0ad6xp9rka3vyq74bbs"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-lxml python-networkx python-dateutil
                             python-rdflib))
    (native-inputs
     (list graphviz python-pydot))
    (arguments
     '(#:tests? #f))
    (home-page "https://github.com/trungdong/prov")
    (synopsis
     "A library for W3C Provenance Data Model supporting PROV-JSON, PROV-XML and PROV-O (RDF)")
    (description
     "This package provides a library for W3C Provenance Data Model supporting
PROV-JSON, PROV-XML and PROV-O (RDF)")
    (license license:expat)))

;; Copied from 1021218d0fbadee0cfa0df4514688af157feac97 in Guix
(define-public python-shellescape
  (package
    (name "python-shellescape")
    (version "3.8.1")
    (source
      (origin
        (method git-fetch)
        (uri (git-reference
               (url "https://github.com/chrissimpkins/shellescape")
               (commit (string-append "v" version))))
        (file-name (git-file-name name version))
        (sha256
         (base32
          "0wzccxk139qx1lb2g70f5b2yh9zq15nr2mgvqdbfabg5zm0vf1qw"))))
    (build-system python-build-system)
    (arguments
     '(#:phases
       (modify-phases %standard-phases
         (replace 'check
           (lambda* (#:key tests? inputs outputs #:allow-other-keys)
             (when tests?
               (add-installed-pythonpath inputs outputs)
               (invoke "python" "tests/test_shellescape.py"))
             #t)))))
    (native-inputs
     (list python-pytest))
    (home-page "https://github.com/chrissimpkins/shellescape")
    (synopsis
     "Shell escape a string to safely use it as a token in a shell command")
    (description
     "The shellescape Python module defines the @code{shellescape.quote()}
     function that returns a shell-escaped version of a Python string.  This is a
     backport of the @code{shlex.quote()} function from Python 3.8 that makes it
     accessible to users of Python 3 versions < 3.3 and all Python 2.x versions.")
    (license license:expat)))

;; TODO: Cannot install. Only work on `guix shell'
(define-public python-cwltool
  (package
    (name "python-cwltool")
    (version "3.1.20230906142556")
    (source (origin
              (method url-fetch)
              (uri (pypi-uri "cwltool" version))
              (sha256
               (base32
                "0bkqd1bhwhq1gkfz8y6qbx3jhs7z5g12ykl7jziksnsrkq336501"))))
    (build-system pyproject-build-system)
    (propagated-inputs (list python-argcomplete
                             python-coloredlogs
                             python-cwl-utils
                             python-importlib-metadata
                             python-importlib-resources
                             python-mypy-extensions
                             python-prov-1.5.1
                             python-psutil
                             python-pydot
                             python-pyparsing
                             python-rdflib
                             python-requests
                             python-ruamel.yaml-0.17
                             python-schema-salad-8.4
                             python-setuptools
                             python-shellescape
                             python-typing-extensions))
    (native-inputs
     (list
      python-pytest-cov))
    (arguments
     '(#:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'sanity-check))))
    (home-page "https://github.com/common-workflow-language/cwltool")
    (synopsis "Common workflow language reference implementation")
    (description "Common workflow language reference implementation")
    (license license:asl2.0)))
