(define-module
  (roquix packages cryptomator)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system maven)
  #:use-module (gnu packages java))

(define-public cryptomator
  (package
   (name "cryptomator")
   (version "1.6.10")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/cryptomator/cryptomator")
           (commit version)))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "0jyvpsxgbibm6jgaqjbq0dr04xkc1s8lnyymm034h2qp50q68lwj"))))
   (build-system maven-build-system)
   (inputs (list java-commons-lang3 ))
   (home-page "https://cryptomator.org/")
   (synopsis "Cryptomator")
   (description
    "Multi-platform transparent client-side encryption of your files in the cloud.")
   (license license:asl2.0)))
