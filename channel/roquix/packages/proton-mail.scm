(define-module (roquix packages proton-mail)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (nonguix build-system chromium-binary))

(define-public proton-mail
  (package
    (name "proton-mail")
    (version "1.16.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://proton.me/download/mail/linux/" version
                           "/ProtonMail-desktop-beta.deb"))
       (file-name (string-append name "-" version ".deb"))
       (sha256
        (base32 "17n174966zm73cvhq3cfd3wcxdad9ad2h23v8pq889lcsgcwrkmc"))))
    (build-system chromium-binary-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:wrapper-plan
      #~'(("usr/lib/proton-mail/Proton Mail Beta" (("out" "/lib/proton-mail") ("nss" "/lib/nss")))
          "usr/lib/proton-mail/libEGL.so"
          "usr/lib/proton-mail/libGLESv2.so"
          "usr/lib/proton-mail/libffmpeg.so"
          "usr/lib/proton-mail/libvk_swiftshader.so"
          "usr/lib/proton-mail/libvulkan.so.1"
          "usr/lib/proton-mail/chrome_crashpad_handler"
          "usr/lib/proton-mail/chrome-sandbox")
      #:install-plan
      #~'(("usr/lib/proton-mail/" "lib/proton-mail")
          ("usr/share/applications/" "share/applications")
          ("usr/share/pixmaps/" "share/pixmaps")
          ("usr/share/doc/" "share/doc"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'install-launcher
            (lambda _
              (mkdir-p (string-append #$output "/bin"))
              (symlink (string-append #$output "/lib/proton-mail/Proton Mail Beta")
                       (string-append #$output "/bin/proton-mail")))))))
    (home-page "https://proton.me/mail")
    (synopsis "Desktop client for Proton Mail and Proton Calendar")
    (description "This package provides Proton's official desktop application
for accessing encrypted email and managing calendars.")
    (license license:gpl3)))
