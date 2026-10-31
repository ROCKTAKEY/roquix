(use-modules (roquix packages t3code staging)
             (ice-9 match))

(match (cdr (command-line))
  (("office" target source) (stage-office-sources target source))
  (("runtime" root destination selector variant)
   (stage-runtime-dependencies root destination selector #:variant variant)))
