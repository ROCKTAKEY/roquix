(define-module (roquix build desktop-container)
  #:use-module (guix build utils)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-9)
  #:export (parse-desktop-application prepare-desktop-runtime
                                      desktop-runtime-share
                                      desktop-runtime-expose
                                      desktop-runtime-environment
                                      desktop-runtime-arguments))

(define-record-type <desktop-application>
  (%desktop-application name) desktop-application?
  (name desktop-application-name))

(define-record-type <desktop-runtime>
  (%desktop-runtime share expose environment arguments)
  desktop-runtime?
  (share desktop-runtime-share)
  (expose desktop-runtime-expose)
  (environment desktop-runtime-environment)
  (arguments desktop-runtime-arguments))

(define (parse-desktop-application name)
  (unless (and (string? name)
               (string-match "^[a-z][a-z0-9-]*$" name))
    (error "desktop application must be a lowercase application ID" name))
  (%desktop-application name))

(define (host-path value)
  (unless (and (string? value)
               (string-prefix? "/" value)
               (not (string-contains value "=")))
    (error "desktop host path must be absolute and contain no '='" value))
  value)

(define* (prepare-desktop-runtime application
                                  #:key (getenv getenv)
                                  (home-directory (passwd:dir (getpwuid (getuid))))
                                  (uid (getuid)))
  "Prepare only the application's own persistent home and display endpoint."
  (unless (desktop-application? application)
    (error "desktop runtime requires a parsed application" application))
  (let* ((home (host-path home-directory))
         (state-base (host-path (or (getenv "XDG_STATE_HOME")
                                    (string-append home "/.local/state"))))
         (state (string-append state-base "/roquix/containers/"
                               (desktop-application-name application)))
         (display (getenv "WAYLAND_DISPLAY"))
         (host-runtime (getenv "XDG_RUNTIME_DIR"))
         (socket (cond
                   ((not (and display
                              (not (string-null? display))))
                    (error
                     "a Wayland display is required for desktop isolation"))
                   ((string-prefix? "/" display)
                    (host-path display))
                   ((string-match "^[A-Za-z0-9_-]+$" display)
                    (string-append (host-path host-runtime) "/" display))
                   (else (error "invalid Wayland display name" display))))
         (socket-stat (stat socket))
         (runtime (string-append "/run/user/"
                                 (number->string uid))))
    (unless (and (eq? (stat:type socket-stat)
                      'socket)
                 (= (stat:uid socket-stat) uid))
      (error "Wayland endpoint must be a socket owned by the current user"
             socket))
    ;; The payload can alter its state contents. Never follow a state-root
    ;; symlink on the host, where it could redirect preparation into host files.
    (mkdir-p (dirname state))
    (unless (file-exists? state)
      (mkdir state #o700))
    (let ((state-stat (lstat state)))
      (unless (and (eq? (stat:type state-stat)
                        'directory)
                   (= (stat:uid state-stat) uid))
        (error
         "application state must be a directory owned by the current user"
         state)))
    (chmod state #o700)
    (%desktop-runtime (list (cons state home))
                      (list (cons socket
                                  (string-append runtime "/wayland-0")))
                      (list (cons "XDG_RUNTIME_DIR" runtime)
                            (cons "WAYLAND_DISPLAY" "wayland-0"))
                      '("--enable-features=UseOzonePlatform"
                        "--ozone-platform=wayland" "--disable-dev-shm-usage"))))
