(define-module
  (roquix packages calibre)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages base)
  #:use-module (gnu packages commencement))

(define-public calibre-latest
  (package
    (name "calibre-latest")
    (version "7.17.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://download.calibre-ebook.com/" version "/calibre-" version "-x86_64.txz"))
       (sha256
        (base32
         "0mgk6ds5hv3bsmigmi2lvqr5myrb9sbv8z2ri65w6y068rg31wr0"))))
    (build-system binary-build-system)
    (arguments (list #:install-plan
                     #~'(("bin/" "bin/")
                         ("lib/" "lib/")
                         ("libexec/" "libexec/")
                         ("plugins/" "plugins//")
                         ("resources/" "resources/")
                         ("translations/" "translations/"))
                     #:patchelf-plan
                     #~(let ((patchelf-inputs
                              '("alsa-lib" "at-spi2-atk" "at-spi2-core" "atk" "cairo" "cups"
                                "dbus" "expat" "fontconfig-minimal" "gcc" "gdk-pixbuf" "glib"
                                "gtk" "libdrm" "libnotify" "libsecret" "libx11" "libxcb"
                                "libxcomposite" "libxcursor" "libxdamage" "libxext" "libxfixes"
                                "libxi" "libxkbcommon" "libxkbfile" "libxrandr" "libxrender"
                                "libxtst" "mesa" "nspr" "pango" "zlib"))
                             (path (string-append "opt/google/" #$appname "/")))
                         (map (lambda (file)
                                (cons (string-append path file) (list patchelf-inputs)))
                              '("chrome"
                                "chrome-sandbox"
                                "chrome_crashpad_handler"
                                "nacl_helper"
                                "libEGL.so"
                                "libGLESv2.so")))
                     #:phases
                     #~(modify-phases %standard-phases
                         (add-after 'unpack 'unpack-deb
                           (lambda* (#:key inputs #:allow-other-keys)
                             (let ((tar (string-append "calibre-" #$version "-x86_64.tar")))
                               (invoke "tar" "xf" tar)
                               (invoke "rm" "-vrf" tar)))))))
    (native-inputs (list tar))
    (inputs (list gcc-toolchain))
    (home-page "https://calibre-ebook.com/")
    (synopsis "E-book library management software")
    (description "Calibre is an e-book library manager.  It can view, convert
and catalog e-books in most of the major e-book formats.  It can also talk
to many e-book reader devices.  It can go out to the Internet and fetch
metadata for books.  It can download newspapers and convert them into
e-books for convenient reading.")
    (license (list license:gpl3+
                   license:gpl2+
                   license:lgpl2.1+
                   license:lgpl2.1
                   license:bsd-3
                   license:expat
                   license:zpl2.1
                   license:asl2.0
                   license:public-domain
                   license:silofl1.1
                   license:cc-by-sa3.0))))
