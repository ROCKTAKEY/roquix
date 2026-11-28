(use-modules (gnu packages base)
             (gnu packages bash)
             (gnu packages glib)
             (guix packages)
             (guix gexp)
             (guix build-system trivial)
             (roquix build-system container-launcher))

(define probe
  (package
    (inherit hello)
    (name "portal-probe")
    (source #f)
    (build-system trivial-build-system)
    (arguments
     (list #:modules '((guix build utils))
           #:builder
           #~(begin
               (use-modules (guix build utils))
               (let ((bin (string-append #$output "/bin/portal-probe")))
                 (mkdir-p (dirname bin))
                 (copy-file #$(local-file "portal-probe.sh") bin)
                 (substitute* bin (("^#!/bin/sh") (string-append "#!" #$bash-minimal "/bin/sh")))
                 (chmod bin #o755)))))))

(package
  (inherit hello)
  (source #f)
  (name "portal-container-probe")
  (build-system container-launcher-build-system)
  (arguments (list #:payload probe
                   #:executable "portal-probe"
                   #:desktop-temporary-directory "/tmp"
                   #:network? #t
                   #:desktop-portals '(Camera NetworkMonitor)
                   #:desktop-application "portal-probe"))
  (inputs (list bash-minimal coreutils-minimal dbus)))
