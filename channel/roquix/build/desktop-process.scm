(define-module (roquix build desktop-process)
  #:export (call-with-child wait-for-condition wait-for-ready wait-for-child))

(define* (spawn-command command environment #:key ready-file)
  (let ((pid (primitive-fork)))
    (when (zero? pid)
      (catch #t
        (lambda ()
          (setsid)
          (sigaction SIGINT SIG_DFL)
          (sigaction SIGTERM SIG_DFL)
          (when environment (environ environment))
          (if ready-file
              (call-with-output-file ready-file
                (lambda (port)
                  (unless (= (fileno port) 3)
                    (fcntl (fileno port) F_SETFD FD_CLOEXEC)
                    (dup2 (fileno port) 3))
                  (fcntl 3 F_SETFD 0)
                  (apply execl (car command) command)))
              (apply execl (car command) command)))
        (lambda arguments (primitive-exit 127))))
    pid))

(define* (call-with-child command environment procedure #:key ready-file)
  (let ((pid (spawn-command command environment #:ready-file ready-file))
        (reaped? #f))
    (dynamic-wind
      (lambda () #t)
      (lambda ()
        (procedure pid
                   (lambda (options)
                     (let ((result (waitpid pid options)))
                       (unless (zero? (car result)) (set! reaped? #t))
                       result))))
      (lambda ()
        (unless reaped?
          (false-if-exception (kill (- pid) SIGTERM))
          ;; A signal may arrive before the child has established its session.
          (false-if-exception (kill pid SIGTERM))
          (waitpid pid))))))

(define (wait-for-condition ready? description)
  (let ((deadline (+ (get-internal-real-time)
                     (* 10 internal-time-units-per-second))))
    (let loop ()
      (unless (ready?)
        (when (> (get-internal-real-time) deadline)
          (error "desktop service did not become ready" description))
        (usleep 100000)
        (loop)))))

(define (wait-for-ready wait ready? description)
  (wait-for-condition
   (lambda ()
     (unless (zero? (car (wait WNOHANG)))
       (error "desktop service exited before becoming ready" description))
     (ready?))
   description))

(define (wait-for-child wait)
  ;; Guile may defer Scheme signal handlers during a blocking waitpid.
  (let loop ()
    (let ((result (wait WNOHANG)))
      (if (zero? (car result))
          (begin (usleep 100000) (loop))
          (cdr result)))))
