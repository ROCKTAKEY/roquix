(define-module (roquix packages hermes python)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (gnu packages guile)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (roquix packages hermes python-inputs)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages image)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages compression)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cargo)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1))

;; Hermes's lock selects Python >= 3.14.  Build that interpreter family with
;; Guix's CPython phases and system libraries.
(define-public hermes-python
  (package
    (inherit python-3.13)
    (name "hermes-python")
    (version "3.14.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.python.org/ftp/python/" version
                           "/Python-" version ".tar.xz"))
       (sha256 (base32 "0lqyrpx7zy9c2aa7csb9hv6wfp66j9578sak8d36xnpb3k19lbg0"))
       (patches (search-patches "python-3-deterministic-build-info.patch"
                                "python-3.13-fix-tests.patch"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           (delete-file-recursively "Modules/expat")
           (substitute* "Modules/Setup"
             (("^#pyexpat.*") "pyexpat pyexpat.c -lexpat\n"))))))
    (arguments
     (substitute-keyword-arguments (package-arguments python-3.13)
       ((#:make-flags flags)
        ;; Keep test socket paths below AF_UNIX's limit; the longer Guix build
        ;; directory otherwise makes multiprocessing fall back outside TMPDIR.
        #~(map (lambda (flag) (string-append flag " --tempdir=/tmp -u-network")) #$flags))
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'unpack 'adapt-python-tests
              (lambda _
                ;; Exercise permission failure without triggering the unrelated
                ;; AF_UNIX path-length fallback in multiprocessing.util.
                (substitute* "Lib/test/_test_multiprocessing.py"
                  (("with support.os_helper.temp_dir\\(\\) as root:")
                   "with tempfile.TemporaryDirectory(prefix='mp-', dir='/tmp') as root:"))
                ;; CPython 3.14 restores the normal SIGINT handler for doctests.
                (substitute* "Lib/test/test_pdb.py"
                  (("pdb ([12]): 1" _ number)
                   (string-append "pdb " number ": <built-in function default_int_handler>")))
                ;; These upstream tests perform DNS/HTTP requests even when the
                ;; regrtest network resource is disabled.
                (substitute* "Lib/test/test_urllib2.py"
                  (("    def test_ftp_error")
                   "    @unittest.skipUnless(support.is_resource_enabled('network'), 'network disabled')\n    def test_ftp_error"))
                (substitute* "Lib/test/test_urllibnet.py"
                  (("    def test_getcode")
                   "    @unittest.skipUnless(support.is_resource_enabled('network'), 'network disabled')\n    def test_getcode"))))
            (add-before 'check 'zip-compatible-source-date
              (lambda _
                ;; CPython 3.14 uses SOURCE_DATE_EPOCH for new ZIP entries.
                (setenv "SOURCE_DATE_EPOCH" "315532800")))
            (replace 'install-sitecustomize.py
              #$((@@ (gnu packages python) customize-site) version))))))
    (native-search-paths
     (list ((@@ (gnu packages python) guix-pythonpath-search-path) version)))))


(define hermes-python-wrapper
  ((@@ (gnu packages python) wrap-python3) hermes-python))

(define %dependency-builder
  (local-file (canonicalize-path
    (search-path %load-path "roquix/packages/hermes/build-python-dependency.py"))))

(define (source-dependency row)
  (match row
    ((upstream-name version uri hash cargo-group license-id)
     (package
       (name (string-append "hermes-python-" upstream-name))
       (version version)
       (source (origin (method url-fetch) (uri uri)
                       (sha256 (base32 hash))))
       (build-system gnu-build-system)
       (arguments
        (list
         #:imported-modules
         (append %cargo-build-system-modules
                 (source-module-closure '((roquix packages hermes python-build))
                   #:select? (lambda (name) (memq (car name) '(guix roquix)))))
         #:modules '((guix build gnu-build-system)
                     ((guix build cargo-build-system) #:prefix cargo:)
                     (guix build utils) (roquix packages hermes python-build)
                     (ice-9 match) (srfi srfi-1))
         #:phases
         (with-extensions (list guile-json-4)
           #~(modify-phases %standard-phases
             (delete 'configure)
             ;; The installed Hermes check exercises the assembled dependency set.
             (delete 'check)
             (add-after 'unpack 'prepare-build-environment
               (lambda* (#:key inputs #:allow-other-keys #:rest args)
                 (setenv "HOME" (getcwd))
                 (setenv "SOURCE_DATE_EPOCH" "315532800")
                 (setenv "PYTHONPATH"
                   (string-join
                     (append-map
                       (match-lambda
                         ((_ . directory)
                          (if (false-if-exception (file-is-directory? (string-append directory "/lib")))
                              (find-files (string-append directory "/lib")
                                "^site-packages$" #:directories? #t)
                              '())))
                       inputs) ":"))
                 (setenv "CARGO_BUILD_JOBS" (number->string (parallel-job-count)))
                 (setenv "CARGO_PROFILE_RELEASE_DEBUG" "0")
                 (setenv "OPENSSL_NO_VENDOR" "1")
                 (setenv "PYO3_PYTHON" #$(file-append hermes-python "/bin/python3"))
                 (when #$cargo-group
                   (for-each
                     (lambda (phase)
                       (apply (assoc-ref cargo:%standard-phases phase)
                              #:cargo-target #$(cargo-triplet) args))
                     '(unpack-rust-crates configure check-for-pregenerated-files
                       patch-cargo-checksums)))))
             #$@(if (string=? upstream-name "cryptography")
                    (list #~(add-before 'build 'restore-cargo-lock
                              (lambda _ (invoke "cargo" "generate-lockfile" "--offline"))))
                    '())
             (replace 'build
               (lambda _
                 (build-python-dependency
                  #$(file-append hermes-python "/bin/python3") #$%dependency-builder)))
             (replace 'install
               (lambda* (#:key inputs outputs #:allow-other-keys)
                 (install-python-dependency inputs outputs #$hermes-python-wrapper)))))))
       (native-inputs
        (append
          (list pkg-config hermes-python hermes-python-wrapper python-setuptools python-setuptools-scm
                python-wheel python-hatch-fancy-pypi-readme python-hatchling python-hatch-vcs python-flit-core
                python-pdm-backend python-poetry-core python-packaging python-pycparser
                python-cython)
          (if cargo-group (list rust-1.96 (list rust-1.96 "cargo") maturin) '())
          (if (string=? upstream-name "pillow")
              (list (cadr (assoc "pybind11" (package-native-inputs python-pillow))))
              '())
          (if (string=? upstream-name "cryptography")
              (map (lambda (dependency)
                     (find (lambda (p)
                             (string=? (package-name p)
                                       (string-append "hermes-python-" dependency)))
                           hermes-python-dependencies))
                   '("cffi"))
              '())))
       (inputs
         (append (cond
                   ((string=? upstream-name "pillow") (package-inputs python-pillow))
                   ((string=? upstream-name "pillow-heif") (list (list "libheif" libheif)))
                   ((string=? upstream-name "cffi") (list (list "libffi" libffi)))
                   ((string=? upstream-name "nemo-relay")
                    (list (list "openssl" openssl) (list "zstd" zstd "lib")))
                   (cargo-group (list (list "openssl" openssl)))
                   (else '()))
                 (if cargo-group
                     (map (lambda (input)
                            (list (if (package? input) (package-name input)
                                      (origin-file-name input)) input))
                          (cargo-inputs (string->symbol cargo-group)
                            #:module '(roquix packages rust-crates)))
                     '())))
       (home-page (string-append "https://pypi.org/project/" upstream-name "/"))
       (synopsis (string-append "Source-built " upstream-name " for Hermes"))
       (description "This package builds a locked Hermes Python dependency from its source distribution.")
       (license (cond
         ((string=? license-id "MIT") license:expat)
         ((string=? license-id "MIT-0") license:expat-0)
         ((string=? license-id "MIT-CMU") (license:non-copyleft "https://spdx.org/licenses/MIT-CMU.html"))
         ((string=? license-id "BSD-3-Clause") license:bsd-3)
         ((string=? license-id "BSD-2-Clause") license:bsd-2)
         ((string=? license-id "Apache-2.0") license:asl2.0)
         ((string=? license-id "MPL-2.0") license:mpl2.0)
         ((string=? license-id "ISC") license:isc)
         ((string=? license-id "PSF-2.0") license:psfl)
         ((string=? license-id "Apache-2.0 OR BSD-3-Clause") (list license:asl2.0 license:bsd-3))
         ((string=? license-id "Apache-2.0 OR BSD-2-Clause") (list license:asl2.0 license:bsd-2))
         ((string=? license-id "MIT OR Apache-2.0") (list license:expat license:asl2.0))
         ((string=? license-id "MPL-2.0 AND MIT") (list license:mpl2.0 license:expat))
         (else (error "unhandled upstream license" upstream-name license-id))))))))

;; Pure Python outputs are interpreter-independent source modules. Reuse an
;; existing Guix build when it already matches the upstream locked version.
(define (existing-dependency row)
  (match row
    ((name version _ _ cargo-group _)
     (and (not cargo-group)
          (not (member name '("cffi" "charset-normalizer" "httptools" "markupsafe"
                              "pillow" "pillow-heif" "psutil" "ruamel-yaml-clib")))
          (let* ((package-name
                   (cond ((string-prefix? "python-" name) name)
                         ((string=? name "ruamel-yaml") "python-ruamel.yaml")
                         (else (string-append "python-" name))))
                 (candidate (find (lambda (p) (string=? version (package-version p)))
                                  (find-packages-by-name package-name))))
            (and candidate (string=? version (package-version candidate))
                 candidate))))))

(define-public hermes-python-dependencies
  (map (lambda (row) (or (existing-dependency row) (source-dependency row)))
       hermes-python-sources))
