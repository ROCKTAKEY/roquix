(define-module (roquix home services t3code)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (ice-9 regex)
  #:use-module (roquix packages t3code)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:export (home-t3code-configuration
            home-t3code-configuration?
            home-t3code-configuration-t3code
            home-t3code-configuration-host
            home-t3code-configuration-port
            home-t3code-configuration-data-directory
            home-t3code-configuration-working-directory
            home-t3code-configuration-log-file
            home-t3code-configuration-environment-variables
            home-t3code-shepherd-service
            home-t3code-service-type))

(define (listen-port? value)
  (and (exact-integer? value) (<= 1 value 65535)))

(define (nonempty-string? value)
  (and (string? value)
       (not (string-null? value))
       (not (string-index value #\nul))))

(define (optional-absolute-path? value)
  (or (not value)
      (and (nonempty-string? value) (string-prefix? "/" value))))

(define (environment-variable-list? value)
  (and (list? value)
       (every (lambda (entry)
                (and (nonempty-string? entry)
                     (string-match "^[A-Za-z_][A-Za-z0-9_]*=" entry)))
              value)))

(define-configuration/no-serialization home-t3code-configuration
  (t3code
   (package t3code-cli)
   "The T3 Code CLI package providing the t3 command.")
  (host
   (nonempty-string "127.0.0.1")
   "The interface on which the server listens.")
  (port
   (listen-port 3773)
   "The HTTP and WebSocket listening port.")
  (data-directory
   (optional-absolute-path #f)
   "The absolute data directory, or #f for ~/.t3.  State lives in userdata.")
  (working-directory
   (optional-absolute-path #f)
   "An existing absolute working directory, or #f for the user's home directory.")
  (log-file
   (optional-absolute-path #f)
   "An absolute log filename whose parent exists, or #f for t3code.log in
the Shepherd log directory.")
  (environment-variables
   (environment-variable-list '())
   "Environment assignments overriding inherited values."))

(define (home-t3code-environment config)
  #~(let* ((extra '#$(home-t3code-configuration-environment-variables config))
           (base (default-environment-variables))
           (names (map (lambda (entry)
                         (substring entry 0 (+ 1 (string-index entry #\=))))
                       extra)))
      (append extra
              (remove (lambda (entry)
                        (any (lambda (name) (string-prefix? name entry)) names))
                      base))))

(define (home-t3code-shepherd-service config)
  (list
   (shepherd-service
    (documentation "Run the T3 Code web server.")
    (provision '(t3code))
    (modules '((shepherd support) (srfi srfi-1) (srfi srfi-13)))
    (start
     #~(make-forkexec-constructor
        (list #$(file-append (home-t3code-configuration-t3code config) "/bin/t3")
              "serve" "--mode" "web"
              "--host" #$(home-t3code-configuration-host config)
              "--port" #$(number->string (home-t3code-configuration-port config))
              "--base-dir"
              #$(or (home-t3code-configuration-data-directory config)
                    #~(string-append (getenv "HOME") "/.t3")))
        #:directory #$(or (home-t3code-configuration-working-directory config)
                          #~(getenv "HOME"))
        #:environment-variables
        #$(home-t3code-environment config)
        #:log-file #$(or (home-t3code-configuration-log-file config)
                         #~(string-append %user-log-dir "/t3code.log"))))
    (stop #~(make-kill-destructor)))))

(define home-t3code-service-type
  (service-type
   (name 'home-t3code)
   (description "Run the T3 Code server as a user Shepherd service.")
   (extensions
    (list (service-extension home-shepherd-service-type
                             home-t3code-shepherd-service)
          (service-extension home-profile-service-type
                             (lambda (config)
                               (list (home-t3code-configuration-t3code config))))))
   (default-value (home-t3code-configuration))))
