(use-modules (gcrypt hash)
             (guix base32)
             (guix import bun)
             (ice-9 match)
             (ice-9 textual-ports)
             (rnrs bytevectors)
             ((rnrs io ports)
              #:select (open-bytevector-input-port))
             (srfi srfi-1)
             (srfi srfi-64))

(define (temporary-file)
  (let* ((template (string-copy "/tmp/bun-importer-test.XXXXXX"))
         (port (mkstemp! template)))
    (display "(define %alpha (list 'old))\n\n" port)
    (display "(define %beta (list 'beta))\n\n" port)
    (display "(define-bun-lock-inputs lookup-bun-lock-inputs\n" port)
    (display "  (%alpha => %alpha)\n" port)
    (display "  (%beta => %beta))\n" port)
    (close-port port)
    template))

(define (read-expressions file)
  (call-with-input-file file
    (lambda (port)
      (let loop ((result '()))
        (let ((expression (read port)))
          (if (eof-object? expression)
              (reverse result)
              (loop (cons expression result))))))))

(define (definition file name)
  (find (match-lambda
          (('define current _)
           (eq? current name))
          (_ #f))
        (read-expressions file)))

(test-begin "bun-importer")

(test-equal "definition becomes a lookup entry"
            '(%fixture => %fixture)
            (bun-lock-expression->entry
             '(define %fixture (list 'value))))

(let* ((contents (string->utf8 "downloaded fixture source"))
       (expected (bytevector->nix-base32-string (sha256 contents)))
       (git-hash "0000000000000000000000000000000000000000000000000000")
       (url-fetches 0)
       (git-fetches 0)
       (resolved
        (resolve-bun-lock-hashes
         '(list
           (base32
            (bun-import-url-hash
             "https://registry.example/fixture.tgz"))
           (base32
            (bun-import-url-hash
             "https://registry.example/fixture.tgz"))
           (base32
            (bun-import-git-hash
             "https://example.org/fixture.git"
             "0123456789abcdef0123456789abcdef01234567")))
         #:fetch-url
         (lambda (url)
           (set! url-fetches (+ url-fetches 1))
           (open-bytevector-input-port contents))
         #:fetch-git
         (lambda (url commit)
           (set! git-fetches (+ git-fetches 1))
           (values commit "/tmp/unused-checkout" git-hash)))))
  (test-equal "URL hash comes from downloaded bytes"
              `(list (base32 ,expected)
                     (base32 ,expected)
                     (base32 ,git-hash))
              resolved)
  (test-equal "repeated URL is downloaded once" 1 url-fetches)
  (test-equal "Git source is downloaded once" 1 git-fetches))

(let ((file (temporary-file)))
  (dynamic-wind
    (const #t)
    (lambda ()
      (update-bun-lock-inputs!
       file '(define %alpha (list 'replacement)))
      (test-equal "existing definition is replaced"
                  '(define %alpha (list 'replacement))
                  (definition file '%alpha))
      (test-equal "existing lookup entry is unique"
                  '((%alpha => %alpha) (%beta => %beta))
                  (extract-bun-lock-inputs file))

      (update-bun-lock-inputs!
       file '(define %aardvark (list 'new)))
      (test-equal "new definition is inserted"
                  '(define %aardvark (list 'new))
                  (definition file '%aardvark))
      (test-equal "lookup entries are sorted"
                  '((%aardvark => %aardvark)
                    (%alpha => %alpha)
                    (%beta => %beta))
                  (extract-bun-lock-inputs file))

      (let ((before (call-with-input-file file get-string-all)))
        (update-bun-lock-inputs!
         file '(define %aardvark (list 'new)))
        (test-equal "reimport is byte-for-byte idempotent"
                    before
                    (call-with-input-file file get-string-all))))
    (lambda ()
      (delete-file file))))

(let* ((template (string-copy "/tmp/bun-importer-empty-test.XXXXXX"))
       (port (mkstemp! template)))
  (display "(define-module (fixture))\n" port)
  (close-port port)
  (dynamic-wind
    (const #t)
    (lambda ()
      (update-bun-lock-inputs!
       template '(define %first (list 'package)))
      (test-equal "first import creates its definition"
                  '(define %first (list 'package))
                  (definition template '%first))
      (test-equal "first import creates the lookup table"
                  '((%first => %first))
                  (extract-bun-lock-inputs template)))
    (lambda ()
      (delete-file template))))

(let ((runner (test-runner-current)))
  (test-end "bun-importer")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
