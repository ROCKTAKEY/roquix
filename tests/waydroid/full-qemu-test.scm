;;; Full Waydroid integration test for Guix System under QEMU.
;;;
;;; Build this VM with:
;;;   guix build -L channel -f tests/waydroid/full-qemu-test.scm
;;;
;;; Prefer running it through tests/waydroid/run-full-qemu-test.sh, which keeps
;;; the required TCG options and checks the serial log for PASS markers.

(use-modules (gnu)
             (gnu packages admin)
             (gnu packages bash)
             (gnu packages base)
             (gnu packages certs)
             (gnu packages curl)
             (gnu packages freedesktop)
             (gnu packages glib)
             (gnu packages linux)
             (gnu packages nss)
             (gnu packages virtualization)
             (gnu services dbus)
             (gnu services desktop)
             (gnu services networking)
             (gnu services shepherd)
             ((gnu system file-systems)
              #:select (%control-groups))
             (gnu system vm)
             (guix gexp)
             (roquix packages waydroid)
             (roquix services waydroid))

(define waydroid-full-runtime-check-service
  (simple-service
   'waydroid-full-runtime-check shepherd-root-service-type
   (list
    (shepherd-service
     (provision '(waydroid-full-runtime-check))
     (requirement '(user-processes dbus-system networking))
     (documentation "Initialize Waydroid images, start the container, and run a headless UI session.")
     (one-shot? #t)
     (start
      #~(make-forkexec-constructor
         (list #$(program-file
                  "waydroid-full-runtime-check"
                  #~(begin
                      (use-modules (ice-9 popen)
                                   (ice-9 rdelim)
                                   (srfi srfi-1))

                      (define console (open-file "/dev/console" "a"))
                      (define failures 0)
                      (define timeout #$(file-append coreutils "/bin/timeout"))
                      (define bash #$(file-append bash-minimal "/bin/sh"))
                      (define ca-certs #$(file-append nss-certs "/etc/ssl/certs"))
                      (define curl #$(file-append curl "/bin/curl"))
                      (define dbus-daemon #$(file-append dbus "/bin/dbus-daemon"))
                      (define dbus-run-session #$(file-append dbus "/bin/dbus-run-session"))
                      (define herd #$(file-append shepherd "/bin/herd"))
                      (define lxc-info #$(file-append lxc "/bin/lxc-info"))
                      (define waydroid #$(file-append waydroid "/bin/waydroid"))
                      (define weston #$(file-append weston "/bin/weston"))

                      (define (log fmt . args)
                        (display "WAYDROID-FULL-CHECK: " console)
                        (apply format console fmt args)
                        (newline console)
                        (force-output console))

                      (define (status-exit-code status)
                        (cond ((status:exit-val status) => identity)
                              ((status:term-sig status) => (lambda (sig) (+ 128 sig)))
                              (else 1)))

                      (define (note-result name ok?)
                        (log "~a: ~a" name (if ok? "PASS" "FAIL"))
                        (unless ok? (set! failures (+ failures 1))))

                      (define (run/status name args)
                        (log "RUN ~a" name)
                        (let ((status (apply system* args)))
                          (log "~a exit=~a" name (status-exit-code status))
                          status))

                      (define (run name . args)
                        (note-result name (zero? (status-exit-code
                                                  (run/status name args)))))

                      (define (run/success? name args)
                        (zero? (status-exit-code (run/status name args))))

                      (define (run-timeout seconds name . args)
                        (apply run name timeout "--foreground"
                               (number->string seconds) args))

                      (define (command-output args)
                        (let ((port (apply open-pipe* OPEN_READ args)))
                          (let loop ((line (read-line port)) (lines '()))
                            (if (eof-object? line)
                                (begin
                                  (close-pipe port)
                                  (string-join (reverse lines) "\n"))
                                (loop (read-line port) (cons line lines))))))

                      (define (lxc-state)
                        (let ((state
                               (command-output
                                (list timeout "--foreground" "60"
                                      lxc-info "-P" "/var/lib/waydroid/lxc"
                                      "-n" "waydroid" "-sH"))))
                          (log "lxc state: ~s" state)
                          state))

                      (define (wait-for-network attempts)
                        (let loop ((attempt attempts))
                          (cond
                           ((zero? attempt) #f)
                           ((run/success?
                             "network access attempt"
                             (list timeout "--foreground" "180"
                                   curl "--fail" "--location" "--max-time" "120"
                                   "--capath" ca-certs
                                   "--output" "/tmp/waydro.id.html" "https://waydro.id/"))
                            #t)
                           (else
                            (log "network not ready; retrying in 10 seconds")
                            (sleep 10)
                            (loop (- attempt 1))))))

                      (define (file-contains? file needle)
                        (and (file-exists? file)
                             (call-with-input-file file
                               (lambda (port)
                                 (let loop ((line (read-line port)))
                                   (cond ((eof-object? line) #f)
                                         ((string-contains line needle) #t)
                                         (else (loop (read-line port)))))))))

                      (define (dump-file file)
                        (when (file-exists? file)
                          (log "BEGIN ~a" file)
                          (call-with-input-file file
                            (lambda (port)
                              (let loop ((line (read-line port)) (count 0))
                                (unless (or (eof-object? line) (> count 200))
                                  (display line console)
                                  (newline console)
                                  (loop (read-line port) (+ count 1))))))
                          (log "END ~a" file)))

                      (define (run-tester-session)
                        (let* ((pw (getpwnam "tester"))
                               (uid (passwd:uid pw))
                               (gid (passwd:gid pw))
                               (runtime "/run/user/1000")
                               (home "/home/tester")
                               (script
                                (string-append
                                 "set -x; "
                                 "export XDG_RUNTIME_DIR=" runtime "; "
                                 "export HOME=" home "; "
                                 "export USER=tester; "
                                 "export LOGNAME=tester; "
                                 "export WAYDROID_WORK=/var/lib/waydroid; "
                                 "export WAYDROID_MISC_DIR=/var/lib/misc; "
                                 "export WAYLAND_DISPLAY=wayland-waydroid-test; "
                                 "export PULSE_RUNTIME_PATH=" runtime "/pulse; "
                                 "mkdir -p \"$PULSE_RUNTIME_PATH\"; "
                                 ": > \"$PULSE_RUNTIME_PATH/native\"; "
                                 weston " --backend=headless-backend.so "
                                 "--socket=wayland-waydroid-test --idle-time=0 "
                                 "--log=/tmp/weston-waydroid.log & "
                                 "WESTON_PID=$!; "
                                 "sleep 8; "
                                 timeout " --foreground 1200 " waydroid " session start & "
                                 "SESSION_PID=$!; "
                                 "LXC_STATE=; i=60; "
                                 "while [ \"$i\" -gt 0 ]; do "
                                 "if ! kill -0 \"$SESSION_PID\" 2>/dev/null; then "
                                 "wait \"$SESSION_PID\"; SESSION_STATUS=$?; "
                                 "kill \"$WESTON_PID\"; exit \"$SESSION_STATUS\"; "
                                 "fi; "
                                 "LXC_STATE=$(" lxc-info " -P /var/lib/waydroid/lxc "
                                 "-n waydroid -sH 2>&1 || true); "
                                 "echo \"LXC_STATE=$LXC_STATE\"; "
                                 "case \"$LXC_STATE\" in "
                                 "*RUNNING*|*privileges*) break;; esac; "
                                 "sleep 5; i=$((i - 1)); "
                                 "done; "
                                 "case \"$LXC_STATE\" in *RUNNING*|*privileges*) ;; "
                                 "*) kill \"$SESSION_PID\" \"$WESTON_PID\"; exit 77;; esac; "
                                 timeout " --foreground 900 " waydroid " show-full-ui; "
                                 "UI_STATUS=$?; "
                                 waydroid " session stop || true; "
                                 "kill \"$SESSION_PID\" || true; "
                                 "kill \"$WESTON_PID\" || true; "
                                 "exit \"$UI_STATUS\"")))
                          (unless (file-exists? "/run/user")
                            (mkdir "/run/user"))
                          (unless (file-exists? runtime)
                            (mkdir runtime))
                          (chown runtime uid gid)
                          (chmod runtime #o700)
                          (let ((pid (primitive-fork)))
                            (if (zero? pid)
                                (begin
                                  (setgid gid)
                                  (setuid uid)
                                  (setenv "XDG_RUNTIME_DIR" runtime)
                                  (setenv "HOME" home)
                                  (setenv "USER" "tester")
                                  (setenv "LOGNAME" "tester")
                                  (execl timeout timeout "--foreground" "1500"
                                         dbus-run-session
                                         (string-append "--dbus-daemon=" dbus-daemon)
                                         "--" bash "-c" script))
                                (let* ((status (cdr (waitpid pid)))
                                       (code (status-exit-code status)))
                                  (log "headless Wayland session exit=~a" code)
                                  (note-result "headless Wayland session and show-full-ui"
                                               (zero? code)))))))

                      (setenv "HOME" "/root")
                      (setenv "SSL_CERT_DIR" ca-certs)
                      (setenv "WAYDROID_WORK" "/var/lib/waydroid")
                      (setenv "WAYDROID_MISC_DIR" "/var/lib/misc")

                      (note-result "network access" (wait-for-network 30))
                      (note-result "kernel advertises binder filesystem"
                                   (file-contains? "/proc/filesystems" "binder"))
                      (dump-file "/proc/1/cgroup")
                      (dump-file "/sys/fs/cgroup/cgroup.controllers")
                      (run-timeout 7200 "waydroid init"
                                   waydroid "--details-to-stdout" "init" "-s" "VANILLA")
                      (note-result "system image exists"
                                   (file-exists? "/var/lib/waydroid/images/system.img"))
                      (note-result "vendor image exists"
                                   (file-exists? "/var/lib/waydroid/images/vendor.img"))
                      (run-timeout 900 "herd start waydroid-container"
                                   herd "start" "waydroid-container")
                      (run-timeout 120 "herd status waydroid-container"
                                   herd "status" "waydroid-container")
                      (run-timeout 120 "waydroid status"
                                   waydroid "status")
                      (run-tester-session)
                      (dump-file "/tmp/weston-waydroid.log")
                      (dump-file "/var/log/waydroid-container.log")
                      (dump-file "/var/lib/waydroid/waydroid.log")
                      (log "failures=~a" failures)
                      (force-output console)
                      (system* #$(file-append shepherd "/sbin/halt"))
                      (exit (if (zero? failures) 0 1)))))
         #:log-file "/dev/console"))))))

(define waydroid-full-test-os
  (operating-system
    (host-name "waydroid-full-test")
    (timezone "Etc/UTC")
    (locale "en_US.utf8")
    (bootloader (bootloader-configuration
                 (bootloader grub-bootloader)
                 (targets '("/dev/vda"))))
    (file-systems (append (list (file-system
                                  (device "/dev/vda1")
                                  (mount-point "/")
                                  (type "ext4")))
                          %control-groups
                          %base-file-systems))
    (users (cons (user-account
                  (name "tester")
                  (comment "Waydroid test user")
                  (group "users")
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "input")))
                 %base-user-accounts))
    (services
     (cons* (service dbus-root-service-type)
            (service polkit-service-type)
            (service dhcpcd-service-type)
            (service waydroid-service-type
                     (waydroid-configuration
                      (auto-start? #f)))
            waydroid-full-runtime-check-service
            %base-services))))

(virtual-machine
 (operating-system waydroid-full-test-os)
 (volatile? #f)
 (graphic? #f)
 (cpu-count 4)
 (memory-size 4096)
 (disk-image-size (* 12 (expt 2 30)))
 (port-forwardings '((10022 . 22))))
