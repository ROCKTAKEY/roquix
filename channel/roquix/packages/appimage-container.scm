(define-module (roquix packages appimage-container)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages base)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages linux)
  #:use-module (roquix build-system appimage)
  #:use-module (roquix build-system container-launcher)
  #:export (appimage-container-package))

(define (appimage-container-package payload)
  "Wrap an AppImage PAYLOAD with a private home and a single Wayland endpoint."
  (unless (and (package? payload)
               (eq? (package-build-system payload) appimage-build-system))
    (error "desktop AppImage container payload must be an AppImage package"
           payload))
  (package
    (inherit payload)
    (name (string-append (package-name payload) "-container"))
    (source
     #f)
    (build-system container-launcher-build-system)
    (arguments
     (list
      #:payload payload
      #:executable (package-name payload)
      ;; Electron's bundled Fontconfig assumes /etc/fonts instead of Guix's
      ;; store configuration, even when fc-match finds its own config.
      #:set-environment (list (cons "FONTCONFIG_FILE"
                                    (file-append fontconfig
                                                 "/etc/fonts/fonts.conf")))
      #:desktop-application (package-name payload)))

    ;; AppRun probes the Electron sandbox with "unshare -Ur true", so both
    ;; commands must be available in the pure container profile.
    (inputs (list coreutils-minimal
                  util-linux
                  dbus
                  fontconfig
                  font-dejavu
                  font-ipa))
    (native-inputs '())
    (propagated-inputs '())))
