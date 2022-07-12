(define-module
  (roquix packages Siv3D)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
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

(define-public Siv3D
  (package
   (name "Siv3D")
   (version "0.6.4")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/Siv3D/OpenSiv3D")
           (commit "03667011e99263c6609f19c83800e5f6627cc4cc")))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "1a1lcqynjs4vvfn2wwr7xy488d4xn4235ri413b1hakjzpgjkpzg"))))
   (build-system cmake-build-system)
   (arguments
    '(#:phases
      (modify-phases %standard-phases
        (add-before 'configure 'set-cwd
          (lambda* (#:key #:allow-other-keys)
            (chdir "Linux")))
        (add-before 'install 'return-cwd
          (lambda* (#:key #:allow-other-keys)
            (chdir "..")))
        (replace 'install
          (lambda* (#:key outputs #:allow-other-keys)
            (let ((lib (string-append (assoc-ref outputs "out") "/lib"))
                  (inc (string-append (assoc-ref outputs "out") "/include")))
              (install-file "build/libSiv3D.a" lib)
              (copy-recursively "Siv3D/include" inc)))))
      #:tests? #f))
   (inputs
    (list gcc
          pkg-config
          alsa-lib
          ffmpeg
          boost-1.74.0
          curl
          ;; libcurl4-openssl
          gtk+
          giflib
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
   (home-page "https://github.com/Siv3D/OpenSiv3D")
   (synopsis "C++20 framework for creative coding")
   (description "Siv3D (OpenSiv3D) is a C++20 framework for creative coding
(2D/3D games, media art, visualizers, and simulators). Siv3D applications run on
Windows, macOS, Linux, and the Web.")
   (license license:expat)))
