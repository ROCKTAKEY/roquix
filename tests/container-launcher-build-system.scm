(use-modules (roquix build container-launcher)
             (roquix build-system container-launcher)
             (guix build utils)
             ((guix build syscalls) #:select (mkdtemp!))
             (guix build-system)
             (guix packages)
             (gnu packages base)
             (rnrs io ports)
             (srfi srfi-64))

(test-begin "container-launcher-build-system")

(test-equal "wrapper package uses its own build system"
  'container-launcher
  (build-system-name container-launcher-build-system))

(let ((bag ((build-system-lower container-launcher-build-system)
            "hello-container"
            #:payload hello
            #:executable "hello"
            #:inputs '()
            #:native-inputs '()
            #:outputs '("out")
            #:system "x86_64-linux"
            #:target #f)))
  (test-equal "payload, profile, and launcher are pinned build inputs"
    '("payload" "runtime-profile" "launcher")
    (map car (bag-host-inputs bag))))

(test-equal "explicit environment and mounts become separate arguments"
  '("shell" "-q" "--pure" "-C" "--profile=/store/profile" "--no-cwd"
    "-N" "-F" "-E" "^DISPLAY$" "-E" "APP_MODE=compact"
    "--share=/tmp/host path=/inside path"
    "--expose=/run/user/1000=/run/user/1000"
    "--" "/store/profile/bin/app" "file with spaces")
  (container-command-arguments
   "/store/profile" "app"
   #:preserve-environment '("DISPLAY")
   #:set-environment '(("APP_MODE" . "compact"))
   #:share '(("/tmp/host path" . "/inside path"))
   #:expose '(((environment "XDG_RUNTIME_DIR")
               . "/run/user/1000"))
   #:network? #t
   #:emulate-fhs? #t
   #:arguments '("file with spaces")
   #:getenv (lambda (name)
              (and (string=? name "XDG_RUNTIME_DIR") "/run/user/1000"))))

(test-equal "missing optional environment mount is omitted"
  '("shell" "-q" "--pure" "-C" "--profile=/store/profile" "--no-cwd"
    "--" "/store/profile/bin/app")
  (container-command-arguments
   "/store/profile" "app"
   #:share '((environment "XDG_RUNTIME_DIR"))
   #:getenv (lambda (_) #f)))

(test-equal "desktop launcher and actions use the wrapper"
  '("Exec=/store/wrapper/bin/app --open %U"
    "TryExec=/store/wrapper/bin/app"
    "DBusActivatable=false"
    "Icon=app"
    "MimeType=text/plain;")
  (map (lambda (line)
         (rewrite-desktop-line line "/store/wrapper/bin/app"))
       '("Exec=/old/app --open %U"
         "TryExec=/old/app"
         "DBusActivatable=true"
         "Icon=app"
         "MimeType=text/plain;")))

(let* ((root (mkdtemp! "/tmp/roquix-container-launcher-XXXXXX"))
       (payload (string-append root "/payload"))
       (output (string-append root "/output"))
       (applications (string-append payload "/share/applications"))
       (desktop-file (string-append applications "/app.desktop"))
       (installed-desktop
        (string-append output "/share/applications/app.desktop")))
  (mkdir-p applications)
  (mkdir-p (string-append payload "/share/icons"))
  (call-with-output-file desktop-file
    (lambda (port)
      (display "[Desktop Entry]\nExec=/old/app %U\n" port)
      (display "[Desktop Action NewWindow]\nExec=/old/app --new\n" port)
      (display "Icon=app\n" port)))
  (install-desktop-metadata payload output "app")
  (test-equal "installed desktop actions retain arguments and use the wrapper"
    (string-append "[Desktop Entry]\nExec=" output "/bin/app %U\n"
                   "[Desktop Action NewWindow]\nExec=" output
                   "/bin/app --new\nIcon=app\n")
    (call-with-input-file installed-desktop get-string-all))
  (test-assert "icon directory stays visible in the wrapper package"
    (string=? (readlink (string-append output "/share/icons"))
              (string-append payload "/share/icons")))
  (delete-file-recursively root))

(let ((runner (test-runner-current)))
  (test-end "container-launcher-build-system")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
