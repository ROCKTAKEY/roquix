(define-module (roquix packages dux-calendar)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages window-management))

(define-public dux-calendar
  (package
    (name "dux-calendar")
    (version "2.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/duxlabs-dev/dux-calendar/releases/download/v"
             version "/dankcalendar-" version ".tar.gz"))
       (sha256
        (base32 "1whrzydfysrccc7nyj88vn9qmxm6sl4wx4vg81kbgxghi59v3q04"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:test-target "test"
      #:make-flags
      #~(list (string-append "PREFIX="
                             #$output)
              (string-append "VERSION="
                             #$version)
              (string-append "COMMIT=v"
                             #$version) "BUILD_TIME=1970-01-01_00:00:01")
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda* (#:key inputs #:allow-other-keys)
              (setenv "HOME"
                      (getcwd))
              (setenv "GOCACHE"
                      (string-append (getcwd) "/.go-cache"))
              (setenv "GOPROXY" "off")
              (setenv "GOTOOLCHAIN" "local")
              (setenv "GOFLAGS" "-mod=vendor -trimpath")
              ;; Autostart records os.Executable(), so resolve external tools
              ;; in the binary instead of depending on a launcher wrapper.
              (substitute* "core/vendor/github.com/duxlabs-dev/dux-go/shellapp/env.go"
                (("\"qs\"")
                 (string-append "\""
                                (search-input-file inputs "/bin/qs") "\"")))
              (substitute* "core/cmd/dcal/account_add.go"
                (("\"xdg-open\"")
                 (string-append "\""
                                (search-input-file inputs "/bin/xdg-open")
                                "\"")))
              ;; Calendar time zones must also work on hosts without /usr/share/zoneinfo.
              (substitute* "core/Makefile"
                (("-tags withshell")
                 "-tags withshell,timetzdata"))))
          (replace 'build
            (lambda* (#:key make-flags #:allow-other-keys)
              (apply invoke
                     "make"
                     "-C"
                     "core"
                     "all"
                     make-flags)))
          (replace 'install
            (lambda* (#:key make-flags #:allow-other-keys)
              (apply invoke "make" "install" make-flags)
              (apply invoke
                     "make"
                     "-C"
                     "core"
                     "install-completions"
                     make-flags)))
          (add-after 'install 'check-installed
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke (string-append #$output "/bin/dcal") "version")
                (invoke "desktop-file-validate"
                        (string-append #$output
                         "/share/applications/dev.duxlabs.calendar.desktop"))))))))
    (native-inputs (list go-1.27 desktop-file-utils))
    (inputs (list quickshell xdg-utils))
    (home-page "https://duxlabs.dev/docs/2.0/dcal/")
    (synopsis "Desktop calendar with local, CalDAV and cloud accounts")
    (description
     "Dux Calendar brings local, Google, Microsoft, CalDAV and iCloud calendars
together in a Quickshell interface.  It provides event and task management,
meeting invitations, reminders and background synchronization.  The dcal command
also exposes calendar operations for scripts.")
    (license license:expat)))
