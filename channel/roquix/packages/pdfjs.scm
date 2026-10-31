(define-module (roquix packages pdfjs)
  #:use-module (roquix packages wasm)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages web)
  #:use-module ((guix licenses)
                #:prefix license:))

(define %pdfjs-version
  "6.4.299")
(define %pdfjs-commit
  "d0991a0d53f3bb3a7307e3b83f279c1d117aafb3")

(define %pdfjs-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/mozilla/pdf.js/tar.gz/"
                        %pdfjs-commit))
    (file-name (string-append "pdfjs-" %pdfjs-version ".tar.gz"))
    (sha256 (base32 "0rb2ylnjhd4nhwnfn13l4mpl99rl2bw82gcy5s2playapmg09m5c"))))

(define* (pdfjs-node-modules-fetch uri
                                   hash-algo
                                   hash
                                   #:optional name
                                   #:key system
                                   guile
                                   #:allow-other-keys)
  (gexp->derivation (or name "pdfjs-node-modules")
                    (with-imported-modules '((guix build utils))
                                           #~(begin
                                               (use-modules (guix build utils))
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
                                                       (getcwd))
                                               (setenv "SSL_CERT_FILE"
                                                       #+(file-append
                                                          nss-certs-for-test
                                                          "/etc/ssl/certs/ca-certificates.crt"))
                                               (invoke "tar" "xf"
                                                       #+%pdfjs-source)
                                               (chdir (string-append "pdf.js-"
                                                       #$%pdfjs-commit))
                                               (invoke "npm" "ci"
                                                       "--ignore-scripts"
                                                       "--no-audit"
                                                       "--no-fund")
                                               (copy-recursively
                                                "node_modules"
                                                #$output)
                                               (when (file-exists? (string-append #$output
                                                                    "/.package-lock.json"))
                                                 (delete-file (string-append #$output
                                                               "/.package-lock.json")))))
                    #:system system
                    #:guile-for-build guile
                    #:hash-algo hash-algo
                    #:hash hash
                    #:recursive? #t))

(define %pdfjs-node-modules
  (origin
    (method pdfjs-node-modules-fetch)
    (uri (string-append "pdfjs-" %pdfjs-version))
    (file-name (string-append "pdfjs-node-modules-" %pdfjs-version))
    (sha256 (base32 "1lhy030nqs0nb0s535k88k84bgfzrhz1v3xr779w3i3rbvapyfv5"))))

(define-public t3code-qcms-wasm
  (package
    (name "t3code-qcms-wasm")
    (version "0.1.0-2ae4ee7")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://codeload.github.com/mozilla/pdf.js.qcms/tar.gz/2ae4ee72334782928210ba4050e3e77d9b2d35be")
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0z5jwf8rvp6mi7hr40z15vr8sv727mar46g5728h04c43ar3rjn0"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.93
      #:install-source? #f
      #:cargo-build-flags ''("--release" "--target" "wasm32-unknown-unknown")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'configure 'set-wasm-sysroot
            (lambda _
              (setenv "RUSTFLAGS"
                      (string-append "--sysroot="
                                     #$rust-sysroot-for-wasm32-unknown-unknown
                                     " -C linker="
                                     #$(file-append lld-22 "/bin/wasm-ld")))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (invoke "wasm-bindgen"
                 "--target"
                 "web"
                 "--out-name"
                 "qcms"
                 ;; Match Cargo.toml's wasm-pack metadata: PDF.js supplies
                 ;; the module and rejects generated import.meta.url paths.
                 "--omit-default-module-path"
                 "--out-dir"
                 out
                 "target/wasm32-unknown-unknown/release/qcms_pdf_js.wasm")
                (copy-recursively "js" out))))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (unsetenv "RUSTFLAGS")
                (invoke "cargo" "test" "--offline" "--lib")))))))
    (native-inputs (list wasm-bindgen-cli-0.2.100
                         rust-sysroot-for-wasm32-unknown-unknown lld-22))
    (inputs (cargo-inputs 't3code-qcms-wasm
                          #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/mozilla/pdf.js.qcms")
    (synopsis "PDF.js color management WebAssembly")
    (description "This package builds PDF.js's qcms color management bindings
and their WebAssembly module from source.")
    (license license:expat)))

(define (github-snapshot repository commit hash)
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/" repository "/tar.gz/"
                        commit))
    (file-name (string-append commit ".tar.gz"))
    (sha256 (base32 hash))))

