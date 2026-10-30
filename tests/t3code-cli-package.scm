(use-modules (gnu packages chromium)
             (guix packages)
             (guix gexp)
             (guix monads)
             (guix store)
             (guix build utils)
             ((guix build syscalls) #:select (mkdtemp!))
             (ice-9 textual-ports)
             (srfi srfi-13)
             (roquix packages t3code)
             (srfi srfi-1)
             (srfi srfi-64))

(define (package-phases package)
  (let ((module (make-fresh-user-module))
        (phases (apply (lambda* (#:key phases #:allow-other-keys) phases)
                       (package-arguments package))))
    (module-use! module (resolve-interface '(guix build utils)))
    (module-use! module (resolve-interface '(ice-9 ftw)))
    (module-use! module (resolve-interface '(guix build gnu-build-system)))
    (with-store store
      (eval (lowered-gexp-sexp
             (run-with-store store (lower-gexp phases #:graft? #f)))
            module))))

(test-begin "t3code-cli-package")

(test-equal "the CLI is a separately installable package"
  "t3code-cli" (package-name t3code-cli))

(test-equal "the desktop packages the stable release"
  "0.1.5" (package-version t3code))

(test-assert "CLI and desktop use the same pinned source release"
  (and (equal? (package-version t3code) (package-version t3code-cli))
       (eq? (package-source t3code) (package-source t3code-cli))))

(for-each
 (lambda (package name)
   (test-equal "session sharing is separately installable"
     name (package-name package))
   (test-equal "session sharing uses an immutable commit of the requested fork"
     (string-append "https://codeload.github.com/ROCKTAKEY/t3code/tar.gz/"
                    "c27fe3959e6aa3fbd8e06a8603ff700e62da8d2c")
     (origin-uri (package-source package)))
   (test-assert "the fork version identifies its pinned revision"
     (and (string-prefix? (string-append (package-version t3code) "-")
                          (package-version package))
          (string-contains (package-version package) "c27fe39")))
   (test-equal "the rebased fork uses the verified release dependency cache"
     (assoc-ref (package-native-inputs t3code) "node-modules")
     (assoc-ref (package-native-inputs package) "node-modules")))
 (list t3code-rocktakey t3code-cli-rocktakey)
 '("t3code-rocktakey" "t3code-cli-rocktakey"))

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
          ((assoc-ref (package-phases t3code) 'use-guix-preview-browser)
           #:inputs `(("ungoogled-chromium" . ,directory)))
          (let ((patched (call-with-input-file source get-string-all)))
            (test-assert "the preview service resolves the packaged browser without downloading"
              (and (string-contains patched
                     (format #f "executable: Effect.succeed(~s)" browser))
                   (string-contains patched
                     (format #f "installed: Effect.succeed(Option.some(~s))" browser))
                   (not (string-contains patched "makePreviewBrowser("))))))))
    (lambda () (delete-file-recursively directory))))

(let ((directory (mkdtemp! "/tmp/t3code-vite-peers.XXXXXX")))
  (dynamic-wind
    (lambda () #t)
    (lambda ()
      (with-directory-excursion directory
        (mkdir-p "apps/web/node_modules/vite")
        (mkdir-p "node_modules/.pnpm/vitest/node_modules")
        (mkdir-p "node_modules/.pnpm/vite/node_modules/vite")
        (symlink "../../vite/node_modules/vite"
                 "node_modules/.pnpm/vitest/node_modules/vite")
        ((assoc-ref (package-phases t3code) 'use-toolchain-vite))
        (test-equal "test configuration peers use the application's source-built Vite toolchain"
          (canonicalize-path "apps/web/node_modules/vite")
          (canonicalize-path "node_modules/.pnpm/vitest/node_modules/vite"))))
    (lambda () (delete-file-recursively directory))))

(let ((runner (test-runner-current)))
  (test-end "t3code-cli-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
