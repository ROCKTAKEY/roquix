;; Exercise the real upstream assembler with a small prepared package.
;; Usage: guix repl -L channel -- tests/hermes-cli-assembly.scm UPSTREAM-SOURCE
(use-modules (roquix build hermes staging)
             (guix build utils)
             ((guix build syscalls) #:select (mkdtemp!))
             (ice-9 popen) (ice-9 textual-ports) (json) (srfi srfi-64))

(define upstream (canonicalize-path (cadr (command-line))))
(define directory (mkdtemp! "/tmp/hermes-cli-assembly.XXXXXX"))
(define python (which "python3"))
(define (write-text file text)
  (mkdir-p (dirname file))
  (call-with-output-file file (lambda (port) (display text port))))
(test-begin "hermes-cli-assembly")
(dynamic-wind
  (lambda () #t)
  (lambda ()
    (with-directory-excursion directory
      (copy-recursively (string-append upstream "/scripts/build") "scripts/build")
      (write-text "pyproject.toml"
        "[project]\nname = 'assembly-example'\nversion = '1.2.3'\ndependencies = []\n[project.scripts]\ncustom-command = 'example:main'\n")
      (write-text "example.py" "import dependency\ndef main():\n    print(dependency.message)\n")
      (write-text "pm/runtime.py" "if stamp.get(\"distribution\") not in (\"nix\", \"docker\"):\n    pass\n")
      (let* ((out (string-append directory "-out"))
             (repo (string-append out "/lib/hermes/source"))
             (site (string-append out "/lib/hermes/site-packages")))
        (install-cli-layout out python "1.2.3")
        (write-text (string-append site "/dependency.py") "message = 'prepared dependency'\n")
        (test-equal "commands come from the upstream project metadata"
          '("custom-command") (assemble-cli out python))
        (test-assert "upstream assembly publishes its manifest"
          (file-exists? (string-append out "/manifest.json")))
        (when (file-exists? (string-append out "/manifest.json"))
          (let* ((manifest (call-with-input-file (string-append out "/manifest.json") json->scm))
                 (runtime (assoc-ref manifest "runtime")))
            (test-equal "external Guix interpreter is retained"
              python (assoc-ref runtime "storePython")))
          (test-assert "upstream generates distribution metadata"
            (file-exists? (string-append repo "/assembly_example-1.2.3.dist-info/METADATA")))
          (test-assert "upstream binds dependencies to the installed source"
            (file-exists? (string-append site "/hermes-agent.pth")))
          (let* ((port (open-pipe* OPEN_READ "bash" (string-append out "/bin/custom-command")))
                 (text (get-string-all port))
                 (status (close-pipe port)))
            (test-equal "generated command loads prepared dependencies"
              '(0 "prepared dependency\n") (list status text)))))))
  (lambda ()
    (delete-file-recursively directory)
    (when (file-exists? (string-append directory "-out"))
      (delete-file-recursively (string-append directory "-out")))))
(define failures (test-runner-fail-count (test-runner-current)))
(test-end "hermes-cli-assembly")
(exit (zero? failures))
