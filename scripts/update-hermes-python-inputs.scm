;; Run with guix repl -L channel -- SCRIPT UV.LOCK REQUIREMENTS.TXT.
;; Standard importer output is a draft: review build/native inputs and the
;; CPython 3.14 dependency markers before incorporating it into python.scm.
(use-modules (roquix packages hermes python-import)
             (ice-9 match)
             (ice-9 popen)
             (ice-9 pretty-print)
             (json))

(match (command-line)
  ((_ lock requirements)
   (let* ((bridge (search-path %load-path
                               "roquix/packages/hermes/python-lock.py"))
          (port (open-pipe* OPEN_READ "python3" bridge lock requirements))
          (pins (dynamic-wind (lambda ()
                                #t)
                              (lambda ()
                                (map parse-python-pin
                                     (vector->list (json->scm port))))
                              (lambda ()
                                (unless (zero? (close-pipe port))
                                  (error
                                   "cannot read locked Python requirements"))))))
     (define failed?
       #f)
     (for-each (lambda (pin)
                 (format (current-error-port) "Importing ~a@~a~%"
                         (python-pin-name pin)
                         (python-pin-version pin))
                 (catch #t
                        (lambda ()
                          (pretty-print `(define-public ,(string->symbol (string-append
                                                                          "hermes-python-"
                                                                          (python-pin-name
                                                                           pin)))
                                           ,(import-python-pin pin)))
                          (newline))
                        (lambda (key . args)
                          (set! failed? #t)
                          (format (current-error-port)
                                  "Import failed for ~a: ~s ~s~%"
                                  (python-pin-name pin) key args)))) pins)
     (exit (not failed?))))
  (_ (error "usage: update-hermes-python-inputs.scm UV.LOCK REQUIREMENTS.TXT")))
