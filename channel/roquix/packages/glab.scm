(define-module
  (roquix packages glab)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages version-control)
  #:use-module (guix build-system go)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define %glab-version "1.113.0")
(define %glab-commit "d62881304ccba9e24d07bcfb2c5e8bcae3f17f75")

(define %glab-source
  (origin
    (method url-fetch)
    ;; The release source archive contains vendor/, which makes the Go build
    ;; reproducible in Guix's network-isolated build environment.
    (uri (string-append
          "https://gitlab.com/gitlab-org/cli/-/releases/v" %glab-version
          "/downloads/glab_" %glab-version "_source.tar.gz"))
    (sha256
     (base32 "0pk2kgim435rwsin4iv3fv1l0qr0zm2c6nfavwzy16cbs49wr9pa"))))

(define-public go-gitlab-com-gitlab-org-cli
  (package
    (name "go-gitlab-com-gitlab-org-cli")
    (version %glab-version)
    (source %glab-source)
    (build-system go-build-system)
    (arguments
     (list
      #:go go-1.26
      #:skip-build? #t
      #:tests? #f
      #:import-path "gitlab.com/gitlab-org/cli"))
    (home-page "https://gitlab.com/gitlab-org/cli")
    (synopsis "GitLab CLI source")
    (description
     "This package provides the vendored Go source tree for GLab, the GitLab
command-line interface.")
    (license license:expat)))

(define-public glab
  (package
    (inherit go-gitlab-com-gitlab-org-cli)
    (name "glab")
    (native-inputs (list git-minimal))
    (arguments
     (list
      #:go go-1.26
      #:install-source? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'enter-vendored-module
            (lambda* (#:key unpack-path #:allow-other-keys)
              ;; Module mode preserves canonical import paths used by vendored
              ;; assembly symbols; GOPATH mode prefixes them with the parent
              ;; vendor path and leaves segmentio/asm symbols unresolved.
              (chdir (string-append "src/" unpack-path))
              (setenv "GO111MODULE" "on")
              (setenv "GOPROXY" "off")
              (setenv "GOTOOLCHAIN" "local")
              (setenv "CGO_ENABLED" "0")))
          (add-before 'check 'initialize-test-repository
            (lambda _
              ;; cmdtest locates fixtures through `git rev-parse`; release
              ;; source archives intentionally contain no Git metadata.
              (setenv "HOME"
                      (getcwd))
              (invoke "git" "init" "--initial-branch=main" ".")))
          (add-after 'check 'leave-vendored-module
            (lambda _
              (chdir (getenv "GOPATH")))))
      #:build-flags
      #~(list (string-append "-ldflags=-s -w -X main.version="
                             #$%glab-version " -X main.commit="
                             #$%glab-commit))
      #:import-path "gitlab.com/gitlab-org/cli/cmd/glab"
      #:unpack-path "gitlab.com/gitlab-org/cli"))
    (synopsis "GitLab command-line interface")
    (description
     "GLab is a command-line interface for GitLab.  It supports working with
issues, merge requests, CI pipelines, releases, and other GitLab features from
the terminal.")))
