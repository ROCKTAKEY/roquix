(define-module (roquix packages proton-vpn)
  #:use-module (guix build-system pyproject)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages vpn)
  #:use-module (gnu packages xorg))

(define-public proton-vpn-gtk-app
  (package
    (name "proton-vpn-gtk-app")
    ;; Later releases require a newer proton-vpn-api-core than Guix provides.
    (version "4.16.4")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ProtonVPN/proton-vpn-gtk-app")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0fs8dl7zv82ibrvkqvc4ms62knpq5ciwrw521c8347wwqssdmcgc"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'prepare-environment
            (lambda _
              (setenv "HOME" (getcwd))
              (setenv "XDG_RUNTIME_DIR" (mkdtemp "/tmp/proton-vpn-XXXXXX"))))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "dbus-run-session" "--" "pytest" "-o" "addopts="))))
          (add-after 'install 'install-desktop-entry
            (lambda _
              (install-file "rpmbuild/SOURCES/proton.vpn.app.gtk.desktop"
                            (string-append #$output "/share/applications"))
              (install-file "rpmbuild/SOURCES/proton-vpn-logo.svg"
                            (string-append #$output "/share/icons/hicolor/scalable/apps")))))))
    (native-inputs (list dbus python-pytest python-pytest-xvfb python-setuptools
                         xorg-server-for-tests))
    (propagated-inputs
     (list gobject-introspection gtk libnotify librsvg network-manager python-dbus python-distro
           python-packaging python-proton-core python-proton-keyring-linux
           python-proton-vpn-api-core python-proton-vpn-local-agent
           python-pycairo python-pygobject python-pyxdg python-requests))
    (home-page "https://protonvpn.com/")
    (synopsis "Graphical client for Proton VPN")
    (description "This official GTK client lets users sign in to Proton VPN,
select servers and manage VPN connections through NetworkManager.")
    (license license:gpl3+)))
