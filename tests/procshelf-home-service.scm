(use-modules (guix build utils)
             (ice-9 textual-ports)
             (roquix home services procshelf)
             (roquix packages procshelf)
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

(define %user-log-dir "/tmp/procshelf-home-test/log")

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
    (car (home-procshelf-shepherd-service configuration)))))

(define (extension-value target configuration)
  (let ((extension
         (find (lambda (extension)
                 (eq? target (service-extension-target extension)))
               (service-type-extensions home-procshelf-service-type))))
    ((service-extension-compute extension) configuration)))

(test-begin "procshelf-home-service")

(let ((saved (getenv "XDG_CONFIG_HOME")))
  (dynamic-wind
    (lambda () (setenv "XDG_CONFIG_HOME" "/tmp/procshelf-home-test/config"))
    (lambda ()
      (let ((spec (start-spec (home-procshelf-configuration))))
        (test-equal "the packaged server uses the user's XDG configuration"
          (list (string-append (evaluate #~#$procshelf) "/bin/procshelf")
                "--config" "/tmp/procshelf-home-test/config/procshelf/config.toml")
          (car spec))
        (test-equal "the working directory and log belong to the user"
          (list (getenv "HOME") (string-append %user-log-dir "/procshelf.log"))
          (cdr spec)))
      (for-each
       (lambda (value)
         (if value (setenv "XDG_CONFIG_HOME" value) (unsetenv "XDG_CONFIG_HOME"))
         (test-equal "unset, empty, and relative XDG paths use ~/.config"
           (string-append (getenv "HOME") "/.config/procshelf/config.toml")
           (list-ref (car (start-spec (home-procshelf-configuration))) 2)))
       '(#f "" "relative")))
    (lambda ()
      (if saved (setenv "XDG_CONFIG_HOME" saved) (unsetenv "XDG_CONFIG_HOME")))))

(let* ((configuration (home-procshelf-configuration
                       (config-file "/tmp/processes with spaces.toml")
                       (log-file "/tmp/procshelf.log")))
       (spec (start-spec configuration)))
  (test-equal "explicit paths reach Shepherd without shell splitting"
    '("--config" "/tmp/processes with spaces.toml")
    (cdr (car spec)))
  (test-equal "a custom log file is honored" "/tmp/procshelf.log" (caddr spec)))

(test-error "store-backed configuration cannot hold adjacent runtime state" #t
  (home-procshelf-configuration
   (config-file (plain-file "config.toml" ""))))

(for-each
 (lambda (path)
   (test-error "configuration paths must be absolute" #t
     (home-procshelf-configuration (config-file path)))
   (test-error "log paths must be absolute" #t
     (home-procshelf-configuration (log-file path))))
 '("" "relative" 42))

(test-error "a store path cannot contain the adjacent key and lock" #t
  (home-procshelf-configuration (config-file "/gnu/store/config.toml")))

(let ((service (car (home-procshelf-shepherd-service (home-procshelf-configuration)))))
  (test-equal "Shepherd exposes the procshelf service" '(procshelf)
    (shepherd-service-provision service))
  (test-assert "the service starts automatically" (shepherd-service-auto-start? service))
  (test-equal "the server has time to reap managed processes before SIGKILL"
    (list SIGTERM 30) (evaluate (shepherd-service-stop service))))

(test-equal "the shutdown grace period is configurable"
  (list SIGTERM 60)
  (evaluate
   (shepherd-service-stop
    (car (home-procshelf-shepherd-service
          (home-procshelf-configuration (stop-timeout 60)))))))

(test-error "shutdown grace periods must be positive" #t
  (home-procshelf-configuration (stop-timeout 0)))

(test-equal "Home installs the selected procshelf package"
  (list procshelf)
  (extension-value home-profile-service-type (home-procshelf-configuration)))

(let* ((directory (mkdtemp "/tmp/procshelf-home-XXXXXX"))
       (saved (getenv "XDG_CONFIG_HOME"))
       (activation (extension-value home-activation-service-type
                                    (home-procshelf-configuration)))
       (file (string-append directory "/procshelf/config.toml")))
  (dynamic-wind
    (lambda () (setenv "XDG_CONFIG_HOME" directory))
    (lambda ()
      (evaluate activation)
      (test-assert "default configuration is a writable regular file"
        (and (eq? 'regular (stat:type (lstat file))) (access? file W_OK)))
      (call-with-output-file file (lambda (port) (display "# user configuration\n" port)))
      (evaluate activation)
      (test-equal "activation preserves the user's configuration"
        "# user configuration\n" (call-with-input-file file get-string-all))
      (test-assert "activation leaves access-key generation to procshelf"
        (not (file-exists? (string-append directory "/procshelf/config.procshelf.key")))))
    (lambda ()
      (if saved (setenv "XDG_CONFIG_HOME" saved) (unsetenv "XDG_CONFIG_HOME"))
      (delete-file-recursively directory))))

(let ((runner (test-runner-current)))
  (test-end "procshelf-home-service")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
