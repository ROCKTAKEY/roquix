(use-modules (roquix extra-profiles paths)
             (roquix extra-profiles shell-configuration)
             (srfi srfi-64))

(define (condition-kind thunk)
  (call-with-extra-profile-error (lambda ()
                                   (thunk) #f) extra-profile-error-kind))

(test-begin "extra-profile-shell-configuration")

(let ((configuration (shell-configuration (extra-options '("-CWNF")))))
  (test-assert "configuration construction retains a parsed type"
               (shell-configuration? configuration))
  (test-equal "ordinary options retain their spelling"
              '("-CWNF")
              (shell-configuration-extra-options configuration))
  (test-equal "mounts default to empty"
              '()
              (shell-configuration-mounts configuration)))

(test-equal "options default to empty"
            '()
            (shell-configuration-extra-options (shell-configuration)))

(for-each (lambda (options)
            (test-equal
             "saved options exclude mount options and command boundaries"
             'invalid-shell-options
             (condition-kind (lambda ()
                               (shell-configuration (extra-options options))))))
          '(42 ("-C" 42)
            ("--")
            ("--share" "/tmp")
            ("--share=/tmp")
            ("--expose" "/tmp")
            ("--expose=/tmp")))

(test-equal "mount lists must contain parsed mount requests"
            'invalid-shell-mounts
            (condition-kind (lambda ()
                              (shell-configuration (mounts '("/tmp"))))))

(let ((shared (share "/host"))
      (exposed (expose "/host"
                       #:target "/config/./codex/../"
                       #:on-missing 'skip)))
  (test-equal
   "share defaults to the source target and errors on missing sources"
   '("/host" "/host" read-write error)
   (list (shell-mount-source shared)
         (shell-mount-target shared)
         (shell-mount-access shared)
         (shell-mount-on-missing shared)))
  (test-equal
   "expose has normalized targets and an independent missing policy"
   '("/host" "/config" read-only skip)
   (list (shell-mount-source exposed)
         (shell-mount-target exposed)
         (shell-mount-access exposed)
         (shell-mount-on-missing exposed))))

(for-each (lambda (source)
            (test-equal
             "mount sources must be absolute and representable in Guix SPEC"
             'invalid-mount-source
             (condition-kind (lambda ()
                               (share source)))))
          (list #f "" "relative" "/path=ambiguous"
                (string #\/ #\nul)))

(test-equal "relative mount targets are rejected"
            'invalid-mount-target
            (condition-kind (lambda ()
                              (expose "/host"
                                      #:target "relative"))))

(test-equal "unknown missing policies are rejected"
            'invalid-mount-policy
            (condition-kind (lambda ()
                              (share "/host"
                                     #:on-missing 'ignore))))

(test-assert "container is a typed setting, disabled by default"
             (not (shell-configuration-container? (shell-configuration))))
(test-assert "container can be explicitly enabled"
             (shell-configuration-container? (shell-configuration (container?
                                                                   #t))))
(test-equal "boolean settings reject truthy non-booleans"
            'invalid-shell-setting
            (condition-kind (lambda ()
                              (shell-configuration (container? "yes")))))

(test-equal "all basic flags default to disabled"
            '(#f #f
              #f
              #f
              #f
              #f
              #f)
            (map (lambda (accessor)
                   (accessor (shell-configuration)))
                 (list shell-configuration-container?
                       shell-configuration-network?
                       shell-configuration-nesting?
                       shell-configuration-link-profile?
                       shell-configuration-writable-root?
                       shell-configuration-emulate-fhs?
                       shell-configuration-pure?)))

(let* ((entry (cons (parse-profile-name "sandbox")
                    (shell-configuration (container? #t)
                                         (network? #t)
                                         (nesting? #t)
                                         (link-profile? #t)
                                         (writable-root? #t)
                                         (emulate-fhs? #t)
                                         (pure? #t)
                                         (preserve '("^TERM$"))
                                         (environment-variables '(("TOKEN" . "with spaces=ok"))))))
       (composed (compose-shell-configurations (list entry)))
       (settings (composed-shell-configuration-settings composed)))
  (test-assert "composed configuration retains checked settings"
               (and (composed-shell-configuration? composed)
                    (shell-configuration-network? settings)
                    (shell-configuration-pure? settings)))
  (test-equal "environment variables are data, not shell words"
              '(("TOKEN" . "with spaces=ok"))
              (shell-configuration-environment-variables settings)))

(for-each (lambda (configuration)
            (test-equal "container-only fields require a structured container"
             'settings-require-container
             (condition-kind (lambda ()
                               (compose-shell-configurations (list (cons (parse-profile-name
                                                                          "sandbox")
                                                                    configuration)))))))
          (list (shell-configuration (network? #t))
                (shell-configuration (writable-root? #t))
                (shell-configuration (emulate-fhs? #t))
                (shell-configuration (nesting? #t))
                (shell-configuration (link-profile? #t))))

(for-each (lambda (patterns)
            (test-equal
             "inheritance contains valid regexps, never assignments"
             'invalid-shell-preserve
             (condition-kind (lambda ()
                               (shell-configuration (preserve patterns))))))
          (list 42
                '(42)
                '("[")
                '("VAR=value")
                (list (string #\nul))))
(for-each (lambda (variables)
            (test-equal
             "environment entries require representable name/value pairs"
             'invalid-shell-environment
             (condition-kind (lambda ()
                               (shell-configuration (environment-variables
                                                     variables))))))
          (list 42
                '("FOO=bar")
                '(("" . "value"))
                '(("A=B" . "value"))
                '(("A" . 42))
                (list (cons (string #\nul) "value"))
                (list (cons "A"
                            (string #\nul)))))

(test-end "extra-profile-shell-configuration")
