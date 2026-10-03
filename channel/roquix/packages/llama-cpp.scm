(define-module (roquix packages llama-cpp)
  #:use-module (gnu packages machine-learning)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix packages))

(define-public llama-cpp-llm-jp
  (let ((commit "26b0e874a2893ba36bc2bea526c5a8ab6637ab2a")
        (build-number "9376"))
    (package
      (inherit llama-cpp)
      (name "llama-cpp-llm-jp")
      (version (string-append "0.0." build-number))
      (source
       (origin
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/llm-jp/llama.cpp")
               (commit commit)))
         (file-name (git-file-name name version))
         (sha256
          (base32 "0wmdb3cjgk7cqsgrgxkr3iiwm3iagb6zbh0j5zf7fps1fj0kzifx"))))
      (arguments
       (list
        #:configure-flags
        #~(list "-DBUILD_SHARED_LIBS=ON"
                ;; Guix checkouts omit .git, which build-info.cmake needs.
                #$(string-append "-DLLAMA_BUILD_NUMBER=" build-number)
                #$(string-append "-DLLAMA_BUILD_COMMIT=" commit)
                ;; This fork calls ggml_ssm_scan with eight arguments, but
                ;; Guix's ggml 0.25.2 requires a ninth K argument.
                ;; See src/llama-model-loader.cpp:990 in the pinned source and
                ;; https://github.com/ggml-org/ggml/blob/v0.25.2/include/ggml.h#L2529
                "-DLLAMA_USE_SYSTEM_GGML=OFF"
                "-DLLAMA_TESTS_INSTALL=OFF"
                ;; UI compilation and fallback download need network access.
                "-DLLAMA_BUILD_UI=OFF"
                "-DLLAMA_USE_PREBUILT_UI=OFF")
        #:phases
        #~(modify-phases %standard-phases
            (replace 'check
              (lambda* (#:key (tests? #t) #:allow-other-keys)
                ;; The chat test exercises parsing without downloading a model.
                (when tests?
                  (invoke "ctest" "--output-on-failure" "-R" "^test-chat$")))))))
      (inputs (modify-inputs (package-inputs llama-cpp)
                (delete "ggml" "ui.tar.gz")))
      (home-page "https://github.com/llm-jp/llama.cpp")
      (synopsis "Llama.cpp with LLM-jp tokenizer handling")
      (description
       "This package provides the LLM-jp fork of llama.cpp.  Its tokenizer
and server handle leading spaces after special tokens in LLM-jp GGUF models.
Model weights are obtained separately."))))
