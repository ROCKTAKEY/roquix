;;; Copyright © 2026 ROCKTAKEY
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software: you can redistribute it and/or modify it under
;;; the terms of the GNU General Public License as published by the Free
;;; Software Foundation, either version 3 of the License, or (at your option)
;;; any later version.

(define-module (roquix extra-profiles operations)
  #:use-module (guix build utils)
  #:use-module (guix store)
  #:use-module (ice-9 ftw)
  #:use-module (roquix extra-profiles paths)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-34)
  #:export (profile-description?
            profile-description-name
            profile-description-manifest-path
            profile-description-manifest-present?
            profile-description-profile-path
            profile-description-status
            profile-description-generation-target

            reconfiguration?
            reconfiguration-name
            reconfiguration-manifest-path
            reconfiguration-profile-path

            list-profile-names
            describe-profile
            write-profile-description
            prepare-reconfiguration
            reconfiguration-arguments
            run-reconfiguration
            generation-arguments
            rollback-arguments
            run-guix-operation
            process-exit-code))

(define-record-type <profile-description>
  (make-profile-description name manifest-path manifest-present?
                            profile-path status generation-target)
  profile-description?
  (name profile-description-name)
  (manifest-path profile-description-manifest-path)
  (manifest-present? profile-description-manifest-present?)
  (profile-path profile-description-profile-path)
  (status profile-description-status)
  (generation-target profile-description-generation-target))

(define-record-type <reconfiguration>
  (make-reconfiguration name manifest-path profile-path)
  reconfiguration?
  (name reconfiguration-name)
  (manifest-path reconfiguration-manifest-path)
  (profile-path reconfiguration-profile-path))

(define (lstat-exists? file)
  (catch 'system-error
    (lambda ()
      (lstat file)
      #t)
    (lambda args
      (if (= ENOENT (system-error-errno args))
          #f
          (apply throw args)))))

(define (directory-entries directory)
  (if (file-exists? directory)
      (scandir directory
               (lambda (entry)
                 (not (member entry '("." "..")))))
      '()))

(define (try-profile-name value)
  (guard (condition ((extra-profile-error? condition) #f))
    (parse-profile-name value)))

(define (definition-name? name root)
  (let ((manifest (manifest-path name #:root root)))
    (and (file-exists? manifest)
         (eq? 'regular (stat:type (stat manifest))))))

(define (profile-name-present? name root)
  (lstat-exists? (profile-path name #:root root)))

(define* (list-profile-names
          #:key
          (definitions-root (definitions-root))
          (profiles-root (profiles-root)))
  "Return sorted parsed names found in either definitions or profiles."
  (define (names-under root present?)
    (filter-map (lambda (entry)
                  (and=> (try-profile-name entry)
                         (lambda (name)
                           (and (present? name root) name))))
                (directory-entries root)))

  (sort (delete-duplicates
         (append (names-under definitions-root definition-name?)
                 (names-under profiles-root profile-name-present?))
         (lambda (left right)
           (string=? (profile-name-value left)
                     (profile-name-value right))))
        (lambda (left right)
          (string<? (profile-name-value left)
                    (profile-name-value right)))))

(define* (describe-profile
          name
          #:key
          (definitions-root (definitions-root))
          (profiles-root (profiles-root))
          (store-directory (%store-prefix)))
  "Return a description without evaluating NAME's definition manifest."
  (let ((manifest (manifest-path name #:root definitions-root))
        (profile (profile-path name #:root profiles-root)))
    (define manifest-present?
      (definition-name? name definitions-root))

    (guard (condition
            ((extra-profile-error? condition)
             (make-profile-description
              name manifest manifest-present? profile
              (extra-profile-error-kind condition) #f)))
      (let ((configured (resolve-profile name
                                         #:profiles-root profiles-root
                                         #:store-directory store-directory)))
        (make-profile-description
         name manifest manifest-present? profile 'configured
         (configured-profile-generation-target configured))))))

(define (write-profile-description description port)
  (format port "Name: ~a~%"
          (profile-name-value (profile-description-name description)))
  (format port "Manifest: ~a (~a)~%"
          (profile-description-manifest-path description)
          (if (profile-description-manifest-present? description)
              "present"
              "missing"))
  (format port "Profile: ~a (~a)~%"
          (profile-description-profile-path description)
          (profile-description-status description))
  (when (profile-description-generation-target description)
    (format port "Generation: ~a~%"
            (profile-description-generation-target description))))

(define* (prepare-reconfiguration
          name
          #:key
          (definitions-root (definitions-root))
          (profiles-root (profiles-root)))
  "Parse NAME's filesystem state into a reconfiguration request."
  (let ((manifest (manifest-path name #:root definitions-root))
        (profile (profile-path name #:root profiles-root)))
    (if (definition-name? name definitions-root)
        (make-reconfiguration name manifest profile)
        (raise-extra-profile-error 'missing-definition name manifest))))

(define (reconfiguration-arguments request build-arguments)
  (unless (reconfiguration? request)
    (error "expected a parsed reconfiguration" request))
  (append
   (list "package"
         (string-append "--profile="
                        (reconfiguration-profile-path request))
         (string-append "--manifest="
                        (reconfiguration-manifest-path request)))
   build-arguments))

(define (process-exit-code status)
  (cond
   ((status:exit-val status) => identity)
   ((status:term-sig status) => (lambda (signal) (+ 128 signal)))
   (else 1)))

(define* (run-reconfiguration request guix build-arguments
                              #:key
                              dry-run?
                              (runner system*))
  "Run REQUEST with GUIX and return its portable exit code."
  (unless dry-run?
    (mkdir-p (dirname (reconfiguration-profile-path request))))
  (process-exit-code
   (apply runner guix
          (reconfiguration-arguments request build-arguments))))

(define (require-configured-profile profile)
  (unless (configured-profile? profile)
    (error "expected a configured profile" profile))
  profile)

(define (profile-operation-arguments profile operation)
  (require-configured-profile profile)
  (list "package"
        (string-append "--profile=" (configured-profile-path profile))
        operation))

(define (generation-arguments profile pattern)
  (when (and pattern (not (string? pattern)))
    (error "expected a generation pattern string" pattern))
  (profile-operation-arguments
   profile
   (if pattern
       (string-append "--list-generations=" pattern)
       "--list-generations")))

(define (rollback-arguments profile)
  (profile-operation-arguments profile "--roll-back"))

(define* (run-guix-operation guix arguments #:key (runner system*))
  (process-exit-code (apply runner guix arguments)))
