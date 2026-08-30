(define-module (roquix packages feishin)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages video)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages compression)
  #:use-module (roquix build-system appimage))

(define %feishin-runpath-inputs
  `(("out" "/lib/feishin/usr/lib")
    "gcc-toolchain"
    "zlib"
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

(define %feishin-patchelf-plan
  (map (lambda (file)
         (list file %feishin-runpath-inputs))
       '("feishin" "chrome-sandbox"
         "chrome_crashpad_handler"
         "libEGL.so"
         "libGLESv2.so"
         "libffmpeg.so"
         "libvk_swiftshader.so"
         "libvulkan.so.1"
         "resources/app.asar.unpacked/node_modules/abstract-socket/build/Release/bindings.node"
         "usr/lib/libXss.so.1.0.0"
         "usr/lib/libXtst.so.6.1.0"
         "usr/lib/libappindicator3.so.1.0.0"
         "usr/lib/libgconf-2.so.4.1.5"
         "usr/lib/libindicator3.so.7.0.0"
         "usr/lib/libnotify.so.4.0.0")))

(define-public feishin
  (package
    (name "feishin")
    (version "1.15.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/jeffvli/feishin/releases/download/v" version
             "/Feishin-linux-x86_64.AppImage"))
       (sha256
        (base32 "05b5p7j0q9bskga01aq4m20dw7x661gilba5i4q3zl9rm8byj12x"))))
    (build-system appimage-build-system)
    (arguments
     (list
      #:patchelf-plan %feishin-patchelf-plan
      #:ld-library-path-inputs '(("nss" "/lib/nss"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install-wrapper 'wrap-runtime-tools
            (lambda* (#:key inputs outputs launcher-name #:allow-other-keys)
              (let* ((launcher (string-append (assoc-ref outputs "out")
                                              "/bin/" launcher-name))
                     (runtime-path (map (lambda (file)
                                          (dirname (search-input-file inputs
                                                                      file)))
                                        '("/bin/mpv" "/bin/unshare"))))
                ;; Feishin delegates local playback to mpv, while AppRun probes
                ;; unshare before enabling Electron's Chromium sandbox.
                (wrap-program launcher
                  `("PATH" ":" prefix
                    ,runtime-path))))))))
    (inputs (list bash-minimal
                  gcc-toolchain
                  zlib
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
                  mpv
                  util-linux))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/jeffvli/feishin")
    (synopsis "Modern music player for self-hosted music servers")
    (description
     "Feishin is a desktop music player for Jellyfin, Navidrome, and
OpenSubsonic servers.  It supports local playback through mpv as well as web
playback.  This package repackages the official Feishin AppImage for Guix.")
    (license license:gpl3)))
