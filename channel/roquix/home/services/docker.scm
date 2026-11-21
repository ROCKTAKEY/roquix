(define-module (roquix home services docker)
  #:use-module (gnu home services)
  #:use-module (gnu services)
  #:use-module (gnu services configuration)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (srfi srfi-1)
  #:export (home-docker-cli-plugins-configuration
            home-docker-cli-plugins-configuration?
            home-docker-cli-plugins-configuration-plugins
            home-docker-cli-plugins-service-type))

(define (plugin-packages? value)
  (and (list? value) (every package? value)))

(define-configuration/no-serialization home-docker-cli-plugins-configuration
  (plugins
   (plugin-packages '())
   "Packages providing executable docker-* files in lib/docker/cli-plugins.
Plugin names must be unique across all packages."))

(define (home-docker-cli-plugins-files config)
  (let ((plugins (home-docker-cli-plugins-configuration-plugins config)))
    `((".docker/cli-plugins"
       ,(computed-file
         "docker-cli-plugins"
         (with-imported-modules '((guix build utils))
           #~(begin
               (use-modules (guix build utils) (ice-9 ftw))
               (mkdir-p #$output)
               (for-each
                (lambda (package)
                  (let* ((directory
                          (string-append package "/lib/docker/cli-plugins"))
                         (names
                          (and (file-exists? directory)
                               (scandir directory
                                        (lambda (name)
                                          (and (string-prefix? "docker-" name)
                                               (> (string-length name) 7)))))))
                    (unless (and names (pair? names))
                      (error "Package provides no Docker CLI plugins" package))
                    (for-each
                     (lambda (name)
                       (let ((source (string-append directory "/" name))
                             (target (string-append #$output "/" name)))
                         (unless (and (eq? 'regular (stat:type (stat source)))
                                      (access? source X_OK))
                           (error "Docker CLI plugin is not executable" source))
                         (when (file-exists? target)
                           (error "Duplicate Docker CLI plugin" name
                                  (readlink target) source))
                         (symlink source target)))
                     names)))
                (list #$@plugins)))))))))

(define home-docker-cli-plugins-service-type
  (service-type
   (name 'home-docker-cli-plugins)
   (extensions
    (list (service-extension home-files-service-type
                             home-docker-cli-plugins-files)
          (service-extension home-profile-service-type
                             home-docker-cli-plugins-configuration-plugins)))
   (default-value (home-docker-cli-plugins-configuration))
   (description
    "Install Docker CLI plugin packages and manage @file{~/.docker/cli-plugins}.
Docker CLI must use its default configuration directory.  This service owns
the plugin directory and does not configure or run a Docker daemon.")))
