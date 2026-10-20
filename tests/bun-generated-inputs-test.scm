(use-modules (guix import bun)
             (ice-9 textual-ports)
             (srfi srfi-1)
             (srfi srfi-13)
             (srfi srfi-64))

(define repository-root
  (dirname (dirname (current-filename))))

(define generated-file
  (string-append repository-root
                 "/channel/roquix/packages/bun-lock-inputs.scm"))

(test-begin "bun-generated-inputs")

(let ((entries (extract-bun-lock-inputs generated-file)))
  (test-equal "all lock snapshots use one importer-managed table"
              30
              (length entries))
  (test-assert "Bun package lock snapshot is registered"
               (assoc '%bun-1.0.30-bun-error-npm-inputs entries))
  (test-assert "OpenCode lock snapshot is registered"
               (assoc '%opencode-1.18.3-npm-inputs entries)))

(let ((source (call-with-input-file generated-file get-string-all)))
  (test-assert "imported HTTP origins use SHA-256"
               (string-contains source "(sha256 (base32"))
  (test-assert "lockfile integrity hashes are not retained"
               (not (string-contains source "(content-hash")))
  (test-assert "all importer hash requests are resolved"
               (not (string-contains source "(bun-import-"))))

(for-each
 (lambda (relative)
   (let ((source
          (call-with-input-file (string-append repository-root "/" relative)
            get-string-all)))
     (test-assert (string-append relative
                                 " derives no hash from lock integrity")
                  (not (string-contains source "(content-hash")))))
 '("tests/bun-offline-node-modules-package.scm"
   "tests/bun-node-modules-layout-package.scm"))

(for-each
 (lambda (relative)
   (let ((source
          (call-with-input-file (string-append repository-root "/" relative)
            get-string-all)))
     (test-assert (string-append relative " does not include fragments")
                  (not (string-contains source "include-from-path")))))
 '("channel/roquix/packages/bun-npm-inputs.scm"
   "channel/roquix/packages/opencode-npm-inputs.scm"))

(let ((runner (test-runner-current)))
  (test-end "bun-generated-inputs")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
