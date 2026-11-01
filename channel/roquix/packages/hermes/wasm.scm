(define-module (roquix packages hermes wasm)
  #:use-module (roquix packages wasm)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages python)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages node)
  #:use-module ((guix licenses) #:prefix license:))

(define %prepare-wasm-cache
  #~(lambda _
      (setenv "HOME" (getcwd))
      (setenv "EM_CACHE" (string-append (getcwd) "/emscripten-cache"))
      (setenv "EMCC_CORES" (number->string (parallel-job-count)))))

(define-public hermes-yoga-wasm
  (hidden-package
    (package
      (name "hermes-yoga-wasm")
      (version "3.2.1")
      (source
        (origin
          (method url-fetch)
          (uri "https://codeload.github.com/facebook/yoga/tar.gz/v3.2.1")
          (file-name "yoga-3.2.1.tar.gz")
          (sha256 (base32 "0mcb11d9ph36m6lb40akqiphnsdv66p3yg42za7hv0px66n9kcw6"))))
      (build-system gnu-build-system)
      (arguments
        (list
          #:phases
          #~(modify-phases %standard-phases
              (add-after 'unpack 'prepare-emscripten #$%prepare-wasm-cache)
              (replace 'configure
                (lambda _
                  ;; Closure only minifies the JS loader; esbuild handles that
                  ;; in the consuming TUI build, without a downloaded Java tool.
                  (substitute* "javascript/CMakeLists.txt"
                    (("--closure 1") "--closure 0")
                    ((".*--memory-init-file.*") ""))
                  (invoke "emcmake" "cmake" "-S" "javascript" "-B" "wasm-build")))
              ;; CMake calls Emscripten's internal compiler path directly.
              ;; emmake keeps host include paths out of those child processes.
              (replace 'build
                (lambda _ (invoke "emmake" "cmake" "--build" "wasm-build" "-j"
                                  (number->string (parallel-job-count)))))
              (replace 'check
                (lambda* (#:key tests? #:allow-other-keys)
                  (when tests?
                    (copy-file "javascript/binaries/yoga-wasm-base64-esm.js" "yoga.mjs")
                    (invoke "node" "--input-type=module" "-e"
                      "import load from './yoga.mjs'; const yoga = await load(); if (!yoga) throw Error('Yoga failed to initialize');"))))
              (replace 'install
                (lambda _
                  (mkdir-p #$output)
                  (copy-file "javascript/binaries/yoga-wasm-base64-esm.js"
                             (string-append #$output "/yoga-wasm-base64-esm.js")))))))
      (native-inputs (list emscripten-4 python cmake-minimal node))
      (home-page "https://www.yogalayout.dev/")
      (synopsis "Source-built Yoga WebAssembly for Hermes Ink")
      (description "This package builds Yoga's JavaScript binding and embedded WebAssembly from C++ sources using the shared Guix Emscripten toolchain.")
      (license license:expat))))

(define-public hermes-es-module-lexer-wasm
  (hidden-package
    (package
      (inherit hermes-yoga-wasm)
      (name "hermes-es-module-lexer-wasm")
      (version "2.3.1")
      (source
        (origin
          (method url-fetch)
          (uri "https://codeload.github.com/guybedford/es-module-lexer/tar.gz/2.3.1")
          (file-name "es-module-lexer-2.3.1.tar.gz")
          (sha256 (base32 "0rv26gdkrbz5r3gpl9546svxzmv1n90nrfygq3hni6sx7cwrkwdr"))))
      (arguments
        (list
          #:phases
          #~(modify-phases %standard-phases
              (delete 'configure)
              (add-after 'unpack 'prepare-emscripten #$%prepare-wasm-cache)
              (replace 'build
                (lambda _
                  (mkdir-p "lib")
                  (for-each
                    (lambda (minimal?)
                      (apply invoke "emcc" "src/lexer.c" "-o"
                        (if minimal? "lib/lexer.min.wasm" "lib/lexer.wasm")
                        "-Oz" "-flto" "--no-entry" "-sSTANDALONE_WASM=1"
                        (string-append "-sEXPORTED_FUNCTIONS="
                          (if minimal?
                            "['_parse','_sa','_e','_ri','_re','_it','_is','_ie','_ss','_ip','_se','_ai','_id','_es','_ee','_els','_ele','___heap_base']"
                            "['_parse','_sa','_e','_ri','_re','_it','_is','_ie','_ss','_ip','_se','_ai','_id','_es','_ee','_els','_ele','_ess','_f','_ms','_ra','_rsa','_aks','_ake','_avs','_ave','___heap_base']"))
                        "-sSUPPORT_LONGJMP=0" "-sALLOW_MEMORY_GROWTH=1"
                        "-sERROR_ON_UNDEFINED_SYMBOLS=0"
                        "-Wno-logical-op-parentheses" "-Wno-parentheses"
                        (if minimal? '("-DLEXER_MIN") '())))
                    '(#f #t))))
              (replace 'check
                (lambda* (#:key tests? #:allow-other-keys)
                  (when tests?
                    (invoke "node" "--input-type=module" "-e"
                      "import fs from 'node:fs'; for (const p of ['lib/lexer.wasm','lib/lexer.min.wasm']) { const m = new WebAssembly.Module(fs.readFileSync(p)); if (!WebAssembly.Module.exports(m).some(e=>e.name==='parse')) throw Error(p); }"))))
              (replace 'install
                (lambda _
                  (mkdir-p #$output)
                  (copy-file "lib/lexer.wasm" (string-append #$output "/lexer.wasm"))
                  (copy-file "lib/lexer.min.wasm" (string-append #$output "/lexer.min.wasm")))))))
      (home-page "https://github.com/guybedford/es-module-lexer")
      (synopsis "Source-built ECMAScript module lexer WebAssembly")
      (description "This package compiles the full and minimal ECMAScript module lexers from C source for use by their JavaScript loaders."))))
