(define-module
  (roquix packages cpp)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cmake))

(define-public argh
  (package
    (name "argh")
    (version "1.3.2")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/adishavit/argh")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "0kl6rgrzda28h1xxd611bsn8y76pfrgdv49v3h37j6mx5p2a24bi"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:phases
      ;; `build' phase just run tests and an example program.
      #~(modify-phases %standard-phases
          (delete 'build)
          (replace 'check
            (assoc-ref %standard-phases 'build)))))
    (synopsis "Minimalist argument handler for C++")
    (description
     "A minimalist argument handler for C++.")
    (home-page "https://github.com/adishavit/argh")
    (license license:bsd-3)))
