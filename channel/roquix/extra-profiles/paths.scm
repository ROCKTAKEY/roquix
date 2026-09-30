;;; Copyright © 2026 ROCKTAKEY
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software: you can redistribute it and/or modify it under
;;; the terms of the GNU General Public License as published by the Free
;;; Software Foundation, either version 3 of the License, or (at your option)
;;; any later version.

(define-module (roquix extra-profiles paths)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:use-module (srfi srfi-14)
  #:use-module (srfi srfi-34)
  #:use-module (srfi srfi-35)
  #:export (profile-name? parse-profile-name
                          parse-profile-names
                          profile-name-value
                          profile-name=?

                          configured-profile?
                          configured-profile-name
                          configured-profile-path
                          configured-profile-generation-target

                          extra-profile-error?
                          extra-profile-error-kind
                          extra-profile-error-name
                          extra-profile-error-path
                          raise-extra-profile-error
                          call-with-extra-profile-error

                          definitions-root
                          profiles-root
                          manifest-path
                          shell-arguments-path
                          profile-path
                          resolve-profile))

(define-record-type <profile-name>
  (%make-profile-name value) profile-name?
  (value profile-name-value))

(define-record-type <configured-profile>
  (make-configured-profile name path generation-target) configured-profile?
  (name configured-profile-name)
  (path configured-profile-path)
  (generation-target configured-profile-generation-target))

(define-condition-type &extra-profile-error
                       &error
                       extra-profile-error?
                       (kind extra-profile-error-kind)
                       (name extra-profile-error-name)
                       (path extra-profile-error-path))

(define (raise-extra-profile-error kind name path)
  (raise-exception (condition (&extra-profile-error (kind kind)
                                                    (name (if (profile-name?
                                                               name)
                                                              (profile-name-value
                                                               name) name))
                                                    (path path)))))

(define (call-with-extra-profile-error thunk handler)
  "Call THUNK and pass typed extra-profile failures to HANDLER."
  (guard (failure ((extra-profile-error? failure)
                   (handler failure)))
         (thunk)))

(define %profile-name-initial-characters
  (char-set-intersection char-set:ascii char-set:letter+digit))

(define %profile-name-characters
  (char-set-union %profile-name-initial-characters
                  (string->char-set "._+-")))

(define (parse-profile-name value)
  "Parse VALUE as an extra profile name and return a <profile-name>."
  (if (and (string? value)
           (not (string-null? value))
           (char-set-contains? %profile-name-initial-characters
                               (string-ref value 0))
           (string-every %profile-name-characters value))
      (%make-profile-name value)
      (raise-extra-profile-error 'invalid-name value #f)))

(define (profile-name=? left right)
  (string=? (profile-name-value left)
            (profile-name-value right)))

(define (parse-profile-names values)
  "Parse VALUES and remove duplicates while preserving their first order."
  (delete-duplicates (map-in-order parse-profile-name values) profile-name=?))

(define (require-profile-name value)
  (unless (profile-name? value)
    (error "expected a parsed profile name" value)) value)

(define (absolute-path path)
  (if (absolute-file-name? path) path
      (string-append (getcwd) "/" path)))

(define (normalize-absolute-path path)
  ;; Avoid 'canonicalize-path' here: generation chains must be inspected one
  ;; link at a time so a cycle or broken link has a precise diagnosis.
  (let loop
    ((parts (string-split (absolute-path path) #\/))
     (result '()))
    (match parts
      (() (if (null? result) "/"
              (string-append "/"
                             (string-join (reverse result) "/"))))
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

(define (home-directory)
  (or (getenv "HOME")
      (passwd:dir (getpwuid (getuid)))))

(define (definitions-root)
  (string-append (config-directory #:ensure? #f) "/extra-profiles"))

(define (profiles-root)
  (string-append (home-directory) "/.guix-extra-profiles"))

(define (definition-file-path name root file)
  (require-profile-name name)
  (string-append (normalize-absolute-path root) "/"
                 (profile-name-value name) "/" file))

(define* (manifest-path name
                        #:key (root (definitions-root)))
  (definition-file-path name root "manifest.scm"))

(define* (shell-arguments-path name
                               #:key (root (definitions-root)))
  (definition-file-path name root "shell-arguments.scm"))

(define* (profile-path name
                       #:key (root (profiles-root)))
  (require-profile-name name)
  (let ((value (profile-name-value name)))
    (string-append (normalize-absolute-path root) "/" value "/" value)))

(define (lstat-or-false file)
  (catch 'system-error
         (lambda ()
           (lstat file))
         (lambda args
           (if (= ENOENT
                  (system-error-errno args)) #f
               (apply throw args)))))

(define (symlink-target file)
  (let ((target (readlink file)))
    (normalize-absolute-path (if (absolute-file-name? target) target
                                 (string-append (dirname file) "/" target)))))

(define (store-path? path store)
  (string-prefix? (string-append store "/") path))

(define* (resolve-profile name
                          #:key (profiles-root (profiles-root))
                          (store-directory (%store-prefix))
                          (maximum-symlinks 64))
  "Resolve NAME's current generation and return a <configured-profile>.

The returned value contains the terminal store directory, not a mutable
  profile link.  Callers that accept only <configured-profile> values therefore
cannot accidentally re-read a generation after it has been snapshotted."
  (require-profile-name name)
  (let ((profile (profile-path name
                               #:root profiles-root))
        (store (normalize-absolute-path store-directory)))
    (let loop
      ((current profile)
       (seen '())
       (depth 0))
      (when (member current seen)
        (raise-extra-profile-error 'symlink-cycle name profile))
      (let ((metadata (lstat-or-false current)))
        (cond
          ((not metadata)
           (raise-extra-profile-error (if (zero? depth)
                                          'not-configured
                                          'broken-symlink) name profile))
          ((eq? 'symlink
                (stat:type metadata))
           (when (>= depth maximum-symlinks)
             (raise-extra-profile-error 'symlink-limit name profile))
           (loop (symlink-target current)
                 (cons current seen)
                 (+ depth 1)))
          ((zero? depth)
           (raise-extra-profile-error 'invalid-profile name profile))
          ((not (eq? 'directory
                     (stat:type metadata)))
           (raise-extra-profile-error 'invalid-profile name profile))
          (else (let ((target (canonicalize-path current)))
                  (cond
                    ((not (store-path? target store))
                     (raise-extra-profile-error 'outside-store name target))
                    ((not (file-exists? (string-append target "/manifest")))
                     (raise-extra-profile-error 'missing-manifest name target))
                    (else (make-configured-profile name profile target))))))))))
