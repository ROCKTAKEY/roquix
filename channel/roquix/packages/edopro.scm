(define-module (roquix packages edopro)
  #:use-module (srfi srfi-13)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
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
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages image)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg))

(define (github-source repository commit hash)
  (origin
    (method git-fetch)
    (uri (git-reference
          (url (string-append "https://github.com/" repository))
          (commit commit)))
    (file-name (git-file-name (basename repository) (string-take commit 7)))
    (sha256 hash)))

(define client-commit "c5a1fcac37fa2bfb4aec6f09b81a569e695d0a7d")
(define client-source
  (github-source "edo9300/edopro" client-commit
                 (base32 "1cz908z02pqhc5z69a1cwidvylimk9z8rb5sfpd1hvy196p32z4p")))

(define core-commit "46779fbe40e6a9bd8967f5dc6a03f4eaa6550d57")
(define core-source
  (github-source "edo9300/ygopro-core" core-commit
                 (base32 "02irnvfhjmkyh36h36a1d7znmikkarcl7h1yypdmrfbv8gj60dh2")))

;; The client and core supply Premake subprojects describing exactly which
;; features and translation units their static libraries must provide.
(define (library-workspace project)
  (plain-file "premake5.lua"
              (string-append "workspace 'library'\nlocation 'build'\n"
                             "configurations { 'Release' }\nlanguage 'C++'\n"
                             "optimize 'Speed'\ndefines { 'NDEBUG' }\n"
                             "targetdir 'lib'\ninclude '" project "'\n")))

