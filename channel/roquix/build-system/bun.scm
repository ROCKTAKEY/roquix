(define-module (roquix build-system bun)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix packages)
  #:use-module (guix records)
  #:use-module (guix search-paths)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages compression)
  #:export (%bun-build-system-modules %bun-node-modules-build-system-modules
                                      bun-build
                                      bun-build-system
                                      define-bun-lock-inputs
                                      bun-node-modules
                                      bun-node-modules-from-layout
                                      bun-lock-package
                                      bun-lock-package-name))

(define %bun-json-modules
  '((json)
    (json builder)
    (json parser)
    (json record)))

(define %bun-common-build-modules
  `((guix build copy-build-system)
    (guix build union)
    ,@%default-gnu-imported-modules))

(define %bun-node-modules-build-system-modules
  `(,@%bun-json-modules (roquix build bun-build-system)
    ,@%bun-common-build-modules))

(define %bun-build-system-modules
  `(,@%bun-json-modules (roquix build bun-build-system)
    (roquix build bun-build-system jsonc)
    (roquix build bun-build-system workspaces)
    ,@%bun-common-build-modules))

(define (default-bun)
  "Return the default Bun package, resolved lazily."
  (let ((module (resolve-interface '(roquix packages bun))))
    (module-ref module
                'bun)))

(define-record-type* <bun-lock-package> bun-lock-package make-bun-lock-package
  bun-lock-package?
  (name bun-lock-package-name)
  (version bun-lock-package-version)
  (cache-directory bun-lock-package-cache-directory)
  (install-paths bun-lock-package-install-paths
                 (default '()))
  (source-kind bun-lock-package-source-kind
               (default 'tarball))
  (source bun-lock-package-source))

(define-syntax define-bun-lock-inputs
  (syntax-rules (=>)
    ((_ lookup inputs ...)
     (define lookup
       (let ((table (make-hash-table)))
         (letrec-syntax ((record
                          (syntax-rules (=>)
                            ((_) #t)
                            ((_ (name => packages) rest (... ...))
                             (begin
                               (hashq-set! table 'name packages)
                               (record rest (... ...)))))))
           (record inputs ...)
           (lambda (name)
             "Return the bun-lock-package list registered for NAME."
             (hashq-ref table name))))))))

(define* (bun-node-modules source
                           lock-packages
                           #:key (name "bun-node-modules")
                           (bun (default-bun))
                           (install-flags '())
                           (frozen-lockfile? #t)
                           (ignore-scripts? #t)
                           (phases '(@ (roquix build bun-build-system)
                                       %standard-bun-node-modules-phases)))
  "Return a normal derivation that builds node_modules from LOCK-PACKAGES.

INSTALL-FLAGS are passed to `bun install'.  FROZEN-LOCKFILE? and
IGNORE-SCRIPTS? default to true so dependency resolution cannot update the
lockfile or execute package lifecycle scripts.  Every lockfile package source
is a separately authenticated origin and no network access is available to the
resulting derivation."
  (let ((archives (map bun-lock-package-source lock-packages))
        (cache-directories (map bun-lock-package-cache-directory lock-packages))
        (source-kinds (map bun-lock-package-source-kind lock-packages))
        (phase-expression (if (pair? phases)
                              (sexp->gexp phases) phases))
        (flags (append install-flags
                       (if frozen-lockfile?
                           '("--frozen-lockfile")
                           '())
                       (if ignore-scripts?
                           '("--ignore-scripts")
                           '())
                       '("--no-progress"))))
    (with-imported-modules %bun-node-modules-build-system-modules
                           (computed-file name
                                          #~(begin
                                              (use-modules (roquix build
                                                            bun-build-system)
                                                           (guix build utils))
                                              (setenv "PATH"
                                                      (string-append #+bash-minimal
                                                                     "/bin:"
                                                                     #+coreutils
                                                                     "/bin:"
                                                                     #+findutils
                                                                     "/bin:"
                                                                     #+gzip
                                                                     "/bin:"
                                                                     #+tar
                                                                     "/bin"))
                                              (bun-node-modules-build #:source #+source
                                                                      #:outputs
                                                                      (list (cons
                                                                             "out"
                                                                             #$output))
                                                                      #:inputs
                                                                      (list (cons
                                                                             "bun"
                                                                             #+bun)
                                                                            (cons
                                                                             "coreutils"
                                                                             #+coreutils)
                                                                            (cons
                                                                             "findutils"
                                                                             #+findutils)
                                                                            (cons
                                                                             "gzip"
                                                                             #+gzip)
                                                                            (cons
                                                                             "tar"
                                                                             #+tar))
                                                                      #:npm-archives
                                                                      (list #$@archives)
                                                                      #:npm-cache-directories '#$cache-directories
                                                                      #:npm-source-kinds '#$source-kinds
                                                                      #:install-flags '#$flags
                                                                      #:phases #$phase-expression))
                                          #:local-build? #t))))

(define* (bun-node-modules-from-layout lock-packages
                                       #:key (name "bun-node-modules-layout")
                                       (native-files 'keep))
  "Materialize the lock-derived install paths in LOCK-PACKAGES.

NATIVE-FILES is one of `keep', `delete', or `reject'.  This entry point exists
for a source-bootstrap stage that cannot invoke Bun before Bun itself exists."
  (unless (memq native-files
                '(keep delete reject))
    (error "invalid native file policy" native-files))
  (let ((sources (map bun-lock-package-source lock-packages))
        (install-paths (map bun-lock-package-install-paths lock-packages))
        (source-kinds (map bun-lock-package-source-kind lock-packages)))
    (with-imported-modules %bun-node-modules-build-system-modules
                           (computed-file name
                                          #~(begin
                                              (use-modules (roquix build
                                                            bun-build-system)
                                                           (guix build utils))
                                              (setenv "PATH"
                                                      (string-append #+bash-minimal
                                                                     "/bin:"
                                                                     #+coreutils
                                                                     "/bin:"
                                                                     #+gzip
                                                                     "/bin:"
                                                                     #+tar
                                                                     "/bin"))
                                              (bun-node-modules-layout-build
                                                                             #:outputs
                                                                             (list
                                                                              (cons
                                                                               "out"
                                                                               #$output))
                                                                             #:inputs
                                                                             (list
                                                                              (cons
                                                                               "coreutils"
                                                                               #+coreutils)

                                                                              (cons
                                                                               "gzip"
                                                                               #+gzip)

                                                                              (cons
                                                                               "tar"
                                                                               #+tar))
                                                                             #:npm-sources
                                                                             (list #$@sources)
                                                                             #:npm-install-paths '#$install-paths
                                                                             #:npm-source-kinds '#$source-kinds
                                                                             #:native-files '#$native-files))
                                          #:local-build? #t))))

(define* (lower name
                #:key source
                inputs
                native-inputs
                outputs
                system
                target
                (bun (default-bun))
                node-modules
                (node-modules-input "node_modules")
                #:allow-other-keys #:rest arguments)
  "Return a bag for NAME built with BUN and optional NODE-MODULES."
  (define private-keywords
    '(#:target #:bun #:node-modules #:inputs #:native-inputs))

  (and (not target)
       (bag (name name)
            (system system)
            (host-inputs `(,@(if source
                                 `(("source" ,source))
                                 '()) ,@inputs
                           ,@(standard-packages)))
            (build-inputs `(,@(if node-modules
                                  `((,node-modules-input ,node-modules))
                                  '()) ("bun" ,bun)
                            ,@native-inputs))
            (outputs outputs)
            (build bun-build)
            (arguments (strip-keyword-arguments private-keywords arguments)))))

(define* (bun-build name
                    inputs
                    #:key guile
                    source
                    (outputs '("out"))
                    (build-command ''("run" "build"))
                    (test-command ''("test"))
                    (install-plan #f)
                    (node-modules-input "node_modules")
                    (search-paths '())
                    (tests? #t)
                    (validate-runpath? #t)
                    (patch-shebangs? #t)
                    (strip-binaries? #t)
                    (strip-flags %strip-flags)
                    (strip-directories %strip-directories)
                    (phases '(@ (roquix build bun-build-system)
                                %standard-phases))
                    (system (%current-system))
                    (target #f)
                    (substitutable? #t)
                    allowed-references
                    disallowed-references
                    (imported-modules %bun-build-system-modules)
                    (modules '((roquix build bun-build-system)
                               (guix build utils))))
  "Build SOURCE with Bun and INPUTS."
  (define builder
    (with-imported-modules imported-modules
                           #~(begin
                               (use-modules #$@modules)

                               #$(with-build-variables inputs outputs
                                                       #~(bun-build #:source #+source
                                                          #:system #$system
                                                          #:outputs %outputs
                                                          #:inputs
                                                          %build-inputs
                                                          #:build-command #$(if
                                                                             (pair?
                                                                              build-command)
                                                                             (sexp->gexp
                                                                              build-command)
                                                                             build-command)
                                                          #:test-command #$(if
                                                                            (pair?
                                                                             test-command)
                                                                            (sexp->gexp
                                                                             test-command)
                                                                            test-command)
                                                          #:install-plan #$(if
                                                                            (pair?
                                                                             install-plan)
                                                                            (sexp->gexp
                                                                             install-plan)
                                                                            install-plan)
                                                          #:node-modules-input #$node-modules-input
                                                          #:search-paths '#$(sexp->gexp
                                                                             (map
                                                                              search-path-specification->sexp
                                                                              search-paths))
                                                          #:phases #$(if (pair?
                                                                          phases)
                                                                      (sexp->gexp
                                                                       phases)
                                                                      phases)
                                                          #:tests? #$tests?
                                                          #:validate-runpath? #$validate-runpath?
                                                          #:patch-shebangs? #$patch-shebangs?
                                                          #:strip-binaries? #$strip-binaries?
                                                          #:strip-flags #$strip-flags
                                                          #:strip-directories #$strip-directories)))))

  (mlet %store-monad
        ((guile (package->derivation (or guile
                                         (default-guile)) system
                                     #:graft? #f)))
        (gexp->derivation name
                          builder
                          #:system system
                          #:target #f
                          #:graft? #f
                          #:substitutable? substitutable?
                          #:allowed-references allowed-references
                          #:disallowed-references disallowed-references
                          #:guile-for-build guile)))

(define bun-build-system
  (build-system (name 'bun)
                (description "Build system for Bun applications")
                (lower lower)))
