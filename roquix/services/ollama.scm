(define-module (roquix services ollama)
  #:use-module (gnu packages admin)
  #:use-module (gnu services)
  #:use-module (gnu services shepherd)
  #:use-module (gnu system shadow)
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (guix records)
  #:use-module (roquix packages ollama)
  #:export (%ollama-default-home-directory
            %ollama-default-models-directory
            %ollama-default-log-file
            %ollama-default-host
            ollama-configuration
            ollama-configuration?
            ollama-configuration-ollama
            ollama-configuration-home-directory
            ollama-configuration-models-directory
            ollama-configuration-log-file
            ollama-configuration-host
            ollama-configuration-supplementary-groups
            ollama-configuration-environment-variables
            ollama-configuration-extra-arguments
            ollama-shepherd-service
            ollama-service-type))

(define %ollama-account-name "ollama")
(define %ollama-group-name "ollama")
(define %ollama-default-home-directory "/var/lib/ollama")
(define %ollama-default-models-directory "/var/lib/ollama/models")
(define %ollama-default-log-file "/var/log/ollama.log")
(define %ollama-default-host "127.0.0.1:11434")

(define-record-type* <ollama-configuration>
  ollama-configuration
  make-ollama-configuration
  ollama-configuration?
  (ollama ollama-configuration-ollama
          (default ollama))
  (home-directory ollama-configuration-home-directory
                  (default %ollama-default-home-directory))
  (models-directory ollama-configuration-models-directory
                    (default %ollama-default-models-directory))
  (log-file ollama-configuration-log-file
            (default %ollama-default-log-file))
  (host ollama-configuration-host
        (default %ollama-default-host))
  (supplementary-groups ollama-configuration-supplementary-groups
                        (default '("video")))
  (environment-variables ollama-configuration-environment-variables
                         (default '()))
  (extra-arguments ollama-configuration-extra-arguments
                   (default '())))

(define (ollama-shepherd-service config)
  (match-record config <ollama-configuration>
    (ollama home-directory models-directory log-file host
            supplementary-groups environment-variables extra-arguments)
    (list
     (shepherd-service
      (documentation "Run the Ollama model server.")
      (provision '(ollama))
      (requirement '(networking user-processes))
      (start
       #~(make-forkexec-constructor
          (append
           (list #$(file-append ollama "/bin/ollama") "serve")
           #$extra-arguments)
          #:environment-variables
          (append
           (list (string-append "HOME=" #$home-directory)
                 (string-append "OLLAMA_HOST=" #$host)
                 (string-append "OLLAMA_MODELS=" #$models-directory))
           #$environment-variables)
          #:user #$%ollama-account-name
          #:group #$%ollama-group-name
          #:supplementary-groups #$supplementary-groups
          #:log-file #$log-file))
      (stop #~(make-kill-destructor))))))

(define (ollama-accounts config)
  (list
   (user-group
    (name %ollama-group-name)
    (system? #t))
   (user-account
    (name %ollama-account-name)
    (group %ollama-group-name)
    (supplementary-groups
     (ollama-configuration-supplementary-groups config))
    (system? #t)
    (comment "Ollama service user")
    (home-directory (ollama-configuration-home-directory config))
    (shell #~(string-append #$shadow "/sbin/nologin")))))

(define (ollama-activation config)
  (match-record config <ollama-configuration>
    (home-directory models-directory)
    (with-imported-modules
        (source-module-closure '((gnu build activation)))
      #~(begin
          (use-modules (gnu build activation))

          (let ((user (getpw #$%ollama-account-name)))
            (mkdir-p/perms #$home-directory user #o755)
            (mkdir-p/perms #$models-directory user #o755))))))

(define-public ollama-service-type
  (service-type
   (name 'ollama)
   (description
    "Run the Ollama model server as a Shepherd service.  For example, to run
the ROCm-enabled package:

@lisp
(service ollama-service-type
         (ollama-configuration
          (ollama ollama-rocm)
          (supplementary-groups '(\"video\" \"render\"))
          (environment-variables '(\"OLLAMA_DEBUG=INFO\"))))
@end lisp")
   (extensions
    (list
     (service-extension shepherd-root-service-type
                        ollama-shepherd-service)
     (service-extension account-service-type
                        ollama-accounts)
     (service-extension activation-service-type
                        ollama-activation)))
   (default-value (ollama-configuration))))
