(define-module (roquix build desktop-network)
  #:use-module (roquix build desktop-process)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-9)
  #:export (prepare-desktop-network desktop-network-expose
            run-desktop-network run-network-child))

(define-record-type <desktop-network>
  (%desktop-network directory resolver) desktop-network?
  (directory desktop-network-directory)
  (resolver desktop-network-resolver))

(define (prepare-desktop-network directory)
  (let ((resolver (string-append directory "/resolv.conf")))
    ;; Slirp's DNS proxy forwards to the host resolver without exposing its
    ;; session sockets or requiring a fixed list of application servers.
    ;; https://github.com/rootless-containers/slirp4netns/blob/master/slirp4netns.1.md
    (call-with-output-file resolver
      (lambda (port) (display "nameserver 10.0.2.3\n" port)))
    (%desktop-network directory resolver)))

(define (desktop-network-expose network)
  (list (cons (desktop-network-resolver network) "/etc/resolv.conf")))

(define (nonempty-file? file)
  (and (file-exists? file) (> (stat:size (stat file)) 0)))

(define (run-network-child directory command)
  (let ((identity (string-append directory "/network-pid"))
        (ready (string-append directory "/network-ready")))
    (call-with-output-file identity
      (lambda (port) (write (getpid) port)))
    (let ((deadline (+ (get-internal-real-time)
                       (* 10 internal-time-units-per-second))))
      (let loop ()
        (unless (nonempty-file? ready)
          (when (> (get-internal-real-time) deadline)
            (error "private network bridge did not become ready"))
          (usleep 100000)
          (loop))))
    (apply execl (car command) command)))

(define (run-desktop-network network command namespace-tool bridge child)
  (unless (desktop-network? network)
    (error "network launch requires prepared desktop networking" network))
  (let* ((directory (desktop-network-directory network))
         (identity (string-append directory "/network-pid"))
         (ready (string-append directory "/network-ready")))
    ;; Guix shares the *private* network namespace created here. A host network
    ;; namespace would expose abstract Unix sockets as well as local TCP ports.
    (call-with-child
     (append (list namespace-tool "--user" "--map-current-user" "--net"
                   child directory) command)
     #f
     (lambda (pid wait)
       (wait-for-ready wait (lambda () (nonempty-file? identity)) "network namespace")
       (unless (= pid (call-with-input-file identity read))
         (error "unexpected network namespace process"))
       (call-with-child
        (list bridge "--configure" "--disable-host-loopback" "--enable-ipv6"
              "--enable-sandbox" "--enable-seccomp" "--ready-fd=3"
              (number->string pid) "tap0")
        #f
        (lambda (bridge-pid bridge-wait)
          (wait-for-ready bridge-wait (lambda () (nonempty-file? ready)) "network bridge")
          (wait-for-child wait))
        #:ready-file ready)))))
