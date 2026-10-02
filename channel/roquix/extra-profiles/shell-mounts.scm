;;; Copyright © 2026 ROCKTAKEY
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software: you can redistribute it and/or modify it under
;;; the terms of the GNU General Public License as published by the Free
;;; Software Foundation, either version 3 of the License, or (at your option)
;;; any later version.

(define-module (roquix extra-profiles shell-mounts)
  #:use-module (roquix extra-profiles paths)
  #:use-module (roquix extra-profiles shell-configuration)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (prepare-shell-mounts prepared-shell-mounts?
                                 prepared-shell-mount-arguments))

(define-record-type <prepared-shell-mounts>
  (make-prepared-shell-mounts mounts) prepared-shell-mounts?
  (mounts prepared-shell-mounts-values))

(define (call-with-absent-source thunk absent)
  ;; Only ENOENT is optional.  ENOTDIR and EACCES mean an unusable source.
  (catch 'system-error thunk
         (lambda args
           (if (= ENOENT
                  (system-error-errno args))
               (absent)
               (apply throw args)))))

(define (metadata-or-missing path)
  (call-with-absent-source (lambda ()
                             (lstat path))
                           (const #f)))

(define (check-source-links path)
  ;; A trailing slash makes lstat follow a directory symlink; strip it to
  ;; distinguish an absent directory from a dangling link to that directory.
  (let* ((stripped (string-trim-right path #\/))
         (path (if (string-null? stripped) "/" stripped))
         (metadata (metadata-or-missing path)))
    (cond
      ((not metadata)
       (unless (string=? path "/")
         (check-source-links (dirname path))))
      ((eq? 'symlink
            (stat:type metadata))
       ;; lstat distinguishes a dangling link from an intentionally absent path.
       (stat path)))))

(define (source-metadata path)
  (call-with-absent-source (lambda ()
                             (stat path))
                           (lambda ()
                             (check-source-links path) #f)))

(define (require-source-directory path)
  (unless (eq? 'directory
               (stat:type (stat path)))
    (raise-extra-profile-error 'mount-source-not-directory #f path)))

(define (create-source-directory path)
  (if (source-metadata path)
      (require-source-directory path)
      (begin
        (create-source-directory (dirname path))
        (catch 'system-error
               (lambda ()
                 (mkdir path #o700)
                 ;; Only a directory created by this invocation has its mode changed.
                 (chmod path #o700))
               (lambda args
                 (unless (= EEXIST
                            (system-error-errno args))
                   (apply throw args))))
        (require-source-directory path))))

(define (prepare-mount-source mount)
  (let ((source (shell-mount-source mount))
        (policy (shell-mount-on-missing mount)))
    (cond
      ((source-metadata source)
       (when (eq? 'create-directory policy)
         (require-source-directory source)) mount)
      ((eq? 'skip policy)
       #f)
      ((eq? 'create-directory policy)
       (create-source-directory source) mount)
      (else (raise-extra-profile-error 'missing-mount-source #f source)))))

(define (prepare-request request)
  (let* ((name (requested-shell-mount-name request))
         (mount (requested-shell-mount-value request))
         (source (shell-mount-source mount)))
    (call-with-extra-profile-error (lambda ()
                                     (catch 'system-error
                                            (lambda ()
                                              (prepare-mount-source mount))
                                            (lambda args
                                              (raise-extra-profile-error 'unusable-mount-source
                                               name source))))
                                   (lambda (condition)
                                     (raise-extra-profile-error (extra-profile-error-kind
                                                                 condition)
                                                                name source)))))

(define (prepare-shell-mounts plan)
  "Prepare only conflict-checked requests, retaining a distinct ready state."
  (unless (shell-mount-plan? plan)
    (error "expected a checked mount plan" plan))
  (make-prepared-shell-mounts (filter-map identity
                                          (map-in-order prepare-request
                                                        (shell-mount-plan-requests
                                                         plan)))))

(define (prepared-shell-mount-arguments prepared)
  (unless (prepared-shell-mounts? prepared)
    (error "expected prepared shell mounts" prepared))
  (map (lambda (mount)
         (string-append (if (eq? 'read-write
                                 (shell-mount-access mount)) "--share="
                            "--expose=")
                        (shell-mount-source mount) "="
                        (shell-mount-target mount)))
       (prepared-shell-mounts-values prepared)))
