(define-module (roquix packages opencode-npm-inputs)
  #:use-module (roquix packages bun-lock-inputs)
  #:export (%opencode-2.0.32-npm-inputs))

(define %opencode-2.0.32-npm-inputs
  (or (lookup-bun-lock-inputs '%opencode-2.0.32-npm-inputs)
      (error "missing imported OpenCode Bun lock inputs")))
