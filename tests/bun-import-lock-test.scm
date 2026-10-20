(use-modules (guix build utils)
             (guix build syscalls)
             (guix import bun lock)
             (guix utils)
             (ice-9 textual-ports)
             (srfi srfi-64))

(define integrity
  "sha512-41Cifkg6e8TylSpdtTpeLVMqvSBEVzTttHvERD741+pnZ8ANv0004MRL43QKPDlK9cGvNp6NZWZUBlbGXYxxng==")

(define other-integrity
  "sha512-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA==")

(define (expression->string expression)
  (call-with-output-string
    (lambda (port)
      (write expression port))))

(define (fixture-lock packages)
  `(("lockfileVersion" . 1)
    ("workspaces" . ())
    ("packages" . ,packages)))

(test-begin "bun-import-lock")

(test-equal "Wyhash matches Bun for empty input"
            #x409638ee2bde459
            (wyhash "" 0))
(test-equal "Wyhash matches Bun for short input"
            #xa8412d091b5fe0a9
            (wyhash "a" 1))
(test-equal "Wyhash matches Bun for remote tarball URL"
            #xcc22f6f3508ed8d0
            (wyhash "https://packages.example/snapshot.tgz"))

(let* ((lock
        `(("lockfileVersion" . 1)
          ("workspaces"
           . (("" . (("dependencies"
                      . (("is-number" . "7.0.0")))))))
          ("packages"
           . (("is-number"
               . #("is-number@7.0.0" "" ()
                   ,integrity))
              ("@scope/tool"
               . #("@scope/tool@1.2.3" "" ()
                   ,integrity))
              ("snapshot"
               . #("snapshot@https://packages.example/snapshot.tgz"
                   ()
                   ,integrity))
              ("workspace"
               . #("workspace@workspace:packages/workspace"))))))
       (rendered
        (expression->string
         (render-bun-lock-definition
          '%fixture-npm-inputs
          (parse-bun-lock lock)))))
  (test-assert "renders registry package URL"
               (string-contains
                rendered
                "https://registry.npmjs.org/@scope/tool/-/tool-1.2.3.tgz"))
  (test-assert "renders registry cache directory"
               (string-contains
                rendered
                "@scope/tool@1.2.3@@registry.npmjs.org@@@1"))
  (test-assert "renders Bun-compatible remote tarball cache"
               (string-contains
                rendered
                "@T@cc22f6f3508ed8d0@@@1"))
  (test-assert "excludes workspace package origins"
               (not (string-contains rendered "workspace:packages"))))

