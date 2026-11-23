(define-module (roquix packages strata)
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages rocm)
  #:use-module (gnu packages rocm-libs)
  #:use-module (gnu packages serialization)
  #:use-module (srfi srfi-13))

(define %strata-commit
  "a34979fc94f3d126b9bb8210f4ad311345688b52")

(define (strata-resource-path name)
  (canonicalize-path
   (search-path %load-path (string-append "roquix/packages/strata/" name))))

(define %strata-hip-architectures
  '("gfx1030" "gfx1100" "gfx1101" "gfx1200" "gfx1201"))

(define %strata-ca-bundle
  (computed-file "strata-ca-certificates.crt"
    (with-imported-modules '((guix build utils))
      #~(begin
          (use-modules (guix build utils) (rnrs io ports))
          (call-with-output-file #$output
            (lambda (port)
              (for-each
               (lambda (certificate)
                 (display (call-with-input-file certificate get-string-all)
                          port))
               (find-files #$(file-append nss-certs "/etc/ssl/certs")
                           "\\.pem$"))))))))

(define-public strata-hip
  (package
    (name "strata-hip")
    (version "0.2.20")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://codeload.github.com/Niko1221/Strata/tar.gz/"
             %strata-commit))
       (file-name (string-append "strata-" version ".tar.gz"))
       (sha256
        (base32 "0waihpn8rdpv33yvj0cyxnb171z3wqwmnf2g1pbn279p067mqd4d"))
       (patches (list (strata-resource-path "strata-hip-setup.patch")
                      (strata-resource-path "strata-parser-timing.patch")
                      (strata-resource-path "strata-server-tests.patch")
                      (strata-resource-path "strata-shape-engines.patch")))
       (modules '((guix build utils)))
       (snippet
        ;; The optional control vector carries a separate Qwen model license.
        #~(delete-file-recursively "terminal/data/experimental-speed-projection"))))
    (build-system cmake-build-system)
    (arguments
     (list
      #:build-type "Release"
      #:configure-flags
      #~(list "-DSTRATA_ENABLE_HIP=ON"
         "-DSTRATA_ENABLE_CUDA=OFF"
         "-DSTRATA_PORTABLE=ON"
         "-DSTRATA_BUILD_TESTS=OFF"
         "-DSTRATA_BUILD_CONVERSATION_TESTS=ON"
         #$(string-append "-DSTRATA_BUILD_ID="
                          (string-take %strata-commit 9))
         #$(string-append "-DCMAKE_HIP_ARCHITECTURES="
                          (string-join %strata-hip-architectures ";"))
         (string-append "-DCMAKE_C_COMPILER="
                        #$(file-append rocm-toolchain "/bin/clang"))
         (string-append "-DCMAKE_CXX_COMPILER="
                        #$(file-append rocm-toolchain "/bin/clang++"))
         (string-append "-DCMAKE_HIP_COMPILER="
                        #$(file-append rocm-toolchain "/bin/clang++"))
         (string-append "-DCMAKE_HIP_COMPILER_ROCM_ROOT="
                        #$rocm-hip-runtime)
         (string-append "-DSTRATA_ROCM_BITCODE_PATH="
                        #$(file-append rocm-device-libs "/amdgcn/bitcode"))
         (string-append "-DCMAKE_HIP_FLAGS=--rocm-path="
                        #$rocm-hip-runtime " --rocm-device-lib-path="
                        #$(file-append rocm-device-libs "/amdgcn/bitcode")))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'enter-engine
            (lambda _
              (setenv "STRATA_SOURCE_DIR" (canonicalize-path "terminal"))
              (setenv "PYTHONDONTWRITEBYTECODE" "1")
              (chdir "engine")
              ;; Clang requires alignas before HIP's shared-storage attribute.
              (substitute* (find-files "src/inkling2/hip" "\\.h(pp)?$")
                (("__shared__ alignas\\(16\\)") "alignas(16) __shared__"))))
          (replace 'build
            (lambda* (#:key parallel-build? #:allow-other-keys)
              (invoke "cmake"
                      "--build"
                      "."
                      "--target"
                      "strata-inkling" "strata-hy4"
                      "strata"
                      "strata-device"
                      "strata-gguf"
                      "strata-plan"
                      "conversation_cache_test"
                      "conversation_memory_test"
                      "file_expert_source_test"
                      "--parallel"
                      (number->string (if parallel-build?
                                          (parallel-job-count) 1)))))
          (replace 'check
            (lambda* (#:key tests? inputs #:allow-other-keys)
              (when tests?
                (setenv "SSL_CERT_FILE"
                        #$%strata-ca-bundle)
                ;; Build workers have no GPU; run device tests on the installed
                ;; package, while keeping CPU and server tests in the build.
                (invoke "./strata-hy4" "--version")
                (invoke "./src/inkling2/strata-inkling" "--version")
                (invoke "ctest" "--output-on-failure" "-R"
                        (string-append
                         "^(conversation_(cache|memory)|"
                         "file_expert_source)_test$"))
                (with-directory-excursion (getenv "STRATA_SOURCE_DIR")
                  ;; The Inkling mock engine generates an executable shell script.
                  (substitute* "serve/test_inkling_serve_e2e.py"
                    (("#!/bin/sh") (string-append "#!" (which "sh"))))
                  ;; The Windows ZIP fixture uses strata.exe even on Linux.
                  (invoke "python3" "-c"
                          (string-append
                           "import setup,unittest; setup.EXE='strata.exe'; "
                           "unittest.main(module='tools.test_setup_amd')"))
                  (invoke "python3" "tools/test_setup_choices.py")
                  (invoke "python3"
                          "-m"
                          "unittest"
                          "discover"
                          "-s"
                          "serve"
                          "-p"
                          "test_*.py"))
                (invoke "python3"
                        (assoc-ref inputs "setup-tests")))))
          (replace 'install
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (bin (string-append out "/bin"))
                     (share (string-append out "/share/strata"))
                     (engine (string-append share "/engine"))
                     (source (getenv "STRATA_SOURCE_DIR")))
                (mkdir-p bin)
                (mkdir-p engine)
                (for-each (lambda (name)
                            (install-file name engine)
                            (let ((exe (basename name)))
                              (symlink (string-append engine "/" exe)
                                       (string-append bin "/" exe))))
                          '("strata" "strata-device" "strata-gguf"
                            "strata-plan" "strata-hy4" "src/inkling2/strata-inkling"))
                (for-each (lambda (name)
                            (copy-recursively (string-append source "/" name)
                                              (string-append share "/" name)))
                          '("serve" "tools" "data" "strata_control" "strata_cli"))
                (for-each (lambda (name)
                            (install-file (string-append source "/" name)
                                          share))
                          '("setup.py" "requirements.txt" "requirements-monitor.txt"))
                (install-file (string-append source "/../LICENSE") share)
                (install-file (string-append source "/../engine/CMakeLists.txt") share)
                (copy-recursively (string-append source "/../engine/third_party/strata-gguf-py")
                                  (string-append share "/third_party/strata-gguf-py"))
                (invoke "python3"
                        "-c"
                        (string-append "import json,sys; json.dump({"
                         "'backend':'hip', 'source':'guix', 'version':sys.argv[2],"
                         "'archs':sys.argv[3].split(';'),"
                         "'vision':'none', 'lib_dirs':sys.argv[4:]},"
                         "open(sys.argv[1], 'w'))")
                        (string-append engine "/BUILD.json")
                        "0.1.66"
                        #$(string-join %strata-hip-architectures ";")
                        #$(file-append rocm-hip-runtime "/lib")
                        #$(file-append hipblas "/lib")
                        #$(file-append hipblaslt "/lib"))
                (for-each (lambda (entry)
                            (let ((program (string-append bin "/"
                                                          (car entry))))
                              (call-with-output-file program
                                (lambda (port)
                                  (format port
                                          "#!~a~%exec ~a ~a ~a \"$@\"~%"
                                          (which "sh")
                                          #$(file-append python "/bin/python3")
                                          (string-append share "/"
                                                         (cadr entry))
                                          (caddr entry))))
                              (chmod program #o755)
                              (wrap-program program
                                `("PATH" ":" prefix
                                  (,(string-append #$procps "/bin")))
                                `("GUIX_PYTHONPATH" ":" prefix
                                  (,(getenv "GUIX_PYTHONPATH")))
                                `("SSL_CERT_FILE" =
                                  (,#$%strata-ca-bundle))
                                '("PYTHONDONTWRITEBYTECODE" =
                                  ("1")))))
                          '(("strata-setup" "setup.py" "")
                            ("strata-server" "serve/server.py"
                             "--engine strata")))))))))
    (native-inputs (list (list "pkg-config" pkg-config)
                         (list "rocm-toolchain" rocm-toolchain)
                         (list "setup-tests"
                               (local-file (strata-resource-path
                                            "test_setup.py")))))
    (inputs (list bash-minimal
                  rocm-hip-runtime
                  hipblas
                  hipblas-common
                  hipblaslt
                  procps
                  python
                  python-numpy
                  python-jinja2
                  python-jsonschema
                  python-regex
                  python-pyyaml
                  python-tqdm
                  python-requests
                  python-pillow
                  python-psutil))
    (supported-systems '("x86_64-linux"))
    (home-page "https://github.com/Niko1221/Strata")
    (synopsis "Local model inference with AMD HIP")
    (description
     "Strata runs Qwen3.8-Flash-Next, Hy4-Flash and Inkling-2-Mini
using GPU memory,
system RAM, and SSD storage.  This package provides the AMD HIP engines, model
preparation tools, and a local web server with OpenAI- and Anthropic-compatible
APIs.  Model weights are downloaded separately into user-selected storage.")
    (license (list license:expat license:silofl1.1))))
