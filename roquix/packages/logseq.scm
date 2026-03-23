(define-module (roquix packages logseq)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages cups)
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

(define %logseq-runpath-inputs
  '("gcc-toolchain"
    "zlib"
    "gtk+"
    "gtk+-2"
    "glib"
    "nspr"
    ("nss" "/lib/nss")
    "curl"
    "dbus"
    "dbus-glib"
    "at-spi2-core"
    "cups"
    "cairo"
    "pango"
    "gdk-pixbuf"
    "gconf"
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

(define %logseq-patchelf-plan
  `(("Logseq" ,%logseq-runpath-inputs)
    ("chrome-sandbox" ,%logseq-runpath-inputs)
    ("chrome_crashpad_handler" ,%logseq-runpath-inputs)
    ("libEGL.so" ,%logseq-runpath-inputs)
    ("libGLESv2.so" ,%logseq-runpath-inputs)
    ("libffmpeg.so" ,%logseq-runpath-inputs)
    ("libvk_swiftshader.so" ,%logseq-runpath-inputs)
    ("libvulkan.so.1" ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/bin/git" ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/bin/scalar" ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-daemon"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-http-backend"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-http-fetch"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-http-push"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-imap-send"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-remote-http"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-sh-i18n--envsubst"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/git-shell"
     ,%logseq-runpath-inputs)
    ("resources/app/node_modules/dugite/git/libexec/git-core/scalar"
     ,%logseq-runpath-inputs)))

(define-public logseq
  (package
    (name "logseq")
    (version "0.10.15")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/logseq/logseq/releases/download/"
             version
             "/Logseq-linux-x64-"
             version
             ".AppImage"))
       (sha256
        (base32
         "1l95gcr89hdv0wk6xv25vh3zcqcq78mrrz6ly1z2rmlnyi9114cb"))))
    (build-system appimage-build-system)
    (arguments
     (list
      #:patchelf-plan %logseq-patchelf-plan
      #:ld-library-path-inputs '(("nss" "/lib/nss"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install-desktop-file 'install-logseq-launcher-icon
            (lambda* (#:key outputs appdir launcher-name #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (appdir (string-append out "/" appdir))
                     (source (string-append appdir "/resources/app/icons/logseq.png"))
                     (desktop (string-append out "/share/applications/"
                                             launcher-name ".desktop")))
                (substitute* desktop
                  (("^Icon=.*")
                   (string-append "Icon=" source "\n")))))))))
    (inputs
     ;; Explicit labels are needed here because the AppImage bundles
     ;; tray/indicator libraries that use GTK2 in addition to the GTK3
     ;; dependencies of the main Electron binary.
     `(("gcc-toolchain" ,gcc-toolchain)
       ("zlib" ,zlib)
       ("gtk+" ,gtk+)
       ("gtk+-2" ,gtk+-2)
       ("glib" ,glib)
       ("nspr" ,nspr)
       ("nss" ,nss)
       ("curl" ,curl)
       ("dbus" ,dbus)
       ("dbus-glib" ,dbus-glib)
       ("at-spi2-core" ,at-spi2-core)
       ("cups" ,cups)
       ("cairo" ,cairo)
       ("pango" ,pango)
       ("gdk-pixbuf" ,gdk-pixbuf)
       ("gconf" ,gconf)
       ("libdbusmenu" ,libdbusmenu)
       ("libx11" ,libx11)
       ("libxcomposite" ,libxcomposite)
       ("libxdamage" ,libxdamage)
       ("libxext" ,libxext)
       ("libxfixes" ,libxfixes)
       ("libxrandr" ,libxrandr)
       ("mesa" ,mesa)
       ("expat" ,expat)
       ("libxcb" ,libxcb)
       ("libxkbcommon" ,libxkbcommon)
       ("eudev" ,eudev)
       ("alsa-lib" ,alsa-lib)))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/logseq/logseq")
    (synopsis "Privacy-first knowledge management and collaboration platform")
    (description
     "Logseq is a privacy-first, open-source platform for knowledge management
and collaboration.")
    (license license:agpl3)))
