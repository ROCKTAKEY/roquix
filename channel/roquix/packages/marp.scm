(define-module (roquix packages marp)
  #:use-module (guix build-system gnu)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages chromium)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages version-control))

(define %marp-version "4.5.1")

(define %marp-source
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/marp-team/marp-cli/"
                        "tar.gz/refs/tags/v" %marp-version))
    (file-name (string-append "marp-cli-" %marp-version ".tar.gz"))
    (sha256 (base32 "1fiainr4f5wr18pzis3vj0gd06vibdavndsyrw8vnlg1a1hjzvw7"))))

(define* (marp-node-modules-fetch uri hash-algo hash
                                  #:optional name
                                  #:key system guile #:allow-other-keys)
  (gexp->derivation
   (or name "marp-node-modules")
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" (string-append #+node "/bin:" #+tar "/bin:"
                                       #+gzip "/bin:" #+git-minimal "/bin:"
                                       #+bash-minimal "/bin"))
         (setenv "HOME" (getcwd))
         (setenv "SSL_CERT_FILE"
                 #+(file-append nss-certs-for-test
                                "/etc/ssl/certs/ca-certificates.crt"))
         (setenv "GIT_SSL_CAINFO" (getenv "SSL_CERT_FILE"))
         (invoke "tar" "xf" #+%marp-source)
         (chdir #$(string-append "marp-cli-" %marp-version))
         (invoke "npm" "ci" "--ignore-scripts" "--no-audit" "--no-fund")
         (copy-recursively "node_modules" #$output)
         (delete-file (string-append #$output "/.package-lock.json"))))
   #:system system
   #:guile-for-build guile
   #:hash-algo hash-algo
   #:hash hash
   #:recursive? #t))

(define %marp-node-modules
  (origin
    (method marp-node-modules-fetch)
    (uri (string-append "marp-node-modules-" %marp-version))
    (sha256 (base32 "1zrg03f57dx3h2wj7sjx1x3g1p75qcvp7wlyc8z72nril6d7ckl8"))))

(define-public marp-cli
  (package
    (name "marp-cli")
    (version %marp-version)
    (source %marp-source)
    (build-system gnu-build-system)
    ;; The npm snapshot includes platform-selected native build tools.
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 rdelim))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (setenv "HOME" (string-append (getcwd) "/.home"))
              (mkdir-p (getenv "HOME"))
              (copy-recursively #$%marp-node-modules "node_modules")
              (for-each make-file-writable (find-files "node_modules"))
              ;; Rollup's native addon needs the Guix C++ runtime while bundling.
              (for-each
               (lambda (file)
                 (invoke "patchelf" "--set-rpath"
                         (string-append #$gcc:lib "/lib") file))
               (find-files "node_modules/@rollup" "\\.node$"))))
          (replace 'build
            (lambda _
              (invoke "node" "node_modules/rollup/dist/bin/rollup" "-c")))
          (delete 'check)
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (lib (string-append out "/lib/marp-cli"))
                     (bin (string-append out "/bin")))
                (invoke "npm" "prune" "--omit=dev" "--offline"
                        "--ignore-scripts" "--no-audit" "--no-fund")
                (mkdir-p lib)
                (copy-recursively "lib" (string-append lib "/lib"))
                (copy-recursively "node_modules" (string-append lib "/node_modules"))
                (for-each (lambda (file) (install-file file lib))
                          '("marp-cli.js" "package.json" "LICENSE"))
                (mkdir-p bin)
                (call-with-output-file (string-append bin "/marp")
                  (lambda (port)
                    (format port (string-append "#!~a~%export CHROME_PATH="
                                                "\"${CHROME_PATH:-~a}\"~%"
                                                "exec ~a ~a/marp-cli.js \"$@\"~%")
                            #$(file-append bash-minimal "/bin/bash")
                            #$(file-append ungoogled-chromium "/bin/chromium")
                            #$(file-append node "/bin/node") lib)))
                (chmod (string-append bin "/marp") #o755))))
          (add-after 'install 'check-installed
            (lambda* (#:key tests? outputs #:allow-other-keys)
              (when tests?
                (let ((marp (string-append (assoc-ref outputs "out") "/bin/marp")))
                  (invoke marp "--version")
                  (call-with-output-file "slides.md"
                    (lambda (port)
                      (display (string-append "---\nmarp: true\n---\n"
                                              "# Guix Marp smoke test\n\n"
                                              "---\n\n# Second slide\n")
                               port)))
                  (invoke marp "slides.md" "--output" "slides.html")
                  (unless (call-with-input-file "slides.html"
                            (lambda (port)
                              (let loop ()
                                (let ((line (read-line port)))
                                  (and (not (eof-object? line))
                                       (or (string-contains line "Guix Marp smoke test")
                                           (loop)))))))
                    (error "Marp did not render the slide content")))))))))
    (native-inputs (list patchelf))
    (inputs (list node bash-minimal ungoogled-chromium))
    (home-page "https://marp.app/")
    (synopsis "Create slide decks from Markdown")
    (description
     "Marp CLI converts Markdown presentations into HTML, PDF, PowerPoint,
and images using the Marp slide framework.  It supports themes, live previews,
and a local presentation server.")
    (license license:expat)))
