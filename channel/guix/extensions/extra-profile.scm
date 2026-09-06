;;; Copyright © 2026 ROCKTAKEY
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software: you can redistribute it and/or modify it under
;;; the terms of the GNU General Public License as published by the Free
;;; Software Foundation, either version 3 of the License, or (at your option)
;;; any later version.

(define-module (guix extensions extra-profile)
  #:use-module (guix scripts)
  #:use-module (guix scripts build)
  #:use-module (guix ui)
  #:use-module (ice-9 match)
  #:use-module (roquix extra-profiles operations)
  #:use-module (roquix extra-profiles paths)
  #:use-module (roquix extra-profiles shell)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-37)
  #:export (guix-extra-profile

                               reconfigure-invocation?
                               reconfigure-invocation-names
                               reconfigure-invocation-all?
                               reconfigure-invocation-dry-run?
                               reconfigure-invocation-build-arguments
                               parse-reconfigure-arguments))

(define-record-type <reconfigure-invocation>
  (make-reconfigure-invocation names all? dry-run? build-arguments)
  reconfigure-invocation?
  (names reconfigure-invocation-names)
  (all? reconfigure-invocation-all?)
  (dry-run? reconfigure-invocation-dry-run?)
  (build-arguments reconfigure-invocation-build-arguments))

