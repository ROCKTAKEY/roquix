(define-module (roquix build bun-build-system jsonc)
  #:use-module (ice-9 textual-ports)
  #:use-module (json)
  #:export (jsonc->scm))

(define (strip-comments text)
  (call-with-output-string (lambda (output)
                             (let ((length (string-length text)))
                               (let loop
                                 ((index 0)
                                  (state 'code))
                                 (if (= index length)
                                     (when (eq? state
                                                'block-comment)
                                       (error
                                        "unterminated JSONC block comment"))
                                     (let* ((character (string-ref text index))
                                            (next-index (+ index 1))
                                            (next-character (and (< next-index
                                                                  length)
                                                                 (string-ref
                                                                  text
                                                                  next-index))))
                                       (case state
                                         ((code)
                                          (cond
                                            ((char=? character #\")
                                             (write-char character output)
                                             (loop next-index
                                                   'string))
                                            ((and (char=? character #\/)
                                                  next-character
                                                  (char=? next-character #\/))
                                             (write-char #\space output)
                                             (loop (+ index 2)
                                                   'line-comment))
                                            ((and (char=? character #\/)
                                                  next-character
                                                  (char=? next-character #\*))
                                             (write-char #\space output)
                                             (loop (+ index 2)
                                                   'block-comment))
                                            (else (write-char character output)
                                                  (loop next-index
                                                        'code))))
                                         ((string)
                                          (write-char character output)
                                          (cond
                                            ((and (char=? character #\\)
                                                  next-character)
                                             (write-char next-character output)
                                             (loop (+ index 2)
                                                   'string))
                                            ((char=? character #\")
                                             (loop next-index
                                                   'code))
                                            (else (loop next-index
                                                        'string))))
                                         ((line-comment)
                                          (if (char=? character #\newline)
                                              (begin
                                                (write-char character output)
                                                (loop next-index
                                                      'code))
                                              (loop next-index
                                                    'line-comment)))
                                         ((block-comment)
                                          (cond
                                            ((and (char=? character #\*)
                                                  next-character
                                                  (char=? next-character #\/))
                                             (write-char #\space output)
                                             (loop (+ index 2)
                                                   'code))
                                            ((char=? character #\newline)
                                             (write-char character output)
                                             (loop next-index
                                                   'block-comment))
                                            (else (loop next-index
                                                        'block-comment))))))))))))

(define (skip-whitespace text index)
  (let ((length (string-length text)))
    (let loop
      ((index index))
      (if (and (< index length)
               (char-whitespace? (string-ref text index)))
          (loop (+ index 1)) index))))

(define (strip-trailing-commas text)
  (call-with-output-string (lambda (output)
                             (let ((length (string-length text)))
                               (let loop
                                 ((index 0)
                                  (state 'code))
                                 (when (< index length)
                                   (let* ((character (string-ref text index))
                                          (next-index (+ index 1)))
                                     (case state
                                       ((code)
                                        (cond
                                          ((char=? character #\")
                                           (write-char character output)
                                           (loop next-index
                                                 'string))
                                          ((char=? character #\,)
                                           (let ((following (skip-whitespace
                                                             text next-index)))
                                             (if (and (< following length)
                                                      (memv (string-ref text
                                                             following)
                                                            '(#\} #\])))
                                                 (begin
                                                   (display (substring text
                                                             next-index
                                                             following) output)
                                                   (loop following
                                                         'code))
                                                 (begin
                                                   (write-char character
                                                               output)
                                                   (loop next-index
                                                         'code)))))
                                          (else (write-char character output)
                                                (loop next-index
                                                      'code))))
                                       ((string)
                                        (write-char character output)
                                        (cond
                                          ((and (char=? character #\\)
                                                (< next-index length))
                                           (write-char (string-ref text
                                                                   next-index)
                                                       output)
                                           (loop (+ index 2)
                                                 'string))
                                          ((char=? character #\")
                                           (loop next-index
                                                 'code))
                                          (else (loop next-index
                                                      'string))))))))))))

(define (jsonc->scm port)
  "Read one JSONC value from PORT and return its Scheme representation."
  (json-string->scm (strip-trailing-commas (strip-comments (get-string-all
                                                            port)))))
