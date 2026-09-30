;;; Copyright © 2026 ROCKTAKEY
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software: you can redistribute it and/or modify it under
;;; the terms of the GNU General Public License as published by the Free
;;; Software Foundation, either version 3 of the License, or (at your option)
;;; any later version.

(define-module (roquix extra-profiles shell)
  #:use-module (gcrypt hash)
  #:use-module (guix base32)
  #:use-module (guix build utils)
  #:use-module (guix store)
  #:use-module ((guix ui) #:select (load*))
  #:use-module (guix utils)
  #:use-module (ice-9 textual-ports)
  #:use-module (rnrs bytevectors)
  #:use-module (roquix extra-profiles paths)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:export (shell-invocation? shell-invocation-names
                              shell-invocation-guix-arguments
                              snapshotted-shell?
                              snapshotted-shell-profiles
                              snapshotted-shell-guix-arguments

                              parse-shell-arguments
                              snapshot-shell-invocation
                              combined-manifest-content
                              combined-manifest-key
                              shell-manifests-directory
                              ensure-combined-manifest
                              guix-shell-arguments
                              current-guix-executable
                              execute-snapshotted-shell))

(define-record-type <shell-invocation>
  (make-shell-invocation names guix-arguments) shell-invocation?
  (names shell-invocation-names)
  (guix-arguments shell-invocation-guix-arguments))

(define-record-type <snapshotted-shell>
  (make-snapshotted-shell profiles guix-arguments) snapshotted-shell?
  (profiles snapshotted-shell-profiles)
  (guix-arguments snapshotted-shell-guix-arguments))

(define-record-type <saved-shell-arguments>
  (make-saved-shell-arguments present? arguments) saved-shell-arguments?
  (present? saved-shell-arguments-present?)
  (arguments saved-shell-arguments-values))

(define-record-type <shell-source>
  (make-shell-source profile arguments) shell-source?
  (profile shell-source-profile)
  (arguments shell-source-arguments))

(define (split-shell-arguments arguments)
  (call-with-values (lambda ()
                      (break (lambda (argument)
                               (string=? argument "--")) arguments))
                    (lambda (names rest)
                      (values names
                              (if (null? rest)
                                  '()
                                  (cdr rest))))))

