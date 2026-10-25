(define-module (roquix packages sway)
  #:use-module ((gnu packages window-management) #:prefix guix:)
  #:use-module (guix packages)
  #:use-module (roquix packages json-c))

(define-public sway
  (package
    (inherit guix:sway)
    (inputs
     (modify-inputs (package-inputs guix:sway)
       (replace "json-c" json-c)))))
