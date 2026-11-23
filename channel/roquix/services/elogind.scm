(define-module (roquix services elogind)
  #:use-module (gnu services)
  #:use-module (gnu services base)
  #:use-module (gnu services desktop)
  #:use-module (gnu system file-systems)
  #:use-module (srfi srfi-1)
  #:export (unified-elogind-service-type))

;; With cgroup2 mounted at /sys/fs/cgroup, elogind manages sessions on v2.
;; The additional named v1 hierarchy would make Slurm detect hybrid mode.
;; https://github.com/elogind/elogind/blob/v257.14/src/shared/cgroup-setup.c
(define (unified-elogind-mounts config)
  (remove (lambda (fs)
            (equal? (file-system-mount-point fs) "/sys/fs/cgroup/elogind"))
          %elogind-file-systems))

(define unified-elogind-service-type
  (let ((base (remove-service-extensions elogind-service-type
                                         (list file-system-service-type))))
    (service-type
     (inherit base)
     (extensions (cons (service-extension file-system-service-type
                                          unified-elogind-mounts)
                       (service-type-extensions base))))))
