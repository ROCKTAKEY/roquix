(use-modules (guix build utils)
             (guix utils)
             (roquix extra-profiles paths)
             (roquix extra-profiles shell)
             (roquix extra-profiles shell-configuration)
             (roquix extra-profiles shell-mounts)
             (srfi srfi-64))

(define (capture-failure thunk)
  (call-with-extra-profile-error (lambda ()
                                   (thunk) #f) identity))

(define (configuration mounts)
  `(shell-configuration (container? #t)
                        (mounts (list ,@mounts))))

(test-begin "extra-profile-shell-mounts")

(define (check-mount-behavior directory)
  (let* ((definitions (string-append directory "/definitions"))
         (source (string-append directory "/host with spaces"))
         (missing (string-append directory "/missing"))
         (created (string-append directory "/private/nested/cache"))
         (file (string-append source "/input"))
         (socket-path (string-append source "/socket")))
    (define* (arguments configurations
                        #:optional (cli '("-CWNF")))
      (for-each (lambda (entry)
                  (let ((path (string-append definitions "/"
                                             (car entry) "/shell.scm")))
                    (mkdir-p (dirname path))
                    (call-with-output-file path
                      (lambda (port)
                        (write '(use-modules (roquix extra-profiles
                                                     shell-configuration))
                               port)
                        (newline port)
                        (write (cdr entry) port))))) configurations)
      (snapshotted-shell-guix-arguments (snapshot-shell-invocation (parse-shell-arguments
                                                                    (append (map
                                                                             car
                                                                             configurations)
                                                                     '("--")
                                                                     cli))
                                         #:definitions-root definitions
                                         #:profiles-root (string-append
                                                          directory
                                                          "/profiles")
                                         #:store-directory (string-append
                                                            directory "/store"))))
    (define (failure mounts)
      (capture-failure (lambda ()
                         (arguments (list (cons "sandbox"
                                                (configuration mounts)))))))
    (mkdir source)
    (call-with-output-file file
      (lambda (port)
        (display "data" port)))

    (test-equal "parent mounts precede children even across profile order"
                (list "--container"
                      (string-append "--share=" source "=/workspace")
                      (string-append "--expose=" source "=/workspace/config")
                      "-CWNF")
                (arguments (list (cons "child"
                                       (configuration `((expose ,source
                                                         #:target
                                                         "/workspace/config"))))
                                 (cons "parent"
                                       (configuration `((share ,source
                                                               #:target
                                                               "/workspace")))))))

    (test-equal "identical requests coalesce after target normalization"
                (list "--container"
                      (string-append "--share=" source "=/workspace") "-CWNF")
                (arguments (list (cons "one"
                                       (configuration `((share ,source
                                                         #:target
                                                         "/workspace/./"))))
                                 (cons "two"
                                       (configuration `((share ,source
                                                               #:target
                                                               "/workspace")))))))

    (for-each (lambda (other)
                (let ((condition (failure `((share ,source
                                                   #:target "/workspace")
                                            ,other))))
                  (test-equal
                   "different source, access or missing policy conflicts"
                   'conflicting-shell-mount
                   (extra-profile-error-kind condition))
                  (test-equal "conflict diagnostics identify the target"
                              "/workspace"
                              (extra-profile-error-path condition))))
              `((expose ,source
                        #:target "/workspace")
                (share ,missing
                       #:target "/workspace")
                (share ,source
                       #:target "/workspace"
                       #:on-missing 'skip)))

    (let ((condition (failure `((share ,missing)))))
      (test-equal "missing sources fail by default"
                  'missing-mount-source
                  (extra-profile-error-kind condition))
      (test-equal "missing source diagnostics retain the profile and path"
                  (list "sandbox" missing)
                  (list (extra-profile-error-name condition)
                        (extra-profile-error-path condition))))

    (test-equal "optional missing mounts are omitted"
                '("--container" "-CWNF")
                (arguments (list (cons "sandbox"
                                       (configuration `((expose ,missing
                                                                #:on-missing 'skip)))))))

    (let ((configuration `(shell-configuration (mounts (list (share ,source))))))
      (for-each (lambda (cli)
                  (test-equal
                   "mounts require the container field regardless of raw Guix arguments"
                   'mounts-require-container
                   (extra-profile-error-kind (capture-failure (lambda ()

                                                                (arguments (list
                                                                            (cons
                                                                             "sandbox"
                                                                             configuration))
                                                                 cli))))))
                '(() ("-C")
                  ("-CWNF")
                  ("--container")
                  ("--" "sh" "-C")
                  ("-E" "-C"))))

    (test-equal "container options can be supplied by saved configuration"
                (list "--container"
                      (string-append "--share=" source "=" source) "--" "echo"
                      "-C")
                (arguments (list (cons "sandbox"
                                       `(shell-configuration (container? #t)
                                                             (mounts (list (share ,source))))))
                           '("--" "echo" "-C")))

    (test-equal "container settings compose across profiles before mounts"
                (list "--container"
                      (string-append "--share=" source "=" source))
                (arguments (list (cons "mounts"
                                       `(shell-configuration (mounts (list (share ,source)))))
                                 (cons "sandbox"
                                       '(shell-configuration (container? #t))))
                           '()))

    (test-equal "missing container is detected before source creation"
                'mounts-require-container
                (extra-profile-error-kind (capture-failure (lambda ()
                                                             (arguments (list (cons
                                                                               "sandbox"
                                                                               `
                                                                               (shell-configuration
                                                                                (extra-options '
                                                                                 ("--container"))

                                                                                (mounts
                                                                                 (list
                                                                                  (share ,created
                                                                                   #:on-missing 'create-directory))))))
                                                                        '("-C"))))))
    (test-assert "failed configuration leaves missing host directories absent"
     (not (file-exists? (string-append directory "/private"))))

    (failure `((share ,created
                      #:on-missing 'create-directory)
               (share ,source
                      #:target "/conflict")
               (expose ,source
                       #:target "/conflict")))
    (test-assert
     "conflicts are detected before source directories are created"
     (not (file-exists? (string-append directory "/private"))))

    (test-equal
     "explicit creation works for read-only as well as writable mounts"
     (list "--container"
           (string-append "--expose=" created "=/cache") "-CWNF")
     (arguments (list (cons "sandbox"
                            (configuration `((expose ,created
                                                     #:target "/cache"
                                                     #:on-missing 'create-directory)))))))
    (test-equal "new source directories and parents are private"
                '(448 448 448)
                (map (lambda (path)
                       (logand #x1ff
                               (stat:perms (stat path))))
                     (list created
                           (dirname created)
                           (dirname (dirname created)))))
    (chmod created #o755)
    (arguments (list (cons "sandbox"
                           (configuration `((share ,created
                                                   #:on-missing 'create-directory))))))
    (test-equal "existing directory permissions are preserved" 493
                (logand #x1ff
                        (stat:perms (stat created))))

    (test-equal "regular files can be mounted"
                (list "--container"
                      (string-append "--expose=" file "=/input") "-CWNF")
                (arguments (list (cons "sandbox"
                                       (configuration `((expose ,file
                                                                #:target
                                                                "/input")))))))
    (test-equal "directory creation policies reject existing regular files"
                'mount-source-not-directory
                (extra-profile-error-kind (failure `((share ,file
                                                            #:on-missing 'create-directory)))))

    (let ((endpoint (socket AF_UNIX SOCK_STREAM 0)))
      (dynamic-wind (lambda ()
                      (bind endpoint AF_UNIX socket-path))
                    (lambda ()
                      (test-equal "sockets can be mounted"
                                  (list "--container"
                                        (string-append "--expose=" socket-path
                                                       "=/socket") "-CWNF")
                                  (arguments (list (cons "sandbox"
                                                         (configuration `((expose ,socket-path
                                                                           #:target
                                                                           "/socket"))))))))
                    (lambda ()
                      (close-port endpoint))))

    (let ((broken (string-append directory "/broken")))
      (symlink missing broken)
      (for-each (lambda (path)
                  (test-equal
                   "optional mounts do not hide broken source or ancestor links"
                   'unusable-mount-source
                   (extra-profile-error-kind (failure `((share ,path
                                                               #:on-missing 'skip))))))
                (list broken
                      (string-append broken "/")
                      (string-append broken "/child"))))
    (test-equal "optional mounts do not hide non-directory ancestors"
                'unusable-mount-source
                (extra-profile-error-kind (failure `((expose ,(string-append
                                                               file "/child")
                                                             #:on-missing 'skip)))))))

(call-with-temporary-directory check-mount-behavior)

(define (check-source-permissions directory)
  (let ((blocked (string-append directory "/blocked")))
    (mkdir blocked)
    (dynamic-wind (lambda ()
                    (chmod blocked #o0))
                  (lambda ()
                    (test-equal
                     "skip does not hide inaccessible source parents"
                     'unusable-mount-source
                     (extra-profile-error-kind (capture-failure (lambda ()

                                                                  (prepare-shell-mounts
                                                                   (compose-shell-mounts
                                                                    (list (cons
                                                                           (parse-profile-name
                                                                            "restricted")

                                                                           (shell-configuration
                                                                            (mounts
                                                                             (list
                                                                              (expose
                                                                               (string-append
                                                                                blocked
                                                                                "/missing")
                                                                               #:on-missing 'skip)))))))))))))
                  (lambda ()
                    (chmod blocked #o700)))))

(call-with-temporary-directory check-source-permissions)

(test-error "configuration requires composition before preparation" #t
            (prepare-shell-mounts (shell-configuration)))
(test-error "mount plan requires preparation before argument generation" #t
            (prepared-shell-mount-arguments (compose-shell-mounts '())))

(test-end "extra-profile-shell-mounts")
