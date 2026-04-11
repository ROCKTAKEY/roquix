(define-module (roquix packages rust-sources)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust)
  #:use-module (srfi srfi-1))

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

(define-public rust-rust-sdks-0.0.0.e2d1d1d
  (let ((commit "e2d1d1d230c6fc9df171ccb181423f957bb3c1f0")
        (revision "0"))
    (hidden-package
     (package
       (name "rust-rust-sdks")
       (version (git-version "0.0.0" revision commit))
       (source
        (origin
          (method git-fetch)
          (uri (git-reference
                 (url "https://github.com/juberti-oai/rust-sdks.git")
                 (commit commit)))
          (file-name (git-file-name name version))
          (sha256
           (base32 "00xwa6w00kdv9nd4a2206wyz3aw61al914xd1g8kj4gx9bmdhic2"))))
       (build-system cargo-build-system)
       (arguments
        (list
         #:skip-build? #t
         #:cargo-package-crates
         ;; Order matters: dependencies must come before packages that need them.
         ''("webrtc-sys-build"
            "webrtc-sys"
            "livekit-runtime"
            "livekit-protocol"
            "libwebrtc")))
       (inputs
        (delete-duplicates
         (append (cargo-inputs 'libwebrtc
                               #:module '(roquix packages rust-crates))
                 (cargo-inputs 'livekit-runtime
                               #:module '(roquix packages rust-crates)))))
       (home-page "https://github.com/juberti-oai/rust-sdks")
       (synopsis "Workspace crates from the LiveKit rust-sdks repository")
       (description
        "This package provides the rust-sdks workspace crates used by Codex's
realtime WebRTC support.")
       (license license:asl2.0)))))
