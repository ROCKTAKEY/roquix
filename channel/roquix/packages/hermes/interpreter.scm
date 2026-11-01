(define-module (roquix packages hermes interpreter)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (gnu packages)
  #:use-module (gnu packages python))

;; Hermes's lock selects Python >= 3.14.  Build that interpreter family with
;; Guix's CPython phases and system libraries.
(define-public hermes-python
  (package
    (inherit (hidden-package python-3.13))
    (name "hermes-python")
    (version "3.14.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://www.python.org/ftp/python/" version
                           "/Python-" version ".tar.xz"))
       (sha256
        (base32 "0lqyrpx7zy9c2aa7csb9hv6wfp66j9578sak8d36xnpb3k19lbg0"))
       (patches (search-patches "python-3-deterministic-build-info.patch"
                                "python-3.13-fix-tests.patch"))
       (modules '((guix build utils)))
       (snippet
        '(begin
           (delete-file-recursively "Modules/expat")
           (substitute* "Modules/Setup"
             (("^#pyexpat.*")
              "pyexpat pyexpat.c -lexpat\n"))))))
    (arguments
     (substitute-keyword-arguments (package-arguments python-3.13)
       ((#:make-flags flags)
        ;; Keep test socket paths below AF_UNIX's limit; the longer Guix build
        ;; directory otherwise makes multiprocessing fall back outside TMPDIR.
        #~(map (lambda (flag)
                 (string-append flag " --tempdir=/tmp -u-network"))
               #$flags))
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'unpack 'adapt-python-tests
              (lambda _
                ;; Exercise permission failure without triggering the unrelated
                ;; AF_UNIX path-length fallback in multiprocessing.util.
                (substitute* "Lib/test/_test_multiprocessing.py"
                  (("with support.os_helper.temp_dir\\(\\) as root:")
                   "with tempfile.TemporaryDirectory(prefix='mp-', dir='/tmp') as root:"))
                ;; CPython 3.14 restores the normal SIGINT handler for doctests.
                (substitute* "Lib/test/test_pdb.py"
                  (("pdb ([12]): 1" _ number)
                   (string-append "pdb " number
                                  ": <built-in function default_int_handler>")))
                ;; These upstream tests perform DNS/HTTP requests even when the
                ;; regrtest network resource is disabled.
                (substitute* "Lib/test/test_urllib2.py"
                  (("    def test_ftp_error")
                   "    @unittest.skipUnless(support.is_resource_enabled('network'), 'network disabled')
    def test_ftp_error"))
                (substitute* "Lib/test/test_urllibnet.py"
                  (("    def test_getcode")
                   "    @unittest.skipUnless(support.is_resource_enabled('network'), 'network disabled')
    def test_getcode"))))
            (add-before 'check 'zip-compatible-source-date
              (lambda _
                ;; CPython 3.14 uses SOURCE_DATE_EPOCH for new ZIP entries.
                (setenv "SOURCE_DATE_EPOCH" "315532800")))
            (replace 'install-sitecustomize.py
              #$((@@ (gnu packages python) customize-site)
                 version))))))
    (native-search-paths
     (list ((@@ (gnu packages python) guix-pythonpath-search-path)
            version)))))

(define-public hermes-python-wrapper
  (hidden-package
   ((@@ (gnu packages python) wrap-python3)
    hermes-python)))

