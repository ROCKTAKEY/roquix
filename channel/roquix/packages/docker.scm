(define-module (roquix packages docker)
  #:use-module (gnu packages base)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages version-control)
  #:use-module (guix build-system go)
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
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.27
      #:import-path "github.com/docker/compose/v5/cmd"
      #:unpack-path "github.com/docker/compose/v5"
      #:install-source? #f
      #:build-flags
      #~(list "-mod=vendor"
              (string-append
               "-ldflags=-s -w -X github.com/docker/compose/v5/internal.Version=v"
               #$version))
      ;; Test the whole module, rather than only the cmd import path.
      #:test-subdirs #~'()
      #:test-flags #~(list "-mod=vendor" "-trimpath" "./...")
      #:modules '((guix build go-build-system)
                  (guix build utils)
                  (ice-9 popen)
                  (ice-9 textual-ports))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'patch-source-shebangs 'prepare-module
            (lambda* (#:key inputs unpack-path #:allow-other-keys)
              (setenv "GO111MODULE" "on")
              (setenv "GOTOOLCHAIN" "local")
              (setenv "GOPROXY" "off")
              (setenv "GOSUMDB" "off")
              (with-directory-excursion (string-append "src/" unpack-path)
                (copy-recursively (assoc-ref inputs "vendor") "vendor"
                                  #:log (%make-void-port "w"))
                ;; These tests execute or generate shell scripts at runtime.
                (substitute* '("pkg/watch/watcher_naive_test.go"
                               "pkg/compose/model_test.go")
                  (("/bin/sh") (which "sh")))
                ;; Remote Compose files are cloned by an external Git process.
                (substitute* "pkg/remote/git.go"
                  (("\"git\"")
                   (object->string (search-input-file inputs "/bin/git")))))))
          ;; Module mode needs go.mod in the working directory.  The standard
          ;; license phase expects to start from the GOPATH root.
          (add-before 'build 'enter-module
            (lambda* (#:key unpack-path #:allow-other-keys)
              (chdir (string-append "src/" unpack-path))))
          (add-after 'check 'leave-module
            (lambda _
              (chdir (getenv "GOPATH"))))
          (add-after 'build 'rename-command
            (lambda _
              (rename-file (string-append #$output "/bin/cmd")
                           (string-append #$output "/bin/docker-compose"))))
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
     (list (list "vendor"
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

(define-public docker-buildx
  (package
    (name "docker-buildx")
    (version "0.38.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/docker/buildx/archive/refs/tags/v"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1h19askhqy87yq6ibd4hfr22fkidhk20a23fxc4b0f34xhycl80x"))))
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.26
      #:import-path "github.com/docker/buildx/cmd/buildx"
      #:unpack-path "github.com/docker/buildx"
      #:install-source? #f
      #:build-flags
      #~(list "-mod=vendor"
              #$(string-append "-ldflags=-s -w -X "
                               "github.com/docker/buildx/version.Version=v"
                               version))
      ;; Test the whole module, rather than only the command import path.
      #:test-subdirs #~'()
      #:test-flags
      #~(list "-mod=vendor" "-trimpath"
              ;; These two cases fetch remote Git branches from GitHub.
              #$(string-append "-skip=^TestGitRemoteURL$/"
                               "(single_tracking_branch|"
                               "fork_tracking_branch)$")
              "./...")
      #:modules '((guix build go-build-system)
                  (guix build utils)
                  (ice-9 popen)
                  (ice-9 textual-ports))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'patch-source-shebangs 'prepare-module
            (lambda _
              ;; Use the upstream vendor tree without downloading modules or
              ;; allowing Go to replace the packaged toolchain.
              (setenv "GO111MODULE" "on")
              (setenv "GOPROXY" "off")
              (setenv "GOTOOLCHAIN" "local")
              (setenv "GOSUMDB" "off")
              ;; Upstream's unit-test mode needs no Docker or BuildKit daemon:
              ;; https://github.com/docker/buildx/blob/v0.38.2/Dockerfile#L99
              (setenv "SKIP_INTEGRATION_TESTS" "1")))
          ;; Module mode needs go.mod in the working directory.  The standard
          ;; license phase expects to start from the GOPATH root.
          (add-before 'build 'enter-module
            (lambda* (#:key unpack-path #:allow-other-keys)
              (chdir (string-append "src/" unpack-path))))
          (add-after 'check 'leave-module
            (lambda _
              (chdir (getenv "GOPATH"))))
          (add-after 'build 'rename-command
            (lambda _
              (rename-file (string-append #$output "/bin/buildx")
                           (string-append #$output "/bin/docker-buildx"))))
          (add-after 'install 'install-plugin
            (lambda _
              (let ((plugins (string-append #$output "/lib/docker/cli-plugins")))
                (mkdir-p plugins)
                (symlink "../../../bin/docker-buildx"
                         (string-append plugins "/docker-buildx")))))
          (add-after 'install-plugin 'check-installed
            (lambda* (#:key tests? #:allow-other-keys)
              (define (output-of . args)
                (let* ((pipe (apply open-pipe* OPEN_READ args))
                       (result (get-string-all pipe)))
                  (unless (zero? (close-pipe pipe))
                    (error "Buildx command failed" args))
                  result))
              (when tests?
                (let ((buildx (string-append #$output "/bin/docker-buildx"))
                      (plugin (string-append #$output
                               "/lib/docker/cli-plugins/docker-buildx")))
                  (unless (string-prefix?
                           (string-append "github.com/docker/buildx v"
                                          #$version " ")
                           (output-of buildx "version"))
                    (error "Unexpected Buildx version"))
                  (unless (string-contains
                           (output-of plugin "docker-cli-plugin-metadata")
                           (string-append "v" #$version))
                    (error "Missing Docker CLI plugin metadata"))
                  (call-with-output-file "docker-bake.hcl"
                    (lambda (port)
                      (display "target \"default\" { tags = [\"package-test:latest\"] }\n"
                               port)))
                  (unless (string-contains
                           (output-of buildx "bake" "--file" "docker-bake.hcl"
                                      "--print")
                           "package-test:latest")
                    (error "Bake configuration parsing failed")))))))))
    (native-inputs (list git-minimal))
    (home-page "https://github.com/docker/buildx")
    (synopsis "Docker CLI plugin for extended BuildKit builds")
    (description
     "Buildx extends the Docker command line with BuildKit features, including
multi-platform images, remote builders, and declarative builds with Bake.  It
provides both the docker-buildx command and a Docker CLI plugin under
@file{lib/docker/cli-plugins}.  Add that directory to Docker's
@code{cliPluginsExtraDirs} configuration to use @code{docker buildx}.")
    (license license:asl2.0)))
