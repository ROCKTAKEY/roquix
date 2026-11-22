(define-module (roquix packages oh-my-hermes)
  #:use-module (gnu packages check)
  #:use-module (gnu packages node)
  #:use-module (gnu packages python-build)
  #:use-module (guix build-system pyproject)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages))

(define-public oh-my-hermes
  (let ((commit "78e2c3b62e75a15da59e0e7e9cbc60762dc074cf"))
    (package
      (name "oh-my-hermes")
      (version "5.0.0")
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/rlaope/oh-my-hermes")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0jhzmv39j5sxjsrss5k0376hci1rwwhz60allmwapvgrrci9a8qx"))))
      (build-system pyproject-build-system)
      (arguments
       (list
        #:test-flags #~(list "tests/test_channel_watch_routing.py"
                             "tests/test_release_version_display.py")
        #:phases
        #~(modify-phases %standard-phases
            ;; The installer verifies the original bytes of bundled skill scripts.
            (delete 'patch-source-shebangs)
            (delete 'patch-shebangs)
            (add-after 'unpack 'record-release-commit
              (lambda _
                ;; git-fetch leaves Git archive's export-subst marker unexpanded.
                (call-with-output-file "src/omh/_archive_commit.txt"
                  (lambda (port) (display #$commit port)))))
            (add-after 'wrap 'wrap-node
              (lambda* (#:key inputs #:allow-other-keys)
                ;; Hermes launches the terminal UI with node inherited from omh.
                (wrap-program (string-append #$output "/bin/omh")
                  `("PATH" suffix
                    (,(dirname (search-input-file inputs "/bin/node"))))))))))
      (native-inputs (list python-pytest python-setuptools python-wheel))
      (inputs (list node))
      (home-page "https://omher.app/")
      (synopsis "Workflow and skill manager for Hermes Agent")
      (description
       "Oh My Hermes provides the omh command to install Hermes Agent skills,
route tasks to specialized agents and coordinate parallel workflows.")
      (license license:expat))))
