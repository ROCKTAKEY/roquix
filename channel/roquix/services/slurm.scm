(define-module (roquix services slurm)
  #:use-module (gnu packages base)
  #:use-module (gnu packages parallel)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:export (slurm-configuration slurm-service-type))

(define-record-type* <slurm-configuration>
  slurm-configuration make-slurm-configuration
  slurm-configuration?
  (package slurm-package (default slurm))
  (slurm-conf slurm-conf)
  (gres-conf slurm-gres-conf (default #f))
  (job-submit-lua slurm-job-submit-lua (default #f)))

;; Guix runs Shepherd, so there is no systemd to create the system.slice
;; cgroup. With IgnoreSystemd=yes, Slurm 23.11.10 calls mkdir(2) on
;; system.slice/slurmstepd.scope and fails if the parent is missing.
;; The Shepherd service therefore supplies that parent before starting slurmd.
;; https://github.com/SchedMD/slurm/blob/slurm-23-11-10-1/src/plugins/cgroup/v2/cgroup_v2.c
(define (with-slurmstepd-scope-parent start)
  #~(lambda args
      (unless (file-exists? "/sys/fs/cgroup/system.slice")
        (mkdir "/sys/fs/cgroup/system.slice"))
      (apply #$start args)))

(define (slurm-daemons config)
  (define (start-daemon name)
    #~(make-forkexec-constructor
       (list #$(file-append (slurm-package config) (string-append "/sbin/" name))
             "-D" "-f" "/etc/slurm/slurm.conf")
       #:log-file #$(string-append "/var/log/" name ".log")))
  (list (shepherd-service
         (provision '(slurmctld))
         (requirement '(networking user-processes))
         (start (start-daemon "slurmctld"))
         (stop #~(make-kill-destructor)))
        (shepherd-service
         (provision '(slurmd))
         (requirement '(slurmctld))
         (start (with-slurmstepd-scope-parent (start-daemon "slurmd")))
         (stop #~(make-kill-destructor)))))

(define (slurm-accounts _)
  (list (user-group (name "slurm") (system? #t))
        (user-account (name "slurm") (group "slurm") (system? #t)
                      (home-directory "/var/empty"))))

(define %cgroup-conf
  (plain-file "cgroup.conf"
              "CgroupPlugin=cgroup/v2\nIgnoreSystemd=yes\nEnableControllers=yes\n"))

(define (activate-slurm config)
  #~(begin
      (use-modules (guix build utils))
      ;; auth/slurm reads its private key alongside slurm.conf. Keep the
      ;; directory writable while linking declarative files into the store.
      (mkdir-p "/etc/slurm")
      (with-directory-excursion "/etc/slurm"
        (let ((uid (passwd:uid (getpwnam "slurm")))
              (gid (group:gid (getgrnam "slurm"))))
          (for-each mkdir-p '("/var/lib/slurm/node" "/run/slurmd"))
          (for-each (lambda (dir)
                      (mkdir-p dir)
                      (chown dir uid gid))
                    '("/var/lib/slurm/controller" "/run/slurmctld"))
          (unless (file-exists? "slurm.key")
            (let* ((tmp (string-copy ".key-XXXXXX"))
                   (port (mkstemp! tmp)))
              (close-port port)
              (dynamic-wind
                (const #t)
                (lambda ()
                  (invoke #$(file-append coreutils "/bin/dd") "if=/dev/urandom"
                          (string-append "of=" tmp) "bs=1024" "count=1" "status=none")
                  (chown tmp uid gid)
                  (link tmp "slurm.key"))
                (lambda () (delete-file tmp))))))
        (for-each (lambda (name target)
                    (if target
                        (switch-symlinks name target)
                        (when (false-if-exception (readlink name))
                          (delete-file name))))
                  '("slurm.conf" "cgroup.conf" "gres.conf" "job_submit.lua")
                  (list #$(slurm-conf config) #$%cgroup-conf
                        #$(slurm-gres-conf config) #$(slurm-job-submit-lua config))))))

(define slurm-service-type
  (service-type
   (name 'slurm)
   (extensions
    (list (service-extension account-service-type slurm-accounts)
          (service-extension activation-service-type activate-slurm)
          (service-extension shepherd-root-service-type slurm-daemons)
          (service-extension profile-service-type
                             (lambda (config) (list (slurm-package config))))))
   (description "Run a single-host Slurm controller and compute daemon on cgroup v2.")))
