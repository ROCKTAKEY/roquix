(define-module (roquix packages virtiofsd)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages pkg-config))

(define-public virtiofsd
  (package
    (name "virtiofsd")
    (version "1.13.3")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://gitlab.com/virtio-fs/virtiofsd")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "07wnrpg76ngljjqbf6jq6mdajib62v0plicmxvcqgs01pjg67h8z"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:install-source? #f))
    (inputs (cons* libcap-ng libseccomp
                   (cargo-inputs 'virtiofsd
                                 #:module '(roquix packages rust-crates))))
    (native-inputs (list pkg-config))
    (home-page "https://gitlab.com/virtio-fs/virtiofsd")
    (synopsis "Virtio-fs vhost-user device daemon")
    (description
     "Virtiofsd provides a vhost-user backend that shares a host directory
with a virtual machine using virtio-fs.")
    (license (list license:asl2.0 license:bsd-3))))
