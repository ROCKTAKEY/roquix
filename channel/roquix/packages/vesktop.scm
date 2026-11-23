(define-module (roquix packages vesktop)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages pulseaudio)
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
  #:use-module (gnu packages compression)
  #:use-module (roquix build-system appimage))

(define %vesktop-runpath-inputs
  `(("out" "/lib/vesktop/usr/lib")
    "gcc-toolchain"
    "zlib"
    "gtk+"
    "glib"
    ;; Electron loads libsecret by name for safeStorage password encryption.
    ;; https://www.electronjs.org/docs/latest/api/safe-storage
    "libsecret"
    "nspr"
    ("nss" "/lib/nss")
    "dbus"
    "dbus-glib"
    "at-spi2-core"
    "cups"
    "cairo"
    "pango"
    "gdk-pixbuf"
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

(define %vesktop-patchelf-plan
  (map (lambda (file)
         (list file %vesktop-runpath-inputs))
       '("vesktop.bin" "chrome-sandbox"
         "chrome_crashpad_handler"
         "libffmpeg.so"
         "libvk_swiftshader.so"
         "libvulkan.so.1"
         "usr/lib/libXss.so.1.0.0"
         "usr/lib/libXtst.so.6.1.0"
         "usr/lib/libappindicator3.so.1.0.0"
         "usr/lib/libgconf-2.so.4.1.5"
         "usr/lib/libindicator3.so.7.0.0"
         "usr/lib/libnotify.so.4.0.0")))

(define-public vesktop
  (package
    (name "vesktop")
    (version "1.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/Vencord/Vesktop/releases/download/v" version
             "/Vesktop-" version ".AppImage"))
       (sha256
        (base32 "0x7gby4h6mqb2crxqar5h9pmg54wdjnw84zg2q7vxvzxm5nwd5mr"))))
    (build-system appimage-build-system)
    (arguments
     (list
      #:patchelf-plan %vesktop-patchelf-plan
      #:ld-library-path-inputs '(("nss" "/lib/nss") "pulseaudio" "pipewire")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install-wrapper 'wrap-runtime-tools
            (lambda* (#:key inputs outputs launcher-name #:allow-other-keys)
              (wrap-program (string-append (assoc-ref outputs "out")
                                           "/bin/" launcher-name)
                `("PATH" ":" prefix
                  (,(dirname (search-input-file inputs "/bin/unshare"))))
                `("FONTCONFIG_FILE" = (,(search-input-file inputs
                                          "/etc/fonts/fonts.conf")))
                `("XDG_DATA_DIRS" ":" suffix
                  (,(string-append #$font-dejavu "/share")
                   ,(string-append #$gsettings-desktop-schemas "/share")))))))))
    (inputs (list bash-minimal
                  gcc-toolchain
                  zlib
                  gtk+
                  glib
                  libsecret
                  nspr
                  nss
                  dbus
                  dbus-glib
                  at-spi2-core
                  cups
                  cairo
                  pango
                  gdk-pixbuf
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
                  alsa-lib
                  fontconfig
                  pulseaudio
                  pipewire
                  util-linux))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/Vencord/Vesktop")
    (synopsis "Discord desktop client with Vencord integration")
    (description
     "Vesktop provides a desktop interface to Discord with Vencord support
and screen sharing with audio on Linux.  This package installs the upstream
Electron AppImage.")
    (license license:gpl3+)))
