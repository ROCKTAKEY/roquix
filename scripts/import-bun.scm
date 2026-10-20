(use-modules (guix extensions import-bun))

(apply guix-import-bun (cdr (command-line)))
