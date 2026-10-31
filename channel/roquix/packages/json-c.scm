(define-module (roquix packages json-c)
  #:use-module ((gnu packages web) #:prefix guix:)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix utils))

(define (json-c-resource path)
  (canonicalize-path
   (search-path %load-path (string-append "roquix/packages/" path))))

(define-public json-c
  (package
    (inherit guix:json-c)
    (source
     (origin
       (inherit (package-source guix:json-c))
       (patches
        (append (origin-patches (package-source guix:json-c))
                (list (json-c-resource
                       "patches/json-c-free-outside-assert.patch"))))))
    (arguments
     (substitute-keyword-arguments (package-arguments guix:json-c)
       ((#:phases phases #~%standard-phases)
        #~(modify-phases #$phases
            (add-after 'install 'check-release
              (lambda* (#:key tests? target outputs #:allow-other-keys)
                (when (and tests? (not target))
                  (let ((out (assoc-ref outputs "out")))
                    (invoke "gcc"
                            #$(local-file
                               (json-c-resource
                                "json-c/package-tests/check-release.c"))
                            (string-append "-I" out "/include")
                            (string-append "-L" out "/lib")
                            (string-append "-Wl,-rpath," out "/lib")
                            "-ljson-c" "-o" "check-release")
                    (invoke "./check-release")))))))))))
