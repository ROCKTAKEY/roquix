(define-module (roquix packages t3code)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages audio)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages cups)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages guile)
  #:use-module (gnu packages libffi)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages ssh)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xml)
  #:use-module (srfi srfi-9)
  #:use-module (guix utils)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages node)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages zig)
  #:use-module (nongnu packages electron))

(define %t3code-version
  "0.0.44")

(define %t3code-source
  (origin
    (method url-fetch)
    (uri (string-append
          "https://codeload.github.com/pingdotgg/t3code/tar.gz/refs/tags/v"
          %t3code-version))
    (file-name (string-append "t3code-" %t3code-version ".tar.gz"))
    (sha256 (base32 "0hmv83j46nq3bmmr0nc9bva2jmniwf7knsngpadszq4ip93cry0z"))))

(define* (native-library name
                         version
                         repository
                         commit
                         hash
                         directory
                         member
                         library
                         filename
                         #:key (tests? #f)
                         (features '())
                         (license-value license:expat))
  (package
    (name name)
    (version version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://codeload.github.com/" repository
                           "/tar.gz/" commit))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 hash))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.95
      #:install-source? #f
      #:features `',features
      ;; Node-API addons need a Node host. Runtime APIs are exercised by
      ;; the application's check-installed phase; build tools run during its build.
      #:tests? tests?
      #:cargo-build-flags `'("--release" "--package"
                             ,member)
      #:cargo-test-flags `'("--package" ,member "--lib")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'enter-library
            (lambda _
              (chdir #$directory)))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((destination (string-append (assoc-ref outputs "out")
                                                "/lib")))
                (mkdir-p destination)
                (copy-file #$(string-append "target/release/" library)
                           (string-append destination "/"
                                          #$filename))))))))
    (inputs (cargo-inputs (string->symbol name)
                          #:module '(roquix packages rust-crates)))
    (home-page (string-append "https://github.com/" repository))
    (synopsis "Native library for T3 Code")
    (description
     "This package builds a native T3 Code dependency from source.")
    (license license-value)))

;; Match npm's gitHead, rather than assuming the Git tag includes the npm release.
;; https://registry.npmjs.org/@ff-labs/fff-node/0.9.4
(define t3code-fff-native
  (native-library "t3code-fff-native"
                  "0.9.4"
                  "dmtrKovalenko/fff"
                  "7d7910b6ba78ea8406671eaac8cdb5eb9850d9d1"
                  "0zrhp8axn4bgg89wyb0d01qk2lfk1ljl3ap244mrjhf6sm2m2v7n"
                  "."
                  "fff-c"
                  "libfff_c.so"
                  "libfff_c.so"
                  #:tests? #t))

(define t3code-ffi-native
  (let ((library (native-library "t3code-ffi-native"
                  "1.3.2"
                  "zhangyuang/node-ffi-rs"
                  "9c5ba3452d8cedbb0b30c7ce4dd0138135bd06ea"
                  "0ai108349k7p4if4ss9n3i37q38dz8llcnj7ddj7hcjc210yyjmb"
                  "."
                  "ffi-rs"
                  "libffi_rs.so"
                  "ffi-rs.linux-x64-gnu.node"
                  #:features '("libffi-sys/system"))))
    (package
      (inherit library)
      ;; Use Guix's source-built libffi rather than the crate's FHS configure script.
      (inputs (cons (list "libffi" libffi)
                    (package-inputs library))))))

(define t3code-keyring-native
  (native-library "t3code-keyring-native"
                  "1.3.0"
                  "Brooooooklyn/keyring-node"
                  "e46be75c3ba8d5fde6b88a17c6153b87ffe4b946"
                  "0s52pmbg6swqc3wa8l80xmd50qzjd5hl3sybzs74nlalzaj3pvxb"
                  "."
                  "napi-keyring"
                  "libnapi_keyring.so"
                  "keyring.linux-x64-gnu.node"))

(define t3code-xa11y-native
  (let ((library (native-library "t3code-xa11y-native"
                  "0.13.0"
                  "xa11y/xa11y"
                  "6c3a5878e5e9a36942144854914985dbc7aaaf88"
                  "040sc9f0b28jybp2ads18fhjn2gk80w81zhndrh04fd8zd9yaclx"
                  "xa11y-js"
                  "xa11y-js"
                  "libxa11y_js.so"
                  "xa11y.linux-x64-gnu.node")))
    (package
      (inherit library)
      (native-inputs (list pkg-config))
      (inputs (cons (list "libxkbcommon" libxkbcommon)
                    (package-inputs library))))))

(define %rolldown-source
  (origin
    (method url-fetch)
    (uri
     "https://codeload.github.com/rolldown/rolldown/tar.gz/5b4746e442989d770c606ce08d2737e6aafbd25d")
    (file-name "t3code-vite-plus-rolldown.tar.gz")
    (sha256 (base32 "1b2qsb91k5avlbi4yifl52lgxadyjgjgd0ccfln54lks9n1s8fi0"))))

(define %vite-task-source
  (origin
    (method url-fetch)
    (uri
     "https://codeload.github.com/voidzero-dev/vite-task/tar.gz/d05b1dcdbaabaa69643ee0b89cebe3cd390957e9")
    (file-name "t3code-vite-task.tar.gz")
    (sha256 (base32 "105avw30wqjpz9xgzrm2f16rfsns3xm1yrj0izdy1r7yhjcr21yl"))))

(define t3code-vite-plus-native
  (let ((library (native-library "t3code-vite-plus-native"
                  "0.3.3"
                  "voidzero-dev/vite-plus"
                  "v0.3.3"
                  "1ijkifs9wia2mfk1v1yjdbma024mz2h9nzkk6ij2gda1i6zxalsv"
                  "."
                  "vite-plus-cli"
                  "libvite_plus_cli.so"
                  "vite-plus.linux-x64-gnu.node"
                  #:features '("rolldown"))))
    (package
      (inherit library)
      (arguments
       (substitute-keyword-arguments (package-arguments library)
         ;; Oxc's declared MSRV is 1.96, but its consumed code builds with
         ;; Guix's 1.95 compiler after the C-variadic adaptation below.
         ((#:cargo-build-flags flags)
          `(append ,flags
                   '("--ignore-rust-version")))
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-after 'unpack 'prepare-component-sources
                (lambda* (#:key inputs #:allow-other-keys)
                  ;; Vite Task's unpublished members omit version requirements,
                  ;; so cargo package cannot normalize them into registry crates.
                  ;; Keep its workspace separate to preserve inherited manifests.
                  ;; https://github.com/voidzero-dev/vite-task/blob/d05b1dcdbaabaa69643ee0b89cebe3cd390957e9/crates/fspy/Cargo.toml
                  (mkdir "rolldown")
                  (invoke "tar"
                          "xf"
                          (assoc-ref inputs "rolldown-source")
                          "--strip-components=1"
                          "-C"
                          "rolldown")
                  (mkdir "../vite-task")
                  (invoke "tar"
                          "xf"
                          (assoc-ref inputs "vite-task-source")
                          "--strip-components=1"
                          "-C"
                          "../vite-task")
                  (substitute* "Cargo.toml"
                    (("^([a-z_]+) = \\{ git = \"https://github.com/voidzero-dev/vite-task.git\", rev = \"[^\"]+\" \\}"
                      _ name)
                     (string-append name " = { path = \"../vite-task/crates/"
                                    name "\" }")))
                  (substitute* "../vite-task/Cargo.toml"
                    (("git = \"https://github.com/polachok/passfd\", rev = \"[^\"]+\"")
                     "version = \"0.2.0\"")
                    (("git = \"https://github.com/rust-vmm/seccompiler\", rev = \"[^\"]+\"")
                     "version = \"0.5.0\""))
                  ;; Rust 1.95 exposes C variadics behind a feature gate and
                  ;; names VaList's extraction method arg instead of next_arg.
                  ;; https://github.com/rust-lang/rust/blob/1.95.0/library/core/src/ffi/va_list.rs
                  (let ((preload "../vite-task/crates/fspy_preload_unix/src"))
                    (substitute* (string-append preload "/lib.rs")
                      (("^// Compile")
                       "#![feature(c_variadic)]\n\n// Compile"))
                    (substitute* (find-files preload "\\.rs$")
                      (("\\.next_arg")
                       ".arg")))
                  ;; Artifact dependencies and tracked proc-macro inputs still
                  ;; require gated features, as in upstream's nightly build.
                  (setenv "RUSTC_BOOTSTRAP" "1")
                  (setenv "WORKSPACE_DIR"
                          (string-append (getcwd) "/rolldown"))
                  (setenv "RUSTFLAGS" "--cfg tokio_unstable")))
              (add-after 'unpack-rust-crates 'exclude-component-workspaces
                (lambda _
                  ;; Cargo's registry directory accepts individual crates,
                  ;; whereas these component archives contain workspaces.
                  (delete-file-recursively
                   "guix-vendor/t3code-vite-task.tar.gz")
                  (delete-file-recursively
                   "guix-vendor/t3code-vite-plus-rolldown.tar.gz")))
              (add-after 'configure 'enable-artifact-dependencies
                (lambda _
                  (let ((port (open-file ".cargo/config" "a")))
                    (display "\n[unstable]\nbindeps = true\n" port)
                    (close-port port))))))))
      (native-inputs (list (list "cmake" cmake-minimal)
                           (list "pkg-config" pkg-config)
                           (list "rolldown-source" %rolldown-source)
                           (list "vite-task-source" %vite-task-source)))
      (inputs (append (list (list "zstd" zstd "lib")
                            (list "sqlite" sqlite))
                      (package-inputs library))))))

(define t3code-tailwind-native
  (native-library "t3code-tailwind-native"
                  "4.3.3"
                  "tailwindlabs/tailwindcss"
                  "v4.3.3"
                  "0vmyl9fxx2ykvva58s19gkjm9w8l1hgdvcnayvl8fljhjcjcw0p7"
                  "."
                  "tailwind-oxide"
                  "libtailwind_oxide.so"
                  "tailwindcss-oxide.linux-x64-gnu.node"))

(define t3code-lightningcss-native
  (native-library "t3code-lightningcss-native"
                  "1.33.0"
                  "parcel-bundler/lightningcss"
                  "1d680fa14e9a089c92dc0929f869d6757ae91c30"
                  "1d0vwp2135ibqgyz803czrjslg6hvd2sn2440n2pybxaym17ydxb"
                  "."
                  "lightningcss_node"
                  "liblightningcss_node.so"
                  "lightningcss.linux-x64-gnu.node"
                  #:license-value license:mpl2.0))

(define pnpm-for-t3code
  (package
    (name "pnpm-for-t3code")
    (version "11.10.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://registry.npmjs.org/pnpm/-/pnpm-" version
                           ".tgz"))
       (sha256
        (base32 "0cblc5s9lzica9mlhgp0441is1vryhrqgafhlrbgqqjgx82nc2v2"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("." "lib/pnpm/"))))
    (home-page "https://pnpm.io")
    (synopsis "Package manager for T3 Code's locked workspace")
    (description
     "This build tool installs the pnpm version selected by T3 Code.")
    (license license:expat)))

(define electron-for-t3code
  (package
    (inherit electron-41)
    (version "44.4.2")
    (source
     (origin
       (method url-fetch/zipbomb)
       (uri (string-append
             "https://github.com/electron/electron/releases/download/v"
             version "/electron-v" version "-linux-x64.zip"))
       (sha256
        (base32 "0dily7qrqh0mcfpb5rvxsvzwraczix3r1c3jz13scafsfwz0cwdd"))))))

(define %ghostty-revision
  "9f62873bf195e4d8a762d768a1405a5f2f7b1697")
(define %ghostty-source
  (origin
    (method url-fetch)
    (uri (string-append
          "https://codeload.github.com/ghostty-org/ghostty/tar.gz/"
          %ghostty-revision))
    (file-name (string-append "ghostty-" %ghostty-revision ".tar.gz"))
    (sha256 (base32 "09njhqahvh5qlw22ms07kcr275wbx0n65kbdiv4ggk87df3qriqn"))))

(define %spdx-licenses
  (origin
    (method url-fetch)
    ;; Match scripts/lib/third-party-licenses.ts, including its cache version.
    (uri
     "https://codeload.github.com/spdx/license-list-data/tar.gz/c4a7237ec8f4654e867546f9f409749300f1bf4c")
    (file-name "spdx-license-list-data-v3.28.0.tar.gz")
    (sha256 (base32 "0cia6f2cadcfx0nmnbr5jb24j0mvd457rfrys1prwhzgik89snpb"))))

(define-record-type <t3code-dependency-reference>
  (make-t3code-dependency-reference source) t3code-dependency-reference?
  (source t3code-dependency-reference-source))

;; Only dependency acquisition has network access.  The application is built
;; in a regular Guix derivation from these content-addressed caches.
(define %t3code-cache-helpers
  #~(begin
      (define (unpack-source source)
        (mkdir "source")
        (invoke "tar"
                "xf"
                source
                "--strip-components=1"
                "-C"
                "source"))
      (define (copy-cache source destination)
        ;; Listing every dependency file hides the package manager's useful output.
        (call-with-output-file "/dev/null"
          (lambda (port)
            (copy-recursively source destination
                              #:log port))))))

(define (t3code-node-modules-builder source)
  (with-imported-modules '((guix build utils))
    #~(begin
        (use-modules (guix build utils)
                     (ice-9 ftw)
                     (ice-9 regex)
                     (ice-9 textual-ports)
                     (srfi srfi-1)
                     (srfi srfi-13))
        #$%t3code-cache-helpers

        (define (fetch-node-modules source output node pnpm)
          (setenv "HOME"
                  (string-append (getcwd) "/home"))
          (mkdir-p (getenv "HOME"))
          (unpack-source source)
          (with-directory-excursion "source"
            (invoke node
                    pnpm
                    "--filter"
                    "@t3tools/desktop..."
                    "--filter"
                    "t3..."
                    "--filter"
                    "@t3tools/scripts..."
                    "--filter"
                    "@t3tools/monorepo"
                    "install"
                    "--frozen-lockfile"
                    "--ignore-scripts"
                    "--store-dir"
                    "../store")
            (mkdir-p output)
            (copy-cache "node_modules"
                        (string-append output "/node_modules"))
            (copy-cache "scripts/node_modules"
                        (string-append output "/scripts/node_modules"))
            (for-each (lambda (parent)
                        (for-each (lambda (child)
                                    (let ((directory (string-append parent "/"
                                                      child "/node_modules")))
                                      (when (file-exists? directory)
                                        (copy-cache directory
                                                    (string-append output "/"
                                                                   directory)))))
                                  (scandir parent
                                           (lambda (file)
                                             (not (member file
                                                          '("." "..")))))))
                      '("apps" "packages" "infra"))
            ;; pnpm's shims contain the temporary installation directory.  Normalize
            ;; it before hashing, then restore it in the build tree.
            (for-each (lambda (file)
                        (when (string-contains file "/.bin/")
                          (substitute* file
                            (((regexp-quote (getcwd)))
                             "@T3CODE_SOURCE_ROOT@"))))
                      (find-files output ".*"))
            ;; Install-manager records contain paths and timestamps; the compiler
            ;; consumes the actual module graph instead.
            (for-each (lambda (name)
                        (delete-file (string-append output "/node_modules/" name)))
                      '(".modules.yaml" ".pnpm-workspace-state-v1.json"))))

        (setenv "PATH"
                (string-append #+node
                               "/bin:"
                               #+tar
                               "/bin:"
                               #+gzip
                               "/bin:"
                               #+bash-minimal
                               "/bin"))
        (setenv "SSL_CERT_FILE"
                #+(file-append nss-certs-for-test
                               "/etc/ssl/certs/ca-certificates.crt"))
        (fetch-node-modules #+source
                            #$output
                            #+(file-append node "/bin/node")
                            #+(file-append pnpm-for-t3code
                                           "/lib/pnpm/bin/pnpm.cjs")))))

(define* (t3code-node-modules-fetch ref hash-algo hash
                                    #:optional name
                                    #:key (system (%current-system))
                                    #:allow-other-keys)
  (let ((source (t3code-dependency-reference-source ref)))
    (gexp->derivation (or name "t3code-node-modules")
                      (t3code-node-modules-builder source)
                      #:system system
                      #:hash-algo hash-algo
                      #:hash hash
                      #:recursive? #t
                      #:local-build? #t
                      #:leaked-env-vars '("http_proxy" "https_proxy"
                                          "HTTP_PROXY" "HTTPS_PROXY"
                                          "no_proxy" "NO_PROXY"))))

(define %t3code-node-modules
  (origin
    (method t3code-node-modules-fetch)
    (uri (make-t3code-dependency-reference %t3code-source))
    (file-name (string-append "t3code-node-modules-" %t3code-version))
    (sha256 (base32 "0jb2nahqjkpwib93lnlhpdvc7aq3qa1a60q584pq66dhrzgjx384"))))

(define (ghostty-dependencies-builder source)
  (with-imported-modules '((guix build utils))
    #~(begin
        (use-modules (guix build utils)
                     (ice-9 ftw)
                     (ice-9 regex)
                     (ice-9 textual-ports)
                     (srfi srfi-1)
                     (srfi srfi-13))
        #$%t3code-cache-helpers

        (define (dependency-urls file)
          (let ((text (call-with-input-file file
                        get-string-all))
                (pattern (make-regexp "^[ \t]*\\.url = \"([^\"]+)\""
                                      regexp/newline)))
            (let loop ((start 0) (result '()))
              (let ((match (regexp-exec pattern text start)))
                (if match
                    (loop (match:end match)
                          (cons (match:substring match 1) result))
                    result)))))

        (define (fetch-ghostty-dependencies source output zig curl)
          (setenv "HOME"
                  (getcwd))
          (setenv "ZIG_GLOBAL_CACHE_DIR"
                  (string-append (getcwd) "/cache"))
          (unpack-source source)
          ;; Zig 0.15's downloader ignores SSL_CERT_FILE.  curl uses Guix's CA bundle;
          ;; zig fetch computes the same package identity from the local archive.
          ;; https://github.com/ziglang/zig/blob/0.15.2/lib/std/crypto/Certificate/Bundle.zig
          (let ((git-url (make-regexp
                          "^git\\+https://github.com/([^/]+/[^#]+)#([0-9a-f]{40})$"))
                (fetched '()))
            (mkdir "downloads")
            (let loop ()
              (let ((pending
                     (lset-difference
                      string=?
                      (delete-duplicates
                       (append-map dependency-urls
                                   (append
                                    (find-files "source" "build\\.zig\\.zon$")
                                    (if (file-exists? "cache/p")
                                        (find-files "cache/p" "build\\.zig\\.zon$")
                                        '())))
                       string=?)
                      fetched)))
                (unless (null? pending)
                  (for-each (lambda (url)
                              (let* ((match (regexp-exec git-url url))
                                     (download-url (if match
                                                       (string-append
                                                        "https://codeload.github.com/"
                                                        (match:substring match 1)
                                                        "/tar.gz/"
                                                        (match:substring match 2))
                                                       url))
                                     (archive (string-append (getcwd)
                                                             "/downloads/"
                                                             (number->string (length
                                                                              fetched))
                                                             "-"
                                                             (if match
                                                                 "source.tar.gz"
                                                                 (basename url)))))
                                (invoke curl
                                        "-fL"
                                        "--retry"
                                        "3"
                                        download-url
                                        "-o"
                                        archive)
                                (invoke zig "fetch" archive)
                                (set! fetched
                                      (cons url fetched))))
                            pending)
                  (loop)))))
          (copy-cache "cache/p" output))

        (setenv "PATH"
                (string-append #+tar "/bin:"
                               #+gzip "/bin"))
        (setenv "SSL_CERT_FILE"
                #+(file-append nss-certs-for-test
                               "/etc/ssl/certs/ca-certificates.crt"))
        (fetch-ghostty-dependencies #+source
                                    #$output
                                    #+(file-append zig-0.15 "/bin/zig")
                                    #+(file-append curl "/bin/curl")))))

(define* (ghostty-dependencies-fetch ref hash-algo hash
                                    #:optional name
                                    #:key (system (%current-system))
                                    #:allow-other-keys)
  (let ((source (t3code-dependency-reference-source ref)))
    (gexp->derivation (or name "t3code-ghostty-dependencies")
                      (ghostty-dependencies-builder source)
                      #:system system
                      #:hash-algo hash-algo
                      #:hash hash
                      #:recursive? #t
                      #:local-build? #t
                      #:leaked-env-vars '("http_proxy" "https_proxy"
                                          "HTTP_PROXY" "HTTPS_PROXY"
                                          "no_proxy" "NO_PROXY"))))

(define %ghostty-dependencies
  (origin
    (method ghostty-dependencies-fetch)
    (uri (make-t3code-dependency-reference %ghostty-source))
    (file-name "t3code-ghostty-dependencies")
    (sha256 (base32 "1bd9x5bfncgqlzs946bgaslm79q3qhpy81wnggq1pz3kgmslpfkh"))))

(define (t3code-native-helper name directory)
  (package
    (name name)
    (version %t3code-version)
    (source
     %t3code-source)
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.95
      #:install-source? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'enter-helper
            (lambda _
              (chdir #$(string-append "native/" directory)))))))
    (inputs (cargo-inputs (string->symbol name)
                          #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/pingdotgg/t3code")
    (synopsis "Native helper for T3 Code")
    (description "This package builds a T3 Code native helper from source.")
    (license license:expat)))

(define t3-resource-monitor
  (t3code-native-helper "t3-resource-monitor" "resource-monitor"))
(define t3-hyprland-snap-shot
  (t3code-native-helper "t3-hyprland-snap-shot" "hyprland-snap-shot"))
(define t3-kde-snap-shot
  (let ((helper (t3code-native-helper "t3-kde-snap-shot" "kde-snap-shot")))
    (package
      (inherit helper)
      (native-inputs (list dbus)))))

(define %t3code-runtime-dependencies-script
  (local-file (canonicalize-path (search-path %load-path
                  "roquix/packages/aux-files/t3code-runtime-dependencies.mjs"))))

(define %t3code-installed-tests
  (local-file (canonicalize-path (dirname (search-path %load-path
                  "roquix/packages/aux-files/t3code/check-installed")))
              #:recursive? #t))

(define* (t3code-build-phases version ghostty-revision dependencies-script
                              #:key (desktop? #t))
  (with-extensions (list guile-json-4)
    #~(let ()
        (define (command-output . arguments)
          (let* ((port (apply open-pipe* OPEN_READ arguments))
                 (text (get-string-all port))
                 (status (close-pipe port)))
            (unless (zero? status)
              (error "command failed" arguments status))
            (string-trim-right text)))

        (define (patch-native-files directory inputs)
          ;; Build tools have library directories too.  Adding them here would retain
          ;; the Zig/LLVM toolchain in the installed application's closure.
          (let* ((runtime-inputs (filter-map (lambda (name)
                                               (assoc-ref inputs name))
                                             '("libc" "gcc-toolchain" "gcc:lib"
                                               "zlib"
                                               "gtk+"
                                               "glib"
                                               "nspr"
                                               "nss"
                                               "dbus"
                                               "dbus-glib"
                                               "at-spi2-core"
                                               "cups"
                                               "cairo"
                                               "pango"
                                               "gdk-pixbuf"
                                               "libdbusmenu"
                                               "libappindicator"
                                               "libx11"
                                               "libxcomposite"
                                               "libxdamage"
                                               "libxext"
                                               "libxfixes"
                                               "libxrandr"
                                               "mesa"
                                               "expat"
                                               "libxcb"
                                               "libxkbcommon"
                                               "eudev"
                                               "alsa-lib"
                                               "libsecret")))
                 (libraries (append (search-path-as-list '("lib") runtime-inputs)
                                    (if (assoc-ref inputs "nss")
                                        (list (string-append (assoc-ref inputs "nss")
                                                             "/lib/nss"))
                                        '())))
                 (interpreter (search-input-file inputs
                                                 "/lib/ld-linux-x86-64.so.2")))
            (for-each (lambda (file)
                        (let ((elf (call-with-input-file file
                                     (lambda (port)
                                       (parse-elf (get-bytevector-all port))))))
                          (when (any (lambda (segment)
                                       (= PT_DYNAMIC
                                          (elf-segment-type segment)))
                                     (elf-segments elf))
                            (when (any (lambda (segment)
                                         (= PT_INTERP
                                            (elf-segment-type segment)))
                                       (elf-segments elf))
                              (invoke "patchelf" "--set-interpreter" interpreter
                                      file))
                            ;; The upstream native dependencies can dlopen siblings via $ORIGIN.
                            (invoke "patchelf" "--set-rpath"
                                    (string-join (cons (command-output
                                                        "patchelf"
                                                        "--print-rpath" file)
                                                       libraries) ":") file))))
                      (filter elf-file?
                              (find-files directory ".*")))))

        (define (replace-native-dependencies inputs)
          ;; npm's loaders need their platform package layout, but all executable
          ;; code comes from ordinary Guix source-build derivations.
          (let ((replacements (map (lambda (addon)
                                     (let* ((filename (car addon))
                                            (source (string-append (assoc-ref
                                                                    inputs
                                                                    (cdr addon))
                                                                   "/lib/"
                                                                   filename))
                                            (targets (find-files "node_modules"
                                                                 (string-append
                                                                  "^"
                                                                  (regexp-quote
                                                                   filename) "$"))))
                                       (unless (pair? targets)
                                         (error
                                          "native dependency absent from locked npm packages"
                                          filename))
                                       (cons source targets)))
                                   (filter (lambda (addon)
                                             (assoc-ref inputs (cdr addon)))
                                           '(("libfff_c.so" . "t3code-fff-native")
                                             ("ffi-rs.linux-x64-gnu.node" . "t3code-ffi-native")
                                             ("keyring.linux-x64-gnu.node" . "t3code-keyring-native")
                                             ("xa11y.linux-x64-gnu.node" . "t3code-xa11y-native")
                                             ("vite-plus.linux-x64-gnu.node" . "t3code-vite-plus-native")
                                             ("tailwindcss-oxide.linux-x64-gnu.node" . "t3code-tailwind-native")
                                             ("lightningcss.linux-x64-gnu.node" . "t3code-lightningcss-native"))))))
            ;; Drop unused native tools and optional accelerators too: a transitive
            ;; loader must never silently select an npm prebuild as a fallback.
            (for-each delete-file
                      (filter elf-file?
                              (find-files "node_modules" ".*")))
            (for-each (lambda (replacement)
                        (for-each (lambda (target)
                                    (copy-file (car replacement) target)
                                    (chmod target #o755))
                                  (cdr replacement))) replacements)))

        (define* (configure-application #:key inputs #:allow-other-keys)
          (copy-recursively (assoc-ref inputs "node-modules") ".")
          (invoke "chmod" "-R" "u+w" ".")
          (for-each (lambda (file)
                      (when (string-contains file "/.bin/")
                        (substitute* file
                          (("@T3CODE_SOURCE_ROOT@")
                           (getcwd)))))
                    (find-files "node_modules" ".*"))
          (setenv "HOME"
                  (string-append (getcwd) "/.home"))
          (mkdir-p (getenv "HOME"))
          (setenv "PATH"
                  (string-append (getcwd) "/node_modules/.bin:"
                                 (getenv "PATH")))
          (replace-native-dependencies inputs)
          (patch-native-files "node_modules" inputs)
          (mkdir "spdx")
          (invoke "tar"
                  "xf"
                  (assoc-ref inputs "spdx-licenses")
                  "--strip-components=1"
                  "-C"
                  "spdx")
          (copy-recursively "spdx/json/details"
                            ".generated/third-party-licenses/spdx/v3.28.0")
          (mkdir "ghostty")
          (invoke "tar"
                  "xf"
                  (assoc-ref inputs "ghostty-source")
                  "--strip-components=1"
                  "-C"
                  "ghostty")
          (setenv "ZIG_GLOBAL_CACHE_DIR"
                  (string-append (getcwd) "/zig-cache"))
          (copy-recursively (assoc-ref inputs "ghostty-dependencies")
                            "zig-cache/p")
          (invoke "chmod" "-R" "u+w" "zig-cache"))

        (define (build-application inputs version ghostty-revision)
          (setenv "APP_VERSION" version)
          ;; The release tag is newer than the workspace manifests.  The web and
          ;; backend must report the version selected by the Guix package as well.
          (substitute* '("package.json" "apps/web/package.json"
                         "apps/server/package.json" "apps/desktop/package.json")
            (("\"version\": \"[^\"]+\"")
             (string-append "\"version\": \"" version "\"")))
          (with-directory-excursion "ghostty"
            (invoke "zig"
                    "build"
                    "-Demit-lib-vt"
                    "-Dtarget=wasm32-freestanding"
                    "-Doptimize=ReleaseSmall"
                    "-Dstrip=true"
                    (string-append "-Dlib-version-string=0.1.0-dev+"
                                   ghostty-revision)))
          (copy-file "ghostty/zig-out/bin/ghostty-vt.wasm"
                     "apps/web/src/terminal/ghostty/vendor/ghostty-vt.wasm")
          (invoke "zig"
           "build-exe"
           "apps/web/scripts/ghostty-write-pty.zig"
           "-target"
           "wasm32-freestanding"
           "-O"
           "ReleaseSmall"
           "-fno-entry"
           "-rdynamic"
           "-femit-bin=apps/web/src/terminal/ghostty/vendor/ghostty-write-pty.wasm")
          ;; Node-API keeps the source-built terminal addon usable by both runtimes.
          ;; Compile the terminal addon instead of using its platform prebuild.
          (with-directory-excursion "apps/server/node_modules/node-pty"
            (delete-file-recursively "prebuilds")
            (mkdir-p "build/Release")
            (invoke "g++"
                    "-std=c++17"
                    "-shared"
                    "-fPIC"
                    "-O2"
                    "-pthread"
                    "-DNAPI_CPP_EXCEPTIONS"
                    (string-append "-I"
                                   (assoc-ref inputs "node") "/include/node")
                    (string-append "-I"
                                   (canonicalize-path "../node-addon-api"))
                    "src/unix/pty.cc"
                    "-o"
                    "build/Release/pty.node"
                    "-lutil"))
          (with-directory-excursion "apps/web"
            (invoke "vp" "build"))
          (with-directory-excursion "apps/server"
            (invoke "vp" "pack"))
          (copy-recursively "apps/web/dist" "apps/server/dist/client")
          (when #$desktop?
            (with-directory-excursion "apps/desktop"
              (invoke "node" "scripts/build-browser-secret.mjs")
              (invoke "node" "scripts/build-preview-annotation-css.mjs")
              (invoke "vp" "pack"))))

        (define* (check-application #:key tests? #:allow-other-keys)
          (when tests?
            ;; These upstream suites cover the bundle boundary and staged resources.
            ;; GUI/provider suites require a running session or credentials.
            (invoke "vp" "test" "scripts/lib/cli-external-packages.test.ts")
            (with-directory-excursion "apps/web"
              (invoke "vp" "test" "src/appearanceFonts.test.ts"))
            (when #$desktop?
              (with-directory-excursion "apps/desktop"
                (invoke "vp" "test" "scripts/browser-secret-native.test.mjs"
                        "src/app/DesktopEnvironment.test.ts"
                        "src/app/DesktopAssets.test.ts")))))

        (define (install-application inputs output version
                                     dependencies-script)
          (let* ((appdir (string-append output "/lib/t3code"))
                 (resources (string-append appdir "/resources"))
                 (application (string-append resources "/app"))
                 (runtime (string-append (assoc-ref inputs
                                                    "electron")
                                         "/share/electron"))
                 (bin (string-append output "/bin")))
            (mkdir-p appdir)
            ;; A private resources directory preserves app.isPackaged and helper lookup.
            (for-each (lambda (file)
                        (unless (member file
                                        '("." ".." "resources"))
                          (copy-recursively (string-append
                                             runtime "/" file)
                                            (string-append
                                             appdir "/" file))))
                      (scandir runtime))
            (rename-file (string-append appdir "/electron")
                         (string-append appdir "/t3code"))
            (chmod (string-append appdir "/t3code") #o755)
            (mkdir-p resources)
            (invoke "node" dependencies-script
                    (getcwd) application)
            (for-each (lambda (directory)
                        (copy-recursively directory
                                          (string-append
                                           application "/"
                                           directory)))
                      '("apps/server/dist"
                        "apps/desktop/dist-electron"))
            (call-with-output-file (string-append application
                                    "/package.json")
              (lambda (port)
                (scm->json (list (cons "name" "t3code")
                                (cons "version" version)
                                (cons "private" #t)
                                (cons "main" "apps/desktop/dist-electron/boot.cjs"))
                           port)))
            (install-file "LICENSE" application)
            ;; GNOME installs this bundle on demand; omitting it breaks screen capture.
            (let* ((extension "apps/desktop/gnome-extension")
                   (manifest (call-with-input-file (string-append
                                                    extension
                                                    "/bundle.json")
                               json->scm)))
              (for-each (lambda (file)
                          (let ((target (string-append
                                         resources
                                         "/gnome-extension/"
                                         file)))
                            (mkdir-p (dirname target))
                            (copy-file (string-append extension
                                        "/" file) target)))
                        (vector->list (assoc-ref manifest
                                                 "files"))))
            (for-each (lambda (helper)
                        (let ((directory (car helper))
                              (name (cdr helper)))
                          (install-file (search-input-file
                                         inputs
                                         (string-append "/bin/"
                                          name))
                                        (string-append
                                         resources "/"
                                         directory))))
                      '(("resource-monitor" . "t3-resource-monitor")
                        ("hyprland-capture" . "t3-hyprland-snap-shot")
                        ("kde-capture" . "t3-kde-snap-shot")))
            (install-file
             "native/browser-secret/build/x64/t3-browser-secret"
             (string-append resources "/browser-secret"))
            ;; Pre-ready desktop registration reads this app-relative icon before
            ;; the resource resolver is available.
            ;; https://github.com/pingdotgg/t3code/blob/v0.0.44/apps/desktop/src/app/DesktopPreReadyPlatform.ts
            (for-each (lambda (target)
                        (mkdir-p (dirname target))
                        (copy-file "assets/prod/black-universal-1024.png"
                                   target))
                      (list (string-append output
                             "/share/icons/hicolor/1024x1024/apps/t3code.png")
                            (string-append resources "/icon.png")
                            (string-append application
                             "/apps/desktop/prod-resources/icon.png")))
            (install-file "LICENSE"
                          (string-append output
                           "/share/licenses/t3code"))
            (invoke "chmod" "-R" "u+w" appdir)
            (patch-native-files appdir inputs)
            (mkdir-p bin)
            (call-with-output-file (string-append appdir
                                                  "/AppRun")
              (lambda (port)
                (format port
                 "#!~a~%if unshare -Ur true 2>/dev/null; then~%  exec ~s \"$@\"~%else~%  exec ~s --no-sandbox \"$@\"~%fi~%"
                 (search-input-file inputs "/bin/sh")
                 (string-append appdir "/t3code")
                 (string-append appdir "/t3code"))))
            (chmod (string-append appdir "/AppRun") #o755)
            ;; Bash initializes an unexported SHELL from passwd.  Only
            ;; an exported value represents the caller's chosen shell.
            (call-with-output-file (string-append bin "/t3code")
              (lambda (port)
                (format port
                 "#!~a~%case \"$(export -p)\" in~%  *\"declare -x SHELL=\"*|*\"export SHELL=\"*) ;;~%  *) unset SHELL ;;~%esac~%export SHELL=\"${SHELL:-~a}\"~%exec ~s \"$@\"~%"
                 (search-input-file inputs "/bin/sh")
                 (search-input-file inputs "/bin/bash")
                 (string-append appdir "/AppRun"))))
            (chmod (string-append bin "/t3code") #o755)
            (mkdir-p (string-append output
                                    "/share/applications"))
            ;; Upstream writes a hidden URL handler under its desktop identity.
            ;; A distinct menu launcher avoids its user-level NoDisplay override.
            ;; https://github.com/pingdotgg/t3code/blob/v0.0.44/apps/desktop/src/app/DesktopLinuxUrlHandler.ts
            (for-each
             (lambda (entry)
               (call-with-output-file
                   (string-append output "/share/applications/" (car entry))
                 (lambda (port)
                   (format port
                    "[Desktop Entry]~%Type=Application~%Name=T3 Code~%Exec=~a/bin/t3code %U~%Icon=t3code~%MimeType=x-scheme-handler/t3code;~%~a"
                    output (cdr entry)))))
             '(("t3code.desktop" . "Categories=Development;\nStartupWMClass=t3code\n")
               ("com.t3tools.T3Code.desktop" . "NoDisplay=true\n")))))

        (define (install-cli inputs output dependencies-script)
          (let* ((application (string-append output "/lib/t3code-cli"))
                 (bin (string-append output "/bin")))
            (invoke "node" dependencies-script (getcwd) application "cli")
            (copy-recursively "apps/server/dist"
                              (string-append application "/apps/server/dist"))
            (copy-file "apps/server/package.json"
                       (string-append application "/apps/server/package.json"))
            (install-file "LICENSE"
                          (string-append output "/share/licenses/t3code-cli"))
            (patch-native-files application inputs)
            (mkdir-p bin)
            (call-with-output-file (string-append bin "/t3")
              (lambda (port)
                (format port
                 "#!~a~%case \"$(export -p)\" in~%  *\"declare -x SHELL=\"*|*\"export SHELL=\"*) ;;~%  *) unset SHELL ;;~%esac~%export SHELL=\"${SHELL:-~a}\"~%exec ~s ~s \"$@\"~%"
                 (search-input-file inputs "/bin/sh")
                 (search-input-file inputs "/bin/bash")
                 (search-input-file inputs "/bin/node")
                 (string-append application "/apps/server/dist/bin.mjs"))))
            (chmod (string-append bin "/t3") #o755)
            (wrap-program (string-append bin "/t3")
              `("PATH" ":" prefix
                ,(map (lambda (file)
                        (dirname (search-input-file inputs file)))
                      '("/bin/bash" "/bin/env" "/bin/git" "/bin/ssh"))))))

        (define* (wrap-desktop #:key inputs outputs #:allow-other-keys)
          (let ((gtk (assoc-ref inputs "gtk+"))
                (fontconfig-file
                 (search-input-file inputs "/etc/fonts/fonts.conf")))
            (wrap-program (string-append (assoc-ref outputs "out") "/bin/t3code")
              `("PATH" ":" prefix
                ,(map (lambda (file)
                        (dirname (search-input-file inputs file)))
                      '("/bin/bash" "/bin/true"
                        "/bin/unshare"
                        "/bin/git"
                        "/bin/ssh"
                        "/bin/xdg-open"
                        "/bin/update-desktop-database")))
              `("FONTCONFIG_FILE" ":" =
                (,fontconfig-file))
              ;; The configuration includes conf.d relative to Fontconfig's
              ;; search directory, which Electron cannot infer from Guix paths.
              ;; https://fontconfig.pages.freedesktop.org/fontconfig/fontconfig-user.html
              `("FONTCONFIG_PATH" ":" =
                (,(dirname fontconfig-file)))
              `("GDK_PIXBUF_MODULE_FILE" ":" =
                (,(string-append gtk "/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache")))
              `("GSETTINGS_SCHEMA_DIR" ":" =
                (,(string-append gtk "/share/glib-2.0/schemas")))
              `("XDG_DATA_DIRS" ":" prefix
                (,(string-append (assoc-ref inputs "shared-mime-info") "/share")))
              `("LD_LIBRARY_PATH" ":" prefix
                (,(string-append (assoc-ref inputs "nss") "/lib/nss") ,(string-append
                                                                        (assoc-ref
                                                                         inputs
                                                                         "libappindicator")
                                                                        "/lib")))
              '("T3CODE_DISABLE_AUTO_UPDATE" ":" =
                ("true")))))

        (modify-phases %standard-phases
          (add-after 'validate-runpath 'check-installed
            (lambda* (#:key tests? inputs outputs #:allow-other-keys)
              (when tests?
                (if #$desktop?
                    (invoke "env"
                            (string-append "GUILE_LOAD_PATH="
                                           (string-join %load-path ":"))
                            (string-append "GUILE_LOAD_COMPILED_PATH="
                                           (string-join %load-compiled-path ":"))
                            #+(file-append guile-3.0 "/bin/guile")
                        "--no-auto-compile"
                        #$(file-append %t3code-installed-tests "/check-installed")
                        (assoc-ref outputs "out")
                        (search-input-file inputs "/lib/libgio-2.0.so"))
                    (invoke "node"
                            #$(file-append %t3code-installed-tests "/check-cli-installed.mjs")
                            (assoc-ref outputs "out")
                            #$(file-append %t3code-installed-tests "/native-modules.mjs")
                            #$version)))))
          (delete 'bootstrap)
          (replace 'configure
            configure-application)
          (replace 'build
            (lambda* (#:key inputs #:allow-other-keys)
              (build-application inputs
                                 #$version
                                 #$ghostty-revision)))
          (replace 'check
            check-application)
          (replace 'install
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (if #$desktop?
                  (install-application inputs
                                       (assoc-ref outputs "out")
                                       #$version
                                       #$dependencies-script)
                  (install-cli inputs (assoc-ref outputs "out")
                               #$dependencies-script))))
          (add-after 'install 'wrap-desktop
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (when #$desktop?
                (wrap-desktop #:inputs inputs #:outputs outputs))))))))

(define-public t3code
  (package
    (name "t3code")
    (version %t3code-version)
    (source
     %t3code-source)
    (build-system gnu-build-system)
    (arguments
     (list
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (guix elf)
                  (json)
                  (ice-9 ftw)
                  (ice-9 popen)
                  (ice-9 regex)
                  (rnrs io ports)
                  (srfi srfi-1)
                  (srfi srfi-13))
      #:imported-modules `(,@%default-gnu-imported-modules
                           (guix build syscalls)
                           (guix elf))
      #:phases (t3code-build-phases version %ghostty-revision
                                    %t3code-runtime-dependencies-script)))
    (native-inputs `(("t3code-vite-plus-native" ,t3code-vite-plus-native)
                     ("xvfb-run" ,xvfb-run)
                     ("t3code-tailwind-native" ,t3code-tailwind-native)
                     ("t3code-lightningcss-native" ,t3code-lightningcss-native)
                     ("pkg-config" ,pkg-config)
                     ("patchelf" ,patchelf)
                     ("zig" ,zig-0.15)
                     ("node-modules" ,%t3code-node-modules)
                     ("ghostty-source" ,%ghostty-source)
                     ("ghostty-dependencies" ,%ghostty-dependencies)
                     ("spdx-licenses" ,%spdx-licenses)))
    ;; Playwright ships a Node CLI whose installed shebang must remain usable.
    (inputs (list node
                  electron-for-t3code
                  t3code-fff-native
                  t3code-ffi-native
                  t3code-keyring-native
                  t3code-xa11y-native
                  t3-resource-monitor
                  t3-hyprland-snap-shot
                  t3-kde-snap-shot
                  bash-minimal
                  coreutils-minimal
                  util-linux
                  git-minimal
                  openssh
                  xdg-utils
                  desktop-file-utils
                  fontconfig
                  shared-mime-info
                  gcc-toolchain
                  zlib
                  gtk+
                  glib
                  nspr
                  nss
                  dbus
                  dbus-glib
                  at-spi2-core
                  cups
                  cairo
                  pango
                  gdk-pixbuf
                  libdbusmenu
                  libappindicator
                  libx11
                  libxcomposite
                  libxdamage
                  libxext
                  libxfixes
                  libxrandr
                  mesa
                  expat
                  libxcb
                  libxkbcommon
                  eudev
                  alsa-lib
                  libsecret))
    (supported-systems '("x86_64-linux"))
    (home-page "https://t3.codes")
    (synopsis "Desktop control surface for coding agents")
    (description
     "T3 Code is a desktop interface for local coding agents.  It provides
conversation management, a terminal, Git integration, and remote connections.
Install the provider command-line tools separately to use their subscriptions.
This package builds the application, terminal WASM, native helpers, and runtime
addons from source, including the native build tools.  It uses the upstream
Electron runtime.")
    (license license:expat)))

(define-public t3code-cli
  (package
    (inherit t3code)
    (name "t3code-cli")
    (arguments
     (substitute-keyword-arguments (package-arguments t3code)
       ((#:phases phases)
        (t3code-build-phases %t3code-version %ghostty-revision
                            %t3code-runtime-dependencies-script
                            #:desktop? #f))))
    (inputs (list (list "node" node)
                  (list "t3code-fff-native" t3code-fff-native)
                  (list "t3code-ffi-native" t3code-ffi-native)
                  (list "t3code-keyring-native" t3code-keyring-native)
                  (list "bash-minimal" bash-minimal)
                  (list "coreutils-minimal" coreutils-minimal)
                  (list "git-minimal" git-minimal)
                  (list "openssh" openssh)
                  (list "gcc:lib" gcc "lib")))
    (synopsis "Web interface and command-line server for coding agents")
    (description
     "T3 Code provides a Web interface, terminal, Git integration, and remote
connections for local coding agents.  The t3 command starts the server and
manages pairing and client authentication.  Install the provider command-line
tools separately to use their subscriptions.  This package builds the server,
Web interface, terminal WASM, and native addons from source and runs on Node.js.")
    (license license:expat)))
