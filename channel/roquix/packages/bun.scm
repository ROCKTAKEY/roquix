(define-module (roquix packages bun)
  #:use-module (roquix packages bun-bootstrap)
  #:use-module (guix packages))

;; Keep the public package in a small, stable module while the complete
;; multi-stage source bootstrap remains isolated in bun-bootstrap.scm.
(define-public bun bun-bootstrap-1.3.14)
