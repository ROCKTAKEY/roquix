(define-module (roquix packages errands)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (guix build-system meson)
  #:use-module (guix build-system pyproject)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages check)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages gettext)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gnome)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-check)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages time)
  #:use-module (gnu packages xml))

(define-public python-x-wr-timezone
  (package
    (name "python-x-wr-timezone")
    (version "2.0.1")
    (source
     (origin
       ;; The PyPI archive omits conftest.py, which defines the test fixtures.
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/niccokunzmann/x-wr-timezone")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0k8n56sm5vfvp27mmz909lkcvfan30zf8z8c8qpxsz8qkpfmwnif"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      #:test-flags
      #~(list "--x-wr-timezone=all")))
    (native-inputs (list python-pytest python-pytest-click python-pytz
                         python-restructuredtext-lint python-setuptools))
    (propagated-inputs (list python-click python-icalendar python-tzdata))
    (home-page "https://github.com/niccokunzmann/x-wr-timezone")
    (synopsis "Convert X-WR-TIMEZONE calendars to standard iCalendar")
    (description
     "This Python library and command-line tool converts calendars using the
X-WR-TIMEZONE extension into RFC 5545-compatible iCalendar data.")
    (license license:lgpl3+)))

(define-public python-recurring-ical-events
  (package
    (name "python-recurring-ical-events")
    (version "3.8.0")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "recurring_ical_events" version))
       (sha256
        (base32 "013xrrmsd1shnp8kyv93w5rdjq3w8x8svbwimfkmd2dxv4spr31y"))))
    (build-system pyproject-build-system)
    (native-inputs (list python-hatchling
                         python-hatch-vcs
                         python-pytest
                         python-pygments
                         python-pytz
                         python-restructuredtext-lint))
    (propagated-inputs (list python-dateutil python-icalendar python-tzdata
                             python-x-wr-timezone))
    (home-page "https://recurring-ical-events.readthedocs.io/")
    (synopsis "Expand recurring iCalendar events")
    (description
     "Recurring ICal Events computes occurrences of events, tasks, journals,
and alarms from iCalendar recurrence rules, including exceptions and changes
to individual occurrences.")
    (license license:gpl3+)))

(define-public python-caldav
  (package
    (name "python-caldav")
    (version "2.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "caldav" version))
       (sha256
        (base32 "1h3a5hv56531fd67aqnj7q0rd4m2dxiqnrzvyr9hyfj3n2q41nh4"))))
    (build-system pyproject-build-system)
    (arguments
     (list
      ;; Integration tests require configured CalDAV servers.  The upstream
      ;; unit suite mocks server communication and runs in the build sandbox.
      ;; https://github.com/python-caldav/caldav/blob/v2.0.1/tests/test_caldav_unit.py
      #:test-flags
      #~(list "tests/test_caldav_unit.py" "tests/test_utils.py"
              "tests/test_vcal.py")))
    (native-inputs (list python-hatchling python-hatch-vcs python-pytest
                         python-vobject))
    (propagated-inputs (list python-icalendar python-lxml
                             python-recurring-ical-events python-requests))
    (home-page "https://github.com/python-caldav/caldav")
    (synopsis "Python client library for CalDAV")
    (description
     "Python CalDAV provides a client for the CalDAV calendar access protocol.
It supports discovering calendars and managing events and tasks on a CalDAV
server.")
    (license (list license:gpl3 license:asl2.0))))

(define-public errands
  (package
    (name "errands")
    (version "46.2.10")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mrvladus/Errands")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0l2hx84prrcyr4wawdbqg14v75ccj0v07i2w3yx03mjns3maf0k2"))))
    (build-system meson-build-system)
    (arguments
     (list
      #:glib-or-gtk? #t
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'disable-cache-updates
            (lambda _
              ;; Guix profile hooks maintain caches across immutable outputs.
              (substitute* "meson.build"
                (("gtk_update_icon_cache: true")
                 "gtk_update_icon_cache: false")
                (("update_desktop_database: true")
                 "update_desktop_database: false"))))
          (add-after 'glib-or-gtk-wrap 'wrap-python-and-introspection
            (lambda* (#:key outputs #:allow-other-keys)
              (wrap-program (string-append (assoc-ref outputs "out")
                                           "/bin/errands")
                `("GUIX_PYTHONPATH" =
                  (,(getenv "GUIX_PYTHONPATH")))
                `("GI_TYPELIB_PATH" =
                  (,(getenv "GI_TYPELIB_PATH"))))))
          (add-after 'glib-or-gtk-compile-schemas 'check-installed-command
            (lambda* (#:key outputs
                      (tests? #t) #:allow-other-keys)
              (when tests?
                ;; Build search paths must not hide missing runtime wrappers.
                (invoke (which "env")
                        "-i"
                        (string-append "HOME="
                                       (getcwd))
                        "LC_ALL=C.UTF-8"
                        (string-append (assoc-ref outputs "out")
                                       "/bin/errands")
                        "--help")))))))
    (native-inputs (list (list "desktop-file-utils" desktop-file-utils)
                         (list "gettext-minimal" gettext-minimal)
                         (list "glib:bin" glib "bin")
                         (list "gobject-introspection" gobject-introspection)
                         (list "pkg-config" pkg-config)))
    (inputs (list bash-minimal
                  glib
                  gnome-online-accounts
                  gtk
                  gtksourceview
                  libadwaita
                  libportal
                  libsecret
                  python
                  python-caldav
                  python-pygobject))
    (home-page "https://github.com/mrvladus/Errands")
    (synopsis "Task manager with CalDAV synchronization")
    (description
     "Errands is a GNOME task manager for organizing multiple task lists and
subtasks, assigning colors, and importing iCalendar files.  It supports
drag-and-drop reordering and synchronization with Nextcloud and other CalDAV
servers.")
    (license license:expat)))
