(define-module
  (roquix packages logseq)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (gnu packages linux)
  #:use-module (nonguix build-system binary))

(define-public logseq
  (package
    (name "logseq")
    (version "0.7.6")
    (source (origin
             (method url-fetch)
             (uri (string-append "https://github.com/logseq/logseq/releases/download/"
                                 version "/Logseq-linux-x64-" version ".AppImage"))
             (sha256
              (base32
               "0ci6x9bq5jqhwx83mw78k9029wddjy7i6164n4jgbrhkjk98x06x"))))
    (build-system binary-build-system)
    (arguments `(#:install-plan
                 '((,(string-append "Logseq-linux-x64-" version ".AppImage") "bin/"))))
    (home-page "https://logseq.com/")
    (synopsis "A privacy-first, open-source platform for knowledge management and collaboration")
    (description "A privacy-first, open-source platform for knowledge management and collaboration.")
    (license license:agpl3)))
