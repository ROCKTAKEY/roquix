(use-modules (roquix build-system bun)
             (guix download)
             (guix gexp)
             ((guix licenses) #:prefix license:)
             (guix packages))

(define source
  (local-file (string-append (dirname (current-filename))
                             "/fixtures/bun-offline-node-modules")
              "bun-offline-node-modules-source"
              #:recursive? #t))

(define node-modules
  (bun-node-modules
   source
   (list
    (bun-lock-package
      (name "is-number")
      (version "7.0.0")
      (cache-directory "is-number@7.0.0@@@1")
      (source
       (origin
         (method url-fetch)
         (uri "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz")
         (file-name "npm-is-number-7.0.0.tgz")
         (sha256
          (base32
           "07nmmpplsj1gxzng6fxhnnyfkif9fvhvxa89d5lrgkwqf42w2xbv"))))))))

(package
  (name "bun-offline-node-modules-test")
  (version "1")
  (source source)
  (build-system bun-build-system)
  (arguments
   (list #:tests? #f
         #:node-modules node-modules
         #:install-plan #~'(("dist/" "share/bun-offline-node-modules/"))))
  (supported-systems '("x86_64-linux"))
  (home-page "https://example.invalid/")
  (synopsis "Exercise offline Bun node module assembly")
  (description "Test the Bun build system's origin-only node module input.")
  (license license:public-domain))
