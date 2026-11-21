(define-module (roquix build marp)
  #:use-module (guix build utils)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-1)
  #:export (remove-prebuilt-code))

(define mz-file?
  (file-header-match #vu8(#x4d #x5a)))

(define wasm-file?
  (file-header-match #vu8(#x00 #x61 #x73 #x6d)))

(define thin-archive-file?
  (file-header-match #vu8(#x21 #x3c #x74 #x68 #x69 #x6e #x3e #x0a)))

(define llvm-bitcode-file?
  (let ((raw? (file-header-match #vu8(#x42 #x43 #xc0 #xde)))
        (wrapped? (file-header-match #vu8(#xde #xc0 #x17 #x0b))))
    (lambda (file) (or (raw? file) (wrapped? file)))))

(define mach-o-file?
  ;; Cover both byte orders of 32/64-bit Mach-O and universal binaries.
  (let ((predicates
         (map file-header-match
              '(#vu8(#xfe #xed #xfa #xce) #vu8(#xce #xfa #xed #xfe)
                #vu8(#xfe #xed #xfa #xcf) #vu8(#xcf #xfa #xed #xfe)
                #vu8(#xca #xfe #xba #xbe) #vu8(#xbe #xba #xfe #xca)
                #vu8(#xca #xfe #xba #xbf) #vu8(#xbf #xba #xfe #xca)))))
    (lambda (file)
      (any (lambda (predicate) (predicate file)) predicates))))

(define (compiled-code? file)
  ;; npm archives include extensionless executables as well as Node addons.
  (or (elf-file? file) (mz-file? file) (mach-o-file? file)
      (ar-file? file) (thin-archive-file? file)
      (llvm-bitcode-file? file) (wasm-file? file)))

(define (remove-prebuilt-code directory)
  (for-each
   (lambda (file)
     (when (and (not (eq? 'symlink (stat:type (lstat file))))
                (compiled-code? file))
       (delete-file file)))
   (find-files directory))
  (remove-embedded-wasm directory))

(define %embedded-wasm-files
  ;; QuickJS is replaced from source; the other loaders belong to development
  ;; dependencies that Marp's Rollup configuration does not use.
  '("cjs-module-lexer/dist/lexer.js"
    "cjs-module-lexer/dist/lexer.mjs"
    "undici/lib/llhttp/llhttp-wasm.js"
    "undici/lib/llhttp/llhttp_simd-wasm.js"
    "postject/dist/api.js"
    "prettier/plugins/flow.mjs"
    "prettier/plugins/flow.js"
    "loader-utils/lib/hash/xxhash64.js"
    "loader-utils/lib/hash/md4.js"
    "@tootallnate/quickjs-emscripten/dist/generated/emscripten-module.WASM_RELEASE_SYNC.js"
    "@tootallnate/quickjs-emscripten/dist/generated/emscripten-module.WASM_RELEASE_SYNC.js.map"
    "es-module-lexer/dist/lexer.minimal.js"
    "es-module-lexer/dist/lexer.minimal.cjs"
    "es-module-lexer/dist/lexer.js"
    "es-module-lexer/dist/lexer.cjs"))

(define %base64-wasm
  (make-regexp "AGFzbQ[A-Za-z0-9+/=]{6,}"))

(define (remove-embedded-wasm directory)
  (for-each
   (lambda (relative)
     (let ((file (string-append directory "/" relative)))
       (when (file-exists? file) (delete-file file))))
   %embedded-wasm-files)
  ;; Reject newly introduced base64 WASM instead of silently disabling code
  ;; whose role in the dependency graph has not been established.
  (for-each
   (lambda (file)
     (when (regexp-exec %base64-wasm
                         (call-with-input-file file get-string-all))
       (error "Unreviewed embedded WebAssembly" file)))
   (find-files directory "\\.(js|cjs|mjs|map)$")))
