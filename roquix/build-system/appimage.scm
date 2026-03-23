(define-module (roquix build-system appimage)
  #:use-module (guix store)
  #:use-module (guix utils)
  #:use-module (guix gexp)
  #:use-module (guix monads)
  #:use-module (guix search-paths)
  #:use-module (guix build-system)
  #:use-module (guix build-system gnu)
  #:use-module (guix packages)
  #:use-module (ice-9 regex)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:export (%appimage-build-system-modules
            lower
            appimage-build
            appimage-build-system))

(define %appimage-build-system-modules
  `((roquix build appimage-build-system)
    (guix build copy-build-system)
    ,@%default-gnu-imported-modules))

(define (default-appimage-name name)
  (let ((match (string-match "^(.*)-([0-9].*)$" name)))
    (if match
        (match:substring match 1)
        name)))

(define (keyword-argument-ref arguments keyword default)
  (let loop ((arguments arguments))
    (cond
     ((null? arguments) default)
     ((and (pair? arguments)
           (pair? (cdr arguments)))
      (if (eq? (car arguments) keyword)
          (cadr arguments)
          (loop (cddr arguments))))
     (else default))))

(define (patchelf-plan-required? arguments)
  (let ((sentinel (list 'not-found)))
    (let ((plan (keyword-argument-ref arguments #:patchelf-plan sentinel)))
      (not (or (eq? plan sentinel)
               (and (list? plan)
                    (null? plan)))))))

(define* (lower name
                #:key source inputs native-inputs outputs system target
                #:allow-other-keys
                #:rest arguments)
  "Return a bag for NAME from the given arguments."
  (define private-keywords
    '(#:target #:inputs #:native-inputs))
  (define appimage-name
    (default-appimage-name name))
  (define needs-patchelf?
    (patchelf-plan-required? arguments))

  (bag
    (name name)
    (system system)
    (host-inputs `(,@(if source
                         `(("source" ,source))
                         '())
                   ,@inputs
                   ,@(standard-packages)))
    (build-inputs `(,@native-inputs
                    ("squashfs-tools" ,squashfs-tools)
                    ,@(if needs-patchelf?
                          `(("patchelf" ,patchelf))
                          '())))
    (outputs outputs)
    (build appimage-build)
    (arguments
     (append
      (list #:appdir (string-append "lib/" appimage-name)
            #:launcher-name appimage-name)
      (strip-keyword-arguments private-keywords arguments)))))

(define* (appimage-build name inputs
                         #:key
                         guile source
                         (outputs '("out"))
                         (install-plan #f)
                         (appdir "lib/appimage")
                         (launcher-name "appimage")
                         (ld-library-path-inputs '())
                         (install-wrapper? #t)
                         (install-desktop-file? #t)
                         (patchelf-plan '())
                         (search-paths '())
                         (out-of-source? #t)
                         (tests? #t)
                         (validate-runpath? #f)
                         (patch-shebangs? #t)
                         (strip-binaries? #f)
                         (strip-flags %strip-flags)
                         (strip-directories %strip-directories)
                         (phases '(@ (roquix build appimage-build-system)
                                     %standard-phases))
                         (system (%current-system))
                         (target #f)
                         (substitutable? #t)
                         (imported-modules %appimage-build-system-modules)
                         (modules '((roquix build appimage-build-system)
                                    (guix build utils))))
  "Build SOURCE using INSTALL-PLAN, and with INPUTS."
  (define effective-install-plan
    (or install-plan
        `(("." ,(string-append appdir "/")))))

  (define builder
    (with-imported-modules imported-modules
      #~(begin
          (use-modules #$@modules)

          #$(with-build-variables inputs outputs
              #~(appimage-build #:source #+source
                                #:system #$system
                                #:outputs %outputs
                                #:inputs %build-inputs
                                #:install-plan '#$(if (pair? effective-install-plan)
                                                      (sexp->gexp effective-install-plan)
                                                      effective-install-plan)
                                #:appdir #$appdir
                                #:launcher-name #$launcher-name
                                #:ld-library-path-inputs '#$(if (pair? ld-library-path-inputs)
                                                                (sexp->gexp ld-library-path-inputs)
                                                                ld-library-path-inputs)
                                #:install-wrapper? #$install-wrapper?
                                #:install-desktop-file? #$install-desktop-file?
                                #:patchelf-plan '#$(if (pair? patchelf-plan)
                                                       (sexp->gexp patchelf-plan)
                                                       patchelf-plan)
                                #:search-paths '#$(sexp->gexp
                                                   (map search-path-specification->sexp
                                                        search-paths))
                                #:phases #$(if (pair? phases)
                                               (sexp->gexp phases)
                                               phases)
                                #:out-of-source? #$out-of-source?
                                #:tests? #$tests?
                                #:validate-runpath? #$validate-runpath?
                                #:patch-shebangs? #$patch-shebangs?
                                #:strip-binaries? #$strip-binaries?
                                #:strip-flags #$strip-flags
                                #:strip-directories #$strip-directories)))))

  (mlet %store-monad ((guile (package->derivation (or guile (default-guile))
                                                  system #:graft? #f)))
    (gexp->derivation name builder
                      #:system system
                      #:target #f
                      #:substitutable? substitutable?
                      #:graft? #f
                      #:guile-for-build guile)))

(define appimage-build-system
  (build-system
    (name 'appimage)
    (description "Build system for extracting AppImage type 2 payloads")
    (lower lower)))
