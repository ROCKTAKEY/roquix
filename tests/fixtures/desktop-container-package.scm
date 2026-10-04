(use-modules (guix build-system trivial)
             (guix gexp)
             ((guix licenses) #:prefix license:)
             (guix packages)
             (gnu packages base)
             (gnu packages bash)
             (gnu packages glib)
             (roquix build-system container-launcher))

(define payload
  (package
    (name "desktop-isolation-probe")
    (version "1")
    (source #f)
    (build-system trivial-build-system)
    (arguments
     (list #:builder
           #~(begin
               (mkdir #$output)
               (mkdir (string-append #$output "/bin"))
               (call-with-output-file
                   (string-append #$output "/bin/desktop-isolation-probe")
                 (lambda (port)
                   (display (string-append "#!" #$(file-append bash-minimal "/bin/bash") "\n") port)
                   (display "set -eu\ncommand -v bash >/dev/null\n" port)
                   (display "for argument in \"$@\"; do case \"$argument\" in --host-port=*) if timeout 2 bash -c 'exec 3<>/dev/tcp/127.0.0.1/$1' bash \"${argument#--host-port=}\" 2>/dev/null; then echo 'host loopback is reachable'; exit 1; fi ;; --*) ;; *) [ ! -e \"$argument\" ] || { echo \"host path is visible: $argument\"; exit 1; }; for fd in /proc/self/fd/*; do [ \"$(readlink \"$fd\" || true)\" != \"$argument\" ] || { echo 'host file descriptor is inherited'; exit 1; }; done ;; esac; done\n" port)
                   (display "[ -z \"${DISPLAY-}${XAUTHORITY-}${PULSE_SERVER-}${XDG_CONFIG_HOME-}${XDG_DATA_HOME-}${XDG_CACHE_HOME-}${SSH_AUTH_SOCK-}\" ]\n" port)
                   (display "[ -S \"$XDG_RUNTIME_DIR/wayland-0\" ]\n" port)
                   (display "[ ! -e \"$XDG_RUNTIME_DIR/host-service\" ]\n" port)
                   (display "[ ! -e /dev/dri ] && [ ! -e /dev/snd ]\n" port)
                   (display "if dbus-send --session --print-reply --dest=org.freedesktop.secrets /org/freedesktop/secrets org.freedesktop.DBus.Peer.Ping; then echo 'host Secret Service is reachable'; exit 1; fi\n" port)
                   (display "printf 'state=private\\n' >\"$HOME/state-token\"\n" port)
                   (display "printf 'isolation=ok\\n'\n" port)))
               (chmod (string-append #$output "/bin/desktop-isolation-probe") #o755))))
    (home-page "https://example.invalid/desktop-isolation")
    (synopsis "Probe for desktop container boundaries")
    (description "A payload that rejects visibility of host files and services.")
    (license license:public-domain)))

(package
  (inherit payload)
  (name "desktop-isolation-probe-container")
  (build-system container-launcher-build-system)
  (arguments (list #:payload payload
                   #:executable "desktop-isolation-probe"
                   #:desktop-application "isolation-probe"))
  (inputs (list coreutils-minimal bash-minimal dbus)))
