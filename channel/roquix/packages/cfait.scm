(define-module (roquix packages cfait)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages regex)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages text-editors)
  #:use-module (gnu packages vulkan)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg))

(define (cfait-resource-path name)
  (canonicalize-path
   (search-path %load-path (string-append "roquix/packages/cfait/" name))))

(define-public cfait
  (package
    (name "cfait")
    (version "1.2.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://codeload.github.com/trougnouf/cfait/tar.gz/"
             "refs/tags/v" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1xvvhz059zlrz5dbc3xb9gwd3qvl0j82rmq4sbbpjl2br49kcjdl"))
       ;; Filename expansion permits command injection through TMPDIR/profile
       ;; paths.  Keep filenames separate from the configured editor command.
       ;; The lockfile patch pins fixes for RUSTSEC-2026-0381/0382/0385;
       ;; advisory links and rationale are included in the patches.
       (patches (list (cfait-resource-path "cfait-editor-arguments.patch")
                      (cfait-resource-path "cfait-security-dependencies.patch")))))
    (build-system cargo-build-system)
    (arguments
     (list
      ;; serial_test 4.0.1 requires Rust 1.93.1 or newer.
      #:rust rust-1.94
      #:install-source? #f
      #:features ''("gui")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'configure 'patch-lru-panic-safety
            (lambda* (#:key vendor-dir #:allow-other-keys)
              ;; cryoglyph requires lru 0.16.  Backport the upstream fix without
              ;; changing its dependency API.  Apply only to Cfait's vendor tree.
              ;; https://rustsec.org/advisories/RUSTSEC-2026-0253.html
              (let ((files (find-files vendor-dir
                                      (lambda (file stat)
                                        (and (string-contains file
                                              "/rust-lru-0.16.4.tar.gz/")
                                             (string-suffix? "/src/lib.rs"
                                                             file))))))
                (unless (= (length files) 1)
                  (error "Expected exactly one lru 0.16.4 source" files))
                (invoke "patch" "-p1" "--batch" "--forward"
                        "-d" (dirname (dirname (car files)))
                        "-i" #$(local-file
                                (cfait-resource-path
                                 "lru-pop-panic-safety.patch")))
                ;; Dependency unit tests are not run by cargo test for Cfait.
                ;; This standalone test exercises the patched cache invariant
                ;; using std's HashMap, without adding test-only crate inputs.
                (mkdir-p "target/guix-security-tests")
                (invoke "rustc" "--edition=2021" "--crate-name" "lru"
                        "--crate-type" "rlib" (car files)
                        "-o" "target/guix-security-tests/liblru.rlib")
                (invoke "rustc" "--edition=2021" "--test"
                        #$(local-file
                           (cfait-resource-path "package-tests/lru-pop.rs"))
                        "--extern"
                        "lru=target/guix-security-tests/liblru.rlib"
                        "-o" "target/guix-security-tests/lru-pop"))))
          (add-after 'configure 'provide-fontconfig-fallback
            (lambda* (#:key vendor-dir #:allow-other-keys)
              ;; fontdb parses XML itself and cannot discover Fontconfig's
              ;; compiled-in configuration path.  Preserve system and user
              ;; settings while supplying fonts in environments without /etc.
              ;; https://github.com/RazrFalcon/fontdb/tree/v0.23.0
              (substitute* (find-files vendor-dir
                                       (lambda (file stat)
                                         (and (string-contains file
                                               "/rust-fontdb-")
                                              (string-suffix? "/src/lib.rs"
                                                              file))))
                (("fontconfig\\.merge_config\\(Path::new\\(\"/etc/fonts/fonts\\.conf\"\\)\\)")
                 (string-append
                  "fontconfig.merge_config(Path::new(\"/etc/fonts/fonts.conf\"))"
                  ".or_else(|_| fontconfig.merge_config(Path::new(\""
                  #$(file-append fontconfig "/etc/fonts/fonts.conf") "\")))")))))
          (add-before 'check 'prepare-test-environment
            (lambda _
              (setenv "HOME"
                      (getcwd))
              (setenv "SSL_CERT_DIR"
                      #$(file-append nss-certs "/etc/ssl/certs"))))
          (replace 'check
            (lambda* (#:key tests? parallel-build? parallel-tests?
                      #:allow-other-keys)
              (when tests?
                (invoke "target/guix-security-tests/lru-pop")
                ;; Upstream omits debug info for its many integration binaries.
                (setenv "CARGO_PROFILE_TEST_DEBUG" "0")
                ;; Criterion's harness rejects Guix's --test-threads argument.
                ;; RUST_TEST_THREADS controls libtest without changing the
                ;; arguments passed to upstream's benchmark smoke tests.
                ;; See .forgejo/workflows/test_roll.yml in the pinned source:
                ;; https://github.com/trougnouf/cfait/tree/v1.2.1
                (setenv "RUST_TEST_THREADS"
                        (number->string (if parallel-tests?
                                            (parallel-job-count) 1)))
                (invoke "cargo"
                        "test"
                        "--offline"
                        "--all-targets"
                        "--features"
                        "gui,test_hooks"
                        "-j"
                        (number->string (if parallel-build?
                                            (parallel-job-count) 1))))))
          (add-after 'install 'install-desktop-files
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                ;; The window's application ID and WM_CLASS are both "cfait".
                ;; AppStream and the desktop entry must identify that window.
                (substitute* "assets/cfait.desktop"
                  (("StartupWMClass=cfait-gui")
                   "StartupWMClass=cfait"))
                (substitute* "assets/com.trougnouf.Cfait.metainfo.xml"
                  (("com\\.trougnouf\\.Cfait\\.desktop")
                   "cfait.desktop"))
                (install-file "assets/cfait.desktop"
                              (string-append out "/share/applications"))
                (install-file "assets/cfait.svg"
                              (string-append out
                               "/share/icons/hicolor/scalable/apps"))
                (install-file "assets/com.trougnouf.Cfait.metainfo.xml"
                              (string-append out "/share/metainfo")))))
          (add-after 'install-desktop-files 'wrap-programs
            (lambda* (#:key outputs #:allow-other-keys)
              (define (wrap binary . variables)
                (apply wrap-program
                       (string-append (assoc-ref outputs "out") "/bin/" binary)
                       `("PATH" prefix
                         (#$(file-append bash-minimal "/bin")
                          #$(file-append nano "/bin")
                          #$(file-append xdg-utils "/bin"))) variables))
              (wrap "cfait")
              (wrap "cfait-gui"
                    `("LD_LIBRARY_PATH" prefix
                      ,(map (lambda (directory)
                              (string-append directory "/lib"))
                            (list #$libx11
                                  #$libxcursor
                                  #$libxi
                                  #$libxrandr
                                  #$libxkbcommon
                                  #$wayland
                                  #$mesa
                                  #$vulkan-loader)))))))))
    (native-inputs (list pkg-config gcc-toolchain))
    (inputs (cons* bash-minimal
                   fontconfig
                   libxkbcommon
                   nano
                   oniguruma
                   wayland
                   xdg-utils
                   `(,zstd "lib")
                   (cargo-inputs 'cfait
                                 #:module '(roquix packages rust-crates))))
    (home-page "https://git.disroot.org/trougnouf/cfait")
    (synopsis "Task manager with terminal and graphical interfaces")
    (description
     "Cfait manages local task lists and synchronizes them with CalDAV servers.
It provides terminal and graphical interfaces, recurring tasks, hierarchical
tags, dependencies, time tracking, and natural-language task entry.")
    (license (list license:gpl3+
                   license:agpl3 ;GNOME help icon
                   license:lgpl3+ ;Breeze icon
                   license:silofl1.1 ;Nerd Fonts
                   license:expat))))      ;Nerd Fonts glyphs
