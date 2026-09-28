(use-modules (guix build-system trivial)
             (guix gexp)
             ((guix licenses)
              #:prefix license:)
             (guix packages)
             (roquix build-system container-launcher))

(define payload
  (package
    (name "container-launcher-fixture-payload")
    (version "1")
    (source
     #f)
    (build-system trivial-build-system)
    (arguments
     (list
      #:modules '((guix build utils))
      #:builder
      #~(begin
          (use-modules (guix build utils))
          (let ((out #$output))
            (mkdir-p (string-append out "/bin"))
            (mkdir-p (string-append out "/share/applications"))
            (mkdir-p (string-append out "/share/icons"))
            (call-with-output-file (string-append out "/bin/test-app")
              (lambda (port)
                (display "#!/bin/sh\nprintf '%s\\n' \"$@\"\n" port)))
            (chmod (string-append out "/bin/test-app") #o755)
            (call-with-output-file (string-append out
                                    "/share/applications/test-app.desktop")
              (lambda (port)
                (display "[Desktop Entry]\n" port)
                (display "Type=Application\n" port)
                (display "Name=Test App\n" port)
                (display "Exec=/old/test-app %U\n" port)
                (display "TryExec=/old/test-app\n" port)
                (display "DBusActivatable=true\n" port)
                (display "Icon=test-app\n" port)))
            (call-with-output-file (string-append out
                                                  "/share/icons/test-app.png")
              (lambda (port)
                (display "fixture icon" port)))))))
    (home-page "https://example.invalid/container-launcher-fixture")
    (synopsis "Fixture payload for the container launcher build system")
    (description "A tiny payload with an executable and desktop metadata.")
    (license license:public-domain)))

(package
  (name "container-launcher-fixture")
  (version "1")
  (source
   #f)
  (build-system container-launcher-build-system)
  (arguments
   (list
    #:payload payload
    #:executable "test-app"
    #:preserve-environment '("DISPLAY" "XDG_RUNTIME_DIR")
    #:share '((environment "XDG_RUNTIME_DIR"))
    #:expose '("/tmp")
    #:network? #t))
  (home-page "https://example.invalid/container-launcher-fixture")
  (synopsis "Fixture for the container launcher build system")
  (description "A tiny container launcher for integration testing.")
  (license license:public-domain))
