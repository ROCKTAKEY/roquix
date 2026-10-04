(define-module (roquix build-system container-launcher)
  #:use-module (guix build-system)
  #:use-module (guix build-system trivial)
  #:use-module (guix gexp)
  #:use-module (guix modules)
  #:use-module (guix packages)
  #:use-module (guix profiles)
  #:use-module (ice-9 match)
  #:use-module (srfi srfi-13)
  #:use-module (gnu packages package-management)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages containers)
  #:use-module (gnu packages linux)
  #:use-module (roquix build container-launcher)
  #:use-module (roquix build desktop-container)
  #:use-module (roquix build desktop-network)
  #:export (container-launcher-build-system))

;; A wrapper package keeps the payload outside its own output, allowing a
;; profile containing the payload to be built without a self dependency.

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
                desktop-application (desktop-audio? #f) (desktop-network? #f)
                source inputs native-inputs outputs system target
                #:allow-other-keys)
  (unless (package? payload)
    (error "container launcher payload must be a package" payload))
  (unless (and (string? payload-output)
               (not (string-null? payload-output)))
    (error "container launcher payload output must be a name" payload-output))
  (unless (and (string? executable)
               (not (string-null? executable))
               (not (string-index executable #\/)))
    (error "container launcher executable must be a file name" executable))
  (when source
    (error "container launcher takes its files from the payload package" source))
  (when target
    (error "cross-building a container launcher is unsupported" target))
  (for-each (lambda (name value)
              (unless (boolean? value)
                (error "container launcher option must be boolean" name value)))
            '(network? emulate-fhs? no-cwd? desktop-audio? desktop-network?)
            (list network? emulate-fhs? no-cwd? desktop-audio? desktop-network?))

  (when (and (or desktop-audio? desktop-network?) (not desktop-application))
    (error "desktop audio and networking require a desktop application"))
  (when (and network? desktop-network?)
    (error "host network sharing conflicts with private desktop networking"))

  (when desktop-application
    (parse-desktop-application desktop-application))

  ;; Parse package configuration before lowering it to a derivation.
  (container-command-arguments
   "/profile" executable
   #:preserve-environment preserve-environment
   #:set-environment
   (map (match-lambda
          ((name . (? file-like? value)) (cons name "/store/environment-value"))
          (entry entry))
        set-environment)
   #:share share #:expose expose
   #:network? network? #:emulate-fhs? emulate-fhs? #:no-cwd? no-cwd?
   #:getenv (lambda (_) "/runtime"))

  (let* ((modules
          (source-module-closure
           '((roquix build container-launcher)
             (roquix build desktop-container)
             (roquix build desktop-network)
             (guix build utils))
           #:select? (lambda (module) (memq (car module) '(guix roquix)))))
         (network-child
          (and desktop-network?
               (program-file
                "desktop-network-child"
                (with-imported-modules modules
                  #~(begin
                      (use-modules (roquix build desktop-network))
                      (run-network-child (cadr (command-line))
                                         (cddr (command-line))))))))
         (runtime-profile
          (profile
            (content (packages->manifest
                      (cons (list payload payload-output)
                            (map runtime-input->manifest-item inputs))))))
         (launcher
          (program-file
           executable
           (with-imported-modules
            modules
            #~(begin
                (use-modules (roquix build container-launcher)
                             (roquix build desktop-container)
                             (roquix build desktop-network))
                (let ((guix #$(file-append guix "/bin/guix")))
                  (define (launch desktop)
                    (let ((command
                           (container-command-arguments
                            #$runtime-profile #$executable
                            #:preserve-environment
                            '#$(sexp->gexp preserve-environment)
                            #:set-environment
                            (append
                             (if desktop (desktop-runtime-environment desktop) '())
                             (list #$@(map (match-lambda
                                            ((name . value)
                                             #~(cons #$name #$value)))
                                          set-environment)))
                            #:share
                            (append (if desktop (desktop-runtime-share desktop) '())
                                    '#$(sexp->gexp share))
                            #:expose
                            (append (if desktop (desktop-runtime-expose desktop) '())
                                    '#$(sexp->gexp expose))
                            #:network? #$(or network? desktop-network?)
                            #:emulate-fhs? #$emulate-fhs?
                            #:no-cwd? #$no-cwd?
                            #:private-session-bus? (and desktop #t)
                            #:arguments
                            (append (if desktop (desktop-runtime-arguments desktop) '())
                                    (cdr (command-line))))))
                      (if desktop
                          (if #$desktop-network?
                              (run-desktop-network
                               (desktop-runtime-network desktop) (cons guix command)
                               #$(and desktop-network?
                                      (file-append util-linux "/bin/unshare"))
                               #$(and desktop-network?
                                      (file-append slirp4netns "/bin/slirp4netns"))
                               #$network-child)
                              (run-desktop-command (cons guix command)))
                          (apply execl guix guix command))))
                  (seal-inherited-file-descriptors)
                  (if #$desktop-application
                      (catch 'desktop-interrupted
                        (lambda ()
                          (let ((status
                                 (call-with-private-desktop-runtime
                                  (parse-desktop-application #$desktop-application)
                                  #$(and desktop-application
                                         (file-append weston "/bin/weston"))
                                  launch
                                  #:audio-daemon
                                  #$(and desktop-audio?
                                         (file-append pulseaudio "/bin/pulseaudio"))
                                  #:network? #$desktop-network?)))
                            (exit (or (status:exit-val status)
                                      (+ 128 (status:term-sig status))))))
                        (lambda (key signal) (exit (+ 128 signal))))
                      (launch #f)))))))
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
