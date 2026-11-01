(use-modules (roquix build hermes node-sources)
             (guix build utils) (guix base64)
             ((guix build syscalls) #:select (mkdtemp!))
             (rnrs bytevectors) (rnrs io ports)
             (ice-9 ftw) (srfi srfi-64))
(test-begin "hermes-node-sources")
  (let ((root (mkdtemp! "/tmp/hermes-sanitize.XXXXXX")))
    (dynamic-wind
      (lambda () #t)
      (lambda ()
        (define (write-source name content)
          (let ((path (string-append root "/" name)))
            (mkdir-p (dirname path))
            (call-with-output-file path (lambda (p) (put-bytevector p content)))))
        (for-each (lambda (name bytes) (write-source name (u8-list->bytevector bytes)))
                  '("linux.node" "windows.exe" "mac.node" "codec.wasm")
                  '((127 69 76 70 0) (77 90 0) (207 250 237 254) (0 97 115 109)))
        (write-source "source.js" (string->utf8 "export const value = 1;"))
        (sanitize-node-sources root)
        (test-equal "platform binaries and WASM are removed, source is retained"
          '("." ".." "source.js") (scandir root))
        ;; The recognizable WASM prefix is followed by an unknown payload.
        (write-source "unknown.js" (string->utf8 "const wasm='AGFzbQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';"))
        (test-error "unknown embedded WASM is rejected" #t (sanitize-node-sources root))
        (delete-file (string-append root "/unknown.js"))
        (write-source "node_modules/vite/dist/node/chunks/build.js"
          (string->utf8 "//#region node_modules/loader-utils/lib/hash/xxhash64.js\nAGFzbQAAAAAAAAAAAAAAAAAAAAAAAA\n//#endregion\n//#region node_modules/loader-utils/lib/hash/md4.js\nAGFzbQAAAAAAAAAAAAAAAAAAAAAAAA\n//#endregion\n"))
        (sanitize-node-sources root)
        (test-equal "Vite hash wrappers use the JS adapters"
          "import __hermesHashes from 'hermes-source-hashes';\nvar require_xxhash64 = () => __hermesHashes.createXxhash64;\nvar require_md4 = () => __hermesHashes.createMd4;\n"
          (call-with-input-file (string-append root "/node_modules/vite/dist/node/chunks/build.js") get-string-all)))
      (lambda () (delete-file-recursively root))))
(let ((failures (test-runner-fail-count (test-runner-current))))
  (test-end "hermes-node-sources") (exit (zero? failures)))
