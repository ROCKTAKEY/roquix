(define-module (roquix packages pi)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages node)
  #:use-module (gnu packages node-xyz)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages xorg)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define pi-version "1.6.0")

(define pi-workspaces
  '("telemetry" "schema" "tui" "codemode" "mcp" "ai" "agent" "coding-agent"))

(define pi-source
  (origin
    (method url-fetch)
    (uri (string-append "https://github.com/earendil-works/pi/releases/download/v"
                        pi-version "/pi-" pi-version "-source.tar.gz"))
    (sha256 (base32 "0gj1vkg4kk57h3yhbwi3zza353l1wsnvc2r2kdi17rw4iql9wl8l"))))

(define* (fetch-runtime-modules source algorithm hash #:optional name
                                #:key system #:allow-other-keys)
  (gexp->derivation
   name
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils) (ice-9 ftw))
         (setenv "PATH" (string-append #+node-lts "/bin:" #+tar "/bin:" #+gzip "/bin"))
         (setenv "HOME" (getcwd))
         (setenv "SSL_CERT_FILE"
                 #+(file-append nss-certs "/etc/ssl/certs/ca-certificates.crt"))
         (invoke "tar" "xf" #+source "--strip-components=1")
         (invoke "npm" "ci" "--workspace" "packages/coding-agent" "--omit=dev"
                 "--ignore-scripts" "--no-audit" "--no-fund")
         ;; npm links @earendil-works packages to ../../packages/<workspace>.
         ;; Node also resolves some locked versions from a workspace's own
         ;; node_modules.  The archive and install tree must agree on both paths.
         (apply invoke "tar" "--sort=name" "--mtime=@0" "--owner=0" "--group=0"
                "--mode=u+rwX,go+rX,go-w" "--exclude=.package-lock.json"
                "-cf" #$output "node_modules"
                (filter file-exists?
                        (map (lambda (p) (string-append "packages/" p "/node_modules"))
                             (scandir "packages" (lambda (p) (not (member p '("." ".."))))))))))
   #:system system #:hash-algo algorithm #:hash hash))

(define pi-runtime-modules
  (origin
    (method fetch-runtime-modules)
    (uri pi-source)
    (file-name (string-append "pi-runtime-modules-" pi-version ".tar"))
    (sha256 (base32 "004grzzvpqj7i1dphxkrky99n9qjx2l42vgw03vlinabm7mz9r81"))))

(define-public pi-coding-agent
  (package
    (name "pi-coding-agent")
    (version pi-version)
    (source pi-source)
    (supported-systems '("x86_64-linux"))
    (build-system gnu-build-system)
    (native-inputs (list node-typescript))
    (inputs (list node-lts libxcb))
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (invoke "tar" "xf" #$pi-runtime-modules)
              ;; Upstream's CLI and RPC entries point to its esbuild bundle.
              ;; In this installation Node loads the modules emitted by tsc.
              ;; https://github.com/earendil-works/pi/blob/v1.6.0/packages/coding-agent/package.json
              (substitute* "packages/coding-agent/package.json"
                (("dist/bundle/") "dist/"))))
          (replace 'build
            (lambda _
              (for-each
               (lambda (workspace)
                 (with-directory-excursion (string-append "packages/" workspace)
                   ;; The runtime dependency archive omits development-only
                   ;; type declarations, so tsc runs in emit-only mode.
                   (invoke "tsc" "-p" "tsconfig.build.json" "--noCheck")))
               '#$pi-workspaces)
              (copy-recursively "packages/ai/src/providers/data" "packages/ai/dist/providers/data")
              (with-directory-excursion "packages/coding-agent"
                (invoke "npm" "run" "copy-assets"))
              (delete-file-recursively "packages/tui/native/linux/prebuilds")
              (setenv "CC" "gcc")
              (invoke "bash" "packages/tui/native/linux/build.sh")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "node" "packages/ai/scripts/check-model-data.ts"))))
          (replace 'install
            (lambda _
              (let ((lib (string-append #$output "/lib/pi"))
                    (bin (string-append #$output "/bin")))
                (mkdir-p lib)
                (mkdir-p bin)
                (copy-recursively "node_modules" (string-append lib "/node_modules"))
                (for-each
                 (lambda (workspace)
                   (with-directory-excursion (string-append "packages/" workspace)
                     (let ((dest (string-append lib "/packages/" workspace)))
                       (mkdir-p dest)
                       (for-each (lambda (path)
                                   (when (file-exists? path)
                                     (copy-recursively path (string-append dest "/" path))))
                                 '("dist" "package.json" "node_modules" "README.md"
                                   "CHANGELOG.md" "docs" "examples" "schemas")))))
                 '#$pi-workspaces)
                (copy-recursively "packages/tui/native/linux/prebuilds"
                                  (string-append lib "/packages/tui/native/linux/prebuilds"))
                (let ((cli (string-append lib "/packages/coding-agent/dist/cli.js")))
                  (substitute* cli (("#!/usr/bin/env node") (string-append "#!" #$node-lts "/bin/node")))
                  (chmod cli #o755)
                  (symlink cli (string-append bin "/pi"))))))
          (add-after 'install 'check-installed
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                ;; Even --help consults project trust and takes a lock under ~/.pi.
                (setenv "HOME" (getenv "TMPDIR"))
                (invoke (string-append #$output "/bin/pi") "--version")
                (invoke (string-append #$output "/bin/pi") "--help")))))))
    (home-page "https://github.com/earendil-works/pi")
    (synopsis "Terminal coding agent")
    (description "Pi provides an interactive coding assistant with file editing,
shell tools, extensions, and persistent sessions.")
    (license license:expat)))
