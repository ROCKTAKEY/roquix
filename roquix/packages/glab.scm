(define-module
  (roquix packages glab)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary))

(define-public go-gitlab-com-gitlab-org-cli
  (package
   (name "go-gitlab-com-gitlab-org-cli")
   (version "1.35.0")
   (source (origin
            (method url-fetch)
            (uri (string-append "https://gitlab.com/gitlab-org/cli/-/releases/v"
                                version "/downloads/glab_" version "_Linux_x86_64.tar.gz"))
            (sha256
             (base32
              "19n0wg5qjg6ixsk3ysjkx2dl432riijyaazs8vwyjngbx3813fn9"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                '(("glab" "/bin/"))))
   (home-page "https://gitlab.com/gitlab-org/cli")
   (synopsis "A GitLab CLI tool bringing GitLab to your command line")
   (description
    "GLab is an open source GitLab CLI tool bringing GitLab to your terminal
next to where you are already working with @code{git} and your code without switching
between windows and browser tabs. Work with issues, merge requests, watch
running pipelines directly from your CLI among other features.")
   (license license:expat)))
