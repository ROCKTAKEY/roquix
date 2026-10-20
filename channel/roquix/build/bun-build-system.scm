(define-module (roquix build bun-build-system)
  #:use-module (ice-9 match)
  #:use-module (json)
  #:use-module (srfi srfi-1)
  #:use-module ((guix build copy-build-system)
                #:prefix copy:)
  #:use-module ((guix build gnu-build-system)
                #:prefix gnu:)
  #:use-module ((guix build union)
                #:select (relative-file-name))
  #:use-module (guix build utils)
  #:export (%standard-phases %standard-bun-node-modules-phases bun-build
                             bun-node-modules-layout-build
                             bun-node-modules-build))

(define (set-bun-environment-at home)
  (mkdir-p home)
  (setenv "HOME" home)
  (for-each (lambda (name)
              (let ((directory (string-append home "/" name)))
                (mkdir-p directory)
                (setenv name directory)))
            '("XDG_CACHE_HOME" "XDG_CONFIG_HOME" "XDG_DATA_HOME"
              "XDG_STATE_HOME"))
  (let ((cache (string-append home "/install-cache")))
    (mkdir-p cache)
    (setenv "BUN_INSTALL_CACHE_DIR" cache)))

(define (set-bun-environment . _)
  (set-bun-environment-at (string-append (getcwd) "/.bun-home")) #t)

(define (link-bun-workspaces . arguments)
  (apply (module-ref (resolve-interface '(roquix build bun-build-system
                                                 workspaces))
                     'link-bun-workspaces) arguments))

(define (set-node-modules-environment . _)
  ;; Keep caches outside the source tree so the final collection phase cannot
  ;; mistake a cache directory for a package's node_modules.
  (set-bun-environment-at (string-append (getenv "NIX_BUILD_TOP") "/.bun-home"))
  #t)

(define* (populate-npm-cache #:key inputs
                             npm-archives
                             npm-cache-directories
                             npm-source-kinds
                             #:allow-other-keys)
  (unless (= (length npm-archives)
             (length npm-cache-directories)
             (length npm-source-kinds))
    (error "npm source and cache metadata counts differ"))
  (let ((cache (string-append (getenv "NIX_BUILD_TOP") "/npm-cache"))
        (tar (search-input-file inputs "/bin/tar")))
    (mkdir-p cache)
    (for-each (lambda (archive relative source-kind)
                (let ((destination (string-append cache "/" relative)))
                  (mkdir-p destination)
                  (case source-kind
                    ((tarball)
                     (invoke tar
                             "-xzf"
                             archive
                             "--strip-components=1"
                             "-C"
                             destination))
                    ((directory)
                     (copy-recursively archive destination))
                    (else (error "unsupported npm source kind" source-kind)))))
              npm-archives npm-cache-directories npm-source-kinds)
    (setenv "BUN_INSTALL_CACHE_DIR" cache)) #t)

(define* (install-dependencies #:key inputs install-flags #:allow-other-keys)
  (let ((bun (search-input-file inputs "/bin/bun")))
    (apply invoke
           bun
           "install"
           "--cache-dir"
           (getenv "BUN_INSTALL_CACHE_DIR")
           ;; A missing origin must fail in the isolated build instead of
           ;; consulting the public registry.
           "--registry"
           "http://127.0.0.1:9"
           install-flags)) #t)

(define* (install-node-modules-output #:key inputs outputs #:allow-other-keys)
  (let ((out (assoc-ref outputs "out"))
        (find (search-input-file inputs "/bin/find"))
        (cp (search-input-file inputs "/bin/cp")))
    (mkdir-p out)
    (invoke find
            "."
            "-type"
            "d"
            "-name"
            "node_modules"
            "-exec"
            cp
            "-R"
            "--parents"
            "{}"
            out
            ";")) #t)

(define %standard-bun-node-modules-phases
  `((unpack unquote
            (assoc-ref gnu:%standard-phases
                       'unpack))
    (set-bun-environment unquote set-node-modules-environment)
    (populate-npm-cache unquote populate-npm-cache)
    (install-dependencies unquote install-dependencies)
    (install unquote install-node-modules-output)))

(define* (bun-node-modules-build #:key inputs
                                 (phases %standard-bun-node-modules-phases)
                                 #:allow-other-keys #:rest arguments)
  "Install and collect node_modules by applying PHASES with INPUTS."
  (apply gnu:gnu-build
         #:inputs inputs
         #:phases phases
         arguments))

(define (read-package-bins package-directory)
  (let* ((manifest (call-with-input-file (string-append package-directory
                                                        "/package.json")
                     json->scm))
         (name (assoc-ref manifest "name"))
         (bin (assoc-ref manifest "bin")))
    (cond
      ((string? bin)
       (list (cons (basename name) bin)))
      ((list? bin)
       bin)
      (else '()))))

(define (install-package-bin-links output install-path)
  (let* ((package-directory (string-append output "/" install-path))
         (modules-directory (dirname package-directory))
         (bin-directory (string-append modules-directory "/.bin")))
    (when (file-exists? (string-append package-directory "/package.json"))
      (for-each (match-lambda
                  ((name . relative) (let ((target (string-append
                                                    package-directory "/"
                                                    relative))
                                           (link (string-append bin-directory
                                                                "/" name)))
                                       (when (file-exists? target)
                                         (mkdir-p bin-directory)
                                         (when (file-exists? link)
                                           (delete-file link))
                                         (symlink (relative-file-name
                                                   bin-directory target) link)))))
                (read-package-bins package-directory)))))

(define* (bun-node-modules-layout-build #:key inputs
                                        outputs
                                        npm-sources
                                        npm-install-paths
                                        npm-source-kinds
                                        native-files
                                        #:allow-other-keys)
  "Materialize already parsed Bun lock paths without invoking a package manager."
  (unless (= (length npm-sources)
             (length npm-install-paths)
             (length npm-source-kinds))
    (error "npm layout source metadata counts differ"))
  (let ((output (assoc-ref outputs "out"))
        (tar (search-input-file inputs "/bin/tar")))
    (mkdir-p output)
    (for-each (lambda (source paths source-kind)
                (for-each (lambda (path)
                            (let ((destination (string-append output "/" path)))
                              (mkdir-p destination)
                              (case source-kind
                                ((tarball)
                                 (invoke tar
                                         "-xzf"
                                         source
                                         "--strip-components=1"
                                         "-C"
                                         destination))
                                ((directory)
                                 (copy-recursively source destination))
                                (else (error "unsupported npm source kind"
                                             source-kind))))) paths))
              npm-sources npm-install-paths npm-source-kinds)
    (let ((native (find-files output
                              (lambda (file stat)
                                (and (eq? 'regular
                                          (stat:type stat))
                                     (elf-file? file))))))
      (case native-files
        ((keep)
         #t)
        ((delete)
         (for-each delete-file native))
        ((reject)
         (unless (null? native)
           (error "native executable found in node_modules" native)))))
    (for-each (lambda (path)
                (install-package-bin-links output path))
              (delete-duplicates (append-map identity npm-install-paths)))) #t)

(define (node-module-file? file stat)
  (and (eq? 'regular
            (stat:type stat))
       (or (string-prefix? "./node_modules/" file)
           (string-contains file "/node_modules/"))))

(define* (install-node-modules #:key inputs
                               (node-modules-input "node_modules")
                               #:allow-other-keys)
  (let ((modules (and node-modules-input
                      (assoc-ref inputs node-modules-input))))
    (if modules
        (begin
          (format #t "installing lock-derived node_modules from ~a~%" modules)
          (let ((null (open-output-file "/dev/null")))
            (copy-recursively modules "."
                              #:log null)
            (close-port null))
          (invoke "chmod" "-R" "u+w" ".")
          (for-each patch-shebang
                    (find-files "." node-module-file?)))
        (format #t "no node_modules input named ~s~%" node-modules-input))) #t)

(define (normalize-command command)
  (cond
    ((not command)
     #f)
    ((string? command)
     (list "run" command))
    ((list? command)
     command)
    (else (error "invalid Bun command" command))))

(define (invoke-bun inputs command)
  (let ((bun (string-append (assoc-ref inputs "bun") "/bin/bun")))
    (apply invoke bun command)))

(define* (build #:key inputs build-command #:allow-other-keys)
  (let ((command (normalize-command build-command)))
    (if command
        (invoke-bun inputs command)
        (format #t "no Bun build command configured~%"))) #t)

(define* (check #:key inputs tests? test-command #:allow-other-keys)
  (if tests?
      (let ((command (normalize-command test-command)))
        (if command
            (invoke-bun inputs command)
            (format #t "no Bun test command configured~%")))
      (format #t "test suite not run~%")) #t)

(define copy-install
  (assoc-ref copy:%standard-phases
             'install))

(define* (install #:key install-plan outputs #:allow-other-keys)
  (unless (list? install-plan)
    (error "the bun-build-system requires an explicit install plan"))
  (copy-install #:install-plan install-plan
                #:outputs outputs))

(define %standard-phases
  (modify-phases gnu:%standard-phases
    (delete 'bootstrap)
    (delete 'configure)
    (add-after 'unpack 'set-bun-environment
      set-bun-environment)
    (add-before 'build 'install-node-modules
      install-node-modules)
    (add-after 'install-node-modules 'link-bun-workspaces
      link-bun-workspaces)
    (replace 'build
      build)
    (replace 'check
      check)
    (replace 'install
      install)))

(define* (bun-build #:key inputs
                    (phases %standard-phases)
                    #:allow-other-keys #:rest arguments)
  "Build a Bun application by applying PHASES with INPUTS."
  (apply gnu:gnu-build
         #:inputs inputs
         #:phases phases
         arguments))
