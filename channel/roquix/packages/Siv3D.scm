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
               (parameterize
                   ((%patch-path
                     (map (lambda (directory)
                            (string-append directory "/roquix/packages/patches"))
                          %load-path)))
                 (search-patches "giflib-make-reallocarray-private.patch")))))
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

(define-public opensiv3d
  (package
    (name "opensiv3d")
    (version "0.6.16")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Siv3D/OpenSiv3D")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1z045fb0p1g3ca912sjg30pw6bq43p6mvdra1wraca7n1jb1grmh"))))
    (build-system cmake-build-system)
    (arguments
     '(#:phases (modify-phases %standard-phases
                  (add-before 'configure 'set-cwd
                    (lambda* (#:key #:allow-other-keys)
                      (chdir "Linux")))
                  (add-after 'set-cwd 'patch-linux-build
                    (lambda _
                      ;; GCC 13 accepted this incompatible pointer argument as
                      ;; a warning, but GCC 14 treats -Wincompatible-pointer-types
                      ;; as an error for C99-and-later C code.  OpenSiv3D's
                      ;; preedit API takes XPointer, while this vendored GLFW
                      ;; call still passes _GLFWwindow* directly.
                      (substitute*
                          "../Siv3D/src/ThirdParty/GLFW/x11_window.c"
                        (("s3d_PreeditAttributes\\(window\\)")
                         "s3d_PreeditAttributes((XPointer) window)"))
                      ;; Upstream Linux CMake requests -msse4.1, but Siv3D's
                      ;; Linux intrinsic gate in Platform.hpp enables the native
                      ;; SIMD path only when __SSE4_2__ is defined.  This is a
                      ;; known upstream Linux/SIMDe issue:
                      ;; https://github.com/Siv3D/OpenSiv3D/issues/819
                      ;; With GCC 11/13/14, the inconsistent state can enter the
                      ;; vendored SIMDe fallback/native-alias path and collide
                      ;; with GCC's own intrinsic declarations.  Build with
                      ;; SSE4.2 to match Siv3D's native SIMD condition on Linux.
                      (substitute* "CMakeLists.txt"
                        (("-msse4\\.1") "-msse4.2")))))
       #:tests? #f))
    (inputs (list gcc))
    (propagated-inputs (list alsa-lib
                             ffmpeg
                             boost-1.83
                             curl
                             gtk+
                             giflib-5.1.4
                             glu
                             harfbuzz
                             libmpg123
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
    (native-inputs (list pkg-config))
    (home-page "https://siv3d.github.io/")
    (synopsis "C++20 framework for creative coding")
    (description
     "Siv3D (OpenSiv3D) is a C++20 framework for creative coding
(2D/3D games, media art, visualizers, and simulators).  Siv3D applications run on
Windows, macOS, Linux, and the Web.")
    (license license:expat)))
