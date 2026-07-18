(define-module (roquix packages opencode)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages rust-apps))

(define %opencode-version "1.18.3")

(define %opencode-aarch64?
  (string=? (%current-system) "aarch64-linux"))

(define %opencode-archive
  (if %opencode-aarch64?
      "opencode-linux-arm64.tar.gz"
      "opencode-linux-x64-baseline.tar.gz"))

(define %opencode-hash
  (if %opencode-aarch64?
      "17f6b7dbbm3i4k3l69z76fj2v0d39wv9s7yml6r818zbfh8n62ns"
      "1g4f1apmhqqmydy0yfk8hz7mgmpmg065jzlm6wh2vzgr5avjm7ll"))

(define %opencode-loader
  (if %opencode-aarch64?
      "ld-linux-aarch64.so.1"
      "ld-linux-x86-64.so.2"))

(define-public opencode
  (package
    (name "opencode")
    (version %opencode-version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/anomalyco/opencode/releases/download/v"
             %opencode-version "/" %opencode-archive))
       (sha256 (base32 %opencode-hash))))
    (build-system binary-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (arguments
     (list
      #:strip-binaries? #f
      #:phases
      #~(begin
          (use-modules (ice-9 popen)
                       (ice-9 rdelim))
          (modify-phases %standard-phases
            ;; Bun executables contain data at fixed offsets.  Modifying their
            ;; ELF headers with patchelf makes them exit without running the
            ;; embedded application, so invoke the unmodified executable
            ;; through Guix's dynamic loader instead.
            (delete 'patchelf)
            (delete 'validate-runpath)
            (replace 'install
              (lambda* (#:key inputs outputs #:allow-other-keys)
                (let* ((out (assoc-ref outputs "out"))
                       (bin (string-append out "/bin"))
                       (libexec (string-append out "/libexec/opencode"))
                       (program (string-append libexec "/opencode"))
                       (wrapper (string-append bin "/opencode"))
                       (bash (assoc-ref inputs "bash-minimal"))
                       (glibc (assoc-ref inputs "glibc"))
                       (ripgrep (assoc-ref inputs "ripgrep")))
                  (mkdir-p bin)
                  (mkdir-p libexec)
                  (install-file "opencode" libexec)
                  ;; The version check creates an XDG data directory named
                  ;; "opencode" in the build tree.
                  (delete-file "opencode")
                  (chmod program #o555)
                  (call-with-output-file wrapper
                    (lambda (port)
                      (format port "#!~a/bin/bash~%" bash)
                      (format port "export PATH=~a/bin${PATH:+:}$PATH~%"
                              ripgrep)
                      (format port
                              "exec ~a/lib/~a --library-path ~a/lib ~a \"$@\"~%"
                              glibc #$%opencode-loader glibc program)))
                  (chmod wrapper #o555))))
            (add-after 'install 'check-version
              (lambda* (#:key outputs #:allow-other-keys)
                (let ((home (string-append (getcwd) "/.home"))
                      (program (string-append (assoc-ref outputs "out")
                                              "/bin/opencode")))
                  (mkdir-p home)
                  (setenv "HOME" home)
                  (for-each (lambda (name)
                              (setenv name home))
                            '("XDG_CACHE_HOME"
                              "XDG_CONFIG_HOME"
                              "XDG_DATA_HOME"
                              "XDG_STATE_HOME"))
                  (with-directory-excursion home
                    (let* ((port (open-pipe* OPEN_READ program "--version"))
                           (actual (read-line port))
                           (status (close-pipe port)))
                      (unless (and (zero? status)
                                   (string=? actual #$%opencode-version))
                        (error "unexpected OpenCode version"
                               actual)))))))))))
    (inputs (list bash-minimal glibc ripgrep))
    (home-page "https://opencode.ai/")
    (synopsis "Open source coding agent")
    (description
     "OpenCode is an open source coding agent for the terminal.  This package
uses the upstream Bun-compiled executable and adds the runtime tools expected
by OpenCode to its search path.")
    (license license:expat)))
