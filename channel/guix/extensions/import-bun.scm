;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2026 ROCKTAKEY <rocktakey@gmail.com>
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.

(define-module (guix extensions import-bun)
  #:use-module (guix import bun)
  #:use-module (guix scripts)
  #:use-module (guix read-print)
  #:use-module (guix ui)
  #:use-module (guix utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-37)
  #:export (guix-import-bun))

(define %default-options '())

(define (existing-directory option value result)
  (if (file-is-directory? value)
      (alist-cons option value result)
      (leave (G_ "directory '~a' does not exist~%") value)))

(define (show-help)
  (display (G_ "Usage: guix import-bun LOCKFILE
Import a Bun lockfile as authenticated bun-lock-package origins.\n"))
  (display (G_ "
  -s, --source=DIRECTORY package source root used for a binary bun.lockb"))
  (display (G_ "
  -p, --project=DIRECTORY
                         prefix install paths with DIRECTORY"))
  (display (G_ "
  -i, --insert=FILE       update definitions in an existing module"))
  (display (G_ "
  -h, --help             display this help and exit"))
  (display (G_ "
  -V, --version          display version information and exit"))
  (newline)
  (show-bug-report-information))

(define %options
  (list
   (option '(#\i "insert") #t #f
           (lambda (option name value result)
             (if (file-exists? value)
                 (alist-cons 'file-to-insert value result)
                 (leave (G_ "file '~a' does not exist~%") value))))
   (option '(#\h "help") #f #f
           (lambda _
             (show-help)
             (exit 0)))
   (option '(#\V "version") #f #f
           (lambda _
             (show-version-and-exit "guix import-bun")))
   (option '(#\s "source") #t #f
           (lambda (option name value result)
             (existing-directory 'source value result)))
   (option '(#\p "project") #t #f
           (lambda (option name value result)
             (alist-cons 'project value result)))))

(define (arguments options)
  (filter-map (match-lambda
                (('argument . value) value)
                (_ #f))
              (reverse options)))

(define-command (guix-import-bun . args)
  (category packaging)
  (synopsis "import authenticated dependencies from a Bun lockfile")
  (let* ((options (parse-command-line args %options (list %default-options)
                                      #:build-options? #f))
         (file-to-insert (assoc-ref options 'file-to-insert)))
    (match (arguments options)
      ((lock)
       (let ((expression
              (bun-lock->expression
               lock
               #:source (assoc-ref options 'source)
               #:project (or (assoc-ref options 'project)
                             "."))))
         (if file-to-insert
             (update-bun-lock-inputs! file-to-insert expression)
             (begin
               (pretty-print-with-comments (current-output-port) expression)
               (newline)))))
      (()
       (leave (G_ "too few arguments~%")))
      (_
       (leave (G_ "too many arguments~%"))))))
