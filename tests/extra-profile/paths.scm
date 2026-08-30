(use-modules (guix build utils)
             (guix utils)
             (roquix extra-profiles paths)
             (srfi srfi-1)
             (srfi srfi-64))

(define (call-with-environment variables thunk)
  (let ((saved (map (lambda (variable)
                      (cons (car variable) (getenv (car variable))))
                    variables)))
    (dynamic-wind
      (lambda ()
        (for-each (lambda (variable)
                    (setenv (car variable) (cdr variable)))
                  variables))
      thunk
      (lambda ()
        (for-each (lambda (variable)
                    (if (cdr variable)
                        (setenv (car variable) (cdr variable))
                        (unsetenv (car variable))))
                  saved)))))

(define (condition-kind thunk)
  (catch #t
    (lambda ()
      (thunk)
      #f)
    (lambda (key condition . rest)
      (and (extra-profile-error? condition)
           (extra-profile-error-kind condition)))))

(define (make-store-profile store name)
  (let ((target (string-append store "/" name "-profile")))
    (mkdir-p target)
    (call-with-output-file (string-append target "/manifest")
      (lambda (port)
        (write '(manifest (version 4) (packages ())) port)))
    target))

(test-begin "extra-profile-paths")

(test-equal "valid profile names are parsed into a distinct type"
  '("codex" "texlive-2026" "C++" "a.b_c")
  (map (compose profile-name-value parse-profile-name)
       '("codex" "texlive-2026" "C++" "a.b_c")))

(for-each
 (lambda (name)
   (test-equal (format #f "invalid profile name: ~s" name)
     'invalid-name
     (condition-kind (lambda () (parse-profile-name name)))))
 '("" "." ".." ".git" "-codex" "a/b" "a b" "a\nb"))

(call-with-temporary-directory
 (lambda (directory)
   (let ((xdg-config (string-append directory "/config"))
         (home (string-append directory "/home")))
     (mkdir-p home)
     (call-with-environment
      `(("XDG_CONFIG_HOME" . ,xdg-config)
        ("HOME" . ,home))
      (lambda ()
        (let ((name (parse-profile-name "codex")))
          (test-equal "definitions root follows XDG_CONFIG_HOME"
            (string-append xdg-config "/guix/extra-profiles")
            (definitions-root))
          (test-equal "manifest path follows the definitions convention"
            (string-append xdg-config
                           "/guix/extra-profiles/codex/manifest.scm")
            (manifest-path name))
          (test-equal "profile path follows HOME"
            (string-append home "/.guix-extra-profiles/codex/codex")
            (profile-path name))))))))

(call-with-temporary-directory
 (lambda (directory)
   (let* ((root (string-append directory "/profiles"))
          (store (string-append directory "/store"))
          (name (parse-profile-name "profile-a"))
          (profile (profile-path name #:root root))
          (generation (string-append profile "-1-link"))
          (target (make-store-profile store "aaaaaaaa-profile-a")))
     (mkdir-p (dirname profile))
     (symlink (basename generation) profile)
     (symlink target generation)
     (let ((configured (resolve-profile name
                                        #:profiles-root root
                                        #:store-directory store)))
       (test-assert "profile symlinks resolve to a configured-profile value"
         (configured-profile? configured))
       (test-equal "profile name survives the state transition"
         "profile-a"
         (profile-name-value (configured-profile-name configured)))
       (test-equal "generation target is snapped to the terminal store path"
         target
         (configured-profile-generation-target configured))))))

(call-with-temporary-directory
 (lambda (directory)
   (let* ((root (string-append directory "/profiles"))
          (store (string-append directory "/store"))
          (name (parse-profile-name "profile-a"))
          (profile (profile-path name #:root root)))
     (mkdir-p (dirname profile))
     (mkdir-p store)
     (test-equal "a missing profile is not configured"
       'not-configured
       (condition-kind
        (lambda ()
          (resolve-profile name
                           #:profiles-root root
                           #:store-directory store))))
     (symlink "profile-a-1-link" profile)
     (test-equal "a broken profile symlink is distinguished"
       'broken-symlink
       (condition-kind
        (lambda ()
          (resolve-profile name
                           #:profiles-root root
                           #:store-directory store))))
     (delete-file profile)
     (call-with-output-file profile (const #t))
     (test-equal "a regular file is not accepted as a profile"
       'invalid-profile
       (condition-kind
        (lambda ()
          (resolve-profile name
                           #:profiles-root root
                           #:store-directory store)))))))

(call-with-temporary-directory
 (lambda (directory)
   (let* ((root (string-append directory "/profiles"))
          (store (string-append directory "/store"))
          (name (parse-profile-name "profile-a"))
          (profile (profile-path name #:root root))
          (generation (string-append profile "-1-link")))
     (mkdir-p (dirname profile))
     (mkdir-p store)
     (symlink (basename generation) profile)
     (symlink (basename profile) generation)
     (test-equal "symlink cycles are rejected"
       'symlink-cycle
       (condition-kind
        (lambda ()
          (resolve-profile name
                           #:profiles-root root
                           #:store-directory store)))))))

(call-with-temporary-directory
 (lambda (directory)
   (let* ((root (string-append directory "/profiles"))
          (store (string-append directory "/store"))
          (outside (string-append directory "/outside-profile"))
          (name (parse-profile-name "profile-a"))
          (profile (profile-path name #:root root)))
     (mkdir-p (dirname profile))
     (mkdir-p outside)
     (call-with-output-file (string-append outside "/manifest") (const #t))
     (symlink outside profile)
     (test-equal "targets outside the active store are rejected"
       'outside-store
       (condition-kind
        (lambda ()
          (resolve-profile name
                           #:profiles-root root
                           #:store-directory store))))
     (delete-file profile)
     (let ((target (string-append store "/bbbbbbbb-profile-a")))
       (mkdir-p target)
       (symlink target profile)
       (test-equal "store targets without a manifest are rejected"
         'missing-manifest
         (condition-kind
          (lambda ()
            (resolve-profile name
                             #:profiles-root root
                             #:store-directory store))))))))

(test-end "extra-profile-paths")
