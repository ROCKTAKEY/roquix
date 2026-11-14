(define-module (roquix packages docker)
  #:use-module (gnu packages base)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages version-control)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define* (compose-vendor-fetch source hash-algo hash
                               #:optional name
                               #:key (system (%current-system))
                               #:allow-other-keys)
  (gexp->derivation
   (or name "docker-compose-vendor")
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" (string-append #+go-1.27 "/bin:"
                                      #+tar "/bin:" #+gzip "/bin"))
         (setenv "SSL_CERT_FILE"
                 #+(file-append nss-certs-for-test
                                "/etc/ssl/certs/ca-certificates.crt"))
         (setenv "HOME" (getcwd))
         (setenv "GOPATH" (string-append (getcwd) "/go"))
         (setenv "GOCACHE" (string-append (getcwd) "/cache"))
         (setenv "GOTOOLCHAIN" "local")
         (setenv "GOPROXY" "https://proxy.golang.org")
         (mkdir "source")
         (chdir "source")
         (invoke "tar" "xf" #+source "--strip-components=1")
         (invoke "go" "mod" "vendor" "-o" #$output)))
   #:system system
   #:hash-algo hash-algo
   #:hash hash
   #:recursive? #t
   #:local-build? #t
   #:leaked-env-vars '("http_proxy" "https_proxy" "HTTP_PROXY" "HTTPS_PROXY"
                       "no_proxy" "NO_PROXY")))

(define-public docker-compose
  (package
    (name "docker-compose")
    (version "5.7.0")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://codeload.github.com/docker/compose/tar.gz/"
                           "refs/tags/v" version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0qqdndw1lmrkwr9hx5932s1gjpryysh8z4cy53cs5n369bfvgxcq"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 popen)
                  (ice-9 textual-ports))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'patch-test-shells
            (lambda _
              ;; These tests execute a shell directly or generate a plugin
              ;; script at runtime, outside the shebang patching phases.
              (substitute* '("pkg/watch/watcher_naive_test.go"
                             "pkg/compose/model_test.go")
                (("/bin/sh") (which "sh")))))
          (replace 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              (copy-recursively (assoc-ref inputs "vendor") "vendor"
                                #:log (%make-void-port "w"))
              ;; Remote Compose files are cloned by an external Git process.
              (substitute* "pkg/remote/git.go"
                (("\"git\"")
                 (object->string (search-input-file inputs "/bin/git"))))
              (setenv "HOME" (getcwd))
              (setenv "GOCACHE" (string-append (getcwd) "/.go-cache"))
              (setenv "GOPATH" (string-append (getcwd) "/.go"))
              (setenv "GOTOOLCHAIN" "local")
              (setenv "GOPROXY" "off")
              (setenv "GOSUMDB" "off")
              (setenv "GOFLAGS" "-mod=vendor -trimpath")
              (setenv "GOMAXPROCS" (number->string (parallel-job-count)))))
          (replace 'build
            (lambda _
              (invoke "go" "build" "-ldflags"
                      (string-append
                       "-w -X github.com/docker/compose/v5/internal.Version=v"
                       #$version)
                      "-o" "docker-compose" "./cmd")))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                ;; Docker's end-to-end suite is gated by the e2e build tag;
                ;; ordinary unit tests can run without a Docker daemon.
                (invoke "go" "test" "./..."))))
          (replace 'install
            (lambda _
              (install-file "docker-compose" (string-append #$output "/bin"))))
          (add-after 'install 'install-plugin
            (lambda _
              (let ((plugins (string-append #$output "/lib/docker/cli-plugins")))
                (mkdir-p plugins)
                (symlink "../../../bin/docker-compose"
                         (string-append plugins "/docker-compose")))))
          (add-after 'install-plugin 'check-installed
            (lambda* (#:key tests? #:allow-other-keys)
              (define (output-of . args)
                (let* ((pipe (apply open-pipe* OPEN_READ args))
                       (result (get-string-all pipe)))
                  (unless (zero? (close-pipe pipe))
                    (error "Compose command failed" args))
                  result))
              (when tests?
                (let ((compose (string-append #$output "/bin/docker-compose"))
                      (plugin (string-append #$output
                               "/lib/docker/cli-plugins/docker-compose")))
                  (unless (string=? (output-of compose "version" "--short")
                                    (string-append #$version "\n"))
                    (error "Unexpected Compose version"))
                  (unless (string-contains (output-of plugin
                                            "docker-cli-plugin-metadata")
                                           (string-append "v"
                                                          #$version))
                    (error "Missing Docker CLI plugin metadata"))
                  (call-with-output-file "compose.yaml"
                    (lambda (port)
                      (display "services:
  web:
    image: nginx:alpine
" port)))
                  (unless (string=? (output-of compose
                                               "--project-name"
                                               "package-test"
                                               "--file"
                                               "compose.yaml"
                                               "config"
                                               "--services") "web\n")
                    (error "Compose configuration parsing failed")))))))))
    (inputs (list git-minimal))
    (native-inputs
     (list (list "go" go-1.27)
           (list "vendor"
                 (origin
                   (method compose-vendor-fetch)
                   (uri (package-source this-package))
                   (file-name (string-append name "-" version "-vendor"))
                   (sha256
                    (base32
                     "0a1yzwf3npx5vvwqpd38slharrng2hqgknb09q1ilhy3zfmgli2p"))))))
    (home-page "https://github.com/docker/compose")
    (synopsis "Define and run multi-container Docker applications")
    (description
     "Docker Compose configures application services in a Compose file and
creates and runs their containers together.  This package provides both the
standalone command and a Docker CLI plugin in @file{lib/docker/cli-plugins}.")
    (license license:asl2.0)))
