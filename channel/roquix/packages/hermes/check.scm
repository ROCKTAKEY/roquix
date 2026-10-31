(define-module (roquix packages hermes check)
  #:use-module (guix build utils)
  #:use-module ((guix build syscalls) #:select (mkdtemp!))
  #:use-module (ice-9 regex)
  #:use-module (ice-9 textual-ports)
  #:use-module (json)
  #:export (check-cli))

(define (read-log file)
  (if (file-exists? file) (call-with-input-file file get-string-all) ""))

(define (deadline seconds)
  (+ (get-internal-real-time) (* seconds internal-time-units-per-second)))

(define (expired? limit)
  (>= (get-internal-real-time) limit))

(define (call-with-command command log proc)
  (let ((pid (primitive-fork)) (status #f))
    (when (zero? pid)
      (catch #t
        (lambda ()
          (setsid)
          (call-with-output-file log
            (lambda (port)
              (dup2 (fileno port) 1)
              (dup2 (fileno port) 2)
              (apply execlp (car command) command))))
        (lambda args (primitive-exit 1))))
    (define (poll)
      (or status
          (let ((result (waitpid pid WNOHANG)))
            (and (positive? (car result))
                 (begin (set! status result) status)))))
    (dynamic-wind
      (lambda () #t)
      (lambda () (proc poll))
      (lambda ()
        (unless (poll)
          ;; The gateway can spawn children; terminate its whole session.
          (false-if-exception (kill (- pid) SIGTERM))
          (let ((limit (deadline 10)))
            (let loop ()
              (unless (poll)
                (if (expired? limit)
                    (begin
                      (false-if-exception (kill (- pid) SIGKILL))
                      (set! status (waitpid pid)))
                    (begin (usleep 100000) (loop)))))))))))

(define (run-command command log seconds)
  (call-with-command command log
    (lambda (poll)
      (let ((limit (deadline seconds)))
        (let loop ()
          (let ((status (poll)))
            (cond
             (status
              (unless (equal? 0 (status:exit-val (cdr status)))
                (error "Hermes check command failed" command (read-log log))))
             ((expired? limit) (error "Hermes check command timed out" command (read-log log)))
             (else (usleep 100000) (loop)))))))))

(define (check-cli command python curl version)
  (let ((home (mkdtemp! "/tmp/hermes-check.XXXXXX"))
        (environment (environ)))
    (dynamic-wind
      (lambda ()
        (environ (list (string-append "HOME=" home)
                       (string-append "HERMES_HOME=" home "/.hermes")
                       (string-append "PATH=" (or (getenv "PATH") "")))))
      (lambda ()
        (let ((log (string-append home "/version.log")))
          (run-command (list command "--version") log 20)
          (unless (and (string-contains (read-log log) (string-append "v" version))
                       (string-contains (read-log log) "Install directory: /gnu/store/"))
            (error "unexpected installed CLI identity" (read-log log))))
        (setenv "PYTHONPATH" (string-append (dirname (dirname command)) "/lib/hermes/site-packages"))
        (run-command
           (list python "-c"
                 "import _cffi_backend, PIL.Image, pillow_heif, cryptography.hazmat.bindings._rust, pydantic_core, jiter, watchfiles, psutil, resvg_py, nemo_relay, anydoc._anydoc")
           (string-append home "/imports.log") 30)
        (unsetenv "PYTHONPATH")
        (let ((log (string-append home "/gateway.log")))
          (call-with-command (list command "serve" "--port" "0") log
            (lambda (poll)
              (let ((limit (deadline 30)))
                (let loop ()
                  (let ((ready (string-match "HERMES_BACKEND_READY port=([0-9]+)" (read-log log))))
                    (cond
                     ((poll) (error "gateway exited before health check" (read-log log)))
                     (ready
                      (let ((health-file (string-append home "/health.json")))
                        (run-command
                         (list curl "--fail" "--silent" "--show-error" "--max-time" "5"
                               "--noproxy" "*" "--output" health-file
                               (string-append "http://127.0.0.1:" (match:substring ready 1) "/api/health"))
                         (string-append home "/http.log") 10)
                        (let ((health (call-with-input-file health-file json->scm)))
                          (unless (and (eq? #t (assoc-ref health "ok"))
                                       (equal? version (assoc-ref health "version")))
                            (error "unexpected gateway health" health)))))
                     ((expired? limit) (error "gateway startup timed out" (read-log log)))
                     (else (usleep 100000) (loop)))))))))
        (format #t "Hermes ~a: installed CLI and gateway ready~%" version))
      (lambda ()
        (environ environment)
        ;; Hermes copies read-only skill directories from the store into HOME.
        (for-each
         (lambda (file)
           (when (eq? 'directory (stat:type (lstat file)))
             (chmod file (logior #o700 (stat:perms (lstat file))))))
         (find-files home #:directories? #t))
        (delete-file-recursively home)))))
