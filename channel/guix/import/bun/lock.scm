;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2026 ROCKTAKEY <rocktakey@gmail.com>
;;;
;;; This file is part of roquix.
;;;
;;; roquix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.

(define-module (guix import bun lock)
  #:use-module (guix base64)
  #:use-module (guix build syscalls)
  #:use-module (guix build utils)
  #:use-module (guix derivations)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix store)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (json)
  #:use-module (web uri)
  #:use-module (roquix build bun-build-system jsonc)
  #:use-module (rnrs bytevectors)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:use-module (srfi srfi-13)
  #:export (bun-lock-definition-name
            bun-lock-file->expression
            parse-bun-lock
            render-bun-lock-definition
            wyhash))

(define %u64-mask #xffffffffffffffff)
(define %wyhash-secret
  (vector #xa0761d6478bd642f
          #xe7037ed1a0b428db
          #x8ebc6af09c88c6e3
          #x589965cc75374cc3))

(define (u64 value)
  (logand value %u64-mask))

(define (u64-xor . values)
  (u64 (apply logxor values)))

(define (multiply-128 left right)
  (let ((product (* (u64 left) (u64 right))))
    (values (u64 product)
            (u64 (ash product -64)))))

(define (wyhash-mix left right)
  (call-with-values
      (lambda ()
        (multiply-128 left right))
    u64-xor))

(define (read-little-endian bytes start length)
  (let loop ((index 0)
             (result 0))
    (if (= index length)
        (u64 result)
        (loop (+ index 1)
              (+ result
                 (ash (bytevector-u8-ref bytes (+ start index))
                      (* index 8)))))))

(define (wyhash-small-key bytes length)
  (cond
   ((>= length 4)
    (let* ((end (- length 4))
           (quarter (* (ash length -3) 4)))
      (values
       (u64 (+ (ash (read-little-endian bytes 0 4) 32)
               (read-little-endian bytes quarter 4)))
       (u64 (+ (ash (read-little-endian bytes end 4) 32)
               (read-little-endian bytes (- end quarter) 4))))))
   ((> length 0)
    (values (+ (ash (bytevector-u8-ref bytes 0) 16)
               (ash (bytevector-u8-ref bytes (ash length -1)) 8)
               (bytevector-u8-ref bytes (- length 1)))
            0))
   (else
    (values 0 0))))

(define (wyhash-round bytes offset states)
  (let ((next (vector-copy states)))
    (do ((index 0 (+ index 1)))
        ((= index 3) next)
      (let ((left
             (read-little-endian bytes
                                 (+ offset (* 16 index))
                                 8))
            (right
             (read-little-endian bytes
                                 (+ offset (* 16 index) 8)
                                 8)))
        (vector-set!
         next index
         (wyhash-mix
          (u64-xor left
                   (vector-ref %wyhash-secret (+ index 1)))
          (u64-xor right
                   (vector-ref states index))))))))

(define (wyhash-final2 a b state length)
  (let ((a (u64-xor a (vector-ref %wyhash-secret 1)))
        (b (u64-xor b state)))
    (call-with-values
        (lambda ()
          (multiply-128 a b))
      (lambda (low high)
        (wyhash-mix
         (u64-xor low
                  (vector-ref %wyhash-secret 0)
                  length)
         (u64-xor high
                  (vector-ref %wyhash-secret 1)))))))

(define* (wyhash value #:optional (seed 0))
  "Return Zig/Bun-compatible Wyhash of the UTF-8 string VALUE."
  (let* ((bytes (string->utf8 value))
         (length (bytevector-length bytes))
         (initial
          (u64-xor seed
                   (wyhash-mix
                    (u64-xor seed (vector-ref %wyhash-secret 0))
                    (vector-ref %wyhash-secret 1)))))
    (if (<= length 16)
        (call-with-values
            (lambda ()
              (wyhash-small-key bytes length))
          (lambda (a b)
            (wyhash-final2 a b initial length)))
        (let loop ((offset 0)
                   (states (vector initial initial initial)))
          (if (and (>= length 48)
                   (< (+ offset 48) length))
              (loop (+ offset 48)
                    (wyhash-round bytes offset states))
              (let* ((state
                      (if (>= length 48)
                          (u64-xor (vector-ref states 0)
                                   (vector-ref states 1)
                                   (vector-ref states 2))
                          (vector-ref states 0)))
                     (state
                      (let final1 ((index offset)
                                   (state state))
                        (if (< (+ index 16) length)
                            (final1
                             (+ index 16)
                             (wyhash-mix
                              (u64-xor
                               (read-little-endian bytes index 8)
                               (vector-ref %wyhash-secret 1))
                              (u64-xor
                               (read-little-endian bytes (+ index 8) 8)
                               state)))
                            state)))
                     (a (read-little-endian bytes (- length 16) 8))
                     (b (read-little-endian bytes (- length 8) 8)))
                (wyhash-final2 a b state length)))))))

(define-record-type <locked-npm-package>
  (make-locked-npm-package kind name version url owner repository commit
                           source-key cache-directory install-paths)
  locked-npm-package?
  (kind locked-npm-package-kind)
  (name locked-npm-package-name)
  (version locked-npm-package-version)
  (url locked-npm-package-url)
  (owner locked-npm-package-owner)
  (repository locked-npm-package-repository)
  (commit locked-npm-package-commit)
  (source-key locked-npm-package-source-key)
  (cache-directory locked-npm-package-cache-directory)
  (install-paths locked-npm-package-install-paths))

(define (locked-package-with-install-paths package paths)
  (make-locked-npm-package
   (locked-npm-package-kind package)
   (locked-npm-package-name package)
   (locked-npm-package-version package)
   (locked-npm-package-url package)
   (locked-npm-package-owner package)
   (locked-npm-package-repository package)
   (locked-npm-package-commit package)
   (locked-npm-package-source-key package)
   (locked-npm-package-cache-directory package)
   paths))

(define (json-object value context)
  (unless (and (list? value)
               (every (lambda (entry)
                        (and (pair? entry)
                             (string? (car entry))))
                      value))
    (error (string-append context " must be an object") value))
  value)

(define (npm-package-name value)
  (unless (and (string? value)
               (string-match "^(@[^/@]+/[^/@]+|[^/@]+)$" value))
    (error "invalid npm package name" value))
  value)

(define (npm-package-version value)
  (unless (and (string? value)
               (string-match
                "^[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9A-Za-z.-]+)?(\\+[0-9A-Za-z.-]+)?$"
                value))
    (error "invalid npm package version" value))
  value)

(define (validate-sha512-integrity value key)
  (unless (and (string? value)
               (string-prefix? "sha512-" value)
               (let ((decoded
                      (false-if-exception
                       (base64-decode
                        (string-drop value
                                     (string-length "sha512-"))))))
                 (and (bytevector? decoded)
                      (= (bytevector-length decoded) 64))))
    (error "invalid SHA-512 integrity" key)))

(define (lockfile-version value)
  (unless (or (equal? value 0)
              (equal? value 1))
    (error "unsupported Bun lockfile version" value))
  value)

(define (project-directory value)
  (unless (and (string? value)
               (or (string=? value ".")
                   (and (not (string-null? value))
                        (not (string-prefix? "/" value))
                        (every (lambda (component)
                                 (not (member component
                                              '("" "." ".."))))
                               (string-split value #\/)))))
    (error "invalid project directory" value))
  value)

(define (split-resolution resolution)
  (let ((match
         (and (string? resolution)
              (string-match "^(@[^/]+/[^@]+|[^@]+)@(.+)$"
                            resolution))))
    (unless match
      (error "invalid Bun lock resolution" resolution))
    (values (npm-package-name (match:substring match 1))
            (match:substring match 2))))

(define (registry-tarball-url name version)
  (let ((basename
         (if (string-prefix? "@" name)
             (substring name (+ (string-index name #\/) 1))
             name)))
    (string-append "https://registry.npmjs.org/"
                   name "/-/" basename "-" version ".tgz")))

(define (registry-cache-directory name version url)
  (let ((host (uri-host (string->uri url))))
    (if (or (string-prefix? "@" name)
            (not (string=? host "registry.npmjs.org")))
        (string-append name "@" version "@@" host "@@@1")
        (string-append name "@" version "@@@1"))))

(define (locked-registry-url name version items)
  (let ((url (and (pair? (cdr items)) (cadr items))))
    (unless (string? url)
      (error "invalid registry URL in Bun lock" name url))
    (if (string-null? url)
        (registry-tarball-url name version)
        (let ((uri (string->uri url)))
          (unless (and uri (memq (uri-scheme uri) '(http https))
                       (uri-host uri))
            (error "invalid registry URL in Bun lock" name url))
          url))))

(define (remote-tarball-cache-directory url)
  (string-append "@T@" (number->string (wyhash url) 16) "@@@1"))

(define (parse-github-spec value)
  (let ((match
         (and (string? value)
              (string-match
               "^github:([^/#]+)/([^/#]+)#([0-9a-f]{40})$"
               value))))
    (and match
         `((owner . ,(match:substring match 1))
           (repository . ,(match:substring match 2))
           (commit . ,(match:substring match 3))
           (source-key . ,value)))))

(define (add-github-dependencies dependencies context result)
  (fold
   (lambda (dependency result)
     (let ((parsed (parse-github-spec (cdr dependency))))
       (if (not parsed)
           result
           (let* ((name
                   (npm-package-name (car dependency)))
                  (previous (assoc name result)))
             (when (and previous
                        (not
                         (string=?
                          (assoc-ref (cdr previous) 'source-key)
                          (assoc-ref parsed 'source-key))))
               (error "conflicting GitHub sources" name))
             (acons name parsed
                    (alist-delete name result string=?))))))
   result
   (json-object dependencies context)))

(define (github-specs workspaces-value)
  (let ((workspaces
         (json-object workspaces-value "Bun lockfile workspaces")))
    (fold
     (lambda (workspace-entry result)
       (let* ((workspace-name (car workspace-entry))
              (workspace
               (json-object (cdr workspace-entry)
                            (string-append "workspace "
                                           workspace-name))))
         (fold
          (lambda (field result)
            (match (assoc field workspace)
              (#f result)
              ((_ . dependencies)
               (add-github-dependencies
                dependencies
                (string-append "workspace "
                               workspace-name " " field)
                result))))
          result
          '("dependencies" "devDependencies"
            "optionalDependencies"))))
     '()
     workspaces)))

(define (workspace-directories workspaces-value)
  (let ((workspaces
         (json-object workspaces-value "Bun lockfile workspaces")))
    (fold
     (lambda (entry result)
       (let ((directory (car entry)))
         (if (member directory '("" "."))
             result
             (let* ((workspace
                     (json-object (cdr entry)
                                  (string-append "workspace "
                                                 directory)))
                    (name-value (assoc-ref workspace "name")))
               (if (not name-value)
                   result
                   (let ((name (npm-package-name name-value)))
                     (when (assoc name result)
                       (error "duplicate Bun workspace name" name))
                     (acons name
                            (project-directory directory)
                            result)))))))
     '()
     workspaces)))

(define (last-matching predicate values)
  (find predicate (reverse values)))

(define (parse-github-package key resolution name specifier items
                              github-by-name)
  (let* ((short
          (string-match
           "^github:([^/#]+)/([^/#]+)#([0-9a-f]{7,40})$"
           specifier))
         (full-entry (assoc name github-by-name))
         (full (and full-entry (cdr full-entry))))
    (unless
        (and short full
             (string=?
              (match:substring short 1)
              (assoc-ref full 'owner))
             (string=?
              (match:substring short 2)
              (assoc-ref full 'repository))
             (string-prefix?
              (match:substring short 3)
              (assoc-ref full 'commit)))
      (error "missing full GitHub commit" resolution))
    (let ((resolved
           (last-matching
            (lambda (item)
              (and (string? item)
                   (not (string=? item resolution))
                   (not (string-prefix? "sha512-" item))))
            items)))
      (unless (and resolved
                   (string-match "^[0-9A-Za-z._-]+$" resolved))
        (error "invalid GitHub cache key" key))
      (make-locked-npm-package
       'github name #f
       (string-append "https://github.com/"
                      (assoc-ref full 'owner) "/"
                      (assoc-ref full 'repository))
       (assoc-ref full 'owner)
       (assoc-ref full 'repository)
       (assoc-ref full 'commit)
       (assoc-ref full 'source-key)
       (string-append "@GH@" resolved "@@@1")
       '()))))

(define (parse-git-package name specifier items)
  (let ((match (string-match "^git\\+(.+)#([0-9a-f]{40})$" specifier)))
    (unless match
      (error "generic Git dependency requires a full commit" specifier))
    (let* ((url (match:substring match 1))
           (commit (match:substring match 2))
           (uri (string->uri url)))
      (unless (and uri (memq (uri-scheme uri) '(http https ssh git))
                   (uri-host uri)
                   (>= (length items) 3)
                   (equal? (list-ref items 2) commit))
        (error "invalid pinned Git resolution" specifier))
      (make-locked-npm-package
       'git name #f url #f
       (basename (uri-path uri) ".git") commit specifier
       (string-append "@G@" commit) '()))))

(define (parse-fetched-package key resolution name specifier items)
  (let ((integrity
         (last-matching
          (lambda (item)
            (and (string? item)
                 (string-prefix? "sha512-" item)))
          items)))
    (validate-sha512-integrity integrity key)
    (if (or (string-prefix? "https://" specifier)
            (string-prefix? "http://" specifier))
        (make-locked-npm-package
         'remote-tarball name #f specifier
         #f #f #f #f
         (remote-tarball-cache-directory specifier)
         '())
        (begin
          (unless (string-match
                   "^[0-9]+\\.[0-9]+\\.[0-9]+"
                   specifier)
            (error "unsupported Bun lock resolution" resolution))
          (let* ((version (npm-package-version specifier))
                 (url (locked-registry-url name version items)))
            (make-locked-npm-package
             'registry name version
             url
             #f #f #f #f
             (registry-cache-directory name version url)
             '()))))))

(define (parse-package key value github-by-name)
  (unless (and (vector? value)
               (> (vector-length value) 0)
               (string? (vector-ref value 0)))
    (error "invalid Bun lock package entry" key))
  (let ((resolution (vector-ref value 0))
        (items (vector->list value)))
    (if (string-contains resolution "@workspace:")
        #f
        (call-with-values
            (lambda ()
              (split-resolution resolution))
          (lambda (name specifier)
            (cond
             ((string-prefix? "github:" specifier)
              (parse-github-package key resolution name specifier
                                    items github-by-name))
             ((string-prefix? "git+" specifier)
              (parse-git-package name specifier items))
             (else
              (parse-fetched-package key resolution name specifier
                                     items))))))))

(define (locked-git-package? package)
  (memq (locked-npm-package-kind package) '(github git)))

(define (package-identity package)
  (if (locked-git-package? package)
      (locked-npm-package-source-key package)
      (locked-npm-package-url package)))

(define (longest-prefix-entry value table)
  "Return the longest slash-delimited prefix of VALUE found in TABLE."
  (let loop ((index (- (string-length value) 1)))
    (cond
     ((negative? index) #f)
     ((char=? (string-ref value index) #\/)
      (let* ((key (substring value 0 index))
             (entry (hash-ref table key)))
        (if entry
            (cons key entry)
            (loop (- index 1)))))
     (else
      (loop (- index 1))))))

(define (workspace-install-path key workspaces)
  (match (longest-prefix-entry key workspaces)
    ((name . directory)
     (string-append directory "/node_modules/"
                    (string-drop key
                                 (+ (string-length name) 1))))
    (#f
     (string-append "node_modules/" key))))

(define (install-path key project packages workspaces memo)
  (or (hash-ref memo key)
      (let* ((parent-entry
              (longest-prefix-entry key packages))
             (parent (and parent-entry
                          (car parent-entry)))
             (relative
              (if parent
                  (string-append
                   (install-path parent project packages
                                 workspaces memo)
                   "/node_modules/"
                   (string-drop key
                                (+ (string-length parent) 1)))
                  (workspace-install-path key workspaces)))
             (result
              (if (or parent
                      (string=? project "."))
                  relative
                  (string-append project "/" relative))))
        (hash-set! memo key result)
        result)))

(define* (parse-bun-lock value #:optional (project-value "."))
  "Parse a Bun text lockfile Scheme VALUE without executing Bun."
  (let* ((lock (json-object value "Bun lockfile"))
         (_ (lockfile-version (assoc-ref lock "lockfileVersion")))
         (project (project-directory project-value))
         (workspaces-value
          (or (assoc-ref lock "workspaces") '()))
         (github-by-name (github-specs workspaces-value))
         (directories-by-workspace
          (workspace-directories workspaces-value))
         (packages
          (json-object (or (assoc-ref lock "packages") '())
                       "Bun lockfile packages"))
         (packages-by-key
          (filter-map
           (lambda (entry)
             (let ((package
                    (parse-package (car entry)
                                   (cdr entry)
                                   github-by-name)))
               (and package
                    (cons (car entry) package))))
           packages))
         (packages-table
          (make-hash-table))
         (workspaces-table
          (make-hash-table))
         (memo (make-hash-table))
         (unique (make-hash-table)))
    (for-each
     (lambda (entry)
       (hash-set! packages-table (car entry) (cdr entry)))
     packages-by-key)
    (for-each
     (lambda (entry)
       (hash-set! workspaces-table (car entry) (cdr entry)))
     directories-by-workspace)
    (for-each
     (lambda (entry)
       (let* ((key (car entry))
              (package (cdr entry))
              (path
               (install-path key project packages-table
                             workspaces-table memo))
              (identity (package-identity package))
              (previous (hash-ref unique identity))
              (paths
               (cons path
                     (if previous
                         (locked-npm-package-install-paths previous)
                         '()))))
         (hash-set!
          unique identity
          (locked-package-with-install-paths package paths))))
     packages-by-key)
    (sort
     (hash-map->list
      (lambda (_ package)
        (locked-package-with-install-paths
         package
         (sort
          (delete-duplicates
           (locked-npm-package-install-paths package)
           string=?)
          string<?)))
      unique)
          (lambda (left right)
            (or (string<?
                 (locked-npm-package-name left)
                 (locked-npm-package-name right))
                (and
                 (string=?
                  (locked-npm-package-name left)
                  (locked-npm-package-name right))
                 (string<?
                  (package-identity left)
                  (package-identity right))))))))

(define (source-file-name package)
  (let ((name
         (string-map
          (lambda (character)
            (if (char=? character #\/)
                #\-
                character))
          (string-trim
           (locked-npm-package-name package)
           (lambda (character)
             (char=? character #\@))))))
    (case (locked-npm-package-kind package)
      ((registry)
       (string-append "npm-" name "-"
                      (locked-npm-package-version package)
                      ".tgz"))
      ((github git)
       (string-append name "-"
                      (locked-npm-package-commit package)
                      "-checkout"))
      (else
       (string-append "npm-" name "-remote.tgz")))))

(define (locked-package->expression package)
  (let ((kind (locked-npm-package-kind package))
        (name (locked-npm-package-name package))
        (cache (locked-npm-package-cache-directory package))
        (paths (locked-npm-package-install-paths package)))
    (if (locked-git-package? package)
        (let* ((repository
                (locked-npm-package-repository package))
               (commit (locked-npm-package-commit package))
               (url (locked-npm-package-url package)))
          `(bun-lock-package
            (name ,name)
            (version ,(substring commit 0 7))
            (cache-directory ,cache)
            (install-paths (quote ,paths))
            (source-kind (quote directory))
            (source
             (origin
              (method git-fetch)
              (uri
               (git-reference
                (url ,url)
                (commit ,commit)))
              (file-name
               (git-file-name ,repository ,commit))
              (sha256
               (base32
                (bun-import-git-hash ,url ,commit)))))))
        (let ((url (locked-npm-package-url package)))
          `(bun-lock-package
            (name ,name)
            (version
             ,(if (eq? kind 'registry)
                  (locked-npm-package-version package)
                  "remote"))
            (cache-directory ,cache)
            (install-paths (quote ,paths))
            (source
             (origin
              (method url-fetch)
              (uri ,url)
              (file-name ,(source-file-name package))
              (sha256
               (base32
                (bun-import-url-hash ,url))))))))))

(define (npm-name->guix-fragment name)
  (let* ((unscoped
          (if (string-prefix? "@" name)
              (string-drop name 1)
              name))
         (normalized
          (string-map
           (lambda (character)
             (if (or (char=? character #\/)
                     (char=? character #\_))
                 #\-
                 (char-downcase character)))
           unscoped)))
    (unless (string-match "^[a-z0-9][a-z0-9+.-]*$"
                          normalized)
      (error "package name cannot form a Guix definition"
             name))
    normalized))

(define (source-root-directory lock project source)
  (if source
      (canonicalize-path source)
      (let loop ((directory
                  (canonicalize-path (dirname lock)))
                 (components
                  (if (string=? project ".")
                      '()
                      (string-split project #\/))))
        (if (null? components)
            directory
            (loop (dirname directory)
                  (cdr components))))))

(define (read-jsonc-file file)
  (call-with-input-file file jsonc->scm))

(define (file-regexp-submatch file regexp)
  (and (file-exists? file)
       (let* ((contents
               (call-with-input-file file get-string-all))
              (match
               (string-match regexp contents)))
         (and match
              (match:substring match 1)))))

(define (bun-source-version directory)
  "Return Bun's release version recorded in its source tree, if any.

Older Bun releases left package.json at 0.0.0 or omitted its version.
Their build system nevertheless records the actual release version in
CMakeLists.txt.  Bun 1.0.0 through 1.0.7 instead formed 1.0.PATCH from
src/build-id."
  (or
   (file-regexp-submatch
    (string-append directory "/CMakeLists.txt")
    "set\\([[:space:]]*Bun_VERSION[[:space:]]+\"([^\"]+)\"")
   (let* ((global
           (string-append directory "/src/__global.zig"))
          (build-id
           (string-append directory "/src/build-id"))
          (major
           (file-regexp-submatch
            global
            "\\.major[[:space:]]*=[[:space:]]*([0-9]+)"))
          (minor
           (file-regexp-submatch
            global
            "\\.minor[[:space:]]*=[[:space:]]*([0-9]+)")))
     (and major
          minor
          (file-exists? build-id)
          (string-append
           major "." minor "."
           (string-trim-both
            (call-with-input-file build-id get-string-all)))))))

(define (workspace-package-version directory manifest package-name)
  "Return a unique workspace version for PACKAGE-NAME, if one exists."
  (let* ((patterns
          (map workspace-pattern->regexp
               (manifest-workspace-patterns manifest)))
         (versions
          (delete-duplicates
           (filter-map
            (lambda (file)
              (let ((relative
                     (string-drop file
                                  (+ (string-length directory) 1))))
                (and
                 (any (lambda (pattern)
                        (regexp-exec pattern relative))
                      patterns)
                 (let* ((workspace
                         (json-object
                          (read-jsonc-file file)
                          relative))
                        (name (assoc-ref workspace "name"))
                        (version (assoc-ref workspace "version")))
                   (and (string? name)
                        (string=? name package-name)
                        (string? version)
                        version)))))
            (find-files directory "package\\.json$"))
           string=?)))
    (match versions
      (() #f)
      ((version) version)
      (_
       (error "workspace packages matching the root name have conflicting versions"
              package-name
              versions)))))

(define (package-identity-from-manifest directory)
  (let* ((manifest-file
          (string-append directory "/package.json"))
         (manifest
          (json-object (read-jsonc-file manifest-file)
                       "package.json"))
         (name (assoc-ref manifest "name"))
         (manifest-version (assoc-ref manifest "version")))
    (unless (string? name)
      (error "package.json must contain a package name"
             manifest-file))
    (let ((version
           (or (and (string=? name "bun")
                    (bun-source-version directory))
               (and (string? manifest-version)
                    manifest-version)
               (workspace-package-version
                directory manifest name))))
      (unless version
        (error "package version is absent from root and matching workspaces"
               manifest-file))
      (values (npm-name->guix-fragment name)
              version))))

(define* (bun-lock-definition-name lock
                                   #:key
                                   (project ".")
                                   source)
  "Derive the generated definition name from package metadata.

The root package name and version form the base.  For a monorepo lock,
PROJECT's basename is appended to distinguish independent lockfiles."
  (let* ((project (project-directory project))
         (root
          (source-root-directory lock project source))
         (suffix
          (if (string=? project ".")
              ""
              (string-append
               "-"
               (npm-name->guix-fragment (basename project))))))
    (call-with-values
        (lambda ()
          (package-identity-from-manifest root))
      (lambda (name version)
        (string->symbol
         (string-append "%" name "-" version suffix
                        "-npm-inputs"))))))

(define (workspace-pattern->regexp pattern)
  (let* ((pattern
          (if (string-prefix? "./" pattern)
              (string-drop pattern 2)
              pattern))
         (pattern
          (string-trim-right pattern #\/))
         (length (string-length pattern)))
    (make-regexp
     (string-append
      "^"
      (call-with-output-string
       (lambda (port)
         (let loop ((index 0))
           (when (< index length)
             (let ((character (string-ref pattern index)))
               (cond
                ((char=? character #\*)
                 (if (and (< (+ index 1) length)
                          (char=? (string-ref pattern (+ index 1))
                                  #\*))
                     (begin
                       (display ".*" port)
                       (loop (+ index 2)))
                     (begin
                       (display "[^/]*" port)
                       (loop (+ index 1)))))
                ((char=? character #\?)
                 (display "[^/]" port)
                 (loop (+ index 1)))
                ((string-index ".+()[]{}^$|\\" character)
                 (write-char #\\ port)
                 (write-char character port)
                 (loop (+ index 1)))
                (else
                 (write-char character port)
                 (loop (+ index 1)))))))))
      "/package\\.json$"))))

(define (manifest-workspace-patterns manifest)
  (let ((value (assoc-ref manifest "workspaces")))
    (cond
     ((not value) '())
     ((vector? value) (vector->list value))
     ((list? value)
      (let ((packages (assoc-ref value "packages")))
        (if (vector? packages)
            (vector->list packages)
            (error "package.json workspaces packages must be an array"))))
     (else
      (error "package.json workspaces must be an array or object")))))

(define (write-json-file file value)
  (call-with-output-file file
    (lambda (port)
      (scm->json value port #:pretty #t)
      (newline port))))

(define (copy-binary-workspace-manifests source temporary manifest)
  (let ((patterns
         (map workspace-pattern->regexp
              (manifest-workspace-patterns manifest))))
    (unless (null? patterns)
      (for-each
       (lambda (file)
         (let ((relative
                (string-drop file
                             (+ (string-length source) 1))))
           (when (any (lambda (pattern)
                        (regexp-exec pattern relative))
                      patterns)
             (let* ((workspace
                     (json-object (read-jsonc-file file)
                                  relative))
                    (name (assoc-ref workspace "name"))
                    (version (assoc-ref workspace "version"))
                    (destination
                     (string-append temporary "/" relative)))
               (unless (string? name)
                 (error "workspace package.json must contain a name"
                        relative))
               (mkdir-p (dirname destination))
               (write-json-file
                destination
                `(("name" . ,name)
                  ,@(if (string? version)
                        `(("version" . ,version))
                        '())
                  ("private" . #t)))))))
       (find-files source "package\\.json$")))))

(define %bun-command
  (delay
    (let ((package
           (module-ref
            (resolve-interface '(roquix packages bun))
            'bun)))
      (with-store store
        (run-with-store store
          (mlet* %store-monad
              ((drv (lower-object package))
               (built (built-derivations (list drv))))
            (return
             (string-append
              (derivation->output-path drv)
              "/bin/bun"))))))))

(define (built-bun-command)
  (force %bun-command))

(define* (convert-binary-lock lock source project
                              #:key
                              (bun-command built-bun-command))
  (let* ((project-source
          (if (string=? project ".")
              source
              (string-append source "/" project)))
         (manifest-file
          (string-append project-source "/package.json"))
         (manifest
          (json-object (read-jsonc-file manifest-file)
                       "package.json"))
         (temporary
          (mkdtemp!
           (string-copy
            (string-append
             (or (getenv "TMPDIR") "/tmp")
             "/bun-lock-conversion.XXXXXX")))))
    (dynamic-wind
      (const #t)
      (lambda ()
        (write-json-file
         (string-append temporary "/package.json")
         manifest)
        (copy-binary-workspace-manifests
         project-source temporary manifest)
        (copy-file lock
                   (string-append temporary "/bun.lockb"))
        (unless
            (zero?
             (system* (bun-command)
                      "install"
                      "--save-text-lockfile"
                      "--lockfile-only"
                      "--ignore-scripts"
                      "--cwd"
                      temporary))
          (error "bun.lockb conversion failed" lock))
        (read-jsonc-file
         (string-append temporary "/bun.lock")))
      (lambda ()
        (delete-file-recursively temporary)))))

(define (render-bun-lock-definition name packages)
  `(define ,name
     (list ,@(map locked-package->expression packages))))

(define* (bun-lock-file->expression lock
                                    #:key
                                    (project ".")
                                    source
                                    (bun-command built-bun-command))
  "Parse LOCK and return its generated Scheme definition.

Text bun.lock files are parsed entirely in Guile.  Bun is realized and
executed only when LOCK is the legacy binary bun.lockb format."
  (let* ((project (project-directory project))
         (source
          (source-root-directory lock project source))
         (value
          (if (string=? (basename lock) "bun.lockb")
              (convert-binary-lock lock source project
                                   #:bun-command bun-command)
              (read-jsonc-file lock)))
         (name
          (bun-lock-definition-name lock
                                    #:project project
                                    #:source source)))
    (render-bun-lock-definition
     name
     (parse-bun-lock value project))))
