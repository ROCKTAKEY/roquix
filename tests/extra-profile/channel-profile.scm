(use-modules (guix build utils)
             (guix describe)
             (guix profiles)
             (ice-9 match)
             (srfi srfi-1))

(define (channel-profile-entry name version item properties)
  `(,name ,version
    "out"
    ,item
    (propagated-inputs ())
    (search-paths ())
    (properties ,@properties)))

(define (channel-profile-manifest guix-entry channel)
  (define guix
    (channel-profile-entry "guix"
                           (manifest-entry-version guix-entry)
                           (manifest-entry-item guix-entry)
                           (manifest-entry-properties guix-entry)))
  (define fixture
    (channel-profile-entry "extra-profile-test" "1" channel
                           '((source (repository (version 0)
                                                 (url
                                                  "https://example.org/extra-profile-test")
                                                 (branch "main")
                                                 (commit
                                                  "0000000000000000000000000000000000000000"))))))
  `(manifest (version 3)
             (packages (,guix ,fixture))))

(match (cdr (command-line))
  ((repository directory command)
   (let* ((guix-entry (find (lambda (entry)
                              (string=? "guix"
                                        (manifest-entry-name entry)))
                            (current-profile-entries)))
          (channel
            (string-append directory "/channel"))
          (modules (string-append channel "/share/guile/site/"
                                  (effective-version)))
          (profile (string-append directory "/profile")))
     (unless guix-entry
       (error "channel integration test requires a guix pull profile"))
     (mkdir-p (string-append profile "/bin"))
     (mkdir-p modules)
     (symlink (canonicalize-path command)
              (string-append profile "/bin/guix"))
     (symlink (string-append repository "/channel/guix")
              (string-append modules "/guix"))
     (mkdir-p (string-append modules "/roquix"))
     (symlink (string-append repository "/channel/roquix/extra-profiles")
              (string-append modules "/roquix/extra-profiles"))
     (mkdir-p (string-append modules "/extra-profile/fixtures"))
     (symlink (string-append repository
                             "/tests/extra-profile/fixtures/packages.scm")
              (string-append modules "/extra-profile/fixtures/packages.scm"))
     ;; Exercise Guix's profile discovery without pulling or compiling a channel.
     ;; The manifest contains only Guix itself and the working-tree test channel.
     (call-with-output-file (string-append profile "/manifest")
       (lambda (port)
         (write (channel-profile-manifest guix-entry channel) port))))))
