(use-modules (guix packages)
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

(let ((runner (test-runner-current)))
  (test-end "t3code-cli-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
