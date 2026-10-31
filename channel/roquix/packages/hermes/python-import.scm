(define-module (roquix packages hermes python-import)
  #:use-module (guix base32)
  #:use-module (guix base16)
  #:use-module (guix import pypi)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-9)
  #:export (parse-python-pin python-pin-name python-pin-version
                             reconcile-python-pin import-python-pin))

(define-record-type <python-pin>
  (%make-python-pin name version hash) python-pin?
  (name python-pin-name)
  (version python-pin-version)
  (hash python-pin-hash))

(define (parse-python-pin entry)
  (let ((name (assoc-ref entry "name"))
        (version (assoc-ref entry "version"))
        (hash (assoc-ref entry "sha256")))
    (unless (and (string? name)
                 (not (string-null? name))
                 (string? version)
                 (not (string-null? version))
                 (string? hash)
                 (string-match "^[0-9a-f]{64}$" hash))
      (error "invalid locked Python source" entry))
    (%make-python-pin name version
                      (base16-string->bytevector hash))))

(define (reconcile-python-pin pin definition)
  (match definition
    (('package fields ...)
     (unless (equal? (assoc-ref fields
                                'version)
                     (list (python-pin-version pin)))
       (error "imported Python version differs from lock"
              (python-pin-name pin)))
     (match (assoc-ref fields
                       'source)
       ((('origin source-fields ...))
        (match (assoc-ref source-fields
                          'sha256)
          ((('base32 hash))
           (let ((actual (nix-base32-string->bytevector hash)))
             (match (assoc-ref source-fields
                               'method)
               (('url-fetch)
                (unless (equal? actual
                                (python-pin-hash pin))
                  (error "source differs from upstream lock"
                         (python-pin-name pin))))
               ;; Git snapshots and sdists have different content.  Guix's
               ;; content hash pins the imported Git snapshot independently.
               (('git-fetch)
                (unless (assoc-ref source-fields
                                   'uri)
                  (error "missing Git reference"
                         (python-pin-name pin))))
               (_ (error "unsupported Python source method" source-fields)))))
          (_ (error "missing source hash"
                    (python-pin-name pin)))))
       (_ (error "missing Python source"
                 (python-pin-name pin)))) definition)
    (_ (error "PyPI import did not return a package"
              (python-pin-name pin)))))

(define (import-python-pin pin)
  (reconcile-python-pin pin
                        (pypi->guix-package (python-pin-name pin)
                                            #:version (python-pin-version pin))))
