(define-module (roquix build desktop-container)
  #:use-module (guix build utils)
  #:use-module (ice-9 regex)
  #:use-module (roquix build desktop-process)
  #:use-module (roquix build desktop-network)
  #:use-module ((guix build syscalls) #:select (mkdtemp!))
  #:use-module (srfi srfi-9)
  #:export (parse-desktop-application prepare-desktop-runtime
            parse-playback-endpoint
            call-with-private-desktop-runtime run-desktop-command
            desktop-runtime-share desktop-runtime-expose
            desktop-runtime-environment desktop-runtime-arguments
            desktop-runtime-network))

(define-record-type <desktop-application>
  (%desktop-application name) desktop-application?
  (name desktop-application-name))

(define-record-type <desktop-runtime>
  (%desktop-runtime share expose environment arguments network)
  desktop-runtime?
  (share desktop-runtime-share)
  (expose desktop-runtime-expose)
  (environment desktop-runtime-environment)
  (arguments desktop-runtime-arguments)
  (network desktop-runtime-network))

(define-record-type <playback-endpoint>
  (%playback-endpoint socket) playback-endpoint?
  (socket playback-endpoint-socket))

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

(define* (parse-playback-endpoint server #:key (uid (getuid)))
  (unless (and (string? server) (string-prefix? "unix:/" server))
    (error "playback requires a local PulseAudio Unix socket" server))
  (let* ((socket (host-path (substring server 5)))
         (info (stat socket)))
    ;; The endpoint becomes a PulseAudio module argument, so reject token and
    ;; line delimiters before constructing the private server configuration.
    (when (string-match "[[:space:]\"\\\\]" socket)
      (error "invalid playback socket path" socket))
    (unless (and (eq? (stat:type info) 'socket) (= (stat:uid info) uid))
      (error "playback endpoint must be a socket owned by the current user" socket))
    (%playback-endpoint socket)))

(define (selected-playback-endpoint)
  (let ((configured (getenv "PULSE_SERVER"))
        (runtime (getenv "XDG_RUNTIME_DIR")))
    (cond
     (configured (parse-playback-endpoint configured))
     ((and runtime (file-exists? (string-append runtime "/pulse/native")))
      (parse-playback-endpoint (string-append "unix:" runtime "/pulse/native")))
     (else #f))))

(define (selected-wayland-socket getenv uid)
  (let* ((display (getenv "WAYLAND_DISPLAY"))
         (socket (cond
                  ((not (and display (not (string-null? display))))
                   (error "a Wayland display is required for desktop isolation"))
                  ((string-prefix? "/" display) (host-path display))
                  ((string-match "^[A-Za-z0-9_-]+$" display)
                   (string-append (host-path (getenv "XDG_RUNTIME_DIR"))
                                  "/" display))
                  (else (error "invalid Wayland display name" display))))
         (info (stat socket)))
    (unless (and (eq? (stat:type info) 'socket) (= (stat:uid info) uid))
      (error "Wayland endpoint must be a socket owned by the current user" socket))
    socket))

(define (application-state-directory application home getenv uid)
  (let* ((base (host-path (or (getenv "XDG_STATE_HOME")
                             (string-append home "/.local/state"))))
         (state (string-append base "/roquix/containers/"
                               (desktop-application-name application))))
    ;; The payload can alter its state contents. Never follow a state-root
    ;; symlink on the host, where it could redirect preparation into host files.
    (mkdir-p (dirname state))
    (unless (file-exists? state)
      (mkdir state #o700))
    (let ((info (lstat state)))
      (unless (and (eq? (stat:type info) 'directory) (= (stat:uid info) uid))
        (error "application state must be a directory owned by the current user"
               state)))
    (chmod state #o700)
    state))

(define* (prepare-desktop-runtime application
                                  #:key (getenv getenv)
                                  (home-directory (passwd:dir (getpwuid (getuid))))
                                  (uid (getuid)))
  "Prepare only the application's own persistent home and display endpoint."
  (unless (desktop-application? application)
    (error "desktop runtime requires a parsed application" application))
  (let* ((home (host-path home-directory))
         (socket (selected-wayland-socket getenv uid))
         (state (application-state-directory application home getenv uid))
         (runtime (string-append "/run/user/" (number->string uid))))
    ;; Mapping a single socket avoids granting access to other session services.
    ;; https://wayland.freedesktop.org/docs/book/Protocol.html#wire-format
    (%desktop-runtime
     (list (cons state home))
     (list (cons socket (string-append runtime "/wayland-0")))
     (list (cons "XDG_RUNTIME_DIR" runtime)
           (cons "WAYLAND_DISPLAY" "wayland-0"))
     '("--enable-features=UseOzonePlatform" "--ozone-platform=wayland"
       "--disable-dev-shm-usage") #f)))

(define (run-desktop-command command)
  "Wait for the container and terminate its process group on interruption."
  (call-with-child command #f
    (lambda (pid wait) (wait-for-child wait))))

(define (call-with-private-playback runtime endpoint daemon directory procedure)
  (let* ((config (string-append directory "/audio.pa"))
         (socket (string-append directory "/pulse-native"))
         (target (string-append (assoc-ref (desktop-runtime-environment runtime)
                                          "XDG_RUNTIME_DIR") "/pulse/native")))
    ;; A host PulseAudio socket also permits recording and controlling other
    ;; clients. Only the trusted tunnel connects to it; the payload's server
    ;; has one playback sink and forbids replacing modules after startup.
    ;; https://www.freedesktop.org/wiki/Software/PulseAudio/Documentation/User/Modules/#module-tunnel-sink-new
    (call-with-output-file config
      (lambda (port)
        (format port "load-module module-native-protocol-unix socket=~a auth-anonymous=1~%"
                socket)
        (format port "load-module module-tunnel-sink-new server=unix:~a sink_name=playback~%"
                (playback-endpoint-socket endpoint))
        (newline port)))
    (call-with-child
     (list daemon "--daemonize=no" "--use-pid-file=no" "--exit-idle-time=-1"
           "--disallow-module-loading=yes" "--disallow-exit=yes"
           "--high-priority=no" "--realtime=no" "--disable-shm=yes"
           "--enable-memfd=no" "--log-target=stderr" "-n"
           (string-append "--file=" config))
     (list (string-append "HOME=" directory)
           (string-append "XDG_RUNTIME_DIR=" directory)
           (string-append "PULSE_CONFIG_PATH=" directory))
     (lambda (pid wait)
       (wait-for-ready wait (lambda () (file-exists? socket)) "playback server")
       (procedure
        (%desktop-runtime
         (desktop-runtime-share runtime)
         (cons (cons socket target) (desktop-runtime-expose runtime))
         (cons (cons "PULSE_SERVER" (string-append "unix:" target))
               (desktop-runtime-environment runtime))
         (desktop-runtime-arguments runtime)
         (desktop-runtime-network runtime)))))))

(define* (call-with-private-desktop-runtime application compositor procedure
                                          #:key audio-daemon (network? #f))
  "Run PROCEDURE with a compositor that exposes only this application's desktop."
  (let* ((runtime (prepare-desktop-runtime application))
         (host-display (car (car (desktop-runtime-expose runtime))))
         (audio (and audio-daemon (selected-playback-endpoint)))
         (directory (mkdtemp! "/tmp/roquix-private-display-XXXXXX"))
         (socket (string-append directory "/wayland-0"))
         (network (and network? (prepare-desktop-network directory)))
         (handlers (map (lambda (signal)
                          (cons signal
                                (sigaction signal
                                           (lambda (signal)
                                             (throw 'desktop-interrupted signal)))))
                        (list SIGINT SIGTERM))))
    (dynamic-wind
      (lambda () #t)
      (lambda ()
        ;; This trusted compositor connects to the host, while the payload sees
        ;; only its private socket. Kiosk mode and --no-config avoid executing
        ;; user desktop launchers or bridging the host clipboard/session bus.
        ;; https://wayland.pages.freedesktop.org/weston/toc/running-weston.html
        (call-with-child
         (list compositor "--backend=wayland" "--renderer=pixman"
               "--shell=kiosk" "--socket=wayland-0" "--no-config"
               "--idle-time=0" (string-append "--log=" directory "/weston.log"))
         (list (string-append "HOME=" directory)
               (string-append "XDG_RUNTIME_DIR=" directory)
               (string-append "WAYLAND_DISPLAY=" host-display))
         (lambda (pid wait)
           (wait-for-ready wait (lambda () (file-exists? socket)) "Wayland compositor")
           (let ((private
                  (%desktop-runtime
                   (desktop-runtime-share runtime)
                   (append (if network (desktop-network-expose network) '())
                           (list (cons socket (cdr (car (desktop-runtime-expose runtime))))))
                   (desktop-runtime-environment runtime)
                   (desktop-runtime-arguments runtime) network)))
             (if audio
                 (call-with-private-playback private audio audio-daemon directory procedure)
                 (procedure private))))))
      (lambda ()
        (for-each (lambda (handler)
                    (sigaction (car handler) (car (cdr handler))
                               (cdr (cdr handler))))
                  handlers)
        (delete-file-recursively directory)))))
