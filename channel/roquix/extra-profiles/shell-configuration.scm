;;; Copyright © 2026 ROCKTAKEY
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software: you can redistribute it and/or modify it under
;;; the terms of the GNU General Public License as published by the Free
;;; Software Foundation, either version 3 of the License, or (at your option)
;;; any later version.

(define-module (roquix extra-profiles shell-configuration)
  #:use-module (guix records)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (roquix extra-profiles paths)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (shell-configuration shell-configuration?
                                shell-configuration-extra-options
                                shell-configuration-network?
                                shell-configuration-nesting?
                                shell-configuration-link-profile?
                                shell-configuration-writable-root?
                                shell-configuration-emulate-fhs?
                                shell-configuration-pure?
                                shell-configuration-preserve
                                shell-configuration-environment-variables
                                shell-configuration-container?
                                shell-configuration-mounts
                                share
                                expose
                                shell-mount?
                                shell-mount-source
                                shell-mount-target
                                shell-mount-access
                                shell-mount-on-missing
                                compose-shell-configurations
                                composed-shell-configuration?
                                composed-shell-configuration-settings
                                composed-shell-configuration-mounts
                                compose-shell-mounts
                                shell-mount-plan?
                                shell-mount-plan-requests
                                requested-shell-mount-name
                                requested-shell-mount-value))

(define-record-type <shell-mount>
  (make-shell-mount source target access on-missing)
  shell-mount?
  (source shell-mount-source)
  (target shell-mount-target)
  (access shell-mount-access)
  (on-missing shell-mount-on-missing))

