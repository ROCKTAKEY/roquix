(define-module
  (roquix packages emacs)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages emacs)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages commencement))

(define-public emacs-keg
  (let ((commit "7fbfd987d35e29eaab2ebad4f0ed6ee2e2adfe28")
        (revision "0"))
    (package
    (name "emacs-keg")
    (version (git-version "0.0.1" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/conao3/keg.el")
             (commit commit)))
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
    (inputs (list emacs))
    (home-page "https://github.com/conao3/keg.el")
    (synopsis "keg.el")
    (description
     "Modern Elisp package development system.
Keg is 100% Elisp project and it developed as alternative to Cask.")
    (license license:gpl3+))))

(define-public emacs-cask
  (let ((commit "2fd12b3aef435bcbdd31e64fbdfbbe69e7bcc65f")
        (revision "0"))
   (package
    (name "emacs-cask")
    (version (git-version "0.8.8" revision commit))
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/cask/cask")
             (commit commit)))
       (file-name (git-file-name name version))
       (sha256
        (base32
         "1m3y2icmj9l0bix66i6gmfsn0j934qfv5wi5p4sw6086n6mc5wrr"))))
    (build-system copy-build-system)
    (arguments '(#:install-plan
                 '(("." "src/cask"))
                 #:phases
                 (modify-phases %standard-phases
                   (add-after 'install 'install-bin
                     (lambda* (#:key outputs #:allow-other-keys)
                       (mkdir-p (string-append (assoc-ref outputs "out") "/bin"))
                       (symlink (string-append (assoc-ref outputs "out") "/src/cask/bin/cask")
                                (string-append (assoc-ref outputs "out") "/bin/cask")))))))
    (inputs (list emacs))
    (home-page "https://github.com/cask/cask")
    (synopsis "Project management tool for Emacs")
    (description
     "Project management tool for Emacs.")
    (license license:gpl3+))))

;; FIXME: Not work because of the syntax error below:
;; SyntaxError: Unexpected token ':'
;;     at new Script (node:vm:101:7)
;;     at readPrelude (node:internal/bootstrap/pkg:29:13)
;;     at node:internal/bootstrap/pkg:36:18
;;     at node:internal/bootstrap/pkg:43:4
;;     at node:internal/bootstrap/pkg:44:2
(define-public emacs-eask
  (package
   (name "emacs-eask")
   (version "0.8.1")
   (source
    (origin
     (method url-fetch)
     (uri (string-append
           "https://github.com/emacs-eask/cli/releases/download/" version "/eask_" version "_linux-x64.zip"))
     (sha256
      (base32
       "1f1bqh5wjmxnb546ax5i4rh54qrpch1a35lr73fw2jyng3q2z21w"))))
   (build-system binary-build-system)
   (arguments '(#:install-plan
                ;; HACK: `unpack' change into child directory even if other file exists in top level
                '((".." "src/eask"))
                #:patchelf-plan
                '(("../eask" ("gcc" "gcc-toolchain")))
                #:phases
                (modify-phases %standard-phases
                               (add-after 'install 'install-bin
                                          (lambda* (#:key outputs #:allow-other-keys)
                                            (mkdir-p (string-append (assoc-ref outputs "out") "/bin"))
                                            (chmod (string-append (assoc-ref outputs "out") "/src/eask/eask") #o555)
                                            (symlink (string-append (assoc-ref outputs "out") "/src/eask/eask")
                                                     (string-append (assoc-ref outputs "out") "/bin/eask")))))))
   ;; FIXME: Somehow unzip is needed
   (native-inputs
    (list unzip))
   (inputs
    (list
     `(,gcc "lib")
     gcc-toolchain))
   (home-page "https://emacs-eask.github.io")
   (synopsis "CLI for building, runing, testing, and managing your Emacs Lisp dependencies")
   (description "CLI for building, runing, testing, and managing your Emacs Lisp dependencies.")
   (license license:gpl3+)))
