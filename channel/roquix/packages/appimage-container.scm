(define-module (roquix packages appimage-container)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages base)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages linux)
  #:use-module (roquix build-system appimage)
  #:use-module (roquix build-system container-launcher)
  #:export (appimage-container-package))

(define (appimage-container-package payload)
  "Wrap an AppImage PAYLOAD with access to the user's desktop session and files."
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
      #:set-environment
      (list (cons "FONTCONFIG_FILE"
                  (file-append fontconfig "/etc/fonts/fonts.conf")))
      #:preserve-environment '("HOME" "DISPLAY"
                               "WAYLAND_DISPLAY"
                               "XAUTHORITY"
                               "XDG_RUNTIME_DIR"
                               "DBUS_SESSION_BUS_ADDRESS"
                               "PULSE_SERVER"
                               "XDG_CONFIG_HOME"
                               "XDG_DATA_HOME"
                               "XDG_CACHE_HOME")
      ;; Sharing HOME preserves application state and lets Logseq open graphs.
      ;; Explicit XDG paths can live outside HOME, while the runtime directory
      ;; carries the Wayland, session D-Bus and PulseAudio/PipeWire sockets.
      #:share '((environment "HOME")
                (environment "XDG_CONFIG_HOME")
                (environment "XDG_DATA_HOME")
                (environment "XDG_CACHE_HOME")
                (environment "XDG_RUNTIME_DIR"))
      #:expose '((environment "XAUTHORITY"))
      ;; Host networking also makes Linux's abstract X11 sockets accessible.
      #:network? #t
      #:no-cwd? #f))
    ;; AppRun probes the Electron sandbox with "unshare -Ur true", so both
    ;; commands must be available in the pure container profile.
    (inputs (list coreutils-minimal util-linux fontconfig font-dejavu font-ipa))
    (native-inputs '())
    (propagated-inputs '())))
