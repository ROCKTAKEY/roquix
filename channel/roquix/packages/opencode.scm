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
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages node)
  #:use-module (gnu packages rust-apps))

(define %opencode-version
  "2.0.32")

(define %opencode-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/anomalyco/opencode")
          (commit (string-append "v" %opencode-version))))
    (file-name (git-file-name "opencode" %opencode-version))
    (sha256 (base32 "13hg76k7wl964kkdcsrnf3l85jwvqrfhn2kxlcagmp7kbv6cs118"))))

(define %opencode-node-modules
  (bun-node-modules-from-layout %opencode-2.0.32-npm-inputs
                                #:name (string-append "opencode-node-modules-"
                                        %opencode-version)))

(define %opencode-apply-patches
  (local-file (canonicalize-path (search-path %load-path
                                  "roquix/packages/opencode/apply-patches.ts"))))

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
      #:tests? #t
      #:strip-binaries? #f
      #:node-modules %opencode-node-modules
      #:phases
      #~(begin
          (use-modules (ice-9 popen)
                       (ice-9 rdelim))
          (modify-phases %standard-phases
            (add-after 'unpack 'use-packaged-bun
              (lambda _
                ;; packageManager pins upstream's development toolchain.
                ;; Guix uses its source-bootstrapped runtime and checks its
                ;; compatibility with the compiled service smoke test below.
                ;; https://github.com/anomalyco/opencode/blob/v2.0.32/package.json
                (substitute* "packages/script/src/index.ts"
                  (("const expectedBunVersionRange = .*")
                   "const expectedBunVersionRange = \"^1.3.14\"
"))))
            (add-after 'use-packaged-bun 'use-current-bun-template
              (lambda _
                ;; A platform-qualified target selects Bun's prebuilt
                ;; compiler artifact from node_modules.  Compile against the
                ;; current, source-built Guix Bun runtime instead.  That Bun
                ;; carries the Guix interpreter and link-time RUNPATH into the
                ;; compiled OpenCode executable, so the upstream smoke test is
                ;; valid without an explicit loader wrapper.
                (substitute* "packages/cli/script/build.ts"
                  (("target: target.replace\\(binary, .*CompileTarget,")
                   "// target omitted: use the current Bun runtime"))))
            (add-after 'use-current-bun-template 'use-guix-ripgrep
              (lambda* (#:key inputs #:allow-other-keys)
                ;; Upstream first searches PATH and otherwise downloads a
                ;; prebuilt ripgrep release at run time.  Embed the Guix store
                ;; path so neither a wrapper nor a network fallback is needed.
                (let ((rg (search-input-file inputs "/bin/rg")))
                  (substitute* "packages/core/src/ripgrep/binary.ts"
                    (("const system = yield\\* Effect\\.sync\\(.*findExecutable.*\\)")
                     (string-append "const system = \"" rg "\""))))))
            (add-after 'link-bun-workspaces 'apply-upstream-patches
              (lambda* (#:key inputs #:allow-other-keys)
                ;; The last photon hunk has an extra leading space in three
                ;; context lines; match the published 0.3.4 source exactly.
                (substitute* "patches/@silvia-odwyer%2Fphoton-node@0.3.4.patch"
                  (("^      ;\n") "     ;\n")
                  (("^  };\n") " };\n")
                  (("^  \n") " \n"))
                (invoke (search-input-file inputs "/bin/bun")
                        #$%opencode-apply-patches)))
            (add-after 'apply-upstream-patches 'patch-native-dependencies
              (lambda* (#:key inputs #:allow-other-keys)
                ;; Bun embeds native libraries and the PTY daemon byte for
                ;; byte.  Their loader paths must be fixed before embedding.
                (let ((runpath (string-append (assoc-ref inputs "glibc")
                                              "/lib:"
                                              (assoc-ref inputs "gcc:lib")
                                              "/lib")))
                  (for-each (lambda (file)
                              (when (elf-file? file)
                                (invoke "patchelf" "--add-rpath" runpath file)))
                            (find-files "." "\\.(node|so)$"))
                  (for-each (lambda (file)
                              (invoke "patchelf"
                                      "--set-interpreter"
                                      (search-input-file inputs
                                       "/lib/ld-linux-x86-64.so.2")
                                      "--add-rpath"
                                      runpath
                                      file))
                            (find-files "."
                                        "pty-linux-x64-gnu/bin/opencode-pty$")))))
            (replace 'build
              (lambda* (#:key inputs #:allow-other-keys)
                (let ((bun (string-append (assoc-ref inputs "bun") "/bin/bun")))
                  (setenv "OPENCODE_VERSION"
                          #$%opencode-version)
                  (setenv "OPENCODE_CHANNEL" "latest")
                  (setenv "OPENCODE_DISABLE_MODELS_FETCH" "1")
                  (with-directory-excursion "packages/cli"
                    (invoke bun "--bun" "./script/build.ts" "--single"
                            "--skip-install")
                    (invoke bun "--bun" "./script/schema.ts" "cli.json")
                    (invoke bun "--bun" "../schema/script/config-schema.ts"
                            "schema.json")))))
            (replace 'check
              (lambda* (#:key inputs tests? #:allow-other-keys)
                (when tests?
                  (setenv "SHELL"
                          (search-input-file inputs "/bin/sh"))
                  (invoke (search-input-file inputs "/bin/bun")
                          "packages/cli/script/service-smoke.ts"))))
            (replace 'install
              (lambda* (#:key outputs #:allow-other-keys)
                (let* ((out (assoc-ref outputs "out"))
                       (bin (string-append out "/bin"))
                       (program (string-append bin "/opencode"))
                       (built (car (find-files "packages/cli/dist"
                                               (lambda (file stat)
                                                 (and (eq? 'regular
                                                           (stat:type stat))
                                                      (string-suffix?
                                                       "/bin/opencode" file)))))))
                  (mkdir-p bin)
                  (install-file built bin)
                  (chmod program #o555)
                  (install-file "packages/cli/schema.json"
                                (string-append out "/share/opencode"))
                  (install-file "packages/cli/cli.json"
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
                  (call-with-output-file (string-append bash-dir "/opencode")
                    (lambda (port)
                      (let ((input (open-pipe* OPEN_READ program
                                               "--completions" "bash")))
                        (dump-port input port)
                        (unless (zero? (close-pipe input))
                          (error "failed to generate bash completion")))))
                  (call-with-output-file (string-append zsh-dir "/_opencode")
                    (lambda (port)
                      (let ((input (open-pipe* OPEN_READ program
                                               "--completions" "zsh")))
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
                                             (string-append "opencode v"
                                                            #$%opencode-version)))
                        (error "unexpected OpenCode version" actual)))))))))))
    (native-inputs (list node patchelf))
    (inputs (list (list "glibc" glibc)
                  (list "icu4c" icu4c)
                  (list "ripgrep" ripgrep)
                  (list "gcc:lib" gcc "lib")))
    (home-page "https://opencode.ai/")
    (synopsis "Open source coding agent")
    (description
     "OpenCode is an open source coding agent for the terminal.  This package
builds the CLI, terminal interface, embedded web interface, and configuration
schema from the upstream source.")
    (license license:expat)))
