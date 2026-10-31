(use-modules (roquix packages t3code wasm-module)
             (srfi srfi-64))

(test-begin "t3code-wasm-module")

(let ((module (wasm-module #:crate "betteroffice-docx-edit"
                           #:stem "docx_edit"
                           #:destination "docx/src/wasm/generated/edit"
                           #:features '("wasm" "heap-stats"))))
  (test-assert "construction produces a parsed WASM module" (wasm-module? module))
  (test-equal "Cargo package names retain hyphens"
    "betteroffice-docx-edit" (wasm-module-crate module))
  (test-equal "binding stems retain underscores"
    "docx_edit" (wasm-module-stem module))
  (test-equal "binding destination is explicit"
    "docx/src/wasm/generated/edit" (wasm-module-destination module))
  (test-equal "features are individually named"
    '("wasm" "heap-stats") (wasm-module-features module)))

(for-each
 (lambda (arguments)
   (test-error "invalid module configuration fails at construction" #t
     (apply wasm-module arguments)))
 (list
  '(#:stem "edit" #:destination "docx/edit")
  '(#:crate "edit" #:stem "edit" #:destination "../edit")
  '(#:crate "edit" #:stem "edit" #:destination "/edit")
  '(#:crate "edit" #:stem "docx/edit" #:destination "docx/edit")
  '(#:crate "edit" #:stem "edit" #:destination "docx/edit"
    #:features "wasm,tiff")))

(let ((runner (test-runner-current)))
  (test-end "t3code-wasm-module")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
