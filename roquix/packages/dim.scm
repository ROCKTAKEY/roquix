 (define-module
  (roquix packages dim)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc))

(define-public dim
  (package
   (name "dim")
   (version "1.0.1")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/c-3lab/dim/releases/download/v"
                                 version "/x86_64-unknown-linux-gnu-dim"))
            (sha256
             (base32
              "1ql4d5885fr663k3wxpqwlj4zyq8pisfbwgkjg4gb3pa5gp9xcf5"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("x86_64-unknown-linux-gnu-dim" "/bin/dim"))
                #:patchelf-plan
                `(("x86_64-unknown-linux-gnu-dim" ("gcc:lib" "glibc")))
                #:phases
                (modify-phases %standard-phases
                   (add-after 'unpack 'chmod
                     (lambda* _
                       (chmod "x86_64-unknown-linux-gnu-dim" #o755))))))
   (inputs
    `(("gcc:lib" ,gcc "lib")
      ("glibc" ,glibc)))
   (home-page "https://github.com/c-3lab/dim")
   (synopsis "Manage the open data in your project like a package manager")
   (description
    "Manage the open data in your project like a package manager.")
   (license license:expat)))
