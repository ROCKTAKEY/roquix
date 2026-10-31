(define-module (roquix packages hermes python-build)
  #:use-module (guix build utils)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-1)
  #:export (prepare-python-build-environment))

(define* (prepare-python-build-environment #:key inputs #:allow-other-keys)
  ;; Guix's pure Python build backends can run under Hermes's newer interpreter;
  ;; their installed directory still carries the Guix interpreter's version.
  (setenv "HOME" (getcwd))
  (setenv "PYTHONPATH"
    (string-join
      (append-map
        (match-lambda
          ((_ . directory)
           (if (false-if-exception (file-is-directory? (string-append directory "/lib")))
               (find-files (string-append directory "/lib")
                           "^site-packages$" #:directories? #t)
               '())))
        inputs) ":")))
