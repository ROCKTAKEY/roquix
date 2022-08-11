(define-module
  (roquix packages Siv3D)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages hurd)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages python)
  #:use-module (gnu packages shells)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages video)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages mp3)
  #:use-module (gnu packages image)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages xiph)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages xorg))

(define (version-with-underscores version)
  (string-map (lambda (x) (if (eq? x #\.) #\_ x)) version))

(define (boost-patch name version hash)
  (origin
    (method url-fetch)
    (uri (string-append "https://www.boost.org/patches/"
                        (version-with-underscores version) "/" name))
    (file-name (string-append "boost-" name))
    (sha256 (base32 hash))))

(define-public boost-1.74.0
  (package
    (name "boost")
    (version "1.74.0")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://dl.bintray.com/boostorg/release/"
                                  version "/source/boost_"
                                  (version-with-underscores version) ".tar.bz2"))
              (sha256
               (base32
                "1c8nw4jz17zy2y27h7p554a5jza1ymz8phkz71p9181ifx8c3gw3"))))
    (build-system gnu-build-system)
    (inputs `(("icu4c" ,icu4c)
              ("zlib" ,zlib)))
    (native-inputs
     `(("perl" ,perl)
       ,@(if (%current-target-system)
             '()
             `(("python" ,python-minimal-wrapper)))
       ("tcsh" ,tcsh)))
    (arguments
     `(#:imported-modules ((guix build python-build-system)
                           ,@%gnu-build-system-modules)
       #:modules (((guix build python-build-system) #:select (python-version))
                  ,@%gnu-build-system-modules)
       #:tests? #f
       #:make-flags
       (list "threading=multi" "link=shared"

             ;; Set the RUNPATH to $libdir so that the libs find each other.
             (string-append "linkflags=-Wl,-rpath="
                            (assoc-ref %outputs "out") "/lib")
             ,@(if (%current-target-system)
                   `("--user-config=user-config.jam"
                     ;; Python is not supported when cross-compiling.
                     "--without-python"
                     "binary-format=elf"
                     "target-os=linux"
                     ,@(cond
                        ((string-prefix? "arm" (%current-target-system))
                         '("abi=aapcs"
                           "address-model=32"
                           "architecture=arm"))
                        ((string-prefix? "aarch64" (%current-target-system))
                         '("abi=aapcs"
                           "address-model=64"
                           "architecture=arm"))
                        (else '())))
                   '()))
       #:phases
       (modify-phases %standard-phases
         (delete 'bootstrap)
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let ((icu (assoc-ref inputs "icu4c"))
                   (python (assoc-ref inputs "python"))
                   (out (assoc-ref outputs "out")))
               (substitute* '("libs/config/configure"
                              "libs/spirit/classic/phoenix/test/runtest.sh"
                              "tools/build/src/engine/execunix.cpp")
                 (("/bin/sh") (which "sh")))

               (setenv "SHELL" (which "sh"))
               (setenv "CONFIG_SHELL" (which "sh"))

               ,@(if (%current-target-system)
                     `((call-with-output-file "user-config.jam"
                          (lambda (port)
                            (format port
                                    "using gcc : cross : ~a-c++ ;"
                                    ,(%current-target-system)))))
                     '())

               ;; Change an #ifdef __MACH__ that really targets macOS.
               (substitute* "boost/test/utils/timer.hpp"
                 (("defined\\(__MACH__\\)")
                  "(defined __MACH__ && !defined __GNU__)"))

               (invoke "./bootstrap.sh"
                       (string-append "--prefix=" out)
                       ;; Auto-detection looks for ICU only in traditional
                       ;; install locations.
                       (string-append "--with-icu=" icu)
                       ;; Ditto for Python.
                       ,@(if (%current-target-system)
                             '()
                             `((string-append "--with-python-root=" python)
                               (string-append "--with-python=" python "/bin/python")
                               (string-append "--with-python-version="
                                              (python-version python))))
                       "--with-toolset=gcc"))))
         (replace 'build
           (lambda* (#:key make-flags #:allow-other-keys)
             (apply invoke "./b2"
                    (format #f "-j~a" (parallel-job-count))
                    make-flags)))
         (replace 'install
           (lambda* (#:key make-flags #:allow-other-keys)
             (apply invoke "./b2" "install" make-flags)))
         ,@(if (%current-target-system)
               '()
               '((add-after 'install 'provide-libboost_python
                    (lambda* (#:key inputs outputs #:allow-other-keys)
                      (let* ((out (assoc-ref outputs "out"))
                             (python-version (python-version
                                              (assoc-ref inputs "python")))
                             (libboost_pythonNN.so
                              (string-append "libboost_python"
                                             (string-join (string-split
                                                           python-version #\.)
                                                          "")
                                             ".so")))
                        (with-directory-excursion (string-append out "/lib")
                          (symlink libboost_pythonNN.so "libboost_python.so")
                          ;; Some packages only look for the major version.
                          (symlink libboost_pythonNN.so
                                   (string-append "libboost_python"
                                                  (string-take python-version 1)
                                                  ".so")))
                        #t))))))))

    (home-page "https://www.boost.org")
    (synopsis "Peer-reviewed portable C++ source libraries")
    (description
     "A collection of libraries intended to be widely useful, and usable
across a broad spectrum of applications.")
    (license (license:x11-style "https://www.boost.org/LICENSE_1_0.txt"
                                "Some components have other similar licences."))))

(define-public giflib-5.1.4
  (package
    (name "giflib")
    (version "5.1.4")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/giflib/giflib-"
                                  version ".tar.bz2"))
              (sha256
               (base32
                "1md83dip8rf29y40cm5r7nn19705f54iraz6545zhwa6y8zyq9yz"))
              (patches
               (search-patches "patches/giflib-make-reallocarray-private.patch"))))
    (build-system gnu-build-system)
    (outputs '("bin"                    ; utility programs
               "out"))                  ; library
    (inputs `(("libx11" ,libx11)
              ("libice" ,libice)
              ("libsm" ,libsm)
              ("perl" ,perl)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'disable-html-doc-gen
           (lambda _
             (substitute* "doc/Makefile.in"
               (("^all: allhtml manpages") ""))
             #t))
         (add-after 'install 'install-manpages
           (lambda* (#:key outputs #:allow-other-keys)
             (let* ((bin (assoc-ref outputs "bin"))
                    (man1dir (string-append bin "/share/man/man1")))
               (mkdir-p man1dir)
               (for-each (lambda (file)
                           (let ((base (basename file)))
                             (format #t "installing `~a' to `~a'~%"
                                     base man1dir)
                             (copy-file file
                                        (string-append
                                         man1dir "/" base))))
                         (find-files "doc" "\\.1"))
               #t))))
       #:tests? #f))
    (synopsis "Tools and library for working with GIF images")
    (description
     "GIFLIB is a library for reading and writing GIF images.  It is API and
ABI compatible with libungif which was in wide use while the LZW compression
algorithm was patented.  Tools are also included to convert, manipulate,
compose, and analyze GIF images.")
    (home-page "http://giflib.sourceforge.net/")
    (license license:x11)))

(define-public Siv3D
  (package
    (name "Siv3D")
    (version "0.6.5")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/Siv3D/OpenSiv3D")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0zvmnqawk8md9qwh2pl8qfncxwlv6pcld00rs5ckny2lnrh337cy"))))
    (build-system cmake-build-system)
    (arguments
     '(#:phases (modify-phases %standard-phases
                  (add-before 'configure 'set-cwd
                    (lambda* (#:key #:allow-other-keys)
                      (chdir "Linux"))))
       #:tests? #f))
    (inputs (list gcc pkg-config))
    (propagated-inputs (list alsa-lib
                             ffmpeg
                             boost-1.74.0
                             curl
                             gtk+
                             giflib-5.1.4
                             glu
                             harfbuzz
                             mpg123
                             opencv
                             opus
                             opusfile
                             soundtouch
                             libtiff
                             libjpeg-turbo
                             libvorbis
                             libwebp
                             libxft
                             util-linux
                             xorg-server))
    (native-search-paths
     (list (search-path-specification
            (variable "CMAKE_PREFIX_PATH")
            (files '("")))))
    (home-page "https://siv3d.github.io/")
    (synopsis "C++20 framework for creative coding")
    (description
     "Siv3D (OpenSiv3D) is a C++20 framework for creative coding
(2D/3D games, media art, visualizers, and simulators). Siv3D applications run on
Windows, macOS, Linux, and the Web.")
    (license license:expat)))
