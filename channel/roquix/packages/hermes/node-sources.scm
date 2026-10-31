(define-module (roquix packages hermes node-sources)
  #:use-module (guix build utils)
  #:use-module (guix base64)
  #:use-module (guix base16)
  #:use-module (gcrypt hash)
  #:use-module (ice-9 regex)
  #:use-module (rnrs bytevectors)
  #:use-module (rnrs io ports)
  #:use-module (srfi srfi-1)
  #:export (sanitize-node-sources))

(define (binary? file)
  (let* ((bytes (call-with-input-file file (lambda (p) (get-bytevector-n p 4))))
         (header (if (eof-object? bytes) '() (bytevector->u8-list bytes))))
    (or (member header '((127 69 76 70) (0 97 115 109)
                         (207 250 237 254) (206 250 237 254)
                         (254 237 250 207) (254 237 250 206)
                         (202 254 186 190)))
        (and (>= (length header) 2) (equal? (take header 2) '(77 90))))))

(define (write-text file text)
  (call-with-output-file file (lambda (p) (display text p))))

(define (replace-vite-hash text algorithm factory)
  (let* ((pattern (string-append "//#region [^\n]*loader-utils[^\n]*/"
                                 algorithm "\\.js\n"))
         (matches (list-matches pattern text)))
    (unless (= (length matches) 1)
      (error "changed Vite hash wrapper" algorithm))
    (let* ((start (car matches))
           (end (string-contains text "//#endregion" (match:end start))))
      (unless end (error "missing Vite hash wrapper terminator" algorithm))
      (string-append (substring text 0 (match:start start))
                     "var require_" algorithm " = () => __hermesHashes."
                     factory ";"
                     (substring text (+ end (string-length "//#endregion")))))))

(define (replace-embedded-wasm file root)
  (let* ((text (call-with-input-file file get-string-all))
         (pattern "AGFzbQ[A-Za-z0-9+/=]{20,}")
         (name (substring file (string-length root))))
    (when (string-match pattern text)
      (cond
       ((or (any (lambda (part) (string-contains name part))
                 '("/undici/lib/llhttp/" "/postject/" "/three/examples/"
                   "/@shikijs/engine-oniguruma/dist/wasm-inlined.mjs"
                   "/prettier/plugins/flow." "/tsx/dist/lexer-" "/@vitest/mocker/"))
            (string=? (basename file) "yoga-wasm-base64-esm.js"))
        (delete-file file))
       ((string-suffix? "/vite/dist/node/chunks/build.js" name)
        (write-text file
          (string-append "import __hermesHashes from 'hermes-source-hashes';\n"
            (replace-vite-hash
             (replace-vite-hash text "xxhash64" "createXxhash64")
             "md4" "createMd4"))))
       (else
        (write-text file
          (regexp-substitute/global
           #f pattern text 'pre
           (lambda (match)
             (let* ((digest (substring (bytevector->base16-string
                                        (sha256 (base64-decode (match:substring match)))) 0 12))
                    (marker (assoc-ref '(("04270c743e88" . "HERMES_SOURCE_LEXER_FULL")
                                         ("44c8677a6404" . "HERMES_SOURCE_LEXER_MINIMAL")) digest)))
               (or marker (error "unclassified embedded WASM" name digest))))
           'post)))))))

(define (sanitize-node-sources root)
  (for-each
   (lambda (file)
     (unless (eq? 'symlink (stat:type (lstat file)))
       (cond ((binary? file) (delete-file file))
             ((string-match "\\.(js|mjs|cjs)$" file)
              (replace-embedded-wasm file root)))))
   (find-files root))
  ;; Select the same JS regex engine as Streamdown so bundlers cannot pull in
  ;; Shiki's precompiled Oniguruma WASM fallback.
  (for-each
   (lambda (file)
     (when (string-contains file "/shiki/dist/")
       (let ((text (call-with-input-file file get-string-all)))
         (when (string-contains text "createOnigurumaEngine")
           (write-text file
             (string-append
              "import { createJavaScriptRegexEngine } from '@shikijs/engine-javascript';\n"
              (regexp-substitute/global
               #f (make-regexp "engine: \\(\\) => .*createOnigurumaEngine.*" regexp/newline)
               (regexp-substitute/global
                #f (make-regexp "^import .*engine.oniguruma.*;\n" regexp/newline)
                text 'pre "" 'post)
               'pre "engine: () => createJavaScriptRegexEngine({ forgiving: true })" 'post)))))))
   (find-files root "^bundle-.*\\.mjs$"))
  (for-each
   (lambda (file)
     (when (string-suffix? "/@shikijs/engine-oniguruma/dist/wasm-inlined.mjs" file)
       (delete-file file)))
   (find-files root "^wasm-inlined\\.mjs$")))
