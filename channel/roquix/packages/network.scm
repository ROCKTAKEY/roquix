(define-module
  (roquix packages network)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy))

(define-public network-manager-dmenu
  (package
   (name "network-manager-dmenu")
   (version "2.3.0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/firecat53/networkmanager-dmenu")
           (commit (string-append "v" version))))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "0kg9p0sh2fzigqcsz3wnqy15hlawwn7figb0b2czshl19mi875vh"))))
   (build-system copy-build-system)
   (arguments '(#:install-plan
                (let ((docs
                       (string-append "share/doc/"
                                      (strip-store-file-name (assoc-ref %outputs "out"))
                                      "/")))
                  `(("networkmanager_dmenu" "bin/")
                    ("networkmanager_dmenu.desktop" "share/applications/")
                    ("README.md" ,docs)
                    ("config.ini.example" ,docs)))))
   (home-page "https://github.com/firecat53/networkmanager-dmenu")
   (synopsis "Manage NetworkManager connections with dmenu, Rofi, Bemenu, Wofi or fuzzel instead of nm-applet")
   (description "Manage NetworkManager connections with dmenu, Rofi, Bemenu, Wofi or fuzzel instead of nm-applet.")
   (license license:expat)))
