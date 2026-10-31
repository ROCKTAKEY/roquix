(define-module (roquix packages hermes-wasm)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages python)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages node-xyz)
  #:use-module (gnu packages web)
  #:use-module ((guix licenses) #:prefix license:))

(define %emscripten-source
  (origin
    (method url-fetch)
    (uri "https://codeload.github.com/emscripten-core/emscripten/tar.gz/3.1.59")
    (file-name "emscripten-3.1.59.tar.gz")
    (sha256 (base32 "192jy4cij1q59g611vjc6s0l1idca3ixkk74npi0spphqip6zwjm"))))

(define %prepare-emscripten
  #~(lambda _
      ;; Cross-compilation must use Emscripten's libc and C++ headers.
      (for-each unsetenv '("C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH" "OBJC_INCLUDE_PATH"
                           "CPATH" "LIBRARY_PATH"))
      (mkdir "emscripten")
      (invoke "tar" "xf" #$%emscripten-source "--strip-components=1" "-C" "emscripten")
      (mkdir-p "llvm/bin")
      (for-each (lambda (directory)
                  (for-each (lambda (file)
                              (let ((target (string-append "llvm/bin/" (basename file))))
                                (unless (file-exists? target) (symlink file target))))
                            (find-files directory ".*")))
                (list #$(file-append llvm-19 "/bin")
                      #$(file-append clang-19 "/bin")
                      #$(file-append lld-19 "/bin")))
      (setenv "HOME" (getcwd))
      (setenv "EM_CONFIG" (string-append (getcwd) "/emscripten.config"))
      (setenv "EM_CACHE" (string-append (getcwd) "/emscripten-cache"))
      ;; Guix Clang has native libc paths compiled into its defaults. Keep
      ;; those out of the wasm target, including Emscripten's library builds.
      (for-each
        (lambda (compiler)
          (let ((wrapper (string-append "llvm/bin/" compiler)))
            (delete-file wrapper)
            (call-with-output-file wrapper
              (lambda (port)
                (format port "#!~a/bin/bash~%exec ~a/bin/~a -Wno-unused-command-line-argument -nostdinc ~a -isystem ~s -isystem ~s -isystem ~s \"$@\"~%"
                        #$bash-minimal #$clang-19 compiler
                        (if (string=? compiler "clang++")
                            (string-append "-isystem " (getenv "EM_CACHE") "/sysroot/include/c++/v1") "")
                        (string-append (getenv "EM_CACHE") "/sysroot/include/compat")
                        #$(file-append clang-19 "/lib/clang/19/include")
                        (string-append (getenv "EM_CACHE") "/sysroot/include"))))
            (chmod wrapper #o755)))
        '("clang" "clang++"))
      (setenv "EMCC_CORES" (number->string (parallel-job-count)))
      (symlink #$(file-append node-acorn "/lib/node_modules") "emscripten/node_modules")
      (setenv "NODE_PATH" #$(file-append node-acorn "/lib/node_modules"))
      (call-with-output-file (getenv "EM_CONFIG")
        (lambda (port)
          (format port "LLVM_ROOT = ~s~%BINARYEN_ROOT = ~s~%NODE_JS = [~s]~%"
                  (string-append (getcwd) "/llvm/bin")
                  #$binaryen #$(file-append node "/bin/node"))))
      (setenv "PATH" (string-append (getcwd) "/emscripten:" (getenv "PATH")))))

(define-public hermes-yoga-wasm
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
            (add-after 'unpack 'prepare-emscripten #$%prepare-emscripten)
            (replace 'configure
              (lambda _
                ;; Closure only minifies the JS loader; esbuild handles that
                ;; in the consuming TUI build, without a downloaded Java tool.
                (substitute* "javascript/CMakeLists.txt"
                  (("--closure 1") "--closure 0")
                  ((".*--memory-init-file.*") ""))
                (invoke "emcmake" "cmake" "-S" "javascript" "-B" "wasm-build")))
            (replace 'build
              (lambda _ (invoke "cmake" "--build" "wasm-build" "-j"
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
    (native-inputs (list python cmake-minimal node))
    (home-page "https://www.yogalayout.dev/")
    (synopsis "Source-built Yoga WebAssembly for Hermes Ink")
    (description "This package builds Yoga's JavaScript binding and embedded WebAssembly from C++ sources with Guix's LLVM and Binaryen tools.")
    (license license:expat)))

(define-public hermes-es-module-lexer-wasm
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
            (add-after 'unpack 'prepare-emscripten #$%prepare-emscripten)
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
    (synopsis "Source-built ECMAScript module lexer WebAssembly")))
