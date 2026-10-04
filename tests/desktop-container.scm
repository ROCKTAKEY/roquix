(use-modules (roquix build desktop-container)
             (guix build utils)
             ((guix build syscalls) #:select (mkdtemp!))
             (srfi srfi-64))

(test-begin "desktop-container")

(test-error "application IDs cannot escape their state directory" #t
  (parse-desktop-application "../other-application"))

(let* ((root (mkdtemp! "/tmp/roquix-desktop-policy-XXXXXX"))
       (host-home (string-append root "/home"))
       (host-runtime (string-append root "/runtime"))
       (host-state (string-append root "/state"))
       (wayland (string-append host-runtime "/wayland-test"))
       (state (string-append host-state "/roquix/containers/test-app"))
       (endpoint (socket AF_UNIX SOCK_STREAM 0))
       (application (parse-desktop-application "test-app")))
  (mkdir-p host-home)
  (mkdir-p host-runtime)
  (bind endpoint AF_UNIX wayland)
  (define (host-environment name)
    (assoc-ref `(("XDG_STATE_HOME" . ,host-state)
                 ("XDG_RUNTIME_DIR" . ,host-runtime)
                 ("WAYLAND_DISPLAY" . "wayland-test")
                 ("DBUS_SESSION_BUS_ADDRESS" . "unix:path=/host/session-bus")
                 ("DISPLAY" . ":0")
                 ("PULSE_SERVER" . "unix:/host/audio")
                 ("XDG_CONFIG_HOME" . "/host/config"))
               name))
  (let ((runtime (prepare-desktop-runtime application
                                          #:getenv host-environment
                                          #:home-directory host-home)))
    (test-equal "only application state is shared read-write"
      (list (cons state host-home)) (desktop-runtime-share runtime))
    (test-equal "only the selected display socket is exposed"
      (list (cons wayland (string-append "/run/user/"
                                         (number->string (getuid))
                                         "/wayland-0")))
      (desktop-runtime-expose runtime))
    (test-equal "host session credentials and paths never enter the environment"
      '("XDG_RUNTIME_DIR" "WAYLAND_DISPLAY")
      (map car (desktop-runtime-environment runtime)))
    (test-equal "private state is accessible only by its owner"
      #o700 (logand (stat:perms (stat state)) #o777))
    (test-assert "Electron uses Wayland without disabling its sandbox"
      (and (member "--ozone-platform=wayland" (desktop-runtime-arguments runtime))
           (not (member "--no-sandbox" (desktop-runtime-arguments runtime))))))
  (test-error "missing Wayland cannot silently fall back to host X11" #t
    (prepare-desktop-runtime application #:home-directory host-home
                             #:getenv (lambda (_) #f)))
  (test-error "display traversal cannot select another host runtime socket" #t
    (prepare-desktop-runtime application #:home-directory host-home
                             #:getenv (lambda (name)
                                        (if (string=? name "WAYLAND_DISPLAY")
                                            "../bus"
                                            (host-environment name)))))
  (rmdir state)
  (symlink host-home state)
  (test-error "state-root symlinks cannot redirect host preparation" #t
    (prepare-desktop-runtime application #:getenv host-environment
                             #:home-directory host-home))
  (close endpoint)
  (delete-file-recursively root))

(let ((runner (test-runner-current)))
  (test-end "desktop-container")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
