(define-module (roquix packages goose)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system trivial)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages xorg))

(define rusty-v8-goose-archive
  (package
    (name "rusty-v8-goose-archive")
    (version "145.0.0")
    (source
     (let ((archive (cond
                      ((string=? (%current-system) "aarch64-linux")
                       '("librusty_v8_release_aarch64-unknown-linux-gnu.a.gz"
                         "09jzmb66qk1q1cxkkri93ri58jyx6vlfygcn5l62nl91r5iaz270"))
                      (else '("librusty_v8_release_x86_64-unknown-linux-gnu.a.gz"
                              "1hfap9v4x9jgm356sipx3n5f21xf9dwr7ffpabvl3lbq1hy7a5bj")))))
       (origin
         (method url-fetch)
         (uri (string-append
               "https://github.com/denoland/rusty_v8/releases/download/v"
               version "/"
               (car archive)))
         (sha256 (base32 (cadr archive))))))
    (build-system trivial-build-system)
    (arguments
     (list
      #:modules '((guix build utils))
      #:builder
      #~(begin
          (use-modules (guix build utils))
          (let* ((out (assoc-ref %outputs "out"))
                 (source (assoc-ref %build-inputs "source"))
                 (destination (string-append out "/share/rusty-v8")))
            (mkdir-p destination)
            (copy-file source
                       (string-append destination "/"
                                      (basename source)))))))
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (home-page "https://github.com/denoland/rusty_v8")
    (synopsis "Prebuilt rusty_v8 static library archive for Goose")
    (description
     "This helper package installs the prebuilt static library archive used
by Goose so its Guix build does not attempt a network download.")
    (license (list license:expat license:bsd-3))))

(define-public goose-cli
  (package
    (name "goose-cli")
    (version "1.48.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/aaif-goose/goose")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1rk84fi4516d4lhm6p924r0i1ns3j8lvhi28bxxirxag0w0q1lpj"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.94
      #:install-source? #f
      #:parallel-tests? #f
      #:cargo-install-paths ''("crates/goose-cli")
      #:cargo-build-flags ''("--release" "--package" "goose-cli")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'use-vendored-git-sources
            (lambda _
              ;; The pinned ACP workspace is packaged into versioned crates in
              ;; rust-sources.scm, following the Guix Cargo workspace pattern:
              ;; https://guix.gnu.org/manual/devel/en/html_node/Rust-Crates.html
              ;; Removing the Git overrides lets Cargo resolve those exact
              ;; crates from the Guix-generated vendor directory.
              (substitute* "Cargo.toml"
                (("^(agent-client-protocol(-http)?|cudaforge) = \\{ git = .*$")
                 ""))))
          (add-after 'unpack 'setenv
            (lambda* (#:key inputs #:allow-other-keys)
              ;; NOTE: Need for test.
              ;; The full path should include the word "goose"
              ;; for test logging::tests::test_log_directory_creation.
              (setenv "GOOSE_PATH_ROOT" "/tmp/goose")
              ;; llama-cpp-sys generates bindings during the build.
              (setenv "LIBCLANG_PATH"
                      (string-append (assoc-ref inputs "clang") "/lib"))))
          (add-before 'build 'use-local-rusty-v8-archive
            (lambda* (#:key inputs #:allow-other-keys)
              ;; v8-goose otherwise downloads this archive during its build
              ;; script, which is forbidden in the Guix build sandbox.
              (let* ((archive-directory (string-append (assoc-ref inputs
                                                        "rusty-v8-goose-archive")
                                                       "/share/rusty-v8"))
                     (archives (find-files archive-directory
                                           "librusty_v8_.*\\.a\\.gz$")))
                (unless (= 1
                           (length archives))
                  (error "expected exactly one rusty_v8 archive" archives))
                (setenv "RUSTY_V8_ARCHIVE"
                        (car archives))))))
      #:cargo-test-flags ''("--package" "goose-cli" "--tests")))
    (inputs (cons* (list zstd "lib") sqlite oniguruma libxcb
                   (cargo-inputs 'goose-cli
                                 #:module '(roquix packages rust-crates))))
    (native-inputs (list pkg-config
                         clang-18
                         cmake-minimal
                         git-minimal
                         nss-certs-for-test
                         rusty-v8-goose-archive))
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (home-page "https://github.com/aaif-goose/goose")
    (synopsis "AI agent CLI")
    (description "This package provides the Goose AI agent CLI.")
    (license license:asl2.0)))
