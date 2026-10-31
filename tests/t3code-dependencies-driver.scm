(use-modules (roquix build t3code-dependencies)
             (ice-9 match))

(match (cdr (command-line))
  (("office" target source) (install-office-sources target source))
  (("runtime" root destination selector variant)
   (stage-runtime-dependencies root destination selector #:variant variant)))
