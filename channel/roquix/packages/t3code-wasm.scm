(define-module (roquix packages t3code-wasm)
  #:use-module (guix packages)
  #:use-module (guix platform)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages node-xyz)
  #:use-module (gnu packages python)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages web))

(define-public emscripten-for-t3code
  (package
    (name "emscripten-for-t3code")
    (version "4.0.10")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://codeload.github.com/emscripten-core/emscripten/tar.gz/"
             version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zklqzns0060zmwrzv1bwbcznwbn9cy1d5ycz51nggq7qb69656w"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 format))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'bootstrap)
          (delete 'configure)
          (delete 'build)
          (delete 'check)
          (replace 'install
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (share (string-append out "/share/emscripten"))
                     (llvm-bin (string-append share "/llvm-bin")))
                (delete-file-recursively "test")
                ;; Guix Clang embeds host glibc include paths.  Keep them out
                ;; of WASM compilation while preserving Emscripten's compat
                ;; headers ahead of its musl headers.
                (substitute* "emcc.py"
                  (("  cflags.append.*sysroot=.*")
                   "  cflags += ['--sysroot=' + cache.get_sysroot(absolute=True), '-nostdlibinc', '-idirafter', cache.get_sysroot(absolute=True) + '/include']
  if shared.run_via_emxx or any(arg.endswith(('.cpp', '.cc', '.cxx')) for arg in user_args):
    cflags = ['-nostdinc++', '-isystem', cache.get_sysroot(absolute=True) + '/include/c++/v1'] + cflags"))
                (copy-recursively "." share)
                (mkdir-p llvm-bin)
                (for-each (lambda (tool)
                            (symlink (search-input-file inputs
                                                        (string-append "/bin/"
                                                         tool))
                                     (string-append llvm-bin "/" tool)))
                          '("clang" "clang++"
                            "llvm-ar"
                            "llvm-nm"
                            "llvm-ranlib"
                            "llvm-objcopy"
                            "wasm-ld"))
                (mkdir-p (string-append share "/node_modules"))
                (symlink (search-input-directory inputs
                                                 "/lib/node_modules/acorn")
                         (string-append share "/node_modules/acorn"))
                (call-with-output-file (string-append share "/.emscripten")
                  (lambda (port)
                    (format port
                     "LLVM_ROOT = ~s~%BINARYEN_ROOT = ~s~%NODE_JS = [~s]~%"
                     llvm-bin
                     #$binaryen
                     #$(file-append node "/bin/node"))))
                (for-each (lambda (tool)
                            (let ((script (string-append out "/bin/" tool)))
                              (mkdir-p (string-append out "/bin"))
                              (call-with-output-file script
                                (lambda (port)
                                  (format port
                                   "#!~a~%unset C_INCLUDE_PATH CPLUS_INCLUDE_PATH CPATH LIBRARY_PATH~%export PYTHON=~s~%exec ~s ~s \"$@\"~%"
                                   (which "sh")
                                   #$(file-append python "/bin/python3")
                                   #$(file-append python "/bin/python3")
                                   (string-append share "/" tool ".py"))))
                              (chmod script #o755)))
                          '("emcc" "em++" "emar" "emranlib" "emcmake" "emmake")))))
          (add-after 'install 'check-compiler
            (lambda* (#:key outputs tests? #:allow-other-keys)
              (when tests?
                (setenv "EM_CACHE"
                        (string-append (getcwd) "/test-cache"))
                (call-with-output-file "smoke.c"
                  (lambda (port)
                    (display "int main(void) { return 0; }\n" port)))
                (invoke (string-append (assoc-ref outputs "out") "/bin/emcc")
                        "smoke.c" "-o" "smoke.js")
                (invoke "node" "smoke.js")))))))
    (inputs (list python
                  node
                  node-acorn
                  clang-21
                  llvm-21
                  lld-21
                  binaryen))
    (home-page "https://emscripten.org/")
    (synopsis "C and C++ to WebAssembly compiler for T3 Code assets")
    (description
     "Emscripten compiles C and C++ programs to WebAssembly and
provides the JavaScript runtime used by T3 Code's document viewers.")
    (license (list license:expat license:ncsa))))

(define-public t3code-wasm-bindgen
  (package
    (name "t3code-wasm-bindgen")
    (version "0.2.126")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://static.crates.io/crates/wasm-bindgen-cli/wasm-bindgen-cli-"
             version ".crate"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0l2vri38gk9a5kni2ir9nx5k0hd5pvgxvwa74dk4xhw7xxpbyblf"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.93
      #:install-source? #f
      #:tests? #f))
    (inputs (cargo-inputs 't3code-wasm-bindgen
                          #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/wasm-bindgen/wasm-bindgen")
    (synopsis "JavaScript bindings generator for T3 Code's Rust WASM")
    (description
     "This package provides the wasm-bindgen generator matching
T3 Code's document libraries.  The generator and library versions must agree
on the binding metadata embedded in the compiled WebAssembly.")
    (license (list license:expat license:asl2.0))))

(define rust-wasm-sysroot-for-t3code
  (package
    (inherit rust-sysroot-for-wasm32-unknown-unknown)
    (name "rust-wasm-sysroot-for-t3code")
    (version (package-version rust-1.95))
    (source
     (package-source rust-1.95))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 format))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (setenv "RUSTC_BOOTSTRAP" "1")
              (setenv "CC" "gcc")
              (setenv "CXX" "g++")
              ;; Guix's Rust source removes bundled native libraries.
              (invoke "python3" "-c"
               "import glob,json
for p in glob.glob('vendor/*/.cargo-checksum.json'):
 d=json.load(open(p)); d['files']={}; json.dump(d,open(p,'w'))")
              (call-with-output-file "bootstrap.toml"
                (lambda (port)
                  (format port
                          (string-append
                           "change-id = 'ignore'~%[build]~%local-rebuild = true~%"
                           "rustc = ~s~%cargo = ~s~%python = ~s~%vendor = true~%"
                           "optimized-compiler-builtins = false~%"
                           "locked-deps = true~%submodules = false~%"
                           "target = ['wasm32-unknown-unknown']~%[rust]~%"
                           "channel = 'stable'~%download-rustc = false~%[llvm]~%"
                           "download-ci-llvm = false~%[target.~a]~%llvm-config = ~s~%"
                           "[target.wasm32-unknown-unknown]~%"
                           "cc = ~s~%cxx = ~s~%ar = ~s~%linker = ~s~%")
                          (which "rustc")
                          (which "cargo")
                          (which "python3")
                          #$(platform-rust-target (lookup-platform-by-system (%current-system)))
                          (which "llvm-config")
                          (which "clang")
                          (which "clang++")
                          (which "llvm-ar")
                          (which "wasm-ld"))))))
          (replace 'build
            (lambda _
              (invoke "python3"
                      "x.py"
                      "build"
                      "--stage"
                      "0"
                      "--target"
                      "wasm32-unknown-unknown"
                      "library/std")))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (lib (string-append out
                           "/lib/rustlib/wasm32-unknown-unknown/lib")))
                ;; Rust keeps full metadata beside hashed archives in deps/.
                ;; Top-level un-hashed archives have no matching metadata.
                (for-each (lambda (file)
                            (install-file file lib))
                          (find-files "build"
                                      (lambda (file stat)
                                        (and (string-contains file
                                              "/wasm32-unknown-unknown/")
                                             (string-contains file "/deps/")
                                             (or (string-suffix? ".rlib" file)
                                                 (string-suffix? ".rmeta" file))))))
                (call-with-output-file "smoke.rs"
                  (lambda (port)
                    (display "fn main() { let _ = String::from(\"WASM\"); }"
                             port)))
                (invoke "rustc"
                        "--target"
                        "wasm32-unknown-unknown"
                        "--sysroot"
                        out
                        "-C"
                        "linker=wasm-ld"
                        "smoke.rs"
                        "-o"
                        "smoke.wasm")))))))
    (native-inputs (list rust-1.95
                         `(,rust-1.95 "cargo")
                         python
                         llvm-22
                         clang-22
                         lld-22
                         zstd))
    (inputs '())))

(define* (betteroffice-wasm name
                            version
                            commit
                            hash
                            modules
                            packages)
  (package
    (name name)
    (version version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://codeload.github.com/openooxml/betteroffice/tar.gz/"
             commit))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 hash))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.95
      #:install-source? #f
      #:phases
      #~(modify-phases %standard-phases
          (replace 'build
            (lambda _
              (setenv "RUSTFLAGS"
                      (string-append "--sysroot="
                                     #$rust-wasm-sysroot-for-t3code
                                     " -C linker="
                                     #$(file-append lld-22 "/bin/wasm-ld")))
              (for-each (lambda (module)
                          (let ((crate (list-ref module 0))
                                (features (list-ref module 3)))
                            (apply invoke
                                   "cargo"
                                   "build"
                                   "--offline"
                                   "--release"
                                   "--target"
                                   "wasm32-unknown-unknown"
                                   "--package"
                                   crate
                                   (if (string=? features "")
                                       '()
                                       (list "--features" features)))))
                        '#$modules)))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (for-each (lambda (package)
                            (copy-recursively (string-append "packages/"
                                                             package)
                                              (string-append out "/" package))
                            (copy-recursively "shared"
                                              (string-append out "/" package
                                                             "/shared")))
                          '#$packages)
                (for-each (lambda (module)
                            (let* ((stem (list-ref module 1))
                                   (destination (string-append out "/"
                                                               (list-ref
                                                                module 2))))
                              (mkdir-p destination)
                              (invoke "wasm-bindgen"
                                      "--target"
                                      "web"
                                      "--out-dir"
                                      destination
                                      "--out-name"
                                      stem
                                      (string-append
                                       "target/wasm32-unknown-unknown/release/"
                                       stem ".wasm"))))
                          '#$modules))))
          (delete 'check)
          (add-after 'install 'check-bindings
            (lambda* (#:key outputs tests? #:allow-other-keys)
              (when tests?
                (for-each (lambda (module)
                            (let ((prefix (string-append (assoc-ref outputs
                                                                    "out") "/"
                                                         (list-ref module 2)
                                                         "/"
                                                         (list-ref module 1))))
                              (invoke "node" "--input-type=module" "-e"
                                      (string-append
                                       "import {readFileSync} from 'node:fs'; import {initSync} from '"
                                       prefix
                                       ".js'; initSync({module:readFileSync('"
                                       prefix "_bg.wasm')});"))))
                          '#$modules)))))))
    (native-inputs (list t3code-wasm-bindgen rust-wasm-sysroot-for-t3code
                         lld-22 node))
    (inputs (cargo-inputs (string->symbol name)
                          #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/openooxml/betteroffice")
    (synopsis "Source-built document WebAssembly and JavaScript bindings")
    (description
     "This package builds BetterOffice's WebAssembly cores and
matching JavaScript bindings, together with the TypeScript sources consumed
by T3 Code's web build.")
    (license license:asl2.0)))

(define-public t3code-betteroffice-docx-wasm
  (betteroffice-wasm "t3code-betteroffice-docx-wasm"
                     "0.4.3"
                     "da04b4356d75ab78379312e7523c5442b1660692"
                     "1xpfblvp6ngdvsnkkbrnawry4qlrv1q1vrfz3bann1b1mvikxx9m"
                     '(("betteroffice-opc" "ooxml_opc"
                        "docx/src/wasm/generated/opc" "wasm")
                       ("betteroffice-docx-layout" "docx_layout"
                        "docx/src/wasm/generated/layout" "")
                       ("betteroffice-docx-edit" "docx_edit"
                        "docx/src/wasm/generated/edit"
                        "wasm,tiff,metafile,heap-stats")
                       ("betteroffice-docx-parse" "docx_parse"
                        "docx/src/wasm/generated/parse" "wasm,tiff,metafile"))
                     '("docx")))

(define-public t3code-betteroffice-sheets-wasm
  (betteroffice-wasm "t3code-betteroffice-sheets-wasm"
                     "0.3.0"
                     "34b9e93a657158fcf3d1d1035df3202031625bdd"
                     "0bwnjsfscx2nkqm3xr8yd3sbv12hfakdn0jg4pxbzljahrp4z1pg"
                     '(("pptx-wasm" "pptx_wasm" "pptx/src/wasm/generated" "")
                       ("xlsx-wasm" "xlsx_wasm" "xlsx/src/wasm/generated" ""))
                     '("pptx" "xlsx")))

(define %sql-wasm-tests
  (local-file (canonicalize-path
               (search-path %load-path
                 "roquix/packages/aux-files/t3code/package-tests/check-sql-wasm.cjs"))))

(define-public t3code-sql-wasm
  (package
    (name "t3code-sql-wasm")
    (version "1.15.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://codeload.github.com/sql-js/sql.js/tar.gz/2824d38946bab8b81d3000d5db8435411cb212ff")
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0nzbi9zibikhc8d15fhcds97qxr04nlknnnj4mqp5l30prc8dbpl"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              (setenv "EM_CACHE"
                      (string-append (getcwd) "/em-cache"))
              (mkdir-p "sqlite-src")
              (invoke "unzip"
                      (assoc-ref inputs "sqlite-amalgamation") "-d"
                      "sqlite-src")
              (copy-file (assoc-ref inputs "extension-functions")
               "sqlite-src/sqlite-amalgamation-3540000/extension-functions.c")
              (mkdir-p "cache")
              (copy-file (assoc-ref inputs "sqlite-amalgamation")
                         "cache/sqlite-amalgamation-3540000.zip")
              (copy-file (assoc-ref inputs "extension-functions")
                         "cache/extension-functions.c")
              (invoke "touch"
               "sqlite-src/sqlite-amalgamation-3540000/extension-functions.c"
               "sqlite-src/sqlite-amalgamation-3540000")
              (mkdir-p "dist")))
          (replace 'build
            (lambda _
              (invoke "make" "dist/sql-wasm.js" "dist/sql-wasm-browser.js"
                      "EMFLAGS_OPTIMIZED=-Oz -flto")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node" #$%sql-wasm-tests))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (for-each (lambda (file)
                          (install-file file
                                        (assoc-ref outputs "out")))
                        '("dist/sql-wasm.js" "dist/sql-wasm.wasm"
                          "dist/sql-wasm-browser.js" "dist/sql-wasm-browser.wasm"
                          "LICENSE")))))))
    (native-inputs (list (list "emscripten" emscripten-for-t3code)
                         (list "node" node)
                         (list "unzip" unzip)
                         (list "sqlite-amalgamation"
                               (origin
                                 (method url-fetch)
                                 (uri
                                  "https://sqlite.org/2026/sqlite-amalgamation-3540000.zip")
                                 (sha256 (base32
                                          "0kdanm3bwmy9a0g2l16dss04x23ji2i99iciygjv9ilfzsq17sb8"))))
                         (list "extension-functions"
                               (origin
                                 (method url-fetch)
                                 (uri
                                  "https://www.sqlite.org/contrib/download/extension-functions.c?get=25")
                                 (file-name "extension-functions.c")
                                 (sha256 (base32
                                          "0lj0zq7k748812m9d64x5i8k7a0l1y4hn9pp2p1fv697igz406wr"))))))
    (home-page "https://github.com/sql-js/sql.js")
    (synopsis "SQLite WebAssembly with matching JavaScript API")
    (description "This package compiles SQLite and the sql.js JavaScript API
for T3 Code's browser database viewer.")
    (license license:expat)))

(define %pdfjs-source
  (origin
    (method url-fetch)
    (uri
     "https://codeload.github.com/mozilla/pdf.js/tar.gz/d0991a0d53f3bb3a7307e3b83f279c1d117aafb3")
    (file-name "pdfjs-6.4.299.tar.gz")
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
                                               (chdir
                                                "pdf.js-d0991a0d53f3bb3a7307e3b83f279c1d117aafb3")
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
    (uri "pdfjs-6.4.299")
    (file-name "pdfjs-node-modules-6.4.299")
    (sha256 (base32 "1lhy030nqs0nb0s535k88k84bgfzrhz1v3xr779w3i3rbvapyfv5"))))

(define t3code-qcms-bindgen
  (package
    (inherit t3code-wasm-bindgen)
    (name "t3code-qcms-bindgen")
    (version "0.2.100")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://static.crates.io/crates/wasm-bindgen-cli/wasm-bindgen-cli-"
             version ".crate"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0n9cp75m6jq6k4c8sfjjn66q7h097w1ns5w49xpppj402ps0czwy"))))
    (inputs (cargo-inputs 't3code-qcms-bindgen
                          #:module '(roquix packages rust-crates)))))

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
    (native-inputs (list t3code-qcms-bindgen
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
                                  "roquix/packages/aux-files/t3code/package-tests/check-pdfjs-wasm.mjs"))))

(define-public t3code-pdfjs-wasm
  (package
    (name "t3code-pdfjs-wasm")
    (version "6.4.299")
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
              (setenv "EM_CACHE"
                      (string-append (getcwd) "/em-cache"))
              (copy-recursively #$%pdfjs-node-modules "node_modules")
              (invoke "chmod" "-R" "u+w" "node_modules")
              (for-each delete-file
                        (filter elf-file?
                                (find-files "node_modules" ".*")))
              (setenv "PATH"
                      (string-append (getcwd) "/node_modules/.bin:"
                                     (getenv "PATH")))
              (for-each (lambda (name)
                          (mkdir-p name)
                          (invoke "tar"
                                  "xf"
                                  (assoc-ref inputs name)
                                  "--strip-components=1"
                                  "-C"
                                  name))
                        '("openjpeg-bindings" "openjpeg-core" "jbig2-bindings"
                          "pdfium" "quickjs-bindings" "quickjs-core"))
              (for-each (lambda (pair)
                          (let ((patches (map canonicalize-path
                                              (find-files (car pair)
                                                          "\\.patch$"))))
                            (with-directory-excursion (cdr pair)
                              (for-each (lambda (patch)
                                          (invoke "patch" "-p1" "-i" patch))
                                        patches))))
                        '(("openjpeg-bindings" . "openjpeg-core")
                          ("quickjs-bindings" . "quickjs-core")))
              (substitute* '("openjpeg-bindings/compile.sh"
                             "jbig2-bindings/compile.sh")
                (("WASM2JS=.*")
                 (string-append "WASM2JS="
                                (which "wasm2js") "\n"))
                (("TERSER=.*")
                 (string-append "TERSER="
                                (which "terser") "\n")))
              (substitute* "quickjs-bindings/compile.sh"
                (("--closure 1")
                 "--closure 0"))
              (substitute* "gulpfile.mjs"
                (("let buildNumber = 0;")
                 "let buildNumber = 299;")
                (("const buildCommit = .*;")
                 "const buildCommit = 'd0991a0d53';"))
              (for-each delete-file
                        (find-files "external" "\\.wasm$"))
              (copy-recursively #$t3code-qcms-wasm "external/qcms")))
          (replace 'build
            (lambda _
              (let ((root (getcwd)))
                (setenv "OPENJPEG"
                        (string-append root "/openjpeg-core"))
                (setenv "INPUT"
                        (string-append root "/openjpeg-bindings/src"))
                (setenv "OUTPUT"
                        (string-append root "/external/openjpeg"))
                (for-each (lambda (kind)
                            (setenv "BUILD_TYPE" kind)
                            (invoke "sh" "openjpeg-bindings/compile_lib.sh"))
                          '("wasm" "js"))
                (invoke "sh" "openjpeg-bindings/compile.sh")
                (setenv "PDFIUM"
                        (string-append root "/pdfium"))
                (setenv "INPUT"
                        (string-append root "/jbig2-bindings/src"))
                (setenv "OUTPUT"
                        (string-append root "/external/jbig2"))
                (with-directory-excursion "jbig2-bindings"
                  (invoke "sh" "compile.sh"))
                (setenv "QUICKJS"
                        (string-append root "/quickjs-core"))
                (setenv "INPUT"
                        (string-append root "/quickjs-bindings/src"))
                (setenv "OUTPUT"
                        (string-append root "/external/quickjs"))
                (invoke "sh" "quickjs-bindings/compile.sh")
                (invoke "node" "node_modules/gulp/bin/gulp.js" "generic")
                (copy-file "build/generic/build/pdf.worker.mjs"
                           "build/generic/build/pdf.worker.min.mjs"))))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node"
                        #$%pdfjs-wasm-tests "external")
                (invoke "node" "--input-type=module" "-e"
                 "import{readFileSync,readdirSync}from'node:fs';for(const f of readdirSync('build/generic/web/wasm').filter(f=>f.endsWith('.wasm'))){const b=readFileSync('build/generic/web/wasm/'+f);if(!WebAssembly.validate(b))throw Error(f)}"))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((out (assoc-ref outputs "out")))
                (copy-recursively "build/generic/build"
                                  (string-append out "/build"))
                (copy-recursively "build/generic/web/wasm"
                                  (string-append out "/wasm"))
                (install-file "LICENSE" out)))))))
    (native-inputs (list (list "emscripten" emscripten-for-t3code)
                         (list "node" node)
                         (list "binaryen" binaryen)
                         (list "cmake" cmake-minimal)
                         (list "qcms" t3code-qcms-wasm)
                         (list "openjpeg-bindings"
                               (github-snapshot "mozilla/pdf.js.openjpeg"
                                "d5f16ba380391d4e32b51834e2e0afa796e402d8"
                                "0gf7dgf02z5insdrw0yl91dyx2lr8045mfzpc1gc2zwh62qmfy42"))
                         (list "openjpeg-core"
                               (github-snapshot "uclouvain/openjpeg"
                                "8314119b067c0fc77834731168daaebd379fdb12"
                                "08a3162p5c9gmkz4r5ndfl1rz069pyqjp1086dsfi211pfxfh8z7"))
                         (list "jbig2-bindings"
                               (github-snapshot "mozilla/pdf.js.jbig2"
                                "d11108f08f8a979b3ff9cbc209783ab05927c37b"
                                "1g9fxclkd28bjjmhvgfz4dap2ghcxp8xa2shi6v5rgq0nnbvqfhs"))
                         (list "pdfium"
                               (github-snapshot "chromium/pdfium"
                                "bb1f9f71e7b15afdd5937adf8cfe5807522b882f"
                                "0hhk6ybm6i3jqdmxpm69ykw37dnh9ch5yar9v1xpqr339hfqw2aq"))
                         (list "quickjs-bindings"
                               (github-snapshot "mozilla/pdf.js.quickjs"
                                "e2c5bfc8194b16f5973eea5e4e025b67be3c1015"
                                "0bdpnbzah7giq34j4ff2rh8l8cfgdmdk31b204r3bawlzj3ddapl"))
                         (list "quickjs-core"
                               (github-snapshot "bellard/quickjs"
                                "3d5e064e9dd67c70f7962836505a7fa067bf0a4e"
                                "0pg02mzb9c6fc481xq155ywx0vi3qygr1rj3mx4lw6p26cax3k5g"))))
    (home-page "https://mozilla.github.io/pdf.js/")
    (synopsis "PDF.js with source-built WebAssembly codecs")
    (description
     "This package builds PDF.js together with its OpenJPEG,
JBIG2, qcms, and QuickJS WebAssembly modules.  The JavaScript worker is built
with the matching generated codec bindings.")
    (license license:asl2.0)))
