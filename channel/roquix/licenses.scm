(define-module (roquix licenses)
  #:use-module (guix licenses))

(define license (@@ (guix licenses) license))

(define-public unicode3
  (license "Unicode"
           "https://directory.fsf.org/wiki/License:Unicode-v3"
           "https://www.gnu.org/licenses/license-list.html#Unicodev3"))
