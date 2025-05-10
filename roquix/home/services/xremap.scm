(define-module (roquix home services xremap)
  #:use-module (gnu home services)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages admin)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:export (home-xremap-configuration
            home-xremap-service-type))


(define-configuration/no-serialization home-xremap-configuration
  (xremap
   (package xremap-x11)
   "The package providing xremap.")
  (config-file
   (file-like)
   "Path to config.yml file for xremap.")
  (debug
   (boolean #f)
   "Whether to output debug log."))

(define (home-xremap-services config)
  (list
   (shepherd-service
    (provision '(xremap))
    (modules '((shepherd support)))
    (start #~(make-forkexec-constructor
              (list #$(file-append (home-xremap-configuration-xremap config) "/bin/xremap")
                    "--watch=device"
                    #$(home-xremap-configuration-config-file config))
              #:log-file (string-append %user-log-dir "/xremap.log")
              #:environment-variables
              (append
               '("DISPLAY=:0"
                 "XAUTHORITY=/home/rocktakey/.Xauthority")
               (if #$(home-xremap-configuration-debug config)
                   '("RUST_LOG=debug")
                   '())
               (default-environment-variables))))
    (stop #~(make-kill-destructor))
    (documentation "Run @code{xremap} with the configuration file."))))

(define home-xremap-service-type
  (service-type
   (name 'home-xremap)
   (extensions
    (list
     (service-extension home-shepherd-service-type
                        home-xremap-services)))
   (description "Run the @code{xremap} utility to modify keymaps.")))
