(use-modules (guix build utils)
             (guix utils)
             (ice-9 textual-ports)
             (roquix extra-profiles paths)
             (roquix extra-profiles shell)
             (srfi srfi-1)
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

(define (link-profile root name generation target)
  (let* ((parsed (parse-profile-name name))
         (profile (profile-path parsed
                                #:root root))
         (generation-link (string-append profile "-"
                                         (number->string generation) "-link")))
    (mkdir-p (dirname profile))
    (symlink target generation-link)
    (symlink (basename generation-link) profile)))

(define (mode file)
  (logand #x1ff
          (stat:perms (stat file))))

(test-begin "extra-profile-shell")

(let ((invocation (parse-shell-arguments '("codex" "codex"
                                           "texlive"
                                           "--"
                                           "-CWNF"
                                           "-m"
                                           "./manifest.scm"
                                           "--"
                                           "sh"
                                           "-c"
                                           "exit 17"))))
  (test-assert "shell arguments parse into a distinct state"
               (shell-invocation? invocation))
  (test-equal "duplicate names are removed without reordering"
              '("codex" "texlive")
              (map profile-name-value
                   (shell-invocation-names invocation)))
  (test-equal "everything after the first boundary remains byte-for-byte"
              '("-CWNF" "-m"
                "./manifest.scm"
                "--"
                "sh"
                "-c"
                "exit 17")
              (shell-invocation-guix-arguments invocation)))

(test-equal "shell can omit the guix shell argument boundary"
            '()
            (shell-invocation-guix-arguments (parse-shell-arguments '("codex"))))

(test-equal "shell requires at least one profile name"
            'missing-name
            (condition-kind (lambda ()
                              (parse-shell-arguments '()))))

(test-equal "a boundary without a profile name is rejected"
            'missing-name
            (condition-kind (lambda ()
                              (parse-shell-arguments '("--" "--help")))))

(test-equal "guix shell options before the boundary are profile-name errors"
            'invalid-name
            (condition-kind (lambda ()
                              (parse-shell-arguments '("codex" "-CWNF")))))

(call-with-temporary-directory (lambda (directory)
                                 (let* ((root (string-append directory
                                                             "/profiles"))
                                        (store (string-append directory
                                                              "/store"))
                                        (cache (string-append directory
                                                              "/cache"))
                                        (target-a (make-store-profile store
                                                   "aaaaaaaa-profile-a"))
                                        (target-b (make-store-profile store
                                                   "bbbbbbbb-profile-b")))
                                   (link-profile root "profile-a" 1 target-a)
                                   (link-profile root "profile-b" 7 target-b)
                                   (let* ((parsed (parse-shell-arguments '("profile-a"
                                                                           "profile-b"
                                                                           "--"
                                                                           "--help")))
                                          (snapshot (snapshot-shell-invocation
                                                     parsed
                                                     #:profiles-root root
                                                     #:store-directory store))
                                          (content (combined-manifest-content
                                                    snapshot))
                                          (path (ensure-combined-manifest
                                                 snapshot
                                                 #:cache-root cache)))
                                     (test-assert
                                      "resolved profiles form a snapshot state"
                                      (snapshotted-shell? snapshot))
                                     (test-equal
                                      "snapshot captures terminal generations in order"
                                      (list target-a target-b)
                                      (map
                                       configured-profile-generation-target
                                       (snapshotted-shell-profiles snapshot)))
                                     (test-assert
                                      "combined manifest references the first target"
                                      (string-contains content target-a))
                                     (test-assert
                                      "combined manifest references the second target"
                                      (string-contains content target-b))
                                     (test-assert
                                      "manifest preserves profile priority order"
                                      (< (string-contains content target-a)
                                         (string-contains content target-b)))
                                     (test-equal
                                      "cache path is based at the requested XDG cache root"
                                      (string-append cache
                                       "/guix/extra-profile/shell-manifests/"
                                       (combined-manifest-key snapshot) ".scm")
                                      path)
                                     (test-equal "cache directory is private"
                                                 448
                                                 (mode (dirname path)))
                                     (test-equal "cache manifest is private"
                                                 384
                                                 (mode path))
                                     (test-equal
                                      "cache contains the complete expected manifest"
                                      content
                                      (call-with-input-file path
                                        get-string-all))
                                     (let ((inode (stat:ino (stat path))))
                                       (test-equal
                                        "correct cache files are reused without replacement"
                                        path
                                        (ensure-combined-manifest snapshot
                                                                  #:cache-root
                                                                  cache))
                                       (test-equal
                                        "cache reuse preserves the file" inode
                                        (stat:ino (stat path))))

                                     (call-with-output-file path
                                       (lambda (port)
                                         (display "corrupt" port)))
                                     (test-equal
                                      "incorrect regular cache files are atomically replaced"
                                      path
                                      (ensure-combined-manifest snapshot
                                                                #:cache-root
                                                                cache))
                                     (test-equal
                                      "replacement restores complete contents"
                                      content
                                      (call-with-input-file path
                                        get-string-all))

                                     (delete-file path)
                                     (let ((children (map (lambda (_)
                                                            (let ((pid (primitive-fork)))
                                                              (if (zero? pid)
                                                                  (begin
                                                                    (ensure-combined-manifest
                                                                     snapshot
                                                                     #:cache-root
                                                                     cache)
                                                                    (primitive-exit
                                                                     0)) pid)))
                                                          (iota 4))))
                                       (test-assert
                                        "concurrent cache writers all succeed"
                                        (every (compose zero? cdr waitpid)
                                               children)))
                                     (test-equal
                                      "concurrent writers leave complete contents"
                                      content
                                      (call-with-input-file path
                                        get-string-all))

                                     (delete-file path)
                                     (mkdir path)
                                     (test-equal
                                      "a cache directory cannot replace a manifest"
                                      'unsafe-cache-file
                                      (condition-kind (lambda ()
                                                        (ensure-combined-manifest
                                                         snapshot
                                                         #:cache-root cache))))
                                     (rmdir path)
                                     (symlink "/dev/null" path)
                                     (test-equal
                                      "a cache symlink is never reused or replaced"
                                      'unsafe-cache-file
                                      (condition-kind (lambda ()
                                                        (ensure-combined-manifest
                                                         snapshot
                                                         #:cache-root cache))))

                                     (let* ((unsafe-root (string-append
                                                          directory
                                                          "/unsafe-cache"))
                                            (unsafe-directory (shell-manifests-directory
                                                               #:cache-root
                                                               unsafe-root)))
                                       (mkdir-p (dirname unsafe-directory))
                                       (symlink "/tmp" unsafe-directory)
                                       (test-equal
                                        "a cache directory symlink is rejected"
                                        'unsafe-cache-directory
                                        (condition-kind (lambda ()
                                                          (ensure-combined-manifest
                                                           snapshot
                                                           #:cache-root
                                                           unsafe-root)))))

                                     (test-equal
                                      "guix shell gets the generated manifest before user args"
                                      (list "shell"
                                            (string-append "--manifest=" path)
                                            "--help")
                                      (guix-shell-arguments snapshot path))))))

(call-with-temporary-directory (lambda (directory)
                                 (let* ((root (string-append directory
                                                             "/profiles"))
                                        (store (string-append directory
                                                              "/store"))
                                        (target-1 (make-store-profile store
                                                   "aaaaaaaa-generation-1"))
                                        (target-2 (make-store-profile store
                                                   "bbbbbbbb-generation-2")))
                                   (link-profile root "profile-a" 1 target-1)
                                   (let* ((invocation (parse-shell-arguments '
                                                                             ("profile-a")))
                                          (snapshot-1 (snapshot-shell-invocation
                                                       invocation
                                                       #:profiles-root root
                                                       #:store-directory store))
                                          (profile (profile-path (parse-profile-name
                                                                  "profile-a")
                                                                 #:root root)))
                                     (delete-file profile)
                                     (link-profile root "profile-a" 2 target-2)
                                     (let ((snapshot-2 (snapshot-shell-invocation
                                                        invocation
                                                        #:profiles-root root
                                                        #:store-directory
                                                        store)))
                                       (test-equal
                                        "an existing snapshot stays pinned after reconfigure"
                                        target-1
                                        (configured-profile-generation-target (first
                                                                               (snapshotted-shell-profiles
                                                                                snapshot-1))))
                                       (test-equal
                                        "the next snapshot observes the new generation"
                                        target-2
                                        (configured-profile-generation-target (first
                                                                               (snapshotted-shell-profiles
                                                                                snapshot-2))))
                                       (test-assert
                                        "generation changes select a new cache key"
                                        (not (string=? (combined-manifest-key
                                                        snapshot-1)
                                                       (combined-manifest-key
                                                        snapshot-2)))))))))

(test-end "extra-profile-shell")
