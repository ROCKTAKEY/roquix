;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2026 ROCKTAKEY <rocktakey@gmail.com>
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.

(define-module (guix import bun)
  #:use-module (gcrypt hash)
  #:use-module (guix base32)
  #:use-module (guix build utils)
  #:use-module (guix http-client)
  #:use-module (guix import bun lock)
  #:use-module ((guix import utils)
                #:select (download-git-repository))
  #:use-module (guix read-print)
  #:use-module (guix ui)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (bun-lock->expression
            bun-lock-expression->entry
            extract-bun-lock-inputs
            find-bun-lock-inputs-location
            resolve-bun-lock-hashes
            update-bun-lock-inputs!))

(define (download-git-commit url commit)
  (download-git-repository url `(commit . ,commit)))

(define* (resolve-bun-lock-hashes expression
                                  #:key
                                  (fetch-url http-fetch)
                                  (fetch-git download-git-commit))
  "Download every source marker in EXPRESSION and replace it with its hash.

HTTP source hashes are SHA-256 digests of the bytes returned by FETCH-URL.
Git source hashes are Guix nar hashes returned by FETCH-GIT.  Results are
memoized within one import so repeated lock entries do not download twice."
  (define url-hashes (make-hash-table))
  (define git-hashes (make-hash-table))

  (define (url-hash url)
    (or (hash-ref url-hashes url)
        (let ((port (fetch-url url)))
          (unless (port? port)
            (leave (G_ "failed to download Bun source '~a'~%") url))
          (let ((hash
                 (dynamic-wind
                   (const #t)
                   (lambda ()
                     (bytevector->nix-base32-string
                      (port-sha256 port)))
                   (lambda ()
                     (close-port port)))))
            (hash-set! url-hashes url hash)
            hash))))

  (define (git-hash url commit)
    (let ((key (string-append url "\0" commit)))
      (or (hash-ref git-hashes key)
          (call-with-values
              (lambda ()
                (fetch-git url commit))
            (lambda (actual-commit checkout hash)
              (unless (string=? actual-commit commit)
                (leave
                 (G_ "Git source '~a' resolved '~a' instead of '~a'~%")
                 url actual-commit commit))
              (hash-set! git-hashes key hash)
              hash)))))

  (let rewrite ((value expression))
    (match value
      (('bun-import-url-hash (? string? url))
       (url-hash url))
      (('bun-import-git-hash (? string? url) (? string? commit))
       (git-hash url commit))
      ((head . tail)
       (cons (rewrite head) (rewrite tail)))
      (_ value))))

(define* (bun-lock->expression lock
                               #:key source (project ".")
                               (fetch-url http-fetch)
                               (fetch-git download-git-commit)
                               bun-command)
  "Return an automatically named definition expression for Bun LOCK.

Text locks are parsed entirely in Guile.  Legacy binary locks realize the
channel's source-built Bun package for conversion.  Every source is downloaded
and hashed by this importer; lockfile integrity values are not used as Guix
origin hashes."
  (resolve-bun-lock-hashes
   (if bun-command
       (bun-lock-file->expression
        lock
        #:source source
        #:project project
        #:bun-command bun-command)
       (bun-lock-file->expression
        lock
        #:source source
        #:project project))
   #:fetch-url fetch-url
   #:fetch-git fetch-git))

(define (bun-lock-expression->entry expression)
  "Convert (define NAME PACKAGES) into a define-bun-lock-inputs entry."
  (match expression
    (('define (? symbol? name) _)
     `(,name => ,name))
    (_
     (leave (G_ "Bun importer produced an invalid definition~%")))))

(define (find-bun-lock-inputs-location file)
  "Return the source location of FILE's define-bun-lock-inputs table."
  (find-definition-location file 'lookup-bun-lock-inputs
                            #:define-prefix 'define-bun-lock-inputs))

(define* (extract-bun-lock-inputs file #:key exclude)
  "Return entries from FILE's define-bun-lock-inputs table except EXCLUDE."
  (call-with-input-file file
    (lambda (port)
      (let loop ((syntax (read-syntax port)))
        (match (syntax->datum syntax)
          (('define-bun-lock-inputs 'lookup-bun-lock-inputs inputs ...)
           (remove (lambda (entry)
                     (and (pair? entry)
                          (eq? exclude (first entry))))
                   inputs))
          ((? eof-object?) '())
          (_ (loop (read-syntax port))))))))

(define (entry<? left right)
  (string< (symbol->string (first left))
           (symbol->string (first right))))

(define (update-bun-lock-inputs! file expression)
  "Replace EXPRESSION's entry in FILE's define-bun-lock-inputs table."
  (let* ((entry (bun-lock-expression->entry expression))
         (name (first entry))
         (definition-location
           (find-definition-location file name #:define-prefix 'define))
         (insertion-location
          (and (not definition-location)
               (or (find-definition-insertion-location
                    file name #:define-prefix 'define)
                   (find-bun-lock-inputs-location file))))
         (_
          (cond
           (definition-location
            (edit-expression definition-location
                             (const (object->string* expression 0))))
           (insertion-location
            (insert-expression insertion-location expression))
           (else
            (let ((port (open-file file "a")))
              (pretty-print-with-comments port expression)
              (newline port)
              (newline port)
              (close-port port)))))
         (table `(define-bun-lock-inputs lookup-bun-lock-inputs
                   ,@(sort (cons entry
                                 (extract-bun-lock-inputs file
                                                          #:exclude name))
                           entry<?)))
         (location (find-bun-lock-inputs-location file)))
    (when location
      (delete-expression location))
    (let ((port (open-file file "a")))
      (pretty-print-with-comments port table)
      (newline port)
      (close-port port))))