(define-public edopro-lua
  (let ((commit "6e22fedb74cf0c9b6656e9fce8b7331db847c605"))
    (package
      (name "edopro-lua")
      (version (git-version "5.4.8" "0" commit))
      (source (github-source "lua/lua" commit
                             (base32 "0zwqxj5a03ypzrq1sgmm1di8gzkf30v06vyqcaym4fsmds6xrbyl")))
      (build-system gnu-build-system)
      (native-inputs (list premake5))
      (arguments
       (list #:tests? #f
             #:make-flags #~'("-C" "build" "config=release" "lua")
             #:phases
             #~(modify-phases %standard-phases
                 (replace 'configure
                   (lambda _
                     (mkdir "lua")
                     (symlink #$(package-source this-package) "lua/src")
                     (for-each (lambda (file)
                                 (copy-file (string-append #$core-source "/lua/" file)
                                            (string-append "lua/" file)))
                               '("premake5.lua" "luaconf-customize.h"))
                     (copy-file #$(library-workspace "lua") "premake5.lua")
                     (invoke "premake5" "gmake")))
                 (replace 'install
                   (lambda _
                     (install-file "lib/liblua.a" (string-append #$output "/lib"))
                     (for-each (lambda (file)
                                 (install-file file (string-append #$output "/include")))
                               '("lua.h" "luaconf.h" "lauxlib.h" "lualib.h")))))))
      (home-page "https://www.lua.org/")
      (synopsis "Lua static library for the EDOPro duel engine")
      (description "This variant compiles Lua as C++ with the library selection
and configuration used by the Project Ignis duel engine.")
      (license license:expat))))

(define-public edopro-ocgcore
  (package
    (name "edopro-ocgcore")
    (version (git-version "11.0" "0" core-commit))
    (source core-source)
    (build-system gnu-build-system)
    (native-inputs (list premake5))
    (inputs (list edopro-lua))
    (arguments
     (list #:tests? #f
           #:make-flags #~'("-C" "build" "config=release" "ocgcore")
           #:phases
           #~(modify-phases %standard-phases
               (replace 'configure
                 (lambda _
                   (substitute* "premake5.lua" (("include \"./lua/\"") ""))
                   (invoke "premake5" "gmake")))
               (replace 'install
                 (lambda _
                   (install-file "bin/release/libocgcore.a" (string-append #$output "/lib"))
                   (for-each (lambda (file)
                               (install-file file (string-append #$output "/include")))
                             '("ocgapi.h" "ocgapi_types.h" "ocgapi_constants.h")))))))
    (home-page "https://github.com/edo9300/ygopro-core")
    (synopsis "Duel rules engine for EDOPro")
    (description "This library executes duel actions and Lua card scripts
through the Project Ignis OCG API.")
    (license (list license:agpl3+ license:expat))))

(define-public babelcdb
  (let ((commit "4c8e9ca577d94292c51e420c5ae423e141d2eec7"))
    (package
      (name "babelcdb")
      (version (git-version "2025.04.19" "0" commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/ProjectIgnis/BabelCDB")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32 "0dnmkxwk6122cv32shvvs1vwh5j19m85dhp3alr085zhykqs69mc"))))
      (build-system copy-build-system)
      (arguments
       (list #:install-plan
             #~'(("." "share/edopro/databases" #:include-regexp ("\\.cdb$"))
                 ("README.md" "share/doc/babelcdb/"))))
      (home-page "https://github.com/ProjectIgnis/BabelCDB")
      (synopsis "Project Ignis card databases for EDOPro")
      (description "BabelCDB provides card statistics and text for EDOPro.
Install it alongside edopro to make the databases available to the client.
Upstream does not specify a redistribution license for these databases.")
      (license
       (license:license "Unspecified"
                        (string-append "https://github.com/ProjectIgnis/BabelCDB/tree/" commit)
                        "No database redistribution license is stated at this revision.")))))

(define-public edopro-cardscripts
  (let ((commit "c8e9c0bcd026a5ccc303bbc73881b8f86f818657"))
    (package
      (name "edopro-cardscripts")
      (version (git-version "0" "0" commit))
      (source (github-source "ProjectIgnis/CardScripts" commit
                             (base32 "1fnmccx1q08bvr4sx06b5l7x9nknvflfb4mdhid3r3ha6if577f2")))
      (build-system copy-build-system)
      (arguments
       (list #:install-plan
             #~'(("." "share/edopro/script"
                  #:include-regexp ("\\.lua$" "^\\./(README\\.md|COPYING)$")))))
      (home-page "https://github.com/ProjectIgnis/CardScripts")
      (synopsis "Lua card scripts for EDOPro")
      (description "These scripts implement card effects for the Project Ignis duel engine.")
      (license license:agpl3+))))

(define-public edopro-puzzles
  ;; This upstream revision includes the collection's AGPL notice and terms.
  ;; https://github.com/ProjectIgnis/Puzzles/commit/3d464b8c5fb52671267f181cb82b5a0ab26b803e
  (let ((commit "3d464b8c5fb52671267f181cb82b5a0ab26b803e"))
    (package
      (name "edopro-puzzles")
      (version (git-version "2020.07.22" "0" commit))
      (source (github-source "ProjectIgnis/Puzzles" commit
                             (base32 "0yvscnpbnihzgcdvf4rmwg88fwyddvcg5pl6ha1cycqwfqbk9xpk")))
      (build-system copy-build-system)
      (arguments
       (list #:install-plan
             #~'(("." "share/edopro/puzzles" #:include-regexp ("\\.lua$"))
                 ("README.md" "share/doc/edopro-puzzles/")
                 ("COPYING" "share/doc/edopro-puzzles/"))))
      (home-page "https://github.com/ProjectIgnis/Puzzles")
      (synopsis "Single-player duel puzzles for EDOPro")
      (description "This collection includes Lua puzzles and tutorials.
Drag a Lua file from share/edopro/puzzles onto the EDOPro main menu to open it.")
      (license license:agpl3+))))

(define distribution-commit "54a6e2395c532648ff762540e9615319fac4f51b")
(define distribution-source
  (github-source "ProjectIgnis/Distribution" distribution-commit
                 (base32 "0fmriail2gxgg8crsdhannvhzhallq61al8vvr3jsk8idg8a1y3z")))

(define-public font-edopro-noto-sans-jp
  (package
    (name "font-edopro-noto-sans-jp")
    (version "2.002")
    (source distribution-source)
    (build-system copy-build-system)
    (arguments
     (list #:install-plan
           #~'(("fonts/NotoSansJP-Regular.otf" "share/fonts/opentype/")
               ("fonts/NotoSansJP-Regular-OFL.txt" "share/fonts/opentype/"))))
    (home-page "https://fonts.google.com/specimen/Noto+Sans+JP")
    (synopsis "Noto Sans JP Regular as distributed with EDOPro")
    (description "This OpenType font provides the Japanese and Latin glyphs
used by the default EDOPro interface.")
    (license license:silofl1.1)))

(define-public edopro-game-data
  (package
    (name "edopro-game-data")
    (version (git-version "0" "0" distribution-commit))
    (source distribution-source)
    (build-system copy-build-system)
    (native-inputs (list imagemagick font-edopro-noto-sans-jp))
    (arguments
     (list #:phases
           #~(modify-phases %standard-phases
               (replace 'install
                 (lambda _
                   (define data (string-append #$output "/share/edopro"))
                   (define (install-resources directory files)
                     (for-each
                      (lambda (file)
                        (install-file (string-append directory "/" file)
                                      (string-append data "/" directory)))
                      files))
                   (mkdir-p data)
                   (install-file "LICENSE" data)
                   ;; The Distribution license covers its configuration.  Card databases
                   ;; and puzzle collections are separate upstream projects.
                   (copy-recursively "config" (string-append data "/config"))
                   (substitute* (string-append data "/config/configs.json")
                     (("\"should_read\": true") "\"should_read\": false"))
                   (substitute* (string-append data "/config/system.conf")
                     (("^skin = .*") ""))
                   ;; The pinned credits identify the license of each selected asset.
                   ;; https://github.com/ProjectIgnis/Distribution/blob/54a6e2395c532648ff762540e9615319fac4f51b/sound/CREDITS.md
                   (install-resources "sound"
                                      '("CREDITS.md" "addcounter.wav" "attack.wav"
                                        "chatmessage.wav" "coinflip.wav" "damage.wav"
                                        "diceroll.wav" "draw.wav" "equip.wav" "flip.wav"
                                        "gainlp.wav" "nextturn.wav" "phase.wav"
                                        "playerenter.wav" "removecounter.wav" "set.wav"
                                        "shuffle.wav" "summon.wav"))
                   ;; https://github.com/ProjectIgnis/Distribution/blob/54a6e2395c532648ff762540e9615319fac4f51b/textures/CREDITS.md
                   (install-resources "textures"
                                      '("CREDITS.md" "AppIcon.png" "act.png" "attack.png"
                                        "bg.png" "bg_deck.png" "bg_menu.png" "chain.png"
                                        "chaintarget.png" "cover.png" "cover2.png"
                                        "equip.png" "field.png" "field2.png" "field3.png"
                                        "field4.png" "fieldSP.png" "fieldSP2.png"
                                        "fieldSP3.png" "fieldSP4.png" "field-transparent.png"
                                        "field-transparent2.png" "field-transparent3.png"
                                        "field-transparent4.png" "field-transparentSP.png"
                                        "field-transparentSP2.png" "field-transparentSP3.png"
                                        "field-transparentSP4.png" "lim.png" "lp.png"
                                        "lpf.png" "mask.png" "negated.png" "number.png"
                                        "ot.png" "settings.png" "target.png" "unknown.jpg"))
                   ;; EDOPro requires three hand textures at startup.  The credits name
                   ;; PNGs, while Distribution supplies JPEGs of uncertain provenance.
                   (for-each
                    (lambda (file label)
                      (invoke "convert"
                              "-size" "89x128" "xc:#222222" "-font"
                              #$(file-append font-edopro-noto-sans-jp
                                             "/share/fonts/opentype/NotoSansJP-Regular.otf") "-pointsize" "19"
                              "-fill" "white" "-gravity" "center" "-annotate" "0" label
                              "-strip" (string-append data "/textures/" file ".png")))
                    '("f1" "f2" "f3") '("Scissors" "Rock" "Paper")))))))
    (home-page "https://github.com/ProjectIgnis/Distribution")
    (synopsis "Configuration, sound and textures for EDOPro")
    (description "This package provides the licensed game resources selected
from the Project Ignis distribution.")
    (license (list license:agpl3+ license:gpl2
                   license:cc0 license:cc-by3.0))))

(define-public edopro-irrlicht
  (let ((commit "7071bec37b1aa1a663f662dc1372f9e476aae009"))
    (package
      (name "edopro-irrlicht")
      (version (git-version "1.8.4" "0" commit))
      (source (github-source "edo9300/irrlicht1-8-4" commit
                             (base32 "1sjf4psj6sfz38fdjn4yj9a08q6khf8qbwksqj5hhxay55cfqlid")))
      (build-system gnu-build-system)
      (native-inputs (list premake5))
      (inputs (list mesa wayland libxkbcommon libx11 libxi libxcursor libxrandr
                    libxxf86vm zlib bzip2 libpng libjpeg-turbo))
      (arguments
       (list #:tests? #f
             #:make-flags #~'("-C" "build" "config=release" "Irrlicht")
             #:phases
             #~(modify-phases %standard-phases
                 (replace 'configure
                   (lambda* (#:key inputs #:allow-other-keys)
                     (for-each (lambda (dir)
                                 (delete-file-recursively (string-append "source/Irrlicht/" dir)))
                               '("bzip2" "jpeglib" "libpng" "zlib"))
                     ;; Irrlicht abandons X11 context setup if it cannot open its
                     ;; GLX library.  This Mesa build exports GLX through libGL.so.1.
                     ;; https://github.com/edo9300/irrlicht1-8-4/blob/7071bec37b1aa1a663f662dc1372f9e476aae009/source/Irrlicht/CGLXManager.cpp#L62-L71
                     (substitute* "source/Irrlicht/CGLXManager.cpp"
                       (("libGLX\\.so(\\.0)?") "libGL.so.1"))
                     ;; Irrlicht opens X11 and Wayland libraries by name at runtime.
                     ;; dlopen's search path need not include their Guix store
                     ;; directories, even when they were available during the build.
                     (for-each
                      (lambda (file)
                        (substitute* file
                          (("dlopen\\(\"(lib[^\"]+\\.so[^\"]*)\"" match library)
                           (let ((path (search-path (map cdr inputs)
                                                    (string-append "lib/" library))))
                             (if path (string-append "dlopen(\"" path "\"") match)))))
                      (find-files "source/Irrlicht" "\\.cpp$"))
                     (copy-recursively (string-append #$client-source "/irrlicht") "irrlicht")
                     (symlink "../include" "irrlicht/include")
                     (symlink "../source/Irrlicht" "irrlicht/src")
                     (copy-file #$(library-workspace "irrlicht") "premake5.lua")
                     (invoke "premake5" "gmake")))
                 (replace 'install
                   (lambda _
                     (install-file "lib/libIrrlicht.a" (string-append #$output "/lib"))
                     (copy-recursively "include" (string-append #$output "/include/irrlicht")))))))
      (home-page "https://github.com/edo9300/irrlicht1-8-4")
      (synopsis "Irrlicht rendering engine for EDOPro")
      (description "This fork of Irrlicht provides the rendering and window
backends used by the EDOPro client.")
      (license (list license:zlib license:agpl3+)))))

(define-public edopro
  (package
    (name "edopro")
    (version (git-version "41.0.2" "0" client-commit))
    (source client-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux"))
    (native-inputs (list premake5))
    (native-search-paths
     (list (search-path-specification
            (variable "EDOPRO_DATABASE_DIR")
            (files '("share/edopro/databases"))
            (separator #f))))
    (inputs (list edopro-irrlicht edopro-ocgcore edopro-lua
                  edopro-game-data edopro-cardscripts font-edopro-noto-sans-jp
                  bash-minimal coreutils mesa freetype
                  fmt-9 nlohmann-json
                  sdl2 sdl2-mixer sqlite libevent curl libgit2 libssh2
                  openssl zlib libjpeg-turbo libpng bzip2
                  libx11 libxi libxcursor libxrandr libxxf86vm))
    (arguments
     (list
      #:tests? #f ; Upstream provides no test target.
      #:make-flags #~(list "-C" "build" "AR=gcc-ar" "config=release_x64" "ygopro")
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              ;; The client must use the same features as the static renderer.
              (substitute* "gframe/premake5.lua"
                (("externalincludedirs \"/usr/include/irrlicht\"")
                 (string-append "externalincludedirs \"" #$edopro-irrlicht "/include/irrlicht\"\n"
                                "dofile(\"../irrlicht/defines.lua\")\n"
                                "links { \"X11\", \"GL\", \"z\", \"bz2\", \"png\", \"jpeg\", \"crypto\" }")))
              ;; Load profile databases directly so switching profiles also
              ;; switches card data without leaving stale user copies.
              (substitute* "gframe/data_handler.cpp"
                (("#include <irrlicht.h>" line)
                 (string-append line "\n#include <cstdlib>"))
                (("void DataHandler::LoadDatabases\\(\\) [{]" line)
                 (string-append
                  line "\n"
                  "    if (const char* dir = std::getenv(\"EDOPRO_DATABASE_DIR\")) {\n"
                  "        auto path = Utils::ToPathString(dir) + EPRO_TEXT(\"/\");\n"
                  "        for (const auto& file : Utils::FindFiles(path, { EPRO_TEXT(\"cdb\") }, 0)) {\n"
                  "            auto db = path + file;\n"
                  "            if (dataManager->LoadDB(db)) WindBot::AddDatabase(db);\n"
                  "        }\n"
                  "    }")))
              (setenv "CPLUS_INCLUDE_PATH"
                      (string-append (search-input-directory inputs "/include/freetype2")
                                     ":" (dirname (search-input-file inputs "/include/SDL2/SDL_stdinc.h"))
                                     ":" (getenv "CPLUS_INCLUDE_PATH")))
              (invoke "premake5" "--sound=sdl-mixer"
                      (string-append "--prebuilt-core=" #$edopro-ocgcore "/lib") "gmake")))
          (replace 'install
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((bin (string-append #$output "/bin"))
                    (lib (string-append #$output "/libexec")))
                (install-file (car (find-files "bin" "^ygopro$")) lib)
                (mkdir-p bin)
                ;; EDOPro reads resources and saves decks and replays under
                ;; the same directory.  Each user needs a writable copy,
                ;; and subsequent launches must preserve local edits.
                (call-with-output-file (string-append bin "/edopro")
                  (lambda (port)
                    (format port
                            (string-append
                             "#!~a~%"
                             "set -eu~%"
                             "dir=\"${XDG_DATA_HOME:-$HOME/.local/share}/edopro\"~%"
                             "~a -p \"$dir/fonts\"~%"
                             "~a -rn --no-preserve=mode ~a/share/fonts/opentype/. \"$dir/fonts/\"~%"
                             "~a -rn --no-preserve=mode ~a/share/edopro/{config,sound,textures} ~a/share/edopro/script \"$dir/\"~%"
                             "exec ~a/ygopro -C \"$dir\" \"$@\"~%")
                            (search-input-file inputs "/bin/bash")
                            (which "mkdir") (which "cp") #$font-edopro-noto-sans-jp
                            (which "cp") #$edopro-game-data #$edopro-cardscripts lib)))
                (chmod (string-append bin "/edopro") #o555)))))))
    (home-page "https://github.com/edo9300/edopro")
    (synopsis "Automatic Yu-Gi-Oh! duel simulator")
    (description "EDOPro provides a graphical deck editor and duel simulator
using the Project Ignis card engine.")
    (license (list license:agpl3+ license:gpl3+))))
