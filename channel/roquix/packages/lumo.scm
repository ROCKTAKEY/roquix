(define-module (roquix packages lumo)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages node)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define (tauri-js name version hash)
  (origin
    (method url-fetch)
    (uri (string-append "https://registry.npmjs.org/@tauri-apps/" name
                        "/-/" name "-" version ".tgz"))
    (sha256 (base32 hash))))

(define-public lumo-desktop
  (package
    (name "lumo-desktop")
    (version "0.5.9")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ProtonLumo/lumo-desktop")
                    (commit "bd5e2c608bac61f215d4a2094e26ef88cb7bc1e0")))
              (file-name (git-file-name name version))
              (sha256
               (base32 "1vzh2akb563nxfn31ib3cdnp6riw40a132jn8a0rh3dhjnqg1sxh"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:install-source? #f
      #:features ''("tauri/custom-protocol")
      #:cargo-test-flags ''("--features" "test-utils,tauri/custom-protocol")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'prepare-webview
            (lambda _
              (mkdir-p "node_modules/@tauri-apps")
              (symlink #$(file-append node-esbuild "/lib/node_modules/esbuild")
                       "node_modules/esbuild")
              (for-each
               (lambda (name archive)
                 (let ((directory (string-append "node_modules/@tauri-apps/" name)))
                   (mkdir directory)
                   (invoke "tar" "xf" archive "-C" directory "--strip-components=1")))
               '("api" "plugin-log")
               (list #$(tauri-js "api" "2.11.1"
                                 "02lyjd57kaaij334m2xsrv38bn6bp9xp2nkiqarqiqzvpzyxx9kh")
                     #$(tauri-js "plugin-log" "2.9.1"
                                 "0ig1v7n2qlw2dw5pxxfswccqivbkllm9k75kpjq2f2isiymf3n49")))
              (invoke "node" "scripts/build-webview.mjs")
              ;; The upstream fallback selects Proton's development service.
              (setenv "LUMO_URL" "https://lumo.proton.me")
              (chdir "src-tauri")))
          (add-before 'configure 'use-profile-command-path
            (lambda _
              ;; Desktop sessions can inherit Guix profiles without a login shell.
              (substitute* "src/tools/command_path.rs"
                (("let mut candidates = vec!\\[")
                 (string-append
                  "let mut candidates = search_dirs_from_path("
                  "&std::env::var(\"PATH\").unwrap_or_default());\n"
                  "        let defaults = vec!["))
                (("// `uv`/`pipx`") "candidates.extend(defaults);\n        // `uv`/`pipx`"))))
          (add-before 'check 'prepare-tests
            (lambda _
              (setenv "CARGO_PROFILE_TEST_DEBUG" "0")
              (setenv "SSL_CERT_DIR" #$(file-append nss-certs "/etc/ssl/certs"))))
          (add-after 'configure 'locate-tray-library
            (lambda* (#:key vendor-dir #:allow-other-keys)
              ;; libappindicator-sys loads the tray library with dlopen.
              (substitute* (string-append vendor-dir
                                          "/rust-libappindicator-sys-0.9.0.tar.gz/src/lib.rs")
                (("libappindicator3\\.so\\.1")
                 #$(file-append libappindicator "/lib/libappindicator3.so.1")))))
          (add-after 'install 'install-desktop-entry
            (lambda _
              (let ((apps (string-append #$output "/share/applications")))
                (mkdir-p apps)
                (call-with-output-file (string-append apps "/me.proton.lumo-app.desktop")
                  (lambda (port)
                    (display "[Desktop Entry]\nType=Application\nName=Lumo\nExec=lumo-desktop %U\nIcon=lumo\nCategories=Office;\nMimeType=x-scheme-handler/proton-lumo;\n" port))))
              (let ((icons (string-append #$output "/share/icons/hicolor/128x128/apps")))
                (mkdir-p icons)
                (copy-file "icons/128x128.png" (string-append icons "/lumo.png"))))))))
    (native-inputs (list cmake-minimal node perl pkg-config procps))
    (inputs (cons* dbus gtk+ libappindicator libx11 openssl webkitgtk-for-gtk3
                   (cargo-inputs 'lumo-desktop #:module '(roquix packages rust-crates))))
    (home-page "https://proton.me/lumo")
    (synopsis "Desktop client for Proton Lumo")
    (description "Lumo connects Proton's AI assistant to desktop files and
tools through a Tauri web view with per-tool approvals.")
    (license license:gpl3)))
