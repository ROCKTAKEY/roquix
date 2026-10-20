(define-module (roquix packages opencode)
  #:use-module (roquix packages opencode-npm-inputs)
  #:use-module (roquix build-system bun)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (gnu packages base)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages node)
  #:use-module (gnu packages rust-apps))

(define %opencode-version
  "1.18.3")

(define %opencode-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/anomalyco/opencode")
          (commit (string-append "v" %opencode-version))))
    (file-name (git-file-name "opencode" %opencode-version))
    (sha256 (base32 "0pnm9r6b39sl6jnvkd009wq5ky04zc8xj9pi6cvpr83xrsd37nar"))))

(define %opencode-node-modules
  (bun-node-modules-from-layout %opencode-1.18.3-npm-inputs
                                #:name (string-append "opencode-node-modules-"
                                        %opencode-version)))

(define-public opencode
  (package
    (name "opencode")
    (version %opencode-version)
    (source
     %opencode-source)
    (build-system bun-build-system)
    ;; The Bun source-bootstrap chain is currently verified for x86_64 only.
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:node-modules %opencode-node-modules
      #:phases
      #~(begin
          (use-modules (ice-9 popen)
                       (ice-9 rdelim))
          (modify-phases %standard-phases
            (add-after 'unpack 'use-current-bun-template
              (lambda _
                ;; A platform-qualified target selects Bun's prebuilt
                ;; compiler artifact from node_modules.  Compile against the
                ;; current, source-built Guix Bun runtime instead.  That Bun
                ;; carries the Guix interpreter and link-time RUNPATH into the
                ;; compiled OpenCode executable, so the upstream smoke test is
                ;; valid without an explicit loader wrapper.
                (substitute* "packages/opencode/script/build.ts"
                  (("target: name.replace\\(pkg.name, \"bun\"\\) as any,")
                   "// target omitted: use the current Bun runtime"))))
            (add-after 'use-current-bun-template 'use-guix-ripgrep
              (lambda* (#:key inputs #:allow-other-keys)
                ;; Upstream first searches PATH and otherwise downloads a
                ;; prebuilt ripgrep release at run time.  Embed the Guix store
                ;; path so neither a wrapper nor a network fallback is needed.
                (let ((rg (search-input-file inputs "/bin/rg")))
                  (substitute* "packages/core/src/ripgrep/binary.ts"
                    (("const system = yield\\* Effect\\.sync\\(.*which.*\\)")
                     (string-append "const system = \"" rg "\""))))))
            (replace 'build
              (lambda* (#:key inputs #:allow-other-keys)
                (let ((bun (string-append (assoc-ref inputs "bun") "/bin/bun")))
                  (setenv "OPENCODE_VERSION"
                          #$%opencode-version)
                  (setenv "OPENCODE_CHANNEL" "prod")
                  (setenv "OPENCODE_DISABLE_MODELS_FETCH" "1")
                  (setenv "MODELS_DEV_API_JSON"
                          (string-append (getcwd)
                           "/packages/opencode/test/tool/fixtures/models-api.json"))
                  (with-directory-excursion "packages/opencode"
                    (invoke bun "--bun" "./script/build.ts" "--single"
                            "--skip-install")
                    (invoke bun "--bun" "./script/schema.ts" "schema.json")))))
            (replace 'install
              (lambda* (#:key outputs #:allow-other-keys)
                (let* ((out (assoc-ref outputs "out"))
                       (bin (string-append out "/bin"))
                       (program (string-append bin "/opencode"))
                       (built (car (find-files "packages/opencode/dist"
                                               (lambda (file stat)
                                                 (and (eq? 'regular
                                                           (stat:type stat))
                                                      (string-suffix?
                                                       "/bin/opencode" file)))))))
                  (mkdir-p bin)
                  (install-file built bin)
                  (chmod program #o555)
                  (install-file "packages/opencode/schema.json"
                                (string-append out "/share/opencode")))))
            (add-after 'install 'install-completions
              (lambda* (#:key outputs #:allow-other-keys)
                (let* ((out (assoc-ref outputs "out"))
                       (program (string-append out "/bin/opencode"))
                       (bash-dir (string-append out
                                  "/share/bash-completion/completions"))
                       (zsh-dir (string-append out "/share/zsh/site-functions")))
                  (mkdir-p bash-dir)
                  (mkdir-p zsh-dir)
                  (setenv "SHELL" "/bin/bash")
                  (call-with-output-file (string-append bash-dir "/opencode")
                    (lambda (port)
                      (let ((input (open-pipe* OPEN_READ program "completion")))
                        (dump-port input port)
                        (unless (zero? (close-pipe input))
                          (error "failed to generate bash completion")))))
                  (setenv "SHELL" "/bin/zsh")
                  (call-with-output-file (string-append zsh-dir "/_opencode")
                    (lambda (port)
                      (let ((input (open-pipe* OPEN_READ program "completion")))
                        (dump-port input port)
                        (unless (zero? (close-pipe input))
                          (error "failed to generate zsh completion"))))))))
            (add-after 'install-completions 'check-version
              (lambda* (#:key outputs #:allow-other-keys)
                (let ((home (string-append (getcwd) "/.check-home"))
                      (program (string-append (assoc-ref outputs "out")
                                              "/bin/opencode")))
                  (mkdir-p home)
                  (setenv "HOME" home)
                  (for-each (lambda (name)
                              (setenv name home))
                            '("XDG_CACHE_HOME" "XDG_CONFIG_HOME"
                              "XDG_DATA_HOME" "XDG_STATE_HOME"))
                  (setenv "OPENCODE_DISABLE_MODELS_FETCH" "1")
                  (with-directory-excursion home
                    (let* ((port (open-pipe* OPEN_READ program "--version"))
                           (actual (read-line port))
                           (status (close-pipe port)))
                      (unless (and (zero? status)
                                   (string=? actual
                                             #$%opencode-version))
                        (error "unexpected OpenCode version" actual)))))))))))
    (native-inputs (list node))
    (inputs (list glibc icu4c ripgrep))
    (home-page "https://opencode.ai/")
    (synopsis "Open source coding agent")
    (description
     "OpenCode is an open source coding agent for the terminal.  This package
builds the CLI, terminal interface, embedded web interface, and configuration
schema from the upstream source.")
    (license license:expat)))
