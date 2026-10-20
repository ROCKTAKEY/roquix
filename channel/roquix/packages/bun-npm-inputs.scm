(define-module (roquix packages bun-npm-inputs)
  #:use-module (roquix packages bun-lock-inputs)
  #:export (%bun-1.0.7-npm-inputs %bun-1.0.30-npm-inputs
                                  %bun-1.1.4-npm-inputs
                                  %bun-1.1.26-npm-inputs
                                  %bun-1.1.30-npm-inputs
                                  %bun-1.1.38-npm-inputs
                                  %bun-1.2.0-npm-inputs
                                  %bun-1.2.17-npm-inputs
                                  %bun-1.3.1-npm-inputs
                                  %bun-1.3.13-npm-inputs
                                  %bun-1.3.14-npm-inputs
                                  %bun-1.0.7-all-npm-inputs
                                  %bun-1.0.30-all-npm-inputs
                                  %bun-1.1.4-all-npm-inputs
                                  %bun-1.1.26-all-npm-inputs
                                  %bun-1.1.30-all-npm-inputs
                                  %bun-1.1.38-all-npm-inputs
                                  %bun-1.2.0-all-npm-inputs
                                  %bun-1.2.17-all-npm-inputs
                                  %bun-1.3.1-all-npm-inputs
                                  %bun-1.3.13-all-npm-inputs
                                  %bun-1.3.14-all-npm-inputs))

(define (lock-inputs name)
  (or (lookup-bun-lock-inputs name)
      (error "missing imported Bun lock inputs" name)))

(define %bun-1.0.7-npm-inputs
  (lock-inputs '%bun-1.0.7-npm-inputs))
(define %bun-1.0.7-bun-error-npm-inputs
  (lock-inputs '%bun-1.0.7-bun-error-npm-inputs))
(define %bun-1.0.7-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.0.7-node-fallbacks-npm-inputs))

(define %bun-1.0.30-npm-inputs
  (lock-inputs '%bun-1.0.30-npm-inputs))
(define %bun-1.0.30-bun-error-npm-inputs
  (lock-inputs '%bun-1.0.30-bun-error-npm-inputs))
(define %bun-1.0.30-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.0.30-node-fallbacks-npm-inputs))

(define %bun-1.1.4-npm-inputs
  (lock-inputs '%bun-1.1.4-npm-inputs))
(define %bun-1.1.4-bun-error-npm-inputs
  (lock-inputs '%bun-1.1.4-bun-error-npm-inputs))
(define %bun-1.1.4-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.1.4-node-fallbacks-npm-inputs))

(define %bun-1.1.26-npm-inputs
  (lock-inputs '%bun-1.1.26-npm-inputs))
(define %bun-1.1.26-bun-error-npm-inputs
  (lock-inputs '%bun-1.1.26-bun-error-npm-inputs))
(define %bun-1.1.26-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.1.26-node-fallbacks-npm-inputs))

(define %bun-1.1.30-npm-inputs
  (lock-inputs '%bun-1.1.30-npm-inputs))
(define %bun-1.1.30-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.1.30-node-fallbacks-npm-inputs))

(define %bun-1.1.38-npm-inputs
  (lock-inputs '%bun-1.1.38-npm-inputs))
(define %bun-1.1.38-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.1.38-node-fallbacks-npm-inputs))

(define %bun-1.2.0-npm-inputs
  (lock-inputs '%bun-1.2.0-npm-inputs))
(define %bun-1.2.0-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.2.0-node-fallbacks-npm-inputs))

(define %bun-1.2.17-npm-inputs
  (lock-inputs '%bun-1.2.17-npm-inputs))
(define %bun-1.2.17-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.2.17-node-fallbacks-npm-inputs))

(define %bun-1.3.1-npm-inputs
  (lock-inputs '%bun-1.3.1-npm-inputs))
(define %bun-1.3.1-bun-error-npm-inputs
  (lock-inputs '%bun-1.3.1-bun-error-npm-inputs))
(define %bun-1.3.1-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.3.1-node-fallbacks-npm-inputs))

(define %bun-1.3.13-npm-inputs
  (lock-inputs '%bun-1.3.13-npm-inputs))
(define %bun-1.3.13-bun-error-npm-inputs
  (lock-inputs '%bun-1.3.13-bun-error-npm-inputs))
(define %bun-1.3.13-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.3.13-node-fallbacks-npm-inputs))

(define %bun-1.3.14-npm-inputs
  (lock-inputs '%bun-1.3.14-npm-inputs))
(define %bun-1.3.14-bun-error-npm-inputs
  (lock-inputs '%bun-1.3.14-bun-error-npm-inputs))
(define %bun-1.3.14-node-fallbacks-npm-inputs
  (lock-inputs '%bun-1.3.14-node-fallbacks-npm-inputs))

(define %bun-1.0.7-all-npm-inputs
  (append %bun-1.0.7-npm-inputs %bun-1.0.7-bun-error-npm-inputs
          %bun-1.0.7-node-fallbacks-npm-inputs))

(define %bun-1.0.30-all-npm-inputs
  (append %bun-1.0.30-npm-inputs %bun-1.0.30-bun-error-npm-inputs
          %bun-1.0.30-node-fallbacks-npm-inputs))

(define %bun-1.1.4-all-npm-inputs
  (append %bun-1.1.4-npm-inputs %bun-1.1.4-bun-error-npm-inputs
          %bun-1.1.4-node-fallbacks-npm-inputs))

(define %bun-1.1.26-all-npm-inputs
  (append %bun-1.1.26-npm-inputs %bun-1.1.26-bun-error-npm-inputs
          %bun-1.1.26-node-fallbacks-npm-inputs))

(define %bun-1.1.30-all-npm-inputs
  (append %bun-1.1.30-npm-inputs %bun-1.1.26-bun-error-npm-inputs
          %bun-1.1.30-node-fallbacks-npm-inputs))

(define %bun-1.1.38-all-npm-inputs
  (append %bun-1.1.38-npm-inputs %bun-1.1.26-bun-error-npm-inputs
          %bun-1.1.38-node-fallbacks-npm-inputs))

(define %bun-1.2.0-all-npm-inputs
  (append %bun-1.2.0-npm-inputs %bun-1.1.26-bun-error-npm-inputs
          %bun-1.2.0-node-fallbacks-npm-inputs))

(define %bun-1.2.17-all-npm-inputs
  (append %bun-1.2.17-npm-inputs %bun-1.1.26-bun-error-npm-inputs
          %bun-1.2.17-node-fallbacks-npm-inputs))

(define %bun-1.3.1-all-npm-inputs
  (append %bun-1.3.1-npm-inputs %bun-1.3.1-bun-error-npm-inputs
          %bun-1.3.1-node-fallbacks-npm-inputs))

(define %bun-1.3.13-all-npm-inputs
  (append %bun-1.3.13-npm-inputs %bun-1.3.13-bun-error-npm-inputs
          %bun-1.3.13-node-fallbacks-npm-inputs))

(define %bun-1.3.14-all-npm-inputs
  (append %bun-1.3.14-npm-inputs %bun-1.3.14-bun-error-npm-inputs
          %bun-1.3.14-node-fallbacks-npm-inputs))
