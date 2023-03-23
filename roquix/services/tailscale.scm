(define-module
  (roquix services tailscale)
  #:use-module (guix records)
  #:use-module (guix packages)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu build shepherd)
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (gnu packages linux)
  #:use-module (roquix packages tailscale))

(define-record-type* <tailscale-configuration>
  tailscale-configuration
  make-tailscale-configuration
  tailscale-configuration?
  ;; File-like object
  (tailscale tailscale-configuration-tailscale
             (default tailscale))
  (iptables tailscale-configuration-iptables
            (default iptables))
  (extra-arguments tailscale-configuration-extra-arguments
                   (default '())))

(define-public %tailscale-configuration
  (tailscale-configuration))

(define-public (tailscale-up-action tailscale iptables)
  (shepherd-action
   (name 'up)
   (documentation
    "Run tailscale up.")
   (procedure
    #~(lambda args
        (make-forkexec-constructor
         (cons* #$(file-append tailscale "/bin/tailscale")
                "up"
                args)
         #:log-file "/var/log/tailscale-up.log"
         #:environment-variables
         (cons*
          (string-append "PATH=" #$(file-append iptables "/sbin"))
          (environ)))))))

(define-public (tailscale-down-action tailscale iptables)
  (shepherd-action
   (name 'down)
   (documentation
    "Run tailscale down.")
   (procedure
    #~(lambda args
        (make-forkexec-constructor
         (cons* #$(file-append tailscale "/bin/tailscale")
                "down"
                args)
         #:log-file "/var/log/tailscale-down.log"
         #:environment-variables
         (cons*
          (string-append "PATH=" #$(file-append iptables "/sbin"))
          (environ)))))))

(define-public (tailscale-shepherd-service config)
  (match-record config <tailscale-configuration>
    (tailscale iptables extra-arguments)
    (list
     (shepherd-service
      (documentation "Run Tailscale daemon.")
      (provision '(tailscale))
      (requirement '(networking))
      (start
       #~(make-forkexec-constructor
          (list #$(file-append tailscale "/bin/tailscaled")
                #$@extra-arguments)
          #:log-file "/var/log/tailscaled.log"
          #:environment-variables
          (cons*
           (string-append "PATH=" #$(file-append iptables "/sbin"))
           (environ))))
      (actions
       (list (tailscale-up-action tailscale iptables)
             (tailscale-down-action tailscale iptables)))
      (stop #~(make-kill-destructor))))))

(define-public tailscale-service-type
  (service-type
   (name 'tailscale)
   (description "Tailscale daemon.")
   (extensions
    (list
     (service-extension shepherd-root-service-type tailscale-shepherd-service)))
   (default-value %tailscale-configuration)))
