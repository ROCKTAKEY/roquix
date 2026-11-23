(define-module (roquix packages slurm)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages parallel)
  #:use-module (guix packages))

(define-public slurm-sview
  (package
    (inherit slurm-23.11)
    (name "slurm-sview")
    (version "23.11.10")
    (source
     (origin
       (inherit (package-source slurm-23.11))
       (uri (string-append "https://download.schedmd.com/slurm/slurm-"
                           version ".tar.bz2"))
       (sha256
        (base32 "0gf7x85bzpkrx87mb16wyiyvkjxqq01sbajsjxwrspyi2v675hgr"))))
    (inputs (modify-inputs (package-inputs slurm-23.11)
              (prepend gtk+-2)))
    (synopsis "Slurm workload manager with the sview graphical interface")
    (description
     "This build of Slurm includes sview, a GTK+ interface for viewing
and managing jobs, nodes, partitions, and reservations on a Slurm cluster.")))