(define (forwarded-option-spelling name argument)
  (let ((option (if (char? name)
                    (string #\- name)
                    (string-append "--" name))))
    (if argument
        (string-append option
                       (if (char? name) "" "=") argument) option)))

(define (forwarding-build-option original)
  (option (option-names original)
          (option-required-arg? original)
          (option-optional-arg? original)
          (lambda (option name
                          argument
                          names
                          all?
                          dry-run?
                          forwarded)
            (values names all? dry-run?
                    (append forwarded
                            (list (forwarded-option-spelling name argument)))))))

(define %reconfigure-options
  (append (list (option '("all") #f #f
                        (lambda (option name
                                        argument
                                        names
                                        all?
                                        dry-run?
                                        forwarded)
                          (values names #t dry-run? forwarded)))
                (option '(#\n "dry-run") #f #f
                        (lambda (option name
                                        argument
                                        names
                                        all?
                                        dry-run?
                                        forwarded)
                          (values names all? #t
                                  (append forwarded
                                          (list "--dry-run"))))))
          (map forwarding-build-option %standard-build-options)))

(define (parse-reconfigure-arguments arguments)
  (call-with-values (lambda ()
                      (args-fold* arguments
                                  %reconfigure-options
                                  (lambda (option name argument . seeds)
                                    (leave (G_ "~a: unrecognized option~%")
                                           name))
                                  (lambda (argument names all? dry-run?
                                                    forwarded)
                                    (values (append names
                                                    (list argument)) all?
                                            dry-run? forwarded))
                                  '()
                                  #f
                                  #f
                                  '()))
                    (lambda (raw-names all? dry-run? build-arguments)
                      (when (and all?
                                 (pair? raw-names))
                        (leave (G_
                                "--all cannot be combined with profile names~%")))
                      (when (and (not all?)
                                 (null? raw-names))
                        (raise-extra-profile-error 'missing-name #f #f))
                      (make-reconfigure-invocation (parse-profile-names
                                                    raw-names) all? dry-run?
                                                   build-arguments))))

(define (show-help)
  (display (G_
            "Usage: guix extra-profile COMMAND [ARGUMENTS...]
Manage named extra profiles and compose them into guix shell environments.
"))
  (display (G_ "
Commands:
"))
  (display (G_ "  list                         list known extra profiles
"))
  (display (G_
            "  show NAME                    show definition and profile state
"))
  (display (G_ "  path NAME                    print the mutable profile path
"))
  (display (G_ "  reconfigure NAME...          apply definition manifests
"))
  (display (G_ "  reconfigure --all            apply every definition manifest
"))
  (display (G_
            "  shell NAME... [-- ARGS...]   run guix shell with extra profiles
"))
  (display (G_ "  generations NAME [PATTERN]   list profile generations
"))
  (display (G_
            "  roll-back NAME               switch to the previous generation
"))
  (newline)
  (show-bug-report-information))

(define (require-one-name subcommand arguments)
  (if (= 1
         (length arguments))
      (parse-profile-name (car arguments))
      (leave (G_ "~a requires exactly one profile name~%") subcommand)))

(define (extra-profile-error-reason kind)
  (case kind
    ((broken-symlink)
     "its generation link is broken")
    ((symlink-cycle)
     "its generation links contain a cycle")
    ((symlink-limit)
     "its generation link chain is too deep")
    ((invalid-profile)
     "its profile path is not a symbolic link")
    ((outside-store)
     "its current generation is outside the Guix store")
    ((missing-manifest)
     "its current generation has no manifest")
    ((unsafe-cache-directory)
     "the shell manifest cache directory is unsafe")
    ((unsafe-cache-file)
     "the shell manifest cache file is unsafe")
    ((invalid-guix-executable)
     "the running Guix executable cannot be resolved")
    (else "its state is invalid")))

(define (report-extra-profile-error condition)
  (let ((kind (extra-profile-error-kind condition))
        (name (extra-profile-error-name condition))
        (path (extra-profile-error-path condition)))
    (case kind
      ((invalid-name)
       (leave (G_ "invalid profile name '~a'~%") name))
      ((missing-name)
       (leave (G_ "at least one profile name is required~%")))
      ((not-configured)
       (report-error (G_ "profile '~a' has not been configured~%") name)
       (display-hint (format #f
                             (G_
                              "Run @command{guix extra-profile reconfigure ~a}.~%")
                             name))
       (exit 1))
      ((missing-definition)
       (leave (G_ "definition manifest for profile '~a' does not exist: ~a~%")
              name path))
      (else (leave (G_ "profile '~a' is unusable: ~a~@[ (~a)~]~%")
                   (or name "?")
                   (extra-profile-error-reason kind) path)))))

(define (run-reconfigure arguments)
  (let* ((invocation (parse-reconfigure-arguments arguments))
         (names (if (reconfigure-invocation-all? invocation)
                    (list-definition-names)
                    (reconfigure-invocation-names invocation)))
         (requests (map prepare-reconfiguration names))
         (guix (current-guix-executable)))
    (let loop
      ((requests requests))
      (match requests
        (() #t)
        ((request rest ...)
         (let ((status (run-reconfiguration request guix
                                            (reconfigure-invocation-build-arguments
                                             invocation))))
           (if (zero? status)
               (loop rest)
               (exit status))))))))

(define (run-generations arguments)
  (if (<= 1
          (length arguments) 2)
      (let* ((name (parse-profile-name (car arguments)))
             (pattern (and (pair? (cdr arguments))
                           (cadr arguments)))
             (profile (resolve-profile name))
             (status (run-guix-operation (current-guix-executable)
                                         (generation-arguments profile pattern))))
        (exit status))
      (leave (G_ "generations requires a profile name and optional pattern~%"))))

(define (run-roll-back arguments)
  (let* ((name (require-one-name "roll-back" arguments))
         (profile (resolve-profile name))
         (status (run-guix-operation (current-guix-executable)
                                     (rollback-arguments profile))))
    (exit status)))

(define (dispatch arguments)
  (match arguments
    (((or "-h" "--help"))
     (show-help))
    (() (leave (G_ "missing subcommand~%")))
    (("list")
     (for-each (lambda (name)
                 (display (profile-name-value name))
                 (newline))
               (list-profile-names)))
    (("list" _ ...)
     (leave (G_ "list does not accept arguments~%")))
    (("show" rest ...)
     (write-profile-description (describe-profile (require-one-name "show"
                                                                    rest))
                                (current-output-port)))
    (("path" rest ...)
     (display (profile-path (require-one-name "path" rest)))
     (newline))
    (("reconfigure" rest ...)
     (run-reconfigure rest))
    (("shell" rest ...)
     (execute-snapshotted-shell (snapshot-shell-invocation (parse-shell-arguments
                                                            rest))))
    (("generations" rest ...)
     (run-generations rest))
    (("roll-back" rest ...)
     (run-roll-back rest))
    ((subcommand _ ...)
     (leave (G_ "unknown subcommand '~a'~%") subcommand))))

(define-command (guix-extra-profile . arguments)
                (category extension)
                (synopsis "manage named extra profiles")
                (call-with-extra-profile-error (lambda ()
                                                 (dispatch arguments))
                                               report-extra-profile-error))
