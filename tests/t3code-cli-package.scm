(use-modules (gnu packages chromium)
             (guix packages)
             (guix gexp)
             (guix monads)
             (guix store)
             (guix utils)
             (guix build utils)
             (guix build gnu-build-system)
             ((guix build syscalls) #:select (mkdtemp!))
             (ice-9 textual-ports)
             (srfi srfi-13)
             (roquix packages t3code)
             (srfi srfi-1)
             (srfi srfi-64))

(test-begin "t3code-cli-package")

(test-equal "the CLI is a separately installable package"
  "t3code-cli" (package-name t3code-cli))

(test-assert "CLI and desktop use the same pinned source release"
  (and (equal? (package-version t3code) (package-version t3code-cli))
       (eq? (package-source t3code) (package-source t3code-cli))))

(test-assert "the CLI needs no Electron runtime or desktop capture helpers"
  (not (any (lambda (input)
              (member (car input)
                      '("electron" "t3code-xa11y-native" "t3-resource-monitor"
                        "t3-hyprland-snap-shot" "t3-kde-snap-shot")))
            (package-inputs t3code-cli))))

(for-each
 (lambda (package)
   (test-assert "preview browsers use Guix Chromium at runtime"
     (any (lambda (input) (eq? (cadr input) ungoogled-chromium))
          (package-inputs package))))
 (list t3code t3code-cli))

;; Exercise the build phase against the upstream service construction contract.
(let* ((directory (mkdtemp! "/tmp/t3code-preview.XXXXXX"))
       (browser (string-append directory "/bin/chromium")))
  (dynamic-wind
    (lambda ()
      (mkdir-p (dirname browser))
      (call-with-output-file browser (lambda (port) (display "browser" port))))
    (lambda ()
      (with-directory-excursion directory
        (mkdir-p "apps/server/src/preview")
        (let ((source "apps/server/src/preview/PreviewBrowser.ts"))
          (call-with-output-file source
            (lambda (port)
              (display "return yield* makePreviewBrowser({ baseDir: config.baseDir });"
                       port)))
          (let* ((expression (with-store store
                               (lowered-gexp-sexp
                                (run-with-store store
                                  (lower-gexp
                                   (apply (lambda* (#:key phases #:allow-other-keys) phases)
                                          (package-arguments t3code))
                                   #:graft? #f)))))
                 (module (make-fresh-user-module))
                 (phases (begin
                           (module-use! module (resolve-interface '(guix build utils)))
                           (module-use! module (resolve-interface '(guix build gnu-build-system)))
                           (eval expression module))))
            ((assoc-ref phases 'use-guix-preview-browser)
             #:inputs `(("ungoogled-chromium" . ,directory))))
          (let ((patched (call-with-input-file source get-string-all)))
            (test-assert "the preview service resolves the packaged browser without downloading"
              (and (string-contains patched
                     (format #f "executable: Effect.succeed(~s)" browser))
                   (string-contains patched
                     (format #f "installed: Effect.succeed(Option.some(~s))" browser))
                   (not (string-contains patched "makePreviewBrowser("))))))))
    (lambda () (delete-file-recursively directory))))

(let ((runner (test-runner-current)))
  (test-end "t3code-cli-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
