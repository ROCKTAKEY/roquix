(define-module
  (roquix packages marp)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages base)
  #:use-module (gnu packages gcc))

(define-public marp-cli
  (package
   (name "marp-cli")
   (version "2.2.2")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/marp-team/marp-cli/releases/download/"
                                version "/marp-cli-v" version "-linux.tar.gz"))
            (sha256
             (base32
              "1324afphj234yky9ckwrhhg7qhvaj08i5gl76qk787mdpmi9zrsa"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("marp" "bin/"))
                #:patchelf-plan
                '(("marp" ("gcc" "glibc")))
                #:strip-binaries? #f))
   (inputs
    `((,gcc "lib")
      ,glibc))
   (home-page "https://marp.app")
   (synopsis "Markdown Presentation Ecosystem")
   (description "Marp (also known as the Markdown Presentation Ecosystem) provides an intuitive experience for creating beautiful slide decks.
You only have to focus on writing your story in a Markdown document.")
   (license license:expat)))
