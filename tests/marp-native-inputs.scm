(use-modules (guix build utils)
             (rnrs bytevectors)
             (rnrs io ports)
             (srfi srfi-64))

(define sanitize
  (false-if-exception
   (module-ref (resolve-interface '(roquix build marp))
               'remove-prebuilt-native-code)))

(test-begin "marp-native-inputs")
(test-assert "native input sanitization is available" (procedure? sanitize))
(when sanitize
  (let ((directory (mkdtemp "/tmp/marp-native-inputs.XXXXXX")))
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
           ("script.js" 47 47 32 74) ("module.wasm" 0 97 115 109)))
        (sanitize directory)
        (test-equal "native objects are excluded; JS and WASM are unchanged"
          '("module.wasm" "script.js")
          (map basename (find-files directory))))
      (lambda () (delete-file-recursively directory)))))
(let ((runner (test-runner-current)))
  (test-end "marp-native-inputs")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
