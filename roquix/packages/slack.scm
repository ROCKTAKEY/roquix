(define-module
  (roquix packages slack)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary)
  #:use-module ((nonguix licenses) :prefix license:)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages commencement))

(define-public slack-desktop
  (package
    (name "slack-desktop")
    (version "4.32.122")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://downloads.slack-edge.com/releases/linux/" version "/prod/x64/slack-desktop-" version "-amd64.deb"))
       (sha256
        (base32
         "1z2v7fmamlqw3k3b41nva6mamcbbkycv7b6knkdakiivpcdlf8jn"))))
    (build-system binary-build-system)
    (arguments
     (list #:validate-runpath? #f ; TODO: fails on wrapped binary and included other files
           #:patchelf-plan
           ;; TODO: Remove unnecessary libraries
           #~(let ((libs '("alsa-lib"
                           "at-spi2-atk"
                           "at-spi2-core"
                           "atk"
                           "cairo"
                           "cups"
                           "dbus"
                           "expat"
                           "fontconfig-minimal"
                           "gcc"
                           "gdk-pixbuf"
                           "glib"
                           "gtk+"
                           "libdrm"
                           "libsecret"
                           "libx11"
                           "libxcb"
                           "libxcomposite"
                           "libxcursor"
                           "libxdamage"
                           "libxext"
                           "libxfixes"
                           "libxi"
                           "libxkbcommon"
                           "libxkbfile"
                           "libxrandr"
                           "libxshmfence"
                           "libxtst"
                           "mesa"
                           "nspr"
                           "pango"
                           "pulseaudio"
                           "zlib")))
               `(("lib/slack/slack" ,libs)
                 ("lib/slack/libffmpeg.so" ,libs)
                 ("lib/slack/libEGL.so" ,libs)
                 ("lib/slack/libGLESv2.so" ,libs)
                 ("lib/slack/libffmpeg.so" ,libs)
                 ("lib/slack/libvk_swiftshader.so" ,libs)
                 ("lib/slack/libvulkan.so.1" ,libs)
                 ("lib/slack/resources/app.asar.unpacked/node_modules/electron-native-auth/build/Release/electron_native_auth.node" ,libs)
                 ("lib/slack/resources/app.asar.unpacked/node_modules/file-handler-info/build/Release/file_handler_info.node" ,libs)))
           ;; FIXME: Slack hung with message below:
           ;;   Initializing local storage instance
           ;;   (electron) Sending uncompressed crash reports is deprecated and will be removed in a future version of Electron. Set { compress: true } to opt-in to the new behavior. Crash reports will be uploaded gzipped, which most crash reporting servers support.
           ;;   [2488:0724/235150.394439:FATAL:spawn_subprocess.cc(221)] posix_spawn: No such file or directory (2)
           ;;   Trace/breakpoint trap
           #:phases
           #~(modify-phases %standard-phases
               (replace 'unpack
                 (lambda _
                   (invoke "ar" "x" #$source)
                   (invoke "tar" "xvf" "data.tar.xz")
                   (copy-recursively "usr/" ".")
                   ;; Remove unneeded files.
                   (delete-file-recursively "usr")
                   (delete-file "control.tar.xz")
                   (delete-file "data.tar.xz")
                   (delete-file "debian-binary")

                   ;; Fix the .desktop file binary location.
                   (substitute* '("share/applications/slack.desktop")
                     (("/usr/")
                      (string-append #$output "/")))))
               (add-after 'install 'wrap-where-patchelf-does-not-work
                 (lambda _
                   (wrap-program (string-append #$output "/lib/slack/slack")
                     `("FONTCONFIG_PATH" ":" prefix
                       (,(string-join
                          (list
                           (string-append #$(this-package-input "fontconfig-minimal") "/etc/fonts")
                           #$output)
                          ":")))
                     `("LD_LIBRARY_PATH" ":" prefix
                       (,(string-join
                          (list
                           (string-append #$(this-package-input "nss") "/lib/nss")
                           (string-append #$(this-package-input "eudev") "/lib")
                           (string-append #$(this-package-input "gcc") "/lib")
                           (string-append #$(this-package-input "mesa") "/lib")
                           (string-append #$(this-package-input "libxkbfile") "/lib")
                           (string-append #$(this-package-input "pulseaudio") "/lib")
                           (string-append #$(this-package-input "zlib") "/lib")
                           (string-append #$(this-package-input "libsecret") "/lib")
                           (string-append #$output "/lib/slack")
                           #$output)
                          ":")))))))))
    (inputs
     (list alsa-lib
           at-spi2-atk
           at-spi2-core
           atk
           cairo
           cups
           dbus
           eudev
           expat
           fontconfig
           `(,gcc "lib")
           glib
           gtk+
           libdrm
           librsvg
           libsecret
           libx11
           libxcb
           libxcomposite
           libxdamage
           libxext
           libxfixes
           libxkbcommon
           libxkbfile
           libxrandr
           libxshmfence
           mesa
           nspr
           nss
           pango
           pulseaudio
           zlib))
    (home-page "https://slack.com")
    (synopsis "Platform for your team and your work")
    (description "Platform for your team and your work.")
    (license (license:nonfree "https://slack.com/terms-of-service/user"))))
