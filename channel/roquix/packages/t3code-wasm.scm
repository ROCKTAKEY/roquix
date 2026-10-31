(define-module (roquix packages t3code-wasm)
  #:use-module (roquix packages wasm)
  #:use-module (roquix packages t3code wasm-module)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages rust)
  #:use-module ((guix licenses)
                #:prefix license:))

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
                                     #$rust-wasm-sysroot-1.95 " -C linker="
                                     #$(file-append lld-22 "/bin/wasm-ld")))
              #$@(map (lambda (module)
                        #~(invoke "cargo"
                                  "build"
                                  "--offline"
                                  "--release"
                                  "--target"
                                  "wasm32-unknown-unknown"
                                  "--package"
                                  #$(wasm-module-crate module)
                                  #$@(if (null? (wasm-module-features module))
                                         '()
                                         (list "--features"
                                               (string-join (wasm-module-features
                                                             module) ",")))))
                      modules)))
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
                #$@(map (lambda (module)
                          #~(let ((destination (string-append out "/"
                                                              #$(wasm-module-destination
                                                                 module))))
                              (mkdir-p destination)
                              (invoke "wasm-bindgen"
                                      "--target"
                                      "web"
                                      "--out-dir"
                                      destination
                                      "--out-name"
                                      #$(wasm-module-stem module)
                                      #$(string-append
                                         "target/wasm32-unknown-unknown/release/"
                                         (wasm-module-stem module) ".wasm"))))
                        modules))))
          (delete 'check)
          (add-after 'install 'check-bindings
            (lambda* (#:key outputs tests? #:allow-other-keys)
              (when tests?
                #$@(map (lambda (module)
                          #~(let ((prefix (string-append (assoc-ref outputs
                                                                    "out") "/"
                                                         #$(wasm-module-destination
                                                            module) "/"
                                                         #$(wasm-module-stem
                                                            module))))
                              (invoke "node" "--input-type=module" "-e"
                                      (string-append
                                       "import {readFileSync} from 'node:fs'; import {initSync} from '"
                                       prefix
                                       ".js'; initSync({module:readFileSync('"
                                       prefix "_bg.wasm')});")))) modules)))))))
    (native-inputs (list wasm-bindgen-cli-0.2.126 rust-wasm-sysroot-1.95
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
                     (list (wasm-module #:crate "betteroffice-opc"
                                        #:stem "ooxml_opc"
                                        #:destination
                                        "docx/src/wasm/generated/opc"
                                        #:features '("wasm"))
                           (wasm-module #:crate "betteroffice-docx-layout"
                                        #:stem "docx_layout"
                                        #:destination
                                        "docx/src/wasm/generated/layout")
                           (wasm-module #:crate "betteroffice-docx-edit"
                                        #:stem "docx_edit"
                                        #:destination
                                        "docx/src/wasm/generated/edit"
                                        #:features '("wasm" "tiff" "metafile"
                                                     "heap-stats"))
                           (wasm-module #:crate "betteroffice-docx-parse"
                                        #:stem "docx_parse"
                                        #:destination
                                        "docx/src/wasm/generated/parse"
                                        #:features '("wasm" "tiff" "metafile")))
                     '("docx")))

(define-public t3code-betteroffice-sheets-wasm
  (betteroffice-wasm "t3code-betteroffice-sheets-wasm"
                     "0.3.0"
                     "34b9e93a657158fcf3d1d1035df3202031625bdd"
                     "0bwnjsfscx2nkqm3xr8yd3sbv12hfakdn0jg4pxbzljahrp4z1pg"
                     (list (wasm-module #:crate "pptx-wasm"
                                        #:stem "pptx_wasm"
                                        #:destination
                                        "pptx/src/wasm/generated")
                           (wasm-module #:crate "xlsx-wasm"
                                        #:stem "xlsx_wasm"
                                        #:destination
                                        "xlsx/src/wasm/generated"))
                     '("pptx" "xlsx")))

(define %sql-wasm-tests
  (local-file (canonicalize-path (search-path %load-path
                                  "roquix/packages/t3code/package-tests/check-sql-wasm.cjs"))))

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
                (invoke "node"
                        #$%sql-wasm-tests))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (for-each (lambda (file)
                          (install-file file
                                        (assoc-ref outputs "out")))
                        '("dist/sql-wasm.js" "dist/sql-wasm.wasm"
                          "dist/sql-wasm-browser.js"
                          "dist/sql-wasm-browser.wasm" "LICENSE")))))))
    (native-inputs (list (list "emscripten" emscripten-4)
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
