(define-module
  (roquix packages disk)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix git-download)
  #:use-module (guix download)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cmake)
  #:use-module (gnu packages)
  #:use-module (gnu packages ncurses)
  #:use-module (gnu packages freedesktop))

(define-public crazydiskinfo
  (package
    (name "crazydiskinfo")
    (version "1.1.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/otakuto/crazydiskinfo")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "094f60dydjq22diq5zqp8sjs58yp3lz0x2dln1x6whr0m2hs397v"))))
    (build-system cmake-build-system)
    (arguments
     '(#:phases (modify-phases %standard-phases
                  (add-before 'configure 'before-configure
                    (lambda* (#:key outputs #:allow-other-keys)
                      (substitute* '("CMakeLists.txt")
                        (("tinfow")
                         "tinfo")
                        (("/usr/sbin")
                         (string-append (assoc-ref outputs "out") "/bin"))))))
       #:tests? #f))
    (inputs (list ncurses ncurses/tinfo libatasmart))
    (home-page "https://github.com/otakuto/crazydiskinfo")
    (synopsis
     "CrazyDiskInfo is an interactive TUI S.M.A.R.T viewer for Unix systems.")
    (description
     "CrazyDiskInfo is an interactive TUI S.M.A.R.T viewer for Unix systems.")
    (license license:expat)))
