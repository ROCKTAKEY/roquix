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
    (version "0.2.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ROCKTAKEY/lllmmm")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1l95bvwx5r8vckacrfxgl907mbj8wjs4d524zfwqra5mgj00qzrf"))))
    (build-system cargo-build-system)
    (arguments
     (list #:install-source? #f
           #:phases
           #~(modify-phases %standard-phases
               (add-after 'install 'install-examples
                 (lambda _
                   (copy-recursively
                    "examples"
                    (string-append #$output "/share/doc/lllmmm/examples"))))
               (add-after 'install-examples 'check-installed
                 (lambda* (#:key tests? #:allow-other-keys)
                   (when tests?
                     (invoke "sh"
                             #$(local-file
                                (canonicalize-path
                                 (search-path
                                  %load-path
                                  (string-append
                                   "roquix/packages/lllmmm/"
                                   "package-tests/check-installed.sh"))))
                             #$output #$version)))))))
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
