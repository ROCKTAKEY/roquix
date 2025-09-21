(define-module
  (roquix packages amdgpu-top)
  #:use-module (ice-9 regex)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages xdisorg))

(define-public amdgpu-top
  (package
    (name "amdgpu-top")
    (version "0.11.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/Umio-Yasuno/amdgpu_top")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "02020kc2kxkdb8ynz96j7qq3plml3lvwr4bayiwy87r364px6yv5"))
       (modules '((guix build utils)))
       (snippet
        #~(begin
            (substitute* "crates/libamdgpu_top/Cargo.toml"
              ((#$(regexp-quote
                   ", rev = \"8d0029b4cf8f3b995728614f96c03f6e3dcf4f9e\""))
               "")
              ((#$(regexp-quote
                   ", git = \"https://github.com/Umio-Yasuno/libdrm-amdgpu-sys-rs\""))
               ""))))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.88
      #:cargo-package-crates ''("libamdgpu_top" "amdgpu_top_tui"
                                "amdgpu_top_gui" "amdgpu_top_json"
                                "amdgpu_top")))
    (inputs (cons* libdrm
                   (cargo-inputs 'amdgpu-top
                                 #:module '(roquix packages rust-crates))))
    (home-page "https://github.com/Umio-Yasuno/amdgpu_top")
    (synopsis "Tool to displays AMDGPU usage")
    (description
     "This package provides Tool to displays AMDGPU usage.
The tool displays information gathered from performance counters (GRBM, GRBM2),
sensors, fdinfo, gpu_metrics and AMDGPU driver.")
    (license license:expat)))
