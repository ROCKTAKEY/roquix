(define-module (roquix packages omher)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages webkit)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages rust-crates))

(define omher-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/rlaope/oh-my-hermes")
          (commit "4726fe83e279bbca05892bc7551fc93aede5cbfb")))
    (file-name (git-file-name "omher" "1.1.2"))
    (sha256 (base32 "0wxg1rrm9zn5y71jg86niqx46193d6d0pkpji8jzsqvvsjpaz0rm"))))

(define launcher
  (local-file (canonicalize-path (search-path %load-path "roquix/packages/omher/launcher.py"))))

(define (codec-source project commit hash)
  (origin
    (method git-fetch)
    (uri (git-reference
          (url (string-append "https://github.com/jerch/" project))
          (commit commit)))
    (file-name (git-file-name project commit))
    (sha256 (base32 hash))))

(define xterm-wasm-parts
  (codec-source "xterm-wasm-parts" "92c6434eb98c16abfcb5d0b3b339baa2a836c7ee"
                "15madd67dj6n8rz04zskjsdihp9p3hm4ylaldlacgxbi21whj3qk"))

(define node-sixel
  (codec-source "node-sixel" "35f542f8b1b9a8867fab133aea5d43cb3da6108a"
                "1jszzpx1i07aixvy8fdz3vgbx1wkw8lv61fj2rw7q5gqz6ix4wz9"))

(define build-image-codecs
  (local-file (canonicalize-path (search-path %load-path "roquix/packages/omher/build-image-codecs.cjs"))))

(define pnpm-source
  (origin
    (method url-fetch)
    (uri "https://registry.npmjs.org/pnpm/-/pnpm-10.32.1.tgz")
    (sha256 (base32 "1qrky9ari1nyvi2akr59c0g0jswfad5y9n5ajfwyymcgpja3p54v"))))

