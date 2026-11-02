(define-module (roquix packages procshelf)
  #:use-module (guix build-system cargo)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages)
  #:use-module (guix utils)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss))

(define %procshelf-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/ROCKTAKEY/procshelf")
          (commit "v0.1.0")))
    (file-name (git-file-name "procshelf" "0.1.0"))
    (sha256
     (base32 "0qq3mxzkh4dbpxgbk9hjaqgsnah0n161lw5ag3kfwfgb32hhialw"))))

(define* (procshelf-node-modules-fetch source hash-algo hash
                                       #:optional name
                                       #:key (system (%current-system))
                                       #:allow-other-keys)
  (gexp->derivation
   (or name "procshelf-node-modules")
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" #+(file-append node "/bin"))
         (setenv "HOME" (getcwd))
         (setenv "SSL_CERT_FILE"
                 #+(file-append nss-certs-for-test
                                "/etc/ssl/certs/ca-certificates.crt"))
         (setenv "NODE_EXTRA_CA_CERTS" (getenv "SSL_CERT_FILE"))
         (copy-recursively #+source "source")
         (with-directory-excursion "source/web"
           (invoke "npm" "ci" "--ignore-scripts" "--no-audit" "--no-fund")
           (delete-file "node_modules/.package-lock.json")
           (copy-recursively "node_modules" #$output))))
   #:system system
   #:hash-algo hash-algo
   #:hash hash
   #:recursive? #t
   #:local-build? #t
   #:leaked-env-vars '("http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY"
                       "no_proxy" "NO_PROXY")))

(define %procshelf-node-modules
  (origin
    (method procshelf-node-modules-fetch)
    (uri %procshelf-source)
    (file-name "procshelf-node-modules-0.1.0")
    (sha256
     (base32 "1b5byzmmdd5y7584py02lzcf9aa2z16162i2xk9qrfh8wlc2ypzl"))))

(define-public procshelf
  (package
    (name "procshelf")
    (version "0.1.0")
    (source %procshelf-source)
    (build-system cargo-build-system)
    (arguments
     (list
      #:install-source? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'prepare-tests
            (lambda _
              ;; Test fixtures create scripts at runtime, outside shebang patching.
              (substitute* (append (find-files "tests" "\\.rs$")
                                   (find-files "scripts" "\\.mjs$"))
                (("/bin/sh") (which "sh")))
              (substitute* "scripts/service.test.mjs"
                (("target/debug/procshelf")
                 (string-append #$output "/bin/procshelf")))))
          (add-before 'build 'build-web
            (lambda* (#:key tests? #:allow-other-keys)
              (copy-recursively #$%procshelf-node-modules "web/node_modules")
              (for-each (lambda (file)
                          (unless (string-contains file "/.bin/")
                            (patch-shebang file)))
                        (find-files "web/node_modules" ".*"))
              (setenv "HOME" (getcwd))
              (setenv "LD_LIBRARY_PATH"
                      (string-append #$gcc:lib "/lib"))
              (with-directory-excursion "web"
                (when tests?
                  (invoke "node" "node_modules/typescript/bin/tsc" "--noEmit")
                  (invoke "npm" "test"))
                (invoke "npm" "run" "build"))))
          (add-after 'install 'install-example
            (lambda _
              (install-file "config.example.toml"
                            (string-append #$output "/share/doc/procshelf"))))
          (add-after 'install-example 'check-installed
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node" "--test" "scripts/service.test.mjs")))))))
    (native-inputs (list node bash-minimal))
    (inputs (cargo-inputs 'procshelf #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/ROCKTAKEY/procshelf")
    (synopsis "Manage commands and child processes through a web interface")
    (description
     "Procshelf manages Linux commands and their child processes from a web
interface.  It provides process startup and shutdown, bounded log viewing,
access-key authentication, and automatic reloading of TOML configuration.")
    (supported-systems '("x86_64-linux"))
    (license #f)))
