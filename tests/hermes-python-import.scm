(use-modules (roquix packages hermes python-import)
             (guix tests)
             (srfi srfi-64))

(test-begin "hermes-python-import")
(define pin
  (parse-python-pin '(("name" . "example") ("version" . "1.0")
                      ("sha256" . "0000000000000000000000000000000000000000000000000000000000000000"))))
(define source
  '(origin
     (method url-fetch)
     (uri (pypi-uri "example" version))
     (sha256 (base32 "0000000000000000000000000000000000000000000000000000"))))
(define (definition version source)
  `(package
     (name "python-example")
     (version ,version)
     (source
      ,source)
     (build-system pyproject-build-system)))
(test-equal "matching sdist is accepted"
            (definition "1.0" source)
            (reconcile-python-pin pin
                                  (definition "1.0" source)))
(test-equal "imported drafts hide Hermes dependencies"
  `(hidden-package ,(definition "1.0" source))
  (mock ((guix import pypi) pypi->guix-package
         (lambda* (name #:key version)
           (definition version source)))
    (import-python-pin pin)))
(test-error "a changed sdist hash is rejected" #t
            (reconcile-python-pin pin
                                  (definition "1.0"
                                              '(origin
                                                 (method url-fetch)
                                                 (uri
                                                  "https://example.org/example.tar.gz")
                                                 (sha256 (base32
                                                          "1000000000000000000000000000000000000000000000000000"))))))
(test-error "a different version is rejected" #t
            (reconcile-python-pin pin
                                  (definition "2.0" source)))
(define git-source
  '(origin
     (method git-fetch)
     (uri (git-reference
           (url "https://example.org/example.git")
           (commit (string-append "v" version))))
     (sha256 (base32 "1000000000000000000000000000000000000000000000000000"))))
(test-equal "Git content has its own hash, independent of the sdist"
            (definition "1.0" git-source)
            (reconcile-python-pin pin
                                  (definition "1.0" git-source)))
(test-error "missing source hash is rejected" #t
            (reconcile-python-pin pin
                                  (definition "1.0"
                                              '(origin
                                                 (method git-fetch)))))
(define failures
  (test-runner-fail-count (test-runner-current)))
(test-end "hermes-python-import")
(exit (zero? failures))
