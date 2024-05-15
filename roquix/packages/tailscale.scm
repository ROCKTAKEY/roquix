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
   (version "1.66.1")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://pkgs.tailscale.com/stable/tailscale_"
                                version "_amd64.tgz"))
            (sha256
             (base32
              "16rjmgq1gsa25pbkdwv3fdz8hd7xp14rpd8ilwc7ndswnpyg6grd"))))
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
