(use-modules (gnu home)
             (gnu services)
             (roquix home services t3code))

(let ((home (getenv "HOME")))
  (home-environment
   (services
    (list
     (service home-t3code-service-type
              (home-t3code-configuration
               (service-name 't3code-personal)
               (port 3773)
               (data-directory (string-append home "/.t3-personal"))))
     (service home-t3code-service-type
              (home-t3code-configuration
               (service-name 't3code-work)
               (port 4773)
               (data-directory (string-append home "/.t3-work"))))))))
