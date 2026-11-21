(use-modules (guix build utils)
             (rnrs bytevectors)
             (rnrs io ports)
             (srfi srfi-64))

(define sanitize
  (false-if-exception
   (module-ref (resolve-interface '(roquix build marp))
               'remove-prebuilt-code)))

(test-begin "marp-prebuilt-inputs")
(test-assert "prebuilt code sanitization is available" (procedure? sanitize))
(when sanitize
  (let ((directory (mkdtemp "/tmp/marp-prebuilt-inputs.XXXXXX")))
    (dynamic-wind
      (const #t)
      (lambda ()
        (for-each
         (lambda (entry)
           (call-with-output-file (string-append directory "/" (car entry))
             (lambda (port)
               (put-bytevector port (u8-list->bytevector (cdr entry))))))
         '(("elf" 127 69 76 70) ("pe" 77 90 144 0)
           ("macho" 207 250 237 254) ("fat-macho" 202 254 186 190)
           ("script.js" 47 47 32 74) ("module.wasm" 0 97 115 109)
           ("archive.a" 33 60 97 114 99 104 62 10)
           ("thin.a" 33 60 116 104 105 110 62 10)
           ("llvm.bc" 66 67 192 222)))
        (sanitize directory)
        (test-equal "compiled objects are excluded; JavaScript is preserved"
          '("script.js")
          (map basename (find-files directory))))
      (lambda () (delete-file-recursively directory)))))
(when sanitize
  (let ((directory (mkdtemp "/tmp/marp-embedded-inputs.XXXXXX")))
    (dynamic-wind
      (const #t)
      (lambda ()
        (mkdir-p (string-append directory "/es-module-lexer/dist"))
        (call-with-output-file
            (string-append directory "/es-module-lexer/dist/lexer.js")
          (lambda (port) (display "const wasm = 'AGFzbQEAAAA=';" port)))
        (sanitize directory)
        (test-equal "unused embedded WASM is removed" '() (find-files directory))
        (call-with-output-file (string-append directory "/unknown.js")
          (lambda (port) (display "const wasm = 'AGFzbQEAAAA=';" port)))
        (test-error "unreviewed embedded WASM fails the fetch" #t
                    (sanitize directory)))
      (lambda () (delete-file-recursively directory)))))
(let ((runner (test-runner-current)))
  (test-end "marp-prebuilt-inputs")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
