((nil
  (geiser-guile-binary . ("guix" "repl"))
  (eval . (setq geiser-guile-load-path
                (list (expand-file-name "." (locate-dominating-file default-directory ".dir-locals.el")))))))
