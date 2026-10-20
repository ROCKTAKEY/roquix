(define-module (roquix packages opencode-npm-inputs)
  #:use-module (roquix packages bun-lock-inputs)
  #:export (%opencode-1.18.3-npm-inputs))

(define %opencode-1.18.3-npm-inputs
  (or (lookup-bun-lock-inputs '%opencode-1.18.3-npm-inputs)
      (error "missing imported OpenCode Bun lock inputs")))
