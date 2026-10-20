(use-modules (roquix build bun-build-system workspaces)
             (guix build syscalls)
             (guix build utils)
             (srfi srfi-64))

(define (workspace-lock . entries)
  (list (cons "workspaces" entries)))

(define fixture-lock
  (workspace-lock '("" ("name" . "fixture-root"))
                  '("packages/app" ("name" . "@fixture/app"))))

(test-begin "bun-workspaces")

(let ((workspaces (parse-bun-workspaces fixture-lock)))
  (test-equal "excludes the root package" 1 (length workspaces))
  (test-equal "parses a workspace package name"
              "@fixture/app"
              (bun-workspace-name (car workspaces)))
  (test-equal "parses a workspace directory"
              "packages/app"
              (bun-workspace-directory (car workspaces))))

(test-error "rejects a workspace directory traversal" #t
            (parse-bun-workspaces
             (workspace-lock
              '("../outside" ("name" . "fixture-outside")))))

(test-error "rejects duplicate workspace names" #t
            (parse-bun-workspaces
             (workspace-lock '("packages/first" ("name" . "fixture"))
                             '("packages/second" ("name" . "fixture")))))

(test-error "rejects a missing workspace name" #t
            (parse-bun-workspaces
             (workspace-lock '("packages/unnamed"))))

(let ((workspaces
       (call-with-input-string
           "{// Bun text locks use JSONC.\n\"workspaces\":{\"packages/app\":{\"name\":\"fixture\",},},}"
         read-bun-workspaces)))
  (test-equal "parses comments and trailing commas in Bun text locks"
              "fixture"
              (bun-workspace-name (car workspaces))))

(let ((directory (mkdtemp! "/tmp/bun-workspaces-test.XXXXXX")))
  (dynamic-wind
    (const #t)
    (lambda ()
      (with-directory-excursion directory
        (mkdir-p "packages/app")
        (call-with-output-file "bun.lock"
          (lambda (port)
            (display
             "{\"workspaces\":{\"packages/app\":{\"name\":\"fixture\"}}}"
             port)))
        (link-bun-workspaces)
        (test-equal "links a workspace relative to node_modules"
                    "../packages/app"
                    (readlink "node_modules/fixture"))))
    (lambda ()
      (delete-file-recursively directory))))

(test-end "bun-workspaces")
