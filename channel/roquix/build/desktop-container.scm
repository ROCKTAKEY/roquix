(define-module (roquix build desktop-container)
  #:use-module (guix build utils)
  #:use-module (ice-9 regex)
  #:use-module (roquix build desktop-process)
  #:use-module (roquix build desktop-network)
  #:use-module (roquix build desktop-temporary)
  #:use-module ((guix build syscalls) #:select (mkdtemp!))
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:export (parse-desktop-application prepare-desktop-runtime
            portal-proxy-rules portal-uses-documents?
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

(define %portal-interfaces
  ;; Auxiliary resources follow each public interface's D-Bus contract.
  ;; https://flatpak.github.io/xdg-desktop-portal/docs/api-reference.html
  '((Account request documents)
    (Background request)
    (Camera request)
    (Clipboard session)
    (Documents document-service documents)
    (DynamicLauncher request)
    (Email request)
    (FileChooser request documents)
    (FileTransfer document-service documents)
    (GlobalShortcuts request session)
    (Inhibit request session)
    (InputCapture request session)
    (Location request session)
    (MemoryMonitor)
    (NetworkMonitor)
    (Notification)
    (OpenURI request)
    (PowerProfileMonitor)
    (Print request)
    (ProxyResolver)
    (RemoteDesktop request session)
    (ScreenCast request session)
    (Screenshot request documents)
    (Secret request)
    (Settings)
    (Trash)
    (Usb request session)
    (Wallpaper request)
    (experimental.Credential request)))

(define (portal-uses-documents? permissions)
  (any (lambda (name) (memq 'documents (assq-ref %portal-interfaces name)))
       permissions))

(define (portal-proxy-rules permissions)
  (define desktop "org.freedesktop.portal.Desktop")
  (define root "/org/freedesktop/portal/desktop")
  (define (rule flag service member path)
    (string-append flag "=" service "=" member "@" path))
  (define (interface-rules name)
    (let ((features (assq-ref %portal-interfaces name)))
      (unless features (error "unsupported desktop portal interface" name))
      (let* ((document-service? (memq 'document-service features))
             (service (if document-service? "org.freedesktop.portal.Documents" desktop))
             (path (if document-service? "/org/freedesktop/portal/documents" root))
             (members (string-append "org.freedesktop.portal." (symbol->string name) ".*")))
        (append
         (list (rule "--call" service members path)
               (rule "--broadcast" service members path)
               (rule "--call" service "org.freedesktop.DBus.Properties.Get" path)
               (rule "--call" service "org.freedesktop.DBus.Properties.GetAll" path)
               (rule "--broadcast" service "org.freedesktop.DBus.Properties.PropertiesChanged" path))
         (if (memq 'request features)
             (list (rule "--call" desktop "org.freedesktop.portal.Request.Close"
                         (string-append root "/request/*"))
                   (rule "--broadcast" desktop "org.freedesktop.portal.Request.Response"
                         (string-append root "/request/*")))
             '())
         (if (memq 'session features)
             (list (rule "--call" desktop "org.freedesktop.portal.Session.Close"
                         (string-append root "/session/*"))
                   (rule "--broadcast" desktop "org.freedesktop.portal.Session.Closed"
                         (string-append root "/session/*")))
             '())))))
  (unless (list? permissions)
    (error "desktop-portals must be a list of permission names" permissions))
  (delete-duplicates (append-map interface-rules permissions)))

(define (call-with-portal application runtime tools directory procedure)
  (let* ((proxy (car tools))
         (bwrap (cadr tools))
         (gdbus (caddr tools))
         (rules (cadddr tools))
         (usb? (list-ref tools 4))
         (network? (list-ref tools 5))
         (app-id (string-append "org.roquix.Container."
                                (desktop-application-name application)))
         (host-runtime (host-path (getenv "XDG_RUNTIME_DIR")))
         (address (or (getenv "DBUS_SESSION_BUS_ADDRESS")
                      (string-append "unix:path=" host-runtime "/bus")))
         (socket (string-append directory "/portal-bus"))
         (target (assoc-ref (desktop-runtime-environment runtime) "XDG_RUNTIME_DIR"))
         (bus (string-append target "/bus"))
         (mount-point (string-append host-runtime "/doc"))
         (documents (string-append mount-point "/by-app/" app-id))
         (instances (string-append host-runtime "/.flatpak")))
    (when gdbus
      (with-output-to-file "/dev/null"
        (lambda ()
          (invoke gdbus "call" "--session" "--timeout" "10"
                  "--dest" "org.freedesktop.portal.Documents"
                  "--object-path" "/org/freedesktop/portal/documents"
                  "--method" "org.freedesktop.portal.Documents.GetMountPoint")))
      (unless (file-is-directory? documents)
        (error "application document portal mount unavailable" documents)))
    (mkdir-p instances)
    (let* ((instance (mkdtemp! (string-append instances "/roquix-XXXXXX")))
           (info (string-append instance "/info")))
      (dynamic-wind
        (lambda () #t)
        (lambda ()
          ;; The portal identifies the D-Bus peer by its process root. Give
          ;; the proxy a read-only identity and publish its actual child PID.
          (call-with-output-file info
            (lambda (port)
              (format port "[Application]~%name=~a~%[Instance]~%instance-id=~a~%"
                      app-id (basename instance))
              (when network?
                (format port "[Context]~%shared=network;~%"))
              (when usb?
                (format port "[USB Devices]~%enumerable-devices=all;~%"))))
          (call-with-child
           (append (list bwrap "--die-with-parent" "--unshare-pid" "--ro-bind" "/gnu/store" "/gnu/store"
                 "--ro-bind" "/etc" "/etc" "--ro-bind" "/tmp" "/tmp"
                 "--ro-bind" host-runtime host-runtime "--dev" "/dev"
                 "--bind" directory directory "--ro-bind" info "/.flatpak-info"
                 "--info-fd" "3" "--" proxy address socket "--filter")
                   rules)
           #f
           (lambda (pid wait)
             (wait-for-ready wait (lambda () (file-exists? socket)) "portal proxy")
             (procedure
              (%desktop-runtime
               (if gdbus
                   (cons (cons documents mount-point) (desktop-runtime-share runtime))
                   (desktop-runtime-share runtime))
               (cons* (cons socket bus) (cons info "/.flatpak-info")
                      (desktop-runtime-expose runtime))
               (append (list (cons "DBUS_SESSION_BUS_ADDRESS" (string-append "unix:path=" bus))
                             (cons "GTK_USE_PORTAL" "1"))
                       (desktop-runtime-environment runtime))
               (desktop-runtime-arguments runtime)
               (desktop-runtime-network runtime))))
           #:ready-file (string-append instance "/bwrapinfo.json")))
        (lambda () (delete-file-recursively instance))))))

(define* (call-with-private-desktop-runtime application compositor procedure
                                          #:key audio-daemon portal-tools (network? #f)
                                          (temporary-directory "/var/tmp"))
  (call-with-desktop-temporary-directory
   (parse-temporary-base temporary-directory)
   (lambda (temporary)
     (call-with-private-desktop-services
      application compositor
      (lambda (runtime)
        (procedure
         (%desktop-runtime
          (cons (cons temporary "/tmp") (desktop-runtime-share runtime))
          (desktop-runtime-expose runtime)
          (desktop-runtime-environment runtime)
          (desktop-runtime-arguments runtime)
          (desktop-runtime-network runtime))))
      #:audio-daemon audio-daemon #:portal-tools portal-tools #:network? network?))))

(define* (call-with-private-desktop-services application compositor procedure
                                           #:key audio-daemon portal-tools (network? #f))
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
             (define (launch runtime)
               (if portal-tools
                   (call-with-portal application runtime portal-tools directory procedure)
                   (procedure runtime)))
             (if audio
                 (call-with-private-playback private audio audio-daemon directory launch)
                 (launch private))))))
      (lambda ()
        (for-each (lambda (handler)
                    (sigaction (car handler) (car (cdr handler))
                               (cdr (cdr handler))))
                  handlers)
        (delete-file-recursively directory)))))
