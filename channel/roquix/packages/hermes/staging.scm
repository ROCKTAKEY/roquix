(define-module (roquix packages hermes staging)
  #:use-module (guix build utils)
  #:use-module (guix base64)
  #:use-module (guix build union)
  #:use-module (srfi srfi-1)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module ((rnrs io ports) #:select (get-bytevector-all))
  #:use-module (json)
  #:export (prepare-desktop install-python-dependencies
            install-source-wasm install-cli-layout assemble-cli))

(define (write-json file value)
  (call-with-output-file file (lambda (port) (scm->json value port))))

(define (install-stamp version payload)
  `(("schemaVersion" . 2)
    ("commit" . "bf0203a794a07aac3ff764972ab9087baa4e4f4e")
    ("baseVersion" . ,version) ("displayVersion" . ,version)
    ("distance" . 0) ("builtAt" . null) ("dirty" . #f)
    ("source" . "guix") ("distribution" . "guix")
    ("updateMechanism" . "external") ("payload" . ,payload)))

(define (prepare-desktop version variant)
  (unless (member variant '("bootstrap" "light"))
    (error "unsupported Guix desktop variant" variant))
  (write-json "install-stamp.json"
              (acons "tag" (string-append "v" version)
                     (install-stamp version variant)))
  (let* ((file "apps/desktop/package.json")
         (package (call-with-input-file file json->scm)))
    (set! package (assoc-set! package "version" version))
    (when (string=? variant "light")
      (set! package (assoc-set! package "name" "hermes-light"))
      (set! package (assoc-set! package "productName" "Hermes Light")))
    (write-json file package)))

(define (install-python-dependencies site packages)
  (define (cache? file)
    (member "__pycache__" (string-split file #\/)))
  (union-build
   site
   (append-map
    (lambda (package)
      (let ((roots (find-files (string-append package "/lib") "^site-packages$"
                               #:directories? #t)))
        (when (null? roots)
          (error "no installed Python modules" package))
        roots))
    packages)
   ;; The assembler writes into this tree; cache removal must not touch inputs.
   #:create-all-directories? #t
   #:resolve-collision (lambda (files)
                         (and (not (cache? (car files)))
                              (error "conflicting Python dependency" files))))
  (for-each delete-file-recursively
            (find-files site "^__pycache__$" #:directories? #t)))

(define (install-source-wasm root wasm)
  (let ((full (base64-encode
               (call-with-input-file (string-append wasm "/lexer.wasm") get-bytevector-all)))
        (minimal (base64-encode
                  (call-with-input-file (string-append wasm "/lexer.min.wasm") get-bytevector-all)))
        (count 0))
    (for-each
     (lambda (file)
       (unless (eq? 'symlink (stat:type (lstat file)))
         (let ((text (call-with-input-file file get-string-all)))
           (when (string-contains text "HERMES_SOURCE_LEXER_")
             (set! count (+ count 1))
             (call-with-output-file file
               (lambda (port)
                 (display
                  (regexp-substitute/global
                   #f "HERMES_SOURCE_LEXER_MINIMAL"
                   (regexp-substitute/global #f "HERMES_SOURCE_LEXER_FULL"
                                             text 'pre full 'post)
                   'pre minimal 'post)
                  port)))))))
     (find-files root "\\.(js|mjs|cjs)$"))
    (unless (= count 5)
      (error "expected five lexer wrappers" count))))

(define (install-cli-layout out python version)
  (let ((repo (string-append out "/lib/hermes/source"))
        (source (getcwd))
        (excluded '("apps" "web" "ui-tui" "website" "docs" "tests"
                    "tests-js" "node_modules")))
    (copy-recursively
     source repo #:keep-mtime? #t #:follow-symlinks? #t
     #:select? (lambda (file stat)
                 (and (not (string=? (basename file) "__pycache__"))
                      (or (not (string=? (dirname file) source))
                          (and (not (string-prefix? "." (basename file)))
                               (not (member (basename file) excluded)))))))
    (write-json (string-append repo "/install-stamp.json")
                (acons "pmRuntime" (string-append out "/lib/hermes")
                       (install-stamp version "bootstrap")))
    (write-json (string-append out "/lib/hermes/pm-runtime.json")
                `(("python" . ,python) ("sitePackages" . "site-packages")))
    ;; Guix supplies the PM imports in its immutable closure, like Nix.
    ;; https://github.com/NousResearch/hermes-agent/blob/v0.22.5/pm/runtime.py
    (let ((file (string-append repo "/pm/runtime.py")))
      (unless (= 1 (length (list-matches "stamp.get\\(\"distribution\"\\) not in \\(\"nix\", \"docker\"\\)"
                                         (call-with-input-file file get-string-all))))
        (error "upstream PM distribution contract changed"))
      (substitute* file
        (("not in \\(\"nix\", \"docker\"\\)")
         "not in (\"nix\", \"docker\", \"guix\")")))))

(define (assemble-cli out python)
  (let* ((runtime (string-append out "/lib/hermes"))
         (repo (string-append runtime "/source"))
         (inputs (string-append (getcwd) "/agent-inputs.json")))
    ;; Fixed placement permits external Guix store paths while letting the
    ;; upstream assembler publish metadata and bind the output-owned site.
    ;; https://github.com/NousResearch/hermes-agent/blob/v0.22.5/scripts/build/README.md
    (write-json inputs
      `(("project" . ,(string-append repo "/pyproject.toml"))
        ("code" . ,repo) ("repo" . "lib/hermes/source")
        ("placement" . "fixed") ("target" . "linux-x64")
        ("python" . ,python)
        ("site_packages" . ,(string-append runtime "/site-packages"))
        ("environment" . ,runtime) ("pm_runtime" . ,runtime)))
    (with-directory-excursion repo
      (invoke python "-B" "-m" "scripts.build.agent"
              "--inputs" inputs "--out" out))
    (map car (assoc-ref
               (assoc-ref (call-with-input-file (string-append out "/manifest.json") json->scm)
                          "runtime")
               "commands"))))
