(use-modules (guix packages)
             (srfi srfi-1)
             (srfi srfi-64))

(define calendar
  (false-if-exception
   (module-ref (resolve-interface '(roquix packages dux-calendar))
               'dux-calendar)))

(test-begin "dux-calendar-package")
(test-assert "Dux Calendar is available from the channel" (package? calendar))
(when (package? calendar)
  (test-assert "the UI and browser launcher are runtime dependencies"
    (every (lambda (name) (assoc-ref (package-inputs calendar) name))
           '("quickshell" "xdg-utils")))
  (test-assert "Go build dependencies do not enter the user's profile"
    (null? (package-propagated-inputs calendar))))
(let ((runner (test-runner-current)))
  (test-end "dux-calendar-package")
  (exit (if (zero? (test-runner-fail-count runner)) 0 1)))
