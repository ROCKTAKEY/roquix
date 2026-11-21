(define-module (roquix packages docker)
  #:use-module (guix build-system go)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages version-control))

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
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'configure-module-build
            (lambda _
              ;; Use the upstream vendor tree without downloading modules or
              ;; allowing Go to replace the packaged toolchain.
              (setenv "GO111MODULE" "on")
              (setenv "GOPROXY" "off")
              (setenv "GOTOOLCHAIN" "local")
              (setenv "GOMAXPROCS" (number->string (parallel-job-count)))))
          (replace 'build
            (lambda _
              (with-directory-excursion "src/github.com/docker/buildx"
                (invoke "go" "build" "-mod=vendor" "-trimpath"
                        #$(string-append "-ldflags=-s -w -X "
                                         "github.com/docker/buildx/version.Version=v"
                                         version)
                        "-o" "docker-buildx" "./cmd/buildx"))))
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (with-directory-excursion "src/github.com/docker/buildx"
                  ;; This is upstream's unit-test mode; integration tests need
                  ;; Docker and BuildKit daemons:
                  ;; https://github.com/docker/buildx/blob/v0.38.2/Dockerfile#L99
                  (setenv "SKIP_INTEGRATION_TESTS" "1")
                  ;; These two cases fetch remote Git branches from GitHub.
                  (invoke "go" "test" "-mod=vendor"
                          #$(string-append "-skip=^TestGitRemoteURL$/"
                                           "(single_tracking_branch|"
                                           "fork_tracking_branch)$")
                          "./...")))))
          (replace 'install
            (lambda _
              (let ((bin (string-append #$output "/bin"))
                    (plugins (string-append #$output "/lib/docker/cli-plugins")))
                (install-file "src/github.com/docker/buildx/docker-buildx" bin)
                (mkdir-p plugins)
                (symlink "../../../bin/docker-buildx"
                         (string-append plugins "/docker-buildx"))))))))
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