(for-each
 (lambda (name)
   (let* ((url (string-append "https://registry.example/" name "/-/tool-1.2.3.tgz"))
          (rendered
           (expression->string
            (render-bun-lock-definition
             '%custom-npm-inputs
             (parse-bun-lock
              (fixture-lock
               `((,name . #(,(string-append name "@1.2.3")
                            ,url () ,integrity)))))))))
     (test-assert "preserves the locked custom registry URL"
                  (string-contains rendered url))
     (test-assert "uses the custom registry host in the cache name"
                  (string-contains rendered
                                   (string-append name "@1.2.3@@registry.example@@@1")))))
 '("tool" "@scope/tool"))

(test-error "rejects malformed integrity" #t
            (parse-bun-lock
             (fixture-lock
              `(("broken"
                 . #("broken@1.0.0" "" ()
                     "sha512-nope"))))))

(let* ((commit "912ca63e26c51429d3e6799aa2a6ab079b188fd8")
       (resolution
        (string-append "github:oven-sh/bun.report#" commit))
       (lock
        `(("lockfileVersion" . 1)
          ("workspaces"
           . (("" . (("devDependencies"
                      . (("bun-tracestrings"
                          . ,resolution)))))))
          ("packages"
           . (("bun-tracestrings"
               . #("bun-tracestrings@github:oven-sh/bun.report#912ca63"
                   ()
                   "oven-sh-bun.report-912ca63"
                   ,integrity))))))
       (rendered
        (expression->string
         (render-bun-lock-definition
          '%fixture-npm-inputs
          (parse-bun-lock lock)))))
  (test-assert "renders Git source"
               (string-contains rendered "(method git-fetch)"))
  (test-assert "retains full Git commit"
               (string-contains rendered commit))
  (test-assert "marks Git checkout as a directory"
               (string-contains rendered
                                "(source-kind (quote directory))")))

(for-each
 (lambda (url)
   (test-assert "renders a pinned generic Git origin and Bun cache key"
     (let* ((commit "3a1288830817d13da39e9231302261896f8721ea")
            (resolution (string-append "tool@git+" url "#" commit))
            (rendered
             (expression->string
              (render-bun-lock-definition
               '%git-npm-inputs
               (parse-bun-lock
                (fixture-lock
                 `(("tool" . #(,resolution () ,commit)))))))))
       (and (string-contains rendered "(method git-fetch)")
            (string-contains rendered (string-append "(url \"" url "\")"))
            (string-contains rendered (string-append "(commit \"" commit "\")"))
            (string-contains rendered (string-append "@G@" commit "\""))
            (string-contains rendered "(source-kind (quote directory))")))))
 '("https://git.example/team/tool.git" "ssh://git@git.example/team/tool.git"))

(test-assert "uses a repository basename for scoped Git package file names"
  (let* ((commit "3a1288830817d13da39e9231302261896f8721ea")
         (rendered
          (expression->string
           (render-bun-lock-definition
            '%scoped-git-inputs
            (parse-bun-lock
             (fixture-lock
              `(("@scope/alias"
                 . #(,(string-append "@scope/alias@git+https://git.example/team/tool.git#" commit)
                     () ,commit)))))))))
    (string-contains rendered "(git-file-name \"tool\"")))

(test-error "rejects unpinned generic Git dependencies" #t
  (parse-bun-lock
   (fixture-lock
    '(("tool" . #("tool@git+https://git.example/tool.git#main" () "main"))))))

(let* ((first "3a1288830817d13da39e9231302261896f8721ea")
       (second "912ca63e26c51429d3e6799aa2a6ab079b188fd8")
       (repository "tool@git+https://git.example/tool.git#"))
  (test-equal "keeps different commits of one Git repository distinct"
    2
    (length
     (parse-bun-lock
      (fixture-lock
       `(("first" . #(,(string-append repository first) () ,first))
         ("second" . #(,(string-append repository second) () ,second)))))))
  (test-error "rejects inconsistent Git commit and cache identity" #t
    (parse-bun-lock
     (fixture-lock
      `(("tool" . #(,(string-append repository first) () ,second)))))))

(let* ((lock
        (fixture-lock
         `(("first"
            . #("is-number@7.0.0" "" ()
                ,integrity))
           ("duplicate"
            . #("is-number@7.0.0" "" ()
                ,other-integrity)))))
       (rendered
        (expression->string
         (render-bun-lock-definition
          '%fixture-npm-inputs
          (parse-bun-lock lock)))))
  (test-equal "deduplicates one tarball origin"
              1
              (let loop ((start 0)
                         (count 0))
                (let ((index
                       (string-contains rendered
                                        "(bun-lock-package"
                                        start)))
                  (if index
                      (loop (+ index 1) (+ count 1))
                      count))))
  (test-assert "retains all install paths"
               (and
                (string-contains rendered
                                 "node_modules/duplicate")
                (string-contains rendered
                                 "node_modules/first"))))

(let* ((lock
        `(("lockfileVersion" . 1)
          ("workspaces"
           . (("packages/app"
               . (("name" . "fixture-app")))))
          ("packages"
           . (("parent"
               . #("parent@1.0.0" "" ()
                   ,integrity))
              ("parent/child"
               . #("child@1.0.0" "" ()
                   ,integrity))
              ("fixture-app/workspace-child"
               . #("workspace-child@1.0.0" "" ()
                   ,integrity))
              ("@scope/parent"
               . #("@scope/parent@1.0.0" "" ()
                   ,integrity))
              ("@scope/parent/@scope/child"
               . #("@scope/child@1.0.0" "" ()
                   ,integrity))))))
       (rendered
        (expression->string
         (render-bun-lock-definition
          '%fixture-npm-inputs
          (parse-bun-lock lock)))))
  (test-assert "derives nested package install paths"
               (and
                (string-contains
                 rendered
                 "node_modules/parent/node_modules/child")
                (string-contains
                 rendered
                 "node_modules/@scope/parent/node_modules/@scope/child")))
  (test-assert "derives workspace package install paths"
               (string-contains
                rendered
                "packages/app/node_modules/workspace-child")))

(let ((directory
       (mkdtemp! "/tmp/bun-import-lock-test.XXXXXX")))
  (dynamic-wind
    (const #t)
    (lambda ()
      (mkdir-p (string-append directory "/packages/app"))
      (call-with-output-file
          (string-append directory "/package.json")
        (lambda (port)
          (display
           "{\"name\":\"@scope/fixture\",\"version\":\"2.3.4\"}"
           port)))
      (call-with-output-file
          (string-append directory "/packages/app/package.json")
        (lambda (port)
          (display
           "{\"name\":\"fixture-app\",\"version\":\"1.0.0\"}"
           port)))
      (let ((lock
             (string-append directory
                            "/packages/app/bun.lock")))
        (call-with-output-file lock
          (lambda (port)
            (display
             "{// parsed by Guile, not Bun\n\
\"lockfileVersion\":1,\"workspaces\":{},\"packages\":{},}"
             port)))
        (let ((bun-called? #f)
              (expression
               (bun-lock-file->expression
                lock
                #:project "packages/app"
                #:bun-command
                (lambda ()
                  (set! bun-called? #t)
                  (error "text lock must not execute Bun")))))
          (test-equal "derives definition from package name and version"
                      '%scope-fixture-2.3.4-app-npm-inputs
                      (cadr expression))
          (test-assert "text lock does not resolve or execute Bun"
                       (not bun-called?)))))
    (lambda ()
      (delete-file-recursively directory))))

(let ((directory
       (mkdtemp! "/tmp/bun-import-lock-binary-test.XXXXXX")))
  (dynamic-wind
    (const #t)
    (lambda ()
      (let ((fake-bun
             (string-append directory "/fake-bun"))
            (lock
             (string-append directory "/bun.lockb"))
            (calls 0))
        (call-with-output-file
            (string-append directory "/package.json")
          (lambda (port)
            (display
             "{\"name\":\"binary-fixture\",\"version\":\"1.2.3\"}"
             port)))
        (call-with-output-file lock (const #t))
        (call-with-output-file fake-bun
          (lambda (port)
            (display
             "#!/bin/sh\n\
while test \"$#\" -gt 0; do\n\
  if test \"$1\" = --cwd; then\n\
    shift\n\
    directory=$1\n\
  fi\n\
  shift\n\
done\n\
printf '%s\\n' '{\"lockfileVersion\":1,\"workspaces\":{},\"packages\":{}}' \
> \"$directory/bun.lock\"\n"
             port)))
        (chmod fake-bun #o755)
        (let ((expression
               (bun-lock-file->expression
                lock
                #:source directory
                #:bun-command
                (lambda ()
                  (set! calls (+ calls 1))
                  fake-bun))))
          (test-equal "binary lock executes the selected Bun once"
                      1
                      calls)
          (test-equal "binary lock retains automatic definition naming"
                      '%binary-fixture-1.2.3-npm-inputs
                      (cadr expression)))))
    (lambda ()
      (delete-file-recursively directory))))

(let ((directory
       (mkdtemp! "/tmp/bun-import-lock-bun-version-test.XXXXXX")))
  (dynamic-wind
    (const #t)
    (lambda ()
      (mkdir-p (string-append directory "/src"))
      (call-with-output-file
          (string-append directory "/package.json")
        (lambda (port)
          (display "{\"name\":\"bun\",\"version\":\"0.0.0\"}" port)))
      (call-with-output-file
          (string-append directory "/CMakeLists.txt")
        (lambda (port)
          (display "set(Bun_VERSION \"1.1.26\")" port)))
      (call-with-output-file
          (string-append directory "/bun.lock")
        (lambda (port)
          (display
           "{\"lockfileVersion\":1,\"workspaces\":{},\"packages\":{}}"
           port)))
      (test-equal "derives Bun version from CMake metadata"
                  '%bun-1.1.26-npm-inputs
                  (bun-lock-definition-name
                   (string-append directory "/bun.lock"))))
    (lambda ()
      (delete-file-recursively directory))))

(let ((directory
       (mkdtemp! "/tmp/bun-import-lock-workspace-version-test.XXXXXX")))
  (dynamic-wind
    (const #t)
    (lambda ()
      (mkdir-p (string-append directory "/packages/example"))
      (call-with-output-file
          (string-append directory "/package.json")
        (lambda (port)
          (display
           "{\"name\":\"example\",\"private\":true,\
\"workspaces\":[\"packages/*\"]}"
           port)))
      (call-with-output-file
          (string-append directory "/packages/example/package.json")
        (lambda (port)
          (display
           "{\"name\":\"example\",\"version\":\"4.5.6\"}"
           port)))
      (call-with-output-file
          (string-append directory "/bun.lock")
        (lambda (port)
          (display
           "{\"lockfileVersion\":1,\"workspaces\":{},\"packages\":{}}"
           port)))
      (test-equal "derives root version from same-name workspace"
                  '%example-4.5.6-npm-inputs
                  (bun-lock-definition-name
                   (string-append directory "/bun.lock"))))
    (lambda ()
      (delete-file-recursively directory))))

(let ((directory
       (mkdtemp! "/tmp/bun-import-lock-legacy-version-test.XXXXXX")))
  (dynamic-wind
    (const #t)
    (lambda ()
      (mkdir-p (string-append directory "/src"))
      (call-with-output-file
          (string-append directory "/package.json")
        (lambda (port)
          (display "{\"name\":\"bun\",\"version\":\"0.0.0\"}" port)))
      (call-with-output-file
          (string-append directory "/src/__global.zig")
        (lambda (port)
          (display
           ".major = 1,\n.minor = 0,\n.patch = build_id,\n"
           port)))
      (call-with-output-file
          (string-append directory "/src/build-id")
        (lambda (port)
          (display "7\n" port)))
      (call-with-output-file
          (string-append directory "/bun.lockb")
        (const #t))
      (test-equal "derives legacy Bun version from build metadata"
                  '%bun-1.0.7-npm-inputs
                  (bun-lock-definition-name
                   (string-append directory "/bun.lockb")
                   #:source directory)))
    (lambda ()
      (delete-file-recursively directory))))

(let ((runner (test-runner-current)))
  (test-end "bun-import-lock")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
