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
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (ice-9 textual-ports)
  #:use-module (rnrs bytevectors)
  #:use-module (roquix extra-profiles paths)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:export (shell-invocation?
            shell-invocation-names
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
  (make-shell-invocation names guix-arguments)
  shell-invocation?
  (names shell-invocation-names)
  (guix-arguments shell-invocation-guix-arguments))

(define-record-type <snapshotted-shell>
  (make-snapshotted-shell profiles guix-arguments)
  snapshotted-shell?
  (profiles snapshotted-shell-profiles)
  (guix-arguments snapshotted-shell-guix-arguments))

(define (split-shell-arguments arguments)
  (call-with-values
      (lambda ()
        (break (lambda (argument) (string=? argument "--")) arguments))
    (lambda (names rest)
      (values names (if (null? rest) '() (cdr rest))))))

(define (parse-shell-arguments arguments)
  "Parse the first '--' boundary in ARGUMENTS into a <shell-invocation>."
  (call-with-values
      (lambda () (split-shell-arguments arguments))
    (lambda (raw-names guix-arguments)
      (when (null? raw-names)
        (raise-extra-profile-error 'missing-name #f #f))
      (make-shell-invocation
       (parse-profile-names raw-names)
       guix-arguments))))

(define* (snapshot-shell-invocation
          invocation
          #:key
          (profiles-root (profiles-root))
          (store-directory (%store-prefix)))
  "Resolve INVOCATION to immutable generation targets."
  (unless (shell-invocation? invocation)
    (error "expected parsed shell arguments" invocation))
  (make-snapshotted-shell
   (map (lambda (name)
          (resolve-profile name
                           #:profiles-root profiles-root
                           #:store-directory store-directory))
        (shell-invocation-names invocation))
   (shell-invocation-guix-arguments invocation)))

(define (require-snapshotted-shell snapshot)
  (unless (snapshotted-shell? snapshot)
    (error "expected a snapshotted shell invocation" snapshot))
  snapshot)

(define (snapshot-targets snapshot)
  (require-snapshotted-shell snapshot)
  (map configured-profile-generation-target
       (snapshotted-shell-profiles snapshot)))

(define (combined-manifest-content snapshot)
  (call-with-output-string
    (lambda (port)
      (display "(use-modules (guix profiles))\n\n" port)
      (display "(concatenate-manifests\n (list\n" port)
      (for-each (lambda (target)
                  (display "  (profile-manifest " port)
                  (write target port)
                  (display ")\n" port))
                (snapshot-targets snapshot))
      (display "  ))\n" port))))

(define (combined-manifest-key snapshot)
  (let* ((input (call-with-output-string
                  (lambda (port)
                    (write (cons "extra-profile-shell-manifest-v1"
                                 (snapshot-targets snapshot))
                           port))))
         (digest (bytevector-hash (string->utf8 input)
                                  (hash-algorithm sha256))))
    (bytevector->nix-base32-string digest)))

(define* (shell-manifests-directory #:key cache-root)
  (string-append
   (if cache-root
       (string-append cache-root "/guix")
       (cache-directory #:ensure? #f))
   "/extra-profile/shell-manifests"))

(define (lstat-or-false file)
  (catch 'system-error
    (lambda () (lstat file))
    (lambda args
      (if (= ENOENT (system-error-errno args))
          #f
          (apply throw args)))))

(define (ensure-private-directory directory)
  (mkdir-p (dirname directory))
  (unless (lstat-or-false directory)
    (catch 'system-error
      (lambda () (mkdir directory #o700))
      (lambda args
        ;; Concurrent creators are expected; the lstat below decides whether
        ;; the winning filesystem object is safe to use.
        (unless (= EEXIST (system-error-errno args))
          (apply throw args)))))
  (let ((metadata (lstat directory)))
    (unless (and (eq? 'directory (stat:type metadata))
                 (= (getuid) (stat:uid metadata)))
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

(define* (ensure-combined-manifest snapshot #:key cache-root)
  "Return SNAPSHOT's content-addressed manifest, creating it atomically."
  (let* ((directory (shell-manifests-directory #:cache-root cache-root))
         (content (combined-manifest-content snapshot))
         (file (string-append directory "/"
                              (combined-manifest-key snapshot) ".scm")))
    (ensure-private-directory directory)
    (let ((metadata (lstat-or-false file)))
      (cond
       ((not metadata)
        (write-cache-file file content))
       ((not (eq? 'regular (stat:type metadata)))
        (raise-extra-profile-error 'unsafe-cache-file #f file))
       ((string=? content (call-with-input-file file get-string-all))
        (chmod file #o600))
       (else
        (write-cache-file file content))))
    file))

(define (guix-shell-arguments snapshot manifest)
  (require-snapshotted-shell snapshot)
  (append (list "shell" (string-append "--manifest=" manifest))
          (snapshotted-shell-guix-arguments snapshot)))

(define* (current-guix-executable #:optional (command (car (command-line))))
  "Resolve COMMAND without looking up a possibly different Guix in PATH."
  (unless (absolute-file-name? command)
    (raise-extra-profile-error 'invalid-guix-executable #f command))
  (let ((target
         (catch 'system-error
           (lambda () (canonicalize-path command))
           (lambda args
             (raise-extra-profile-error
              'invalid-guix-executable #f command)))))
    (if (and (eq? 'regular (stat:type (stat target)))
             (access? target X_OK))
        target
        (raise-extra-profile-error 'invalid-guix-executable #f target))))

(define* (execute-snapshotted-shell snapshot
                                     #:key
                                     cache-root
                                     (guix (current-guix-executable))
                                     (executor execl))
  "Atomically replace the current process with the requested Guix shell."
  (let* ((manifest (ensure-combined-manifest snapshot
                                             #:cache-root cache-root))
         (arguments (guix-shell-arguments snapshot manifest)))
    (apply executor guix guix arguments)))
