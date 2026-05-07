(define-module (roquix packages waydroid)
  #:use-module (gnu packages admin)
  #:use-module (gnu packages android)
  #:use-module (gnu packages apparmor)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages base)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages certs)
  #:use-module (gnu packages dns)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-build)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages virtualization)
  #:use-module (gnu packages xdisorg)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define-public libglibutil
  (package
    (name "libglibutil")
    (version "1.0.81")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/sailfishos/libglibutil")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1br3ys92spr0g9csydwbkr24ji3m5cpkmi13xd1wg6m4q1r9sd5h"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:make-flags
      #~(list "KEEP_SYMBOLS=1"
              "CC=gcc"
              "AR=ar"
              (string-append "LIBDIR=" #$output "/lib")
              (string-append "INSTALL_LIB_DIR=" #$output "/lib")
              (string-append "INSTALL_INCLUDE_DIR=" #$output "/include/gutil")
              (string-append "INSTALL_PKGCONFIG_DIR="
                             #$output "/lib/pkgconfig"))
      #:phases
      #~(modify-phases %standard-phases
          ;; Upstream ships a plain Makefile and no configure script.
          (delete 'configure)
          (add-before 'build 'fix-pkg-config
            (lambda _
              ;; The upstream .pc template is FHS-oriented; point consumers at
              ;; this output so libgbinder can find the installed headers.
              (substitute* "libglibutil.pc.in"
                (("includedir=/usr/include")
                 (string-append "includedir=" #$output "/include")))))
          (replace 'install
            (lambda* (#:key make-flags #:allow-other-keys)
              ;; install-dev installs the library, headers and pkg-config file
              ;; needed by packages that link against libglibutil.
              (apply invoke "make" "install-dev" make-flags))))))
    (native-inputs (list pkg-config))
    (propagated-inputs (list glib))
    (home-page "https://github.com/sailfishos/libglibutil")
    (synopsis "GLib utility library")
    (description
     "Libglibutil provides utility functions and data structures built on top of
GLib.")
    (license license:bsd-3)))

(define-public libgbinder
  (package
    (name "libgbinder")
    (version "1.1.45")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/mer-hybris/libgbinder")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "14r860nbxmf8xs99613a17fh876r0izz3alza4z2fbb5c5vhisb0"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:make-flags
      #~(list "KEEP_SYMBOLS=1"
              "CC=gcc"
              "AR=ar"
              (string-append "LIBDIR=" #$output "/lib")
              (string-append "INSTALL_LIB_DIR=" #$output "/lib")
              (string-append "INSTALL_INCLUDE_DIR=" #$output "/include/gbinder")
              (string-append "INSTALL_PKGCONFIG_DIR="
                             #$output "/lib/pkgconfig"))
      #:phases
      #~(modify-phases %standard-phases
          ;; Upstream ships a plain Makefile and no configure script.
          (delete 'configure)
          (add-before 'build 'fix-pkg-config
            (lambda _
              ;; The upstream .pc template is FHS-oriented; point consumers at
              ;; this output so python-gbinder can find the installed headers.
              (substitute* "libgbinder.pc.in"
                (("includedir=/usr/include")
                 (string-append "includedir=" #$output "/include")))))
          (replace 'install
            (lambda* (#:key make-flags #:allow-other-keys)
              ;; install-dev installs the library, headers and pkg-config file
              ;; needed by the Python extension build.
              (apply invoke "make" "install-dev" make-flags))))))
    (native-inputs (list pkg-config))
    (propagated-inputs (list glib libglibutil))
    (home-page "https://github.com/mer-hybris/libgbinder")
    (synopsis "GLib-style interface to Android Binder")
    (description
     "Libgbinder provides a GLib-style interface to Android Binder IPC.")
    (license license:bsd-3)))

(define-public python-gbinder
  (let ((version "1.2.8"))
    (package
      (name "python-gbinder")
      (version version)
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/Kyle6012/gbinder")
               (commit (string-append "v" version))))
         (file-name (git-file-name name version))
         (sha256
          (base32 "17d12f7sa7kcdvmznzglhiyylz3b73axra637zaakqf76d34gk3g"))))
      (build-system python-build-system)
      (arguments
       (list
        #:tests? #f
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'fix-build-metadata
              (lambda _
                ;; The 1.2.8 tag still carries stale 1.2.7 metadata and looks
                ;; for gbinder.pc; libgbinder installs libgbinder.pc.
                (substitute* "setup.py"
                  (("pkg-config --cflags --libs gbinder")
                   "pkg-config --cflags --libs libgbinder")
                  (("version=\"1\\.2\\.7\"")
                   (string-append "version=\"" #$version "\"")))
                (substitute* "pyproject.toml"
                  (("version = \"1\\.2\\.7\"")
                   (string-append "version = \"" #$version "\""))))))))
      (native-inputs (list pkg-config python-setuptools python-wheel))
      (inputs (list libgbinder))
      (home-page "https://github.com/Kyle6012/gbinder")
      (synopsis "Python bindings for libgbinder")
      (description
       "Python-gbinder provides Python bindings for libgbinder, allowing Python
programs to communicate with Android Binder services.")
      (license license:gpl3+))))

(define (waydroid-package name use-nftables?)
  (package
    (name name)
    (version "1.6.2")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/waydroid/waydroid")
             (commit version)))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0zmpdfmyfqizknyzbyma7cc0qs0i90ma8mpff5c90fbyaiwbdlw9"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          ;; Waydroid is installed by its Makefile and has no configure script.
          (delete 'configure)
          (add-after 'unpack 'patch-python-shell
            (lambda* (#:key inputs #:allow-other-keys)
              ;; Avoid relying on an ambient "sh" lookup from Python helpers.
              (let ((sh (search-input-file inputs "/bin/sh")))
                (substitute* "tools/helpers/run.py"
                  (("\"sh\", \"-c\"")
                   (string-append "\"" sh "\", \"-c\""))))))
          (add-after 'patch-python-shell 'patch-work-directory
            (lambda _
              ;; Upstream treats work as fixed at import time: derived defaults
              ;; such as rootfs, lxc and host_perms are computed immediately
              ;; from /var/lib/waydroid.  When a downstream service overrides
              ;; work, changing only defaults["work"] would leave those paths
              ;; stale, so recalculate the derived state directories together.
              (substitute* "tools/__init__.py"
                (("args.work = config.defaults\\[\"work\"\\]\n")
                 (string-append
                  "args.work = os.environ.get(\"WAYDROID_WORK\", config.defaults[\"work\"])\n"
                  "    config.defaults[\"work\"] = args.work\n"
                  "    config.defaults[\"images_path\"] = args.work + \"/images\"\n"
                  "    config.defaults[\"rootfs\"] = args.work + \"/rootfs\"\n"
                  "    config.defaults[\"overlay\"] = args.work + \"/overlay\"\n"
                  "    config.defaults[\"overlay_rw\"] = args.work + \"/overlay_rw\"\n"
                  "    config.defaults[\"overlay_work\"] = args.work + \"/overlay_work\"\n"
                  "    config.defaults[\"data\"] = args.work + \"/data\"\n"
                  "    config.defaults[\"lxc\"] = args.work + \"/lxc\"\n"
                  "    config.defaults[\"host_perms\"] = args.work + \"/host-permissions\"\n")))))
          (add-after 'patch-work-directory 'patch-lxc-config-generation
            (lambda* (#:key inputs #:allow-other-keys)
              ;; Upstream assembles LXC snippets that embed /var/lib/waydroid.
              ;; Keep the existing command/run.user flow, but build a command
              ;; that replaces those embedded paths before the config is
              ;; written, so custom state-directory values remain coherent.
              (let ((sh (search-input-file inputs "/bin/sh"))
                    (sed (search-input-file inputs "/bin/sed")))
                (substitute* "tools/helpers/lxc.py"
                  (("import shutil\n")
                   "import shutil\nimport shlex\n")
                  (("def get_lxc_version\\(args\\):\n")
                   (string-append
                    "GUIX_SH = \"" sh "\"\n"
                    "GUIX_SED = \"" sed "\"\n\n"
                    "def escape_sed_replacement(path):\n"
                    "    return path.replace(\"\\\\\", \"\\\\\\\\\").replace(\"&\", \"\\\\&\").replace(\"|\", \"\\\\|\")\n\n"
                    "def make_lxc_config_command(args, config_snippets, config_path):\n"
                    "    sed_script = \"s|/var/lib/waydroid|{}|g\".format(escape_sed_replacement(args.work))\n"
                    "    return [\n"
                    "        GUIX_SH,\n"
                    "        \"-c\",\n"
                    "        \"{} {} {} > {}\".format(\n"
                    "            shlex.quote(GUIX_SED),\n"
                    "            shlex.quote(sed_script),\n"
                    "            \" \".join(shlex.quote(path) for path in config_snippets),\n"
                    "            shlex.quote(config_path)),\n"
                    "    ]\n\n"
                    "def get_lxc_version(args):\n"))
                  (("    command = \\[\"sh\", \"-c\", \"cat .*")
                   "    command = make_lxc_config_command(args, config_snippets, lxc_path + \"/config\")\n")))))
          (add-after 'patch-lxc-config-generation 'patch-network-state-directory
            (lambda _
              ;; dnsmasq leases live under /var/lib/misc by default; expose the
              ;; path to the service so activation can create it declaratively.
              (substitute* "tools/helpers/net.py"
                (("from shutil import which\n")
                 "from shutil import which\nimport os\n")
                (("lease_file = \"/var/lib/misc/dnsmasq.waydroid0.leases\"")
                 "lease_file = os.environ.get(\"WAYDROID_MISC_DIR\", \"/var/lib/misc\") + \"/dnsmasq.waydroid0.leases\""))
              ;; The network shell script also reads the LXC config and writes
              ;; dnsmasq leases, so it must honor the same directories.
              (substitute* "data/scripts/waydroid-net.sh"
                (("varlib=\"/var/lib\"\n")
                 (string-append
                  "varlib=\"/var/lib\"\n"
                  "waydroid_work=\"${WAYDROID_WORK:-/var/lib/waydroid}\"\n"
                  "varmisc=\"${WAYDROID_MISC_DIR:-${varlib}/misc}\"\n"))
                ((" /var/lib/waydroid/lxc/waydroid/config")
                 " \"${waydroid_work}/lxc/waydroid/config\"")
                (("\\[ ! -d \"\\$\\{varlib\\}\"/misc \\]")
                 "[ ! -d \"${varmisc}\" ]")
                (("mkdir \"\\$\\{varlib\\}\"/misc")
                 "mkdir \"${varmisc}\"")
                (("--dhcp-leasefile=\"\\$\\{varlib\\}\"/misc/")
                 "--dhcp-leasefile=\"${varmisc}\"/"))))
          (replace 'build
            (lambda _
              ;; Upstream's build target is intentionally a no-op, but keeping
              ;; it here follows the project's expected Makefile interface.
              (invoke "make" "build")))
          (replace 'install
            (lambda _
              ;; Install host-side files only: no systemd unit, D-Bus
              ;; activation enabled, AppArmor profiles included, and the
              ;; networking backend selected by this package variant.
              (let ((nftables? #$(if use-nftables? #t #f)))
                (invoke "make" "install"
                        (string-append "PREFIX=" #$output)
                        (string-append "SYSCONFDIR=" #$output "/etc")
                        "USE_SYSTEMD=0"
                        "USE_DBUS_ACTIVATION=1"
                        (string-append "USE_NFTABLES="
                                       (if nftables? "1" "0")))
                (invoke "make" "install_apparmor"
                        (string-append "PREFIX=" #$output)
                        (string-append "SYSCONFDIR=" #$output "/etc")))))
          (add-after 'install 'patch-installed-files
            (lambda _
              ;; Installed files still contain FHS entry points; patch
              ;; shebangs and the D-Bus activation command to store paths.
              (let ((waydroid (string-append #$output "/bin/waydroid"))
                    (waydroid.py
                     (string-append #$output "/lib/waydroid/waydroid.py"))
                    (net-script
                     (string-append
                      #$output
                      "/lib/waydroid/data/scripts/waydroid-net.sh"))
                    (dbus-service
                     (string-append
                      #$output
                      "/share/dbus-1/system-services/id.waydro.Container.service")))
                (patch-shebang waydroid.py)
                (patch-shebang net-script)
                (substitute* dbus-service
                  (("Exec=/usr/bin/waydroid -w container start")
                   (string-append "Exec=" waydroid " container start"))))))
          (add-after 'patch-installed-files 'wrap-installed-programs
            (lambda* (#:key inputs #:allow-other-keys)
              ;; Waydroid invokes many host tools by name and imports Python/GI
              ;; modules at run time, so wrap both the CLI and network helper.
              (define runtime-inputs
                '("adb" "apparmor" "bash-minimal" "coreutils" "dnsmasq"
                  "findutils" "gawk" "glibc" "grep" "iproute2" "iptables"
                  "kmod" "lxc" "nftables" "procps" "sed" "sudo"
                  "util-linux" "wl-clipboard"))
              (define (input-directories name)
                (let ((input (assoc-ref inputs name)))
                  (if input
                      (filter file-exists?
                              (map (lambda (suffix)
                                     (string-append input suffix))
                                   '("/bin" "/sbin")))
                      '())))
              (let* ((path
                      (string-join
                       (apply append (map input-directories runtime-inputs))
                       ":"))
                     (python-path
                      (search-path-as-string->list
                       (or (getenv "GUIX_PYTHONPATH") "")))
                     (typelib-path
                      (search-path-as-string->list
                       (or (getenv "GI_TYPELIB_PATH") "")))
                     (cert-dir
                      (string-append
                       (assoc-ref inputs "nss-certs")
                       "/etc/ssl/certs"))
                     (waydroid.py
                      (string-append #$output "/lib/waydroid/waydroid.py"))
                     (net-script
                      (string-append
                       #$output
                       "/lib/waydroid/data/scripts/waydroid-net.sh")))
                (wrap-program waydroid.py
                  `("PATH" ":" prefix (,path))
                  `("GUIX_PYTHONPATH" ":" prefix ,python-path)
                  `("GI_TYPELIB_PATH" ":" prefix ,typelib-path)
                  `("SSL_CERT_DIR" = (,cert-dir)))
                (wrap-program net-script
                  `("PATH" ":" prefix (,path))))))
          (add-after 'wrap-installed-programs 'validate-waydroid
            (lambda* (#:key inputs #:allow-other-keys)
              ;; Import-check the required Python bindings and exercise the
              ;; wrapped CLI without needing Binder or an initialized image.
              (setenv "HOME" "/tmp")
              (setenv "XDG_CACHE_HOME" "/tmp")
              (invoke (search-input-file inputs "/bin/python3")
                      "-c" "import dbus, gi, gbinder; gi.require_version('Gtk', '3.0'); from gi.repository import GLib, Gtk")
              (invoke (string-append #$output "/bin/waydroid") "-h"))))))
    (native-inputs (list pkg-config))
    (inputs
     (list adb
           apparmor
           bash-minimal
           coreutils
           dbus
           dnsmasq
           findutils
           gawk
           glib
           glibc
           gobject-introspection
           grep
           gtk+
           iproute
           iptables
           kmod
           libgbinder
           lxc
           nftables
           nss-certs
           procps
           python-argcomplete
           python-dbus
           python-gbinder
           python-pyclip
           python-pygobject
           python-wrapper
           sed
           sudo
           util-linux
           wl-clipboard))
    (home-page "https://waydro.id")
    (synopsis "Container-based Android runtime for GNU/Linux")
    (description
     "Waydroid runs a full Android system in an LXC container and integrates
Android applications into a Wayland-based GNU/Linux desktop.  This package
contains the host-side Waydroid tools, D-Bus system service files, Polkit
policy and AppArmor profiles.  Android images are not bundled and are fetched
at run time with @command{waydroid init}.")
    (license license:gpl3+)))

(define-public waydroid
  (waydroid-package "waydroid" #f))

(define-public waydroid-nftables
  (waydroid-package "waydroid-nftables" #t))

(define-public waydroid-extras-script
  (let ((commit "d5289cfd8929e86e7f0dc89ecadcef8b66930eec"))
    (package
      (name "waydroid-extras-script")
      (version "0-unstable-2026-05-07")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/casualsnek/waydroid_script")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0g26xsaahxnr2bib9wjsv9l3r2hgl62safbj2d8nc7f926bdj8fd"))))
      (build-system copy-build-system)
      (arguments
       (list
        #:install-plan #~'(("." "share/waydroid-extras"))
        #:phases
        #~(modify-phases %standard-phases
            (add-after 'unpack 'patch-cli-wrapper
              (lambda _
                ;; Guix does not currently provide InquirerPy.  Keep the
                ;; command-line installer usable and make accidental
                ;; interactive invocation fail with an actionable message.
                (substitute* "main.py"
                  (("from InquirerPy import inquirer\n") "")
                  (("from InquirerPy\\.base\\.control import Choice\n") "")
                  (("from InquirerPy\\.separator import Separator\n") "")
                  (("def interact\\(\\):")
                   (string-append
                    "def interact():\n"
                    "    Logger.error(\"Interactive mode is disabled in this "
                    "Guix package; use 'waydroid-extras install <component>' "
                    "or 'waydroid-extras remove <component>'.\")\n"
                    "    raise SystemExit(1)")))))
            (add-after 'patch-cli-wrapper 'patch-waydroid-paths
              (lambda _
                ;; Honor the same state-directory override as the roquix
                ;; Waydroid package and service.
                (substitute* "stuff/general.py"
                  (("from tools.logger import Logger\n")
                   (string-append
                    "from tools.logger import Logger\n\n\n"
                    "def get_waydroid_work():\n"
                    "    return os.environ.get(\"WAYDROID_WORK\", "
                    "\"/var/lib/waydroid\")\n\n\n"
                    "def get_waydroid_config():\n"
                    "    return os.environ.get(\"WAYDROID_CONFIG\", "
                    "os.path.join(get_waydroid_work(), \"waydroid.cfg\"))\n"))
                  (("return \"/var/lib/waydroid/overlay\"")
                   "return os.path.join(get_waydroid_work(), \"overlay\")")
                  (("cfg.read\\(\"/var/lib/waydroid/waydroid.cfg\"\\)")
                   "cfg.read(get_waydroid_config())")
                  (("with open\\(\"/var/lib/waydroid/waydroid.cfg\", \"w\"\\) as f:")
                   "with open(get_waydroid_config(), \"w\") as f:"))
                (substitute* "stuff/magisk.py"
                  (("sys_overlay_rw = \"/var/lib/waydroid/overlay_rw\"")
                   (string-append
                    "sys_overlay_rw = os.path.join("
                    "os.environ.get(\"WAYDROID_WORK\", \"/var/lib/waydroid\"), "
                    "\"overlay_rw\")")))))
            (add-after 'install 'install-wrapper
              (lambda* (#:key inputs #:allow-other-keys)
                (let* ((bin (string-append #$output "/bin"))
                       (program (string-append bin "/waydroid-extras"))
                       (python (search-input-file inputs "/bin/python3"))
                       (sh (search-input-file inputs "/bin/sh"))
                       (runtime-inputs
                        '("bash-minimal" "coreutils" "e2fsprogs" "findutils"
                          "gawk" "grep" "lzip" "sed" "squashfs-tools" "sudo"
                          "tar" "unzip" "util-linux" "waydroid"))
                       (input-directories
                        (lambda (name)
                          (let ((input (assoc-ref inputs name)))
                            (if input
                                (filter file-exists?
                                        (map (lambda (suffix)
                                               (string-append input suffix))
                                             '("/bin" "/sbin")))
                                '()))))
                       (path
                        (string-join
                         (apply append (map input-directories runtime-inputs))
                         ":"))
                       (python-path
                        (search-path-as-string->list
                         (or (getenv "GUIX_PYTHONPATH") "")))
                       (cert-dir
                        (string-append
                         (assoc-ref inputs "nss-certs")
                         "/etc/ssl/certs")))
                  (mkdir-p bin)
                  (call-with-output-file program
                    (lambda (port)
                      (format port
                              "#!~a~%exec ~a ~a/share/waydroid-extras/main.py \"~a\"~%"
                              sh python #$output "$@")))
                  (chmod program #o755)
                  (wrap-program program
                    `("PATH" ":" prefix (,path))
                    `("GUIX_PYTHONPATH" ":" prefix ,python-path)
                    `("SSL_CERT_DIR" = (,cert-dir))))))
            (add-after 'install-wrapper 'validate-wrapper
              (lambda _
                (setenv "HOME" "/tmp")
                (setenv "XDG_CACHE_HOME" "/tmp")
                (setenv "USER" "root")
                (invoke (string-append #$output "/bin/waydroid-extras")
                        "-h"))))))
      (inputs
       (list bash-minimal
             coreutils
             e2fsprogs
             findutils
             gawk
             grep
             lzip
             nss-certs
             python-requests
             python-tqdm
             python-wrapper
             sed
             squashfs-tools
             sudo
             tar
             unzip
             util-linux
             waydroid))
      (home-page "https://github.com/casualsnek/waydroid_script")
      (synopsis "Install optional Waydroid extras")
      (description
       "Waydroid Extras Script installs optional additions into an existing
Waydroid image.  This package provides the @command{waydroid-extras} command
for non-interactive use, including @command{sudo waydroid-extras install
libndk} and @command{sudo waydroid-extras install libhoudini}.  The native
bridge archives themselves are not bundled; they are downloaded and verified by
the script at run time.  Use only one native bridge implementation for a given
Waydroid image.")
      (license license:gpl3+))))
