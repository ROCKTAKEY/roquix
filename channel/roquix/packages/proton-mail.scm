(define-module (roquix packages proton-mail)
  #:use-module (gnu packages base)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages guile-xyz)
  #:use-module (roquix packages pnpm)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages debian)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages web)
  #:use-module (roquix packages proton-mail sources)
  #:use-module (gnu packages node)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gnome)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix build-system gnu)
  #:use-module (nongnu packages electron))

(define proton-mail-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/ProtonMail/WebClients/tar.gz/"
                        "a2e93b9af665f9dcef254d2f182dfd732f592325"))
    (file-name "proton-mail-1.16.1.tar.gz")
    (sha256
     (base32 "1hj46nvq924ymqr8fkh2862wal18rrlcp1y3div2bv4555ixr4jj"))))

(define* (fetch-build-dependencies source algorithm hash
                                   #:optional name #:key system
                                   #:allow-other-keys)
  (gexp->derivation
   name
   (with-extensions (list guile-json-4 guile-yamlpp)
     (with-imported-modules '((guix build utils) (roquix build proton-mail-lock))
      #~(begin
          (use-modules (guix build utils) (roquix build proton-mail-lock))
          (setenv "HOME" (getcwd))
          (setenv "PATH" (string-append #+pnpm "/bin:" #+node "/bin:"
                                        #+gzip "/bin:" #+bash-minimal "/bin"))
          (setenv "SSL_CERT_FILE"
                  #+(file-append nss-certs-for-test "/etc/ssl/certs/ca-certificates.crt"))
          (invoke #+(file-append tar "/bin/tar") "xf" #+source
                  "--wildcards" "--no-wildcards-match-slash"
                  "--strip-components=1" "*/pnpm-lock.yaml")
          (write-desktop-lock "pnpm-lock.yaml")
          (invoke "pnpm" "install" "--ignore-scripts" "--frozen-lockfile")
          ;; pnpm records the temporary store path and install time here.
          (for-each delete-file '("node_modules/.modules.yaml"
                                  "node_modules/.pnpm-workspace-state-v1.json"))
          (call-with-output-file "/dev/null"
            (lambda (port) (copy-recursively "node_modules" #$output #:log port))))))
   #:system system #:hash-algo algorithm #:hash hash #:recursive? #t))

(define build-dependencies
  (origin
    (method fetch-build-dependencies)
    (uri proton-mail-source)
    (file-name "proton-mail-build-dependencies")
    (sha256 (base32 "0i5bagg3k1clb03jy8winw2h78wnlr02crcyas1j6dgcgm8b92gg"))))

(define electron-for-proton-mail
  (package
    (inherit electron-41)
    (version "43.8.6")
    (source
     (origin
       (method url-fetch/zipbomb)
       (uri (string-append "https://github.com/electron/electron/releases/download/v"
                           version "/electron-v" version "-linux-x64.zip"))
       (sha256 (base32 "00ilfqxb2sj0p2zjyabnr5ss7878v66f2gwan5ams73hw1w7cr8w"))))))

(define-public proton-mail
  (package
    (name "proton-mail")
    (version "1.16.1")
    (source
     proton-mail-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:imported-modules (cons '(roquix build proton-mail)
                               %default-gnu-imported-modules)
      ;; All ELF objects come from Electron, whose launcher sets LD_LIBRARY_PATH.
      #:validate-runpath? #f
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (replace 'build
            (lambda _
              (use-modules (roquix build proton-mail))
              (stage-desktop-sources
               (list #$@(map (lambda (spec) #~(cons #+(car spec) '#$(cdr spec)))
                             desktop-sources))
               (string-append #$output "/share/doc/proton-mail-" #$version "/licenses"))
              (substitute* "applications/inbox-desktop/src/utils/protocol/default_mailto_linux.ts"
                (("/usr/share/applications/proton-mail.desktop")
                 (string-append #$output "/share/applications/proton-mail.desktop")))
              (mkdir "electron-cache")
              (let ((archive (string-append (canonicalize-path "electron-cache")
                                            "/electron-v" #$(package-version electron-for-proton-mail)
                                            "-linux-x64.zip")))
                (copy-recursively #$(file-append electron-for-proton-mail "/share/electron")
                                  "electron-template")
                (copy-recursively
                 #$(file-append electron-for-proton-mail "/share/doc/electron-"
                                (package-version electron-for-proton-mail))
                 "electron-template")
                (invoke "chmod" "-R" "u+w" "electron-template")
                (with-directory-excursion "electron-template"
                  (invoke "zip" "-q0r" archive ".")))
              (setenv "ELECTRON_ZIP_DIR" (canonicalize-path "electron-cache"))
              (setenv "HOME" (getcwd))
              (setenv "NODE_INSTALLER" "npm")
              (setenv "BUILD_TAG" #$(string-append "ida-" version))
              (setenv "TS_NODE_TRANSPILE_ONLY" "true")
              (setenv "TS_NODE_COMPILER_OPTIONS"
                      "{\"moduleResolution\":\"node\",\"ignoreDeprecations\":\"6.0\"}")
              (build-desktop #+build-dependencies
                             (string-append #$output "/share/applications"))
              (let ((doc (string-append #$output "/share/doc/proton-mail-" #$version)))
                (mkdir-p doc)
                (copy-file "LICENSE" (string-append doc "/COPYING")))
              (chdir "applications/inbox-desktop/out/Proton Mail-linux-x64")))
          (replace 'install
            (lambda _
              (define runtime #$(file-append electron-for-proton-mail "/share/electron"))
              (define lib (string-append #$output "/lib/proton-mail"))
              (define launcher (string-append #$output "/bin/proton-mail"))
              (mkdir-p lib)
              ;; Forge applies Proton's fuse settings to the executable. Electron
              ;; looks for the application's resources relative to that executable.
              (for-each (lambda (name)
                          (let ((dest (string-append lib "/" name)))
                            (cond ((string=? name "Proton Mail") (copy-file name dest))
                                  ((string=? name "resources") (copy-recursively name dest))
                                  ((file-exists? (string-append runtime "/" name))
                                   (symlink (string-append runtime "/" name) dest))
                                  (else
                                   (symlink (string-append #$electron-for-proton-mail
                                             "/share/doc/electron-" #$(package-version electron-for-proton-mail)
                                             "/" name) dest)))))
                        ((@ (ice-9 ftw) scandir) "." (lambda (n) (not (member n '("." ".."))))))
              (mkdir-p (dirname launcher))
              (copy-file #$(file-append electron-for-proton-mail "/bin/electron") launcher)
              (chmod launcher #o755)
              (substitute* launcher
                (((string-append runtime "/electron")) (string-append lib "/Proton Mail"))
                (("^exec ") (string-append "export XDG_DATA_DIRS=\"${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:"
                                           #$gsettings-desktop-schemas "/share\"\nexec ")))
              (let ((desktop (string-append #$output "/share/applications/proton-mail.desktop")))
                (substitute* desktop (("^Exec=proton-mail ") (string-append "Exec=" launcher " ")))
                (invoke "desktop-file-validate" desktop))
              (mkdir-p (string-append #$output "/share/pixmaps"))
              (copy-file "resources/icon.png" (string-append #$output "/share/pixmaps/proton-mail.png")))))))
    (native-inputs (list node esbuild dpkg fakeroot zip desktop-file-utils))
    (inputs (list electron-for-proton-mail gsettings-desktop-schemas))
    (home-page "https://proton.me/mail")
    (synopsis "Desktop client for Proton Mail and Proton Calendar")
    (description "This package provides Proton's official desktop application
for accessing encrypted email and managing calendars.")
    (license license:gpl3)))
