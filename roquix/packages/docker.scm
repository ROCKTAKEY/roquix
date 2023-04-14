(define-module
  (roquix packages docker)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages docker)
  #:use-module (nonguix build-system binary))

(define-public docker-buildx
  (package
    (name "docker-buildx")
    (version "0.10.4")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/docker/buildx/releases/download/v" version "/buildx-v" version ".linux-amd64"))
       (sha256
        (base32
         "16w6dvi3n1kg5prjggxgklbir88crms0kwz3hgy500bxagf8rrnv"))))
    (build-system binary-build-system)
    (arguments `(#:install-plan
                 '((,(string-append "./" "buildx-v" version ".linux-amd64") "/usr/local/lib/docker/cli-plugins/docker-buildx"))))
    (home-page "https://github.com/docker/buildx")
    (synopsis "Docker CLI plugin for extended build capabilities with BuildKit")
    (description "
The buildx is a Docker CLI plugin for extended build capabilities with BuildKit.

Key features:

    Familiar UI from docker build
    Full BuildKit capabilities with container driver
    Multiple builder instance support
    Multi-node builds for cross-platform images
    Compose build support
    High-level build constructs (bake)
    In-container driver support (both Docker and Kubernetes)
")
    (license license:asl2.0)))

(define-public docker-with-buildx
  (package
    (inherit docker)
    (inputs
     (modify-inputs (package-inputs docker)
       (prepend docker-buildx)))))
