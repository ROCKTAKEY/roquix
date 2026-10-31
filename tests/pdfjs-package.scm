(use-modules (guix packages)
             (guix store)
             (guix derivations)
             (roquix packages pdfjs)
             (srfi srfi-64))

(test-begin "pdfjs-package")

(define changed-quickjs
  (package (inherit pdfjs-quickjs-wasm) (version "test-update")))
(define rewrite
  (package-input-rewriting (list (cons pdfjs-quickjs-wasm changed-quickjs))))
(define changed-pdfjs (rewrite t3code-pdfjs-wasm))

(define (input package label)
  (cadr (assoc label (package-native-inputs package))))

(with-store store
  (define (drv package)
    (derivation-file-name (package-derivation store package #:graft? #f)))
  (for-each
   (lambda (label)
     (test-equal "a QuickJS update reuses independently built codecs"
       (drv (input t3code-pdfjs-wasm label))
       (drv (input changed-pdfjs label))))
   '("openjpeg" "jbig2" "qcms"))
  (test-assert "a QuickJS update rebuilds its bindings"
    (not (equal? (drv (input t3code-pdfjs-wasm "quickjs"))
                 (drv (input changed-pdfjs "quickjs")))))
  (test-assert "the PDF worker rebuilds against updated bindings"
    (not (equal? (drv t3code-pdfjs-wasm) (drv changed-pdfjs)))))

(let ((runner (test-runner-current)))
  (test-end "pdfjs-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
