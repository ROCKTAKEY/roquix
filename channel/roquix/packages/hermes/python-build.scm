(define-module (roquix packages hermes python-build)
  #:use-module (guix build utils)
  #:use-module ((guix build pyproject-build-system) #:prefix pyproject:)
  #:use-module (ice-9 popen)
  #:use-module (json)
  #:export (build-python-dependency install-python-dependency))

(define (build-python-dependency python bridge)
  ;; Use Python's TOML parser: upstream pyproject files can contain constructs
  ;; not supported by Guix's TOML parser, including arrays of tables.
  (let* ((port (open-pipe* OPEN_READ python bridge "describe"))
         (metadata (dynamic-wind (lambda () #t)
                     (lambda () (json->scm port))
                     (lambda ()
                       (unless (zero? (close-pipe port))
                         (error "cannot read Python build-backend metadata")))))
         (backend (or (assoc-ref metadata "build-backend") "setuptools.build_meta:__legacy__"))
         (dist (string-append (getcwd) "/dist")))
    (unless (string? backend) (error "invalid Python build backend" backend))
    (mkdir-p dist)
    (if (string=? backend "maturin")
        (invoke "maturin" "build" "--offline" "--release" "--compatibility" "linux"
                "--interpreter" python "--out" dist)
        (invoke python bridge "build" dist))))

(define (install-python-dependency inputs outputs python-wrapper)
  ((assoc-ref pyproject:%standard-phases 'install)
   #:inputs (acons "python" python-wrapper inputs)
   #:outputs outputs))
