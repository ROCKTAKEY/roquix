(use-modules (roquix build-system bun)
             (guix build-system copy)
             (guix download)
             ((guix licenses) #:prefix license:)
             (guix packages))

(define is-number
  (bun-lock-package
    (name "is-number")
    (version "7.0.0")
    (cache-directory "is-number@7.0.0@@@1")
    (install-paths '("node_modules/is-number"))
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/is-number/-/is-number-7.0.0.tgz")
       (file-name "npm-is-number-7.0.0.tgz")
       (sha256
        (base32
         "07nmmpplsj1gxzng6fxhnnyfkif9fvhvxa89d5lrgkwqf42w2xbv"))))))

(package
  (name "bun-node-modules-layout-test")
  (version "1")
  (source
   (bun-node-modules-from-layout (list is-number)
                                 #:native-files 'reject))
  (build-system copy-build-system)
  (arguments
   '(#:install-plan '(("node_modules" "share/bun-layout/"))))
  (supported-systems '("x86_64-linux"))
  (home-page "https://example.invalid/")
  (synopsis "Exercise lock-derived node_modules layout")
  (description "Test package for lock-derived node module materialization.")
  (license license:public-domain))
