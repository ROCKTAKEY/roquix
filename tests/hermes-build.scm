(use-modules (roquix build hermes staging)
             (guix build utils)
             ((guix build syscalls) #:select (mkdtemp!))
             (ice-9 textual-ports)
             (json)
             (srfi srfi-64))

(test-begin "hermes-build")
  (let ((directory (mkdtemp! "/tmp/hermes-assembly.XXXXXX")))
    (dynamic-wind
      (lambda () #t)
      (lambda ()
        (with-directory-excursion directory
          (define (write-text path text)
            (mkdir-p (dirname path))
            (call-with-output-file path (lambda (port) (display text port))))
          (write-text "apps/desktop/package.json" "{\"name\":\"hermes\",\"dependencies\":{\"x\":\"1\"}}")
          (prepare-desktop "0.22.5" "light")
          (let ((stamp (call-with-input-file "install-stamp.json" json->scm))
                (package (call-with-input-file "apps/desktop/package.json" json->scm)))
            (test-equal "Light is externally managed" "external" (assoc-ref stamp "updateMechanism"))
            (test-equal "Light carries its payload identity" "light" (assoc-ref stamp "payload"))
            (test-equal "Light has a separate application identity" "hermes-light" (assoc-ref package "name"))
            (test-equal "package dependencies survive metadata preparation" "1"
              (assoc-ref (assoc-ref package "dependencies") "x")))
          (write-text "a/lib/python3.14/site-packages/ns/a.py" "a")
          (write-text "b/lib/python3.14/site-packages/ns/b.py" "b")
          (write-text "b/lib/python3.14/site-packages/ns/a.py" "a")
          (write-text "a/lib/python3.14/site-packages/ns/__pycache__/a.pyc" "old")
          (write-text "b/lib/python3.14/site-packages/ns/__pycache__/a.pyc" "new")
          (write-text "a/lib/python3.14/site-packages/solo/__pycache__/x.pyc" "cache")
          (let ((packages (map (lambda (p) (string-append directory "/" p)) '("a" "b"))))
            (install-python-dependencies "site" packages)
            (test-equal "namespace packages combine source-built modules" "b"
              (call-with-input-file "site/ns/b.py" get-string-all))
            (test-equal "dependency files stay linked to their Guix inputs" 'symlink
              (stat:type (lstat "site/ns/a.py")))
            (test-assert "dependency caches are excluded, including conflicting caches"
              (null? (find-files "site" "^__pycache__$" #:directories? #t)))
            (test-assert "cache exclusion leaves Guix inputs intact"
              (file-exists? "a/lib/python3.14/site-packages/solo/__pycache__/x.pyc"))
            (test-equal "identical dependency files are accepted" "a"
              (call-with-input-file "site/ns/a.py" get-string-all))
            (write-text "b/lib/python3.14/site-packages/ns/a.py" "different")
            (test-error "conflicting dependency files are rejected" #t
              (install-python-dependencies "conflict-site" packages)))
          (write-text "pm/runtime.py" "if stamp.get(\"distribution\") not in (\"nix\", \"docker\"):\n    pass\n")
          (write-text "docs/unused" "documentation")
          (write-text ".hidden" "omit")
          (write-text "pm/__pycache__/runtime.pyc" "omit")
          (write-text "pm/.resource" "keep")
          (install-cli-layout (string-append directory "-out") "/python/bin/python3" "0.22.5")
          (test-assert "CLI sources recognize Guix-managed PM dependencies"
            (string-contains (call-with-input-file (string-append directory "-out/lib/hermes/source/pm/runtime.py") get-string-all)
                             "(\"nix\", \"docker\", \"guix\")"))
          (test-assert "CLI omits frontend and documentation sources"
            (not (file-exists? (string-append directory "-out/lib/hermes/source/docs"))))
          (let ((repo (string-append directory "-out/lib/hermes/source")))
            (test-assert "CLI omits root hidden files and nested Python caches"
              (and (not (file-exists? (string-append repo "/.hidden")))
                   (not (file-exists? (string-append repo "/pm/__pycache__")))))
            (test-equal "CLI preserves package-local hidden resources" "keep"
              (call-with-input-file (string-append repo "/pm/.resource") get-string-all)))
          (write-text "wasm/lexer.wasm" "full")
          (write-text "wasm/lexer.min.wasm" "min")
          (for-each (lambda (n)
                      (write-text (format #f "wrappers/~a.mjs" n)
                                  "HERMES_SOURCE_LEXER_FULL HERMES_SOURCE_LEXER_MINIMAL"))
                    '(1 2 3 4 5))
          (install-source-wasm "wrappers" "wasm")
          (test-equal "lexer wrappers contain only the supplied WASM bytes"
            "ZnVsbA== bWlu"
            (call-with-input-file "wrappers/1.mjs" get-string-all))
          (test-error "a changed upstream wrapper layout is rejected" #t
            (install-source-wasm "wrappers" "wasm"))))
      (lambda ()
        (delete-file-recursively directory)
        (when (file-exists? (string-append directory "-out"))
          (delete-file-recursively (string-append directory "-out"))))))
(let ((failures (test-runner-fail-count (test-runner-current))))
  (test-end "hermes-build")
  (exit (zero? failures)))
