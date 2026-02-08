(define-module (roquix packages rust-sources)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust))

(define-public rust-tungstenite-0.28.0.f514de8
  (let ((commit "f514de8644821113e5d18a027d6d28a5c8cc0a6e")
        (revision "0"))
    (hidden-package
     (package
       (name "rust-tungstenite")
       (version (git-version "0.28.0" revision commit))
       (source
        (origin
          (method git-fetch)
          (uri (git-reference
                (url "https://github.com/JakkuSakura/tungstenite-rs")
                (commit commit)))
          (file-name (git-file-name name version))
          (sha256
           (base32 "0h7vkblgpavap5wzwj18sbvvi122cf5miywa28hma6ikkykxj98b"))))
       (build-system cargo-build-system)
       (arguments
        (list #:skip-build? #t
              #:cargo-package-crates
              ''("tungstenite")))
       ;; (inputs (cargo-inputs 'rust-tungstenite-0.28.0.f514de8
       ;;                       #:module '(roquix packages rust-crates)))
       (home-page "https://github.com/JakkuSakura/tungstenite-rs")
       (synopsis "WebSocket library for Rust")
       (description "This package provides a WebSocket library for Rust.")
       (license (list license:expat license:asl2.0))))))

(define-public rust-runfiles-0.1.0.b56cbaa
  (let ((commit "b56cbaa8465e74127f1ea216f813cd377295ad81")
        (revision "0"))
    (hidden-package
     (package
       (name "rust-runfiles")
       (version (git-version "0.1.0" revision commit))
       (source
        (origin
          (method git-fetch)
          (uri (git-reference
                (url "https://github.com/dzbarsky/rules_rust")
                (commit commit)))
          (file-name (git-file-name name version))
          (sha256
           (base32 "1sdmgr8gramp4z1kfsmbx083gpinzk8bz3vi0fchbwr1qhnmb6mq"))
          (modules '((guix build utils)))
          (snippet #~(begin
                       (mkdir-p "src")
                       (copy-file "rust/runfiles/runfiles.rs" "src/lib.rs")
                       (delete-file-recursively "rust")
                       (call-with-output-file "Cargo.toml"
                         (lambda (port)
                           (display
                            (string-append
                             "[package]\n"
                             "name = \"runfiles\"\n"
                             "version = \"0.1.0\"\n"
                             "authors = [\"Matt Sztolik <[email protected]>\"]\n"
                             "description = \"Runfiles lookup library for Bazel-built Rust binaries and tests.\"\n"
                             "repository = \"https://https://github.com/matts1/rust_runfiles\"\n"
                             "license = \"Apache-2.0\"\n"
                             "readme = \"README.md\"\n"
                             "edition = \"2021\"\n")
                            port)))))))
       (build-system cargo-build-system)
       (arguments
        (list #:skip-build? #t
              #:cargo-package-crates
              ''("runfiles")))
       (home-page "https://github.com/matts1/rust_runfiles")
       (synopsis "Runfiles lookup library for Bazel-built Rust binaries and tests.")
       (description "Runfiles lookup library for Bazel-built Rust binaries and tests.")
       (license license:asl2.0)))))
