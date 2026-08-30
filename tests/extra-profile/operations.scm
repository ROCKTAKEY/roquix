(use-modules (guix build utils)
             (guix utils)
             (roquix extra-profiles operations)
             (roquix extra-profiles paths)
             (srfi srfi-64))

(define (condition-kind thunk)
  (catch #t
         (lambda ()
           (thunk) #f)
         (lambda (key condition . rest)
           (and (extra-profile-error? condition)
                (extra-profile-error-kind condition)))))

(define (make-store-profile store name)
  (let ((target (string-append store "/" name "-profile")))
    (mkdir-p target)
    (call-with-output-file (string-append target "/manifest")
      (lambda (port)
        (write '(manifest (version 4)
                          (packages ())) port))) target))

(test-begin "extra-profile-operations")

(call-with-temporary-directory (lambda (directory)
                                 (let* ((definitions (string-append directory
                                                      "/definitions"))
                                        (profiles (string-append directory
                                                                 "/profiles"))
                                        (store (string-append directory
                                                              "/store"))
                                        (manifest-only (parse-profile-name
                                                        "manifest-only"))
                                        (profile-only (parse-profile-name
                                                       "profile-only"))
                                        (manifest (manifest-path manifest-only
                                                   #:root definitions))
                                        (profile (profile-path profile-only
                                                               #:root profiles))
                                        (generation (string-append profile
                                                                   "-3-link"))
                                        (target (make-store-profile store
                                                 "aaaaaaaa-profile-only")))
                                   (mkdir-p (dirname manifest))
                                   ;; Deliberately invalid Scheme proves that discovery does not evaluate it.
                                   (call-with-output-file manifest
                                     (lambda (port)
                                       (display
                                        "(this manifest is not evaluated" port)))
                                   (mkdir-p (dirname profile))
                                   (symlink (basename generation) profile)
                                   (symlink target generation)

                                   (test-equal
                                    "list includes manifest-only and profile-only names"
                                    '("manifest-only" "profile-only")
                                    (map profile-name-value
                                         (list-profile-names
                                                             #:definitions-root
                                                             definitions
                                                             #:profiles-root
                                                             profiles)))
                                   (test-equal
                                    "reconfigure --all discovery includes definitions only"
                                    '("manifest-only")
                                    (map profile-name-value
                                         (list-definition-names
                                                                #:definitions-root
                                                                definitions)))

                                   (let ((manifest-description (describe-profile
                                                                manifest-only
                                                                #:definitions-root
                                                                definitions
                                                                #:profiles-root
                                                                profiles
                                                                #:store-directory
                                                                store))
                                         (profile-description (describe-profile
                                                               profile-only
                                                               #:definitions-root
                                                               definitions
                                                               #:profiles-root
                                                               profiles
                                                               #:store-directory
                                                               store)))
                                     (test-assert
                                      "show represents a manifest-only definition"
                                      (profile-description-manifest-present?
                                       manifest-description))
                                     (test-equal
                                      "manifest-only profile status"
                                      'not-configured
                                      (profile-description-status
                                       manifest-description))
                                     (test-assert
                                      "show represents a configured profile without a definition"
                                      (not (profile-description-manifest-present?
                                            profile-description)))
                                     (test-equal "configured profile status"
                                                 'configured
                                                 (profile-description-status
                                                  profile-description))
                                     (test-equal
                                      "show snapshots the configured generation"
                                      target
                                      (profile-description-generation-target
                                       profile-description)))

                                   (test-equal
                                    "path returns the conventional mutable profile path"
                                    profile
                                    (profile-path profile-only
                                                  #:root profiles))

                                   (let ((request (prepare-reconfiguration
                                                   manifest-only
                                                   #:definitions-root
                                                   definitions
                                                   #:profiles-root profiles)))
                                     (test-assert
                                      "an existing manifest parses into a reconfiguration"
                                      (reconfiguration? request))
                                     (test-equal
                                      "reconfigure delegates through public guix package options"
                                      (list "package"
                                            (string-append "--profile="
                                                           (profile-path
                                                            manifest-only
                                                            #:root profiles))
                                            (string-append "--manifest="
                                                           manifest)
                                            "--dry-run" "--no-substitutes")
                                      (reconfiguration-arguments request
                                                                 '("--dry-run"
                                                                   "--no-substitutes"))))

                                   (test-equal
                                    "reconfigure rejects a missing definition"
                                    'missing-definition
                                    (condition-kind (lambda ()
                                                      (prepare-reconfiguration
                                                       profile-only
                                                       #:definitions-root
                                                       definitions
                                                       #:profiles-root
                                                       profiles))))

                                   (let ((configured (resolve-profile
                                                      profile-only
                                                      #:profiles-root profiles
                                                      #:store-directory store)))
                                     (test-equal
                                      "generations delegates to the configured mutable profile"
                                      (list "package"
                                            (string-append "--profile="
                                                           profile)
                                            "--list-generations")
                                      (generation-arguments configured #f))
                                     (test-equal
                                      "generation patterns remain a single option argument"
                                      (list "package"
                                            (string-append "--profile="
                                                           profile)
                                            "--list-generations=2d")
                                      (generation-arguments configured "2d"))
                                     (test-equal
                                      "roll-back delegates to the configured mutable profile"
                                      (list "package"
                                            (string-append "--profile="
                                                           profile)
                                            "--roll-back")
                                      (rollback-arguments configured))))))

(test-end "extra-profile-operations")
