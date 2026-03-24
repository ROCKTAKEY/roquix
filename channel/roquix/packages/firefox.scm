(define-module
  (roquix packages firefox)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages cpio)
  #:use-module (nongnu packages mozilla)
  #:use-module (gnu packages gcc))

(define-public pwas-for-firefox
  (package
    (name "pwas-for-firefox")
    (version "2.6.1")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/filips123/PWAsForFirefox/releases/download/v"
                    version "/firefoxpwa-" version "-1.x86_64.rpm"))
              (sha256
               (base32
                "00n8n8rbk13ljmdz6j0rbf4g7sjh8ykld4zva1zkrqrqy2fvxaw3"))))
    (build-system binary-build-system)
    (arguments
     '(#:patchelf-plan '(("usr/libexec/firefoxpwa-connector" ("gcc"))
                         ("usr/bin/firefoxpwa" ("gcc")))
       #:install-plan '(("usr/" "/"
                         #:exclude-regexp ("\\.build-id/")))
       #:phases (modify-phases %standard-phases
                  (replace 'unpack
                    (lambda* (#:key source #:allow-other-keys)
                      (system (format #f "rpm2cpio ~a | cpio -idv" source)) #t)))))
    (native-inputs (list rpm cpio))
    (inputs (list `(,gcc "lib")))
    (home-page "https://github.com/filips123/PWAsForFirefox")
    (synopsis
     "Tool to install, manage and use Progressive Web Apps in Mozilla Firefox")
    (description
     "A tool to install, manage and use Progressive Web Apps (PWAs) in Mozilla Firefox.")
    (license license:mpl2.0)))
