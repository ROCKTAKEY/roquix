(define-module (roquix packages opencode)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix records)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages rust-apps))

(define %opencode-version "1.18.3")
(define %bun-version "1.3.14")

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

(define %bun-archive
  (if %opencode-aarch64?
      "bun-linux-aarch64.zip"
      "bun-linux-x64-baseline.zip"))

(define %bun-hash
  (if %opencode-aarch64?
      "0fwsl5rijcv53j17rhw8ig8xia3zw656cvqdds1pa0rim1iznzx2"
      "1iz66qxxfr9xx3f0557vx2ydlggdrv3bv6wk23554y4bw2590qx0"))

;; Bun is self-hosting and Guix does not currently package it.  Keep the
;; bootstrap executable private and use it only while building OpenCode.
(define bun-bootstrap
  (package
    (name "bun-bootstrap")
    (version %bun-version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/oven-sh/bun/releases/download/bun-v"
             %bun-version "/" %bun-archive))
       (sha256 (base32 %bun-hash))))
    (build-system copy-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (arguments
     (list
      #:install-plan #~'(("bun" "libexec/bun/bun"))
      #:strip-binaries? #f
      #:validate-runpath? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'patch-interpreter-in-place
            (lambda* (#:key outputs #:allow-other-keys)
              ;; patchelf grows this self-extracting executable and invalidates
              ;; offsets used by Bun.compile.  Replace the interpreter bytes
              ;; without changing the file size instead.
              (use-modules (rnrs bytevectors)
                           (rnrs io ports))
              (let* ((file (string-append (assoc-ref outputs "out")
                                           "/libexec/bun/bun"))
                     (old (string->utf8
                           (string-append "/lib" (if #$%opencode-aarch64?
                                                     ""
                                                     "64")
                                          "/" #$%opencode-loader)))
                     (new (string->utf8 "/tmp/bun-ld.so"))
                     (input (open-file file "rb"))
                     (data (get-bytevector-all input)))
                (close-port input)
                (let search ((offset 0))
                  (cond
                   ((> (+ offset (bytevector-length old))
                       (bytevector-length data))
                    (error "Bun ELF interpreter not found"))
                   ((let compare ((index 0))
                      (or (= index (bytevector-length old))
                          (and (= (bytevector-u8-ref data (+ offset index))
                                  (bytevector-u8-ref old index))
                               (compare (+ index 1)))))
                    (bytevector-copy! new 0 data offset
                                      (bytevector-length new))
                    (do ((index (+ offset (bytevector-length new))
                                (+ index 1)))
                        ((= index (+ offset (bytevector-length old))))
                      (bytevector-u8-set! data index 0))
                    (let ((output (open-file file "wb")))
                      (put-bytevector output data)
                      (close-port output)))
                   (else (search (+ offset 1)))))
                (chmod file #o555))))
          (add-after 'install 'make-wrapper
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (bin (string-append out "/bin"))
                     (wrapper (string-append bin "/bun"))
                     (program (string-append out "/libexec/bun/bun"))
                     (bash (assoc-ref inputs "bash-minimal"))
                     (glibc (assoc-ref inputs "glibc")))
                (mkdir-p bin)
                (call-with-output-file wrapper
                  (lambda (port)
                    (format port "#!~a/bin/bash~%" bash)
                    (format port
                            "exec ~a/lib/~a --library-path ~a/lib ~a \"$@\"~%"
                            glibc #$%opencode-loader glibc program)))
                (chmod wrapper #o555)))))))
    (native-inputs (list unzip))
    (inputs (list bash-minimal glibc))
    (home-page "https://bun.sh/")
    (synopsis "Bootstrap Bun executable for building OpenCode")
    (description
     "This private package provides the pinned Bun executable needed to build
OpenCode from source.  It is not propagated to the OpenCode runtime closure.")
    (license license:expat)))

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
                   #$(file-append nss-certs
                                  "/etc/ssl/certs/ca-certificates.crt"))
           (setenv "HOME" (string-append (getcwd) "/.home"))
           (setenv "XDG_CACHE_HOME" (string-append (getcwd) "/.cache"))
           (setenv "BUN_INSTALL_CACHE_DIR"
                   (string-append (getcwd) "/.bun-cache"))
           (false-if-exception (delete-file "/tmp/bun-ld.so"))
           (symlink #$(file-append glibc "/lib/" %opencode-loader)
                    "/tmp/bun-ld.so")
           (mkdir-p (getenv "HOME"))
           (copy-recursively #+source "source")
           (with-directory-excursion "source"
             (invoke #$(file-append coreutils "/bin/chmod")
                     "-R" "u+w" ".")
             (invoke #$(file-append bun "/libexec/bun/bun")
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
             (invoke #$(file-append bun "/libexec/bun/bun") "--bun"
                     "nix/scripts/canonicalize-node-modules.ts")
             (invoke #$(file-append bun "/libexec/bun/bun") "--bun"
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
          (bun bun-bootstrap)
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
                   "if (false) {"))))
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
                (let ((bun (string-append (assoc-ref inputs "bun-bootstrap")
                                          "/libexec/bun/bun"))
                      (glibc (assoc-ref inputs "glibc")))
                  (setenv "HOME" (string-append (getcwd) "/.home"))
                  (for-each
                   (lambda (name)
                     (setenv name (string-append (getcwd) "/." name)))
                   '("XDG_CACHE_HOME" "XDG_CONFIG_HOME" "XDG_DATA_HOME"
                     "XDG_STATE_HOME"))
                  (setenv "OPENCODE_VERSION" #$%opencode-version)
                  (setenv "OPENCODE_CHANNEL" "prod")
                  (setenv "OPENCODE_DISABLE_MODELS_FETCH" "1")
                  (false-if-exception (delete-file "/tmp/bun-ld.so"))
                  (symlink (string-append glibc "/lib/"
                                          #$%opencode-loader)
                           "/tmp/bun-ld.so")
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
                              "exec ~a/lib/~a --library-path ~a/lib ~a \"$@\"~%"
                              glibc #$%opencode-loader glibc program)))
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
     `(("bun-bootstrap" ,bun-bootstrap)
       ("node" ,node)
       ("node_modules" ,%opencode-node-modules)))
    (inputs (list bash-minimal glibc ripgrep))
    (home-page "https://opencode.ai/")
    (synopsis "Open source coding agent")
    (description
     "OpenCode is an open source coding agent for the terminal.  This package
builds the CLI, terminal interface, embedded web interface, and configuration
schema from the upstream source and adds the runtime tools expected by
OpenCode to its search path.")
    (license license:expat)))
