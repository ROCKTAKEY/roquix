(define-module (roquix packages hermes)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages python)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages version-control)
  #:use-module (nongnu packages electron)
  #:use-module (roquix packages hermes-wheel-inputs))

(define %hermes-version
  "0.22.5")
(define %hermes-source
  (origin
    (method url-fetch)
    (uri (string-append
          "https://codeload.github.com/NousResearch/hermes-agent/tar.gz/refs/tags/v"
          %hermes-version))
    (file-name (string-append "hermes-" %hermes-version ".tar.gz"))
    (sha256 (base32 "1cjfqpn7wjyxpwidzlhz22v2n01zapqpzk7nrqd6isjgq5g7xxm8"))))

(define (hermes-file name)
  (local-file (canonicalize-path (search-path %load-path
                                              (string-append
                                               "roquix/packages/hermes/" name)))))

(define %patch-elf
  (hermes-file "patch-elf.py"))

;; Match pm/lock.json's interpreter family and artifact.  The application lock
;; has Python >= 3.14 markers, so an older interpreter silently omits dependencies.
;; https://github.com/NousResearch/hermes-agent/blob/v0.22.5/nix/pythonLock.nix
(define hermes-python
  (package
    (name "hermes-python")
    (version "3.14.9")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://github.com/astral-sh/python-build-standalone/releases/download/20261021/cpython-3.14.9+20261021-x86_64-unknown-linux-gnu-install_only.tar.gz")
       (sha256
        (base32 "1pxba62bqgm09pxb3gz6j71lf8n7a3jpn0aq2vs3iws71jjcb96z"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:strip-binaries? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'build)
          (delete 'check)
          (replace 'install
            (lambda _
              (copy-recursively "."
                                #$output)
              (invoke "python3"
                      #$%patch-elf
                      #$output
                      #$(file-append glibc "/lib/ld-linux-x86-64.so.2")
                      #$(file-append glibc "/lib")
                      (string-append #$gcc:lib "/lib"))))
          (add-after 'install 'check-installed
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke (string-append #$output "/bin/python3") "-c"
                 "import ssl, sqlite3, ctypes, bz2, lzma; assert __import__('sys').version_info[:2] == (3, 14)")))))))
    (native-inputs (list python patchelf))
    (inputs (list (list "glibc" glibc)
                  (list "gcc:lib" gcc "lib")))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/astral-sh/python-build-standalone")
    (synopsis "Pinned Python runtime for Hermes")
    (description
     "This package supplies the CPython runtime selected by Hermes's package lock.")
    (license license:psfl)))

(define %hermes-npm
  (origin
    (method url-fetch)
    (uri "https://registry.npmjs.org/npm/-/npm-12.0.2.tgz")
    (sha256 (base32 "1qb4schnlvhwr90qsbdwkv6vsn3avn940wwh5rzrb8873p3qdfsx"))))

(define (hermes-node-modules-builder source)
  (with-imported-modules '((guix build utils))
                         #~(begin
                             (use-modules (guix build utils)
                                          (ice-9 ftw))
                             (setenv "PATH"
                                     (string-append #+node
                                                    "/bin:"
                                                    #+tar
                                                    "/bin:"
                                                    #+gzip
                                                    "/bin:"
                                                    #+bash-minimal
                                                    "/bin"))
                             (setenv "HOME"
                                     (string-append (getcwd) "/home"))
                             (mkdir-p (getenv "HOME"))
                             (setenv "SSL_CERT_FILE"
                                     #+(file-append nss-certs-for-test
                                        "/etc/ssl/certs/ca-certificates.crt"))
                             (setenv "NODE_EXTRA_CA_CERTS"
                                     (getenv "SSL_CERT_FILE"))
                             (mkdir "source")
                             (invoke "tar"
                                     "xf"
                                     #+source
                                     "--strip-components=1"
                                     "-C"
                                     "source")
                             (mkdir "npm")
                             (invoke "tar"
                                     "xf"
                                     #+%hermes-npm
                                     "--strip-components=1"
                                     "-C"
                                     "npm")
                             (let ((npm (string-append (getcwd)
                                                       "/npm/bin/npm-cli.js")))
                               (with-directory-excursion "source"
                                 (invoke "node"
                                         npm
                                         "ci"
                                         "--ignore-scripts"
                                         "--no-audit"
                                         "--no-fund"
                                         "--workspace"
                                         "apps/desktop"
                                         "--workspace"
                                         "apps/shared"
                                         "--workspace"
                                         "ui-tui"
                                         "--workspace"
                                         "ui-tui/packages/hermes-ink"
                                         "--workspace"
                                         "web")
                                 (mkdir-p #$output)
                                 (for-each (lambda (directory)
                                             (when (file-exists? directory)
                                               (call-with-output-file "/dev/null"
                                                 (lambda (port)
                                                   (copy-recursively directory
                                                    (string-append #$output
                                                                   "/"
                                                                   directory)
                                                    #:log port)))))
                                           '("node_modules"
                                             "apps/desktop/node_modules"
                                             "apps/shared/node_modules"
                                             "ui-tui/node_modules"
                                             "ui-tui/packages/hermes-ink/node_modules"
                                             "web/node_modules"))
                                 (delete-file (string-append #$output
                                               "/node_modules/.package-lock.json")))))))

(define* (hermes-node-modules-fetch source
                                    hash-algo
                                    hash
                                    #:optional name
                                    #:key (system (%current-system))
                                    #:allow-other-keys)
  (gexp->derivation (or name "hermes-node-modules")
                    (hermes-node-modules-builder source)
                    #:system system
                    #:hash-algo hash-algo
                    #:hash hash
                    #:recursive? #t
                    #:local-build? #t
                    #:leaked-env-vars '("http_proxy" "https_proxy"
                                        "HTTP_PROXY" "HTTPS_PROXY" "no_proxy"
                                        "NO_PROXY")))

(define %hermes-node-modules
  (origin
    (method hermes-node-modules-fetch)
    (uri %hermes-source)
    (sha256 (base32 "030cp1vvpa73fjw30bm2bm1djgcqsv9mfsv19pd04rj45plrzyvi"))))

(define-public hermes
  (package
    (name "hermes")
    (version %hermes-version)
    (source
     %hermes-source)
    (build-system gnu-build-system)
    (arguments
     (list
      #:strip-binaries? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'build)
          (delete 'check)
          (replace 'install
            (lambda* (#:key inputs #:allow-other-keys)
              (invoke "python3"
                      #$(hermes-file "install-cli.py")
                      #$output
                      #$(file-append hermes-python "/bin/python3")
                      #$version)
              (mkdir "wheels")
              (for-each (lambda (name)
                          (symlink (assoc-ref inputs name)
                                   (string-append "wheels/" name)))
                        '#$(map car hermes-wheel-inputs))
              (apply invoke
                     #$(file-append hermes-python "/bin/python3")
                     "-m"
                     "pip"
                     "install"
                     "--no-index"
                     "--no-deps"
                     "--no-compile"
                     "--target"
                     (string-append #$output "/lib/hermes/site-packages")
                     (map (lambda (name)
                            (string-append "wheels/" name))
                          '#$(map car hermes-wheel-inputs)))
              (invoke "python3"
                      #$%patch-elf
                      #$output
                      #$(file-append glibc "/lib/ld-linux-x86-64.so.2")
                      #$(file-append glibc "/lib")
                      #$(file-append zlib "/lib")
                      (string-append #$gcc:lib "/lib"))
              (for-each (lambda (command)
                          (substitute* (string-append #$output "/bin/" command)
                            (("#!/usr/bin/env bash")
                             (string-append "#!"
                                            #$bash-minimal "/bin/bash")))
                          (wrap-program (string-append #$output "/bin/"
                                                       command)
                            `("HERMES_PYTHON" =
                              (#$(file-append hermes-python "/bin/python3")))
                            `("HERMES_INSTALL_ROOT" =
                              (,(string-append #$output "/lib/hermes/source")))
                            `("HERMES_TUI_DIR" =
                              (#$(file-append hermes-frontends "/tui")))
                            `("HERMES_WEB_DIST" =
                              (#$(file-append hermes-frontends "/web")))
                            `("PATH" prefix
                              (,(string-append #$git-minimal "/bin") ,(string-append #$coreutils-minimal
                                                                       "/bin")
                               ,(string-append #$node "/bin")))
                            `("SSL_CERT_FILE" =
                              (#$(file-append nss-certs-for-test
                                  "/etc/ssl/certs/ca-certificates.crt")))))
                        '("hermes" "hermes-agent" "hermes-acp"))))
          (add-after 'install 'check-installed
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "python3"
                        #$(hermes-file "check-cli.py")
                        (string-append #$output "/bin/hermes")
                        #$version)))))))
    (native-inputs (append (list (list "hermes-python" hermes-python)
                                 (list "patchelf" patchelf))
                           hermes-wheel-inputs))
    (inputs (list (list "hermes-python" hermes-python)
                  (list "hermes-frontends" hermes-frontends)
                  (list "bash-minimal" bash-minimal)
                  (list "coreutils-minimal" coreutils-minimal)
                  (list "git-minimal" git-minimal)
                  (list "node" node)
                  (list "glibc" glibc)
                  (list "zlib" zlib)
                  (list "gcc:lib" gcc "lib")
                  (list "nss-certs-for-test" nss-certs-for-test)))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/NousResearch/hermes-agent")
    (synopsis "Hermes AI agent and command-line interface")
    (description
     "Hermes is an AI agent with tool use, persistent sessions, skills,
and a gateway for desktop and remote clients.")
    (license license:expat)))

(define hermes-frontends
  (package
    (inherit hermes)
    (name "hermes-frontends")
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-after 'unpack 'prepare-dependencies
            (lambda* (#:key inputs #:allow-other-keys)
              (call-with-output-file "/dev/null"
                (lambda (port)
                  (copy-recursively (assoc-ref inputs "node-modules") "."
                                    #:log port)))
              (invoke "chmod" "-R" "u+w" "node_modules")
              (invoke "python3"
                      #$%patch-elf
                      "node_modules"
                      #$(file-append glibc "/lib/ld-linux-x86-64.so.2")
                      #$(file-append glibc "/lib")
                      (string-append #$gcc:lib "/lib"))))
          (replace 'build
            (lambda _
              (invoke "node"
                      "scripts/build/tui.mjs"
                      "--source"
                      (getcwd)
                      "--out"
                      (string-append (getcwd) "/.build/tui"))
              (invoke "node"
                      "scripts/build/web.mjs"
                      "--source"
                      (getcwd)
                      "--out"
                      (string-append (getcwd) "/.build/web")
                      "--icons"
                      (getcwd))))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node" "--check" ".build/tui/dist/entry.js")
                (unless (file-exists? ".build/web/index.html")
                  (error "missing Hermes dashboard entry point")))))
          (replace 'install
            (lambda _
              (copy-recursively ".build/tui"
                                (string-append #$output "/tui"))
              (copy-recursively ".build/web"
                                (string-append #$output "/web")))))))
    (native-inputs (list (list "node" node)
                         (list "python" python)
                         (list "patchelf" patchelf)
                         (list "node-modules" %hermes-node-modules)))
    (inputs '())
    (synopsis "Prebuilt terminal and web interfaces for Hermes")))

(define hermes-electron
  (package
    (inherit electron-41)
    (version "44.9.3")
    (source
     (origin
       (method url-fetch/zipbomb)
       (uri
        "https://github.com/electron/electron/releases/download/v44.9.3/electron-v44.9.3-linux-x64.zip")
       (sha256
        (base32 "1x3d7v1by6i3nlrs11iycnqy25xxwbk4mkkahixm0hnla3ad4zvf"))))))

(define %hermes-electron-headers
  (origin
    (method url-fetch)
    (uri
     "https://artifacts.electronjs.org/headers/dist/v44.9.3/node-v44.9.3-headers.tar.gz")
    (sha256 (base32 "0407cifcglw45p59h8pfbfff84d2ii79hz9zsb4l5576f0gawxaz"))))

(define (make-hermes-desktop light?)
  (package
    (inherit hermes)
    (name (if light? "hermes-desktop-light" "hermes-desktop"))
    (arguments
     (list
      #:strip-binaries? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-after 'unpack 'prepare-dependencies
            (lambda* (#:key inputs #:allow-other-keys)
              (setenv "HOME"
                      (string-append (getcwd) "/home"))
              (mkdir-p (getenv "HOME"))
              (setenv "NODE_OPTIONS" "--max-old-space-size=8192")
              (mkdir "build-tools")
              (symlink (which "gcc") "build-tools/cc")
              (setenv "PATH"
                      (string-append (getcwd) "/build-tools:"
                                     (getenv "PATH")))
              ;; The upstream Light stamp classifies the artifact, but its
              ;; source resolver and onboarding still offer local installation.
              (when #$light?
                (invoke "patch" "-p1" "-i"
                        #$(hermes-file "light-remote-only.patch")))
              (copy-recursively (assoc-ref inputs "node-modules") ".")
              (invoke "chmod" "-R" "u+w" "node_modules")
              (mkdir "npm")
              (invoke "tar"
                      "xf"
                      #$%hermes-npm
                      "--strip-components=1"
                      "-C"
                      "npm")
              (mkdir "electron-headers")
              (invoke "tar"
                      "xf"
                      #$%hermes-electron-headers
                      "--strip-components=1"
                      "-C"
                      "electron-headers")
              (invoke "python3"
                      #$%patch-elf
                      "node_modules"
                      #$(file-append glibc "/lib/ld-linux-x86-64.so.2")
                      #$(file-append glibc "/lib")
                      (string-append #$gcc:lib "/lib"))
              (invoke "node"
                      "npm/node_modules/node-gyp/bin/node-gyp.js"
                      "rebuild"
                      "--directory=node_modules/node-pty"
                      (string-append "--nodedir="
                                     (getcwd) "/electron-headers")
                      "--build-from-source"
                      "--runtime=electron"
                      "--target=44.9.3")
              (invoke "python3"
                      #$(hermes-file "prepare-desktop.py")
                      #$%hermes-version
                      #$(if light? "light" "bootstrap"))))
          (replace 'build
            (lambda _
              (invoke "node"
                      "apps/desktop/scripts/stage-native-deps.mjs"
                      "--source"
                      (getcwd)
                      "--out"
                      "apps/desktop/build/native-deps"
                      "--platform"
                      "linux"
                      "--arch"
                      "x64")
              (invoke "node"
                      "scripts/build/desktop.mjs"
                      "--source"
                      (getcwd)
                      "--out"
                      "apps/desktop/dist"
                      "--icons"
                      (getcwd)
                      "--stamp"
                      "install-stamp.json"
                      "--native-deps"
                      "apps/desktop/build/native-deps"
                      "--platform"
                      "linux")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (with-directory-excursion "apps/desktop"
                  (invoke "node" "scripts/assert-dist-built.mjs")))))
          (replace 'install
            (lambda _
              (let* ((command #$(if light? "hermes-desktop-light"
                                    "hermes-desktop"))
                     (app (string-append #$output "/share/" command))
                     (bin (string-append #$output "/bin/" command))
                     (icon (string-append #$output "/share/pixmaps/" command
                                          ".png")))
                (mkdir-p app)
                (copy-recursively "apps/desktop/dist"
                                  (string-append app "/dist"))
                (copy-file "apps/desktop/package.json"
                           (string-append app "/package.json"))
                (copy-file "install-stamp.json"
                           (string-append app "/install-stamp.json"))
                (copy-recursively "apps/desktop/assets"
                                  (string-append app "/assets"))
                (substitute* (string-append app "/dist/electron-main.mjs")
                  (("process.resourcesPath")
                   (format #f "~s" app)))
                (mkdir-p (dirname bin))
                (call-with-output-file bin
                  (lambda (port)
                    (format port
                            (string-append "#!~a/bin/bash~%"
                                           "exec ~a/bin/electron ~s \"$@\"~%")
                            #$bash-minimal
                            #$hermes-electron app)))
                (chmod bin #o755)
                (apply wrap-program bin
                       (append (if #$light?
                                   '()
                                   `(("HERMES_DESKTOP_HERMES" =
                                      (#$(if light? ""
                                             (file-append hermes "/bin/hermes"))))))
                               `(("PATH" prefix
                                  (#$(file-append git-minimal "/bin")
                                   #$(file-append openssh "/bin")
                                   #$(file-append xdg-utils "/bin")
                                   #$(file-append desktop-file-utils "/bin")))
                                 ("HERMES_DESKTOP_APP_NAME" =
                                  (#$(if light? "Hermes Light" "Hermes")))
                                 ("FONTCONFIG_FILE" =
                                  (#$(file-append fontconfig
                                                  "/etc/fonts/fonts.conf")))
                                 ("FONTCONFIG_PATH" =
                                  (#$(file-append fontconfig "/etc/fonts")))
                                 ("GDK_PIXBUF_MODULE_FILE" =
                                  (#$(file-append gtk+
                                      "/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache")))
                                 ("GSETTINGS_SCHEMA_DIR" =
                                  (#$(file-append gtk+
                                                  "/share/glib-2.0/schemas")))
                                 ("XDG_DATA_DIRS" prefix
                                  (#$(file-append shared-mime-info "/share"))))))
                (mkdir-p (dirname icon))
                (copy-file "apps/desktop/assets/icon.png" icon)
                (mkdir-p (string-append #$output "/share/applications"))
                (call-with-output-file (string-append #$output
                                                      "/share/applications/"
                                                      command ".desktop")
                  (lambda (port)
                    (format port
                            (string-append
                             "[Desktop Entry]~%Type=Application~%Name=~a~%"
                             "Exec=~a %U~%Icon=~a~%StartupWMClass=~a~%"
                             "Terminal=false~%Categories=Development;~%")
                            #$(if light? "Hermes Light" "Hermes")
                            bin
                            icon
                            #$(if light? "hermes-light" "hermes"))))))))))
    (native-inputs (list (list "node" node)
                         (list "python" python)
                         (list "patchelf" patchelf)
                         (list "pkg-config" pkg-config)
                         (list "node-modules" %hermes-node-modules)))
    (inputs (list (list "bash-minimal" bash-minimal)
                  (list "electron" hermes-electron)
                  (list "glibc" glibc)
                  (list "gcc:lib" gcc "lib")
                  (list "fontconfig-minimal" fontconfig)
                  (list "gtk+" gtk+)
                  (list "shared-mime-info" shared-mime-info)
                  (list "git-minimal" git-minimal)
                  (list "openssh" openssh)
                  (list "xdg-utils" xdg-utils)
                  (list "desktop-file-utils" desktop-file-utils)
                  (list "libx11" libx11)
                  (list "libxi" libxi)))
    (propagated-inputs (if light?
                           '()
                           (list hermes)))
    (synopsis (if light? "Remote client for Hermes Agent"
                  "Desktop interface for Hermes Agent"))
    (description (if light?
                  "Hermes Light connects to a remote Hermes gateway without
installing a local agent."
                  "Hermes Desktop provides a graphical interface to the packaged
Hermes agent and remote gateways."))))

(define-public hermes-desktop
  (make-hermes-desktop #f))
(define-public hermes-desktop-light
  (make-hermes-desktop #t))
