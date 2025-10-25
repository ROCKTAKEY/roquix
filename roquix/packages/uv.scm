(define-module
  (roquix packages uv)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build utils)
  #:use-module (guix utils)
  #:use-module (gnu packages rust-apps))

;; https://codeberg.org/guix/guix/pulls/3840
(define-public uv-patched
  (package
    (inherit uv)
    (arguments
     (substitute-keyword-arguments (package-arguments uv)
       ((#:phases phases)
        #~(modify-phases #$phases
            (replace 'use-guix-vendored-dependencies
              (lambda _
                (substitute* "Cargo.toml"
                  ;; The attribute "features" should not be removed.
                  ;; (substitute* "Cargo.toml"
                  ;;   (("git.*, rev.*}")
                  ;;    "version = \"*\"}"))
                  (("git[^,]*, rev[^,}]*")
                   "version = \"*\""))))))))))
