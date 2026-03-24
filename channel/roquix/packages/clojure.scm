(define-module (roquix packages clojure)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (nonguix build-system binary))

(define-public babashka
  (package
    (name "babashka")
    (version "1.3.181")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/babashka/babashka/releases/download/v"
                    version "/babashka-" version "-linux-amd64-static.tar.gz"))
              (sha256
               (base32
                "1akk4dp3glgxw5jpvpcx0zx2hx79jnx8bqmaylf3z0r5ynvb4zzv"))))
    (build-system binary-build-system)
    (arguments
     '(#:install-plan '(("bb" "bin/"))))
    (home-page "https://github.com/babashka/babashka")
    (synopsis "Native, fast starting Clojure interpreter for scripting")
    (description
     "Babashka is a native Clojure interpreter for scripting with fast startup.
Its main goal is to leverage Clojure in places where you would be using bash otherwise.")
    (license license:epl1.0)))
