(define-module
  (roquix packages glab)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary))

(define-public go-github-com-profclems-glab
  (package
   (name "go-github-com-profclems-glab")
   (version "1.22.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://github.com/profclems/glab/releases/download/v"
                                version "/glab_" version "_Linux_x86_64.tar.gz"))
            (sha256
             (base32
              "0pwa4kakka88cnbzcg3bcfgpd0grzngdsp9ik4475mwccjaayw3x"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("glab" "/bin/"))))
   (home-page "https://github.com/profclems/glab")
   (synopsis "GLab")
   (description
    "GLab is an open source GitLab CLI tool bringing GitLab to your terminal next to
where you are already working with @code{git} and your code without switching
between windows and browser tabs.  Work with issues, merge requests,
@strong{watch running pipelines directly from your CLI} among other features.
Inspired by @url{https://github.com/cli/cli,gh}, the official GitHub CLI tool.")
   (license license:expat)))
