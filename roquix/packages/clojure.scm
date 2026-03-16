(define-module (roquix packages clojure)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix gexp)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages java))

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

(define-public clojure-lsp
  (package
    (name "clojure-lsp")
    (version "2023.07.01-22.35.41")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://github.com/clojure-lsp/clojure-lsp/releases/download/"
                    version "/clojure-lsp"))
              (sha256
               (base32
                "1ikjbmmzmjh5z1dw6bj8l8drfh6567cvvhzcy9rv8fnwn4cax5lz"))))
    (build-system binary-build-system)
    (arguments
     (list
      #:install-plan #~'(("./" "bin/"))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'chroot
            (lambda* (#:key inputs #:allow-other-keys)
              (chmod (string-append #$output "/bin/clojure-lsp") #o555)
              ;; FIXME: the clojure-lsp file is partial binary, so cannot use substitute.
              (substitute* (string-append #$output "/bin/clojure-lsp")
                (("exec java")
                 (string-append
                  "exec "
                  (assoc-ref inputs "openjdk") "/bin/java"))))))))
    (inputs
     (list openjdk))
    (home-page "https://clojure-lsp.io/")
    (synopsis "Clojure & ClojureScript Language Server (LSP) implementation")
    (description
     "A Language Server for Clojure(script).
Taking a Cursive-like approach of statically analyzing code.")
    (license license:expat)))
