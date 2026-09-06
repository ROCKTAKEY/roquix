(use-modules (guix extensions extra-profile)
             (roquix extra-profiles paths)
             (srfi srfi-64))

(test-begin "extra-profile-command")

(let ((invocation (parse-reconfigure-arguments '("codex" "codex"
                                                 "texlive"
                                                 "--dry-run"
                                                 "-K"
                                                 "--max-jobs=2"
                                                 "-L"
                                                 "./packages"))))
  (test-assert "reconfigure arguments parse into a distinct state"
               (reconfigure-invocation? invocation))
  (test-equal "reconfigure names are parsed and stably deduplicated"
              '("codex" "texlive")
              (map profile-name-value
                   (reconfigure-invocation-names invocation)))
  (test-assert "dry-run is retained as state"
               (reconfigure-invocation-dry-run? invocation))
  (test-equal "standard build options are forwarded semantically"
              '("--dry-run" "-K" "--max-jobs=2" "-L./packages")
              (reconfigure-invocation-build-arguments invocation)))

(let ((invocation (parse-reconfigure-arguments '("--all" "--no-grafts"))))
  (test-assert "--all is represented independently from profile names"
               (reconfigure-invocation-all? invocation))
  (test-equal "--all has no explicit names"
              '()
              (reconfigure-invocation-names invocation))
  (test-equal "build options after --all are retained"
              '("--no-grafts")
              (reconfigure-invocation-build-arguments invocation)))

(test-end "extra-profile-command")
