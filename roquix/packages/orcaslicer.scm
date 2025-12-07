(define-module
  (roquix packages orcaslicer)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cmake)
  #:use-module (guix gexp)
  #:use-module (gnu packages algebra)
  #:use-module (gnu packages boost)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages curl)
  #:use-module (gnu packages engineering)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages gl)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages graphics)
  #:use-module (gnu packages gstreamer)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages image)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages serialization)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages webkit)
  #:use-module (gnu packages wxwidgets)
  #:use-module (gnu packages xml))


(define-public orcaslicer
  (package
   (name "orcaslicer")
   (version "2.3.1")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/OrcaSlicer/OrcaSlicer")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
       (sha256
        (base32
         "08hh58iqz6zh7jjd48yy6wc94pcq0x3jyv4dl1yawbi7zb3h3ls5"))))
   (build-system cmake-build-system)
   (arguments
    (list))
   (native-inputs
    (list pkg-config))
   (inputs
    (list ))
   (home-page "https://github.com/OrcaSlicer/OrcaSlicer")
   (synopsis "G-code generator for 3D printers")
   (description "G-code generator for 3D printers")
   (license license:agpl3)))
