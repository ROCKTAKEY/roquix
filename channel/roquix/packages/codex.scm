(define-module (roquix packages codex)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages libunwind)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages virtualization)
  #:use-module (gnu packages regex))

(define %codex-rusty-v8-version
  "150.4.0")

;; Keep these two packages in sync.  The archive and bindings must come from
;; the same OpenAI rusty_v8 release and match the target, pointer-compression,
;; sandbox, and release-profile configuration.
;; Cargo treats bare origins in native-inputs as crate sources, so package
;; these non-crate artifacts as ordinary inputs.
(define rusty-v8-prebuilt-archive
  (package
    (name "rusty-v8-prebuilt-archive")
    (version %codex-rusty-v8-version)
    (source
     (let* ((archive (cond
                       ((string=? (%current-system) "aarch64-linux")
                        '("librusty_v8_ptrcomp_sandbox_release_aarch64-unknown-linux-gnu.a.gz"
                          "1fhi51yhpwkd79mr27rmimf4vivyk7zda1dh55q56s2l83npwlfi"))
                       (else '("librusty_v8_ptrcomp_sandbox_release_x86_64-unknown-linux-gnu.a.gz"
                               "10xm60dl5ywwp0r8nmjha3q59gjf194k6nx4hlw9hskfyb8pap53"))))
            (archive-name (car archive))
            (archive-sha256 (cadr archive)))
       (origin
         (method url-fetch)
         (uri (string-append
               "https://github.com/openai/codex/releases/download/rusty-v8-v"
               %codex-rusty-v8-version "/" archive-name))
         (sha256 (base32 archive-sha256)))))
    (build-system trivial-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (arguments
     (list
      #:modules '((guix build utils))
      #:builder
      #~(begin
          (use-modules (guix build utils))
          (let ((out (assoc-ref %outputs "out"))
                (src (assoc-ref %build-inputs "source")))
            (mkdir-p (string-append out "/share/rusty-v8"))
            (copy-file src
                       (string-append out "/share/rusty-v8/"
                                      (basename src)))))))
    (home-page "https://github.com/denoland/rusty_v8")
    (synopsis "Prebuilt rusty_v8 static library archive")
    (description
     "This helper package installs the prebuilt static library archive used
by the rust-v8 crate so Guix builds do not attempt to download it during the
build phase.")
    (license (list license:expat license:bsd-3))))

(define rusty-v8-prebuilt-binding
  (package
    (name "rusty-v8-prebuilt-binding")
    (version %codex-rusty-v8-version)
    (source
     (let* ((binding (cond
                       ((string=? (%current-system) "aarch64-linux")
                        '("src_binding_ptrcomp_sandbox_release_aarch64-unknown-linux-gnu.rs"
                          "01l53l6nk4p5brpz2v3svqijx3hz5nqry8q7x12vdgbrwim849vp"))
                       (else '("src_binding_ptrcomp_sandbox_release_x86_64-unknown-linux-gnu.rs"
                               "01l53l6nk4p5brpz2v3svqijx3hz5nqry8q7x12vdgbrwim849vp"))))
            (binding-name (car binding))
            (binding-sha256 (cadr binding)))
       (origin
         (method url-fetch)
         (uri (string-append
               "https://github.com/openai/codex/releases/download/rusty-v8-v"
               %codex-rusty-v8-version "/" binding-name))
         (sha256 (base32 binding-sha256)))))
    (build-system trivial-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (arguments
     (list
      #:modules '((guix build utils))
      #:builder
      #~(begin
          (use-modules (guix build utils))
          (let ((out (assoc-ref %outputs "out"))
                (src (assoc-ref %build-inputs "source")))
            (mkdir-p (string-append out "/share/rusty-v8"))
            (copy-file src
                       (string-append out "/share/rusty-v8/"
                                      (basename src)))))))
    (home-page "https://github.com/denoland/rusty_v8")
    (synopsis "Prebuilt rusty_v8 Rust bindings")
    (description
     "This helper package installs the prebuilt Rust bindings matching the
sandbox-enabled rusty_v8 static library used by Codex code mode.")
    (license (list license:expat license:bsd-3))))

(define %codex-release-version
  "0.160.0")

