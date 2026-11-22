(define-module (roquix packages omher)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (roquix packages omher image-addon)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages webkit)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages rust-crates)
  #:use-module ((roquix packages hermes) #:select (hermes))
  #:use-module ((roquix packages hermes interpreter) #:select (hermes-python)))

(define omher-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/rlaope/oh-my-hermes")
          (commit "4726fe83e279bbca05892bc7551fc93aede5cbfb")))
    (file-name (git-file-name "omher" "1.1.2"))
    (sha256 (base32 "0wxg1rrm9zn5y71jg86niqx46193d6d0pkpji8jzsqvvsjpaz0rm"))))

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
                   (delete-file-recursively "node_modules/@xterm/addon-image")
                   (copy-recursively #$image-addon "node_modules/@xterm/addon-image")
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
                     ;; Omher normally finds Hermes's Python under the user's Hermes home.
                     ;; Guix installs Python and the Hermes modules in separate store
                     ;; locations, so the desktop launcher supplies both paths.
                     (call-with-output-file bin
                       (lambda (port)
                         (format port "#!~a~%" #$(file-append bash-minimal "/bin/sh"))
                         (display "if test -z \"$OMHER_HERMES_PYTHON\"; then\n" port)
                         (format port "  export OMHER_HERMES_PYTHON=~s~%"
                                 #$(file-append hermes-python "/bin/python3"))
                         (format port "  export OMHER_HERMES_ROOT=~s~%fi~%"
                                 #$(file-append hermes "/lib/hermes/source"))
                         (format port "export PATH=\"~a${PATH:+:$PATH}:~a\"~%"
                                 #$(file-append hermes "/bin")
                                 (string-join
                                  (list #$(file-append openssh "/bin")
                                        #$(file-append curl "/bin")
                                        #$(file-append coreutils "/bin")
                                        #$(file-append bash-minimal "/bin")) ":"))
                         (format port "exec ~s \"$@\"~%" exe)))
                     (chmod bin #o555))
                   ;; The Guix interpreter keeps Hermes libraries in the Hermes output.
                   ;; Activate them in the bridge process so other Python tools stay isolated.
                   (substitute* "../bridge/omher_bridge.py"
                     (("    ensure_hermes_on_path\\(root\\)" original)
                      (string-append original "\n"
                                     "    if os.environ.get('OMHER_HERMES_ROOT') == str(root):\n"
                                     "        import site\n"
                                     "        site.addsitedir(str(root.parent / 'site-packages'))"))
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
    (inputs (cons* hermes openssh gtk+ openssl webkitgtk-for-gtk3 libappindicator dbus
                   (cargo-inputs 'omher #:module '(roquix packages rust-crates))))
    (home-page "https://omher.app/")
    (synopsis "Desktop workspace for Hermes Agent")
    (description "Omher brings Hermes conversations, tasks and agent terminals
together in a Tauri desktop application.")
    (license license:expat)))
