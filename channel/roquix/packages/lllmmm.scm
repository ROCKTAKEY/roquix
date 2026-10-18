(define-module (roquix packages lllmmm)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages python))

(define-public lllmmm
  (package
    (name "lllmmm")
    (version "0.1.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ROCKTAKEY/lllmmm")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "024ri2v1g4yj0vc8npy9wwdxaxpzwv3apzx45lwga42sb2vg63j4"))))
    (build-system cargo-build-system)
    (arguments
     (list #:install-source? #f
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'install 'install-examples
                 (lambda _
                   (copy-recursively
                    "examples"
                    (string-append #$output "/share/doc/lllmmm/examples")))))))
    (native-inputs (list python))
    (inputs (cargo-inputs 'lllmmm #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/ROCKTAKEY/lllmmm")
    (synopsis "Manage local models through an OpenAI-compatible endpoint")
    (description
     "Lllmmm provides a single OpenAI-compatible endpoint for local llama.cpp
and Strata inference servers.  It loads models on demand, switches between
models, and unloads idle backends.  Backend executables and model files are
selected through a TOML configuration file.")
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (license license:agpl3)))