(define* (fetch-web-inputs uri hash-algo hash #:optional name
                           #:key system guile #:allow-other-keys)
  (gexp->derivation
   name
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" (string-append #+node "/bin:" #+tar "/bin:" #+gzip "/bin:"
                                       #+bash-minimal "/bin:" #+coreutils "/bin"))
         (setenv "HOME" (getcwd))
         (setenv "CI" "true")
         (setenv "NODE_EXTRA_CA_CERTS"
                 #+(file-append nss-certs-for-test "/etc/ssl/certs/ca-certificates.crt"))
         (invoke "tar" "xf" #+pnpm-source)
         (mkdir "app")
         (for-each (lambda (file)
                     (copy-file (string-append #+omher-source "/apps/omher/" file)
                                (string-append "app/" file)))
                   '("pnpm-lock.yaml" "package.json" "pnpm-workspace.yaml"))
         (with-directory-excursion "app"
           (invoke "node" "../package/bin/pnpm.cjs" "install"
                   "--frozen-lockfile" "--ignore-scripts" "--config.node-linker=hoisted")
           ;; pnpm's install bookkeeping and launchers contain build-directory paths.
           (for-each delete-file (find-files "node_modules" "^\\.modules\\.yaml$|^\\.pnpm-workspace-state-v1\\.json$"))
           (for-each delete-file-recursively
                     (find-files "node_modules" "^\\.bin$" #:directories? #t))
           (copy-recursively "node_modules" #$output #:log (%make-void-port "w")))))
   #:system system #:guile-for-build guile
   #:hash-algo hash-algo #:hash hash #:recursive? #t))

(define web-inputs
  (origin
    (method fetch-web-inputs)
    (uri "omher-node-modules")
    (file-name "omher-1.1.2-node-modules")
    (sha256 (base32 "067gx9w0gx3zzlg9yx8jvxbsscnsmgxd5vqdffj7n00z92wyl4il"))))

(define-public omher
  (package
    (name "omher")
    (version "1.1.2")
    (source omher-source)
    (build-system cargo-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list #:install-source? #f
           #:cargo-build-flags ''("--release" "--features" "tauri/custom-protocol" "--bin" "omher")
           #:cargo-test-flags ''("--release" "--features" "tauri/custom-protocol" "--tests")
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'unpack 'build-frontend
                 (lambda _
                   (chdir "apps/omher")
                   (copy-recursively #$web-inputs "node_modules")
                   (for-each make-file-writable
                             (find-files "node_modules/@xterm/addon-image/lib" "^addon-image\\.m?js$"))
                   (invoke "node" #$build-image-codecs #$xterm-wasm-parts #$node-sixel
                           #$(file-append clang-22 "/bin/clang")
                           #$(file-append lld-22 "/bin/wasm-ld"))
                   (invoke "node" "node_modules/typescript/bin/tsc" "-b")
                   (invoke "node" "node_modules/vite/bin/vite.js" "build")
                   (chdir "src-tauri")
                   ;; Local subprocesses and PTY test fixtures need Guix executables.
                   (substitute* (append (find-files "src" "\\.rs$") (find-files "tests" "\\.rs$"))
                     (("/bin/sh") #$(file-append bash-minimal "/bin/sh")))
                   (substitute* "src/sessions.rs"
                     (("OsString::from\\(\"/usr/bin:/bin\"\\)")
                      (string-append "OsString::from(\"" #$coreutils "/bin\")"))
                     (("[{][}]:/usr/bin:/bin") (string-append "{}:" #$coreutils "/bin"))
                     (("/bin/cat") (which "cat"))
                     (("/usr/bin/yes") (which "yes"))
                     (("/bin/bash") #$(file-append bash-minimal "/bin/bash")))
                   (substitute* "src/peers.rs"
                     (("/usr/bin:/bin") (getenv "PATH")))
                   ;; Tauri's Linux resource resolver assumes an FHS install prefix.
                   (substitute* "src/lib.rs"
                     (("app.path\\(\\).resource_dir\\(\\).ok\\(\\)")
                      (string-append "Some(std::path::PathBuf::from(\"" #$output "/lib/omher\"))")))))
               (replace 'install
                 (lambda _
                   (let ((bin (string-append #$output "/bin/omher"))
                         (exe (string-append #$output "/libexec/omher")))
                     (install-file "target/release/omher" (dirname exe))
                     ;; The GTK tray loads libappindicator with dlopen.
                     (invoke "patchelf" "--add-rpath" #$(file-append libappindicator "/lib") exe)
                     (mkdir-p (dirname bin))
                     (copy-file #$launcher bin)
                     (substitute* bin
                       (("@python@") #$(file-append python "/bin/python3"))
                       (("@executable@") exe)
                       (("@host_tools@") (string-append #$curl "/bin:" #$coreutils "/bin:"
                                                       #$bash-minimal "/bin")))
                     (chmod bin #o555))
                   (substitute* "../bridge/omher_bridge.py"
                     (("DEFAULT_HERMES_ROOT = _default_hermes_root\\(\\)")
                      "DEFAULT_HERMES_ROOT = Path(os.environ.get('OMHER_HERMES_ROOT') or _default_hermes_root())"))
                   (install-file "../bridge/omher_bridge.py" (string-append #$output "/lib/omher/bridge"))
                   (install-file "../THIRD_PARTY_NOTICES.md" (string-append #$output "/share/doc/omher"))
                   (install-file "icons/icon.png" (string-append #$output "/share/pixmaps/omher"))
                   (make-desktop-entry-file
                    (string-append #$output "/share/applications/omher.desktop")
                    #:name "omher" #:exec (string-append #$output "/bin/omher %U")
                    #:icon (string-append #$output "/share/pixmaps/omher/icon.png")
                    #:mime-type '("x-scheme-handler/omher")
                    #:categories '("Development")))))))
    (native-inputs (list curl node patchelf perl pkg-config))
    (inputs (cons* gtk+ openssl webkitgtk-for-gtk3 libappindicator dbus
                   (cargo-inputs 'omher #:module '(roquix packages rust-crates))))
    (home-page "https://omher.app/")
    (synopsis "Desktop workspace for Hermes Agent")
    (description "Omher brings Hermes conversations, tasks and agent terminals
together in a Tauri desktop application.")
    (license license:expat)))
