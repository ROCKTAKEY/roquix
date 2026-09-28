(use-modules (roquix build container-launcher)
             (srfi srfi-64))

(test-begin "container-launcher-build-system")

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

(let ((runner (test-runner-current)))
  (test-end "container-launcher-build-system")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
