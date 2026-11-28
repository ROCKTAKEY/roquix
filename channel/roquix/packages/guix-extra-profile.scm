(define-module (roquix packages guix-extra-profile)
  #:use-module (guix build-system copy)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (guix search-paths))

(define (channel-file name)
  (canonicalize-path (search-path %load-path name)))

(define-public guix-extra-profile
  (package
    (name "guix-extra-profile")
    (version "0.1.0")
    (source
     (file-union "extra-profile-source"
                 `(("extra-profile.scm"
                    ,(local-file (channel-file "roquix/extensions/extra-profile.scm")))
                   ("extra-profiles"
                    ,(local-file (dirname (channel-file "roquix/extra-profiles/paths.scm"))
                                 #:recursive? #t)))))
    (build-system copy-build-system)
    (arguments
     (list
      #:install-plan
      #~'(("extra-profile.scm" "share/guix/extensions/1.5/guix/extensions/extra-profile.scm")
          ("extra-profiles/" "share/guix/extensions/1.5/roquix/extra-profiles/"
           #:include (".scm")))
      #:phases
      #~(modify-phases %standard-phases
          (add-before 'install 'set-extension-module-name
            (lambda _
              (substitute* "extra-profile.scm"
                (("\\(roquix extensions extra-profile\\)")
                 "(guix extensions extra-profile)")))))))
    (native-search-paths
     (list (search-path-specification
            (variable "GUIX_EXTENSIONS_PATH")
            (files '("share/guix/extensions/1.5" "share/guix/extensions")))))
    (home-page "https://github.com/ROCKTAKEY/roquix")
    (synopsis "Manage named Guix profiles")
    (description "This Guix extension manages named profiles and composes
them into shell environments.")
    (license license:gpl3+)))
