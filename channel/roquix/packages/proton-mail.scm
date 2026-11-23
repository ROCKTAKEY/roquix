(define-module (roquix packages proton-mail)
  #:use-module (gnu packages base)
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
  #:use-module (nonguix build-system chromium-binary))

(define (proton-mail-file name)
  (local-file (canonicalize-path
               (search-path %load-path
                            (string-append "roquix/packages/proton-mail/" name)))))

(define proton-mail-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/ProtonMail/WebClients/tar.gz/"
                        "a2e93b9af665f9dcef254d2f182dfd732f592325"))
    (file-name "proton-mail-1.16.1.tar.gz")
    (sha256
     (base32 "1hj46nvq924ymqr8fkh2862wal18rrlcp1y3div2bv4555ixr4jj"))))

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
     proton-mail-source)
    (build-system chromium-binary-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:imported-modules (cons '(roquix build proton-mail)
                               %chromium-binary-build-system-modules)
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
              (use-modules (roquix build proton-mail))
              (stage-desktop-sources
               (list #$@(map (lambda (spec) #~(cons #+(car spec) '#$(cdr spec)))
                             desktop-sources))
               (string-append #$output "/share/doc/proton-mail-" #$version "/licenses"))
              (substitute* "applications/inbox-desktop/src/utils/protocol/default_mailto_linux.ts"
                (("/usr/share/applications/proton-mail.desktop")
                 (string-append #$output "/share/applications/proton-mail.desktop")))
              (invoke "unzip" "-q" #+electron-archive "-d" "applications/inbox-desktop/out")
              (build-desktop #+(proton-mail-file "package-linux.cjs")
                             (string-append #$output "/share/applications"))
              (let ((doc (string-append #$output "/share/doc/proton-mail-" #$version)))
                (mkdir-p doc)
                (copy-file "LICENSE" (string-append doc "/COPYING")))
              (chdir "applications/inbox-desktop/out")))
          (add-after 'install 'install-launcher
            (lambda _
              (let ((share (string-append #$output "/share"))
                    (desktop (string-append #$output
                                            "/share/applications/proton-mail.desktop")))
                (mkdir-p (string-append share "/pixmaps"))
                (copy-file "resources/icon.png"
                           (string-append share "/pixmaps/proton-mail.png"))
                (invoke "desktop-file-validate" desktop))
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
    (native-inputs (list node esbuild unzip desktop-file-utils))
    (inputs (list gsettings-desktop-schemas))
    (home-page "https://proton.me/mail")
    (synopsis "Desktop client for Proton Mail and Proton Calendar")
    (description "This package provides Proton's official desktop application
for accessing encrypted email and managing calendars.")
    (license license:gpl3)))
