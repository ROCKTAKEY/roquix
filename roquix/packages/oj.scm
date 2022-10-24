(define-module
  (roquix packages oj)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system python)
  #:use-module (guix build python-build-system)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages xml)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-9))

(define-public online-judge-api-client
  (package
   (name "online-judge-api-client")
   (version "10.10.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/online-judge-tools/api-client")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "0yjqhh44va5nawd9rpqcjyf0g7rjlkvn7s90fmwmwjyqvy6lhjiz"))))
   (build-system python-build-system)
   (arguments '(#:tests? #f))
   (propagated-inputs (list
                       python-appdirs
                       python-beautifulsoup4
                       python-colorlog
                       python-lxml
                       python-requests
                       python-toml
                       python-jsonschema))
   (home-page "https://github.com/online-judge-tools/api-client")
   (synopsis "API client to develop tools for competitive programming")
   (description "API client to develop tools for competitive programming")
   (license license:expat)))

(define-public online-judge-tools
  (package
   (name "online-judge-tools")
   (version "11.5.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/online-judge-tools/oj")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "0zkzmmjgjb6lyrzq1ip54cpnp7al9a7mcyjyi5vx58bvnx3q0c6m"))))
   (build-system python-build-system)
   (arguments '(#:tests? #f))
   (propagated-inputs (list
                       online-judge-api-client
                       python-colorama
                       python-requests))
   (home-page "https://github.com/online-judge-tools/oj")
   (synopsis "Tools for various online judges.")
   (description "Tools for various online judges.
 Downloading sample cases, generating additional test cases, testing your code, and submitting it.")
   (license license:expat)))

(define-public online-judge-template-generator
  (package
   (name "online-judge-template-generator")
   (version "4.8.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/online-judge-tools/template-generator")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "1a4n3nxli3z6aqzq1r5pi5c1q6lg0p2vg89fmc2z3ndxaq7l8bbi"))))
   (build-system python-build-system)
   (arguments '(#:phases
                (modify-phases %standard-phases
                  (replace 'install
                    ;;; This code is originated from module (guix build python-build-system)
                    (lambda* (#:key inputs outputs (configure-flags '()) use-setuptools?
                              #:allow-other-keys)
                      "Install a given Python package."
                      (use-modules (guix build python-build-system)
                                   (guix build utils)
                                   (ice-9 match)
                                   (ice-9 ftw)
                                   (ice-9 format)
                                   (srfi srfi-1)
                                   (srfi srfi-26))
                      (define setuptools-shim
                        ;; Run setup.py with "setuptools" being imported, which will patch
                        ;; "distutils". This is needed for packages using "distutils" instead of
                        ;; "setuptools" since the former does not understand the
                        ;; "--single-version-externally-managed" flag.
                        ;; Python code taken from pip 9.0.1 pip/utils/setuptools_build.py
                        (string-append
                         "import setuptools, tokenize;__file__='setup.py';"
                         "f=getattr(tokenize, 'open', open)(__file__);"
                         "code=f.read().replace('\\r\\n', '\\n');"
                         "f.close();"
                         "exec(compile(code, __file__, 'exec'))"))
                      (define (call-setuppy command params use-setuptools?)
                        (if (file-exists? "setup.py")
                            (begin
                              (format #t "running \"python setup.py\" with command ~s and parameters ~s~%"
                                      command params)
                              (if use-setuptools?
                                  (apply invoke "python" "-c" setuptools-shim
                                         command params)
                                  (apply invoke "python" "./setup.py" command params)))
                            (error "no setup.py found")))
                      (let* ((out (or (assoc-ref outputs "python")
                                      (assoc-ref outputs "out")))
                             (python (assoc-ref inputs "python"))
                             (major-minor (map string->number
                                               (take (string-split (python-version python) #\.) 2)))
                             ;; FIXME: `match' macro cannot be loaded even when `use-modules' `(ice-9 match)'
                             ;; (<3.7? (match major-minor
                             ;;          ((major minor)
                             ;;           (or (< major 3) (and (= major 3) (< minor 7))))))
                             (<3.7? (and (= (length major-minor) 2)
                                         (or (< (car major-minor) 3)
                                             (and (= (car major-minor) 3) (< (cadr major-minor) 7)))))
                             (params (append (list (string-append "--prefix=" out)
                                                   "--no-compile")
                                             (if use-setuptools?
                                                 ;; distutils does not accept these flags
                                                 (list "--single-version-externally-managed"
                                                       "--root=/")
                                                 '())
                                             configure-flags)))
                        (call-setuppy "install" params use-setuptools?)
                        (unless <3.7?
                          (invoke "python" "-m" "compileall" "--invalidation-mode=unchecked-hash"
                                  ;; Exclude template directory
                                  "-x" "onlinejudge_template_resources/template/*"
                                  out))
                        ))))
                #:tests? #f))
   (propagated-inputs (list
                       python-appdirs
                       python-beautifulsoup4
                       python-colorlog
                       python-mako
                       online-judge-api-client
                       online-judge-tools
                       python-ply
                       python-pyyaml
                       python-requests
                       python-toml))
   (home-page "https://github.com/online-judge-tools/template-generator")
   (synopsis "Analyze problems of competitive programming and automatically generate boilerplate.")
   (description "Analyze problems of competitive programming and automatically generate boilerplate.")
   (license license:expat)))
