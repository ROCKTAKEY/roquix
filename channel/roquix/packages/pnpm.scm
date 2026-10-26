(define-module (roquix packages pnpm)
  #:use-module (guix build-system cargo)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages check)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages web)
  #:use-module (gnu packages version-control))

(define (npm-source name version hash)
  (origin
    (method url-fetch)
    (uri (string-append "https://registry.npmjs.org/" name "/-/"
                        name "-" version ".tgz"))
    (file-name (string-append name "-" version ".tgz"))
    (sha256 (base32 hash))))

(define-public pnpm
  (package
    (name "pnpm")
    (version "12.14.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://codeload.github.com/pnpm/pnpm/tar.gz/refs/tags/v"
                           version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256 (base32 "11kz3f1nfjcdzx00axl8wi2dbahnp8p61ip9l9i5jhsmgyr62g29"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.96
      #:install-source? #f
      #:cargo-install-paths ''("pnpm/crates/cli")
      #:cargo-build-flags ''("--release" "--package" "pnpm-cli")
      #:phases
      #~(modify-phases %standard-phases
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              ;; Handshake caches are process-global; upstream uses nextest to
              ;; isolate each test from servers reused by other tests.
              ;; https://github.com/pnpm/pnpm/blob/v12.14.0/.github/workflows/pacquet-ci.yml
              (when tests?
                (invoke "cargo" "nextest" "run" "--offline" "--release"
                        "--package" "pnpm-cli" "--lib" "--no-fail-fast"
                        "--build-jobs" (number->string (parallel-job-count))
                        "--test-threads" (number->string (parallel-job-count))))))
          (add-after 'unpack 'use-guix-shell
            (lambda _
              ;; Generated scripts and test fixtures must run in a non-FHS store.
              (substitute* (find-files "pnpm/crates" "\\.rs$")
                (("/bin/sh") (which "sh")))))
          (add-before 'check 'configure-test-certificates
            (lambda _
              ;; Reqwest initializes TLS even for the local HTTP mock servers.
              (setenv "SSL_CERT_DIR" #$(file-append nss-certs "/etc/ssl/certs"))
              ;; The fallback-readlink test needs helpers from Guix's PATH.
              (substitute* "pnpm/crates/cli/src/cli_args/setup/tests.rs"
                (("\"/usr/bin:/bin\"")
                 "std::env::var_os(\"PATH\").unwrap()"))))
          (add-after 'unpack 'configure-optimization
            (lambda _
              ;; Parallelize optimization across this large CLI workspace.
              (setenv "CARGO_PROFILE_RELEASE_LTO" "thin")
              (setenv "CARGO_PROFILE_RELEASE_CODEGEN_UNITS" "16")))
          (add-after 'unpack 'use-vendored-semver
            (lambda _
              ;; Keep the fork pinned by Cargo.lock in Guix's offline vendor set.
              (substitute* "Cargo.toml"
                (("node-semver = \\{ git = [^\n]+\n") ""))))
          (add-before 'build 'bundle-store-loader
            (lambda _
              ;; Rust embeds this loader; generate it with the options from
              ;; pnpm/esm-loader/scripts/bundle-runtime.mjs.
              (for-each
               (lambda (input)
                 (let ((directory (string-append "node_modules/" (car input))))
                   (mkdir-p directory)
                   (invoke "tar" "xf" (cadr input)
                           "-C" directory "--strip-components=1")))
               (list
                (list "enhanced-resolve"
                      #$(npm-source "enhanced-resolve" "5.26.0"
                                    "1sw7qvsvjk9a1x2v9h0n7zqbccww6jmk9rhq44acqy8mzbb5b8w1"))
                (list "graceful-fs"
                      #$(npm-source "graceful-fs" "4.2.11"
                                    "1709vla02prpbf34xqsvkqngvsmp5ypnljvg1pcgxrk1l553fq9r"))
                (list "tapable"
                      #$(npm-source "tapable" "2.3.3"
                                    "1kcj2yyxxqfy5784s8vq5s3d6313s8sqaqnfi36hx0lrha6w8mss"))))
              (invoke "patch" "-p1" "-d" "node_modules/graceful-fs"
                      "-i" (string-append (getcwd)
                                          "/__patches__/graceful-fs@4.2.11.patch"))
              (invoke "esbuild" "pnpm/esm-loader/install-register.mjs"
                      "--bundle" "--minify" "--platform=node" "--format=esm"
                      "--outfile=pnpm/crates/deps-restorer/src/cas-loader.mjs.inc"
                      "--banner:js=import { createRequire as bootstrapRequire } from 'node:module'; const require = bootstrapRequire(import.meta.url);")))
          (add-after 'unpack-rust-crates 'adjust-iterator-msrv
            (lambda _
              ;; This iterator inherits its upstream workspace MSRV but uses
              ;; APIs available in Guix's Rust 1.96.
              ;; https://docs.rs/crate/tree-sitter-iter/1.29.0/source/src/lib.rs
              (substitute* "guix-vendor/rust-tree-sitter-iter-1.29.0.tar.gz/Cargo.toml"
                (("rust-version = \"1.97.0\"")
                 "rust-version = \"1.96.0\"")))))))
    (native-inputs (list cargo-nextest pkg-config node esbuild git-minimal))
    (inputs (append (list openssl sqlite-next)
                    (cargo-inputs 'pnpm #:module '(roquix packages rust-crates))))
    (home-page "https://pnpm.io")
    (synopsis "Fast, disk space efficient package manager")
    (description
     "pnpm manages JavaScript dependencies using a content-addressable store
and a lockfile.  It supports workspaces and shares package files between
projects.")
    (license license:expat)))
