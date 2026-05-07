(define-module (roquix services waydroid)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services dbus)
  #:use-module (gnu services shepherd)
  #:use-module ((gnu system file-systems)
                #:select (%control-groups))
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (guix records)
  #:use-module (roquix packages waydroid)
  #:export (waydroid-configuration
            waydroid-configuration?
            waydroid-configuration-package
            waydroid-configuration-state-directory
            waydroid-configuration-misc-directory
            waydroid-configuration-extra-environment-variables
            waydroid-configuration-auto-start?
            waydroid-shepherd-service
            waydroid-service-type))

(define-record-type* <waydroid-configuration>
  waydroid-configuration
  make-waydroid-configuration
  waydroid-configuration?
  (package waydroid-configuration-package
           (default waydroid))
  (state-directory waydroid-configuration-state-directory
                   (default "/var/lib/waydroid"))
  (misc-directory waydroid-configuration-misc-directory
                  (default "/var/lib/misc"))
  (extra-environment-variables
   waydroid-configuration-extra-environment-variables
   (default '()))
  (auto-start? waydroid-configuration-auto-start?
               (default #t)))

(define (waydroid-shepherd-service config)
  (match-record config <waydroid-configuration>
    (package state-directory misc-directory extra-environment-variables
             auto-start?)
    (list
     (shepherd-service
      (documentation "Run the Waydroid container manager.")
      (provision '(waydroid-container))
      (requirement '(dbus-system file-system-/sys/fs/cgroup networking))
      (start
       #~(make-forkexec-constructor
          (list #$(file-append package "/bin/waydroid")
                "container" "start")
          #:environment-variables
          `(,(string-append "WAYDROID_WORK=" #$state-directory)
            ,(string-append "WAYDROID_MISC_DIR=" #$misc-directory)
            #$@extra-environment-variables
            ,@(environ))
          #:log-file "/var/log/waydroid-container.log"))
      (stop #~(make-kill-destructor))
      (auto-start? auto-start?)))))

(define (waydroid-activation config)
  (match-record config <waydroid-configuration>
    (state-directory misc-directory)
    (with-imported-modules (source-module-closure
                            '((guix build utils)))
      #~(begin
          (use-modules (guix build utils))

          (mkdir-p #$state-directory)
          (chmod #$state-directory #o755)
          (mkdir-p #$misc-directory)
          (chmod #$misc-directory #o755)))))

(define (waydroid-package-list config)
  (list (waydroid-configuration-package config)))

(define-public waydroid-service-type
  (service-type
   (name 'waydroid)
   (description
    "Run the Waydroid container manager as a root Shepherd service.
Waydroid requires a Wayland session, Binder/BinderFS kernel support, a cgroup2
mount and Android images initialized with @command{sudo waydroid init}.  The
@code{package} field can be set to @code{waydroid-nftables} to install the
nftables networking variant.

A minimal operating system configuration can enable the service like this:

@lisp
(use-modules (gnu)
             (gnu services dbus)
             (gnu services desktop)
             (gnu services networking)
             (roquix services waydroid))

(services
 (cons* (service dbus-root-service-type)
        (service polkit-service-type)
        (service dhcpcd-service-type)
        (service waydroid-service-type
                 (waydroid-configuration
                  ;; Start it manually after running \"waydroid init\" once.
                  (auto-start? #f)))
        %base-services))
@end lisp

To use the nftables networking variant, import the package module and override
the package field:

@lisp
(use-modules (gnu)
             (roquix packages waydroid)
             (roquix services waydroid))

(service waydroid-service-type
         (waydroid-configuration
          (package waydroid-nftables)))
@end lisp

After reconfiguring the system, initialize the Android image once and start the
container service:

@example
sudo waydroid init
herd start waydroid-container
waydroid session start
waydroid show-full-ui
@end example")
   (extensions
    (list
     (service-extension shepherd-root-service-type
                        waydroid-shepherd-service)
     (service-extension activation-service-type
                        waydroid-activation)
     (service-extension profile-service-type
                        waydroid-package-list)
     (service-extension file-system-service-type
                        (const %control-groups))
     (service-extension dbus-root-service-type
                        waydroid-package-list)
     (service-extension polkit-service-type
                        waydroid-package-list)))
   (default-value (waydroid-configuration))))
