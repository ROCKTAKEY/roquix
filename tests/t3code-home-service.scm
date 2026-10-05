(use-modules (roquix home services t3code)
             (roquix packages t3code)
             (gnu home services)
             (gnu services)
             (gnu services shepherd)
             (guix gexp)
             (guix monads)
             (guix store)
             (srfi srfi-1)
             (srfi srfi-13)
             (srfi srfi-64))

(define default-environment-variables
  (make-parameter '("PATH=/providers/bin" "SHELL=/chosen/shell"
                    "KEEP=kept")))

(define* (make-forkexec-constructor command
                                    #:key environment-variables directory log-file)
  `((command . ,command)
    (environment . ,environment-variables)
    (directory . ,directory)
    (log-file . ,log-file)))

(define %user-log-dir "/tmp/t3code-home-test/log")

(define (evaluate expression)
  (with-store store
    (eval (lowered-gexp-sexp
           (run-with-store store (lower-gexp expression #:graft? #f)))
          (current-module))))

(define (start-spec configuration)
  (evaluate
   (shepherd-service-start
    (car (home-t3code-shepherd-service configuration)))))

(test-begin "t3code-home-service")

(test-equal "the default server listens on loopback"
  "127.0.0.1"
  (home-t3code-configuration-host (home-t3code-configuration)))

(test-equal "the default server port is 3773"
  3773
  (home-t3code-configuration-port (home-t3code-configuration)))

(for-each
 (lambda (port)
   (test-error "a configuration rejects an invalid listening port" #t
     (home-t3code-configuration (port port))))
 '(0 65536 3773.0 "3773"))

(test-error "the listening host must be nonempty" #t
  (home-t3code-configuration (host "")))

(test-error "state paths must be absolute" #t
  (home-t3code-configuration (data-directory "relative")))

(test-error "environment entries must be assignments" #t
  (home-t3code-configuration (environment-variables '("INVALID"))))

(let* ((services (home-t3code-shepherd-service (home-t3code-configuration)))
       (spec (start-spec (home-t3code-configuration)))
       (package (evaluate #~#$t3code-cli)))
  (test-equal "Shepherd manages one automatically started t3code service"
    '((t3code))
    (map shepherd-service-provision services))
  (test-assert "the server starts automatically"
    (every shepherd-service-auto-start? services))
  (test-equal "the packaged backend runs in web serve mode with explicit paths"
    (list (string-append package "/bin/t3")
          "serve" "--mode" "web" "--host" "127.0.0.1" "--port" "3773"
          "--base-dir" (string-append (getenv "HOME") "/.t3"))
    (assoc-ref spec 'command))
  (test-equal "provider sessions start in the user's home directory"
    (getenv "HOME")
    (assoc-ref spec 'directory))
  (test-equal "server output goes to the user Shepherd log directory"
    (string-append %user-log-dir "/t3code.log")
    (assoc-ref spec 'log-file))
  (let ((environment (assoc-ref spec 'environment)))
    (test-assert "the provider PATH and chosen shell remain available"
      (and (member "SHELL=/chosen/shell" environment)
           (any (lambda (entry)
                  (and (string-prefix? "PATH=" entry)
                       (string=? "PATH=/providers/bin" entry)))
                environment)
           (member "KEEP=kept" environment)))))

(let* ((spec (start-spec
              (home-t3code-configuration
               (host "0.0.0.0")
               (port 4773)
               (data-directory "/tmp/t3-data")
               (working-directory "/tmp/projects")
               (log-file "/tmp/t3.log")
               (environment-variables
                '("SHELL=/custom/shell" "PATH=/custom/bin" "KEEP=override")))))
       (environment (assoc-ref spec 'environment)))
  (test-equal "custom network and storage settings reach the server"
    '("serve" "--mode" "web" "--host" "0.0.0.0" "--port" "4773"
      "--base-dir" "/tmp/t3-data")
    (drop (assoc-ref spec 'command) 1))
  (test-equal "custom working and log directories reach Shepherd"
    '("/tmp/projects" "/tmp/t3.log")
    (list (assoc-ref spec 'directory) (assoc-ref spec 'log-file)))
  (test-equal "explicit environment entries replace inherited assignments"
    '("SHELL=/custom/shell" "KEEP=override")
    (filter (lambda (entry)
              (or (string-prefix? "SHELL=" entry)
                  (string-prefix? "KEEP=" entry)))
            environment))
  (test-equal "the CLI launcher receives the custom provider PATH"
    '("PATH=/custom/bin")
    (filter (lambda (entry) (string-prefix? "PATH=" entry)) environment)))

(let* ((extensions (service-type-extensions home-t3code-service-type))
       (extension
        (find (lambda (extension)
                (eq? home-profile-service-type
                     (service-extension-target extension)))
              extensions)))
  (test-equal "the selected T3 Code package is installed in the Home profile"
    (list t3code-cli)
    ((service-extension-compute extension) (home-t3code-configuration))))

(let ((runner (test-runner-current)))
  (test-end "t3code-home-service")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
