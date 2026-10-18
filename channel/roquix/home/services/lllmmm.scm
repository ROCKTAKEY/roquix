(define-module (roquix home services lllmmm)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (roquix packages lllmmm)
  #:use-module (srfi srfi-13)
  #:export (home-lllmmm-configuration
            home-lllmmm-configuration?
            home-lllmmm-configuration-lllmmm
            home-lllmmm-configuration-config-file
            home-lllmmm-configuration-log-file
            home-lllmmm-configuration-stop-timeout
            home-lllmmm-shepherd-service
            home-lllmmm-service-type))

(define (absolute-path? value)
  (and (string? value)
       (string-prefix? "/" value)
       (not (string-index value #\nul))))

(define (optional-absolute-path? value)
  (or (not value) (absolute-path? value)))

(define (optional-config-file? value)
  (or (optional-absolute-path? value) (file-like? value)))

(define (positive-integer? value)
  (and (exact-integer? value) (positive? value)))

(define-configuration/no-serialization home-lllmmm-configuration
  (lllmmm
   (package lllmmm)
   "The package providing the lllmmm server.")
  (config-file
   (optional-config-file #f)
   "An absolute TOML filename or file-like object, or #f for
$XDG_CONFIG_HOME/lllmmm/lllmmm.toml, falling back to ~/.config/lllmmm/lllmmm.toml.
The file must configure at least one model.  Relative model and state paths
resolve against the configuration file's directory; store-backed configuration
must specify an absolute writable state_dir and absolute model paths.")
  (log-file
   (optional-absolute-path #f)
   "An absolute log filename whose parent exists, or #f for lllmmm.log in
the Shepherd log directory.")
  (stop-timeout
   (positive-integer 30)
   "Seconds Shepherd allows for graceful shutdown before SIGKILL.  Allow more
than the TOML shutdown_timeout_secs plus the server's five-second HTTP drain
margin so lllmmm can reap its backend process groups."))

(define (home-lllmmm-shepherd-service config)
  (list
   (shepherd-service
    (documentation "Run the lllmmm local model server.")
    (provision '(lllmmm))
    (modules '((shepherd support) (srfi srfi-13)))
    (start
     #~(make-forkexec-constructor
        (list #$(file-append (home-lllmmm-configuration-lllmmm config)
                            "/bin/lllmmm")
              "--config"
              #$(or (home-lllmmm-configuration-config-file config)
                    #~(let ((xdg (getenv "XDG_CONFIG_HOME")))
                        (string-append
                         (if (and xdg (string-prefix? "/" xdg))
                             xdg
                             (string-append (getenv "HOME") "/.config"))
                         "/lllmmm/lllmmm.toml")))
              "serve")
        #:directory (getenv "HOME")
        #:log-file #$(or (home-lllmmm-configuration-log-file config)
                         #~(string-append %user-log-dir "/lllmmm.log"))))
    (stop #~(make-kill-destructor
             #:grace-period #$(home-lllmmm-configuration-stop-timeout config))))))

(define home-lllmmm-service-type
  (service-type
   (name 'home-lllmmm)
   (description
    "Run lllmmm as a user Shepherd service using an existing TOML configuration.
Backend executables must be on the service's PATH or specified by absolute path
in the TOML file.  Backend-specific environment variables belong in models.env.")
   (extensions
    (list (service-extension home-shepherd-service-type
                             home-lllmmm-shepherd-service)
          (service-extension home-profile-service-type
                             (lambda (config)
                               (list (home-lllmmm-configuration-lllmmm config))))))
   (default-value (home-lllmmm-configuration))))
