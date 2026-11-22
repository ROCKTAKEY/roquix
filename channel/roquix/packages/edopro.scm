(define-module (roquix packages edopro)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages pretty-print)
  #:use-module (gnu packages cpp)
  #:use-module (gnu packages sdl)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages image)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg))

(define irrlicht-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/edo9300/irrlicht1-8-4")
          (commit "7071bec37b1aa1a663f662dc1372f9e476aae009")))
    (file-name "edopro-irrlicht-7071bec")
    (sha256 (base32 "1sjf4psj6sfz38fdjn4yj9a08q6khf8qbwksqj5hhxay55cfqlid"))))

(define distribution
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/ProjectIgnis/Distribution")
          (commit "54a6e2395c532648ff762540e9615319fac4f51b")
          (recursive? #t)))
    (file-name "edopro-distribution-54a6e23")
    (sha256 (base32 "1sm2hj5xah99kby8spybfbggl48ckh81nv6yikmh19gh2sk86sac"))))

(define-public edopro
  (let ((commit "c5a1fcac37fa2bfb4aec6f09b81a569e695d0a7d"))
    (package
      (name "edopro")
      (version (git-version "41.0.2" "0" commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/edo9300/edopro")
                      (commit commit)
                      (recursive? #t)))
                (file-name (git-file-name name version))
                (sha256 (base32 "01s1a0r1p88xqxrcqknlri3pjapn7ll0qkmnwqvaq311br3kzv9m"))))
      (build-system gnu-build-system)
      (supported-systems '("x86_64-linux"))
      (native-inputs (list premake5))
      (inputs (list bash-minimal coreutils mesa wayland libxkbcommon freetype
                    fmt-9 nlohmann-json
                    sdl2 sdl2-mixer sqlite libevent curl libgit2 libssh2
                    openssl zlib libjpeg-turbo libpng bzip2
                    libx11 libxi libxcursor libxrandr libxxf86vm))
      (arguments
       (list
        #:tests? #f ; Upstream provides no test target.
        #:phases
        #~(modify-phases %standard-phases
            (replace 'configure
              (lambda* (#:key inputs #:allow-other-keys)
                (copy-recursively (string-append #$irrlicht-source "/include")
                                  "irrlicht/include")
                (copy-recursively (string-append #$irrlicht-source "/source/Irrlicht")
                                  "irrlicht/src")
                (for-each (lambda (dir)
                            (delete-file-recursively (string-append "irrlicht/src/" dir)))
                          '("bzip2" "jpeglib" "libpng" "zlib"))
                (substitute* "premake5.lua"
                  (("if os.istarget.*or os.istarget.*haiku.* then")
                   "if true then"))
                (substitute* "gframe/premake5.lua"
                  (("externalincludedirs \"/usr/include/irrlicht\"")
                   "externalincludedirs \"../irrlicht/include\"
                dofile(\"../irrlicht/defines.lua\")
                links { \"X11\", \"GL\", \"z\", \"bz2\", \"png\", \"jpeg\", \"crypto\" }"))
                ;; Guix Mesa exports GLX through libGL.
                (substitute* "irrlicht/src/CGLXManager.cpp"
                  (("libGLX\\.so(\\.0)?") "libGL.so.1"))
                ;; Irrlicht opens the display libraries with dlopen.
                (for-each
                 (lambda (file)
                   (substitute* file
                     (("dlopen\\(\"(lib[^\"]+\\.so[^\"]*)\"" match library)
                      (let ((path (search-path (map cdr inputs)
                                               (string-append "lib/" library))))
                        (if path (string-append "dlopen(\"" path "\"") match)))))
                 (find-files "irrlicht/src" "\\.cpp$"))
                (setenv "CPLUS_INCLUDE_PATH"
                        (string-append (search-input-directory inputs "/include/freetype2")
                                       ":" (dirname (search-input-file inputs "/include/SDL2/SDL_stdinc.h"))
                                       ":" (getenv "CPLUS_INCLUDE_PATH")))
                (invoke "premake5" "--sound=sdl-mixer" "gmake")))
            (replace 'build
              (lambda _
                (invoke "make" "-C" "build" "-j" (number->string (parallel-job-count))
                        "AR=gcc-ar" "config=release_x64" "ygopro")))
            (replace 'install
              (lambda* (#:key inputs #:allow-other-keys)
                (let ((bin (string-append #$output "/bin"))
                      (lib (string-append #$output "/libexec")))
                  (install-file (car (find-files "bin" "^ygopro$")) lib)
                  (mkdir-p bin)
                  ;; The client stores decks and replays alongside its resources.
                  (call-with-output-file (string-append bin "/edopro")
                    (lambda (port)
                      (format port
                              (string-append
                               "#!~a~%"
                               "set -eu~%"
                               "dir=\"${XDG_DATA_HOME:-$HOME/.local/share}/edopro\"~%"
                               "~a -p \"$dir\"~%"
                               "~a -rn --no-preserve=mode ~a/{config,deck,expansions,fonts,lflists,puzzles,script,skin,sound,textures} \"$dir/\"~%"
                               "exec ~a/ygopro -C \"$dir\" \"$@\"~%")
                              (search-input-file inputs "/bin/bash")
                              (which "mkdir") (which "cp") #$distribution lib)))
                  (chmod (string-append bin "/edopro") #o555)))))))
      (home-page "https://github.com/edo9300/edopro")
      (synopsis "Automatic Yu-Gi-Oh! duel simulator")
      (description "EDOPro provides a graphical deck editor and duel simulator
using the Project Ignis card engine.")
      (license license:agpl3+))))