(define (parse-mount-path value kind)
  (unless (and (string? value)
               (string-prefix? "/" value)
               (not (string-index value #\nul)))
    (raise-extra-profile-error kind #f value
     #:message "mount paths must be absolute strings without NUL")) value)

(define (parse-mount-source source)
  (parse-mount-path source
                    'invalid-mount-source)
  ;; Guix splits SOURCE=TARGET at the first '=', without an escape syntax.
  ;; https://codeberg.org/guix/guix/src/branch/master/gnu/system/file-systems.scm
  (when (string-index source #\=)
    (raise-extra-profile-error 'invalid-mount-source #f source
                               #:message "mount source cannot contain '='"))
  source)

(define (parse-mount-target target)
  (parse-mount-path target
                    'invalid-mount-target)
  (let loop
    ((parts (string-split target #\/))
     (result '()))
    (match parts
      (() (string-append "/"
                         (string-join (reverse result) "/")))
      ((or ("" rest ...)
           ("." rest ...))
       (loop rest result))
      ((".." rest ...)
       (loop rest
             (if (null? result) result
                 (cdr result))))
      ((part rest ...)
       (loop rest
             (cons part result))))))

(define (parse-mount-policy policy)
  (unless (memq policy
                '(error skip create-directory))
    (raise-extra-profile-error 'invalid-mount-policy #f #f
     #:message "on-missing must be error, skip or create-directory")) policy)

(define (parse-shell-mount source target access on-missing)
  (make-shell-mount (parse-mount-source source)
                    (parse-mount-target target) access
                    (parse-mount-policy on-missing)))

(define* (share source
                #:key (target source)
                (on-missing 'error))
  (parse-shell-mount source target
                     'read-write on-missing))

(define* (expose source
                 #:key (target source)
                 (on-missing 'error))
  (parse-shell-mount source target
                     'read-only on-missing))

(define (parse-extra-options options)
  (unless (and (list? options)
               (every string? options)
               (not (any (lambda (option)
                           (or (member option
                                       '("--" "--share" "--expose"))
                               (string-prefix? "--share=" option)
                               (string-prefix? "--expose=" option)
                               (string-index option #\nul))) options)))
    (raise-extra-profile-error 'invalid-shell-options #f #f
     #:message
     "extra-options must be a list of strings without --, --share or --expose"))
  options)

(define (parse-shell-mounts mounts)
  (unless (and (list? mounts)
               (every shell-mount? mounts))
    (raise-extra-profile-error 'invalid-shell-mounts #f #f
     #:message "shell mounts must be a list of share or expose requests"))
  mounts)

(define (parse-shell-boolean value)
  (unless (boolean? value)
    (raise-extra-profile-error 'invalid-shell-setting #f #f
                               #:message
                               "shell boolean settings require #t or #f"))
  value)

(define (environment-string? value)
  (and (string? value)
       (not (string-index value #\nul))))

(define (inheritance-pattern? pattern)
  ;; Guix interprets '=' in --preserve as an assignment, not a regexp.
  ;; https://codeberg.org/guix/guix/src/branch/master/guix/scripts/environment.scm
  (and (environment-string? pattern)
       (not (string-index pattern #\=))
       (catch 'regular-expression-syntax
              (lambda ()
                (make-regexp pattern) #t)
              (lambda args
                #f))))

(define (parse-shell-preserve patterns)
  (unless (and (list? patterns)
               (every inheritance-pattern? patterns))
    (raise-extra-profile-error 'invalid-shell-preserve #f #f
     #:message "preserve must contain valid regexps without '=' or NUL"))
  patterns)

(define (environment-entry? entry)
  (and (pair? entry)
       (environment-string? (car entry))
       (not (string-null? (car entry)))
       (not (string-index (car entry) #\=))
       (environment-string? (cdr entry))))

(define (parse-shell-environment variables)
  (unless (and (list? variables)
               (every environment-entry? variables))
    (raise-extra-profile-error 'invalid-shell-environment #f #f
     #:message
     "environment-variables must contain (name . value) string pairs; names must be nonempty without '=' and strings must be NUL-free"))
  variables)

(define-record-type* <shell-configuration> shell-configuration
                     make-shell-configuration
  shell-configuration?
  (container? shell-configuration-container?
              (default #f)
              (sanitize parse-shell-boolean))
  (network? shell-configuration-network?
            (default #f)
            (sanitize parse-shell-boolean))
  (nesting? shell-configuration-nesting?
            (default #f)
            (sanitize parse-shell-boolean))
  (link-profile? shell-configuration-link-profile?
                 (default #f)
                 (sanitize parse-shell-boolean))
  (writable-root? shell-configuration-writable-root?
                  (default #f)
                  (sanitize parse-shell-boolean))
  (emulate-fhs? shell-configuration-emulate-fhs?
                (default #f)
                (sanitize parse-shell-boolean))
  (pure? shell-configuration-pure?
         (default #f)
         (sanitize parse-shell-boolean))
  (preserve shell-configuration-preserve
            (default '())
            (sanitize parse-shell-preserve))
  (environment-variables shell-configuration-environment-variables
                         (default '())
                         (sanitize parse-shell-environment))
  (extra-options shell-configuration-extra-options
                 (default '())
                 (sanitize parse-extra-options))
  (mounts shell-configuration-mounts
          (default '())
          (sanitize parse-shell-mounts)))

(define-record-type <requested-shell-mount>
  (make-requested-shell-mount name value) requested-shell-mount?
  (name requested-shell-mount-name)
  (value requested-shell-mount-value))

(define-record-type <shell-mount-plan>
  (make-shell-mount-plan requests) shell-mount-plan?
  (requests shell-mount-plan-requests))

(define (requested-target request)
  (shell-mount-target (requested-shell-mount-value request)))

(define (same-mount? left right)
  (every (lambda (accessor)
           (equal? (accessor left)
                   (accessor right)))
         (list shell-mount-source shell-mount-target shell-mount-access
               shell-mount-on-missing)))

(define (coalesce-mounts requests)
  (reverse (fold (lambda (request result)
                   (let ((previous (find (lambda (candidate)
                                           (string=? (requested-target request)
                                                     (requested-target
                                                      candidate))) result)))
                     (cond
                       ((not previous)
                        (cons request result))
                       ((same-mount? (requested-shell-mount-value previous)
                                     (requested-shell-mount-value request))
                        result)
                       (else (raise-extra-profile-error 'conflicting-shell-mount
                                                        (string-append (profile-name-value
                                                                        (requested-shell-mount-name
                                                                         previous))
                                                                       ", "
                                                                       (profile-name-value
                                                                        (requested-shell-mount-name
                                                                         request)))
                                                        (requested-target
                                                         request))))))
                 '() requests)))

(define (order-mounts requests)
  ;; Guix mounts in argument order; a later parent would hide its children.
  ;; https://codeberg.org/guix/guix/src/branch/master/guix/scripts/environment.scm
  (define (parent? parent child)
    (let ((target (requested-target parent)))
      (string-prefix? (if (string=? target "/") "/"
                          (string-append target "/"))
                      (requested-target child))))
  (define (visit request result)
    (if (memq request result) result
        (cons request
              (fold visit result
                    (filter (lambda (candidate)
                              (and (not (eq? request candidate))
                                   (parent? candidate request))) requests)))))
  (reverse (fold visit
                 '() requests)))

(define (require-named-configuration entry)
  (unless (and (pair? entry)
               (profile-name? (car entry))
               (shell-configuration? (cdr entry)))
    (error "expected a named shell configuration" entry)) entry)

(define (named-mount-requests entry)
  (require-named-configuration entry)
  (map (lambda (mount)
         (make-requested-shell-mount (car entry) mount))
       (shell-configuration-mounts (cdr entry))))

(define (compose-shell-mounts configurations)
  "Compose (parsed profile name . configuration) pairs into a checked plan."
  (make-shell-mount-plan (order-mounts (coalesce-mounts (append-map
                                                         named-mount-requests
                                                         configurations)))))

(define-record-type <composed-shell-configuration>
  (make-composed-shell-configuration settings mounts)
  composed-shell-configuration?
  (settings composed-shell-configuration-settings)
  (mounts composed-shell-configuration-mounts))

(define (merge-shell-settings configurations)
  (shell-configuration (container? (any shell-configuration-container?
                                        configurations))
                       (network? (any shell-configuration-network?
                                      configurations))
                       (nesting? (any shell-configuration-nesting?
                                      configurations))
                       (link-profile? (any shell-configuration-link-profile?
                                           configurations))
                       (writable-root? (any shell-configuration-writable-root?
                                        configurations))
                       (emulate-fhs? (any shell-configuration-emulate-fhs?
                                          configurations))
                       (pure? (any shell-configuration-pure? configurations))
                       (preserve (append-map shell-configuration-preserve
                                             configurations))
                       (environment-variables (append-map
                                               shell-configuration-environment-variables
                                               configurations))
                       (extra-options (append-map
                                       shell-configuration-extra-options
                                       configurations))))

(define (requested-container-setting configuration)
  (let ((field (find (lambda (field)
                       ((cdr field)
                        configuration))
                     (list (cons "network?" shell-configuration-network?)
                           (cons "nesting?" shell-configuration-nesting?)
                           (cons "link-profile?"
                                 shell-configuration-link-profile?)
                           (cons "writable-root?"
                                 shell-configuration-writable-root?)
                           (cons "emulate-fhs?"
                                 shell-configuration-emulate-fhs?)))))
    (and field
         (car field))))

(define (require-container-for-settings entry)
  (let ((field (requested-container-setting (cdr entry))))
    (when field
      (raise-extra-profile-error 'settings-require-container
                                 (car entry) field))))

(define (compose-shell-configurations entries)
  "Resolve cross-profile constraints before any filesystem preparation."
  (for-each require-named-configuration entries)
  (let* ((settings (merge-shell-settings (map cdr entries)))
         (plan (compose-shell-mounts entries)))
    (unless (shell-configuration-container? settings)
      (when (pair? (shell-mount-plan-requests plan))
        (raise-extra-profile-error 'mounts-require-container
                                   (requested-shell-mount-name (car (shell-mount-plan-requests
                                                                     plan)))
                                   #f))
      (for-each require-container-for-settings entries))
    (make-composed-shell-configuration settings plan)))
