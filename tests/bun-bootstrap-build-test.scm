(use-modules (roquix build bun-bootstrap)
             (roquix build bun-bootstrap esbuild)
             (guix build utils)
             (srfi srfi-64))

(test-begin "bun-bootstrap-build")

(define (call-with-esbuild-fixture proc)
  (let ((directory (string-append "/tmp/bun-esbuild-test-"
                                  (number->string (getpid)))))
    (define (remove-fixture)
      (when (file-exists? directory)
        (delete-file-recursively directory)))
    (dynamic-wind
      remove-fixture
      (lambda ()
        (mkdir directory)
        (proc directory))
      remove-fixture)))

(test-equal "selects only Cargo crate origins"
            '(("rust-thiserror-1.0.69.tar.gz" . "/gnu/store/crate"))
            (bun-rust-crate-inputs '(("source" . "/gnu/store/source")
                                     ("lol-html-cargo-checksums" . "/gnu/store/checksums")
                                     ("rust-thiserror-1.0.69.tar.gz" . "/gnu/store/crate")
                                     ("tar" . "/gnu/store/tar"))))

(let ((checksums (parse-bun-cargo-checksums '(("rust-thiserror-1.0.69.tar.gz" . "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef")))))
  (test-equal "parses an authenticated crate checksum" 1
              (length checksums))
  (test-equal "retains the vendor directory name"
              "rust-thiserror-1.0.69.tar.gz"
              (bun-cargo-checksum-directory (car checksums)))
  (test-equal "renders Cargo's package checksum metadata"
   "{\"files\":{},\"package\":\"0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef\"}
"
   (bun-cargo-checksum-json (car checksums))))

(test-error "rejects a vendor directory traversal" #t
            (parse-bun-cargo-checksums '(("../rust-thiserror-1.0.69.tar.gz" . "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"))))

(test-error "rejects a malformed Cargo checksum" #t
            (parse-bun-cargo-checksums '(("rust-thiserror-1.0.69.tar.gz" . "not-a-sha256"))))

(test-error "rejects duplicate crate checksum entries" #t
            (parse-bun-cargo-checksums '(("rust-thiserror-1.0.69.tar.gz" . "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef")
                                         ("rust-thiserror-1.0.69.tar.gz" . "0123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef"))))

(call-with-esbuild-fixture
 (lambda (directory)
   (let* ((input (string-append directory "/input"))
          (work (string-append directory "/work"))
          (link "node_modules/.bin/esbuild")
          (missing-parent-link
           "packages/bun-error/node_modules/.bin/esbuild"))
     (mkdir-p (string-append input "/bin"))
     (mkdir-p (string-append work "/node_modules/.bin"))
     (call-with-output-file (string-append input "/bin/esbuild")
       (lambda (port)
         (display "source-built esbuild" port)))
     (symlink "/missing/npm-esbuild"
              (string-append work "/" link))
     (with-directory-excursion work
       (bind-bun-esbuild-tools `(("esbuild" unquote input))
                               `(((unquote link) . "esbuild")
                                 ((unquote missing-parent-link) . "esbuild")))
       (test-equal "binds npm esbuild entry points to Guix inputs"
                   (string-append input "/bin/esbuild")
                   (readlink link))
       (test-equal "creates missing npm bin directories"
                   (string-append input "/bin/esbuild")
                   (readlink missing-parent-link))))))

(test-end "bun-bootstrap-build")
