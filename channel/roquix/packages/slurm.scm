(define-module (roquix packages slurm)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages parallel)
  #:use-module (guix packages))

(define-public slurm-sview
  (package
    (inherit slurm)
    (name "slurm-sview")
    (inputs (modify-inputs (package-inputs slurm)
              (prepend gtk+-2)))
    (synopsis "Slurm workload manager with the sview graphical interface")
    (description
     "This build of Slurm includes sview, a GTK+ interface for viewing
and managing jobs, nodes, partitions, and reservations on a Slurm cluster.")))
