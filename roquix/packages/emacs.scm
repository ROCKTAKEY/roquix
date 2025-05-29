(define-module
  (roquix packages emacs)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages emacs))

(define-public emacs-keg
  (let ((commit "930b3ab881440a026ec38c1674b3531aa2166e3f")
        (revision "1"))
    (package
      (name "emacs-keg")
      (version (git-version "0.0.1" revision commit))
      (source (origin
                (method git-fetch)
                (uri (git-reference
                      (url "https://github.com/conao3/keg.el")
                      (commit commit)))
                (file-name (git-file-name name version))
                (sha256
                 (base32
                  "00i02nlamh4g6hr6fmc94qlabn7p6k1p6fifkxkgmnl55vx4zkrx"))))
      (build-system copy-build-system)
      (arguments
       '(#:install-plan '(("." "src/keg.el"))
         #:phases (modify-phases %standard-phases
                    (add-after 'install 'install-bin
                      (lambda* (#:key outputs #:allow-other-keys)
                        (mkdir-p (string-append (assoc-ref outputs "out")
                                                "/bin"))
                        (symlink (string-append (assoc-ref outputs "out")
                                                "/src/keg.el/bin/keg")
                                 (string-append (assoc-ref outputs "out")
                                                "/bin/keg")))))))
      (inputs (list emacs))
      (home-page "https://github.com/conao3/keg.el")
      (synopsis "keg.el")
      (description
       "Modern Elisp package development system.
Keg is 100% Elisp project and it developed as alternative to Cask.")
      (license license:gpl3+))))

(define-public emacs-cask
  (package
    (name "emacs-cask")
    (version "0.9.0")
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/cask/cask")
                    (commit (string-append "v" version))))
              (file-name (git-file-name name version))
              (sha256
               (base32
                "1013cp97074ghjm3z7ah1xpgjwcr95pfibwg4lzvjj3nr8bcjnpp"))))
    (build-system copy-build-system)
    (arguments
     '(#:install-plan '(("." "src/cask"))
       #:phases (modify-phases %standard-phases
                  (add-after 'install 'install-bin
                    (lambda* (#:key outputs #:allow-other-keys)
                      (mkdir-p (string-append (assoc-ref outputs "out") "/bin"))
                      (symlink (string-append (assoc-ref outputs "out")
                                              "/src/cask/bin/cask")
                               (string-append (assoc-ref outputs "out")
                                              "/bin/cask")))))))
    (inputs (list emacs))
    (home-page "https://github.com/cask/cask")
    (synopsis "Project management tool for Emacs")
    (description "Project management tool for Emacs.")
    (license license:gpl3+)))

(define-public emacs-with-source
  (package
    (inherit emacs)
    (name "emacs-with-source")
    (arguments
     (list
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'build 'install-source
            (lambda* _
              (copy-recursively "." (string-append #$output "src")))))))))
