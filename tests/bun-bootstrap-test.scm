(use-modules (guix download)
             (guix git-download)
             (guix packages)
             (srfi srfi-1)
             (srfi srfi-64))

(define bun-cargo-inputs
  (@@ (roquix packages bun-bootstrap) bun-cargo-inputs))

(define bun-cargo-checksum-entries
  (@@ (roquix packages bun-bootstrap) bun-cargo-checksum-entries))

(define replace-bun-cargo-inputs
  (@@ (roquix packages bun-bootstrap) replace-bun-cargo-inputs))

(define call-with-limited-cpu-affinity
  (@ (roquix build bun-bootstrap affinity)
     call-with-limited-cpu-affinity))

(define %bun-1.0.7-webkit-source
  (@@ (roquix packages bun-bootstrap) %bun-1.0.7-webkit-source))

(define bun-bootstrap-1.0.7
  (@ (roquix packages bun-bootstrap) bun-bootstrap-1.0.7))

(define bun-bootstrap-1.0.30
  (@ (roquix packages bun-bootstrap) bun-bootstrap-1.0.30))

(define bun-bootstrap-1.1.4
  (@ (roquix packages bun-bootstrap) bun-bootstrap-1.1.4))

(define bun-bootstrap-1.1.26
  (@ (roquix packages bun-bootstrap) bun-bootstrap-1.1.26))

(define bun-bootstrap-1.3.1-base
  (@@ (roquix packages bun-bootstrap) bun-bootstrap-1.3.1-base))

(define bun-bootstrap-1.3.14
  (@ (roquix packages bun-bootstrap) bun-bootstrap-1.3.14))

(define %bootstrap-chain
  (list bun-bootstrap-1.0.30 bun-bootstrap-1.1.4 bun-bootstrap-1.1.26
        bun-bootstrap-1.3.14))

(define (package-loads-build-module? package module)
  (every (lambda (keyword)
           (let ((argument (memq keyword (package-arguments package))))
             (and argument
                  (member module (cadr argument)))))
         '(#:imported-modules #:modules)))

(define cargo-input-counts
  '((bun-lol-html-1.0 . 61)
    (bun-lol-html-1.2.0 . 60)
    (bun-lol-html-1.2.17 . 62)
    (bun-lol-html-1.3.1 . 42)
    (bun-lol-html-1.3.13 . 43)))

(test-begin "bun-bootstrap")

(test-assert "seedless stage supplies source-built node-fallback esbuild"
             (assoc-ref (package-native-inputs bun-bootstrap-1.0.7)
                        "esbuild-node-fallbacks"))

(test-assert "complete bootstrap chain stages evaluate"
             (every package? %bootstrap-chain))

(test-assert "CPU affinity limiter restores the original mask"
             (let ((original (getaffinity 0)))
               (and (call-with-limited-cpu-affinity
                     1
                     (lambda ()
                       (= 1 (bitvector-count (getaffinity 0)))))
                    (equal? original (getaffinity 0)))))

(test-assert "shared bootstrap stages import esbuild binding support"
             (let ((arguments (memq #:imported-modules (package-arguments
                                                        bun-bootstrap-1.3.1-base))))
               (and arguments
                    (member '(roquix build bun-bootstrap esbuild)
                            (cadr arguments)))))

(test-assert "TypeScript bootstrap stages load esbuild binding support"
             (package-loads-build-module?
              bun-bootstrap-1.3.14
              '(roquix build bun-bootstrap esbuild)))

(for-each (lambda (entry)
            (let ((inputs (bun-cargo-inputs (car entry))))
              (test-equal (string-append (symbol->string (car entry))
                                         " crate count")
                          (cdr entry)
                          (length inputs))
              (test-assert (string-append (symbol->string (car entry))
                                          " contains standard origins")
                           (every (lambda (input)
                                    (and (origin? input)
                                         (eq? url-fetch
                                              (origin-method input))
                                         (string-prefix? "rust-"
                                                         (origin-file-name
                                                          input)))) inputs))
              (test-equal (string-append (symbol->string (car entry))
                                         " checksum count")
                          (cdr entry)
                          (length (bun-cargo-checksum-entries inputs)))))
          cargo-input-counts)

(let* ((cargo-inputs (take (bun-cargo-inputs 'bun-lol-html-1.3.13) 2))
       (inputs (replace-bun-cargo-inputs '(("runtime" runtime-input)
                                           ("rust-obsolete" obsolete-crate))
                                         'bun-lol-html-1.3.13 cargo-inputs)))
  (test-assert "preserves unrelated native inputs"
               (assoc-ref inputs "runtime"))
  (test-assert "adds the Cargo checksum manifest"
               (assoc-ref inputs "lol-html-cargo-checksums"))
  (test-assert "removes obsolete crate inputs"
               (not (assoc-ref inputs "rust-obsolete")))
  (test-equal "adds the parsed cargo inputs" 2
              (count (lambda (input)
                       (string-prefix? "rust-"
                                       (car input))) inputs)))

(test-assert "WebKit uses Guix's standard git-fetch origin"
             (and (origin? %bun-1.0.7-webkit-source)
                  (eq? git-fetch
                       (origin-method %bun-1.0.7-webkit-source))
                  (git-reference? (origin-uri %bun-1.0.7-webkit-source))))

(let ((runner (test-runner-current)))
  (test-end "bun-bootstrap")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
