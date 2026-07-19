(define-module (roquix packages opencode)
  #:use-module (roquix packages bun)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix records)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages rust-apps))

(define %opencode-version "1.18.3")

(define %opencode-aarch64?
  (string=? (%current-system) "aarch64-linux"))

(define %opencode-loader
  (if %opencode-aarch64?
      "ld-linux-aarch64.so.1"
      "ld-linux-x86-64.so.2"))

(define %opencode-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/anomalyco/opencode")
          (commit (string-append "v" %opencode-version))))
    (file-name (git-file-name "opencode" %opencode-version))
    (sha256
     (base32 "0pnm9r6b39sl6jnvkd009wq5ky04zc8xj9pi6cvpr83xrsd37nar"))))

(define-record-type* <bun-node-modules-reference>
  bun-node-modules-reference make-bun-node-modules-reference
  bun-node-modules-reference?
  (source bun-node-modules-reference-source)
  (bun bun-node-modules-reference-bun)
  (cpu bun-node-modules-reference-cpu))

(define* (bun-node-modules-fetch ref hash-algo hash
                                 #:optional name
                                 #:key (system (%current-system))
                                 #:allow-other-keys)
  "Return a fixed-output derivation containing OpenCode's NODE_MODULES."
  (let ((source (bun-node-modules-reference-source ref))
        (bun (bun-node-modules-reference-bun ref))
        (cpu (bun-node-modules-reference-cpu ref)))
    (with-imported-modules '((guix build utils))
      (gexp->derivation
       (or name "opencode-node-modules")
       #~(begin
           (use-modules (guix build utils))
           (setenv "PATH"
                   (string-append #+bash-minimal "/bin:"
                                  #+coreutils "/bin:"
                                  #+findutils "/bin"))
           (setenv "SSL_CERT_FILE"
                   #$(file-append nss-certs-for-test
                                  "/etc/ssl/certs/ca-certificates.crt"))
           (setenv "HOME" (string-append (getcwd) "/.home"))
           (setenv "XDG_CACHE_HOME" (string-append (getcwd) "/.cache"))
           (setenv "BUN_INSTALL_CACHE_DIR"
                   (string-append (getcwd) "/.bun-cache"))
           (mkdir-p (getenv "HOME"))
           (copy-recursively #+source "source")
           (with-directory-excursion "source"
             (invoke #$(file-append coreutils "/bin/chmod")
                     "-R" "u+w" ".")
             (invoke #$(file-append bun "/bin/bun")
                     "install"
                     (string-append "--cpu=" #$cpu)
                     "--os=linux"
                     "--filter" "!./"
                     "--filter" "./packages/opencode"
                     "--filter" "./packages/desktop"
                     "--filter" "./packages/app"
                     "--frozen-lockfile"
                     "--ignore-scripts"
                     "--no-progress")
             (invoke #$(file-append bun "/bin/bun") "--bun"
                     "nix/scripts/canonicalize-node-modules.ts")
             (invoke #$(file-append bun "/bin/bun") "--bun"
                     "nix/scripts/normalize-bun-binaries.ts")
             (mkdir-p #$output)
             (invoke #$(file-append findutils "/bin/find")
                     "." "-type" "d" "-name" "node_modules"
                     "-exec" #$(file-append coreutils "/bin/cp")
                     "-R" "--parents" "{}" #$output ";")))
       #:system system
       #:hash-algo hash-algo
       #:hash hash
       #:recursive? #t
       #:local-build? #t
       #:leaked-env-vars '("http_proxy" "https_proxy" "HTTP_PROXY"
                           "HTTPS_PROXY" "no_proxy" "NO_PROXY")))))

(define %opencode-node-modules
  (origin
    (method bun-node-modules-fetch)
    (uri (bun-node-modules-reference
          (source %opencode-source)
          (bun bun)
          (cpu (if %opencode-aarch64? "arm64" "x64"))))
    (file-name (string-append "opencode-node-modules-"
                              %opencode-version))
    ;; These are the architecture-specific recursive hashes recorded by the
    ;; upstream Nix build after canonicalizing node_modules.
    (sha256
     (base32
      (if %opencode-aarch64?
          "0pl26vkr2hi3r887gjymziylg1j5rhwgaisj60vlaih2gdk1fvax"
          "0vkpjzziddyjpf0wrnqz4yfkz8qrk3j9jprcywjg827ab5r6wn8p")))))

(define-public opencode
  (package
    (name "opencode")
    (version %opencode-version)
    (source %opencode-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:validate-runpath? #f
      #:phases
      #~(begin
          (use-modules (ice-9 popen)
                       (ice-9 rdelim))
          (modify-phases %standard-phases
            (delete 'bootstrap)
            (delete 'configure)
            (add-after 'unpack 'disable-unwrapped-smoke-test
              (lambda _
                ;; The generated ELF cannot use /lib64/ld-linux directly in a
                ;; Guix build container.  Test it after installing the loader
                ;; wrapper instead.
                (substitute* "packages/opencode/script/build.ts"
                  (("if \\(item.os.*!item.abi\\) \\{")
                   "if (false) {")
                  ;; A platform-qualified target selects Bun's prebuilt
                  ;; compiler artifact from node_modules.  Compile against
                  ;; the current, source-built Guix Bun runtime instead.
                  (("target: name.replace\\(pkg.name, \"bun\"\\) as any,")
                   "// target omitted: use the current Bun runtime"))))
            (add-before 'build 'install-node-modules
              (lambda* (#:key inputs #:allow-other-keys)
                (let ((modules (assoc-ref inputs "node_modules")))
                  (let ((null (open-output-file "/dev/null")))
                    (copy-recursively modules "." #:log null)
                    (close-port null))
                  (invoke "chmod" "-R" "u+w" ".")
                  (let ((regular-file?
                         (lambda (_ stat)
                           (eq? 'regular (stat:type stat)))))
                    (for-each patch-shebang
                              (append
                               (find-files "node_modules" regular-file?)
                               (find-files "packages"
                                           (lambda (file stat)
                                             (and (regular-file? file stat)
                                                  (string-contains
                                                   file "/node_modules/"))))))))))
            (replace 'build
              (lambda* (#:key inputs #:allow-other-keys)
                (let ((bun (string-append (assoc-ref inputs "bun")
                                          "/bin/bun")))
                  (setenv "HOME" (string-append (getcwd) "/.home"))
                  (for-each
                   (lambda (name)
                     (setenv name (string-append (getcwd) "/." name)))
                   '("XDG_CACHE_HOME" "XDG_CONFIG_HOME" "XDG_DATA_HOME"
                     "XDG_STATE_HOME"))
                  (setenv "OPENCODE_VERSION" #$%opencode-version)
                  (setenv "OPENCODE_CHANNEL" "prod")
                  (setenv "OPENCODE_DISABLE_MODELS_FETCH" "1")
                  (setenv
                   "MODELS_DEV_API_JSON"
                   (string-append
                    (getcwd)
                    "/packages/opencode/test/tool/fixtures/models-api.json"))
                  (mkdir-p (getenv "HOME"))
                  (with-directory-excursion "packages/opencode"
                    (invoke bun "--bun" "./script/build.ts"
                            "--single" "--skip-install")
                    (invoke bun "--bun" "./script/schema.ts" "schema.json")))))
            (replace 'install
              (lambda* (#:key inputs outputs #:allow-other-keys)
                (let* ((out (assoc-ref outputs "out"))
                       (bin (string-append out "/bin"))
                       (libexec (string-append out "/libexec/opencode"))
                       (program (string-append libexec "/opencode"))
                       (wrapper (string-append bin "/opencode"))
                       (bash (assoc-ref inputs "bash-minimal"))
                       (glibc (assoc-ref inputs "glibc"))
                       (icu (assoc-ref inputs "icu4c"))
                       (ripgrep (assoc-ref inputs "ripgrep"))
                       (built
                        (car
                         (find-files
                          "packages/opencode/dist"
                          (lambda (file stat)
                            (and (eq? 'regular (stat:type stat))
                                 (string-suffix? "/bin/opencode" file)))))))
                  (mkdir-p bin)
                  (mkdir-p libexec)
                  (install-file built libexec)
                  (chmod program #o555)
                  (install-file "packages/opencode/schema.json"
                                (string-append out "/share/opencode"))
                  (call-with-output-file wrapper
                    (lambda (port)
                      (format port "#!~a/bin/bash~%" bash)
                      (format port "export PATH=~a/bin${PATH:+:}$PATH~%"
                              ripgrep)
                      (format port
                              "exec ~a/lib/~a --library-path ~a/lib:~a/lib ~a \"$@\"~%"
                              glibc #$%opencode-loader glibc icu program)))
                  (chmod wrapper #o555))))
            (add-after 'install 'install-completions
              (lambda* (#:key outputs #:allow-other-keys)
                (let* ((out (assoc-ref outputs "out"))
                       (program (string-append out "/bin/opencode"))
                       (bash-dir (string-append
                                  out "/share/bash-completion/completions"))
                       (zsh-dir (string-append
                                 out "/share/zsh/site-functions")))
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
                  (for-each (lambda (name) (setenv name home))
                            '("XDG_CACHE_HOME" "XDG_CONFIG_HOME"
                              "XDG_DATA_HOME" "XDG_STATE_HOME"))
                  (setenv "OPENCODE_DISABLE_MODELS_FETCH" "1")
                  (with-directory-excursion home
                    (let* ((port (open-pipe* OPEN_READ program "--version"))
                           (actual (read-line port))
                           (status (close-pipe port)))
                      (unless (and (zero? status)
                                   (string=? actual #$%opencode-version))
                        (error "unexpected OpenCode version" actual)))))))))))
    (native-inputs
     `(("bun" ,bun)
       ("node" ,node)
       ("node_modules" ,%opencode-node-modules)))
    (inputs (list bash-minimal glibc icu4c ripgrep))
    (home-page "https://opencode.ai/")
    (synopsis "Open source coding agent")
    (description
     "OpenCode is an open source coding agent for the terminal.  This package
builds the CLI, terminal interface, embedded web interface, and configuration
schema from the upstream source and adds the runtime tools expected by
OpenCode to its search path.")
    (license license:expat)))
