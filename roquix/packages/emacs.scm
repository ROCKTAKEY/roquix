(define-module
  (roquix packages emacs)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (gnu packages emacs))

(define-public emacs-keg
  (package
    (name "emacs-keg")
    (version "0.0.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/conao3/keg.el")
             (commit "7fbfd987d35e29eaab2ebad4f0ed6ee2e2adfe28")))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1d5clcjqp48m5282my3akp47h996xn9jxr8kxs7pkz18wixy48aw"))))
    (build-system copy-build-system)
    (arguments '(#:install-plan
                 '(("." "src/keg.el"))
                 #:phases
                 (modify-phases %standard-phases
                   (add-after 'install 'install-bin
                     (lambda* (#:key outputs #:allow-other-keys)
                       (mkdir-p (string-append (assoc-ref outputs "out") "/bin"))
                       (symlink (string-append (assoc-ref outputs "out") "/src/keg.el/bin/keg")
                                (string-append (assoc-ref outputs "out") "/bin/keg")))))))
    (propagated-inputs (list emacs))
    (home-page "https://github.com/conao3/keg.el")
    (synopsis "keg.el")
    (description
     "Modern Elisp package development system.
Keg is 100% Elisp project and it developed as alternative to Cask.")
    (license license:gpl3+)))
