(define-module (roquix packages strata)
  #:use-module (guix build-system cmake)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages python-web)
  #:use-module (gnu packages python-xyz)
  #:use-module (gnu packages rocm)
  #:use-module (gnu packages rocm-libs)
  #:use-module (gnu packages serialization)
  #:use-module (srfi srfi-13))

(define %strata-llama-source
  ;; Strata uses ggml's internal headers and its own pinned tensor layout.
  ;; https://github.com/Niko1221/Strata/blob/v0.1.45/third_party/ggml/VERSION.txt
  (origin
    (method url-fetch)
    (uri (string-append
          "https://codeload.github.com/ggml-org/llama.cpp/tar.gz/"
          "3cf03257f219afbe7334045ff7c6a06ac68c627d"))
    (file-name "strata-llama.cpp-3cf0325.tar.gz")
    (sha256
     (base32 "1052avqwwwd0mqhp4whdvvric73r3sqjbm50q875s3ps999xfxn0"))))

(define (strata-resource-path name)
  (canonicalize-path
   (search-path %load-path (string-append "roquix/packages/strata/" name))))

(define %strata-hip-architectures
  '("gfx1030" "gfx1100" "gfx1101" "gfx1200" "gfx1201"))

(define-public strata-hip
  (package
    (name "strata-hip")
    (version "0.1.45")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://codeload.github.com/Niko1221/Strata/tar.gz/"
             "477ac13cbe8e582c20484871ce459d20d82df09d"))
       (file-name (string-append "strata-" version ".tar.gz"))
       (sha256
        (base32 "1jgkj2460xrczjs3dpa6f9l28aqsx4cdr9jz37ws1g99xvb5pdkp"))
       (patches (list (strata-resource-path "strata-hip-setup.patch")
                      (strata-resource-path "strata-hip-align.patch")
                      (strata-resource-path "strata-hip-sampler.patch")
                      (strata-resource-path "strata-missing-disk-counters.patch")
                      (strata-resource-path "strata-cgroup-root.patch")))
       (modules '((guix build utils)))
       (snippet
        ;; The optional control vector carries a separate Qwen model license.
        #~(delete-file-recursively "data/experimental-speed-projection"))))
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
         "-DSTRATA_PREFILL_MMQ=ON"
         "-DSTRATA_GGML_DIR=../strata-llama-source"
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
         (string-append "-DCMAKE_HIP_FLAGS=--rocm-path="
                        #$rocm-hip-runtime " --rocm-device-lib-path="
                        #$(file-append rocm-device-libs "/amdgcn/bitcode")))
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'unpack-ggml
            (lambda* (#:key inputs #:allow-other-keys)
              (setenv "STRATA_SOURCE_DIR"
                      (getcwd))
              (setenv "PYTHONDONTWRITEBYTECODE" "1")
              (mkdir-p "../strata-llama-source")
              (invoke "tar"
                      "xf"
                      (assoc-ref inputs "llama-source")
                      "--strip-components=1"
                      "-C"
                      "../strata-llama-source")))
          (replace 'build
            (lambda* (#:key parallel-build? #:allow-other-keys)
              (invoke "cmake"
                      "--build"
                      "."
                      "--target"
                      "strata"
                      "strata-device"
                      "strata-gguf"
                      "strata-plan"
                      "conversation_cache_test"
                      "conversation_memory_test"
                      "cgroup_path_test"
                      "file_expert_source_test"
                      "--parallel"
                      (number->string (if parallel-build?
                                          (parallel-job-count) 1)))))
          (replace 'check
            (lambda* (#:key tests? inputs #:allow-other-keys)
              (when tests?
                ;; Build workers have no GPU; run device tests on the installed
                ;; package, while keeping CPU and server tests in the build.
                (invoke "ctest" "--output-on-failure" "-R"
                        "^(conversation_(cache|memory)|cgroup_path|file_expert_source)_test$")
                (with-directory-excursion (getenv "STRATA_SOURCE_DIR")
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
                            (symlink (string-append engine "/" name)
                                     (string-append bin "/" name)))
                          '("strata" "strata-device" "strata-gguf"
                            "strata-plan"))
                (for-each (lambda (name)
                            (copy-recursively (string-append source "/" name)
                                              (string-append share "/" name)))
                          '("serve" "tools" "data"))
                (for-each (lambda (name)
                            (install-file (string-append source "/" name)
                                          share))
                          '("setup.py" "CMakeLists.txt" "requirements.txt"
                            "LICENSE"))
                (copy-recursively "../strata-llama-source/gguf-py"
                                  (string-append share
                                   "/third_party/llama.cpp/gguf-py"))
                (invoke "python3"
                        "-c"
                        (string-append "import json,sys; json.dump({"
                         "'backend':'hip', 'source':'guix', 'version':sys.argv[2],"
                         "'archs':sys.argv[3].split(';'),"
                         "'vision':'none', 'lib_dirs':sys.argv[4:]},"
                         "open(sys.argv[1], 'w'))")
                        (string-append engine "/BUILD.json")
                        #$version
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
                                `("GUIX_PYTHONPATH" ":" prefix
                                  (,(getenv "GUIX_PYTHONPATH")))
                                `("SSL_CERT_FILE" =
                                  (,(string-append #$nss-certs
                                     "/etc/ssl/certs/ca-certificates.crt")))
                                '("PYTHONDONTWRITEBYTECODE" =
                                  ("1")))))
                          '(("strata-setup" "setup.py" "")
                            ("strata-server" "serve/server.py"
                             "--engine strata")))))))))
    (native-inputs (list (list "pkg-config" pkg-config)
                         (list "rocm-toolchain" rocm-toolchain)
                         (list "llama-source" %strata-llama-source)
                         (list "setup-tests"
                               (local-file (strata-resource-path
                                            "test_setup.py")))))
    (inputs (list bash-minimal
                  rocm-hip-runtime
                  hipblas
                  hipblas-common
                  hipblaslt
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
    (synopsis "Local Qwen3.8-Flash-Next inference with AMD HIP")
    (description
     "Strata runs Qwen3.8-Flash-Next and supported derivatives using GPU memory,
system RAM, and SSD storage.  This package provides the AMD HIP engine, model
preparation tools, and a local web server with OpenAI- and Anthropic-compatible
APIs.  Model weights are downloaded separately into user-selected storage.")
    (license (list license:expat license:silofl1.1))))
