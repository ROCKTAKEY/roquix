(define-module (roquix packages feishin)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages python)
  #:use-module (gnu packages video)
  #:use-module (nongnu packages electron))

(define feishin-version "1.15.1")

(define feishin-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/jeffvli/feishin/tar.gz/refs/tags/v"
                        feishin-version))
    (file-name (string-append "feishin-" feishin-version ".tar.gz"))
    (sha256 (base32 "1w50d2kvdwmbh3dhsh218ck3haz4nrmkxz71mqdbv8j4q4wf8094"))))

(define pnpm-cli
  (origin
    (method url-fetch)
    (uri "https://registry.npmjs.org/pnpm/-/pnpm-11.5.2.tgz")
    (sha256 (base32 "169cd8zdr6jpdn0whsfd7w6pg16afz0k5bms2kjfkk9xpm7wb7bl"))))

(define (fetch-modules production?)
  (lambda* (source algorithm hash #:optional name #:key system #:allow-other-keys)
    (gexp->derivation
     name
     (with-imported-modules '((guix build utils))
       #~(begin
           (use-modules (guix build utils))
           (setenv "PATH" (string-append #+node "/bin:" #+tar "/bin:"
                                         #+gzip "/bin:" #+bash-minimal "/bin"))
           (setenv "SSL_CERT_FILE"
                   #+(file-append nss-certs "/etc/ssl/certs/ca-certificates.crt"))
           (setenv "HOME" (getcwd))
           (setenv "CI" "1")
           (invoke "tar" "xf" #+pnpm-cli)
           (invoke "tar" "xf" #+source "--strip-components=1")
           (apply invoke "node" "package/bin/pnpm.mjs" "install"
                  "--frozen-lockfile" "--ignore-scripts"
                  (if #$production?
                      '("--prod")
                      '("--config.prefer-symlinked-executables=true")))
           (apply invoke "tar" "--sort=name" "--mtime=@0" "--owner=0" "--group=0"
                   "--mode=u+rwX,go+rX,go-w" "--hard-dereference"
                   "--exclude=.modules.yaml"
                   "--exclude=.pnpm-workspace-state-v1.json"
                   "-cf" #$output
                   (append (if #$production? '("--exclude=.bin") '())
                           '("node_modules")))))
     #:system system #:hash-algo algorithm #:hash hash)))

(define (modules production? hash)
  (origin
    (method (fetch-modules production?))
    (uri feishin-source)
    (file-name (if production? "feishin-runtime-modules.tar" "feishin-build-modules.tar"))
    (sha256 hash)))

(define build-modules
  (modules #f (base32 "02msghcq7whlbvcnn9zpkw0q89qay9qxdnb6wlwr1r6drvv54bcs")))

(define runtime-modules
  (modules #t (base32 "1z715a7pjn21zhhsm2fwrga0qv16bhaf7qp482z0g3c16p2pnsfj")))

(define electron-headers
  (origin
    (method url-fetch)
    (uri (string-append "https://artifacts.electronjs.org/headers/dist/v"
                        (package-version electron-41) "/node-v"
                        (package-version electron-41) "-headers.tar.gz"))
    (sha256 (base32 "07gr77myqi1k5qvs7zlnr7y8d1avmbqac50xgkq8hnbalz4183sj"))))

(define-public feishin
  (package
    (name "feishin")
    (version feishin-version)
    (source feishin-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (setenv "HOME" (getcwd))
              (invoke "tar" "xf" #+build-modules)
              (invoke "tar" "xf" #+pnpm-cli)
              (symlink "pnpm.mjs" "package/bin/pnpm")
              (setenv "PATH" (string-append (getcwd) "/package/bin:" (getenv "PATH")))))
          (replace 'build
            (lambda _
              (mkdir "headers")
              (invoke "tar" "xf" #+electron-headers "--strip-components=1" "-C" "headers")
              (invoke "node" #+(file-append node "/lib/node_modules/npm/node_modules/node-gyp/bin/node-gyp.js")
                      "rebuild" (string-append "--nodedir=" (getcwd) "/headers")
                      "--directory=node_modules/.pnpm/abstract-socket@2.1.1/node_modules/abstract-socket")
              ;; The fixed-output dependency archive already matches the lockfile.
              (setenv "pnpm_config_verify_deps_before_run" "false")
              (invoke "pnpm" "run" "build")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (for-each (lambda (file) (unless (file-exists? file) (error "missing" file)))
                          '("out/main/index.js" "out/preload/index.js"
                            "out/renderer/index.html" "out/remote/remote.js")))))
          (replace 'validate-runpath
            (lambda* (#:key outputs #:allow-other-keys)
              ;; Nonguix's Electron launcher sets the runtime library paths.
              ((assoc-ref %standard-phases 'validate-runpath)
               #:outputs outputs
               #:elf-directories '("lib/feishin/resources/app"))))
          (replace 'install
            (lambda _
              (define root (string-append #$output "/lib/feishin"))
              (define runtime #$(file-append electron-41 "/share/electron"))
              (define app (string-append root "/resources/app"))
              (define addon "node_modules/.pnpm/abstract-socket@2.1.1/node_modules/abstract-socket")
              (define launcher (string-append #$output "/bin/feishin"))
              (mkdir-p app)
              (invoke "tar" "xf" #+runtime-modules "-C" app)
              ;; Electron supplies this module internally at runtime.  Its npm
              ;; installer includes unused native extractors for other systems.
              (for-each delete-file (find-files app "^index.*\\.node$"))
              (install-file (string-append addon "/build/Release/bindings.node")
                            (string-append app "/" addon "/build/Release"))
              (for-each (lambda (file) (copy-recursively file (string-append app "/" file)))
                        '("out" "package.json" "LICENSE"))
              (mkdir-p (dirname launcher))
              (for-each (lambda (file)
                          (unless (member file '("." ".." "resources" "electron"))
                            (symlink (string-append runtime "/" file)
                                     (string-append root "/" file))))
                        ((@ (ice-9 ftw) scandir) runtime))
              (copy-file (string-append runtime "/electron") (string-append root "/feishin"))
              (copy-recursively "assets" (string-append root "/resources/assets"))
              (copy-file #$(file-append electron-41 "/bin/electron") launcher)
              (substitute* launcher
                (((string-append runtime "/electron")) (string-append root "/feishin")))
              (wrap-program launcher
                `("PATH" ":" prefix (,#$(file-append mpv "/bin")))
                `("LD_LIBRARY_PATH" ":" prefix (,#$(file-append libsecret "/lib"))))
              (substitute* "feishin.desktop.tmpl"
                (("\\$\\{FEISHIN_DESKTOP_EXECUTABLE\\}") launcher)
                (("\\$\\{FEISHIN_DESKTOP_ARGS\\}") "%U"))
              (rename-file "feishin.desktop.tmpl" "org.jeffvli.feishin.desktop")
              (install-file "org.jeffvli.feishin.desktop" (string-append #$output "/share/applications"))
              (install-file "org.jeffvli.feishin.metainfo.xml"
                            (string-append #$output "/share/metainfo"))
              (rename-file "resources/icon.png" "org.jeffvli.feishin.png")
              (install-file "org.jeffvli.feishin.png" (string-append #$output "/share/pixmaps")))))))
    (native-inputs (list node python-minimal))
    (inputs (list bash-minimal))
    (home-page "https://github.com/jeffvli/feishin")
    (synopsis "Modern music player for self-hosted music servers")
    (description
     "Feishin is a desktop music player for Jellyfin, Navidrome, and
OpenSubsonic servers.  It supports local playback through mpv as well as web
playback.")
    (license license:gpl3)))
