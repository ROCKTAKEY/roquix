(use-modules (roquix build bun-build-system jsonc)
             (srfi srfi-64))

(define (parse text)
  (call-with-input-string text jsonc->scm))

(test-begin "bun-jsonc")

(test-equal "removes comments and trailing commas"
            '(("items" . #(1 2)))
            (parse "{/* block */\"items\":[1,2,],// line\n}"))

(test-equal "preserves comment and comma syntax inside strings"
            '(("url" . "https://example.test/*literal*/,}"))
            (parse "{\"url\":\"https://example.test/*literal*/,}\",}"))

(test-error "rejects an unterminated block comment" #t
            (parse "{/* unterminated"))

(let ((runner (test-runner-current)))
  (test-end "bun-jsonc")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
