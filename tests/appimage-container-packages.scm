(use-modules (guix build-system)
             (guix packages)
             (guix gexp)
             (guix profiles)
             (gnu packages base)
             (gnu packages fontutils)
             (roquix packages appimage-container)
             (roquix build container-launcher)
             (srfi srfi-1)
             (srfi srfi-64))

(define (argument-ref package keyword default)
  (let ((entry (memq keyword (package-arguments package))))
    (if entry (cadr entry) default)))

(define (desktop-environment name)
  (assoc-ref '(("HOME" . "/home/test")
               ("XDG_CONFIG_HOME" . "/config")
               ("XDG_DATA_HOME" . "/data")
               ("XDG_CACHE_HOME" . "/cache")
               ("XDG_RUNTIME_DIR" . "/run/user/1000")
               ("XAUTHORITY" . "/tmp/test-xauthority"))
             name))

(test-begin "appimage-container-packages")

(for-each
 (lambda (spec)
   (let* ((module (resolve-interface (car spec)))
          (payload (module-ref module (cadr spec)))
          (binding (module-variable module (caddr spec)))
          (wrapper (and binding (variable-bound? binding)
                        (variable-ref binding)))
          (executable (package-name payload)))
     (test-group executable
       (test-assert "container variant is a public package" (package? wrapper))
       (when (package? wrapper)
         (test-equal "container variant has a distinct installable name"
           (string-append executable "-container") (package-name wrapper))
         (test-eq "original AppImage is the payload"
           payload (argument-ref wrapper #:payload #f))
         (test-equal "launcher retains the original command name"
           executable (argument-ref wrapper #:executable #f))
         (test-equal "launcher uses the container build system"
           'container-launcher
           (build-system-name (package-build-system wrapper)))
         (test-assert "launcher has no separate source"
           (not (package-source wrapper)))
         (test-equal "payload release and architecture are retained"
           (list (package-version payload) (package-supported-systems payload))
           (list (package-version wrapper) (package-supported-systems wrapper)))
         (let* ((bag (package->bag wrapper "x86_64-linux"))
                (profile (cadr (assoc "runtime-profile" (bag-host-inputs bag))))
                (packages (map manifest-entry-name
                               (manifest-entries (profile-content profile)))))
           (test-assert "container has the payload, sandbox tools and fonts"
             (every (lambda (name) (member name packages))
                    (list executable (package-name coreutils-minimal) "util-linux"
                          (package-name fontconfig)
                          "font-dejavu" "font-ipa"))))
         (let ((config (assoc-ref (argument-ref wrapper #:set-environment '())
                                  "FONTCONFIG_FILE")))
           (test-assert "Fontconfig configuration is pinned to the runtime input"
             (and (file-append? config)
                  (eq? (file-append-base config) fontconfig)
                  (equal? (file-append-suffix config) '("/etc/fonts/fonts.conf")))))
         (let ((command
                (container-command-arguments
                 "/store/profile" executable
                 #:preserve-environment
                 (argument-ref wrapper #:preserve-environment '())
                 #:share (argument-ref wrapper #:share '())
                 #:expose (argument-ref wrapper #:expose '())
                 #:network? (argument-ref wrapper #:network? #f)
                 #:no-cwd? (argument-ref wrapper #:no-cwd? #t)
                 #:getenv desktop-environment)))
           (test-assert "desktop session, audio and home environment survive"
             (every (lambda (name)
                      (member (string-append "^" name "$") command))
                    '("HOME" "DISPLAY" "WAYLAND_DISPLAY" "XAUTHORITY"
                      "XDG_RUNTIME_DIR" "DBUS_SESSION_BUS_ADDRESS"
                      "PULSE_SERVER" "XDG_CONFIG_HOME" "XDG_DATA_HOME"
                      "XDG_CACHE_HOME")))
           (test-assert "home and desktop sockets are accessible"
             (every (lambda (option) (member option command))
                    '("--share=/home/test=/home/test"
                      "--share=/run/user/1000=/run/user/1000"
                      "--share=/config=/config"
                      "--share=/data=/data"
                      "--share=/cache=/cache"
                      "--expose=/tmp/test-xauthority=/tmp/test-xauthority")))
           (test-assert "network and X11 abstract sockets are available"
             (member "-N" command))
           (test-assert "working directory files remain available"
             (not (member "--no-cwd" command))))))))
 '(((roquix packages feishin) feishin feishin-container)
   ((roquix packages logseq) logseq logseq-container)
   ((roquix packages mattermost) mattermost-desktop mattermost-desktop-container)))

(test-error "non-package payload is rejected at construction" #t
  (appimage-container-package #f))

(test-error "non-AppImage payload is rejected at construction" #t
  (appimage-container-package hello))

(let ((runner (test-runner-current)))
  (test-end "appimage-container-packages")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
