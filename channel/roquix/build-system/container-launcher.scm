(define-module (roquix build-system container-launcher)
  #:use-module (guix build-system)
  #:use-module (guix build-system trivial)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix profiles)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-13)
  #:use-module (gnu packages package-management)
  #:use-module (roquix build container-launcher)
  #:export (container-launcher-build-system))

(define (runtime-input->manifest-item input)
  (match input
    ((_ (? package? package)) package)
    ((_ (? package? package) output) (list package output))
    (_ (error "container launcher inputs must be packages" input))))

(define* (lower name
                #:key payload (payload-output "out") executable
                (preserve-environment '()) (set-environment '())
                (share '()) (expose '())
                (network? #f) (emulate-fhs? #f) (no-cwd? #t)
                source inputs native-inputs outputs system target
                #:allow-other-keys)
  (unless (package? payload)
    (error "container launcher payload must be a package" payload))
  (unless (and (string? executable)
               (not (string-null? executable))
               (not (string-index executable #\/)))
    (error "container launcher executable must be a file name" executable))
  (when source
    (error "container launcher takes its files from the payload package" source))
  (when target
    (error "cross-building a container launcher is unsupported" target))

  ;; Parse package configuration before lowering it to a derivation.
  (container-command-arguments
   "/profile" executable
   #:preserve-environment preserve-environment
   #:set-environment set-environment
   #:share share #:expose expose
   #:network? network? #:emulate-fhs? emulate-fhs? #:no-cwd? no-cwd?
   #:getenv (lambda (_) "/runtime"))

  (let* ((runtime-profile
          (profile
            (content (packages->manifest
                      (cons (list payload payload-output)
                            (map runtime-input->manifest-item inputs)))))
          )
         (launcher
          (program-file
           executable
           (with-imported-modules
            '((roquix build container-launcher)
              (guix build utils))
            #~(begin
                (use-modules (roquix build container-launcher))
                (let ((guix #$(file-append guix "/bin/guix")))
                  (apply execl guix guix
                         (container-command-arguments
                          #$runtime-profile #$executable
                          #:preserve-environment
                          '#$(sexp->gexp preserve-environment)
                          #:set-environment
                          '#$(sexp->gexp set-environment)
                          #:share '#$(sexp->gexp share)
                          #:expose '#$(sexp->gexp expose)
                          #:network? #$network?
                          #:emulate-fhs? #$emulate-fhs?
                          #:no-cwd? #$no-cwd?
                          #:arguments (cdr (command-line)))))))))
         (builder
          #~(begin
              (use-modules (guix build utils)
                           (roquix build container-launcher))
              (let* ((out (assoc-ref %outputs "out"))
                     (payload (assoc-ref %build-inputs "payload"))
                     (launcher (assoc-ref %build-inputs "launcher"))
                     (bin (string-append out "/bin")))
                (unless (file-exists? (string-append payload "/bin/" #$executable))
                  (error "payload executable does not exist" payload #$executable))
                (mkdir-p bin)
                (symlink launcher (string-append bin "/" #$executable))
                (install-desktop-metadata payload out #$executable)))))
    ((build-system-lower trivial-build-system)
     name
     #:source #f
     #:inputs `(("payload" ,payload ,payload-output)
                ("runtime-profile" ,runtime-profile)
                ("launcher" ,launcher))
     #:native-inputs native-inputs
     #:outputs outputs
     #:system system
     #:target #f
     #:builder builder
     #:modules '((guix build utils)
                 (roquix build container-launcher)))))

(define container-launcher-build-system
  (build-system
    (name 'container-launcher)
    (description "Install a Guix container launcher for a package payload")
    (lower lower)))
