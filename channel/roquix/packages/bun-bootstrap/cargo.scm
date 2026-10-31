(define-module (roquix packages bun-bootstrap cargo)
  #:use-module ((guix build cargo-build-system)
                #:prefix cargo:)
  #:use-module (guix build utils)
  #:use-module (ice-9 format)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (bun-rust-crate-inputs parse-bun-cargo-checksums
                                  bun-cargo-checksum-directory
                                  bun-cargo-checksum-json
                                  install-bun-cargo-vendor))

(define-record-type <bun-cargo-checksum>
  (make-bun-cargo-checksum directory digest) bun-cargo-checksum?
  (directory bun-cargo-checksum-directory)
  (digest bun-cargo-checksum-digest))

(define (bun-rust-crate-inputs inputs)
  "Return only the rust-* crate origins from Guix build INPUTS."
  ;; Guix's unpack-rust-crates probes every regular input as a tar archive.
  ;; Bun also supplies regular non-crate files, so pass only the inputs which
  ;; `guix import crate' labels as Rust crates.
  ;; https://codeberg.org/guix/guix/src/branch/master/guix/build/cargo-build-system.scm
  (filter (lambda (input)
            (and (pair? input)
                 (string? (car input))
                 (string-prefix? "rust-"
                                 (car input)))) inputs))

(define (parse-bun-cargo-checksums datum)
  "Parse DATUM into validated Cargo checksum records."
  (unless (list? datum)
    (error "Cargo checksum manifest must be a list" datum))
  (let ((checksums (map (lambda (entry)
                          (unless (and (pair? entry)
                                       (string? (car entry))
                                       (string? (cdr entry)))
                            (error "invalid Cargo checksum entry" entry))
                          (let ((directory (car entry))
                                (digest (cdr entry)))
                            (unless (and (string=? directory
                                                   (basename directory))
                                         (string-prefix? "rust-" directory)
                                         (string-suffix? ".tar.gz" directory))
                              (error "invalid Cargo vendor directory"
                                     directory))
                            (unless (string-match "^[0-9a-f]{64}$" digest)
                              (error "invalid Cargo package checksum" digest))
                            (make-bun-cargo-checksum directory digest))) datum)))
    (unless (= (length checksums)
               (length (delete-duplicates (map bun-cargo-checksum-directory
                                               checksums) string=?)))
      (error "duplicate Cargo checksum entry" datum)) checksums))

(define (bun-cargo-checksum-json checksum)
  "Render CHECKSUM in Cargo's vendored-source metadata format."
  (format #f "{\"files\":{},\"package\":\"~a\"}~%"
          (bun-cargo-checksum-digest checksum)))

(define (read-bun-cargo-checksums file)
  (call-with-input-file file
    (lambda (port)
      (let ((datum (read port)))
        (unless (eof-object? (read port))
          (error "trailing data in Cargo checksum manifest" file))
        (parse-bun-cargo-checksums datum)))))

(define (write-bun-cargo-checksums file vendor-dir)
  (for-each (lambda (checksum)
              (let ((crate-directory (string-append vendor-dir "/"
                                                    (bun-cargo-checksum-directory
                                                     checksum))))
                (unless (file-is-directory? crate-directory)
                  (error "Cargo input was not unpacked" crate-directory))
                (call-with-output-file (string-append crate-directory
                                                      "/.cargo-checksum.json")
                  (lambda (port)
                    (display (bun-cargo-checksum-json checksum) port)))))
            (read-bun-cargo-checksums file)))

(define* (install-bun-cargo-vendor #:key source inputs checksums vendor-dir)
  "Install Bun's Guix-generated crate INPUTS into VENDOR-DIR."
  ((assoc-ref cargo:%standard-phases
              'unpack-rust-crates)
   #:source source
   #:inputs (bun-rust-crate-inputs inputs)
   #:vendor-dir vendor-dir)
  ;; Preserve each imported origin's authenticated crate checksum.  This also
  ;; permits a compatible upstream Cargo.lock to be consumed with --frozen.
  (write-bun-cargo-checksums checksums vendor-dir)
  #t)
