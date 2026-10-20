(use-modules (roquix build-system bun)
             (srfi srfi-64))

(define workspace-module
  '(roquix build bun-build-system workspaces))

(define jsonc-module
  '(roquix build bun-build-system jsonc))

(test-begin "bun-build-system-modules")

(test-assert "application builds import workspace support"
  (member workspace-module %bun-build-system-modules))

(test-assert "application builds import Bun lock parsing support"
  (member jsonc-module %bun-build-system-modules))

(test-assert "node_modules materialization excludes application support"
  (and (not (member workspace-module
                    %bun-node-modules-build-system-modules))
       (not (member jsonc-module
                    %bun-node-modules-build-system-modules))))

(let ((runner (test-runner-current)))
  (test-end "bun-build-system-modules")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
