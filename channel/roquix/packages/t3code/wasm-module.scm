(define-module (roquix packages t3code wasm-module)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-9)
  #:export (wasm-module wasm-module? wasm-module-crate wasm-module-stem
            wasm-module-destination wasm-module-features))

(define-record-type <wasm-module>
  (%make-wasm-module crate stem destination features)
  wasm-module?
  (crate wasm-module-crate)
  (stem wasm-module-stem)
  (destination wasm-module-destination)
  (features wasm-module-features))

(define (identifier? value)
  (and (string? value) (string-match "^[A-Za-z0-9_-]+$" value) #t))

(define* (wasm-module #:key crate stem destination (features '()))
  (unless (and (identifier? crate)
               (identifier? stem)
               (string? destination)
               (every identifier? (string-split destination #\/))
               (list? features)
               (every identifier? features))
    (error "Invalid Cargo/WASM binding configuration"
           crate stem destination features))
  (%make-wasm-module crate stem destination features))
