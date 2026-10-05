(define-module (roquix packages zotero)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (gnu packages base)
  #:use-module (guix download)
  #:use-module (nonguix build-system binary)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages glib)
  #:use-module (ice-9 regex))

(define-public zotero
  (package
    (name "zotero")
    (version "6.0.18")
    (source (origin
              (method url-fetch)
              (uri (string-append
                    "https://download.zotero.org/client/release/" version
                    "/Zotero-" version "_linux-x86_64.tar.bz2"))
              (sha256
               (base32
                "0vbwbalz1cf35d2znq7lvxq9pll5ax9sb8ld7gaagdid32z6301h"))))
    (build-system binary-build-system)
    (arguments
     `(#:patchelf-plan `(("zotero-bin" ("gcc:lib"))
                         ("libmozgtk.so" ("gtk+"))
                         ("libxul.so" ("libx11" "dbus-glib")))
       #:install-plan '(("./" "/opt/zotero/"))
       #:phases (modify-phases %standard-phases
                  (add-after 'patch-usr-bin-file 'patch-launcher
                    (lambda* (#:key outputs #:allow-other-keys)
                      (substitute* "zotero"
                        ((,(regexp-quote
                                         "$(dirname \"$(readlink -f \"$0\")\")"))
                         (string-append (assoc-ref outputs "out")
                                        "/opt/zotero")))))
                  (add-after 'install 'install-bin
                    (lambda* (#:key outputs #:allow-other-keys)
                      (mkdir-p (string-append (assoc-ref outputs "out") "/bin"))
                      (symlink (string-append (assoc-ref outputs "out")
                                              "/opt/zotero/zotero")
                               (string-append (assoc-ref outputs "out")
                                              "/bin/zotero"))
                      (mkdir-p (string-append (assoc-ref outputs "out")
                                              "/share/applications"))
                      (symlink (string-append (assoc-ref outputs "out")
                                              "/opt/zotero/zotero.desktop")
                               (string-append (assoc-ref outputs "out")
                                "/share/applications/zotero.desktop")))))))
    (inputs `(("coreutils" ,coreutils)
              ("gcc:lib" ,gcc "lib")
              ("gtk+" ,gtk+)
              ("libx11" ,libx11)
              ("dbus-glib" ,dbus)))
    (synopsis
     "Zotero is a free, easy-to-use tool to help you collect, organize, annotate, cite, and share research.")
    (description
     "Zotero is a free, easy-to-use tool to help you collect, organize, annotate, cite, and share research.")
    (home-page "https://github.com/latex-lsp/texlab")
    (license license:gpl3)))
