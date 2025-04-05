(define-module
  (roquix packages tailscale)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (gnu packages linux)
  #:use-module (nonguix build-system binary))

(define-public tailscale
  (package
   (name "tailscale")
   (version "1.82.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://pkgs.tailscale.com/stable/tailscale_"
                                version "_amd64.tgz"))
            (sha256
             (base32
              "0ayc224qr2v04qvppbjlhfvnv360qm4129nwzspcd2929xaqkbf4"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("tailscale" "bin/")
                  ("tailscaled" "bin/"))))
   (home-page "https://tailscale.com/")
   (synopsis "Tailscale")
   (propagated-inputs
    (list iptables))
   (description
    "A secure network that just works
Zero config VPN. Installs on any device in minutes, manages firewall rules for you, and works from anywhere.")
   (license license:bsd-3)))
