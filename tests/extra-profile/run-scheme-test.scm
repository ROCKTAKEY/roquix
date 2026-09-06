(define-module (extra-profile run-scheme-test)
  #:declarative? #f
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-64))

(match (cdr (command-line))
  ((test-file)
   (let ((runner (test-runner-simple)))
     (test-runner-current runner)
     (load (canonicalize-path test-file))
     (exit (if (zero? (test-runner-fail-count runner)) 0 1))))
  (_ (error "expected exactly one Scheme test file")))
