(define-module (roquix packages lumo)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages debian)
  #:use-module (gnu packages elf)
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
  #:use-module (gnu packages rust-crates)
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

(define tauri-cli
  (package
    (name "tauri-cli")
    (version "2.11.4")
    (source (crate-source "tauri-cli" version
                          "0xds4kcqrjvk6pbwpgp44mkh47bihkflsyp18rn6z4li09ycbnpy"))
    (build-system cargo-build-system)
    (arguments (list #:install-source? #f))
    (native-inputs (list pkg-config perl))
    (inputs (cons* openssl `(,zstd "lib")
                   (cargo-inputs 'tauri-cli #:module '(roquix packages rust-crates))))
    (home-page "https://tauri.app")
    (synopsis "Build and bundle Tauri applications")
    (description "The Tauri CLI builds desktop applications and packages their
executables, resources, icons and launchers for distribution.")
    (license (list license:asl2.0 license:expat))))

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
      #:cargo-test-flags ''("--features" "test-utils")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'prepare-webview
            (lambda _
              ;; Seed the offline npm install with the archives in package-lock.json.
              (setenv "npm_config_offline" "true")
              (setenv "npm_config_cache" (string-append (getcwd) "/npm-cache"))
              (setenv "npm_config_script_shell" (which "sh"))
              (invoke "npm" "cache" "add"
                      #$(tauri-js "api" "2.11.1"
                                 "02lyjd57kaaij334m2xsrv38bn6bp9xp2nkiqarqiqzvpzyxx9kh")
                      #$(tauri-js "plugin-log" "2.9.1"
                                 "0ig1v7n2qlw2dw5pxxfswccqivbkllm9k75kpjq2f2isiymf3n49")
                      #$(tauri-js "plugin-autostart" "2.5.1"
                                 "04x7r1859hf636p9wsil2q16phqxk9gggwjzbjb9z83ycccx1xr7"))
              (invoke "npm" "ci" "--omit=dev" "--ignore-scripts" "--no-audit" "--no-fund")
              (symlink #$(file-append node-esbuild "/lib/node_modules/esbuild")
                       "node_modules/esbuild")
              (mkdir-p "node_modules/.bin")
              (symlink #$(file-append tauri-cli "/bin/cargo-tauri")
                       "node_modules/.bin/tauri")
              (chdir "src-tauri")))
          (add-before 'configure 'use-profile-command-path
            (lambda _
              ;; Desktop sessions can inherit Guix profiles without a login shell.
              (substitute* "src/tools/command_path.rs"
                (("candidates.retain" original)
                 (string-append
                  "candidates.splice(0..0, search_dirs_from_path("
                  "&std::env::var(\"PATH\").unwrap_or_default()));\n        " original)))))
          (replace 'build
            (lambda _
              ;; Upstream defaults to the development service.
              (setenv "LUMO_URL" "https://lumo.proton.me")
              (setenv "CARGO_NET_OFFLINE" "true")
              (setenv "CARGO_BUILD_JOBS" (number->string (parallel-job-count)))
              (with-directory-excursion ".."
                (invoke "npm" "run" "build" "--" "--bundles" "deb" "--ci"))))
          (add-before 'check 'prepare-tests
            (lambda _
              (setenv "CARGO_PROFILE_TEST_DEBUG" "0")
              (setenv "SSL_CERT_DIR" #$(file-append nss-certs "/etc/ssl/certs"))))
          (replace 'install
            (lambda _
              (apply (lambda (deb) (invoke "dpkg-deb" "--extract" deb "bundle"))
                     (find-files "target/release/bundle/deb" "\\.deb$"))
              (copy-recursively "bundle/usr" #$output)
              ;; The tray uses dlopen, so the linker omits this runtime path.
              (invoke "patchelf" "--add-rpath" #$(file-append libappindicator "/lib")
                      (string-append #$output "/bin/lumo-desktop")))))))
    (native-inputs (list cmake-minimal dpkg node patchelf perl pkg-config procps))
    (inputs (cons* dbus gtk+ libappindicator libx11 openssl webkitgtk-for-gtk3
                   (cargo-inputs 'lumo-desktop #:module '(roquix packages rust-crates))))
    (home-page "https://proton.me/lumo")
    (synopsis "Desktop client for Proton Lumo")
    (description "Lumo connects Proton's AI assistant to desktop files and
tools through a Tauri web view with per-tool approvals.")
    (license license:gpl3)))
