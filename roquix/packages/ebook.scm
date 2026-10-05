(define-module (roquix packages ebook)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system python)
  #:use-module (guix build-system qt)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages databases)
  #:use-module (gnu packages file)
  #:use-module (gnu packages fonts)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages hunspell)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages image)
  #:use-module (gnu packages javascript)
  #:use-module (gnu packages language)
  #:use-module (gnu packages libreoffice)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages music)
  #:use-module (gnu packages pantheon)
  #:use-module (gnu packages pdf)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-compression)
  #:use-module (gnu packages python-crypto)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages qt)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages speech)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages time)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages ebook))

(define-public calibre
  (package
    (name "calibre")
    (version "6.15.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://download.calibre-ebook.com/"
                           version "/calibre-"
                           version ".tar.xz"))
       (sha256
        (base32
         "06j4zf0xbwx0g0lmsd4db2ibvl4k58dcqpifsbhn0hk523bcdmxp"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           ;; Unbundle python2-odfpy.
           (delete-file-recursively "src/odf")
           ;; Disable test that attempts to load it.
           (substitute* "setup/test.py"
             ((".*SRC, 'odf'.*") ""))
           ;; Remove unneeded resources.
           (delete-file "resources/mozilla-ca-certs.pem")
           (delete-file "resources/calibre-portable.bat")
           (delete-file "resources/calibre-portable.sh")))
       (patches (search-patches "calibre-no-updates-dialog.patch"
                                "calibre-remove-test-sqlite.patch" ; TODO: fix test.
                                "calibre-remove-test-unrar.patch"))))
    (build-system python-build-system)
    (native-inputs
     (list bash-minimal
           pkg-config
           python-flake8
           python-pyqt-builder
           qtbase-5                     ; for qmake
           xdg-utils))
    (inputs
     (list fontconfig
           font-liberation
           glib
           hunspell
           hyphen
           icu4c
           libmtp
           libpng
           libjpeg-turbo
           libjxr
           libstemmer
           libusb
           openssl
           optipng
           podofo
           poppler
           python-apsw
           python-beautifulsoup4
           python-cchardet
           python-css-parser
           python-cssselect
           python-dateutil
           python-dnspython-1.16
           python-feedparser
           python-html2text
           python-html5-parser
           python-html5lib
           python-jeepney
           python-lxml
           python-markdown
           python-mechanize
           ;; python-msgpack is needed for the network content server to work.
           python-msgpack
           python-netifaces
           python-odfpy
           python-pillow
           python-psutil
           python-py7zr
           python-pychm
           python-pycryptodome
           python-pygments
           python-pyqt
           python-pyqtwebengine
           python-regex
           speech-dispatcher
           python-zeroconf
           qtwebengine-5
           sqlite
           uchardet))
    (arguments
     (list
      ;; Calibre is using setuptools by itself, but the setup.py is not
      ;; compatible with the shim wrapper (taken from pip) we are using.
      #:use-setuptools? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-source
            (lambda _
              (substitute* "src/calibre/linux.py"
                ;; We can't use the uninstaller in Guix. Don't build it.
                (("self\\.create_uninstaller()") ""))))
          (add-after 'patch-source-shebangs 'patch-more-shebangs
            (lambda* (#:key inputs native-inputs #:allow-other-keys)
              ;; Patch various inline shebangs.
              (substitute* '("src/calibre/gui2/preferences/tweaks.py"
                             "src/calibre/gui2/dialogs/custom_recipes.py"
                             "setup/install.py"
                             "setup/linux-installer.sh")
                (("#!/usr/bin/env python")
                 (string-append "#!" (search-input-file inputs "/bin/python")))
                (("#!/bin/sh")
                 (string-append "#!"
                                (search-input-file native-inputs "/bin/sh"))))))
          (add-after 'unpack 'dont-load-remote-icons
            (lambda _
              (substitute* "setup/plugins_mirror.py"
                (("href=\"//calibre-ebook.com/favicon.ico\"")
                 "href=\"favicon.ico\""))))
          (add-before 'build 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              (substitute* "setup/build.py"
                (("\\[tool.sip.bindings.pictureflow\\]")
                 "[tool.sip.bindings.pictureflow]
tags = [\"WS_X11\"]")
                (("\\[tool.sip.project\\]")
                 (string-append "[tool.sip.project]
sip-include-dirs = [\""
                                #$(this-package-input
                                   "python-pyqt")
                                "/share/sip\"]")))
              (substitute* "src/calibre/ebooks/pdf/pdftohtml.py"
                (("PDFTOHTML = 'pdftohtml'")
                 (string-append "PDFTOHTML = \""
                                (search-input-file inputs "/bin/pdftohtml")
                                "\"")))
              ;; get_exe_path looks in poppler's output for these
              ;; binaries. Make it not do that.
              (substitute* "src/calibre/utils/img.py"
                (("get_exe_path..jpegtran..")
                 (string-append "'"
                                (search-input-file inputs "/bin/jpegtran")
                                "'"))
                (("get_exe_path..cjpeg..")
                 (string-append "'"
                                (search-input-file inputs "/bin/cjpeg")
                                "'"))
                (("get_exe_path..optipng..")
                 (string-append "'"
                                (search-input-file inputs "/bin/optipng")
                                "'"))
                (("get_exe_path..JxrDecApp..")
                 (string-append "'"
                                (search-input-file inputs "/bin/JxrDecApp")
                                "'")))
              ;; Calibre thinks we are installing desktop files into a home
              ;; directory, but here we butcher the script in to installing
              ;; to calibres /share directory.
              (setenv "XDG_DATA_HOME" (string-append #$output "/share"))
              (substitute* "src/calibre/linux.py"
                (("'~/.local/share'") "''"))
              ;; 'python setup.py rapydscript' uses QtWebEngine, which
              ;; needs to create temporary files in $HOME.
              (setenv "HOME" "/tmp")
              ;; XXX: QtWebEngine will fail if no fonts are available.  This
              ;; can likely be removed when fontconfig has been patched to
              ;; include TrueType fonts by default.
              (symlink (string-append #$(this-package-input "font-liberation")
                                      "/share/fonts")
                       "/tmp/.fonts")
              (let ((podofo #$(this-package-input "podofo")))
                (setenv "PODOFO_INC_DIR"
                        (string-append podofo "/include/podofo"))
                (setenv "PODOFO_LIB_DIR" (string-append podofo "/lib")))
              ;; This informs the tests we are a continuous integration
              ;; environment and thus have no networking.
              (setenv "CI" "true")
              ;; The Qt test complains about being unable to load all image
              ;; plugins, and I notice the available plugins list it shows
              ;; lacks 'svg'. Adding qtsvg-5 doesn't fix it, so I'm not sure how
              ;; to fix it.  TODO: Fix test and remove this.
              (setenv "SKIP_QT_BUILD_TEST" "true")))
          (add-after 'install 'install-rapydscript
            (lambda _
              ;; Unset so QtWebengine doesn't dump temporary files here.
              (unsetenv "XDG_DATA_HOME")
              (invoke "python" "setup.py" "rapydscript")))
          (add-after 'install 'install-man-pages
            (lambda _
              (copy-recursively "man-pages"
                                (string-append #$output "/share/man"))))
          ;; The font TTF files are used in some miscellaneous tests, so we
          ;; unbundle them here to avoid patching the tests.
          (add-after 'install 'unbundle-font-liberation
            (lambda _
              (let ((font-dest
                     (string-append #$output "/share/calibre/fonts/liberation"))
                    (font-src
                     (string-append #$(this-package-input "font-liberation")
                                    "/share/fonts/truetype")))
                (delete-file-recursively font-dest)
                (symlink font-src font-dest))))
          ;; Make run-time dependencies available to the binaries.
          (add-after 'wrap 'wrap-program
            (lambda* (#:key inputs #:allow-other-keys)
              (with-directory-excursion (string-append #$output "/bin")
                (for-each
                 (lambda (binary)
                   (wrap-program binary
                     ;; Make QtWebEngineProcess available.
                     `("QTWEBENGINEPROCESS_PATH" =
                       ,(list
                         (search-input-file
                          inputs "/lib/qt5/libexec/QtWebEngineProcess")))))
                 ;; Wrap all the binaries shipping with the package, except
                 ;; for the wrappings created during the 'wrap standard
                 ;; phase.  This extends existing .calibre-real wrappers
                 ;; rather than create ..calibre-real-real-s.  For more
                 ;; information see: https://issues.guix.gnu.org/43249.
                 (find-files "." (lambda (file stat)
                                   (not (wrapped-program? file)))))))))))
    (home-page "https://calibre-ebook.com/")
    (synopsis "E-book library management software")
    (description "Calibre is an e-book library manager.  It can view, convert
and catalog e-books in most of the major e-book formats.  It can also talk
to many e-book reader devices.  It can go out to the Internet and fetch
metadata for books.  It can download newspapers and convert them into
e-books for convenient reading.")
    ;; Calibre is largely GPL3+, but includes a number of components covered
    ;; by other licenses. See COPYRIGHT for more details.
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
