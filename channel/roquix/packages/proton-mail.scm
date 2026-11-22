(define-module (roquix packages proton-mail)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnome)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (nonguix build-system chromium-binary))

(define (proton-mail-file name)
  (local-file (canonicalize-path
               (search-path %load-path
                            (string-append "roquix/packages/proton-mail/" name)))))

;; The desktop build only uses a subset of the WebClients workspaces.  Keep
;; its public npm inputs locked independently of Proton's private registries.
(define* (fetch-build-dependencies uri algorithm hash
                                   #:optional name #:key system
                                   #:allow-other-keys)
  (gexp->derivation
   name
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "HOME" (getcwd))
         (setenv "PATH" (string-append #+node "/bin:" #+bash-minimal "/bin"))
         (setenv "npm_config_cafile"
                 #+(file-append nss-certs-for-test "/etc/ssl/certs/ca-certificates.crt"))
         (copy-file #+(proton-mail-file "package.json") "package.json")
         (copy-file #+(proton-mail-file "package-lock.json") "package-lock.json")
         (invoke "npm" "ci" "--legacy-peer-deps" "--ignore-scripts"
                 "--no-audit" "--no-fund")
         (call-with-output-file "/dev/null"
           (lambda (port) (copy-recursively "node_modules" #$output #:log port)))))
   #:system system #:hash-algo algorithm #:hash hash #:recursive? #t))

(define build-dependencies
  (origin
    (method fetch-build-dependencies)
    (uri "proton-mail-build-dependencies")
    (file-name "proton-mail-build-dependencies")
    (sha256 (base32 "0sy05fscwmfh28xyv14zvzav1sf0nzcrpkc2lc1rqmryqad5vwgw"))))

(define electron-archive
  (origin
    (method url-fetch)
    (uri "https://github.com/electron/electron/releases/download/v43.8.6/electron-v43.8.6-linux-x64.zip")
    (sha256 (base32 "00ilfqxb2sj0p2zjyabnr5ss7878v66f2gwan5ams73hw1w7cr8w"))))

(define-public proton-mail
  (package
    (name "proton-mail")
    (version "1.16.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://codeload.github.com/ProtonMail/WebClients/tar.gz/"
                           "a2e93b9af665f9dcef254d2f182dfd732f592325"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1hj46nvq924ymqr8fkh2862wal18rrlcp1y3div2bv4555ixr4jj"))))
    (build-system chromium-binary-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:wrapper-plan
      #~'(("Proton Mail" (("out" "/lib/proton-mail") ("nss" "/lib/nss")))
          "libEGL.so"
          "libGLESv2.so"
          "libffmpeg.so"
          "libvk_swiftshader.so"
          "libvulkan.so.1"
          "chrome_crashpad_handler"
          "chrome-sandbox")
      #:install-plan
      #~'(("." "lib/proton-mail/"))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'binary-unpack)
          (add-before 'patchelf 'build-desktop
            (lambda _
              (call-with-output-file "/dev/null"
                (lambda (port)
                  (copy-recursively #+build-dependencies "node_modules" #:log port)))
              (mkdir-p "node_modules/@proton")
              (for-each (lambda (name)
                          (symlink (string-append "../../packages/" name)
                                   (string-append "node_modules/@proton/" name)))
                        '("colors" "shared" "utils" "metrics"))
              (mkdir "electron-cache")
              (symlink #+electron-archive
                       "electron-cache/electron-v43.8.6-linux-x64.zip")
              (setenv "ELECTRON_ZIP_DIR" (canonicalize-path "electron-cache"))
              (setenv "HOME" (getcwd))
              (setenv "NODE_INSTALLER" "npm")
              (setenv "TS_NODE_TRANSPILE_ONLY" "true")
              (setenv "TS_NODE_COMPILER_OPTIONS"
                      "{\"moduleResolution\":\"node\",\"ignoreDeprecations\":\"6.0\"}")
              (setenv "BUILD_TAG" #$(string-append "ida-" version))
              (chdir "applications/inbox-desktop")
              ;; Forge normally downloads Electron.  The Guix input supplies
              ;; the matching archive, and ts-loader compiles the TypeScript
              ;; without loading type-checking fixtures from other workspaces.
              (substitute* "forge.config.ts"
                (("packagerConfig: [{]")
                 "packagerConfig: { electronZipDir: process.env.ELECTRON_ZIP_DIR,")
                (("config: rendererConfig,")
                 "config: { ...rendererConfig, plugins: [] },"))
              (substitute* "src/utils/protocol/default_mailto_linux.ts"
                (("/usr/share/applications/proton-mail.desktop")
                 (string-append #$output "/share/applications/proton-mail.desktop")))
              (invoke "node" "../../node_modules/.bin/electron-forge" "package")
              (let ((doc (string-append #$output "/share/doc/proton-mail-" #$version)))
                (mkdir-p doc)
                (copy-file "../../LICENSE" (string-append doc "/COPYING")))
              (chdir "out/Proton Mail-linux-x64")))
          (add-after 'install 'install-launcher
            (lambda _
              (let ((share (string-append #$output "/share"))
                    (desktop #+(proton-mail-file "proton-mail.desktop")))
                (mkdir-p (string-append share "/pixmaps"))
                (copy-file "resources/icon.png"
                           (string-append share "/pixmaps/proton-mail.png"))
                (invoke "desktop-file-validate" desktop)
                (mkdir-p (string-append share "/applications"))
                (copy-file desktop
                           (string-append share "/applications/proton-mail.desktop")))
              (mkdir-p (string-append #$output "/bin"))
              (let ((launcher (string-append #$output "/bin/proton-mail")))
                (call-with-output-file launcher
                  (lambda (port)
                    (format port
                            (string-append
                             "#!~a~%"
                             "export XDG_DATA_DIRS=\"${XDG_DATA_DIRS:-"
                             "/usr/local/share:/usr/share}:~a/share\"~%"
                             "exec \"~a/lib/proton-mail/Proton Mail\" \"$@\"~%")
                            #$(file-append bash-minimal "/bin/sh")
                            #$gsettings-desktop-schemas #$output)))
                (chmod launcher #o755)))))))
    (native-inputs (list node desktop-file-utils))
    (inputs (list gsettings-desktop-schemas))
    (home-page "https://proton.me/mail")
    (synopsis "Desktop client for Proton Mail and Proton Calendar")
    (description "This package provides Proton's official desktop application
for accessing encrypted email and managing calendars.")
    (license license:gpl3)))
