(define-module (roquix packages wasm)
  #:use-module (guix packages)
  #:use-module (guix platform)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages node-xyz)
  #:use-module (gnu packages python)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages web)
  #:use-module ((guix licenses)
                #:prefix license:))

(define-public emscripten-4
  (package
    (name "emscripten")
    (version "4.0.10")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://codeload.github.com/emscripten-core/emscripten/tar.gz/"
             version))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "1zklqzns0060zmwrzv1bwbcznwbn9cy1d5ycz51nggq7qb69656w"))))
    (build-system gnu-build-system)
    (arguments
     (list
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 format))
      #:phases
      #~(modify-phases %standard-phases
          (delete 'bootstrap)
          (delete 'configure)
          (delete 'build)
          (delete 'check)
          (replace 'install
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (share (string-append out "/share/emscripten"))
                     (llvm-bin (string-append share "/llvm-bin")))
                (delete-file-recursively "test")
                ;; Guix Clang embeds host glibc include paths.  Keep them out
                ;; of WASM compilation while preserving Emscripten's compat
                ;; headers ahead of its musl headers.
                (substitute* "emcc.py"
                  (("  cflags.append.*sysroot=.*")
                   "  cflags += ['--sysroot=' + cache.get_sysroot(absolute=True), '-nostdlibinc', '-idirafter', cache.get_sysroot(absolute=True) + '/include']
  if shared.run_via_emxx or any(arg.endswith(('.cpp', '.cc', '.cxx')) for arg in user_args):
    cflags = ['-nostdinc++', '-isystem', cache.get_sysroot(absolute=True) + '/include/c++/v1'] + cflags"))
                (copy-recursively "." share)
                (mkdir-p llvm-bin)
                (for-each (lambda (tool)
                            (symlink (search-input-file inputs
                                                        (string-append "/bin/"
                                                         tool))
                                     (string-append llvm-bin "/" tool)))
                          '("clang" "clang++"
                            "llvm-ar"
                            "llvm-nm"
                            "llvm-ranlib"
                            "llvm-objcopy"
                            "wasm-ld"))
                (mkdir-p (string-append share "/node_modules"))
                (symlink (search-input-directory inputs
                                                 "/lib/node_modules/acorn")
                         (string-append share "/node_modules/acorn"))
                (call-with-output-file (string-append share "/.emscripten")
                  (lambda (port)
                    (format port
                     "LLVM_ROOT = ~s~%BINARYEN_ROOT = ~s~%NODE_JS = [~s]~%"
                     llvm-bin
                     #$binaryen
                     #$(file-append node "/bin/node"))))
                (for-each (lambda (tool)
                            (let ((script (string-append out "/bin/" tool)))
                              (mkdir-p (string-append out "/bin"))
                              (call-with-output-file script
                                (lambda (port)
                                  (format port
                                   "#!~a~%unset C_INCLUDE_PATH CPLUS_INCLUDE_PATH CPATH LIBRARY_PATH~%export PYTHON=~s~%exec ~s ~s \"$@\"~%"
                                   (which "sh")
                                   #$(file-append python "/bin/python3")
                                   #$(file-append python "/bin/python3")
                                   (string-append share "/" tool ".py"))))
                              (chmod script #o755)))
                          '("emcc" "em++" "emar" "emranlib" "emcmake" "emmake")))))
          (add-after 'install 'check-compiler
            (lambda* (#:key outputs tests? #:allow-other-keys)
              (when tests?
                (setenv "EM_CACHE"
                        (string-append (getcwd) "/test-cache"))
                (call-with-output-file "smoke.c"
                  (lambda (port)
                    (display "int main(void) { return 0; }\n" port)))
                (invoke (string-append (assoc-ref outputs "out") "/bin/emcc")
                        "smoke.c" "-o" "smoke.js")
                (invoke "node" "smoke.js")))))))
    (inputs (list python
                  node
                  node-acorn
                  clang-21
                  llvm-21
                  lld-21
                  binaryen))
    (home-page "https://emscripten.org/")
    (synopsis "C and C++ to WebAssembly compiler")
    (description
     "Emscripten compiles C and C++ programs to WebAssembly and
provides the JavaScript runtime for browser and Node.js applications.")
    (license (list license:expat license:ncsa))))

(define-public wasm-bindgen-cli-0.2.126
  (package
    (name "wasm-bindgen-cli")
    (version "0.2.126")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://static.crates.io/crates/wasm-bindgen-cli/wasm-bindgen-cli-"
             version ".crate"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0l2vri38gk9a5kni2ir9nx5k0hd5pvgxvwa74dk4xhw7xxpbyblf"))))
    (build-system cargo-build-system)
    (arguments
     (list
      #:rust rust-1.93
      #:install-source? #f
      #:tests? #f))
    (inputs (cargo-inputs 'wasm-bindgen-cli-0.2.126
                          #:module '(roquix packages rust-crates)))
    (home-page "https://github.com/wasm-bindgen/wasm-bindgen")
    (synopsis "JavaScript bindings generator for Rust WebAssembly")
    (description
     "This package provides the wasm-bindgen command-line generator.
The generator and library versions must agree
on the binding metadata embedded in the compiled WebAssembly.")
    (license (list license:expat license:asl2.0))))

(define-public rust-wasm-sysroot-1.95
  (package
    (inherit rust-sysroot-for-wasm32-unknown-unknown)
    (name "rust-wasm-sysroot")
    (version (package-version rust-1.95))
    (source
     (package-source rust-1.95))
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:modules '((guix build gnu-build-system)
                  (guix build utils)
                  (ice-9 format))
      #:phases
      #~(modify-phases %standard-phases
          (replace 'configure
            (lambda _
              (setenv "RUSTC_BOOTSTRAP" "1")
              (setenv "CC" "gcc")
              (setenv "CXX" "g++")
              ;; Guix's Rust source removes bundled native libraries.
              (invoke "python3" "-c"
               "import glob,json
for p in glob.glob('vendor/*/.cargo-checksum.json'):
 d=json.load(open(p)); d['files']={}; json.dump(d,open(p,'w'))")
              (call-with-output-file "bootstrap.toml"
                (lambda (port)
                  (format port
                          (string-append
                           "change-id = 'ignore'~%[build]~%local-rebuild = true~%"
                           "rustc = ~s~%cargo = ~s~%python = ~s~%vendor = true~%"
                           "optimized-compiler-builtins = false~%"
                           "locked-deps = true~%submodules = false~%"
                           "target = ['wasm32-unknown-unknown']~%[rust]~%"
                           "channel = 'stable'~%download-rustc = false~%[llvm]~%"
                           "download-ci-llvm = false~%[target.~a]~%llvm-config = ~s~%"
                           "[target.wasm32-unknown-unknown]~%"
                           "cc = ~s~%cxx = ~s~%ar = ~s~%linker = ~s~%")
                          (which "rustc")
                          (which "cargo")
                          (which "python3")
                          #$(platform-rust-target (lookup-platform-by-system (%current-system)))
                          (which "llvm-config")
                          (which "clang")
                          (which "clang++")
                          (which "llvm-ar")
                          (which "wasm-ld"))))))
          (replace 'build
            (lambda _
              (invoke "python3"
                      "x.py"
                      "build"
                      "--stage"
                      "0"
                      "--target"
                      "wasm32-unknown-unknown"
                      "library/std")))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (lib (string-append out
                           "/lib/rustlib/wasm32-unknown-unknown/lib")))
                ;; Rust keeps full metadata beside hashed archives in deps/.
                ;; Top-level un-hashed archives have no matching metadata.
                (for-each (lambda (file)
                            (install-file file lib))
                          (find-files "build"
                                      (lambda (file stat)
                                        (and (string-contains file
                                              "/wasm32-unknown-unknown/")
                                             (string-contains file "/deps/")
                                             (or (string-suffix? ".rlib" file)
                                                 (string-suffix? ".rmeta" file))))))
                (call-with-output-file "smoke.rs"
                  (lambda (port)
                    (display "fn main() { let _ = String::from(\"WASM\"); }"
                             port)))
                (invoke "rustc"
                        "--target"
                        "wasm32-unknown-unknown"
                        "--sysroot"
                        out
                        "-C"
                        "linker=wasm-ld"
                        "smoke.rs"
                        "-o"
                        "smoke.wasm")))))))
    (native-inputs (list rust-1.95
                         `(,rust-1.95 "cargo")
                         python
                         llvm-22
                         clang-22
                         lld-22
                         zstd))
    (inputs '())))

(define-public wasm-bindgen-cli-0.2.100
  (package
    (inherit wasm-bindgen-cli-0.2.126)
    (name "wasm-bindgen-cli")
    (version "0.2.100")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://static.crates.io/crates/wasm-bindgen-cli/wasm-bindgen-cli-"
             version ".crate"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32 "0n9cp75m6jq6k4c8sfjjn66q7h097w1ns5w49xpppj402ps0czwy"))))
    (inputs (cargo-inputs 'wasm-bindgen-cli-0.2.100
                          #:module '(roquix packages rust-crates)))))