(define %pdfjs-wasm-tests
  (local-file (canonicalize-path (search-path %load-path
                                  "roquix/packages/aux-files/pdfjs/package-tests/check-pdfjs-wasm.mjs"))))

;; PDF.js consumes generated JS and WASM as a pair.  Keeping each codec in
;; its own derivation lets a codec update reuse the other compiled codecs.
(define* (pdfjs-codec codec-name
                      bindings
                      core
                      core-variable
                      #:key (prepare #~(lambda _
                                         #t))
                      (build #~(lambda _
                                 (invoke "sh" "compile.sh")))
                      (license license:asl2.0))
  (package
    (name (string-append "pdfjs-" codec-name "-wasm"))
    (version (string-take (basename (origin-uri bindings)) 10))
    (source
     bindings)
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (delete 'bootstrap)
          (replace 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              (setenv "EM_CACHE"
                      (string-append (getcwd) "/em-cache"))
              (setenv #$core-variable
                      (string-append (getcwd) "/core"))
              (setenv "INPUT"
                      (string-append (getcwd) "/src"))
              (setenv "OUTPUT"
                      (string-append (getcwd) "/result/"
                                     #$codec-name))
              (mkdir-p (getenv "OUTPUT"))
              (let ((patches (map canonicalize-path
                                  (find-files "." "\\.patch$"))))
                (mkdir-p "core")
                (invoke "tar"
                        "xf"
                        (assoc-ref inputs "core")
                        "--strip-components=1"
                        "-C"
                        "core")
                (with-directory-excursion "core"
                  (for-each (lambda (patch)
                              (invoke "patch" "-p1" "-i" patch)) patches)))
              (setenv "NODE_PATH"
                      #$%pdfjs-node-modules)
              (call-with-output-file "terser"
                (lambda (port)
                  (format port "#!~a~%exec ~a ~a \"$@\"~%"
                          (which "sh")
                          (which "node")
                          (string-append #$%pdfjs-node-modules
                                         "/terser/bin/terser"))))
              (chmod "terser" #o755)
              (substitute* "compile.sh"
                (("WASM2JS=.*")
                 (string-append "WASM2JS="
                                (which "wasm2js") "\n"))
                (("TERSER=.*")
                 (string-append "TERSER="
                                (canonicalize-path "terser") "\n")))
              (#$prepare)))
          (replace 'build
            #$build)
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node"
                        #$%pdfjs-wasm-tests "result"
                        #$codec-name))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (copy-recursively (getenv "OUTPUT") out)
                (install-file "LICENSE" out)))))))
    (native-inputs (list (list "emscripten" emscripten-4)
                         (list "node" node)
                         (list "binaryen" binaryen)
                         (list "cmake" cmake-minimal)
                         (list "core" core)))
    (home-page (string-append "https://github.com/mozilla/pdf.js." codec-name))
    (synopsis (string-append "PDF.js " codec-name
                             " WebAssembly and JavaScript bindings"))
    (description
     "This package compiles a PDF.js codec and its matching
JavaScript bindings, including the JavaScript fallback where supported.")
    (license license)))

(define-public pdfjs-openjpeg-wasm
  (pdfjs-codec "openjpeg"
               (github-snapshot "mozilla/pdf.js.openjpeg"
                "d5f16ba380391d4e32b51834e2e0afa796e402d8"
                "0gf7dgf02z5insdrw0yl91dyx2lr8045mfzpc1gc2zwh62qmfy42")
               (github-snapshot "uclouvain/openjpeg"
                "8314119b067c0fc77834731168daaebd379fdb12"
                "08a3162p5c9gmkz4r5ndfl1rz069pyqjp1086dsfi211pfxfh8z7")
               "OPENJPEG"
               #:license license:bsd-2
               #:build #~(lambda _
                           (for-each (lambda (kind)
                                       (setenv "BUILD_TYPE" kind)
                                       (invoke "sh" "compile_lib.sh"))
                                     '("wasm" "js"))
                           (invoke "sh" "compile.sh"))))

(define-public pdfjs-jbig2-wasm
  (pdfjs-codec "jbig2"
               (github-snapshot "mozilla/pdf.js.jbig2"
                "d11108f08f8a979b3ff9cbc209783ab05927c37b"
                "1g9fxclkd28bjjmhvgfz4dap2ghcxp8xa2shi6v5rgq0nnbvqfhs")
               (github-snapshot "chromium/pdfium"
                "bb1f9f71e7b15afdd5937adf8cfe5807522b882f"
                "0hhk6ybm6i3jqdmxpm69ykw37dnh9ch5yar9v1xpqr339hfqw2aq")
               "PDFIUM"))

(define-public pdfjs-quickjs-wasm
  (pdfjs-codec "quickjs"
               (github-snapshot "mozilla/pdf.js.quickjs"
                "e2c5bfc8194b16f5973eea5e4e025b67be3c1015"
                "0bdpnbzah7giq34j4ff2rh8l8cfgdmdk31b204r3bawlzj3ddapl")
               (github-snapshot "bellard/quickjs"
                "3d5e064e9dd67c70f7962836505a7fa067bf0a4e"
                "0pg02mzb9c6fc481xq155ywx0vi3qygr1rj3mx4lw6p26cax3k5g")
               "QUICKJS"
               #:license license:expat
               #:prepare #~(lambda _
                             (substitute* "compile.sh"
                               (("--closure 1")
                                "--closure 0")))))

(define-public t3code-pdfjs-wasm
  (package
    (name "t3code-pdfjs-wasm")
    (version %pdfjs-version)
    (source
     %pdfjs-source)
    (build-system gnu-build-system)
    (arguments
     (list
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 format))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'bootstrap)
          (replace 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              (copy-recursively #$%pdfjs-node-modules "node_modules")
              (invoke "chmod" "-R" "u+w" "node_modules")
              (for-each delete-file
                        (filter elf-file?
                                (find-files "node_modules" ".*")))
              (setenv "PATH"
                      (string-append (getcwd) "/node_modules/.bin:"
                                     (getenv "PATH")))
              (substitute* "gulpfile.mjs"
                (("let buildNumber = 0;")
                 (string-append "let buildNumber = "
                                #$(last (string-split %pdfjs-version #\.)) ";"))
                (("const buildCommit = .*;")
                 (string-append "const buildCommit = '"
                                #$(string-take %pdfjs-commit 10) "';")))
              (for-each delete-file
                        (find-files "external" "\\.wasm$"))
              (for-each (lambda (name)
                          (copy-recursively (assoc-ref inputs name)
                                            (string-append "external/" name)))
                        '("openjpeg" "jbig2" "quickjs" "qcms"))))
          (replace 'build
            (lambda _
              (invoke "node" "node_modules/gulp/bin/gulp.js" "generic")
              (copy-file "build/generic/build/pdf.worker.mjs"
                         "build/generic/build/pdf.worker.min.mjs")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node"
                        #$%pdfjs-wasm-tests "external")
                (invoke "node"
                 "--input-type=module"
                 "-e"
                 "import{readFileSync,readdirSync}from'node:fs';import assert from'node:assert/strict';for(const f of readdirSync('build/generic/web/wasm').filter(f=>f.endsWith('.wasm'))){const b=readFileSync('build/generic/web/wasm/'+f);assert(WebAssembly.validate(b),f)}const [version,commit]=process.argv.slice(1);for(const f of ['pdf.mjs','pdf.worker.mjs']){const text=readFileSync('build/generic/build/'+f,'utf8');assert(text.includes('pdfjsVersion = '+version),f);assert(text.includes('pdfjsBuild = '+commit),f)}"
                 #$%pdfjs-version
                 #$(string-take %pdfjs-commit 10)))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (copy-recursively "build/generic/build"
                                  (string-append out "/build"))
                (copy-recursively "build/generic/web/wasm"
                                  (string-append out "/wasm"))
                (install-file "LICENSE" out)))))))
    (native-inputs (list (list "node" node)
                         (list "qcms" t3code-qcms-wasm)
                         (list "openjpeg" pdfjs-openjpeg-wasm)
                         (list "jbig2" pdfjs-jbig2-wasm)
                         (list "quickjs" pdfjs-quickjs-wasm)))
    (home-page "https://mozilla.github.io/pdf.js/")
    (synopsis "PDF.js with source-built WebAssembly codecs")
    (description
     "This package builds PDF.js together with its OpenJPEG,
JBIG2, qcms, and QuickJS WebAssembly modules.  The JavaScript worker is built
with the matching generated codec bindings.")
    (license license:asl2.0)))
