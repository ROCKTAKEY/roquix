(define-module (roquix packages mattermost)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages base)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages version-control)
  #:use-module (nongnu packages electron))

(define %mattermost-version "6.3.1")

(define %mattermost-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/mattermost/desktop/tar.gz/refs/tags/v"
                        %mattermost-version))
    (file-name (string-append "mattermost-desktop-" %mattermost-version ".tar.gz"))
    (sha256 (base32 "0m614w1b2p6j8xfdjv8kins5qqq5x1l07r5v3p5780znl6q135kp"))))

(define electron-for-mattermost
  (package
    (inherit electron-41)
    (version "43.0.0")
    (source
     (origin
       (method url-fetch/zipbomb)
       (uri (string-append "https://github.com/electron/electron/releases/download/v"
                           version "/electron-v" version "-linux-x64.zip"))
       (sha256 (base32 "074nmymycqkk6ady1wm8myg70h4hgx7gl60kw0lbg1zd2wp5ddak"))))))

;; npm resolves the lockfile with network access only in this fixed-output
;; derivation.  Lifecycle scripts and native compilation belong to the offline
;; application build, where their outputs depend on the Guix toolchain.
(define* (mattermost-dependencies-fetch source hash-algo hash
                                        #:optional name
                                        #:key (system (%current-system))
                                        #:allow-other-keys)
  (gexp->derivation
   (or name "mattermost-dependencies")
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" (string-append #+node "/bin:" #+git-minimal "/bin:"
                                       #+tar "/bin:" #+gzip "/bin:"
                                       #+bash-minimal "/bin"))
         (setenv "HOME" (string-append (getcwd) "/home"))
         (setenv "SSL_CERT_FILE"
                 #+(file-append nss-certs-for-test "/etc/ssl/certs/ca-certificates.crt"))
         (setenv "npm_config_cafile" (getenv "SSL_CERT_FILE"))
         (mkdir-p (getenv "HOME"))
         (mkdir "source")
         (invoke "tar" "xf" #+source "--strip-components=1" "-C" "source")
         (with-directory-excursion "source"
           (invoke "npm" "ci" "--ignore-scripts" "--no-audit" "--no-fund")
           ;; Native prebuilds are not inputs to the source build of Koffi.
           (for-each delete-file (find-files "node_modules" "\\.(node|dll|exe|so|dylib)$"))
           (delete-file "node_modules/.package-lock.json")
           (call-with-output-file "/dev/null"
             (lambda (port)
               (copy-recursively "node_modules" #$output #:log port))))))
   #:system system
   #:hash-algo hash-algo #:hash hash #:recursive? #t
   #:local-build? #t
   #:leaked-env-vars '("http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY"
                       "no_proxy" "NO_PROXY")))

(define %mattermost-dependencies
  (origin
    (method mattermost-dependencies-fetch)
    (uri %mattermost-source)
    (file-name (string-append "mattermost-dependencies-" %mattermost-version))
    (sha256 (base32 "1s6lcdka8hcyk0n3lxiclfmbmbqq51wid7ci1qsfk6pjjx5pf1a1"))))

(define-public mattermost-desktop
  (package
    (name "mattermost-desktop")
    (version %mattermost-version)
    (source %mattermost-source)
    (build-system gnu-build-system)
    (arguments
     (list
      #:modules '((guix build gnu-build-system) (guix build utils) (ice-9 ftw))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (replace 'validate-runpath
            (lambda* (#:key outputs validate-runpath? #:allow-other-keys)
              ;; Nonguix resolves Electron's libraries through its launcher.
              ;; Check the native code compiled by this package independently.
              ((assoc-ref %standard-phases 'validate-runpath)
               #:outputs outputs #:validate-runpath? validate-runpath?
               #:elf-directories
               '("lib/mattermost-desktop/resources/app/node_modules/koffi/build"))))
          (add-after 'unpack 'prepare-dependencies
            (lambda* (#:key inputs #:allow-other-keys)
              (setenv "HOME" (string-append (getcwd) "/home"))
              (mkdir-p (getenv "HOME"))
              (setenv "npm_config_offline" "true")
              (setenv "npm_config_script_shell" (which "sh"))
              (setenv "ELECTRON_SKIP_BINARY_DOWNLOAD" "1")
              (setenv "ELECTRON_OVERRIDE_DIST_PATH"
                      (string-append (assoc-ref inputs "electron") "/bin"))
              (call-with-output-file "/dev/null"
                (lambda (port)
                  (copy-recursively (assoc-ref inputs "node-modules")
                                    "node_modules" #:log port)))
              (for-each make-file-writable (find-files "node_modules"))
              (setenv "PATH" (string-append (getcwd) "/node_modules/.bin:"
                                            (getenv "PATH")))
              (invoke "node" "node_modules/patch-package/index.js")
              ;; Release archives have no Git metadata.  Upstream release builds
              ;; suppress the development revision in the displayed version.
              (substitute* "webpack.config.base.js"
                (("const VERSION = .*;") "const VERSION = '';"))
              (setenv "GITHUB_WORKFLOW" "release")))
          (replace 'build
            (lambda _
              (with-directory-excursion "node_modules/koffi"
                (invoke "node" "cnoke.cjs" "-P" "." "-D" "src/koffi" "--release"))
              (invoke "npm" "run" "build-prod")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "npm" "run" "check-types")
                (invoke "node" "node_modules/jest/bin/jest.js" "--runInBand"))))
          (replace 'install
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (appdir (string-append out "/lib/mattermost-desktop"))
                     (application (string-append appdir "/resources/app"))
                     (runtime (string-append (assoc-ref inputs "electron")
                                             "/share/electron")))
                (mkdir-p appdir)
                ;; A private resources directory keeps Electron's app.isPackaged
                ;; and process.resourcesPath consistent with upstream releases.
                (for-each
                 (lambda (file)
                   (unless (member file '("." ".." "resources"))
                     (copy-recursively (string-append runtime "/" file)
                                       (string-append appdir "/" file))))
                 (scandir runtime))
                (rename-file (string-append appdir "/electron")
                             (string-append appdir "/mattermost-desktop"))
                (copy-recursively "dist" application)
                (copy-file "package.json" (string-append application "/package.json"))
                (substitute* (string-append application "/package.json")
                  (("dist/index.js") "index.js"))
                (copy-recursively "node_modules/koffi"
                                  (string-append application "/node_modules/koffi"))
                (for-each (lambda (file) (install-file file appdir))
                          '("LICENSE.txt" "NOTICE.txt"))
                (mkdir-p (string-append out "/bin"))
                (copy-file (string-append (assoc-ref inputs "electron") "/bin/electron")
                           (string-append out "/bin/mattermost-desktop"))
                (substitute* (string-append out "/bin/mattermost-desktop")
                  (((string-append runtime "/electron"))
                   (string-append appdir "/mattermost-desktop")))
                (install-file "src/assets/linux/app_icon.png"
                              (string-append out "/share/icons/hicolor/512x512/apps"))
                (rename-file (string-append out "/share/icons/hicolor/512x512/apps/app_icon.png")
                             (string-append out "/share/icons/hicolor/512x512/apps/mattermost-desktop.png"))
                (mkdir-p (string-append out "/share/applications"))
                (call-with-output-file (string-append out "/share/applications/mattermost-desktop.desktop")
                  (lambda (port)
                    (format port "[Desktop Entry]~%Type=Application~%Name=Mattermost~%Exec=~a/bin/mattermost-desktop %U~%Icon=mattermost-desktop~%Terminal=false~%Categories=Network;InstantMessaging;~%MimeType=x-scheme-handler/mattermost;~%StartupWMClass=Mattermost~%" out)))
                (wrap-program (string-append out "/bin/mattermost-desktop")
                  `("PATH" prefix (,(string-append (assoc-ref inputs "xdg-utils") "/bin")
                                    ,(string-append (assoc-ref inputs "desktop-file-utils") "/bin")))
                  `("LD_LIBRARY_PATH" prefix
                    (,(string-append (assoc-ref inputs "libnotify") "/lib")
                     ,(string-append (assoc-ref inputs "pulseaudio") "/lib")))))))
          (add-after 'install 'check-installed-koffi
            (lambda* (#:key outputs tests? #:allow-other-keys)
              (when tests?
                (invoke "node" "-e"
                        (string-append
                         "const k = require('" (assoc-ref outputs "out")
                         "/lib/mattermost-desktop/resources/app/node_modules/koffi');"
                         "if (k.sizeof('int') !== 4) process.exit(1);"))))))))
    (native-inputs
     (list (list "node" node)
           (list "cmake-minimal" cmake-minimal)
           (list "node-modules" %mattermost-dependencies)))
    (inputs (list bash-minimal electron-for-mattermost libnotify pulseaudio xdg-utils desktop-file-utils))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/mattermost/desktop")
    (synopsis "Desktop client for Mattermost")
    (description "Mattermost Desktop connects to Mattermost workspaces with
notifications, multiple servers and desktop integration.  The application and
its Koffi native module are built from source and use the Nonguix Electron runtime.")
    (license license:asl2.0)))