(define (parse-shell-arguments arguments)
  "Parse the first '--' boundary in ARGUMENTS into a <shell-invocation>."
  (call-with-values (lambda ()
                      (split-shell-arguments arguments))
                    (lambda (raw-names guix-arguments)
                      (when (null? raw-names)
                        (raise-extra-profile-error 'missing-name #f #f))
                      (make-shell-invocation (parse-profile-names raw-names)
                                             guix-arguments))))

(define (profile-shell-arguments name root)
  (let ((file (shell-arguments-path name
                                    #:root root)))
    (if (not (false-if-file-not-found (lstat file)))
        (make-saved-shell-arguments #f
                                    '())
        (let ((arguments (load* file
                                '())))
          (if (and (list? arguments)
                   (every string? arguments)
                   (not (member "--" arguments)))
              (make-saved-shell-arguments #t arguments)
              (raise-extra-profile-error 'invalid-shell-arguments name file))))))

(define (resolve-shell-profile name profile-root store-directory
                               definition-root saved-arguments)
  (call-with-extra-profile-error (lambda ()
                                   (resolve-profile name
                                                    #:profiles-root
                                                    profile-root
                                                    #:store-directory
                                                    store-directory))
                                 (lambda (condition)
                                   (if (and (eq? 'not-configured
                                                 (extra-profile-error-kind
                                                  condition))
                                            (saved-shell-arguments-present?
                                             saved-arguments)
                                            (not (false-if-file-not-found (lstat
                                                                           (manifest-path
                                                                            name
                                                                            #:root
                                                                            definition-root)))))
                                       #f
                                       (raise-exception condition)))))

(define (snapshot-shell-source name profile-root store-directory definition-root)
  (let ((saved (profile-shell-arguments name definition-root)))
    (make-shell-source
     (resolve-shell-profile name profile-root store-directory
                            definition-root saved)
     (saved-shell-arguments-values saved))))

(define* (snapshot-shell-invocation invocation
                                    #:key (profiles-root (profiles-root))
                                    (store-directory (%store-prefix))
                                    (definitions-root (definitions-root)))
  "Resolve INVOCATION to immutable generation targets."
  (unless (shell-invocation? invocation)
    (error "expected parsed shell arguments" invocation))
  (let ((sources (map (lambda (name)
                        (snapshot-shell-source name profiles-root
                                               store-directory definitions-root))
                      (shell-invocation-names invocation))))
    (make-snapshotted-shell
     (filter-map shell-source-profile sources)
     (append (append-map shell-source-arguments sources)
             (shell-invocation-guix-arguments invocation)))))

(define (require-snapshotted-shell snapshot)
  (unless (snapshotted-shell? snapshot)
    (error "expected a snapshotted shell invocation" snapshot)) snapshot)

(define (snapshot-targets snapshot)
  (require-snapshotted-shell snapshot)
  (map configured-profile-generation-target
       (snapshotted-shell-profiles snapshot)))

(define (combined-manifest-content snapshot)
  (let ((profiles (map (lambda (target)
                         `(profile-manifest ,target))
                       (snapshot-targets snapshot))))
    (call-with-output-string (lambda (port)
                               (write '(use-modules (guix profiles)) port)
                               (newline port)
                               (write `(concatenate-manifests (list ,@profiles))
                                      port)
                               (newline port)))))

(define (combined-manifest-key snapshot)
  (let* ((input (call-with-output-string (lambda (port)
                                           (write (cons
                                                   "extra-profile-shell-manifest-v1"
                                                   (snapshot-targets snapshot))
                                                  port))))
         (digest (bytevector-hash (string->utf8 input)
                                  (hash-algorithm sha256))))
    (bytevector->nix-base32-string digest)))

(define* (shell-manifests-directory #:key cache-root)
  (string-append (if cache-root
                     (string-append cache-root "/guix")
                     (cache-directory #:ensure? #f))
                 "/extra-profile/shell-manifests"))

(define (ensure-private-directory directory)
  (mkdir-p (dirname directory))
  (unless (false-if-file-not-found (lstat directory))
    (catch 'system-error
           (lambda ()
             (mkdir directory #o700))
           (lambda args
             ;; Concurrent creators are expected; the lstat below decides whether
             ;; the winning filesystem object is safe to use.
             (unless (= EEXIST
                        (system-error-errno args))
               (apply throw args)))))
  (let ((metadata (lstat directory)))
    (unless (and (eq? 'directory
                      (stat:type metadata))
                 (= (getuid)
                    (stat:uid metadata)))
      (raise-extra-profile-error 'unsafe-cache-directory #f directory))
    (chmod directory #o700)))

(define (write-cache-file file content)
  ;; 'with-atomic-file-output' uses mkstemp(3), so the temporary file starts
  ;; private even if another process races to create the same cache key.
  (with-atomic-file-output file
                           (lambda (port)
                             (display content port))
                           #:sync? #f)
  (chmod file #o600))

(define* (ensure-combined-manifest snapshot
                                   #:key cache-root)
  "Return SNAPSHOT's content-addressed manifest, creating it atomically."
  (let* ((directory (shell-manifests-directory #:cache-root cache-root))
         (content (combined-manifest-content snapshot))
         (file (string-append directory "/"
                              (combined-manifest-key snapshot) ".scm")))
    (ensure-private-directory directory)
    (let ((metadata (false-if-file-not-found (lstat file))))
      (cond
        ((not metadata)
         (write-cache-file file content))
        ((not (eq? 'regular
                   (stat:type metadata)))
         (raise-extra-profile-error 'unsafe-cache-file #f file))
        ((string=? content
                   (call-with-input-file file
                     get-string-all))
         (chmod file #o600))
        (else (write-cache-file file content)))) file))

(define (guix-shell-arguments snapshot manifest)
  (require-snapshotted-shell snapshot)
  (append (list "shell"
                (string-append "--manifest=" manifest))
          (snapshotted-shell-guix-arguments snapshot)))

(define* (current-guix-executable #:optional (command (car (command-line))))
  "Check COMMAND and preserve its invocation path for channel discovery."
  (unless (absolute-file-name? command)
    (raise-extra-profile-error 'invalid-guix-executable #f command))
  (let ((executable (catch 'system-error
                           (lambda ()
                             (canonicalize-path command))
                           (lambda args
                             (raise-extra-profile-error 'invalid-guix-executable
                                                        #f command)))))
    (if (and (eq? 'regular
                  (stat:type (stat executable)))
             (access? executable X_OK))
        ;; (guix describe)'s find-profile uses the invocation path to find
        ;; the channel manifest.  Executing the store target loses channels.
        ;; https://codeberg.org/guix/guix/src/branch/master/guix/describe.scm
        command
        (raise-extra-profile-error 'invalid-guix-executable #f executable))))

(define* (execute-snapshotted-shell snapshot
                                    #:key cache-root
                                    (guix (current-guix-executable))
                                    (executor execl))
  "Atomically replace the current process with the requested Guix shell."
  (let* ((manifest (ensure-combined-manifest snapshot
                                             #:cache-root cache-root))
         (arguments (guix-shell-arguments snapshot manifest)))
    (apply executor guix guix arguments)))
