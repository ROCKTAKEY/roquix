(define-module
  (roquix packages briss)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages java))

(define-public briss
  (let ((revision "3"))
   (package
   (name "briss")
   (version "2.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/mbaeuerle/Briss-2.0/releases/download/v"
                                version "-alpha-" revision "/Briss-2.0.zip"))
            (sha256
             (base32
              "0p0afm0nkxfgqawlj36mpqwlczi6q8h2aih3d7g3dji1rh4qxchx"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("bin/" "bin/")
                  ("lib/" "lib/"))))
   (native-inputs
    (list unzip))
   (propagated-inputs
    (list openjdk))
   (home-page "https://github.com/mbaeuerle/Briss-2.0")
   (synopsis "Briss 2.0 is intended to be a GUI Update for the Briss PDF cropping tool.")
   (description
    "Briss 2.0 is intended to be a GUI Update for the Briss PDF cropping tool.")
   (license license:gpl3))))
