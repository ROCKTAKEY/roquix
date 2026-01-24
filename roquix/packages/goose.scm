(define-module
  (roquix packages goose)
  #:use-module (guix packages)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages textutils)
  #:use-module (gnu packages xorg))

(define-public goose-cli
  (package
    (name "goose-cli")
    (version "1.20.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/block/goose")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1wcs7gi6z5iwjrnhx2sq2qi1vjjwdksh342hmfq59rqxrlb43496"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.88
      #:install-source? #f
      #:cargo-install-paths ''("crates/goose-cli")
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'setenv
            (lambda _
              ;; NOTE: Need for test.
              ;;   The full path should include the word "goose"
              ;;   for test logging::tests::test_log_directory_creation.
              (setenv "GOOSE_PATH_ROOT" "/tmp/goose"))))
      #:cargo-test-flags
      ''("--tests"
         "--"
         ;; NOTE: Need network
         "--skip=providers::gcpauth::tests::test_token_refresh_race_condition"
         "--skip=routes::audio::tests::test_transcribe_endpoint_requires_auth"
         "--skip=tunnel::lapstone_test::test_tunnel_end_to_end"
         "--skip=tunnel::lapstone_test::test_tunnel_post_request"
         ;; FIXME: (code: 5) database is locked
         "--skip=session::session_manager::tests::test_concurrent_session_creation"
         )))
    (inputs (cons* `(,zstd "lib")
                   sqlite
                   oniguruma
                   libxcb
                   (cargo-inputs 'goose-cli
                                 #:module '(roquix packages rust-crates))))
    (native-inputs (list pkg-config))
    (home-page "https://github.com/block/goose")
    (synopsis "AI agent CLI")
    (description "This package provides the Goose AI agent CLI.")
    (license license:asl2.0)))
