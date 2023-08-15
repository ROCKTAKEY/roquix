(define-module
  (roquix packages skk)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages language)
  #:use-module (gnu packages fcitx5)
  #:use-module (gnu packages dictionaries)
  #:use-module (gnu packages kde-frameworks)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages qt))

(define-public fcitx5-skk
  (package
    (name "fcitx5-skk")
    (version "5.0.15")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/fcitx/fcitx5-skk")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "186hf2l2iasw2wgsn4l6mrb9vx3vaw1n0aiby465842cca4rr4fb"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:tests? #f
      #:configure-flags
      #~(list (string-append "-D" "SKK_DEFAULT_PATH=" #$(file-append (this-package-input "skk-jisyo") "/share/skk/SKK-JISYO.L")))))
    (native-inputs (list extra-cmake-modules gettext-minimal pkg-config))
    (inputs (list glib
                  libskk
                  qtbase-5
                  fcitx5
                  fcitx5-qt
                  skk-jisyo))
    (home-page "https://github.com/fcitx/fcitx5-skk")
    (synopsis
     "Input method engine for Fcitx5, which uses libskk as its backend")
    (description
     "Input method engine for Fcitx5, which uses libskk as its backend.")
    (license license:gpl3+)))