(define-public codex
  (package
    (name "codex")
    ;; Guix also provides Codex, so a channel revision makes this build win
    ;; package specification resolution when both packages track the same tag.
    (version (string-append %codex-release-version "-roquix"))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openai/codex/")
             (commit (string-append "rust-v" %codex-release-version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0nr65d2va3yw4lvll87h8757vbax2dcl4xwngqcicc5l8bsyylsh"))))
    (build-system cargo-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (inputs (cons* ;clang-toolchain
                   openssl
                   `(,zstd "lib")
                   gcc-toolchain
                   libunwind
                   sqlite
                   bubblewrap
                   ripgrep
                   libcap ;codex-linux-sandbox
                   oniguruma ;onig-sys
                   (cargo-inputs 'codex
                                 #:module '(roquix packages rust-crates))))
    ;; PID-managed app-server daemons call ps to identify their processes.
    ;; https://github.com/openai/codex/blob/rust-v0.160.0/codex-rs/app-server-daemon/src/backend/pid.rs
    (propagated-inputs (list procps))
    (native-inputs (list rusty-v8-prebuilt-archive
                         rusty-v8-prebuilt-binding
                         pkg-config
                         cmake
                         ;; Need for tests
                         python
                         git
                         perl))
    (arguments
     `(#:install-source? #f
       ;; Match codex-rs/rust-toolchain.toml for this release.
       #:rust ,rust-1.95
       ;; A successful Guix build establishes compilation and installation,
       ;; but not test coverage: Cargo tests are disabled here.
       #:tests? #f
       #:parallel-build? #f
       ;; Build both executables together so Cargo resolves their workspace
       ;; features once; the daemon package needs both binaries.
       #:cargo-build-flags '("--package" "codex-cli" "--package"
                             "codex-code-mode-host" "--release")
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'change-directory-to-rust-source
                    (lambda _
                      (chdir "codex-rs")))
                  (add-after 'change-directory-to-rust-source 'use-guix-vendored-dependencies
                    (lambda _
                      ;; Cargo's offline vendor directory resolves these
                      ;; dependencies through Guix's versioned crate inputs.
                      (substitute* "Cargo.toml"
                        (("runfiles = \\{ git = \"https://github.com/dzbarsky/rules_rust\", rev = \"b56cbaa8465e74127f1ea216f813cd377295ad81\" \\}")
                         "runfiles = \"0.1.0\"")
                        (("nucleo = \\{ git = \"https://github.com/helix-editor/nucleo.git\", rev = \"4253de9faabb4e5c6d81d946a5e35a90f87347ee\" \\}")
                         "nucleo = \"0.5.0\"")
                        (("ratatui = \\{ git = \"https://github.com/nornagon/ratatui\", rev = \"[0-9a-f]+\" \\}")
                         "")
                        (("crossterm = \\{ git = \"https://github.com/nornagon/crossterm\", rev = \"[0-9a-f]+\" \\}")
                         "")
                        (("tokio-tungstenite = \\{ git = \"https://github.com/openai-oss-forks/tokio-tungstenite\", rev = \"[0-9a-f]+\" \\}")
                         "")
                        (("\\[patch\\.crates-io\\]")
                         "")
                        (("\\[patch\\.\"ssh://git@github\\.com/openai-oss-forks/tungstenite-rs\\.git\"\\]")
                         "")
                        (("tungstenite = \\{ git = \"https://github.com/openai-oss-forks/tungstenite-rs\", rev = \"[0-9a-f]+\" \\}")
                         ""))
                      (substitute* "tcp-tunnel/Cargo.toml"
                        (("h3 = \\{ git = \"https://github.com/hyperium/h3\", rev = \"e07e69412876f7e26f026bd75a48b2704d8c8283\" \\}")
                         "h3 = \"0.0.8\"")
                        (("h3-quinn = \\{ git = \"https://github.com/hyperium/h3\", rev = \"e07e69412876f7e26f026bd75a48b2704d8c8283\" \\}")
                         "h3-quinn = \"0.0.10\""))))
                  (add-after 'use-guix-vendored-dependencies 'remove-windows-git-dependency
                    (lambda _
                      ;; Codex is packaged only for Linux.  These Windows-only
                      ;; workspace git dependencies cannot be provided by Cargo's
                      ;; offline vendor directory.
                      (substitute* "mxc-sandbox/Cargo.toml"
                        (((string-append
                           "(appcontainer_common|learning_mode_windows|"
                           "wxc_common) = \\{ workspace = true \\}"))
                         ""))))
                  (add-after 'change-directory-to-rust-source 'patch-system-bwrap-path
                    (lambda* (#:key inputs #:allow-other-keys)
                      ;; Guix provides bwrap in the store rather than /usr/bin.
                      (let ((bwrap (search-input-file inputs "/bin/bwrap")))
                        (substitute* '("core/src/config/mod.rs"
                                       "linux-sandbox/src/launcher.rs")
                          (("/usr/bin/bwrap")
                           bwrap)))))
                  (add-after 'change-directory-to-rust-source 'fix-test
                    (lambda _
                      ;; Tese tests need environments variable named USER.
                      ;; - suite::client::azure_overrides_assign_properties_used_for_responses_url
                      ;; - suite::client::env_var_overrides_loaded_auth
                      (setenv "USER" "guix")

                      (substitute* (append (find-files "./*.rs"))
                        (("/bin/sh")
                         (which "sh"))
                        (("/bin/bash")
                         (which "bash"))
                        (("/bin/echo")
                         (which "echo"))
                        (("/bin/cat")
                         (which "cat"))
                        (("/usr/bin/sed")
                         (which "sed"))
                        (("\"command\": \"perl")
                         (string-append "\"command\": \""
                                        (which "perl"))))))
                  (add-before 'build 'use-local-rusty-v8-archive
                    (lambda* (#:key inputs #:allow-other-keys)
                      ;; The `v8` crate downloads this archive during build by
                      ;; default, which fails in the Guix build sandbox.
                      (let* ((archive-dir (string-append (assoc-ref inputs
                                                          "rusty-v8-prebuilt-archive")
                                                         "/share/rusty-v8"))
                             (archives (find-files archive-dir
                                        "librusty_v8_ptrcomp_sandbox_release_.*\\.a\\.gz$"))
                             (binding-dir (string-append (assoc-ref inputs
                                                          "rusty-v8-prebuilt-binding")
                                                         "/share/rusty-v8"))
                             (bindings (find-files binding-dir
                                        "src_binding_ptrcomp_sandbox_release_.*\\.rs$")))
                        (unless (= 1
                                   (length archives))
                          (error "expected exactly one rusty_v8 archive"
                                 archives))
                        (unless (= 1
                                   (length bindings))
                          (error "expected exactly one rusty_v8 binding"
                                 bindings))
                        (setenv "RUSTY_V8_ARCHIVE"
                                (car archives))
                        (setenv "RUSTY_V8_SRC_BINDING_PATH"
                                (car bindings)))))
                  (add-before 'build 'configure-low-memory-release
                    (lambda _
                      ;; Codex core and TUI have grown too large for even thin
                      ;; LTO in memory-constrained builders.  Keep release
                      ;; optimization, but split code generation more finely
                      ;; and omit debug line tables to reduce peak memory.
                      (setenv "CARGO_PROFILE_RELEASE_LTO" "false")
                      (setenv "CARGO_PROFILE_RELEASE_CODEGEN_UNITS" "16")
                      (setenv "CARGO_PROFILE_RELEASE_DEBUG" "false")))
                  (replace 'install
                    (lambda* (#:key inputs outputs system target
                              #:allow-other-keys)
                      ;; cargo-build-system provides guile-json to build phases.
                      ;; https://codeberg.org/guix/guix/src/branch/master/guix/build-system/cargo.scm
                      (use-modules (json))
                      ;; The standard phase runs `cargo install` separately
                      ;; for each workspace member.  That changes Cargo's
                      ;; feature resolution, recompiles part of the workspace,
                      ;; and also installs the CLI's auxiliary `logs_client`.
                      ;; The daemon copies a complete package, so install the
                      ;; layout required by Codex's package validator.
                      ;; https://github.com/openai/codex/blob/rust-v0.160.0/scripts/codex_package/README.md
                      ;; Keep bin/codex as the executable: daemon installation
                      ;; compares its bytes with the running CLI before copying.
                      ;; https://github.com/openai/codex/blob/rust-v0.160.0/codex-rs/app-server-daemon/src/prepare_install.rs
                      (let* ((out (assoc-ref outputs "out"))
                             (bin (string-append out "/bin"))
                             (resources (string-append out "/codex-resources"))
                             (path (string-append out "/codex-path"))
                             (architecture (car (string-split (or target
                                                                  system) #\-))))
                        (mkdir-p bin)
                        (mkdir-p resources)
                        (mkdir-p path)
                        (install-file "target/release/codex" bin)
                        (install-file "target/release/codex-code-mode-host"
                                      bin)
                        (install-file (search-input-file inputs "/bin/bwrap")
                                      resources)
                        (install-file (search-input-file inputs "/bin/rg")
                                      path)
                        (call-with-output-file (string-append out
                                                "/codex-package.json")
                          (lambda (port)
                            (scm->json (list (cons 'layoutVersion 1)
                                             (cons 'version
                                                   ,%codex-release-version)
                                             (cons 'target
                                                   (string-append architecture
                                                    "-unknown-linux-gnu"))
                                             (cons 'variant "codex")
                                             (cons 'entrypoint "bin/codex")
                                             (cons 'resourcesDir
                                                   "codex-resources")
                                             (cons 'pathDir "codex-path"))
                                       port)
                            (newline port)))))))))
    (home-page "https://github.com/openai/codex")
    (synopsis "Lightweight coding agent that runs in your terminal")
    (description "Lightweight coding agent that runs in your terminal")
    (properties `((max-silent-time . 9600)))
    (license license:asl2.0)))
