(define-module (roquix home services ollama)
  #:use-module (gnu home services)
  #:use-module (gnu home services shepherd)
  #:use-module (gnu services)
  #:use-module (guix gexp)
  #:use-module (guix records)
  #:use-module (roquix packages ollama)
  #:export (%home-ollama-default-host
            home-ollama-configuration
            home-ollama-configuration?
            home-ollama-configuration-ollama
            home-ollama-configuration-models-directory
            home-ollama-configuration-log-file
            home-ollama-configuration-host
            home-ollama-configuration-environment-variables
            home-ollama-configuration-extra-arguments
            home-ollama-shepherd-service
            home-ollama-service-type))

(define %home-ollama-default-host "127.0.0.1:11434")

(define-record-type* <home-ollama-configuration>
  home-ollama-configuration
  make-home-ollama-configuration
  home-ollama-configuration?
  (ollama home-ollama-configuration-ollama
          (default ollama))
  (models-directory home-ollama-configuration-models-directory
                    (default #f))
  (log-file home-ollama-configuration-log-file
            (default #f))
  (host home-ollama-configuration-host
        (default %home-ollama-default-host))
  (environment-variables home-ollama-configuration-environment-variables
                         (default '()))
  (extra-arguments home-ollama-configuration-extra-arguments
                   (default '())))

(define (home-ollama-models-directory config)
  (or (home-ollama-configuration-models-directory config)
      #~(string-append (getenv "HOME") "/.ollama/models")))

(define (home-ollama-log-file config)
  (or (home-ollama-configuration-log-file config)
      #~(string-append %user-log-dir "/ollama.log")))

(define (home-ollama-shepherd-service config)
  (let ((models-directory (home-ollama-models-directory config))
        (log-file (home-ollama-log-file config)))
    (match-record config <home-ollama-configuration>
      (ollama host environment-variables extra-arguments)
      (list
       (shepherd-service
        (documentation "Run the Ollama model server.")
        (provision '(ollama))
        (modules '((shepherd support)
                   (srfi srfi-1)))
        (start
         #~(make-forkexec-constructor
            (append
             (list #$(file-append ollama "/bin/ollama") "serve")
             #$extra-arguments)
            #:environment-variables
            (let* ((extra '#$environment-variables)
                   (managed? (lambda (name)
                               (any (lambda (variable)
                                      (string-prefix?
                                       (string-append name "=")
                                       variable))
                                    extra)))
                   (base (remove
                          (lambda (variable)
                            (or (string-prefix? "HOME=" variable)
                                (string-prefix? "OLLAMA_HOST=" variable)
                                (string-prefix? "OLLAMA_MODELS=" variable)))
                          (default-environment-variables))))
              (append
               (if (managed? "HOME")
                   '()
                   (list (string-append "HOME=" (getenv "HOME"))))
               (if (managed? "OLLAMA_HOST")
                   '()
                   (list (string-append "OLLAMA_HOST=" #$host)))
               (if (managed? "OLLAMA_MODELS")
                   '()
                   (list (string-append "OLLAMA_MODELS=" #$models-directory)))
               extra
               base))
            #:log-file #$log-file))
        (stop #~(make-kill-destructor)))))))

(define (home-ollama-profile-service config)
  (list (home-ollama-configuration-ollama config)))

(define (home-ollama-activation config)
  (let ((models-directory (home-ollama-models-directory config)))
    (with-imported-modules '((guix build utils))
      #~(begin
          (use-modules (guix build utils))
          (mkdir-p #$models-directory)))))

(define-public home-ollama-service-type
  (service-type
   (name 'home-ollama)
   (description
    "Run the Ollama model server as a user Shepherd service.  For example, to
use the ROCm-enabled package:

@lisp
(service home-ollama-service-type
         (home-ollama-configuration
          (ollama ollama-rocm)
          (environment-variables '(\"OLLAMA_DEBUG=INFO\"))))
@end lisp")
   (extensions
    (list
     (service-extension home-profile-service-type
                        home-ollama-profile-service)
     (service-extension home-activation-service-type
                        home-ollama-activation)
     (service-extension home-shepherd-service-type
                        home-ollama-shepherd-service)))
   (default-value (home-ollama-configuration))))
