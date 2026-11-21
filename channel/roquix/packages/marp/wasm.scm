(define-module (roquix packages marp wasm)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix build-system gnu)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages node)
  #:use-module (roquix packages wasm))

(define-public marp-quickjs-wasm
  (hidden-package
   (package
     (name "marp-quickjs-wasm")
     (version "0.23.0")
     (source
      (origin
        (method url-fetch)
        (uri (string-append "https://codeload.github.com/justjake/"
                            "quickjs-emscripten/tar.gz/refs/tags/v" version))
        (file-name (string-append name "-" version ".tar.gz"))
        (sha256
         (base32 "1jbh89w9dsc9asbd1sakhnqlfxb6lfg2agjiv209zp8rzn212xfj"))))
     (build-system gnu-build-system)
     (arguments
      (list
       #:phases
       #~(modify-phases %standard-phases
           (replace 'configure
             (lambda _
               (setenv "HOME" (getcwd))
               (setenv "EM_CACHE" (string-append (getcwd) "/emscripten-cache"))
               (setenv "EMCC_CORES" (number->string (parallel-job-count)))
               ;; The generator only uses APIs provided by Node's fs module.
               (substitute* "generate.ts"
                 (("\"fs-extra\"") "\"node:fs\"")
                 (("require.main === module") "true"))
               (rename-file "generate.ts" "generate.mts")
               (invoke "node" "generate.mts" "symbols" "symbols.json")))
           (replace 'build
             (lambda _
               ;; Match the synchronous release ABI used by pac-resolver.
               ;; SINGLE_FILE generates a fresh WASM payload and its JS loader.
               (apply invoke "emcc" "c/interface.c"
                      "-o" "quickjs.cjs" "-Oz" "-flto" "--no-entry"
                      "-D_GNU_SOURCE" "-DCONFIG_VERSION=\"2021-03-27\""
                      "-DCONFIG_STACK_CHECK" "-DCONFIG_BIGNUM"
                      "-sMODULARIZE=1" "-sEXPORT_NAME=QuickJSRaw"
                      "-sSINGLE_FILE=1" "-sFILESYSTEM=0"
                      "-sALLOW_MEMORY_GROWTH=1" "-sALLOW_TABLE_GROWTH=1"
                      "-sSTACK_SIZE=5242880"
                      "-sEXPORTED_FUNCTIONS=@symbols.json"
                      (string-append
                       "-sEXPORTED_RUNTIME_METHODS=['cwrap','stringToUTF8',"
                       "'lengthBytesUTF8','UTF8ToString','HEAPU8']")
                      (map (lambda (file) (string-append "quickjs/" file))
                           '("quickjs.c" "libregexp.c" "libunicode.c"
                             "cutils.c" "quickjs-libc.c" "libbf.c")))))
           (replace 'check
             (lambda* (#:key tests? #:allow-other-keys)
               (when tests?
                 (invoke "node"
                         #$(local-file
                            (canonicalize-path
                             (search-path %load-path
                              "roquix/packages/marp/check-quickjs-wasm.cjs")))
                         (string-append (getcwd) "/quickjs.cjs")))))
           (replace 'install
             (lambda _
               (install-file "quickjs.cjs" #$output))))))
     (native-inputs (list emscripten-4 node))
     (home-page "https://github.com/justjake/quickjs-emscripten")
     (synopsis "QuickJS WebAssembly for Marp's proxy resolver")
     (description
      "This package compiles QuickJS and its synchronous Emscripten interface
from C sources for use by Marp's proxy auto-configuration resolver.")
     (license license:expat))))
