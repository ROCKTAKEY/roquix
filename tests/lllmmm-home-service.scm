(use-modules (roquix home services lllmmm)
             (roquix packages lllmmm)
             (gnu home services)
             (gnu services)
             (gnu services shepherd)
             (guix gexp)
             (guix monads)
             (guix store)
             (srfi srfi-1)
             (srfi srfi-64))

(define* (make-forkexec-constructor command #:key directory log-file)
  (list command directory log-file))

(define %user-log-dir "/tmp/lllmmm-home-test/log")

(define* (make-kill-destructor #:optional (signal SIGTERM) #:key grace-period)
  (list signal grace-period))

(define (evaluate expression)
  (with-store store
    (eval (lowered-gexp-sexp
           (run-with-store store (lower-gexp expression #:graft? #f)))
          (current-module))))

(define (start-spec configuration)
  (evaluate
   (shepherd-service-start
    (car (home-lllmmm-shepherd-service configuration)))))

(test-begin "lllmmm-home-service")

(let ((saved (getenv "XDG_CONFIG_HOME")))
  (dynamic-wind
    (lambda () (setenv "XDG_CONFIG_HOME" "/tmp/lllmmm-home-test/config"))
    (lambda ()
      (let ((spec (start-spec (home-lllmmm-configuration))))
        (test-equal "the packaged server uses the user's XDG configuration"
          (list (string-append (evaluate #~#$lllmmm) "/bin/lllmmm")
                "--config" "/tmp/lllmmm-home-test/config/lllmmm/lllmmm.toml"
                "serve")
          (car spec))
        (test-equal "the working directory and log belong to the user"
          (list (getenv "HOME") (string-append %user-log-dir "/lllmmm.log"))
          (cdr spec)))
      (for-each
       (lambda (value)
         (if value (setenv "XDG_CONFIG_HOME" value) (unsetenv "XDG_CONFIG_HOME"))
         (test-equal "unset, empty, and relative XDG paths use ~/.config"
           (string-append (getenv "HOME") "/.config/lllmmm/lllmmm.toml")
           (list-ref (car (start-spec (home-lllmmm-configuration))) 2)))
       '(#f "" "relative")))
    (lambda ()
      (if saved (setenv "XDG_CONFIG_HOME" saved) (unsetenv "XDG_CONFIG_HOME")))))

(let* ((configuration (home-lllmmm-configuration
                       (config-file "/tmp/models with spaces.toml")
                       (log-file "/tmp/models.log")))
       (spec (start-spec configuration)))
  (test-equal "explicit paths reach Shepherd without shell splitting"
    '("--config" "/tmp/models with spaces.toml" "serve")
    (cdr (car spec)))
  (test-equal "a custom log file is honored" "/tmp/models.log" (caddr spec)))

(let* ((file (plain-file "lllmmm-test.toml" "listen = '127.0.0.1:19100'\n"))
       (spec (start-spec (home-lllmmm-configuration (config-file file)))))
  (test-equal "declarative file-like configuration is lowered to the store"
    (evaluate #~#$file) (list-ref (car spec) 2)))

(for-each
 (lambda (path)
   (test-error "configuration paths must be absolute or file-like" #t
     (home-lllmmm-configuration (config-file path)))
   (test-error "log paths must be absolute" #t
     (home-lllmmm-configuration (log-file path))))
 '("" "relative" 42))

(let ((service (car (home-lllmmm-shepherd-service (home-lllmmm-configuration)))))
  (test-equal "Shepherd exposes the lllmmm service" '(lllmmm)
    (shepherd-service-provision service))
  (test-assert "the service starts automatically" (shepherd-service-auto-start? service))
  (test-equal "the server has time to shut down its backends before SIGKILL"
    (list SIGTERM 30) (evaluate (shepherd-service-stop service))))

(test-equal "the shutdown grace period is configurable"
  (list SIGTERM 60)
  (evaluate
   (shepherd-service-stop
    (car (home-lllmmm-shepherd-service
          (home-lllmmm-configuration (stop-timeout 60)))))))

(test-error "shutdown grace periods must be positive" #t
  (home-lllmmm-configuration (stop-timeout 0)))

(let ((extension
       (find (lambda (extension)
               (eq? home-profile-service-type (service-extension-target extension)))
             (service-type-extensions home-lllmmm-service-type))))
  (test-equal "Home installs the selected lllmmm package"
    (list lllmmm)
    ((service-extension-compute extension) (home-lllmmm-configuration))))

(let ((runner (test-runner-current)))
  (test-end "lllmmm-home-service")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
