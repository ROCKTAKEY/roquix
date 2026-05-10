(define-module (roquix packages mattermost)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xml)
  #:use-module (roquix build-system appimage))

(define %mattermost-desktop-runpath-inputs
  '(("out" "/lib/mattermost-desktop/usr/lib")
    "gcc-toolchain"
    "gtk+"
    "glib"
    "nspr"
    ("nss" "/lib/nss")
    "dbus"
    "dbus-glib"
    "at-spi2-core"
    "cups"
    "cairo"
    "pango"
    "gdk-pixbuf"
    "libappindicator"
    "libdbusmenu"
    "libx11"
    "libxcomposite"
    "libxdamage"
    "libxext"
    "libxfixes"
    "libxrandr"
    "mesa"
    "expat"
    "libxcb"
    "libxkbcommon"
    "eudev"
    "alsa-lib"))

(define %mattermost-desktop-patchelf-plan
  `(("mattermost-desktop" ,%mattermost-desktop-runpath-inputs)
    ("chrome-sandbox" ,%mattermost-desktop-runpath-inputs)
    ("chrome_crashpad_handler" ,%mattermost-desktop-runpath-inputs)
    ("libEGL.so" ,%mattermost-desktop-runpath-inputs)
    ("libGLESv2.so" ,%mattermost-desktop-runpath-inputs)
    ("libffmpeg.so" ,%mattermost-desktop-runpath-inputs)
    ("libvk_swiftshader.so" ,%mattermost-desktop-runpath-inputs)
    ("libvulkan.so.1" ,%mattermost-desktop-runpath-inputs)
    ("usr/lib/libXss.so.1" ,%mattermost-desktop-runpath-inputs)
    ("usr/lib/libXtst.so.6" ,%mattermost-desktop-runpath-inputs)
    ("usr/lib/libgconf-2.so.4" ,%mattermost-desktop-runpath-inputs)
    ("usr/lib/libnotify.so.4" ,%mattermost-desktop-runpath-inputs)))

(define-public mattermost-desktop
  (package
    (name "mattermost-desktop")
    (version "6.1.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/mattermost/desktop/releases/download/v"
             version
             "/mattermost-desktop-"
             version
             "-linux-x86_64.AppImage"))
       (sha256
        (base32
         "164h0xbfrw0fq6mlspgxpi1w6vfcz66wgv33zj0sw2bnkz6dqp02"))))
    (build-system appimage-build-system)
    (arguments
     (list
      #:patchelf-plan %mattermost-desktop-patchelf-plan
      #:ld-library-path-inputs '(("nss" "/lib/nss"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'remove-bundled-gtk2-indicator-libraries
            ;; These legacy GTK2 indicator libraries are incomplete in the
            ;; AppImage and otherwise mask Guix's GTK3 libappindicator.
            (lambda* (#:key outputs appdir #:allow-other-keys)
              (let ((appdir (string-append (assoc-ref outputs "out")
                                           "/" appdir)))
                (for-each
                 (lambda (file)
                   (let ((file (string-append appdir "/" file)))
                     (when (file-exists? file)
                       (delete-file file))))
                 '("usr/lib/libappindicator.so.1"
                   "usr/lib/libindicator.so.7"))))))))
    (inputs
     (list gcc-toolchain
           gtk+
           glib
           nspr
           nss
           dbus
           dbus-glib
           at-spi2-core
           cups
           cairo
           pango
           gdk-pixbuf
           libappindicator
           libdbusmenu
           libx11
           libxcomposite
           libxdamage
           libxext
           libxfixes
           libxrandr
           mesa
           expat
           libxcb
           libxkbcommon
           eudev
           alsa-lib))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/mattermost/desktop")
    (synopsis "Desktop client for Mattermost")
    (description
     "Mattermost Desktop is a desktop client for Mattermost workspaces.  This
package repackages the official Mattermost Desktop AppImage for Guix; it is
not an official Mattermost, Inc. distribution channel.")
    (license license:asl2.0)))
