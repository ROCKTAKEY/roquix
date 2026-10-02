(use-modules (gnu packages base)
             (guix packages)
             (roquix build-system container-launcher))

(package
  (inherit hello)
  (name "hello-container")
  (source #f)
  (build-system container-launcher-build-system)
  (arguments
   (list #:payload hello
         #:executable "hello")))
