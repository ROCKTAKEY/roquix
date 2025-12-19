(define-module
  (roquix packages orcaslicer)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages file)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages fontutils)
  #:use-module ((gnu packages gettext) #:select (gettext-minimal))
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages image-processing)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages multiprecision)
  #:use-module (gnu packages ninja)
  #:use-module (gnu packages libusb)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages texinfo)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages tbb)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages wget)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xml))

(define-public libnoise
  (package
    (name "libnoise")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://prdownloads.sourceforge.net/libnoise/libnoisesrc-" version ".zip"))
       (sha256
       (base32
         "0nz97ds5q3qnclf394n05g6q44616fajqr0jk3iya37k8cpl1v9l"))))
    (build-system gnu-build-system)
    (native-inputs (list libtool unzip))
    (arguments
     (list
      #:phases
      '(modify-phases %standard-phases
        (add-before 'configure 'set-cwd
                    (lambda* (#:key #:allow-other-keys)
                      (chdir "src")))
        (delete 'configure)
        (replace 'build
                 (lambda* (#:key #:allow-other-keys)
                   ;; Build with upstream Makefile, then reuse libtool's archive.
                   (invoke "make" "libnoise.a" "libnoise.la")
                   (copy-file ".libs/libnoise.a" "libnoise.a")
                   (invoke "ranlib" "libnoise.a")
                   #t))
        (replace 'install
                 (lambda* (#:key outputs #:allow-other-keys)
                   (let* ((out (assoc-ref outputs "out"))
                          (libdir (string-append out "/lib"))
                          (include-noise (string-append out "/include/noise"))
                          (include-libnoise (string-append out "/include/libnoise"))
                          (model-noise (string-append include-noise "/model"))
                          (module-noise (string-append include-noise "/module"))
                          (model-libnoise (string-append include-libnoise "/model"))
                          (module-libnoise (string-append include-libnoise "/module"))
                          (cmakedir (string-append out "/lib/cmake/libnoise")))
                     (mkdir-p libdir)
                     (for-each mkdir-p
                               (list include-noise include-libnoise
                                     model-noise module-noise
                                     model-libnoise module-libnoise
                                     cmakedir))

                     (install-file "libnoise.a" libdir)

                     ;; headers are installed twice for compatibility:
                     ;;  - include/noise/... (original layout)
                     ;;  - include/libnoise/... (CMake Findlibnoise expects libnoise/noise.h)
                     (for-each (lambda (h)
                                 (install-file h include-noise)
                                 (install-file h include-libnoise))
                               (find-files "." "^[^/]+\\.h$"))
                     (for-each (lambda (h)
                                 (install-file h model-noise)
                                 (install-file h model-libnoise))
                               (find-files "model" "\\.h$"))
                     (for-each (lambda (h)
                                 (install-file h module-noise)
                                 (install-file h module-libnoise))
                               (find-files "module" "\\.h$"))

                     ;; Provide a config-package for CMake (preferred over bundled
                     ;; Findlibnoise.cmake) to avoid search failures.
                     (call-with-output-file (string-append cmakedir "/libnoiseConfig.cmake")
                       (lambda (port)
                         (format port "set(LIBNOISE_INCLUDE_DIR \"~a\")~%" include-libnoise)
                         (format port "set(LIBNOISE_LIBRARY \"~a/libnoise.a\")~%" libdir)
                         (format port "if(NOT TARGET noise::noise)~%")
                         (format port "  add_library(noise::noise UNKNOWN IMPORTED)~%")
                         (format port "  set_target_properties(noise::noise PROPERTIES~%")
                         (format port "    IMPORTED_LOCATION \"~a/libnoise.a\"~%" libdir)
                         (format port "    INTERFACE_INCLUDE_DIRECTORIES \"~a\")~%" include-libnoise)
                         (format port "endif()~%")))
                     (call-with-output-file (string-append cmakedir "/libnoiseConfigVersion.cmake")
                       (lambda (port)
                         (format port "set(PACKAGE_VERSION \"1.0.0\")~%")
                         (format port "if(PACKAGE_VERSION VERSION_LESS PACKAGE_FIND_VERSION)~%")
                         (format port "  set(PACKAGE_VERSION_COMPATIBLE FALSE)~%")
                         (format port "else()~%")
                         (format port "  set(PACKAGE_VERSION_COMPATIBLE TRUE)~%")
                         (format port "  if(PACKAGE_VERSION VERSION_EQUAL PACKAGE_FIND_VERSION)~%")
                         (format port "    set(PACKAGE_VERSION_EXACT TRUE)~%")
                         (format port "  endif()~%")
                         (format port "endif()~%")))
                     #t)))
        (delete 'check))
      ))
    (home-page "https://github.com/eXpl0it3r/libnoise")
    (synopsis "A portable, open-source, coherent noise-generating library for C++")
    (description "A portable, open-source, coherent noise-generating library for C++")
    (license license:lgpl2.1)))

(define-public orcaslicer
  (package
    (name "orcaslicer")
    (version "2.3.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
              (url "https://github.com/OrcaSlicer/OrcaSlicer")
              (commit (string-append "v" version))
              (recursive? #t)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "08hh58iqz6zh7jjd48yy6wc94pcq0x3jyv4dl1yawbi7zb3h3ls5"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:make-flags #~(list "-j4")
      #:configure-flags
      #~(list "-DSLIC3R_FHS=1"
              "-DSLIC3R_GTK=3"
              "-DSLIC3R_WX_STABLE=1"
              "-DBoost_NO_BOOST_CMAKE=ON"
              "-DOpenGL_GL_PREFERENCE=GLVND"
              (string-append "-Dlibnoise_DIR=" #$libnoise "/lib/cmake/libnoise")
              (string-append "-DLIBNOISE_LIBRARY=" #$libnoise "/lib/libnoise.a")
              (string-append "-DLIBNOISE_INCLUDE_DIR=" #$libnoise "/include/libnoise"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-opencv-world
            (lambda _
              (substitute* "src/libslic3r/CMakeLists.txt"
                (("find_package\\(OpenCV REQUIRED core\\)")
                 "find_package(OpenCV REQUIRED core imgproc imgcodecs highgui)")
                (("opencv_world") "${OpenCV_LIBRARIES}"))
              ;; Always link against webkit2gtk on Linux; upstream only does this
              ;; under FLATPAK, which leaves symbols unresolved in our static libs.
              (substitute* "src/slic3r/CMakeLists.txt"
                (("if \\(FLATPAK\\)") "if (TRUE)")
                (("pkg_check_modules\\(webkit2gtk REQUIRED webkit2gtk-4\\.1\\)")
                 "pkg_check_modules(webkit2gtk REQUIRED webkit2gtk-4.0)")
                (("target_link_libraries \\(libslic3r_gui \\$\\{X11_LIBRARIES\\} \\$\\{webkit2gtk_LIBRARIES\\}\\)")
                 "target_link_libraries (libslic3r_gui ${X11_LIBRARIES} ${webkit2gtk_LIBRARIES})"))
              #t)))))
    (native-inputs
     (list autoconf automake cmake extra-cmake-modules file gettext-minimal
           git-minimal libtool ninja pkg-config texinfo wget))
    (inputs
     (list boost-1.83 cereal cgal curl dbus eglexternalplatform eigen eudev expat
           glew glfw glib glu gmp gstreamer gtk+ heatshrink hidapi ilmbase libglvnd libigl
           libjpeg-turbo libmspack libnoise libpng libsecret libspnav mesa mpfr nanosvg
           nlopt opencascade-occt opencv openvdb openssl pango prusa-libbgcode prusa-slicer
           prusa-wxwidgets qhull tbb ;; webkitgtk-for-gtk3
           webkitgtk-with-libsoup2 zlib))
    (home-page "https://github.com/OrcaSlicer/OrcaSlicer")
    (synopsis "G-code generator for 3D printers")
    (description "G-code generator for 3D printers")
    (license license:agpl3)))
