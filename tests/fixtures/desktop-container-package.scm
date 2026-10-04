(use-modules (guix build-system trivial)
             (guix gexp)
             ((guix licenses) #:prefix license:)
             (guix packages)
             (gnu packages base)
             (gnu packages bash)
             (gnu packages glib)
             (gnu packages freedesktop)
             (gnu packages curl)
             (gnu packages pulseaudio)
             (roquix build-system container-launcher))

(define payload
  (package
    (name "desktop-isolation-probe")
    (version "1")
    (source #f)
    (build-system trivial-build-system)
    (arguments
     (list #:modules '((guix build utils))
           #:builder
           #~(begin
               (use-modules (guix build utils))
               (let ((probe (string-append #$output "/bin/desktop-isolation-probe")))
                 (mkdir-p (dirname probe))
                 (copy-file #$(local-file "desktop-isolation-probe.sh") probe)
                 (substitute* probe
                   (("^#!/bin/sh")
                    (string-append "#!" #$(file-append bash-minimal "/bin/bash"))))
                 (chmod probe #o755)))))
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
                   #:network? #t
                   #:desktop-audio? #t
                   #:desktop-application "isolation-probe"))
  (inputs (list coreutils-minimal bash-minimal dbus grep wayland-utils
                curl pulseaudio)))
