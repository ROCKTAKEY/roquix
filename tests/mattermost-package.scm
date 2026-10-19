(use-modules (guix packages)
             (guix build-system)
             (roquix packages mattermost)
             (srfi srfi-13)
             (srfi srfi-64))

(test-begin "mattermost-package")
(test-assert "the application is built from the pinned upstream source archive"
  (string-prefix? "https://codeload.github.com/mattermost/desktop/tar.gz/"
                  (origin-uri (package-source mattermost-desktop))))
(test-assert "Electron is an explicit runtime dependency"
  (assoc-ref (package-inputs mattermost-desktop) "electron"))
(let ((runner (test-runner-current)))
  (test-end "mattermost-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
