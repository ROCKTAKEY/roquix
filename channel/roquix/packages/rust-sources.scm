(define-module (roquix packages rust-sources)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust))

(define-public rust-sdks-source-modules
  '((guix build utils)
    (ice-9 ftw)))

(define rust-sdks-workspace-footer
  (string-append
   "\n[workspace]\n"
   "resolver = \"2\"\n"
   "\n[workspace.package]\n"
   "edition = \"2021\"\n"
   "repository = \"https://github.com/livekit/rust-sdks\"\n"
   "license = \"Apache-2.0\"\n"
   "\n[workspace.dependencies]\n"
   "imgproc = \"0.3.18\"\n"
   "libwebrtc = \"0.3.26\"\n"
   "livekit = \"0.7.33\"\n"
   "livekit-api = \"0.4.15\"\n"
   "livekit-ffi = \"0.12.49\"\n"
   "livekit-protocol = \"0.7.1\"\n"
   "livekit-runtime = \"0.4.0\"\n"
   "soxr-sys = \"0.1.2\"\n"
   "webrtc-sys = \"0.3.24\"\n"
   "webrtc-sys-build = \"0.3.13\"\n"
   "yuv-sys = \"0.3.13\"\n"
   "\n"
   "anyhow = \"1.0\"\n"
   "bytes = \"1.10\"\n"
   "clap = \"4.5\"\n"
   "console-subscriber = \"0.1\"\n"
   "env_logger = \"0.11\"\n"
   "futures = \"0.3\"\n"
   "futures-util = { version = \"0.3\", default-features = false }\n"
   "lazy_static = \"1.4\"\n"
   "log = \"0.4\"\n"
   "parking_lot = \"0.12\"\n"
   "prost = \"0.14\"\n"
   "prost-build = \"0.14\"\n"
   "prost-types = \"0.14\"\n"
   "rand = \"0.9\"\n"
   "serde = \"1\"\n"
   "serde_json = \"1.0\"\n"
   "thiserror = \"1\"\n"
   "tokio = { version = \"1\", default-features = false }\n"
   "\n"
   "eframe = { version = \"0.33.3\", default-features = false }\n"
   "egui = \"0.33.3\"\n"
   "egui-wgpu = \"0.33.3\"\n"
   "image = \"0.25\"\n"
   "wgpu = \"28.0\"\n"
   "winit = \"0.30.12\"\n"))

(define-public (rust-sdks-crate-snippet crate-dir)
  #~(begin
       (define crate-dir #$crate-dir)
       (define workspace-footer #$rust-sdks-workspace-footer)
       (copy-recursively crate-dir "crate-src")
       (for-each delete-file-recursively
                 (scandir "."
                          (lambda (name)
                            (not (member name
                                         '("." ".." "crate-src"))))))
       (copy-recursively "crate-src" ".")
       (delete-file-recursively "crate-src")
       (chmod "Cargo.toml" #o644)
       (let ((port (open-file "Cargo.toml" "a")))
         (display workspace-footer port)
         (close-port port))))

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
