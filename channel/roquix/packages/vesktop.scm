(define-module (roquix packages vesktop)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages logging)
  #:use-module (roquix packages vesktop venmic)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages python)
  #:use-module (gnu packages xorg)
  #:use-module (nongnu packages electron)
  #:use-module ((roquix packages pnpm) #:prefix roquix:))

(define vesktop-version "1.7.0")

(define vesktop-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/Vencord/Vesktop/tar.gz/refs/tags/v"
                        vesktop-version))
    (file-name (string-append "vesktop-" vesktop-version ".tar.gz"))
    (sha256 (base32 "1974aqcgvslcw6n06lmsjfy8l4p33iz8z1zfbray99ikh6ssvzpk"))))

;; Only acquisition runs with network access. The tar contains dependency
;; files and workspace links, without install scripts or build-machine paths.
(define* (fetch-vesktop-modules source algorithm hash #:optional name
                                #:key (system (%current-system)) #:allow-other-keys)
  (gexp->derivation
   name
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" (string-append #+node "/bin:" #+tar "/bin:" #+gzip
                                       "/bin:" #+bash-minimal "/bin"))
         (setenv "SSL_CERT_FILE" #+(file-append nss-certs "/etc/ssl/certs/ca-certificates.crt"))
         (setenv "HOME" (getcwd))
         (setenv "CI" "1")
         (mkdir "source")
         (chdir "source")
         (invoke "tar" "xf" #+source "--strip-components=1")
         (invoke #+(file-append roquix:pnpm "/bin/pnpm")
                 "install" "--frozen-lockfile" "--ignore-scripts"
                 "--config.manage-package-manager-versions=false"
                 "--store-dir" (string-append (getenv "HOME") "/store"))
         (invoke "tar" "--sort=name" "--mtime=@0" "--owner=0" "--group=0"
                 "--mode=u+rwX,go+rX,go-w" "--hard-dereference"
                 "--exclude=.bin" "--exclude=.modules.yaml"
                 "--exclude=.pnpm-workspace-state-v1.json"
                 "-cf" #$output "node_modules" "packages/libvesktop/node_modules")))
   #:system system #:hash-algo algorithm #:hash hash #:local-build? #t))

(define vesktop-modules
  (origin
    (method fetch-vesktop-modules)
    (uri vesktop-source)
    (file-name (string-append "vesktop-modules-" vesktop-version ".tar"))
    (sha256 (base32 "1yx95dpbdks2nzysf11hcngkz0xdbvpj6ccrdb57hd61msvpgdln"))))

;; The npm archive ships only the loader and prebuilt addons.
(define game-detection-source
  (origin
    (method url-fetch)
    (uri "https://codeload.github.com/Vencord/GameDetection/tar.gz/refs/tags/v0.1.0-alpha.1")
    (file-name "game-detection-0.1.0-alpha.1.tar.gz")
    (sha256 (base32 "0fwnqqji0i2rfr4aa22rq7rd0xryndv6gdbcn5hckxh25v3cjkj0"))))

(define vesktop-electron
  (package
    (inherit electron-41)
    (version "45.4.1")
    (source
     (origin
       (method url-fetch/zipbomb)
       (uri (string-append "https://github.com/electron/electron/releases/download/v"
                           version "/electron-v" version "-linux-x64.zip"))
       (sha256 (base32 "0xdqc2jw23wfyds995zpkcyszibx5g6wb80f6m2f7mw7l33pgl71"))))))

(define-public vesktop
  (package
    (name "vesktop")
    (version vesktop-version)
    (source vesktop-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (invoke "tar" "xf" #+vesktop-modules)
              (setenv "HOME" (getcwd))
              ;; Desktop autostart must restore the same library environment
              ;; as a launch from the application menu.
              (substitute* "src/main/autoStart.ts"
                ((" \\|\\| process.execPath;")
                 (string-append " || " (object->string
                                        (string-append #$output "/bin/vesktop")) ";")))))
          (add-before 'build 'build-audio-addon #$build-venmic)
          (replace 'build
            (lambda _
              (define (build-addon directory)
                (invoke "node" "packages/libvesktop/node_modules/node-gyp/bin/node-gyp.js"
                        "rebuild" (string-append "--directory=" directory)
                        (string-append "--nodedir=" #+node)))
              (setenv "CC" "gcc")
              (mkdir "game-detection")
              (invoke "tar" "xf" #+game-detection-source
                      "--strip-components=1" "-C" "game-detection")
              (build-addon "game-detection")
              (copy-file "game-detection/build/Release/rpc_native.node"
                         "node_modules/@vencord/game-detection/prebuilds/linux-x64/rpc_native.node")
              (build-addon "packages/libvesktop")
              (build-addon "node_modules/uiohook-napi")
              (copy-file "node_modules/uiohook-napi/build/Release/uiohook_napi.node"
                         "node_modules/uiohook-napi/prebuilds/linux-x64/uiohook-napi.node")
              (invoke "node" "node_modules/tsx/dist/cli.mjs" "scripts/build/build.mts")
              (for-each delete-file (find-files "static/dist" "-arm64\\.node$"))))
          (replace 'validate-runpath
            (lambda* (#:key outputs #:allow-other-keys)
              ;; Nonguix supplies Electron's library paths in its launcher.
              ((assoc-ref %standard-phases 'validate-runpath)
               #:outputs outputs
               #:elf-directories '("lib/vesktop/resources/app/static/dist"))))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node" "node_modules/typescript/bin/tsc" "--noEmit")
                ;; libuiohook queries the X display when its addon loads.
                (invoke "xvfb-run" "-a" "node" "-e"
                        "for (const name of ['libvesktop','venmic','game-detection','uiohook-napi']) require('./static/dist/'+name+'-x64.node')"))))
          (replace 'install
            (lambda _
              (define runtime #$(file-append vesktop-electron "/share/electron"))
              (define root (string-append #$output "/lib/vesktop"))
              (define app (string-append root "/resources/app"))
              (define launcher (string-append #$output "/bin/vesktop"))
              (mkdir-p app)
              ;; Electron locates packaged apps relative to its executable.
              (for-each (lambda (name)
                          (unless (member name '("." ".." "resources" "electron"))
                            (symlink (string-append runtime "/" name)
                                     (string-append root "/" name))))
                        ((@ (ice-9 ftw) scandir) runtime))
              (copy-file (string-append runtime "/electron")
                         (string-append root "/vesktop"))
              (for-each (lambda (name)
                          (copy-recursively name (string-append app "/" name)))
                        '("dist/js" "static" "package.json" "LICENSE"))
              (mkdir-p (dirname launcher))
              (copy-file #$(file-append vesktop-electron "/bin/electron") launcher)
              (substitute* launcher
                (((string-append runtime "/electron")) (string-append root "/vesktop")))
              (wrap-program launcher
                `("FONTCONFIG_FILE" = (,#$(file-append fontconfig "/etc/fonts/fonts.conf")))
                `("XDG_DATA_DIRS" ":" suffix
                  (,#$(file-append gsettings-desktop-schemas "/share"))))
              (let ((icons (string-append #$output "/share/icons/hicolor/scalable/apps"))
                    (desktop (string-append #$output "/share/applications/vesktop.desktop")))
                (mkdir-p icons)
                (copy-file "build/icon.svg" (string-append icons "/vesktop.svg"))
                (mkdir-p (dirname desktop))
                (call-with-output-file desktop
                  (lambda (port)
                    (format port "[Desktop Entry]~%Type=Application~%Name=Vesktop~%Exec=~a %U~%Icon=vesktop~%Categories=Network;InstantMessaging;Chat;~%MimeType=x-scheme-handler/discord;~%StartupWMClass=vesktop~%" launcher)))))))))
    (native-inputs
     (list cmake-minimal gcc-toolchain-15 libuv node pkg-config
           python-minimal xvfb-run-for-tests))
    (inputs (list bash-minimal glib spdlog pipewire pulseaudio libx11 libxrandr libxtst libxt))
    (home-page "https://github.com/Vencord/Vesktop")
    (synopsis "Discord desktop client with Vencord integration")
    (description
     "Vesktop provides a desktop interface to Discord with Vencord support
and screen sharing with audio on Linux.")
    (license license:gpl3+)))
