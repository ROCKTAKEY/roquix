(define-module (roquix packages slack)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages nss)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (roquix build-system container-launcher)
  #:use-module (nonguix build-system chromium-binary)
  #:use-module ((nonguix licenses) #:prefix license:))

(define-public slack
  (package
    (name "slack")
    (version "4.53.287")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://downloads.slack-edge.com/desktop-releases/linux/x64/"
                           version "/slack-desktop-" version "-amd64.deb"))
       (sha256
        (base32 "0sgr01liz0wlb0n92p5mdxmld282q3nmidn5mmz5n9s13qi7y1f2"))))
    (supported-systems '("x86_64-linux"))
    (build-system chromium-binary-build-system)
    (arguments
     (list
      ;; The Chromium launcher supplies runtime libraries through LD_LIBRARY_PATH.
      #:validate-runpath? #f
      #:patchelf-plan
      #~'(("usr/lib/slack/slack")
          ("usr/lib/slack/chrome_crashpad_handler")
          ("usr/lib/slack/chrome-sandbox"))
      #:install-plan
      #~'(("usr/lib/slack" "lib/slack")
          ("usr/share/applications" "share/applications")
          ("usr/share/pixmaps" "share/pixmaps"))
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'install 'adjust-desktop-entry
            (lambda _
              (substitute* "usr/share/applications/slack.desktop"
                (("/usr/bin/slack") (string-append #$output "/bin/slack"))
                (("/usr/share/pixmaps/slack.png") "slack"))))
          (add-after 'install 'link-launcher
            (lambda _
              (mkdir-p (string-append #$output "/bin"))
              (symlink "../lib/slack/slack"
                       (string-append #$output "/bin/slack")))))))
    (inputs (list eudev xdg-utils))
    (home-page "https://slack.com/")
    (synopsis "Desktop client for Slack")
    (description "Slack provides workspace channels, direct messages, calls,
and file sharing for teams.")
    (license (license:nonfree "https://slack.com/terms-of-service"))))

(define-public slack-container
  (package
    (inherit slack)
    (name "slack-container")
    (source #f)
    (build-system container-launcher-build-system)
    (arguments
     (list #:payload slack
           #:executable "slack"
           #:desktop-application "slack"
           #:desktop-network? #t
           #:desktop-audio? #t
           #:set-environment
           (list (cons "LD_LIBRARY_PATH" (file-append pulseaudio "/lib"))
                 (cons "FONTCONFIG_FILE"
                       (file-append fontconfig "/etc/fonts/fonts.conf")))))
    (inputs (list dbus fontconfig font-dejavu font-ipa nss-certs pulseaudio))
    (synopsis "Desktop client for Slack in a Guix container")))
