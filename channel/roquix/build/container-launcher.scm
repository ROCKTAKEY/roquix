(define-module (roquix build container-launcher)
  #:use-module (guix build utils)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:export (container-command-arguments
            rewrite-desktop-line
            install-desktop-metadata))

(define (environment-name? name)
  (and (string? name)
       (string-match "^[A-Za-z_][A-Za-z_0-9]*$" name)))

(define (absolute-path path)
  (unless (and (string? path)
               (string-prefix? "/" path)
               (not (string-contains path "=")))
    (error "container mapping must be an absolute path without '='" path))
  path)

(define (resolve-path spec getenv)
  (cond
   ((string? spec) (absolute-path spec))
   ((and (pair? spec)
         (list? spec)
         (eq? (car spec) 'environment)
         (or (= (length spec) 2) (= (length spec) 3))
         (environment-name? (cadr spec))
         (or (= (length spec) 2)
             (and (string? (caddr spec))
                  (or (string-null? (caddr spec))
                      (string-prefix? "/" (caddr spec))))))
    (let ((value (getenv (cadr spec))))
      (and value
           (not (string-null? value))
           (absolute-path (string-append value
                                         (if (= (length spec) 3)
                                             (caddr spec)
                                             ""))))))
   (else (error "invalid container path" spec))))

(define (mapping-option flag mapping getenv)
  (let* ((same-path? (or (string? mapping)
                        (and (pair? mapping)
                             (eq? (car mapping) 'environment))))
         (source (resolve-path (if same-path? mapping (car mapping)) getenv))
         (target (and source
                      (resolve-path (if same-path? mapping (cdr mapping))
                                    getenv))))
    (and target
         (string-append flag source "=" target))))

(define* (container-command-arguments profile executable
                                      #:key
                                      (preserve-environment '())
                                      (set-environment '())
                                      (share '())
                                      (expose '())
                                      (network? #f)
                                      (emulate-fhs? #f)
                                      (no-cwd? #t)
                                      (arguments '())
                                      (getenv getenv))
  "Return the exact argv passed to Guix for the containerized executable."
  (define (preserve-argument name)
    (unless (environment-name? name)
      (error "invalid environment variable name" name))
    (list "-E" (string-append "^" name "$")))
  (define (set-argument entry)
    (unless (and (pair? entry)
                 (environment-name? (car entry))
                 (string? (cdr entry)))
      (error "invalid environment variable assignment" entry))
    (list "-E" (string-append (car entry) "=" (cdr entry))))
  (append (list "shell" "-q" "--pure" "-C"
                (string-append "--profile=" (absolute-path profile)))
          (if no-cwd? '("--no-cwd") '())
          (if network? '("-N") '())
          (if emulate-fhs? '("-F") '())
          (append-map preserve-argument preserve-environment)
          (append-map set-argument set-environment)
          (filter-map (lambda (mapping)
                        (mapping-option "--share=" mapping getenv))
                      share)
          (filter-map (lambda (mapping)
                        (mapping-option "--expose=" mapping getenv))
                      expose)
          (list "--" (string-append profile "/bin/" executable))
          arguments))

(define (rewrite-desktop-line line launcher)
  "Route desktop actions and application launch through LAUNCHER."
  (cond
   ((string-prefix? "Exec=" line)
    (let ((match (string-match
                  "^Exec=([^[:space:]]+)([[:space:]].*)?$" line)))
      (unless match
        (error "unsupported desktop Exec field" line))
      ;; An env prefix would turn assignments into application arguments.
      (when (member (match:substring match 1) '("env" "/usr/bin/env"))
        (error "desktop Exec with env prefix needs package-specific handling"
               line))
      (string-append "Exec=" launcher (or (match:substring match 2) ""))))
   ((string-prefix? "TryExec=" line)
    (string-append "TryExec=" launcher))
   ((string=? line "DBusActivatable=true")
    ;; D-Bus activation ignores Exec, so keeping it would bypass the launcher.
    ;; https://specifications.freedesktop.org/desktop-entry/latest/recognized-keys.html
    "DBusActivatable=false")
   (else line)))

(define (rewrite-desktop-file source destination launcher)
  (call-with-input-file source
    (lambda (input)
      (call-with-output-file destination
        (lambda (output)
          (define (write-missing-exec main-entry? main-exec?)
            ;; Replacing D-Bus activation with the wrapper requires a main Exec.
            (when (and main-entry? (not main-exec?))
              (format output "Exec=~a~%" launcher)))
          (let loop ((line (read-line input))
                     (main-entry? #f)
                     (main-exec? #f))
            (if (eof-object? line)
                (write-missing-exec main-entry? main-exec?)
                (let ((section? (and (string-prefix? "[" line)
                                     (string-suffix? "]" line))))
                  (when section?
                    (write-missing-exec main-entry? main-exec?))
                  (display (rewrite-desktop-line line launcher) output)
                  (newline output)
                  (loop (read-line input)
                        (if section?
                            (string=? line "[Desktop Entry]")
                            main-entry?)
                        (if section?
                            #f
                            (or main-exec?
                                (and main-entry?
                                     (string-prefix? "Exec=" line)))))))))))))

(define (install-desktop-metadata payload output launcher-name)
  "Export host-visible XDG metadata while routing desktop launches through the wrapper."
  (let* ((source (string-append payload "/share"))
         (destination (string-append output "/share"))
         (applications (string-append source "/applications"))
         (launcher (string-append output "/bin/" launcher-name)))
    (when (file-exists? source)
      (mkdir-p destination)
      (for-each
       (lambda (name)
         (let ((path (string-append source "/" name)))
           (when (file-exists? path)
             (symlink path (string-append destination "/" name)))))
       '("icons" "pixmaps" "metainfo" "appdata" "mime"
         "desktop-directories"))
      (when (file-exists? applications)
        (let ((target (string-append destination "/applications")))
          (mkdir-p target)
          (for-each
           (lambda (file)
             (let ((installed (string-append
                               target "/"
                               (string-drop file (+ (string-length applications)
                                                    1)))))
               (mkdir-p (dirname installed))
               (rewrite-desktop-file file installed launcher)))
           (find-files applications "\\.desktop$"))))))
  #t)
