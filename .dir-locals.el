((nil
  (geiser-guile-binary . ("guix" "repl"))
  (eval . (setq geiser-guile-load-path
                (cons
                 (expand-file-name "." (locate-dominating-file default-directory ".dir-locals.el"))
                 geiser-guile-load-path)))))
