(define-module (roquix packages orca)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (gcrypt base16)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages python)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages vulkan)
  #:use-module ((gnu packages web) #:select (jq))
  #:use-module (gnu packages xorg)
  #:use-module (nongnu packages electron)
  #:use-module ((roquix packages pnpm) #:prefix roquix:))

(define orca-version "1.4.266")

(define local-agents-patch
  (local-file (canonicalize-path
               (search-path %load-path "roquix/packages/orca/local-agents.patch"))))

(define orca-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/stablyai/orca/tar.gz/refs/tags/v"
                        orca-version))
    (file-name (string-append "orca-" orca-version ".tar.gz"))
    (sha256 (base32 "00nylrzli0hkc8nfmfggv2pbgfbd42b7mr8vr550v25a4m0ynvlw"))))

;; Only acquisition runs with network access. The tar contains dependency
;; files and workspace links, without install scripts or build-machine paths.
(define* (fetch-orca-modules source algorithm hash #:optional name
                             #:key (system (%current-system)) #:allow-other-keys)
  (gexp->derivation
   name
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" (string-append #+node "/bin:" #+tar "/bin:" #+gzip
                                       "/bin:" #+bash-minimal "/bin"))
         (setenv "SSL_CERT_FILE" #+(file-append nss-certs "/etc/ssl/certs/ca-certificates.crt"))
         (setenv "HOME" (getcwd))
         (setenv "CI" "1")
         (mkdir "source")
         (chdir "source")
         (invoke "tar" "xf" #+source "--strip-components=1")
         ;; Omit the Claude SDK and unused development tools
         ;; before fetching the build inputs.
         (invoke #+(file-append patch "/bin/patch") "-p1" "-i" #+local-agents-patch)
         (define (install-dependencies)
           (invoke #+(file-append roquix:pnpm "/bin/pnpm")
                   "install" "--frozen-lockfile" "--ignore-scripts"
                   "--store-dir" (string-append (getenv "HOME") "/store")))
         (install-dependencies)
         (with-directory-excursion "mobile" (install-dependencies))
         (invoke "tar" "--sort=name" "--mtime=@0" "--owner=0" "--group=0"
                 "--mode=u+rwX,go+rX,go-w" "--hard-dereference"
                 "--exclude=.bin" "--exclude=.modules.yaml"
                 "--exclude=.pnpm-workspace-state-v1.json"
                 ;; node-pty ships ConPTY twice in its cross-platform npm archive.
                 "--exclude=*/node-pty/third_party/conpty"
                 "--exclude=*/node-pty/prebuilds/win32-*"
                 "-cf" #$output "node_modules" "mobile/node_modules")))
   #:system system #:hash-algo algorithm #:hash hash #:local-build? #t))

(define orca-modules
  (origin
    (method fetch-orca-modules)
    (uri orca-source)
    (file-name (string-append "orca-modules-" orca-version ".tar"))
    (sha256 (base32 "08la8127c8mkccyz0b6fz5g7ax8pxfldm0f75wn166rlf1vzr0i8"))))

(define orca-electron
  (package
    (inherit electron-41)
    (version "43.8.10")
    (source
     (origin
       (method url-fetch/zipbomb)
       (uri (string-append "https://github.com/electron/electron/releases/download/v"
                           version "/electron-v" version "-linux-x64.zip"))
       (sha256 (base16-string->bytevector "657998e8d675aefd16f624b4771e7b9e8f6de34d6c11abfc9cf90d55894adc53"))))))

(define-public orca-ide
  (package
    (name "orca-ide")
    (version orca-version)
    (source orca-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux"))
    (native-inputs (list orca-modules jq patchelf python-minimal))
    (inputs (list orca-electron node-lts bash-minimal git ripgrep wayland
                  fontconfig gsettings-desktop-schemas vulkan-loader
                  libx11 libxext libxcb (list gcc "lib")))
    (arguments
     (list
      #:strip-binaries? #f
      #:phases
      #~(let ()
          (define lib (string-append #$output "/lib/orca-ide"))
          (define resources (string-append lib "/resources"))
          (define bin (string-append #$output "/bin"))
          (define (entries directory)
            ((@ (ice-9 ftw) scandir) directory (lambda (name) (not (member name '("." ".."))))))
          (define (copy-to source destination)
            (mkdir-p (dirname destination))
            (invoke "cp" "-RLT" source destination))
          (modify-phases %standard-phases
            ;; The upstream CLI verifier checks the original source shebang.
            (delete 'patch-source-shebangs)
            (replace 'configure
              (lambda _
                (invoke "patch" "-p1" "-i" #+local-agents-patch)
                (invoke "tar" "xf" #+orca-modules)
                ;; The release archive lacks Git metadata for the bundled skills.
                (substitute* "config/scripts/build-identity/build-source-commit.mjs"
                  (("commit = execFileSync.*\\.trim\\(\\)")
                   "commit = '903c91e80fbe7bbcaffe6ac767c49eac91e98a64'"))))
            (replace 'build
              (lambda _
                (define tsc "node_modules/typescript/bin/tsc")
                (invoke "node" tsc "-p" "src/packages/process-host/tsconfig.json" "--noCheck")
                (invoke "node" tsc "-p" "config/tsconfig.build.cli.json" "--outDir" "out"
                        "--composite" "false" "--incremental" "false" "--noCheck")
                (invoke "node" "config/scripts/cli-build/verify-cli-bin.mjs"
                        "--fix-executable" "--fix-package-json")
                (invoke "node" "node_modules/electron-vite/bin/electron-vite.js" "build")
                (for-each (lambda (script) (invoke "node" script))
                          '("config/scripts/desktop-build/output-contracts/preload-output-contract.mjs"
                            "config/scripts/remote-host-build/wsl-guest/build-wsl-guest.mjs"
                            "config/scripts/development/web-client/project-renderer-web-client.mjs"
                            "mobile/scripts/build-terminal-webview-engine.mjs"
                            "mobile/scripts/build-mermaid-page-engine.mjs"
                            "mobile/scripts/build-katex-page-style.mjs"
                            "mobile/scripts/build-terminal-document-script.mjs"
                            "config/scripts/build/mobile-web-app/build-mobile-web-app-bundle.mjs"
                            "config/scripts/build/mobile-web-app/verify-mobile-web-app-bundle.mjs"))))
            (add-after 'build 'build-native-modules
              (lambda _
                (invoke "node" "node_modules/node-gyp/bin/node-gyp.js" "rebuild"
                        "--directory=node_modules/@parcel/watcher"
                        (string-append "--nodedir=" #$node-lts))
                (invoke "g++" "-shared" "-fPIC" "-O2" "-std=c++20" "-DNAPI_CPP_EXCEPTIONS"
                        (string-append "-I" #$(file-append node-lts "/include/node"))
                        "-Inode_modules/node-pty/../node-addon-api"
                        "node_modules/node-pty/src/unix/pty.cc" "-lutil" "-pthread" "-o" "pty.node")
                (invoke "gcc" "-O2" "native/provider-exec/provider-exec.c" "-o" "orca-provider-exec")
                (invoke "gcc" "-O2" "native/journal-file-lock/main.c" "-o" "journal-file-lock")
                (invoke "gcc" "-O2" "native/wayland-clipboard/wayland-clipboard.c"
                        "native/wayland-clipboard/x11-clipboard-publisher.c" "-ldl"
                        "-o" "orca-wayland-clipboard")))
            (replace 'install
              (lambda _
                (define electron #$(file-append orca-electron "/share/electron"))
                (mkdir-p resources)
                (mkdir-p bin)
                (for-each
                 (lambda (name)
                   (let ((source (string-append electron "/" name))
                         (dest (string-append lib "/" name)))
                     (cond ((member name '("electron" "resources")) #t)
                           ((member name '("libEGL.so" "libGLESv2.so" "libffmpeg.so"))
                            (copy-file source dest))
                           (else (symlink source dest)))))
                 (entries electron))
                (copy-file (string-append electron "/electron") (string-append lib "/orca-ide"))
                (let ((desktop (string-append bin "/orca-desktop")))
                  (copy-file #$(file-append orca-electron "/bin/electron") desktop)
                  (chmod desktop #o755)
                  (substitute* desktop
                    (((string-append electron "/electron")) (string-append lib "/orca-ide"))))
                ;; Electron opens app.asar while Node workers use app.asar.unpacked.
                (mkdir "app")
                (rename-file "out" "app/out")
                (for-each delete-file (find-files "app/out" "\\.map$"))
                (copy-to "resources" "app/resources")
                (copy-file "LICENSE" "app/LICENSE")
                (with-output-to-file "app/package.json"
                  (lambda () (invoke "jq" "-cj" "{name, version, main}" "package.json")))
                (invoke "node" "node_modules/@electron/asar/bin/asar.js" "pack" "app"
                        (string-append resources "/app.asar") "--unpack" "**/*")
                (symlink #$node-lts (string-append resources "/node-runtime"))
                (mkdir-p (string-append resources "/ripgrep/linux-x64"))
                (symlink #$(file-append ripgrep "/bin/rg") (string-append resources "/ripgrep/linux-x64/rg"))
                (symlink "app.asar.unpacked/out/relay" (string-append resources "/relay"))
                (for-each (lambda (name)
                            (symlink (string-append "app.asar.unpacked/resources/" name)
                                     (string-append resources "/" name)))
                          '("skills" "plugins" "onboarding" "native-chat-visuals"))
                (install-file "native/computer-use-linux/runtime.py" (string-append resources "/computer-use-linux"))
                (for-each (lambda (file) (install-file file (string-append resources "/bin")))
                          '("resources/linux/bin/orca-ide" "orca-provider-exec"
                            "journal-file-lock" "orca-wayland-clipboard"))
                (symlink (string-append resources "/bin/orca-ide") (string-append bin "/orca-ide"))
                (copy-to "resources/icon.png" (string-append #$output "/share/pixmaps/orca-ide.png"))
                (mkdir-p (string-append #$output "/share/applications"))
                (call-with-output-file (string-append #$output "/share/applications/orca-ide.desktop")
                  (lambda (port)
                    (format port "[Desktop Entry]
Type=Application
Name=Orca
Exec=~a/orca-desktop %U
Icon=orca-ide
StartupWMClass=orca
MimeType=text/markdown;text/csv;text/tab-separated-values;x-scheme-handler/orca;
Categories=Development;IDE;
" bin)))))
            (add-after 'install 'install-runtime-dependencies
              (lambda* (#:key inputs #:allow-other-keys)
                (define (install-module source target)
                  (let ((dest (string-append resources "/" target)))
                    (unless (string-prefix? "node_modules/@parcel/watcher-" target)
                      (for-each
                       (lambda (name)
                         (cond
                          ((member name '("node_modules" "prebuilds")) #t)
                          ((and (string=? target "node_modules/@parcel/watcher")
                                (string=? name "build"))
                           (copy-to (string-append source "/build/Release/watcher.node")
                                    (string-append dest "/build/Release/watcher.node")))
                          (else (copy-to (string-append source "/" name)
                                         (string-append dest "/" name)))))
                       (if (string=? target "node_modules/@orca/process-host")
                           '("package.json" "dist")
                           (entries source))))))
                ;; Use Orca's Node resolver for transitive and platform-specific packages.
                (invoke "node" "-e"
                        "const runtime = require('./config/packaged-runtime-node-modules.cjs');
const modules = runtime.createPackagedRuntimeNodeModuleResources('linux');
require('node:fs').writeFileSync('runtime-modules', modules.map(({from,to}) => from+'\\t'+to).join('\\n'));
require('./config/packaged-transcribe-cpp.cjs').copyPackagedTranscribeCpp(
  runtime.readPackage, process.argv[1], 'linux', 'x64');" resources)
                (call-with-input-file "runtime-modules"
                  (lambda (port)
                    (let loop ((line ((@ (ice-9 rdelim) read-line) port)))
                      (unless (eof-object? line)
                        (apply install-module (string-split line #\tab))
                        (loop ((@ (ice-9 rdelim) read-line) port))))))
                (let ((pty (string-append resources "/node_modules/node-pty/build/Release")))
                  (install-file "pty.node" pty)
                  (symlink (string-append resources "/bin/journal-file-lock")
                           (string-append pty "/journal-file-lock")))
                (let ((emoji "node_modules/emojibase-data/en/shortcodes/emojibase.json"))
                  (copy-to emoji (string-append resources "/" emoji)))
                (copy-to "node_modules/agent-browser/skills/agent-browser"
                         (string-append resources "/skills/agent-browser"))
                (copy-to "node_modules/agent-browser/skill-data" (string-append resources "/skill-data"))
                (let ((browser (string-append resources "/agent-browser-linux-x64")))
                  (copy-file "node_modules/@agent-browser/cli-linux-x64-gnu/bin/agent-browser" browser)
                  (invoke "patchelf" "--set-interpreter" (search-input-file inputs "/lib/ld-linux-x86-64.so.2")
                          browser))))
            (add-after 'install-runtime-dependencies 'set-library-search-paths
              (lambda* (#:key inputs #:allow-other-keys)
                (let* ((modules (string-append resources "/node_modules"))
                       (speech (string-append modules "/@transcribe-cpp/linux-x64-cpu-vulkan"))
                       (ffi (string-append modules "/@koromix/koffi-linux-x64"))
                       (runpath (string-join
                                 (cons "$ORIGIN"
                                       (map (lambda (file)
                                              (dirname (search-input-file inputs file)))
                                            '("/lib/libc.so.6" "/lib/libgcc_s.so.1"
                                              "/lib/libX11.so.6" "/lib/libXext.so.6"
                                              "/lib/libxcb.so.1" "/lib/libvulkan.so.1")))
                                 ":")))
                  (delete-file-recursively (string-append ffi "/musl_x64"))
                  (for-each (lambda (file)
                              (chmod file #o755)
                              (invoke "patchelf" "--set-rpath" runpath file))
                            (append (find-files speech "\\.so$")
                                    (find-files ffi "\\.node$")
                                    (map (lambda (file) (string-append lib "/" file))
                                         '("libEGL.so" "libGLESv2.so" "libffmpeg.so")))))))
            (delete 'check)
            (add-after 'patch-shebangs 'check-installed-orca
              (lambda* (#:key tests? #:allow-other-keys)
                (when tests?
                  (invoke (string-append #$output "/bin/orca-ide") "--version")
                  (invoke (string-append #$output "/bin/orca-ide") "bot" "--help"))))
            (add-after 'set-library-search-paths 'wrap-desktop
              (lambda _
                (let ((desktop (string-append bin "/orca-desktop")))
                  (wrap-program desktop
                    `("PATH" ":" prefix (,(string-append #$git "/bin")))
                    `("FONTCONFIG_FILE" ":" = (,#$(file-append fontconfig "/etc/fonts/fonts.conf")))
                    `("XDG_DATA_DIRS" ":" suffix (,(string-append #$gsettings-desktop-schemas "/share")))))))))))
    (home-page "https://orca.dev")
    (synopsis "Development environment for running coding agents in parallel")
    (description
     "Orca manages coding agents, terminal sessions, Git worktrees, and bots.
This package builds the desktop application and CLI for local agents.")
    (license license:expat)))
