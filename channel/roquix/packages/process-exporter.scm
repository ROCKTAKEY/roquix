(define-module (roquix packages process-exporter)
  #:use-module (guix packages)
  #:use-module (guix git-download)
  #:use-module (guix build-system go)
  #:use-module (guix gexp)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (gnu packages golang-build)
  #:use-module (gnu packages golang-check)
  #:use-module (gnu packages golang-xyz)
  #:use-module (gnu packages prometheus))

(define-public go-github-com-ncabatoff-fakescraper
  (package
    (name "go-github-com-ncabatoff-fakescraper")
    (version "0.0.0-20201102132415-4b37ba603d65")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ncabatoff/fakescraper")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "05wlix7qbrrsh913nv90zy9gisanrx38mvfxn10dchfgb84z9dg5"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/ncabatoff/fakescraper"))
    (propagated-inputs (list go-github-com-prometheus-client-golang))
    (home-page "https://github.com/ncabatoff/fakescraper")
    (synopsis "Scrape Prometheus metrics in Go tests")
    (description
     "Scrape Prometheus metrics from inside the app.  Handy for testing.")
    (license license:expat)))

(define-public go-github-com-ncabatoff-go-seq
  (package
    (name "go-github-com-ncabatoff-go-seq")
    (version "0.0.0-20180805175032-b08ef85ed833")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ncabatoff/go-seq")
             (commit (go-version->git-ref version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1x88x285n4wf221pp7ccmh2ai7rgcnwz764gn8k861qg30jl1ky6"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path "github.com/ncabatoff/go-seq/seq"
      #:unpack-path "github.com/ncabatoff/go-seq"))
    (native-inputs (list go-github-com-google-go-cmp))
    (home-page "https://github.com/ncabatoff/go-seq")
    (synopsis "Package for ordering of Go values")
    (description
     "This package is intended to allow ordering (most) values via reflection, much
like go-cmp allows comparing values for equality.")
    (license license:expat)))

(define-public process-exporter
  (package
    (name "process-exporter")
    (version "0.8.7")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ncabatoff/process-exporter")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "09lp1ik5q7rp9w19cg2s6rpz6rsabb3zvjmx3ykcyq2xns3c25bp"))))
    (build-system go-build-system)
    (arguments
     (list
      #:import-path
      "github.com/ncabatoff/process-exporter/cmd/process-exporter"
      #:unpack-path "github.com/ncabatoff/process-exporter"
      #:install-source? #f
      #:embed-files
      #~(list "landing_page.css" "landing_page.html")
      #:phases
      #~(modify-phases %standard-phases
          (replace 'check
            (lambda* (#:key tests? #:allow-other-keys)
              (when tests?
                (invoke "go" "test"
                        "github.com/ncabatoff/process-exporter/..."))))
          (add-after 'unpack 'patch-test-command
            (lambda _
              (substitute* "src/github.com/ncabatoff/process-exporter/proc/read_test.go"
                (("/bin/cat")
                 (which "cat")))))
          (add-after 'unpack 'use-prometheus-slog
            (lambda _
              ;; Prometheus common provides slog logging, as required by
              ;; exporter-toolkit's web.ListenAndServe logger argument.
              (substitute* "src/github.com/ncabatoff/process-exporter/cmd/process-exporter/main.go"
                (("promlog")
                 "promslog")))))))
    (native-inputs (list go-github-com-google-go-cmp
                         go-github-com-ncabatoff-fakescraper
                         go-github-com-ncabatoff-go-seq
                         go-github-com-prometheus-client-golang
                         go-github-com-prometheus-common
                         go-github-com-prometheus-exporter-toolkit
                         go-github-com-prometheus-procfs
                         go-gopkg-in-check-v1
                         go-gopkg-in-yaml-v2))
    (home-page "https://github.com/ncabatoff/process-exporter")
    (synopsis "Export process-group metrics to Prometheus")
    (description
     "Prometheus exporter that mines /proc to report on selected processes.")
    (license license:expat)))
