(define-module (extra-profile fixtures packages)
  #:use-module (guix build-system trivial)
  #:use-module (guix gexp)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:export (fixture-profile-a
            fixture-profile-a-v2
            fixture-profile-b
            fixture-project))

(define (fixture-package name version command marker)
  (package
    (name name)
    (version version)
    (source #f)
    (build-system trivial-build-system)
    (arguments
     (list
      #:builder
      #~(begin
          (let ((bin (string-append #$output "/bin")))
            (mkdir #$output)
            (mkdir bin)
            (for-each
             (lambda (file value)
               (let ((program (string-append bin "/" file)))
                 (call-with-output-file program
                   (lambda (port)
                     (format port "#!/bin/sh~%printf '%s\\n' '~a'~%" value)))
                 (chmod program #o755)))
             (list #$command "collision")
             (list #$marker #$marker))))))
    (synopsis "Fixture command for guix extra-profile tests")
    (description "This package exists only for the extra-profile integration tests.")
    (home-page "https://github.com/ROCKTAKEY/roquix")
    (license expat)))

(define-public fixture-profile-a
  (fixture-package "fixture-profile-a" "1.0" "profile-a" "a"))

(define-public fixture-profile-a-v2
  (fixture-package "fixture-profile-a" "2.0" "profile-a" "a2"))

(define-public fixture-profile-b
  (fixture-package "fixture-profile-b" "1.0" "profile-b" "b"))

(define-public fixture-project
  (fixture-package "fixture-project" "1.0" "project-command" "project"))
