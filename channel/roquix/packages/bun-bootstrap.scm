(define-module (roquix packages bun-bootstrap)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (guix base16)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix gexp)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix records)
  #:use-module (guix utils)
  #:use-module (guix build-system cargo)
  #:use-module (guix build-system gnu)
  #:use-module (roquix build-system bun)
  #:use-module (roquix packages bun-npm-inputs)
  #:use-module (roquix packages rust-crates)
  #:use-module (gnu packages)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages file)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages rsync)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages rust-apps)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages web)
  #:use-module (gnu packages zig)
  #:use-module (ice-9 match)
  #:use-module (ice-9 textual-ports)
  #:export (%bun-1.0.7-bootstrap-npm-inputs bun-bootstrap-1.0.7))

;; This module contains only source-bootstrap stages.  In particular, no
;; origin may refer to github.com/oven-sh/bun/releases or an npm Bun binary.

;; src/node-fallbacks/bun.lockb fixes this older esbuild.  Build it with
;; Guix's Go build system instead of using npm's platform ELF.
(define esbuild-0.14.54
  (package
    (inherit esbuild)
    (version "0.14.54")
    (source
     (origin
       (inherit (package-source esbuild))
       (uri (git-reference
             (url "https://github.com/evanw/esbuild")
             (commit "v0.14.54")))
       (file-name (git-file-name "esbuild" "0.14.54"))
       (sha256
        (base32 "1357s1357r9nq3qlydd24lww93v1fhjrijh38qljnf2imz5njax8"))))))

(define (git-origin name url commit hash)
  (origin
    (method git-fetch)
    (uri (git-reference
          (url url)
          (commit commit)))
    (file-name (git-file-name name commit))
    (sha256 (base32 hash))))

;; Zig alternates between rebuilding its portable zig1 compiler and the native
;; zig2 executable.  Bun 1.0.7 pins a revision between Guix's dev.761 and
;; dev.1967 bootstrap stages, so build both halves at the pinned revision.
(define %zig-0.12.0-dev.899-source
  (git-origin "zig" "https://github.com/ziglang/zig"
              "027aabf4977d0362e908d9ef732aaa929605d563"
              "152mvlj55w6ww3sd79fk2srllqvjs8f4h1xfzyi16flm4kqr3snr"))

;; dev.899 still has the Zig 0.11 source layout.  These are the official Guix
;; Zig 0.11 patches; all four apply to this revision without modification.
;; In particular, the last two make the compiler honor Guix's search paths
;; when choosing the ELF interpreter and constructing RUNPATH.
(define %zig-0.12.0-dev.899-guix-source
  (origin
    (inherit %zig-0.12.0-dev.899-source)
    (patches (search-patches "zig-0.11-build-respect-PKG_CONFIG-env-var.patch"
              "zig-0.9-use-baseline-cpu-by-default.patch"
              "zig-0.11-use-system-paths.patch" "zig-0.11-fix-runpath.patch"))))

(define bun-bootstrap-zig1-1.0.7
  (let ((base (@@ (gnu packages zig) zig-0.11.0-761)))
    (package
      (inherit base)
      (name "bun-bootstrap-zig1")
      (version "0.12.0-dev.899")
      (source
       %zig-0.12.0-dev.899-source)
      ;; Supply dev.761 zig2 and rebuild the portable zig1 compiler.
      (arguments
       (package-arguments (@@ (gnu packages zig) zig-0.10.0-747)))
      (native-inputs (modify-inputs (package-native-inputs base)
                       (replace "zig"
                                `(,base "out")))))))

(define-public bun-bootstrap-zig-1.0.7
  (package
    (inherit zig-0.12)
    (name "bun-bootstrap-zig")
    (version "0.12.0-dev.899")
    (source
     %zig-0.12.0-dev.899-guix-source)
    ;; Supply the just-built dev.899 zig1 and build the complete stage3
    ;; compiler using Guix's source-bootstrap recipe.
    (arguments
     (substitute-keyword-arguments (package-arguments zig-0.12)
       ((#:configure-flags flags
         ''())
        #~(cons "-DZIG_VERSION=0.12.0-dev.899+027aabf49"
                #$flags))
       ((#:phases phases
         '%standard-phases)
        #~(modify-phases #$phases
            ;; dev.899 still uses the pre-0.12 NativeTargetInfo location.
            ;; This is the same native ELF probe substitution used by Guix's
            ;; official Zig 0.11 source-bootstrap recipe.
            (add-after 'patch-more-shebangs 'patch-native-target-info
              (lambda* (#:key inputs #:allow-other-keys)
                (substitute* "lib/std/zig/system/NativeTargetInfo.zig"
                  (("/usr/bin/env")
                   (search-input-file inputs "bin/clang++")))))))))
    (native-inputs (modify-inputs (package-native-inputs zig-0.12)
                     ;; The stable 0.12 ABI consolidator uses std.fs APIs introduced after
                     ;; dev.899.  Use the official Guix Zig 0.11 tool from the same API era.
                     (replace "libc-abi-tools"
                              (cadr (assoc "libc-abi-tools"
                                           (package-native-inputs zig-0.11))))
                     (replace "zig"
                              `(,bun-bootstrap-zig1-1.0.7 "zig1"))))
    (synopsis "Zig compiler used to build Bun 1.0.7")
    (description "This package provides the Zig compiler used to build Bun.")))

(define %zig-0.12.0-dev.1828-source
  (git-origin "zig" "https://github.com/ziglang/zig"
              "225fe6ddbfae016395762850e0cd5c51f9e7751c"
              "0hnih09n7ncny4hlkh8alqm4klvr6yg46vlq42pcqnfksdpgiz2g"))

;; dev.1828 is midway between the Zig 0.11 and 0.12 source layouts.  Reuse
;; each official Guix patch from the API generation where it applies.  The
;; two local patches adapt official Guix fixes to dev.1828's Build API.
(define %zig-0.12.0-dev.1828-guix-source
  (origin
    (inherit %zig-0.12.0-dev.1828-source)
    (patches (append (search-patches
                      "zig-0.9-use-baseline-cpu-by-default.patch"
                      "zig-0.11-use-system-paths.patch")
                     (parameterize ((%patch-path (map (lambda (directory)
                                                        (string-append
                                                         directory
                                                         "/roquix/packages/patches"))
                                                      %load-path)))
                       (search-patches
                        "zig-0.12.0-dev.1828-respect-PKG_CONFIG.patch"
                        "zig-0.12.0-dev.1828-fix-runpath.patch"))))))

(define bun-bootstrap-zig1-1.0.30
  (let ((base bun-bootstrap-zig-1.0.7))
    (package
      (inherit base)
      (name "bun-bootstrap-zig1")
      (version "0.12.0-dev.1828")
      (source
       %zig-0.12.0-dev.1828-source)
      ;; Use the complete dev.899 compiler to rebuild portable zig1 at the
      ;; exact revision required by Bun 1.0.30.
      (arguments
       (substitute-keyword-arguments (package-arguments (@@ (gnu packages zig)
                                                            zig-0.10.0-747))
         ((#:phases phases
           '%standard-phases)
          #~(modify-phases #$phases
              (replace 'build-zig1
                (lambda* (#:key inputs #:allow-other-keys)
                  (invoke (search-input-file inputs "/bin/zig")
                          "build"
                          "--zig-lib-dir"
                          "lib"
                          "update-zig1"
                          "--verbose")))))))
      (native-inputs (modify-inputs (package-native-inputs base)
                       (replace "zig"
                                `(,base "out")))))))

(define-public bun-bootstrap-zig-1.0.30
  (package
    (inherit zig-0.12)
    (name "bun-bootstrap-zig")
    (version "0.12.0-dev.1828")
    (source
     %zig-0.12.0-dev.1828-guix-source)
    (arguments
     (substitute-keyword-arguments (package-arguments zig-0.12)
       ((#:configure-flags flags
         ''())
        #~(cons* "-DZIG_VERSION=0.12.0-dev.1828+225fe6ddb"
                 ;; GCC 14 promotes this old Zig C backend diagnostic to an
                 ;; error.  Retain the diagnostic while restoring its GCC 13
                 ;; severity for the generated stage2 C translation.  See
                 ;; https://gcc.gnu.org/gcc-14/porting_to.html#c-language-issues
                 "-DCMAKE_C_FLAGS=-Wno-error=incompatible-pointer-types"
                 #$flags))
       ((#:phases phases
         '%standard-phases)
        #~(modify-phases #$phases
            ;; dev.1828 still probes the pre-0.12 NativeTargetInfo path.
            (add-after 'patch-more-shebangs 'patch-native-target-info
              (lambda* (#:key inputs #:allow-other-keys)
                (substitute* "lib/std/zig/system/NativeTargetInfo.zig"
                  (("/usr/bin/env")
                   (search-input-file inputs "bin/clang++")))))))))
    (native-inputs (modify-inputs (package-native-inputs zig-0.12)
                     (replace "zig"
                              `(,bun-bootstrap-zig1-1.0.30 "zig1"))))
    (synopsis "Zig compiler used to build Bun 1.0.30")
    (description "This package provides the Zig compiler used to build Bun.")))

(define %bun-1.0.7-commit
  "b0393fba6200d8573f3433fb0af258a0e33ac157")

(define %bun-1.0.7-source
  (git-origin "bun" "https://github.com/oven-sh/bun" %bun-1.0.7-commit
              "0f42affxq8bphcbx2qjmfskzi6y05d0yr3rdcygglhawyajqwhnw"))

(define %bun-1.0.7-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "1a49a1f94bf42ab4f8c6b11d7bbbb21e491d2d62"
              "0av6d4z7hx5iw1hz70cm49hc7xs7gj4h5ij3d7nbbq7mahl7b4fq"))

(define %bun-1.0.7-dependency-sources
  `(("base64" ,(git-origin "base64" "https://github.com/aklomp/base64"
                "e77bd70bdd860c52c561568cffb251d88bba064c"
                "0ipg5b0gidcfvnnhdz819v51nxz74b2nnif2032hirknip4j165c"))
    ("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "b275c5ce1c88bc06f5a967026d3c0ce1df2be815"
                   "07v0lkzpli9s92lzrihv3lja1hwnc0scj926f36qx2sr5rdz29w8"))
    ("c-ares" ,(git-origin "c-ares" "https://github.com/c-ares/c-ares"
                "0e7a5dee0fbb04080750cf6eabbe89d8bae87faa"
                "1xg31qkjkl2yy0vr7c70s69zc74hwhgb2al113bw8v7nb3jxaxlz"))
    ("libarchive" ,(git-origin "libarchive"
                    "https://github.com/libarchive/libarchive"
                    "dc321febde83dd0f31158e1be61a7aedda65e7a2"
                    "0pvhr28w171zpyk3sn0w88wpwrfhqaal3xrv1y2vzwbh819kzgf9"))
    ("lol-html" ,(git-origin "lol-html"
                  "https://github.com/cloudflare/lol-html"
                  "8d4c273ded322193d017042d1f48df2766b0f88b"
                  "1s1qmsgn57alc474pcsv5nz7c4690hfxfnrwm7mwq12yj87px85q"))
    ("mimalloc" ,(git-origin "mimalloc"
                  "https://github.com/Jarred-Sumner/mimalloc"
                  "7968d4285043401bb36573374710d47a4081a063"
                  "0c9a3xy05wj96pyzdkqb6nr1j1qbn2s47fv5f69l1bpw69f7yaqb"))
    ("picohttpparser" ,(git-origin "picohttpparser"
                        "https://github.com/h2o/picohttpparser"
                        "066d2b1e9ab820703db0837a7255d92d30f0c9f5"
                        "0g2g1x34xqyck37vs7kjm9762w859xmvhhl839kcy0rb7vj0w177"))
    ("tinycc" ,(git-origin "tinycc" "https://github.com/Jarred-Sumner/tinycc"
                "2d3ad9e0d32194ad7fd867b66ebe218dcc8cb5cd"
                "1snd64x22md72dgz2dfcj4rlnvzlmpr6cz0gf0kv4y1hlbblgfkq"))
    ("zlib" ,(git-origin "zlib" "https://github.com/cloudflare/zlib"
              "885674026394870b7e7a05b7bf1ec5eb7bd8a9c0"
              "10wc2k2x6b4anyl0zsdkp1f8mizvdyf28izas8g5hv7aw8fv26hp"))
    ("zstd" ,(git-origin "zstd" "https://github.com/facebook/zstd"
              "63779c798237346c2b245c546c40b72a5a5913fe"
              "0x3n97hx5x68fa7jz674rkabaaji1bijcqdm99rg5vhlqhicfwdl"))))

(define bun-bootstrap-jsc-1.0.7
  (package
    (name "bun-bootstrap-jsc")
    (version "1.0.7")
    (source
     %bun-1.0.7-webkit-source)
    (build-system gnu-build-system)
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (replace 'build
            (lambda* (#:key inputs
                      (parallel-build? #t) #:allow-other-keys)
              (let ((release "WebKitBuild/Release")
                    (jobs (if parallel-build?
                              (number->string (parallel-job-count)) "1")))
                (setenv "CC"
                        (search-input-file inputs "/bin/clang"))
                (setenv "CXX"
                        (search-input-file inputs "/bin/clang++"))
                (setenv "CFLAGS"
                        "-O3 -march=nehalem -mtune=nehalem -ffat-lto-objects")
                (setenv "CXXFLAGS"
                        (string-append (getenv "CFLAGS")
                                       " -DUSE_BUN_JSC_ADDITIONS=ON"))
                (invoke "cmake"
                        "-S"
                        "."
                        "-B"
                        release
                        "-G"
                        "Ninja"
                        "-DPORT=JSCOnly"
                        "-DENABLE_STATIC_JSC=ON"
                        "-DCMAKE_BUILD_TYPE=Release"
                        "-DUSE_THIN_ARCHIVES=OFF"
                        "-DUSE_BUN_JSC_ADDITIONS=ON"
                        "-DENABLE_FTL_JIT=ON"
                        "-DENABLE_REMOTE_INSPECTOR=ON"
                        "-DJSEXPORT_PRIVATE=WTF_EXPORT_DECLARATION"
                        "-DALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS=ON"
                        "-DUSE_VISIBILITY_ATTRIBUTE=1"
                        "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
                        (string-append "-DCMAKE_C_COMPILER="
                                       (getenv "CC"))
                        (string-append "-DCMAKE_CXX_COMPILER="
                                       (getenv "CXX")))
                (invoke "cmake"
                        "--build"
                        release
                        "--parallel"
                        jobs
                        "--config"
                        "relwithdebuginfo"
                        "--target"
                        "jsc"))))
          (replace 'install
            (lambda _
              (copy-recursively "WebKitBuild/Release"
                                #$output)
              (delete-file-recursively (string-append #$output "/bin")))))))
    (native-inputs (list clang-toolchain-16
                         cmake-minimal
                         ninja
                         pkg-config
                         perl
                         python
                         ruby))
    (inputs (list icu4c))
    (supported-systems '("x86_64-linux"))
    (home-page "https://webkit.org/")
    (synopsis "JavaScriptCore engine used to build Bun")
    (description "This package provides the JavaScriptCore engine.")
    (license license:lgpl2.1)))

(define (bun-bootstrap-node-modules version npm-inputs)
  (bun-node-modules-from-layout npm-inputs
                                #:name (string-append "bun-" version
                                                      "-node-modules")
                                ;; Bun lockfiles include optional platform packages.  The bootstrap replaces
                                ;; their command shims with Guix source builds and must not retain their ELF
                                ;; payloads in the build input.
                                #:native-files 'delete))

(define %bun-1.0.7-bootstrap-npm-inputs
  ;; This stage supplies JSC_BASE_DIR from the pinned WebKit git source.  The
  ;; The bun-webkit base package and its platform archives form Bun's prebuilt
  ;; JSC distribution, so retaining them would make those binaries part of the
  ;; bootstrap closure even though Bun's link command selects the source build.
  ;; https://github.com/oven-sh/bun/blob/bun-v1.0.7/Makefile#L196-L220
  (remove (lambda (package)
            (string-prefix? "bun-webkit"
                            (bun-lock-package-name package)))
          %bun-1.0.7-all-npm-inputs))

(define %bun-1.0.7-node-modules
  (bun-bootstrap-node-modules "1.0.7"
                              %bun-1.0.7-bootstrap-npm-inputs))

(define (bun-cargo-inputs cargo-key)
  "Return cargo inputs generated by `guix import crate' for CARGO-KEY."
  (or (lookup-cargo-inputs cargo-key)
      (error "Bun generated crate input set not found" cargo-key)))

(define (bun-cargo-input-tuples inputs)
  "Label Cargo source INPUTS for Guix's standard crate unpacking phase."
  (map (lambda (input)
         (list (origin-file-name input) input)) inputs))

(define (bun-cargo-checksum-entries cargo-inputs)
  "Return Cargo vendor directory and SHA-256 pairs for CARGO-INPUTS."
  (let* ((entries
          (map (lambda (input)
                 (unless (and (origin? input)
                              (string? (origin-file-name input))
                              (origin-hash input))
                   (error "invalid Bun Cargo origin" input))
                 (cons (origin-file-name input)
                       (bytevector->base16-string
                        (content-hash-value (origin-hash input)))))
               cargo-inputs))
         (directories (map car entries)))
    (unless (= (length directories)
               (length (delete-duplicates directories string=?)))
      (error "duplicate Cargo crate identity" directories))
    entries))

(define (bun-cargo-checksums-input cargo-key cargo-inputs)
  "Return a Cargo checksum manifest for generated CARGO-INPUTS."
  (plain-file (string-append (symbol->string cargo-key) ".checksums.scm")
              (call-with-output-string (lambda (port)
                                         (write (bun-cargo-checksum-entries
                                                 cargo-inputs) port)
                                         (newline port)))))

(define (replace-bun-cargo-inputs inputs cargo-key cargo-inputs)
  "Replace Bun's lol-html Cargo closure in INPUTS with CARGO-INPUTS."
  (append (remove (lambda (input)
                    (let ((label (car input)))
                      (or (string=? label "lol-html-cargo-checksums")
                          (string-prefix? "rust-" label)))) inputs)
          `(("lol-html-cargo-checksums"
             ,(bun-cargo-checksums-input cargo-key cargo-inputs)))
          (bun-cargo-input-tuples cargo-inputs)))

(define %bun-1.0.7-lol-html-cargo-inputs
  (bun-cargo-inputs 'bun-lol-html-1.0))

(define %bun-bootstrap-esbuild-bindings
  '(("node_modules/.bin/esbuild" . "esbuild")
    ("packages/bun-error/node_modules/.bin/esbuild" . "esbuild")
    ("src/node-fallbacks/node_modules/.bin/esbuild" . "esbuild-node-fallbacks")))

(define %bun-bootstrap-legacy-esbuild-bindings
  '(("packages/bun-error/node_modules/.bin/esbuild" . "esbuild")
    ("src/node-fallbacks/node_modules/.bin/esbuild" . "esbuild")))

(define bun-bootstrap-native-deps-1.0.7
  (package
    (name "bun-bootstrap-native-deps")
    (version "1.0.7")
    (source
     %bun-1.0.7-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:imported-modules (cons* '(roquix packages bun-bootstrap cargo)
                                '(guix build cargo-build-system)
                                %default-gnu-imported-modules)
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (add-after 'unpack 'install-pinned-sources
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((null (open-output-file "/dev/null")))
                (copy-recursively (assoc-ref inputs "webkit")
                                  "src/bun.js/WebKit"
                                  #:log null)
                (copy-recursively (assoc-ref inputs "jsc")
                                  "src/bun.js/WebKit/WebKitBuild/Release"
                                  #:log null)
                (for-each (lambda (name)
                            (copy-recursively (assoc-ref inputs
                                                         (string-append
                                                          "source-" name))
                                              (string-append "src/deps/" name)
                                              #:log null))
                          '#$(map car %bun-1.0.7-dependency-sources))
                (copy-recursively (assoc-ref inputs "node-modules") "."
                                  #:log null)
                (close-port null))
              (invoke "chmod" "-R" "u+w" ".")))
          (add-after 'install-pinned-sources 'prepare-build
            (lambda* (#:key inputs #:allow-other-keys)
              (use-modules (srfi srfi-1)
                           (srfi srfi-13))
              ;; Origins used only as copy sources may themselves contain an
              ;; "include" directory.  Do not let Guix's automatic search
              ;; paths treat those unbuilt trees as compiler inputs.
              (let ((source-roots (filter-map (lambda (name)
                                                (assoc-ref inputs name))
                                              (append '("webkit"
                                                        "node-modules")
                                                      '#$(map (lambda (entry)
                                                                (string-append
                                                                 "source-"
                                                                 (car entry)))
                                                          %bun-1.0.7-dependency-sources)))))
                (for-each (lambda (variable)
                            (let ((value (getenv variable)))
                              (when value
                                (setenv variable
                                        (string-join (remove (lambda (path)
                                                               (any (lambda (root)
                                                                      (string-prefix?
                                                                       root
                                                                       path))
                                                                source-roots))
                                                             (string-split
                                                              value #\:)) ":")))))
                          '("CPATH" "C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH"
                            "LIBRARY_PATH" "PKG_CONFIG_PATH")))
              (setenv "HOME"
                      (string-append (getcwd) "/.home"))
              (setenv "XDG_CACHE_HOME"
                      (string-append (getcwd) "/.cache"))
              (setenv "CC"
                      (search-input-file inputs "/bin/clang"))
              (setenv "CXX"
                      (search-input-file inputs "/bin/clang++"))
              (setenv "AR"
                      (search-input-file inputs "/bin/llvm-ar"))
              (setenv "RANLIB"
                      (search-input-file inputs "/bin/llvm-ranlib"))
              (setenv "CONFIG_SHELL"
                      (search-input-file inputs "/bin/bash"))
              (setenv "SHELL"
                      (getenv "CONFIG_SHELL"))
              (setenv "ZIG"
                      (search-input-file inputs "/bin/zig"))
              (setenv "ESBUILD"
                      (search-input-file inputs "/bin/esbuild"))
              (setenv "NPM_CLIENT"
                      (search-input-file inputs "/bin/npm"))
              (setenv "CPU_TARGET" "nehalem")
              (setenv "CPUS"
                      (number->string (parallel-job-count)))
              (mkdir-p (getenv "HOME"))
              (mkdir-p ".cargo")
              (call-with-output-file ".cargo/config.toml"
                (lambda (port)
                  (format port
                   "[source.crates-io]~%replace-with = ~s~%~%[source.vendored-sources]~%directory = ~s~%~%[net]~%offline = true~%"
                   "vendored-sources"
                   (string-append (getcwd) "/.cargo-vendor"))))
              ;; node_modules is already a lock-derived derivation input.
              (substitute* "Makefile"
                (("^SHELL :=.*$")
                 (string-append "SHELL := "
                                (search-input-file inputs "/bin/bash") "\n"))
                (("^BUN_OR_NODE =.*$")
                 (string-append "BUN_OR_NODE = "
                                (search-input-file inputs "/bin/node") "\n"))
                (("^ESBUILD =.*$")
                 (string-append "ESBUILD = "
                                (search-input-file inputs "/bin/esbuild") "\n"))
                (("^REAL_CC =.*$")
                 (string-append "REAL_CC = "
                                (search-input-file inputs "/bin/clang") "\n"))
                (("^REAL_CXX =.*$")
                 (string-append "REAL_CXX = "
                                (search-input-file inputs "/bin/clang++") "\n"))
                (("^AR ?=.*$")
                 (string-append "AR = "
                                (search-input-file inputs "/bin/llvm-ar") "\n"))
                (("^[ \t]*-DCMAKE_RANLIB=.*$")
                 (string-append "\t-DCMAKE_RANLIB="
                                (search-input-file inputs "/bin/llvm-ranlib")
                                "\n"))
                (("\\./configure")
                 "$(SHELL) ./configure")
                (("prerelease: npm-install ")
                 "prerelease: ")
                (("@cd src/node-fallbacks; \\$\\(NPM_CLIENT\\) install; ")
                 "@cd src/node-fallbacks; ")
                (("cargo build --release")
                 ;; This upstream lol-html revision predates its committed
                 ;; Cargo.lock.  The Guix crate inputs still fix the available
                 ;; offline dependency set.
                 "cargo build --release --offline")
                (("-DCMAKE_C_FLAGS=\"\\$\\(CFLAGS\\) -flto=full\"")
                 "-DCMAKE_C_FLAGS=\"$(CFLAGS) -flto=full\" -DCMAKE_EXE_LINKER_FLAGS=\"-fuse-ld=lld\" -DCMAKE_TRY_COMPILE_TARGET_TYPE=STATIC_LIBRARY")
                (("-DCARES_STATIC=ON")
                 "-DCARES_BUILD_TOOLS=OFF -DCARES_BUILD_TESTS=OFF -DCARES_STATIC=ON"))
              (substitute* "src/deps/zlib/Makefile.in"
                (("SHELL=/bin/sh")
                 (string-append "SHELL="
                                (getenv "CONFIG_SHELL"))))
              (substitute* "src/deps/libarchive/build/autogen.sh"
                (("/bin/sh build/clean.sh")
                 (string-append (getenv "CONFIG_SHELL") " build/clean.sh")))))
          ;; Guix's shebang patching changes checksummed files in vendored
          ;; crates, so install this source-only tree after that phase.
          (add-after 'patch-generated-file-shebangs 'install-cargo-vendor
            (lambda* (#:key inputs #:allow-other-keys)
              (use-modules (roquix packages bun-bootstrap cargo))
              (install-bun-cargo-vendor #:source (assoc-ref inputs "source")
                                        #:inputs inputs
                                        #:checksums (assoc-ref inputs
                                                     "lol-html-cargo-checksums")
                                        #:vendor-dir ".cargo-vendor")))
          (replace 'build
            (lambda _
              ;; Build the pinned WebKit/JSC and every native dependency from
              ;; the gitlink sources before compiling Bun itself.
              (invoke "make" "jsc-build-mac-copy" "jsc-copy-headers")
              (apply invoke "make"
                     '("mimalloc" "picohttp"
                       "zlib"
                       "boringssl"
                       "libarchive"
                       "lolhtml"
                       "sqlite"
                       "uws"
                       "c-ares"
                       "zstd"
                       "base64"
                       "tinycc"))))
          (replace 'install
            (lambda _
              (let ((null (open-output-file "/dev/null")))
                (copy-recursively "."
                                  #$output
                                  #:log null)
                (close-port null)))))))
    (native-inputs (append `(("webkit" ,%bun-1.0.7-webkit-source)
                             ("jsc" ,bun-bootstrap-jsc-1.0.7)
                             ("node-modules" ,%bun-1.0.7-node-modules)
                             ("lol-html-cargo-checksums"
                              ,(bun-cargo-checksums-input
                                'bun-lol-html-1.0
                                %bun-1.0.7-lol-html-cargo-inputs))
                             ("zig" ,zig-0.11)
                             ("clang-toolchain" ,clang-toolchain-16)
                             ("lld" ,lld-16)
                             ("llvm" ,llvm-16)
                             ("node" ,node)
                             ("esbuild" ,esbuild)
                             ("bash" ,bash-minimal)
                             ("cmake" ,cmake-minimal)
                             ("ninja" ,ninja)
                             ("pkg-config" ,pkg-config)
                             ("python" ,python)
                             ("ruby" ,ruby)
                             ("perl" ,perl)
                             ("git" ,git-minimal)
                             ("go" ,go)
                             ("rust" ,rust)
                             ("cargo" ,rust "cargo")
                             ("autoconf" ,autoconf)
                             ("automake" ,automake)
                             ("libtool" ,libtool)
                             ("rsync" ,rsync)
                             ("unzip" ,unzip))
                           (map (lambda (entry)
                                  (list (string-append "source-"
                                                       (car entry))
                                        (cadr entry)))
                                %bun-1.0.7-dependency-sources)
                           (bun-cargo-input-tuples
                            %bun-1.0.7-lol-html-cargo-inputs)))
    (inputs (list icu4c))
    (home-page "https://bun.sh/")
    (synopsis "Native dependencies used to bootstrap Bun")
    (description "This package provides native inputs used to build Bun.")
    (license (list license:expat license:lgpl2.1))))

(define-public bun-bootstrap-1.0.7
  (package
    (inherit bun-bootstrap-native-deps-1.0.7)
    (name "bun-bootstrap")
    (source
     bun-bootstrap-native-deps-1.0.7)
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:imported-modules (cons* '(roquix packages bun-bootstrap affinity)
                                '(roquix packages bun-bootstrap esbuild)
                                %default-gnu-imported-modules)
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'bootstrap)
          (delete 'patch-usr-bin-file)
          (delete 'patch-source-shebangs)
          (delete 'patch-generated-file-shebangs)
          (replace 'build
            (lambda* (#:key inputs #:allow-other-keys)
              (use-modules (roquix packages bun-bootstrap affinity)
                           (roquix packages bun-bootstrap esbuild)
                           (srfi srfi-1)
                           (srfi srfi-13))
              ;; The inherited source origins are copy-only inputs.  Exclude
              ;; their include directories from Guix's compiler search paths.
              (let ((source-roots (filter-map (lambda (name)
                                                (assoc-ref inputs name))
                                              (append '("webkit"
                                                        "node-modules")
                                                      '#$(map (lambda (entry)
                                                                (string-append
                                                                 "source-"
                                                                 (car entry)))
                                                          %bun-1.0.7-dependency-sources)))))
                (for-each (lambda (variable)
                            (let ((value (getenv variable)))
                              (when value
                                (setenv variable
                                        (string-join (remove (lambda (path)
                                                               (any (lambda (root)
                                                                      (string-prefix?
                                                                       root
                                                                       path))
                                                                source-roots))
                                                             (string-split
                                                              value #\:)) ":")))))
                          '("CPATH" "C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH"
                            "LIBRARY_PATH" "PKG_CONFIG_PATH")))
              (setenv "HOME"
                      (string-append (getcwd) "/.home-final"))
              (setenv "ZIG"
                      (search-input-file inputs "/bin/zig"))
              (setenv "JSC_BASE_DIR"
                      (string-append (getcwd)
                                     "/src/bun.js/WebKit/WebKitBuild/Release"))
              (setenv "CPU_TARGET" "nehalem")
              ;; Several WebCore translation units require substantial memory.
              (setenv "CPUS"
                      (number->string (min 4
                                           (parallel-job-count))))
              (mkdir-p (getenv "HOME"))
              ;; Lock layout reconstruction restores npm's JavaScript bin
              ;; links, while the native @esbuild packages are deliberately
              ;; deleted.  Bind those CLI entry points to Guix's Go source
              ;; builds before any generator can follow the stale links.
              (bind-bun-esbuild-tools inputs
                                      '#$%bun-bootstrap-esbuild-bindings)
              (substitute* "Makefile"
                (("^NPM_CLIENT =.*$")
                 (string-append "NPM_CLIENT = "
                                (search-input-file inputs "/bin/npm") "\n"))
                (("\\$\\(ZIG\\) build obj -Doptimize=ReleaseFast")
                 "$(ZIG) build -j$(CPUS) obj -Doptimize=ReleaseFast")
                (("@cd packages/bun-error; \\$\\(NPM_CLIENT\\) install; ")
                 "@cd packages/bun-error; "))
              ;; The manifest and stream.js use readable-stream, but this tag
              ;; retains a stale tsconfig path to undeclared stream-browserify.
              ;; Correct the path without requiring newer esbuild alias flags.
              (substitute* "src/node-fallbacks/tsconfig.json"
                (("node_modules/stream-browserify")
                 "node_modules/readable-stream"))
              ;; Backport the missing declaration for abort() from upstream
              ;; bun-v1.0.8:
              ;; https://github.com/oven-sh/bun/blob/bun-v1.0.8/src/bun.js/bindings/workaround-missing-symbols.cpp
              (substitute* "src/bun.js/bindings/workaround-missing-symbols.cpp"
                (("#include <fcntl.h>")
                 "#include <cstdlib>\n#include <fcntl.h>"))
              (invoke "make" "identifier-cache")
              (invoke "make"
                      (string-append "NPM_CLIENT="
                                     (search-input-file inputs "/bin/npm"))
                      "prerelease")
              ;; release-only lists link and object targets as independent
              ;; prerequisites, so invoke them explicitly to preserve order.
              (invoke "make"
                      (string-append "-j"
                                     (number->string (min 4
                                                          (parallel-job-count))))
                      "release-bindings")
              ;; `zig build -jN' limits the build runner, but the compiler
              ;; child initializes its own thread pool from CPU affinity.
              (call-with-limited-cpu-affinity
               (min 4 (parallel-job-count))
               (lambda ()
                 (invoke "make" "build-obj")))
              (invoke "make"
                      (string-append "ICU_FLAGS=-L"
                                     (assoc-ref inputs "icu4c")
                                     "/lib"
                                     ;; Static c-ares references inet_net_pton, provided by
                                     ;; libresolv on glibc systems.  Keep it after libcares in the
                                     ;; final link order by appending it to these trailing flags.
                                     " -licuuc -licudata -licui18n -lresolv"
                                     ;; Add runtime search paths at the original link.  This keeps
                                     ;; Bun's ELF layout intact and avoids post-link patchelf.
                                     " -Wl,-rpath,"
                                     (assoc-ref inputs "icu4c")
                                     "/lib"
                                     " -Wl,-rpath,"
                                     (assoc-ref inputs "glibc")
                                     "/lib") "bun-link-lld-release")
              (invoke "make" "bun-link-lld-release-dsym")))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                (mkdir-p bin)
                (install-file "packages/bun-linux-x64/bun" bin)
                (chmod (string-append bin "/bun") #o555)
                (symlink "bun"
                         (string-append bin "/bunx")))))
          (add-after 'install 'check-bootstrap
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((bun (string-append (assoc-ref outputs "out") "/bin/bun"))
                    (script (string-append (getcwd) "/bootstrap-check.js")))
                (call-with-output-file script
                  (lambda (port)
                    (display
                     "console.log('source-bootstrap-ok', process.versions.bun);
"
                     port)))
                (invoke bun "--version")
                (invoke bun script)
                (delete-file script)))))))
    (synopsis "Seedless source-bootstrap stage for Bun")
    (description
     "This package provides Bun, a JavaScript runtime, bundler, test runner,
and package manager.")
    (native-inputs (cons (list "esbuild-node-fallbacks" esbuild-0.14.54)
                         (modify-inputs (package-native-inputs
                                         bun-bootstrap-native-deps-1.0.7)
                           (replace "zig" bun-bootstrap-zig-1.0.7))))
    (inputs (modify-inputs (package-inputs bun-bootstrap-native-deps-1.0.7)
              (prepend glibc)))))

(define %bun-1.0.30-commit
  "1424a196ffb8a6bace554070ef029913ec19e1da")

(define %bun-1.0.30-source
  (git-origin "bun" "https://github.com/oven-sh/bun" %bun-1.0.30-commit
              "165ac92xsv89q125p0vw1db8l6d840miy9pm7gkj8mfk7hdhjz76"))

(define %bun-1.0.30-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "c3712c13dcdc091cfe4c7cb8f2c1fd16472e6f92"
              "0x4y6mr62ii4d9vl3a25lca0g5c336hhh67yyaqpzc2jc3cbggg9"))

(define %bun-1.0.30-tinycc-source
  (origin
    ;; The repository moved from Jarred-Sumner/tinycc to oven-sh/tinycc.
    ;; Its codeload archive still exposes the exact Bun gitlink commit.
    (method url-fetch/tarbomb)
    (uri (string-append "https://codeload.github.com/oven-sh/tinycc/tar.gz/"
                        "ab631362d839333660a265d3084d8ff060b96753"))
    (file-name "tinycc-ab631362d839333660a265d3084d8ff060b96753")
    (sha256 (base32 "1s1hzm5ma88kqvsndc0h2kza39239rm6j12cx5dv8hmzhlgckyzy"))))

(define %bun-1.0.30-dependency-sources
  `(("base64" ,(git-origin "base64" "https://github.com/aklomp/base64"
                "3a5add8652076612a8407627a42c768736a4263f"
                "13fd1adhnv2lnfblsvsg9w9j0m9j7cf6aakv9gp56wm39n6phksf"))
    ("boringssl" ,(cadr (assoc "boringssl" %bun-1.0.7-dependency-sources)))
    ("c-ares" ,(cadr (assoc "c-ares" %bun-1.0.7-dependency-sources)))
    ("libarchive" ,(cadr (assoc "libarchive" %bun-1.0.7-dependency-sources)))
    ("lol-html" ,(cadr (assoc "lol-html" %bun-1.0.7-dependency-sources)))
    ("ls-hpack" ,(git-origin "ls-hpack"
                  "https://github.com/litespeedtech/ls-hpack"
                  "3d0f1fc1d6e66a642e7a98c55deb38aa986eb4b0"
                  "1vc57nbqhl5aw5fsgrdsn14438m5zi3b0fw18bdlfvb5bi1m93fm"))
    ("mimalloc" ,(git-origin "mimalloc"
                  "https://github.com/Jarred-Sumner/mimalloc"
                  "011b62a66bc74bbfda87b32b54d394a544d9a7f0"
                  "1apzmnwizcb9kg7cycrmqbsj832kxnpp9birzffd7gpza7z5xjzv"))
    ("picohttpparser" ,(cadr (assoc "picohttpparser"
                                    %bun-1.0.7-dependency-sources)))
    ("tinycc" ,%bun-1.0.30-tinycc-source)
    ("zlib" ,(git-origin "zlib" "https://github.com/cloudflare/zlib"
              "886098f3f339617b4243b286f5ed364b9989e245"
              "1qrbljy2922nr796cffd8zbvw92pxabznri4vnbahafxcy4s5xhq"))
    ("zstd" ,(cadr (assoc "zstd" %bun-1.0.7-dependency-sources)))))

(define bun-bootstrap-jsc-1.0.30
  (package
    (inherit bun-bootstrap-jsc-1.0.7)
    (version "1.0.30")
    (source
     %bun-1.0.30-webkit-source)))

(define %bun-1.0.30-node-modules
  (bun-bootstrap-node-modules "1.0.30" %bun-1.0.30-all-npm-inputs))

(define-public bun-bootstrap-native-deps-1.0.30
  (package
    (inherit bun-bootstrap-native-deps-1.0.7)
    (version "1.0.30")
    (source
     %bun-1.0.30-source)
    (arguments
     (substitute-keyword-arguments (package-arguments
                                    bun-bootstrap-native-deps-1.0.7)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install-pinned-sources 'install-lshpack-source
              (lambda* (#:key inputs #:allow-other-keys)
                (copy-recursively (assoc-ref inputs "source-ls-hpack")
                                  "src/deps/ls-hpack")))
            (add-after 'install-lshpack-source 'flatten-tinycc-source
              (lambda _
                (let ((nested (string-append "src/deps/tinycc/tinycc-"
                               "ab631362d839333660a265d3084d8ff060b96753"))
                      (flat "src/deps/tinycc-flat"))
                  (copy-recursively nested flat)
                  (delete-file-recursively "src/deps/tinycc")
                  (rename-file flat "src/deps/tinycc"))))
            (add-after 'build 'build-lshpack
              (lambda _
                (invoke "make" "lshpack")))))))
    (native-inputs (let ((inputs (modify-inputs (package-native-inputs
                                                 bun-bootstrap-native-deps-1.0.7)
                                   (replace "webkit" %bun-1.0.30-webkit-source)
                                   (replace "jsc" bun-bootstrap-jsc-1.0.30)
                                   (replace "node-modules"
                                            %bun-1.0.30-node-modules)
                                   (replace "zig" bun-bootstrap-zig-1.0.30))))
                     (fold (lambda (entry result)
                             (modify-inputs result
                               (replace (string-append "source-"
                                                       (car entry))
                                        (cadr entry))))
                           (cons (list "source-ls-hpack"
                                       (cadr (assoc "ls-hpack"
                                              %bun-1.0.30-dependency-sources)))
                                 inputs)
                           (filter (lambda (entry)
                                     (not (string=? (car entry) "ls-hpack")))
                                   %bun-1.0.30-dependency-sources))))))

(define-public bun-bootstrap-1.0.30
  (package
    (inherit bun-bootstrap-native-deps-1.0.30)
    (name "bun-bootstrap")
    (source
     bun-bootstrap-native-deps-1.0.30)
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:imported-modules (cons* '(roquix packages bun-bootstrap affinity)
                                '(roquix packages bun-bootstrap esbuild)
                                %default-gnu-imported-modules)
      #:phases
      #~(modify-phases %standard-phases
          (delete 'configure)
          (delete 'bootstrap)
          (delete 'patch-usr-bin-file)
          (delete 'patch-source-shebangs)
          (delete 'patch-generated-file-shebangs)
          (replace 'build
            (lambda* (#:key inputs #:allow-other-keys)
              (use-modules (roquix packages bun-bootstrap affinity)
                           (roquix packages bun-bootstrap esbuild)
                           (srfi srfi-1)
                           (srfi srfi-13))
              (let ((source-roots (filter-map (lambda (name)
                                                (assoc-ref inputs name))
                                              (append '("webkit"
                                                        "node-modules")
                                                      '#$(map (lambda (entry)
                                                                (string-append
                                                                 "source-"
                                                                 (car entry)))
                                                          %bun-1.0.30-dependency-sources)))))
                (for-each (lambda (variable)
                            (let ((value (getenv variable)))
                              (when value
                                (setenv variable
                                        (string-join (remove (lambda (path)
                                                               (any (lambda (root)
                                                                      (string-prefix?
                                                                       root
                                                                       path))
                                                                source-roots))
                                                             (string-split
                                                              value #\:)) ":")))))
                          '("CPATH" "C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH"
                            "LIBRARY_PATH" "PKG_CONFIG_PATH")))
              (let ((seed (search-input-file inputs "/bin/bun"))
                    (jobs (min 4 (parallel-job-count))))
                (setenv "HOME"
                        (string-append (getcwd) "/.home-final"))
                (mkdir-p (getenv "HOME"))
                (bind-bun-esbuild-tools inputs
                                        '#$%bun-bootstrap-legacy-esbuild-bindings)
                ;; Backport the missing declaration for abort() from upstream
                ;; bun-v1.0.8:
                ;; https://github.com/oven-sh/bun/blob/bun-v1.0.8/src/bun.js/bindings/workaround-missing-symbols.cpp
                (substitute* "src/bun.js/bindings/workaround-missing-symbols.cpp"
                  (("#include <fcntl.h>")
                   "#include <cstdlib>\n#include <fcntl.h>"))
                ;; The 1.0.30 CMake build is the first build system in this
                ;; chain that models every generated source as a dependency.
                ;; Pass the declared seed directly instead of exposing it via
                ;; PATH.  WEBKIT_DIR selects the JSC built above and prevents
                ;; CMake's prebuilt-WebKit download path.
                (substitute* "CMakeLists.txt"
                  (((string-append
                     "    target_link_libraries\\(\\$\\{bun\\} PRIVATE "
                     "\"\\$\\{WEBKIT_LIB_DIR\\}/libicu"
                     "(data|i18n|uc)\\.a\"\\)"))
                   "")
                  (("target_link_libraries\\(\\$\\{bun\\} PRIVATE \\\"\\$\\{WEBKIT_LIB_DIR\\}/libbmalloc\\.a\\\"\\)")
                   (string-append "target_link_libraries(${bun} PRIVATE "
                                  "\"${WEBKIT_LIB_DIR}/libbmalloc.a\")\n"
                                  "target_link_libraries(${bun} PRIVATE "
                                  "icuuc icudata icui18n resolv)\n"
                                  "target_link_options(${bun} PRIVATE "
                                  "\"-Wl,-rpath,"
                                  (assoc-ref inputs "icu4c")
                                  "/lib\" "
                                  "\"-Wl,-rpath,"
                                  (assoc-ref inputs "glibc")
                                  "/lib\")")))
                ;; These two embedded bundles are consumed directly by
                ;; build.zig but are not represented in the early CMake
                ;; dependency graph.
                (substitute* "src/node-fallbacks/package.json"
                  (("--platform=browser")
                   "--platform=browser --alias:http=stream-http --alias:stream=readable-stream"))
                (with-directory-excursion "src/node-fallbacks"
                  (invoke seed "run" "--silent" "build"))
                (with-directory-excursion "packages/bun-error"
                  (invoke seed "run" "--silent" "build"))
                ;; 1.0.30's CMakeLists generates fallback.out.js but omits the
                ;; corresponding runtime.out.js rule still required by
                ;; build.zig.  Reproduce the upstream Makefile command.
                (invoke (search-input-file inputs "/bin/esbuild")
                        "--define:process.env.NODE_ENV=\"production\""
                        "--target=esnext"
                        "--bundle"
                        "src/runtime.bun.js"
                        "--format=esm"
                        "--platform=node"
                        "--minify"
                        "--external:/bun:*"
                        "--outfile=src/runtime.out.js")
                ;; Its fallback rule has the same missing dependency edge: the
                ;; Zig object may start before this custom command finishes.
                (invoke (search-input-file inputs "/bin/esbuild")
                        "--target=esnext"
                        "--bundle"
                        "src/fallback.ts"
                        "--format=iife"
                        "--platform=browser"
                        "--minify"
                        "--outfile=src/fallback.out.js")
                (invoke "cmake"
                        "-S"
                        "."
                        "-B"
                        "build/release"
                        "-G"
                        "Ninja"
                        "-DCMAKE_BUILD_TYPE=Release"
                        "-DUSE_BASELINE_BUILD=ON"
                        (string-append "-DCMAKE_C_COMPILER="
                                       (search-input-file inputs "/bin/clang"))
                        (string-append "-DCMAKE_CXX_COMPILER="
                                       (search-input-file inputs
                                                          "/bin/clang++"))
                        (string-append "-DLLVM_PREFIX="
                                       (assoc-ref inputs "clang-toolchain"))
                        (string-append "-DZIG_COMPILER="
                                       (search-input-file inputs "/bin/zig"))
                        (string-append "-DBUN_EXECUTABLE=" seed)
                        (string-append "-DWEBKIT_DIR="
                         (getcwd) "/src/bun.js/WebKit/WebKitBuild/Release")
                        (string-append "-DBUN_DEPS_OUT_DIR="
                                       (getcwd) "/src/deps"))
                ;; CMake's Ninja limit does not constrain the independent
                ;; thread pool created by its nested Zig compiler process.
                (call-with-limited-cpu-affinity
                 jobs
                 (lambda ()
                   (invoke "cmake"
                           "--build"
                           "build/release"
                           "--parallel"
                           (number->string jobs)))))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                (mkdir-p bin)
                (install-file "build/release/bun-profile" bin)
                (rename-file (string-append bin "/bun-profile")
                             (string-append bin "/bun"))
                (chmod (string-append bin "/bun") #o555)
                (symlink "bun"
                         (string-append bin "/bunx")))))
          (add-after 'install 'check-bootstrap
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((bun (string-append (assoc-ref outputs "out") "/bin/bun"))
                    (script (string-append (getcwd) "/bootstrap-check.js")))
                (call-with-output-file script
                  (lambda (port)
                    (display
                     "console.log('source-bootstrap-ok', process.versions.bun);
"
                     port)))
                (invoke bun "--version")
                (invoke bun script)
                (delete-file script)))))))
    (synopsis "Source-bootstrap stage for Bun")
    (description
     "This package provides Bun, a JavaScript runtime, bundler, test runner,
and package manager.")
    (native-inputs (cons (list "bun-seed" bun-bootstrap-1.0.7)
                         (package-native-inputs
                          bun-bootstrap-native-deps-1.0.30)))
    (inputs (modify-inputs (package-inputs bun-bootstrap-native-deps-1.0.30)
              (prepend glibc)))))

(define %bun-1.1.4-commit
  "fbe2fe0c3fd198530db51d9f54e0a03ffff9f22d")

(define %bun-1.1.4-source
  (git-origin "bun" "https://github.com/oven-sh/bun" %bun-1.1.4-commit
              "0mgr05b1q7cmpg8gaqig8i31hgd7dp7x0x7kql1xilpz4b77m2a8"))

(define %bun-1.1.4-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "e3a2d89a0b1644cc8d5c245bd2ffee4d4bd6c1d5"
              "1kvvsg734rr99zlbspgrjgrj4sk40r5i1mzzfya8dan7fwg84s5h"))

(define bun-bootstrap-jsc-1.1.4
  (package
    (inherit bun-bootstrap-jsc-1.0.30)
    (version "1.1.4")
    (source
     %bun-1.1.4-webkit-source)))

(define %bun-1.1.4-node-modules
  (bun-bootstrap-node-modules "1.1.4" %bun-1.1.4-all-npm-inputs))

(define-public bun-bootstrap-native-deps-1.1.4
  (package
    (inherit bun-bootstrap-native-deps-1.0.30)
    (version "1.1.4")
    (source
     %bun-1.1.4-source)
    (native-inputs (modify-inputs (package-native-inputs
                                   bun-bootstrap-native-deps-1.0.30)
                     (replace "webkit" %bun-1.1.4-webkit-source)
                     (replace "jsc" bun-bootstrap-jsc-1.1.4)
                     (replace "node-modules" %bun-1.1.4-node-modules)))))

(define-public bun-bootstrap-1.1.4
  (package
    (inherit bun-bootstrap-1.0.30)
    (version "1.1.4")
    (source
     bun-bootstrap-native-deps-1.1.4)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-1.0.30)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build 'provide-zig-library
              (lambda* (#:key inputs #:allow-other-keys)
                ;; 1.1.4 adds --zig-lib-dir=src/deps/zig/lib.  Its official
                ;; Docker build uses the same dev.1828 release selected here,
                ;; so bind that source-built compiler's standard library at
                ;; the exact location expected by the CMake rule.
                (mkdir-p "src/deps/zig")
                (symlink (string-append (assoc-ref inputs "zig") "/lib/zig")
                         "src/deps/zig/lib")))))))
    (native-inputs (cons (list "bun-seed" bun-bootstrap-1.0.30)
                         (package-native-inputs
                          bun-bootstrap-native-deps-1.1.4)))))

(define %bun-1.1.26-commit
  "0a37423bafab6aebe803e5f1594cffa9796f2ae6")

(define %bun-1.1.26-source
  (git-origin "bun" "https://github.com/oven-sh/bun" %bun-1.1.26-commit
              "0ijbrqcn6g7fqcyzlb97ri2vhk9mry6flkmw44yampzbl30cnaxx"))

(define %bun-1.1.26-webkit-source
  ;; This is the source revision selected by Bun 1.1.26's build system.  The
  ;; repository gitlink lagged behind and lacks headers required by this Bun.
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "21fc366db3de8f30dbb7f5997b9b9f5cf422ff1e"
              "1bz2s92p4li1qiqj8g1x7907qbsqgn9ya8f8g14f462yx2gbc75v"))

(define %bun-1.1.26-libdeflate-source
  (git-origin "libdeflate" "https://github.com/ebiggers/libdeflate"
              "dc76454a39e7e83b68c3704b6e3784654f8d5ac5"
              "0s9x8shpcrnjbydq1xbxyar3gar59pypnf99mxphad1xzflp2pc1"))

(define %bun-1.1.26-changed-dependency-sources
  `(("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "29a2cd359458c9384694b75456026e4b57e3e567"
                   "1klwhzi7b4p5dwjvkci1wgf8lqvmn7vcm35ajw29ficmksdc9rg1"))
    ("c-ares" ,(git-origin "c-ares" "https://github.com/c-ares/c-ares"
                "d1722e6e8acaf10eb73fa995798a9cd421d9f85e"
                "057d8vgqy6mqniwwa5sb88zgr9jx1csm4scx037hfm0sd7jx30bc"))
    ("libarchive" ,(git-origin "libarchive"
                    "https://github.com/libarchive/libarchive"
                    "898dc8319355b7e985f68a9819f182aaed61b53a"
                    "02zrxq33793kwy9s5kxd3vcswhyl076rsd4l3xbl19qkq0lzwyxd"))
    ("mimalloc" ,(git-origin "mimalloc"
                  "https://github.com/Jarred-Sumner/mimalloc"
                  "4c283af60cdae205df5a872530c77e2a6a307d43"
                  "0syx024s5ig8prsk5hibhnwbwl6fsxmms94f5rwj4kwgqv5kzsc9"))
    ("zstd" ,(git-origin "zstd" "https://github.com/facebook/zstd"
              "794ea1b0afca0f020f4e57b6732332231fb23c70"
              "1mshnj817iqf3qwwhhh6vjivskc2vkc9wwkq9z61hm1a2kd7vix9"))))

(define bun-bootstrap-jsc-1.1.26
  (package
    (inherit bun-bootstrap-jsc-1.1.4)
    (version "1.1.26")
    (source
     %bun-1.1.26-webkit-source)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-jsc-1.1.4)
       ((#:phases phases)
        #~(modify-phases #$phases
            (replace 'build
              (lambda* (#:key inputs
                        (parallel-build? #t) #:allow-other-keys)
                (let ((release "WebKitBuild/Release")
                      (gcc (assoc-ref inputs "gcc-toolchain"))
                      (jobs (if parallel-build?
                                (number->string (parallel-job-count)) "1")))
                  (setenv "CC"
                          (search-input-file inputs "/bin/clang"))
                  (setenv "CXX"
                          (search-input-file inputs "/bin/clang++"))
                  (setenv "CFLAGS"
                   "-O3 -march=nehalem -mtune=nehalem -ffat-lto-objects")
                  ;; GCC 14 added C++23 P2165R4 pair-like constructors after
                  ;; this WebKit snapshot.  Use the preceding Guix toolchain,
                  ;; matching the release-era libstdc++ while retaining
                  ;; Clang 16 as the compiler.  Reference:
                  ;; https://gcc.gnu.org/pipermail/gcc-cvs/2024-February/398177.html
                  (setenv "CXXFLAGS"
                          (string-append (getenv "CFLAGS") " --gcc-toolchain="
                                         gcc " -DUSE_BUN_JSC_ADDITIONS=ON"))
                  (invoke "cmake"
                          "-S"
                          "."
                          "-B"
                          release
                          "-G"
                          "Ninja"
                          "-DPORT=JSCOnly"
                          "-DENABLE_STATIC_JSC=ON"
                          "-DCMAKE_BUILD_TYPE=Release"
                          "-DUSE_THIN_ARCHIVES=OFF"
                          "-DUSE_BUN_JSC_ADDITIONS=ON"
                          "-DENABLE_FTL_JIT=ON"
                          "-DENABLE_REMOTE_INSPECTOR=ON"
                          "-DJSEXPORT_PRIVATE=WTF_EXPORT_DECLARATION"
                          "-DALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS=ON"
                          "-DUSE_VISIBILITY_ATTRIBUTE=1"
                          "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
                          (string-append "-DCMAKE_C_COMPILER="
                                         (getenv "CC"))
                          (string-append "-DCMAKE_CXX_COMPILER="
                                         (getenv "CXX")))
                  (invoke "cmake"
                          "--build"
                          release
                          "--parallel"
                          jobs
                          "--config"
                          "relwithdebuginfo"
                          "--target"
                          "jsc"))))))))
    (native-inputs (cons (list "gcc-toolchain" gcc-toolchain-13)
                         (package-native-inputs bun-bootstrap-jsc-1.1.4)))))

(define %bun-1.1.26-node-modules
  (bun-bootstrap-node-modules "1.1.26" %bun-1.1.26-all-npm-inputs))

(define-public bun-bootstrap-native-deps-1.1.26
  (package
    (inherit bun-bootstrap-native-deps-1.1.4)
    (version "1.1.26")
    (source
     %bun-1.1.26-source)
    (arguments
     (substitute-keyword-arguments (package-arguments
                                    bun-bootstrap-native-deps-1.1.4)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install-pinned-sources 'install-libdeflate-source
              (lambda* (#:key inputs #:allow-other-keys)
                (copy-recursively (assoc-ref inputs "source-libdeflate")
                                  "src/deps/libdeflate")
                ;; The Make build still includes src/deps directly, whereas
                ;; the newer CMake build includes src/deps/libdeflate.
                (symlink "libdeflate/libdeflate.h" "src/deps/libdeflate.h")))
            (replace 'build
              (lambda _
                ;; The prebuilt-JSC copy target was renamed after 1.1.4.
                ;; Its input is our independently source-built JSC package.
                (mkdir-p "build/bun-deps")
                (invoke "make" "jsc-build-copy" "jsc-copy-headers")
                (invoke "cmake"
                        "-S"
                        "src/deps/libdeflate"
                        "-B"
                        "build/libdeflate"
                        "-G"
                        "Ninja"
                        "-DLIBDEFLATE_BUILD_SHARED_LIB=OFF"
                        "-DLIBDEFLATE_BUILD_GZIP=OFF"
                        "-DLIBDEFLATE_BUILD_TESTS=OFF")
                (invoke "cmake" "--build" "build/libdeflate")
                (copy-file "build/libdeflate/libdeflate.a"
                           "build/bun-deps/libdeflate.a")
                ;; This older zlib configure script uses compiler probes that
                ;; reject Bun's executable-only -fno-pic/-fno-pie flags.
                (invoke "make" "zlib"
                        "CFLAGS=-O3 -march=nehalem -mtune=nehalem")
                ;; libarchive's Autoconf probes also link and execute test
                ;; programs, so keep executable-only flags out of them.
                (invoke "make" "libarchive"
                        "CFLAGS=-O3 -march=nehalem -mtune=nehalem -fPIC")
                (apply invoke "make"
                       '("mimalloc" "picohttp"
                         "boringssl"
                         "lolhtml"
                         "sqlite"
                         "uws"
                         "c-ares"
                         "zstd"
                         "tinycc"))))))))
    (native-inputs (let ((inputs (cons (list "source-libdeflate"
                                             %bun-1.1.26-libdeflate-source)
                                       (modify-inputs (package-native-inputs
                                                       bun-bootstrap-native-deps-1.1.4)
                                         (replace "autoconf" autoconf-2.71)
                                         (replace "webkit"
                                                  %bun-1.1.26-webkit-source)
                                         (replace "jsc"
                                                  bun-bootstrap-jsc-1.1.26)
                                         (replace "node-modules"
                                                  %bun-1.1.26-node-modules)
                                         (replace "zig" zig-0.13)))))
                     (fold (lambda (entry result)
                             (modify-inputs result
                               (replace (string-append "source-"
                                                       (car entry))
                                        (cadr entry)))) inputs
                           %bun-1.1.26-changed-dependency-sources)))))

(define-public bun-bootstrap-1.1.26
  (package
    (inherit bun-bootstrap-1.1.4)
    (version "1.1.26")
    (source
     bun-bootstrap-native-deps-1.1.26)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-1.1.4)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build 'select-release-libstdc++
              (lambda* (#:key inputs #:allow-other-keys)
                (setenv "CXXFLAGS"
                        (string-append "--gcc-toolchain="
                                       (assoc-ref inputs "gcc-toolchain")))))
            (add-before 'build 'expose-native-outputs
              (lambda _
                ;; The inherited 1.0 CMake invocation names src/deps as its
                ;; output directory; 1.1's Make targets use build/bun-deps.
                (for-each (lambda (file)
                            (symlink (canonicalize-path file)
                                     (string-append "src/deps/"
                                                    (basename file))))
                          (find-files "build/bun-deps" ".*"))))
            (add-before 'build 'use-cxx-atomics
              (lambda _
                ;; This is a C++20 translation unit.  Clang 16 does not expose
                ;; the C11 stdatomic free functions here; use the equivalent
                ;; standard C++ atomic type and member operations.
                (substitute* "src/bun.js/bindings/wtf-bindings.cpp"
                  (("static _Atomic int orig_termios_spinlock;")
                   "static std::atomic<int> orig_termios_spinlock;")
                  (("atomic_exchange\\(&orig_termios_spinlock, 1\\)")
                   "orig_termios_spinlock.exchange(1)")
                  (("atomic_store\\(&orig_termios_spinlock, 0\\)")
                   "orig_termios_spinlock.store(0)")
                  (("atomic_compare_exchange_strong\\(&orig_termios_spinlock, &expected, 1\\)")
                   "orig_termios_spinlock.compare_exchange_strong(expected, 1)"))
                ;; Guix's LLVM package exposes the canonical lld driver name;
                ;; it does not install Debian's version-suffixed alias.
                (substitute* "CMakeLists.txt"
                  (("-fuse-ld=lld-\\$\\{LLVM_VERSION\\}")
                   "-fuse-ld=lld"))))))))
    (native-inputs (cons* (list "bun-seed" bun-bootstrap-1.1.4)
                          (list "gcc-toolchain" gcc-toolchain-13)
                          (modify-inputs (package-native-inputs
                                          bun-bootstrap-native-deps-1.1.26)
                            (delete "source-libdeflate"))))))

(define %bun-1.3.1-commit
  "89fa0f343945e61d5e4a0077cc7e93a802ed56e7")

(define %bun-1.3.1-source
  (git-origin "bun" "https://github.com/oven-sh/bun" %bun-1.3.1-commit
              "14gw3bvfia6jzs3jkj9642pqva3y6n4y2119f91nil3jnyhf4kw5"))

(define %bun-1.3.1-webkit-source
  ;; SetupWebKit.cmake's default source-compatible revision.
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "6d0f3aac0b817cc01a846b3754b21271adedac12"
              "1y5nms3fdyaw4n5qblm7g1zfm2pclwzkynqyjg9zf8javv1y4xl4"))

(define %bun-1.3.1-zig-source
  (git-origin "zig" "https://github.com/oven-sh/zig"
              "55fdbfa0c86be86b68d43a4ba761e6909eb0d7b2"
              "0j27z0ac2qdal8z3rji5vmzxf4dkyznhp4sjybxyyh0j3nh8fw6a"))

(define-public bun-bootstrap-zig-1.3.1
  (package
    (inherit zig-0.14)
    (name "bun-bootstrap-zig")
    (version "0.14.1-bun.1.3.1")
    (source
     (origin
       (inherit %bun-1.3.1-zig-source)
       ;; Keep Guix's official Zig 0.14 system-path and RUNPATH fixes when
       ;; substituting Bun's pinned fork.  These make stage3 executable
       ;; inside the build environment without post-link patchelf.
       ;; References:
       ;; https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/patches/zig-0.14-use-system-paths.patch
       ;; https://git.savannah.gnu.org/cgit/guix.git/tree/gnu/packages/patches/zig-0.14-fix-runpath.patch
       (patches (origin-patches (package-source zig-0.14)))))
    (arguments
     (substitute-keyword-arguments (package-arguments zig-0.14)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build-zig1 'install-fork-stage3
              (lambda* (#:key outputs #:allow-other-keys)
                ;; Bun's Zig fork does not install the stage3 executable,
                ;; although the inherited Guix bootstrap expects to use it
                ;; for update-zig1.  Install the compiler produced entirely
                ;; by the preceding source build before that phase runs.
                (let ((out (assoc-ref outputs "out")))
                  (unless (file-exists? (string-append out "/bin/zig"))
                    (mkdir-p (string-append out "/bin"))
                    (install-file "stage3/bin/zig"
                                  (string-append out "/bin")))
                  (unless (file-exists? (string-append out "/lib/zig"))
                    (mkdir-p (string-append out "/lib"))
                    (copy-recursively "stage3/lib/zig"
                                      (string-append out "/lib/zig"))))))))))
    (synopsis "Zig compiler used to build Bun 1.3.1")
    (description "This package provides the Zig compiler used to build Bun.")))

(define %bun-1.3.1-dependency-sources
  `(("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "f1ffd9e83d4f5c28a9c70d73f9a4e6fcf310062f"
                   "1g94h4sx6i2z1dg1fc7b4bkzgril5hapks0z0i9v0cvy3z4ma4p4"))
    ("brotli" ,(git-origin "brotli" "https://github.com/google/brotli"
                "v1.1.0"
                "0cvcq302wpjpd1a2cmxcp9a01lwvc2kkir8vsdb3x11djnxc0nsk"))
    ("cares" ,(git-origin "cares" "https://github.com/c-ares/c-ares"
               "d3a507e920e7af18a5efb7f9f1d8044ed4750013"
               "02jy7k0x5wwc28v6nywqm2np603zgrs9js45xm1j8hvvmdx3ir1i"))
    ("highway" ,(git-origin "highway" "https://github.com/google/highway"
                 "ac0d5d297b13ab1b89f48484fc7911082d76a93f"
                 "1bl576f3zlygxfmjqs5rrk3sag411hlhx2210lpq461plvvs80zi"))
    ("libarchive" ,(git-origin "libarchive"
                    "https://github.com/libarchive/libarchive"
                    "9525f90ca4bd14c7b335e2f8c84a4607b0af6bdf"
                    "1prmq89ra1hcs324hjyz078jp3rldq6aa3p77jpp5ji0gfq3mfd6"))
    ("libdeflate" ,(git-origin "libdeflate"
                    "https://github.com/ebiggers/libdeflate"
                    "96836d7d9d10e3e0d53e6edb54eb908514e336c4"
                    "1anhd3c4jg3x9jgz1in27cj9yj1arxbqg4vwdzh46rvbsndxg991"))
    ("libuv" ,(git-origin "libuv" "https://github.com/libuv/libuv"
               "f3ce527ea940d926c40878ba5de219640c362811"
               "0814fsrwbxmn2j9vvq6jbdblw3lmhc1rcsjfh8fzw9wb0w1y9082"))
    ("lolhtml" ,(git-origin "lolhtml" "https://github.com/cloudflare/lol-html"
                 "d64457d9ff0143deef025d5df7e8586092b9afb7"
                 "022r1fa7crwriaganfyqwv0s53llpp8qs72nfy8y7fnhhzg358xp"))
    ("lshpack" ,(git-origin "lshpack"
                 "https://github.com/litespeedtech/ls-hpack"
                 "8905c024b6d052f083a3d11d0a169b3c2735c8a1"
                 "0wwr69vxv53jbzaaqml49kbz6bzgdbrd9h47c9131ii6xdgkvzh6"))
    ("mimalloc" ,(git-origin "mimalloc" "https://github.com/oven-sh/mimalloc"
                  "1beadf9651a7bfdec6b5367c380ecc3fe1c40d1a"
                  "1aslqv6awflxlnppfh7pm8km7a2619fqshxd6445pgif6dq43176"))
    ("picohttpparser" ,(git-origin "picohttpparser"
                        "https://github.com/h2o/picohttpparser"
                        "066d2b1e9ab820703db0837a7255d92d30f0c9f5"
                        "0g2g1x34xqyck37vs7kjm9762w859xmvhhl839kcy0rb7vj0w177"))
    ("tinycc" ,(git-origin "tinycc" "https://github.com/oven-sh/tinycc"
                "29985a3b59898861442fa3b43f663fc1af2591d7"
                "024bjy1jkz9gnjyfgsj60q1pq748rncha2dwbnbjlwiz2l1ybzn8"))
    ("zlib" ,(cadr (assoc "zlib" %bun-1.0.30-dependency-sources)))
    ("hdrhistogram" ,(git-origin "hdrhistogram"
                      "https://github.com/HdrHistogram/HdrHistogram_c"
                      "be60a9987ee48d0abf0d7b6a175bad8d6c1585d1"
                      "0ifjprpp4xrci0mz3axx261vs9jn7lkwypdycvqix949za07wypm"))
    ("zstd" ,(git-origin "zstd" "https://github.com/facebook/zstd"
              "f8745da6ff1ad1e7bab384bd1f9d742439278e99"
              "13jbpfhx3as4494k2x9fci1c54mrrij74mn70wrzlxbj7whmdldl"))))

(define bun-bootstrap-jsc-1.3.1
  (package
    (inherit bun-bootstrap-jsc-1.0.7)
    (version "1.3.1")
    (source
     %bun-1.3.1-webkit-source)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-jsc-1.0.7)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build 'qualify-cmath-functions
              (lambda _
                ;; This is the same namespace qualification present in newer
                ;; upstream WebKit revisions for C++23 toolchains.
                (substitute* "Source/JavaScriptCore/runtime/JSCJSValueInlines.h"
                  (("return isnan\\(d\\) \\? 0\\.0 : trunc\\(d\\) \\+ 0\\.0;")
                   "return std::isnan(d) ? 0.0 : std::trunc(d) + 0.0;")
                  (("return trunc\\(std::isnan\\(d\\) \\? 0\\.0 : d \\+ 0\\.0\\);")
                   "return std::trunc(std::isnan(d) ? 0.0 : d + 0.0);"))))
            (replace 'build
              (lambda* (#:key inputs
                        (parallel-build? #t) #:allow-other-keys)
                (let ((release "WebKitBuild/Release")
                      (jobs (if parallel-build?
                                (number->string (parallel-job-count)) "1")))
                  (setenv "CC"
                          (search-input-file inputs "/bin/clang"))
                  (setenv "CXX"
                          (search-input-file inputs "/bin/clang++"))
                  (setenv "CFLAGS"
                   "-O3 -march=nehalem -mtune=nehalem -ffat-lto-objects")
                  (setenv "CXXFLAGS"
                          (string-append (getenv "CFLAGS")
                                         " -DUSE_BUN_JSC_ADDITIONS=ON"))
                  (invoke "cmake"
                          "-S"
                          "."
                          "-B"
                          release
                          "-G"
                          "Ninja"
                          "-DPORT=JSCOnly"
                          "-DENABLE_STATIC_JSC=ON"
                          "-DCMAKE_BUILD_TYPE=Release"
                          "-DUSE_THIN_ARCHIVES=OFF"
                          "-DUSE_BUN_JSC_ADDITIONS=ON"
                          ;; This option selects Source/WTF/wtf/bun/RunLoopBun.cpp.
                          ;; It is paired with JSC additions by Bun's own Makefile.
                          "-DUSE_BUN_EVENT_LOOP=ON"
                          "-DENABLE_FTL_JIT=ON"
                          "-DENABLE_REMOTE_INSPECTOR=ON"
                          "-DJSEXPORT_PRIVATE=WTF_EXPORT_DECLARATION"
                          "-DALLOW_LINE_AND_COLUMN_NUMBER_IN_BUILTINS=ON"
                          "-DUSE_VISIBILITY_ATTRIBUTE=1"
                          "-DCMAKE_EXPORT_COMPILE_COMMANDS=ON"
                          (string-append "-DCMAKE_C_COMPILER="
                                         (getenv "CC"))
                          (string-append "-DCMAKE_CXX_COMPILER="
                                         (getenv "CXX")))
                  (invoke "cmake"
                          "--build"
                          release
                          "--parallel"
                          jobs
                          "--config"
                          "relwithdebuginfo"
                          "--target"
                          "jsc"))))))))
    ;; Bun 1.3.1's bootstrap recipe fixes LLVM at 19.1.7.  Use Guix's LLVM 19
    ;; toolchain for both JSC and the Bun executable.
    (native-inputs (list clang-toolchain-19
                         cmake-minimal
                         ninja
                         pkg-config
                         perl
                         python
                         ruby))))

(define %bun-1.3.1-node-modules
  (bun-bootstrap-node-modules "1.3.1" %bun-1.3.1-all-npm-inputs))

(define %bun-1.3.1-lol-html-cargo-inputs
  (bun-cargo-inputs 'bun-lol-html-1.3.1))

(define %node-24.3.0-headers
  (origin
    (method url-fetch)
    (uri "https://nodejs.org/dist/v24.3.0/node-v24.3.0-headers.tar.gz")
    (file-name "node-v24.3.0-headers.tar.gz")
    (sha256 (base32 "01yx2n8qxf09xp8f70f5wbgxx17plwxsdhgqcznb0pfdfzs9nph4"))))

(define %node-22.6.0-headers
  (origin
    (method url-fetch)
    (uri "https://nodejs.org/dist/v22.6.0/node-v22.6.0-headers.tar.gz")
    (file-name "node-v22.6.0-headers.tar.gz")
    (sha256 (base32 "1g18a7zmajyd9rd99qsklvz3jxbi0isdq4wc1saq97ja0gs83pj3"))))

(define %bun-1.3.1-dependency-refs
  '(("boringssl" . "f1ffd9e83d4f5c28a9c70d73f9a4e6fcf310062f")
    ("brotli" . "refs/tags/v1.1.0")
    ("cares" . "d3a507e920e7af18a5efb7f9f1d8044ed4750013")
    ("highway" . "ac0d5d297b13ab1b89f48484fc7911082d76a93f")
    ("libarchive" . "9525f90ca4bd14c7b335e2f8c84a4607b0af6bdf")
    ("libdeflate" . "96836d7d9d10e3e0d53e6edb54eb908514e336c4")
    ("libuv" . "f3ce527ea940d926c40878ba5de219640c362811")
    ("lolhtml" . "d64457d9ff0143deef025d5df7e8586092b9afb7")
    ("lshpack" . "8905c024b6d052f083a3d11d0a169b3c2735c8a1")
    ("mimalloc" . "1beadf9651a7bfdec6b5367c380ecc3fe1c40d1a")
    ("picohttpparser" . "066d2b1e9ab820703db0837a7255d92d30f0c9f5")
    ("tinycc" . "29985a3b59898861442fa3b43f663fc1af2591d7")
    ("zlib" . "886098f3f339617b4243b286f5ed364b9989e245")
    ("hdrhistogram" . "be60a9987ee48d0abf0d7b6a175bad8d6c1585d1")
    ("zstd" . "f8745da6ff1ad1e7bab384bd1f9d742439278e99")))

(define bun-bootstrap-1.3.1-base
  (package
    (name "bun-bootstrap")
    (version "1.3.1")
    (source
     %bun-1.3.1-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux"))
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:imported-modules (cons* '(roquix packages bun-bootstrap affinity)
                                '(roquix packages bun-bootstrap cargo)
                                '(roquix packages bun-bootstrap esbuild)
                                '(guix build cargo-build-system)
                                %default-gnu-imported-modules)
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'install-node-modules
            (lambda* (#:key inputs #:allow-other-keys)
              (use-modules (roquix packages bun-bootstrap esbuild))
              ;; The lock-derived npm tree is generated from this same source
              ;; revision and includes every workspace node_modules tree.
              (let ((null (open-output-file "/dev/null"))
                    (tree (assoc-ref inputs "node-modules")))
                (for-each (lambda (path)
                            (copy-recursively (string-append tree "/" path)
                                              path
                                              #:log null))
                          '("node_modules" "packages/bun-error/node_modules"
                            "src/node-fallbacks/node_modules"))
                (close-port null))
              (invoke "chmod" "-R" "u+w" ".")
              ;; npm's esbuild package binary was deliberately removed from
              ;; the lock-derived tree.  Bind each expected CLI path to a Guix
              ;; source build.  The fallback bundle requires the exact old
              ;; esbuild API declared by its own package.json.
              (bind-bun-esbuild-tools inputs
                                      '#$%bun-bootstrap-esbuild-bindings)
              ;; These tags declare readable-stream but retain an obsolete
              ;; tsconfig alias to the undeclared stream-browserify package.
              ;; Point the Node "stream" fallback at the dependency that the
              ;; manifest and stream.js both select.
              (substitute* "src/node-fallbacks/tsconfig.json"
                (("node_modules/stream-browserify")
                 "node_modules/readable-stream"))
              ;; The lock-derived npm input already supplies every declared
              ;; package.json.  Keep Ninja's timestamp checks from invoking
              ;; Bun's network installer by making those registered commands
              ;; explicit no-ops; their outputs are checked below.
              (for-each (lambda (file)
                          (unless (file-exists? file)
                            (error "lock-derived npm input is incomplete" file)))
                        '("node_modules/esbuild/package.json"
                          "src/node-fallbacks/node_modules/assert/package.json"))
              ;; bun-error used React through 1.2.x and switched to Preact in
              ;; 1.3.1.  Require the dependency declared by the checked-out
              ;; package, without making this shared phase version-specific.
              (unless (or (file-exists?
                           "packages/bun-error/node_modules/react/package.json")
                          (file-exists?
                           "packages/bun-error/node_modules/preact/package.json"))
                (error
                 "lock-derived npm input lacks bun-error's UI dependency"))
              (substitute* "cmake/Globals.cmake"
                (("\\$\\{BUN_EXECUTABLE\\}")
                 "${CMAKE_COMMAND}")
                (("        install")
                 "        -E")
                (("        --frozen-lockfile")
                 "        true")
                ;; CMake 4 no longer accepts dependencies that merely declare
                ;; a pre-3.5 policy floor.  Preserve their source while making
                ;; the supported compatibility floor explicit for every
                ;; nested CMake configure invocation.
                (("set\\(MAKE_EFFECTIVE_ARGS -B\\$\\{MAKE_BUILD_PATH\\} \\$\\{CMAKE_ARGS\\}\\)")
                 (string-append
                  "set(MAKE_EFFECTIVE_ARGS -B${MAKE_BUILD_PATH} ${CMAKE_ARGS} "
                  "-DCMAKE_POLICY_VERSION_MINIMUM=3.5 "
                  "-DCMAKE_INSTALL_LIBDIR=lib)")))
              (substitute* "cmake/tools/SetupEsbuild.cmake"
                (("\\$\\{BUN_EXECUTABLE\\}")
                 "${CMAKE_COMMAND}")
                (("      install")
                 "      -E")
                (("      --frozen-lockfile")
                 "      true"))
              ;; Public JSC headers include names such as
              ;; <JavaScriptCore/JSBase.h>; local WebKit mode must therefore
              ;; expose the parent Headers directory as well as its child.
              (substitute* "cmake/tools/SetupWebKit.cmake"
                (("      \\$\\{WEBKIT_PATH\\}/JavaScriptCore/Headers/JavaScriptCore")
                 "      ${WEBKIT_PATH}/JavaScriptCore/Headers
      ${WEBKIT_PATH}/JavaScriptCore/Headers/JavaScriptCore"))
              (when (file-exists?
                     "src/bun.js/bindings/workaround-missing-symbols.cpp")
                ;; This is C++20; do not depend on a transitive header to
                ;; provide the legacy C NULL macro.
                (substitute* "src/bun.js/bindings/workaround-missing-symbols.cpp"
                  (("static fcntl64_func real_fcntl64 = NULL;")
                   "static fcntl64_func real_fcntl64 = nullptr;")))))
          (add-after 'patch-generated-file-shebangs 'install-pinned-sources
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((null (open-output-file "/dev/null")))
                (mkdir-p "vendor")
                (for-each (lambda (entry)
                            (let* ((name (car entry))
                                   (directory (string-append "vendor/" name)))
                              (copy-recursively (assoc-ref inputs
                                                           (string-append
                                                            "source-" name))
                                                directory
                                                #:log null)
                              (call-with-output-file (string-append directory
                                                                    "/.ref")
                                (lambda (port)
                                  (display (cdr entry) port)))))
                          '#$%bun-1.3.1-dependency-refs)
                (close-port null))
              (invoke "chmod" "-R" "u+w" "vendor")
              ;; GitClone.cmake normally applies Bun's dependency patches.
              ;; Apply the same checked-in patch set to our pinned inputs.
              (for-each (lambda (name)
                          (let ((patch-directory (string-append "patches/"
                                                                name))
                                (vendor-directory (string-append "vendor/"
                                                                 name)))
                            (when (file-exists? patch-directory)
                              (for-each (lambda (patch)
                                          (if (string-suffix? ".patch" patch)
                                              (let ((absolute-patch (canonicalize-path
                                                                     patch)))
                                                (with-directory-excursion vendor-directory
                                                  (invoke "git"
                                                   "apply"
                                                   "--ignore-whitespace"
                                                   "--ignore-space-change"
                                                   "--no-index"
                                                   "--verbose"
                                                   absolute-patch)))
                                              (copy-file patch
                                                         (string-append
                                                          vendor-directory "/"
                                                          (basename patch)))))
                                        (find-files patch-directory ".*")))))
                        (map car
                             '#$%bun-1.3.1-dependency-refs))
              ;; CMake 4 removed compatibility with policy versions below
              ;; 3.5.  ls-hpack uses no behavior that requires the obsolete
              ;; 2.8 policy set, so raise only its declared policy floor.
              (substitute* "vendor/lshpack/CMakeLists.txt"
                (("CMAKE_MINIMUM_REQUIRED\\(VERSION 2\\.8\\)")
                 "CMAKE_MINIMUM_REQUIRED(VERSION 3.5)"))
              ;; Supply the exact source-built Zig fork in the directory
              ;; layout consumed by SetupZig.cmake.
              (mkdir-p "vendor/zig")
              (symlink (search-input-file inputs "/bin/zig") "vendor/zig/zig")
              (if (assoc-ref inputs "zig-library")
                  (begin
                    (copy-recursively (string-append (assoc-ref inputs
                                                                "zig-library")
                                                     "/lib") "vendor/zig/lib")
                    ;; Zig probes /usr/bin/env as a representative native ELF
                    ;; when resolving the host ABI and dynamic linker.  Guix
                    ;; build containers deliberately have no /usr tree, so
                    ;; point the probe at the equivalent explicit input.
                    (substitute* "vendor/zig/lib/std/zig/system.zig"
                      (("/usr/bin/env")
                       (search-input-file inputs "/bin/env"))))
                  (symlink (string-append (assoc-ref inputs "zig") "/lib/zig")
                           "vendor/zig/lib"))
              ;; Supply fixed Node.js headers so bun-node-headers cannot use
              ;; CMake's download path.
              (mkdir-p "vendor/nodejs")
              (invoke "tar"
                      "-xf"
                      (assoc-ref inputs "node-headers")
                      "--strip-components=1"
                      "-C"
                      "vendor/nodejs")
              ;; PrepareNodeHeaders.cmake was added after 1.2.17.  Older
              ;; releases consume the upstream header archive directly.
              (when (file-exists? "cmake/scripts/PrepareNodeHeaders.cmake")
                (invoke "cmake" "-DNODE_INCLUDE_DIR=vendor/nodejs/include"
                        "-P" "cmake/scripts/PrepareNodeHeaders.cmake"))
              ;; Cargo must consume only the fixed lol-html crate closure.
              (setenv "HOME"
                      (string-append (getcwd) "/.home"))
              (setenv "CARGO_HOME"
                      (string-append (getcwd) "/.cargo"))
              (mkdir-p (getenv "HOME"))
              (mkdir-p (getenv "CARGO_HOME"))
              (use-modules (roquix packages bun-bootstrap cargo))
              (install-bun-cargo-vendor #:source (assoc-ref inputs "source")
                                        #:inputs inputs
                                        #:checksums (assoc-ref inputs
                                                     "lol-html-cargo-checksums")
                                        #:vendor-dir ".cargo/vendor")
              (call-with-output-file ".cargo/config.toml"
                (lambda (port)
                  (display "[source.crates-io]
replace-with = \"vendored-sources\"

[source.vendored-sources]
directory = \".cargo/vendor\"

[net]
offline = true
" port)))
              ;; Link Guix ICU at build time and record its runtime search
              ;; path in the linker invocation.  No finished ELF is edited.
              (substitute* "cmake/targets/BuildBun.cmake"
                (("target_link_libraries.*libicudata\\.a.*")
                 "target_link_libraries(${bun} PRIVATE icudata)
")
                (("target_link_libraries.*libicui18n\\.a.*")
                 "target_link_libraries(${bun} PRIVATE icui18n)
")
                (("target_link_libraries.*libicuuc\\.a.*")
                 "target_link_libraries(${bun} PRIVATE icuuc)
"))
              ;; A fresh Ninja log otherwise executes repository fetch rules
              ;; even when all declared outputs are already pinned locally.
              (substitute* "cmake/scripts/GitClone.cmake"
                (("if\\(GIT_COMMIT\\)")
                 "if(EXISTS ${GIT_PATH}/.ref)
  return()
endif()

if(GIT_COMMIT)"))
              (substitute* "cmake/scripts/DownloadZig.cmake"
                (("if\\(CMAKE_HOST_APPLE\\)")
                 "if(EXISTS ${ZIG_PATH}/zig)
  return()
endif()

if(CMAKE_HOST_APPLE)"))
              ;; The fixed Node header origin has already populated the
              ;; registered output.  A fresh Ninja log still schedules the
              ;; download rule, so make the downloader recognize that exact
              ;; completed tree before it attempts network access.
              (substitute* "cmake/scripts/DownloadUrl.cmake"
                (("^if\\(NOT DOWNLOAD_URL OR NOT DOWNLOAD_PATH\\)")
                 "if(EXISTS ${DOWNLOAD_PATH}/include/node/node_version.h)
  return()
endif()

if(NOT DOWNLOAD_URL OR NOT DOWNLOAD_PATH)"))))
          (delete 'configure)
          (replace 'build
            (lambda* (#:key inputs #:allow-other-keys)
              (use-modules (roquix packages bun-bootstrap affinity))
              (let ((seed (search-input-file inputs "/bin/bun"))
                    (icu (assoc-ref inputs "icu4c"))
                    (libc (assoc-ref inputs "glibc"))
                    (jobs (min 4 (parallel-job-count))))
                (setenv "CC"
                        (search-input-file inputs "/bin/clang"))
                (setenv "CXX"
                        (search-input-file inputs "/bin/clang++"))
                (setenv "AR"
                        (search-input-file inputs "/bin/llvm-ar"))
                (setenv "RANLIB"
                        (search-input-file inputs "/bin/llvm-ranlib"))
                ;; Source origins such as TinyCC contain top-level include/
                ;; directories.  They are inputs to explicit vendor builds,
                ;; not global system headers; keep Guix's environment hooks
                ;; from leaking them into unrelated native dependencies.
                (letrec ((source-path? (lambda (path entries)
                                         (and (pair? entries)
                                              (let ((entry (car entries)))
                                                (or (and (string-prefix?
                                                          "source-"
                                                          (car entry))
                                                         (string-prefix? (cdr
                                                                          entry)
                                                                         path))
                                                    (source-path? path
                                                                  (cdr entries)))))))
                         (remove-source-paths (lambda (paths)
                                                (cond
                                                  ((null? paths)
                                                   '())
                                                  ((source-path? (car paths)
                                                                 inputs)
                                                   (remove-source-paths (cdr
                                                                         paths)))
                                                  (else (cons (car paths)
                                                              (remove-source-paths
                                                               (cdr paths)))))))
                         (join-paths (lambda (paths)
                                       (cond
                                         ((null? paths)
                                          "")
                                         ((null? (cdr paths))
                                          (car paths))
                                         (else (string-append (car paths) ":"
                                                              (join-paths (cdr
                                                                           paths))))))))
                  (for-each (lambda (variable)
                              (let ((value (getenv variable)))
                                (when value
                                  (setenv variable
                                          (join-paths (remove-source-paths (string-split
                                                                            value
                                                                            #\:)))))))
                            '("CPATH" "C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH"
                              "OBJC_INCLUDE_PATH")))
                ;; Bun enables full LLVM LTO for its nested native projects.
                ;; Make those child CMake link checks use the matching LLD;
                ;; GNU ld otherwise searches for an unavailable LLVMgold.so.
                (setenv "LDFLAGS" "-fuse-ld=lld")
                ;; These deterministic source manifests are intentionally
                ;; absent from newer tags and must exist before CMake reads
                ;; them.  Older CMake files glob their sources directly.
                (when (file-exists? "scripts/glob-sources.mjs")
                  (invoke seed "run" "glob-sources"))
                (invoke "cmake"
                        "-S"
                        "."
                        "-B"
                        "build/release"
                        "-G"
                        "Ninja"
                        "-DCMAKE_BUILD_TYPE=Release"
                        "-DENABLE_BASELINE=ON"
                        (string-append "-DCMAKE_C_COMPILER="
                                       (getenv "CC"))
                        (string-append "-DCMAKE_CXX_COMPILER="
                                       (getenv "CXX"))
                        (string-append "-DBUN_EXECUTABLE=" seed)
                        "-DWEBKIT_LOCAL=ON"
                        (string-append "-DWEBKIT_PATH="
                                       (assoc-ref inputs "jsc"))
                        (string-append "-DVENDOR_PATH="
                                       (getcwd) "/vendor")
                        (string-append "-DCMAKE_BUILD_PARALLEL_LEVEL="
                                       (number->string jobs))
                        (string-append
                         "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld -Wl,-rpath,"
                         icu "/lib -Wl,-rpath," libc "/lib"))
                (call-with-limited-cpu-affinity
                 jobs
                 (lambda ()
                   (invoke "cmake"
                           "--build"
                           "build/release"
                           "--parallel"
                           (number->string jobs)))))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                (mkdir-p bin)
                (install-file "build/release/bun-profile" bin)
                (rename-file (string-append bin "/bun-profile")
                             (string-append bin "/bun"))
                (chmod (string-append bin "/bun") #o555)
                (symlink "bun"
                         (string-append bin "/bunx")))))
          (add-after 'install 'check-bootstrap
            (lambda* (#:key outputs inputs #:allow-other-keys)
              (use-modules (ice-9 popen)
                           (ice-9 textual-ports))
              (let* ((bun (string-append (assoc-ref outputs "out") "/bin/bun"))
                     (readelf (search-input-file inputs "/bin/readelf"))
                     (port (open-pipe* OPEN_READ readelf "-dW" bun))
                     (dynamic (get-string-all port))
                     (status (close-pipe port)))
                (unless (zero? status)
                  (error "readelf failed while checking Bun"))
                (invoke bun "--version")
                (invoke bun "-e"
                 "console.log('source-bootstrap-ok', process.versions.bun)")
                (unless (string-contains dynamic
                                         (assoc-ref inputs "icu4c"))
                  (error "Bun RUNPATH does not contain the Guix ICU input"))
                (when (or (string-contains dynamic "/usr")
                          (string-contains dynamic "/lib64"))
                  (error "host path present in Bun dynamic metadata"))))))))
    (native-inputs (append `(("bun-seed" ,bun-bootstrap-1.1.26)
                             ("jsc" ,bun-bootstrap-jsc-1.3.1)
                             ("zig" ,bun-bootstrap-zig-1.3.1)
                             ("node-modules" ,%bun-1.3.1-node-modules)
                             ("esbuild" ,esbuild)
                             ("esbuild-node-fallbacks" ,esbuild-0.14.54)
                             ("node-headers" ,%node-24.3.0-headers)
                             ("lol-html-cargo-checksums"
                              ,(bun-cargo-checksums-input
                                'bun-lol-html-1.3.1
                                %bun-1.3.1-lol-html-cargo-inputs))
                             ("clang-toolchain" ,clang-toolchain-19)
                             ("lld" ,lld-19)
                             ("cmake" ,cmake-minimal)
                             ("ninja" ,ninja)
                             ("pkg-config" ,pkg-config)
                             ("python" ,python)
                             ("ruby" ,ruby)
                             ("perl" ,perl)
                             ("git" ,git-minimal)
                             ("go" ,go)
                             ("rust" ,rust)
                             ("cargo" ,rust "cargo")
                             ("tar" ,tar)
                             ("binutils" ,binutils))
                           (map (lambda (entry)
                                  (list (string-append "source-"
                                                       (car entry))
                                        (cadr entry)))
                                %bun-1.3.1-dependency-sources)
                           (bun-cargo-input-tuples
                            %bun-1.3.1-lol-html-cargo-inputs)))
    (inputs (list icu4c glibc))
    (home-page "https://bun.sh/")
    (synopsis "Source-bootstrap stage for Bun")
    (description "This package provides the Bun JavaScript runtime.")
    (license (list license:expat license:lgpl2.1))))

;; The version constraints in CMake are weaker than the code generators used
;; by the release tags.  Bun 1.1.26 can execute 1.1.30's Bake generator, while
;; the same probe fails for 1.1.38.  Use that measured compatibility boundary
;; before following the seed versions selected by Bun's bootstrap scripts:
;; 1.1.38 builds 1.2.0, and 1.2.0 builds 1.2.17.
(define %bun-1.1.30-source
  (git-origin "bun" "https://github.com/oven-sh/bun"
              "7996d06b8f5869ccc9ad9a421cd06469da4273fc"
              "0ni509s2il2qrfxqbh341mibhbmda119c9s3av02p3nsk6l8hm4i"))

;; Bun 1.1.30 through 1.2.0 run Zig 0.13 but replace its standard library
;; with this pinned oven-sh fork.  The executable remains Guix's source-built
;; Zig; this origin supplies the exact source library expected by Bun.
(define %bun-zig-library-1.1.30
  (origin
    (inherit (git-origin "zig" "https://github.com/oven-sh/zig"
              "131a009ba2eb127a3447d05b9e12f710429aa5ee"
              "0l94p3bdr6vrjh8r97p4q9q2vzqxg2d58wfkywf3lrcsmcf3a7a4"))
    ;; Compiler behavior lives in Zig's source library.  Apply the same
    ;; system path and RUNPATH corrections as Guix's source-built Zig 0.13
    ;; executable before pairing it with Bun's fork.
    (patches (origin-patches (package-source zig-0.13)))))

(define %bun-1.1.30-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "0a0a3838e5fab36b579df26620237bb62ed6d950"
              "0n0z33sxj9r8prfi12pqdva4imw2virdgi156p98xvpbmfq1yxkk"))

(define %bun-1.1.30-changed-sources
  `(("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "29a2cd359458c9384694b75456026e4b57e3e567"
                   "1klwhzi7b4p5dwjvkci1wgf8lqvmn7vcm35ajw29ficmksdc9rg1"))
    ("cares" ,(git-origin "cares" "https://github.com/c-ares/c-ares"
               "d1722e6e8acaf10eb73fa995798a9cd421d9f85e"
               "057d8vgqy6mqniwwa5sb88zgr9jx1csm4scx037hfm0sd7jx30bc"))
    ("libarchive" ,(git-origin "libarchive"
                    "https://github.com/libarchive/libarchive"
                    "898dc8319355b7e985f68a9819f182aaed61b53a"
                    "02zrxq33793kwy9s5kxd3vcswhyl076rsd4l3xbl19qkq0lzwyxd"))
    ("libdeflate" ,(git-origin "libdeflate"
                    "https://github.com/ebiggers/libdeflate"
                    "dc76454a39e7e83b68c3704b6e3784654f8d5ac5"
                    "0s9x8shpcrnjbydq1xbxyar3gar59pypnf99mxphad1xzflp2pc1"))
    ("libuv" ,(git-origin "libuv" "https://github.com/libuv/libuv"
               "da527d8d2a908b824def74382761566371439003"
               "1vm0xni99d3p2immmshv4sndl2b7hdrh2zqi2z2k98ccddjvrj09"))
    ("lolhtml" ,(cadr (assoc "lol-html" %bun-1.0.7-dependency-sources)))
    ("lshpack" ,(git-origin "lshpack"
                 "https://github.com/litespeedtech/ls-hpack"
                 "3d0f1fc1d6e66a642e7a98c55deb38aa986eb4b0"
                 "1vc57nbqhl5aw5fsgrdsn14438m5zi3b0fw18bdlfvb5bi1m93fm"))
    ("mimalloc" ,(git-origin "mimalloc" "https://github.com/oven-sh/mimalloc"
                  "4c283af60cdae205df5a872530c77e2a6a307d43"
                  "0syx024s5ig8prsk5hibhnwbwl6fsxmms94f5rwj4kwgqv5kzsc9"))
    ("zstd" ,(cadr (assoc "zstd" %bun-1.0.30-dependency-sources)))))

(define %bun-1.1.30-changed-refs
  '(("boringssl" . "29a2cd359458c9384694b75456026e4b57e3e567")
    ("cares" . "d1722e6e8acaf10eb73fa995798a9cd421d9f85e")
    ("libarchive" . "898dc8319355b7e985f68a9819f182aaed61b53a")
    ("libdeflate" . "dc76454a39e7e83b68c3704b6e3784654f8d5ac5")
    ("libuv" . "da527d8d2a908b824def74382761566371439003")
    ("lolhtml" . "8d4c273ded322193d017042d1f48df2766b0f88b")
    ("lshpack" . "3d0f1fc1d6e66a642e7a98c55deb38aa986eb4b0")
    ("mimalloc" . "4c283af60cdae205df5a872530c77e2a6a307d43")
    ("zstd" . "794ea1b0afca0f020f4e57b6732332231fb23c70")))

(define %bun-1.1.30-node-modules
  (bun-bootstrap-node-modules "1.1.30" %bun-1.1.30-all-npm-inputs))

(define %bun-1.1.30-lol-html-cargo-inputs
  %bun-1.0.7-lol-html-cargo-inputs)

(define %bun-1.1.38-source
  (git-origin "bun" "https://github.com/oven-sh/bun"
              "bf2f153f5ca45876bc88369273743cd6fa04881c"
              "102nhr4k44pwbc1316cc664bj6v10p2n5bv3l9s73fj09csfpyzf"))

(define %bun-1.1.38-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "8f9ae4f01a047c666ef548864294e01df731d4ea"
              "00wh5ak1g2fx2hmfyflgg4319fnjvr74krpr3b44gyikqa2bbq6r"))

(define %bun-1.1.38-changed-sources
  `(("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "29a2cd359458c9384694b75456026e4b57e3e567"
                   "1klwhzi7b4p5dwjvkci1wgf8lqvmn7vcm35ajw29ficmksdc9rg1"))
    ("cares" ,(git-origin "cares" "https://github.com/c-ares/c-ares"
               "c29e75d54c3743783d51a609980495cf553b4bca"
               "1zcgba1pyz1ij9g5a49a65wa39gii77l8rv4an8si5zz9b9549dw"))
    ("libarchive" ,(git-origin "libarchive"
                    "https://github.com/libarchive/libarchive"
                    "898dc8319355b7e985f68a9819f182aaed61b53a"
                    "02zrxq33793kwy9s5kxd3vcswhyl076rsd4l3xbl19qkq0lzwyxd"))
    ("libdeflate" ,(git-origin "libdeflate"
                    "https://github.com/ebiggers/libdeflate"
                    "dc76454a39e7e83b68c3704b6e3784654f8d5ac5"
                    "0s9x8shpcrnjbydq1xbxyar3gar59pypnf99mxphad1xzflp2pc1"))
    ("libuv" ,(git-origin "libuv" "https://github.com/libuv/libuv"
               "da527d8d2a908b824def74382761566371439003"
               "1vm0xni99d3p2immmshv4sndl2b7hdrh2zqi2z2k98ccddjvrj09"))
    ("lolhtml" ,(cadr (assoc "lol-html" %bun-1.0.7-dependency-sources)))
    ("lshpack" ,(git-origin "lshpack"
                 "https://github.com/litespeedtech/ls-hpack"
                 "3d0f1fc1d6e66a642e7a98c55deb38aa986eb4b0"
                 "1vc57nbqhl5aw5fsgrdsn14438m5zi3b0fw18bdlfvb5bi1m93fm"))
    ("mimalloc" ,(git-origin "mimalloc" "https://github.com/oven-sh/mimalloc"
                  "82b2c2277a4d570187c07b376557dc5bde81d848"
                  "1injm0zqp37npzh2micky50acjhzfg628azx2qgr4sgd0d57a74i"))
    ("zstd" ,(cadr (assoc "zstd" %bun-1.0.30-dependency-sources)))))

(define %bun-1.1.38-changed-refs
  '(("boringssl" . "29a2cd359458c9384694b75456026e4b57e3e567")
    ("cares" . "c29e75d54c3743783d51a609980495cf553b4bca")
    ("libarchive" . "898dc8319355b7e985f68a9819f182aaed61b53a")
    ("libdeflate" . "dc76454a39e7e83b68c3704b6e3784654f8d5ac5")
    ("libuv" . "da527d8d2a908b824def74382761566371439003")
    ("lolhtml" . "8d4c273ded322193d017042d1f48df2766b0f88b")
    ("lshpack" . "3d0f1fc1d6e66a642e7a98c55deb38aa986eb4b0")
    ("mimalloc" . "82b2c2277a4d570187c07b376557dc5bde81d848")
    ("zstd" . "794ea1b0afca0f020f4e57b6732332231fb23c70")))

(define %bun-1.1.38-node-modules
  (bun-bootstrap-node-modules "1.1.38" %bun-1.1.38-all-npm-inputs))

(define %bun-1.1.38-lol-html-cargo-inputs
  %bun-1.0.7-lol-html-cargo-inputs)

(define bun-bootstrap-jsc-1.1.38
  (package
    (inherit bun-bootstrap-jsc-1.1.26)
    (version "1.1.38")
    (source
     %bun-1.1.38-webkit-source)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-jsc-1.1.26)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build 'qualify-cmath-functions
              (lambda _
                (substitute* "Source/JavaScriptCore/runtime/JSCJSValueInlines.h"
                  (("return isnan\\(d\\) \\? 0\\.0 : trunc\\(d\\) \\+ 0\\.0;")
                   "return std::isnan(d) ? 0.0 : std::trunc(d) + 0.0;")
                  (("return trunc\\(std::isnan\\(d\\) \\? 0\\.0 : d \\+ 0\\.0\\);")
                   "return std::trunc(std::isnan(d) ? 0.0 : d + 0.0);"))))))))))

(define bun-bootstrap-jsc-1.1.30
  (package
    (inherit bun-bootstrap-jsc-1.1.38)
    (version "1.1.30")
    (source
     %bun-1.1.30-webkit-source)))

(define-public bun-bootstrap-1.1.30
  (package
    (inherit bun-bootstrap-1.3.1-base)
    (version "1.1.30")
    (source
     %bun-1.1.30-source)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-1.3.1-base)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install-pinned-sources 'correct-dependency-refs
              (lambda _
                (for-each (lambda (entry)
                            (call-with-output-file (string-append "vendor/"
                                                                  (car entry)
                                                                  "/.ref")
                              (lambda (port)
                                (display (cdr entry) port))))
                          '#$%bun-1.1.30-changed-refs)))))))
    (native-inputs (let ((inputs (modify-inputs (package-native-inputs
                                                 bun-bootstrap-1.3.1-base)
                                   (replace "bun-seed" bun-bootstrap-1.1.26)
                                   (replace "jsc" bun-bootstrap-jsc-1.1.30)
                                   (replace "zig" zig-0.13)
                                   (replace "node-headers"
                                            %node-22.6.0-headers)
                                   (replace "node-modules"
                                            %bun-1.1.30-node-modules)
                                   (replace "clang-toolchain"
                                            clang-toolchain-16)
                                   (replace "lld" lld-16))))
                     (replace-bun-cargo-inputs (cons (list "zig-library"
                                                      %bun-zig-library-1.1.30)
                                                     (fold (lambda (entry
                                                                    result)
                                                             (modify-inputs result
                                                               (replace (string-append
                                                                         "source-"
                                                                         (car
                                                                          entry))
                                                                        (cadr
                                                                         entry))))
                                                      inputs
                                                      %bun-1.1.30-changed-sources))
                      'bun-lol-html-1.0 %bun-1.1.30-lol-html-cargo-inputs)))))

(define-public bun-bootstrap-1.1.38
  (package
    (inherit bun-bootstrap-1.3.1-base)
    (version "1.1.38")
    (source
     %bun-1.1.38-source)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-1.3.1-base)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install-pinned-sources 'correct-dependency-refs
              (lambda _
                (for-each (lambda (entry)
                            (call-with-output-file (string-append "vendor/"
                                                                  (car entry)
                                                                  "/.ref")
                              (lambda (port)
                                (display (cdr entry) port))))
                          '#$%bun-1.1.38-changed-refs)))
            (add-after 'correct-dependency-refs 'expose-jsc-derived-headers
              (lambda _
                ;; Source-built JSC leaves this generated inspector header
                ;; in DerivedSources, where local WebKit builds must find it.
                (substitute* "cmake/tools/SetupWebKit.cmake"
                  (("      \\$\\{WEBKIT_PATH\\}/JavaScriptCore/PrivateHeaders")
                   (string-append
                    "      ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders
"
                    "      ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders/JavaScriptCore
"
                    "      ${WEBKIT_PATH}/JavaScriptCore/DerivedSources/inspector")))
                ;; C++20 exposes this overload through namespace std; do not
                ;; rely on a libc header also defining the C macro globally.
                (substitute* "src/bun.js/bindings/napi.cpp"
                  (("if \\(isfinite\\(js_number\\)\\)")
                   "if (std::isfinite(js_number))"))
                (substitute* "src/bun.js/bindings/workaround-missing-symbols.cpp"
                  (("#include <features.h>")
                   "#include <features.h>
#include <sys/types.h>"))))))))
    (native-inputs (let ((inputs (modify-inputs (package-native-inputs
                                                 bun-bootstrap-1.3.1-base)
                                   (replace "bun-seed" bun-bootstrap-1.1.30)
                                   (replace "jsc" bun-bootstrap-jsc-1.1.38)
                                   (replace "zig" zig-0.13)
                                   (replace "node-headers"
                                            %node-22.6.0-headers)
                                   (replace "node-modules"
                                            %bun-1.1.38-node-modules)
                                   (replace "clang-toolchain"
                                            clang-toolchain-16)
                                   (replace "lld" lld-16))))
                     (replace-bun-cargo-inputs (cons (list "zig-library"
                                                      %bun-zig-library-1.1.30)
                                                     (fold (lambda (entry
                                                                    result)
                                                             (modify-inputs result
                                                               (replace (string-append
                                                                         "source-"
                                                                         (car
                                                                          entry))
                                                                        (cadr
                                                                         entry))))
                                                      inputs
                                                      %bun-1.1.38-changed-sources))
                      'bun-lol-html-1.0 %bun-1.1.38-lol-html-cargo-inputs)))))

(define %bun-1.2.0-source
  (git-origin "bun" "https://github.com/oven-sh/bun"
              "b0c5a7655dac9040655a22754c5eab91046e923b"
              "1bbgzf1w5fvkvvzrjk1zl73rzzlh2q80kv3z374p027da7fifhb7"))

(define %bun-1.2.0-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "9e3b60e4a6438d20ee6f8aa5bec6b71d2b7d213f"
              "1lbs2bx6pyv61rvm4gdmhdf3yln1f7xc3kng82lcf3kgi9ixhld1"))

(define %bun-1.2.0-changed-sources
  `(("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "914b005ef3ece44159dca0ffad74eb42a9f6679f"
                   "1d9w40vbf08kci2ji70544gsqyvfsdhvslmfjqbbc3n21ci1idgb"))
    ("cares" ,(git-origin "cares" "https://github.com/c-ares/c-ares"
               "4f4912bce7374f787b10576851b687935f018e17"
               "1n209p6kihzrb9lsjbq83a9sld7hw8448095q22h4p3diaim44pb"))
    ("libarchive" ,(cadr (assoc "libarchive" %bun-1.1.38-changed-sources)))
    ("libdeflate" ,(git-origin "libdeflate"
                    "https://github.com/ebiggers/libdeflate"
                    "733848901289eca058804ca0737f8796875204c8"
                    "0f6vz5kjf8nmai48fbb4kqa3xbmfjgzj0wviv3g34xqr328ibrvf"))
    ("libuv" ,(cadr (assoc "libuv" %bun-1.1.38-changed-sources)))
    ("lolhtml" ,(git-origin "lolhtml" "https://github.com/cloudflare/lol-html"
                 "4f8becea13a0021c8b71abd2dcc5899384973b66"
                 "1951hax3fz3bc83c9jw68cj62pbq0w7896hnra0r8qdgcnrl65py"))
    ("lshpack" ,(git-origin "lshpack"
                 "https://github.com/litespeedtech/ls-hpack"
                 "32e96f10593c7cb8553cd8c9c12721100ae9e924"
                 "1xsm8jzsypjnwrrj5lfx0vqnn05sj1429qvbpwgsnyr5p3g27icq"))
    ("mimalloc" ,(cadr (assoc "mimalloc" %bun-1.1.38-changed-sources)))
    ("zstd" ,(cadr (assoc "zstd" %bun-1.1.38-changed-sources)))))

(define %bun-1.2.0-changed-refs
  '(("boringssl" . "914b005ef3ece44159dca0ffad74eb42a9f6679f")
    ("cares" . "4f4912bce7374f787b10576851b687935f018e17")
    ("libarchive" . "898dc8319355b7e985f68a9819f182aaed61b53a")
    ("libdeflate" . "733848901289eca058804ca0737f8796875204c8")
    ("libuv" . "da527d8d2a908b824def74382761566371439003")
    ("lolhtml" . "4f8becea13a0021c8b71abd2dcc5899384973b66")
    ("lshpack" . "32e96f10593c7cb8553cd8c9c12721100ae9e924")
    ("mimalloc" . "82b2c2277a4d570187c07b376557dc5bde81d848")
    ("zstd" . "794ea1b0afca0f020f4e57b6732332231fb23c70")))

(define %bun-1.2.0-node-modules
  (bun-bootstrap-node-modules "1.2.0" %bun-1.2.0-all-npm-inputs))

(define %bun-1.2.0-lol-html-cargo-inputs
  (bun-cargo-inputs 'bun-lol-html-1.2.0))

(define bun-bootstrap-jsc-1.2.0
  (package
    (inherit bun-bootstrap-jsc-1.3.1)
    (version "1.2.0")
    (source
     %bun-1.2.0-webkit-source)
    (native-inputs (list clang-toolchain-18
                         cmake-minimal
                         ninja
                         pkg-config
                         perl
                         python
                         ruby))))

(define-public bun-bootstrap-1.2.0
  (package
    (inherit bun-bootstrap-1.3.1-base)
    (version "1.2.0")
    (source
     %bun-1.2.0-source)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-1.3.1-base)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install-pinned-sources 'correct-dependency-refs
              (lambda _
                (for-each (lambda (entry)
                            (call-with-output-file (string-append "vendor/"
                                                                  (car entry)
                                                                  "/.ref")
                              (lambda (port)
                                (display (cdr entry) port))))
                          '#$%bun-1.2.0-changed-refs)))
            (add-after 'correct-dependency-refs 'fix-source-jsc-interfaces
              (lambda _
                (substitute* "cmake/tools/SetupWebKit.cmake"
                  (("      \\$\\{WEBKIT_PATH\\}/JavaScriptCore/PrivateHeaders")
                   (string-append
                    "      ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders
"
                    "      ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders/JavaScriptCore
"
                    "      ${WEBKIT_PATH}/JavaScriptCore/DerivedSources/inspector")))
                (substitute* "src/bun.js/bindings/napi.cpp"
                  (("if \\(isfinite\\(js_number\\)\\)")
                   "if (std::isfinite(js_number))"))
                (substitute* "src/bun.js/bindings/workaround-missing-symbols.cpp"
                  (("#include <features.h>")
                   "#include <features.h>
#include <sys/types.h>"))))))))
    (native-inputs (let ((inputs (modify-inputs (package-native-inputs
                                                 bun-bootstrap-1.3.1-base)
                                   (replace "bun-seed" bun-bootstrap-1.1.38)
                                   (replace "jsc" bun-bootstrap-jsc-1.2.0)
                                   (replace "zig" zig-0.13)
                                   (replace "node-headers"
                                            %node-22.6.0-headers)
                                   (replace "node-modules"
                                            %bun-1.2.0-node-modules)
                                   (replace "clang-toolchain"
                                            clang-toolchain-18)
                                   (replace "lld" lld-18))))
                     (replace-bun-cargo-inputs (cons (list "zig-library"
                                                      %bun-zig-library-1.1.30)
                                                     (fold (lambda (entry
                                                                    result)
                                                             (modify-inputs result
                                                               (replace (string-append
                                                                         "source-"
                                                                         (car
                                                                          entry))
                                                                        (cadr
                                                                         entry))))
                                                      inputs
                                                      %bun-1.2.0-changed-sources))
                      'bun-lol-html-1.2.0 %bun-1.2.0-lol-html-cargo-inputs)))))

(define %bun-1.2.17-source
  (git-origin "bun" "https://github.com/oven-sh/bun"
              "0b5363099b3a01057106b6582937c465611d539c"
              "1fh2980b2gs190bmpp47vx1gyn95wh3xf97yask2d6srjkw8arrk"))

(define %bun-1.2.17-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "397dafc9721b8f8046f9448abb6dbc14efe096d3"
              "0wylc8mmbzl1vfx3xcgxycgafp5jxh43db22f4msr7b09sw31n8d"))

(define %bun-1.2.17-zig-source
  (git-origin "zig" "https://github.com/oven-sh/zig"
              "0a0120fa92cd7f6ab244865688b351df634f0707"
              "1rzv4pj0cw3pmxdgkj8s109ifw0c7vdydkqb3pwk743df0vyk93x"))

(define bun-bootstrap-zig-1.2.17
  (package
    (inherit bun-bootstrap-zig-1.3.1)
    (version "0.14.1-bun.1.2.17")
    (source
     (origin
       (inherit %bun-1.2.17-zig-source)
       (patches (origin-patches (package-source zig-0.14)))))))

(define %bun-1.2.17-changed-sources
  `(("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "7a5d984c69b0c34c4cbb56c6812eaa5b9bef485c"
                   "1s9lfv9v4ac4nc7bdz7i16d1zhir408b8cwxl6ylv23zrwcbhp52"))
    ("hdrhistogram" ,(git-origin "hdrhistogram"
                      "https://github.com/HdrHistogram/HdrHistogram_c"
                      "652d51bcc36744fd1a6debfeb1a8a5f58b14022c"
                      "1b739vglr7pxbik0xh8jbpnb414fidk71wzwpf74c5s94fz06ra0"))
    ("highway" ,(git-origin "highway" "https://github.com/google/highway"
                 "12b325bc1793dee68ab2157995a690db859fe9e0"
                 "1a05wahdr706psva45vhqh829fxk98dcgyf6i3dg4c15angi84b0"))
    ("libarchive" ,(git-origin "libarchive"
                    "https://github.com/libarchive/libarchive"
                    "898dc8319355b7e985f68a9819f182aaed61b53a"
                    "02zrxq33793kwy9s5kxd3vcswhyl076rsd4l3xbl19qkq0lzwyxd"))
    ("libuv" ,(git-origin "libuv" "https://github.com/libuv/libuv"
               "da527d8d2a908b824def74382761566371439003"
               "1vm0xni99d3p2immmshv4sndl2b7hdrh2zqi2z2k98ccddjvrj09"))
    ("lolhtml" ,(git-origin "lolhtml" "https://github.com/cloudflare/lol-html"
                 "67f1d4ffd6b74db7e053fb129dcce620193c180d"
                 "1vfn5hdfz1bqd71n1sb2gjx681asnlxf1m80fc5aqin2p8k8387a"))))

(define %bun-1.2.17-node-modules
  (bun-bootstrap-node-modules "1.2.17" %bun-1.2.17-all-npm-inputs))

(define %bun-1.2.17-lol-html-cargo-inputs
  (bun-cargo-inputs 'bun-lol-html-1.2.17))

(define bun-bootstrap-jsc-1.2.17
  (package
    (inherit bun-bootstrap-jsc-1.3.1)
    (version "1.2.17")
    (source
     %bun-1.2.17-webkit-source)))

(define %bun-1.2.17-changed-refs
  '(("boringssl" . "7a5d984c69b0c34c4cbb56c6812eaa5b9bef485c")
    ("hdrhistogram" . "652d51bcc36744fd1a6debfeb1a8a5f58b14022c")
    ("highway" . "12b325bc1793dee68ab2157995a690db859fe9e0")
    ("libarchive" . "898dc8319355b7e985f68a9819f182aaed61b53a")
    ("libuv" . "da527d8d2a908b824def74382761566371439003")
    ("lolhtml" . "67f1d4ffd6b74db7e053fb129dcce620193c180d")))

(define-public bun-bootstrap-1.2.17
  (package
    (inherit bun-bootstrap-1.3.1-base)
    (version "1.2.17")
    (source
     %bun-1.2.17-source)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-1.3.1-base)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-after 'install-pinned-sources 'correct-dependency-refs
              (lambda _
                (for-each (lambda (entry)
                            (call-with-output-file (string-append "vendor/"
                                                                  (car entry)
                                                                  "/.ref")
                              (lambda (port)
                                (display (cdr entry) port))))
                          '#$%bun-1.2.17-changed-refs)))
            (add-after 'correct-dependency-refs 'fix-source-jsc-interfaces
              (lambda _
                (substitute* "cmake/tools/SetupWebKit.cmake"
                  (("      \\$\\{WEBKIT_PATH\\}/JavaScriptCore/PrivateHeaders")
                   (string-append
                    "      ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders
"
                    "      ${WEBKIT_PATH}/JavaScriptCore/PrivateHeaders/JavaScriptCore
"
                    "      ${WEBKIT_PATH}/JavaScriptCore/DerivedSources/inspector")))
                (substitute* "src/bun.js/bindings/napi.cpp"
                  (("if \\(isfinite\\(js_number\\)\\)")
                   "if (std::isfinite(js_number))"))
                (substitute* "src/bun.js/bindings/workaround-missing-symbols.cpp"
                  (("#include <features.h>")
                   "#include <features.h>
#include <sys/types.h>"))))
            (add-before 'build 'load-zig-build-environment-1.2.17
              (lambda _
                ;; SetupZig.cmake writes these values to .env for Bun's normal
                ;; build driver.  This stage invokes Ninja directly, so export
                ;; them explicitly for nested Zig compiler-server processes.
                (let ((cache (string-append (getcwd)
                                            "/build/release/cache/zig")))
                  (setenv "ZIG_LOCAL_CACHE_DIR"
                          (string-append cache "/local"))
                  (setenv "ZIG_GLOBAL_CACHE_DIR"
                          (string-append cache "/global")))))))))
    (native-inputs (let ((inputs (modify-inputs (package-native-inputs
                                                 bun-bootstrap-1.3.1-base)
                                   (replace "jsc" bun-bootstrap-jsc-1.2.17)
                                   (replace "zig" bun-bootstrap-zig-1.2.17)
                                   (replace "bun-seed" bun-bootstrap-1.2.0)
                                   (replace "node-headers"
                                            %node-22.6.0-headers)
                                   (replace "node-modules"
                                            %bun-1.2.17-node-modules))))
                     (replace-bun-cargo-inputs (fold (lambda (entry result)
                                                       (modify-inputs result
                                                         (replace (string-append
                                                                   "source-"
                                                                   (car entry))
                                                                  (cadr entry))))
                                                inputs
                                                %bun-1.2.17-changed-sources)
                      'bun-lol-html-1.2.17 %bun-1.2.17-lol-html-cargo-inputs)))))

(define-public bun-bootstrap-1.3.1
  (package
    (inherit bun-bootstrap-1.3.1-base)
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-1.3.1-base)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build 'record-bun-source-revision
              (lambda _
                ;; Guix git-fetch checkouts intentionally contain no .git
                ;; directory.  This generator uses the Bun checkout revision
                ;; for the bundled uWebSockets and libusockets versions, so
                ;; supply the already pinned origin commit as its fallback.
                (substitute* "cmake/tools/GenerateDependencyVersions.cmake"
                  (("set\\(BUN_GIT_SHA \"unknown\"\\)")
                   (string-append "set(BUN_GIT_SHA \""
                                  #$%bun-1.3.1-commit "\")")))
                ;; Newer C++ standard libraries expose this overload only in
                ;; namespace std; later Bun sources make the same qualified
                ;; call.
                (substitute* "src/bun.js/bindings/napi.cpp"
                  (("if \\(isfinite\\(js_number\\)\\)")
                   "if (std::isfinite(js_number))"))))
            (add-before 'build 'load-zig-build-environment
              (lambda _
                (let ((cache (string-append (getcwd)
                                            "/build/release/cache/zig")))
                  (setenv "ZIG_LOCAL_CACHE_DIR"
                          (string-append cache "/local"))
                  (setenv "ZIG_GLOBAL_CACHE_DIR"
                          (string-append cache "/global")))))))))
    (native-inputs (modify-inputs (package-native-inputs
                                   bun-bootstrap-1.3.1-base)
                     (replace "bun-seed" bun-bootstrap-1.2.17)))))

(define %bun-1.3.13-commit
  "bf2e2cecf27e800962b1e7f03d66278f9d5d2e79")

(define %bun-1.3.13-source
  (origin
    (inherit (git-origin "bun" "https://github.com/oven-sh/bun"
              %bun-1.3.13-commit
              "18vwvlinc4z2zblh6xrn14q74i8379qk4fai7wzdg41n2agcgpdh"))
    (patches (parameterize ((%patch-path (map (lambda (directory)
                                                (string-append directory
                                                 "/roquix/packages/patches"))
                                              %load-path)))
               (search-patches "bun-1.3.13-local-zig.patch")))))

(define %bun-1.3.13-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "4d5e75ebd84a14edbc7ae264245dcd77fe597c10"
              "1z3yiijpkaivsz97wgz84h3iywskrx25p2gv5z5fvwspiflmqwvf"))

(define %bun-1.3.13-zig-source
  (git-origin "zig" "https://github.com/oven-sh/zig"
              "365343af4fc5a1a632e6b54aadd0b87be30edd81"
              "1nwnnbk1map3l90mdqraz89vbgyarm70aa6ljg0j9s15kdl679y4"))

(define-public bun-bootstrap-zig-1.3.13
  (package
    (inherit zig-0.15)
    (name "bun-bootstrap-zig")
    (version "0.15.2-bun.1.3.13")
    (source
     (origin
       (inherit %bun-1.3.13-zig-source)
       ;; This fork identifies itself as Zig 0.15.2 and requires LLVM 20.
       ;; Preserve Guix's official 0.15 system-path and RUNPATH patches.
       (patches (origin-patches (package-source zig-0.15)))))
    (arguments
     (substitute-keyword-arguments (package-arguments zig-0.15)
       ((#:phases phases)
        #~(modify-phases #$phases
            (add-before 'build-zig1 'install-fork-stage3
              (lambda* (#:key outputs #:allow-other-keys)
                (let ((out (assoc-ref outputs "out")))
                  (unless (file-exists? (string-append out "/bin/zig"))
                    (mkdir-p (string-append out "/bin"))
                    (install-file "stage3/bin/zig"
                                  (string-append out "/bin")))
                  (unless (file-exists? (string-append out "/lib/zig"))
                    (mkdir-p (string-append out "/lib"))
                    (copy-recursively "stage3/lib/zig"
                                      (string-append out "/lib/zig"))))))))))
    (synopsis "Zig compiler used to build Bun 1.3.13")))

(define bun-bootstrap-jsc-1.3.13
  (package
    (inherit bun-bootstrap-jsc-1.3.1)
    (version "1.3.13")
    (source
     %bun-1.3.13-webkit-source)
    (native-inputs (list clang-toolchain-21
                         cmake-minimal
                         ninja
                         pkg-config
                         perl
                         python
                         ruby))))

(define %bun-1.3.13-changed-sources
  `(("boringssl" ,(git-origin "boringssl"
                   "https://github.com/oven-sh/boringssl"
                   "0c5fce43b7ed5eb6001487ee48ac65766f5ddcd1"
                   "00fq878mm4r9vqfy0j3ylwjxaz6y5w7f1dh7bvfw3van3ghhzfpi"))
    ("cares" ,(git-origin "cares" "https://github.com/c-ares/c-ares"
               "3ac47ee46edd8ea40370222f91613fc16c434853"
               "1z80i6bzp7svjnyx6q4fm23yg5q5rxjfm856sm9vdc1zbla70f2c"))
    ("libarchive" ,(git-origin "libarchive"
                    "https://github.com/libarchive/libarchive"
                    "ded82291ab41d5e355831b96b0e1ff49e24d8939"
                    "1i8ga2a7g99nxyz84r27m7gqb7qxjcqy3n1s0fxis9a517ql87cx"))
    ("libdeflate" ,(git-origin "libdeflate"
                    "https://github.com/ebiggers/libdeflate"
                    "c8c56a20f8f621e6a966b716b31f1dedab6a41e3"
                    "147ibdzw489xd0rzvnvqkshqqzw3js3s3bc7d7wdicw597g9af6r"))
    ("lolhtml" ,(git-origin "lolhtml" "https://github.com/cloudflare/lol-html"
                 "77127cd2b8545998756e8d64e36ee2313c4bb312"
                 "0v0hsmqdgy88m3zqbml21gcqkyp4piglq4269hbgnqp2kjgb4q66"))
    ("mimalloc" ,(git-origin "mimalloc" "https://github.com/oven-sh/mimalloc"
                  "57029fb1f193e633462e76af745599e1dbfd4b58"
                  "0p3sf763mxaia7swrxxm0p15i1h73xyfxmkhnfda0bg37bb0ddh0"))
    ("tinycc" ,(git-origin "tinycc" "https://github.com/oven-sh/tinycc"
                "12882eee073cfe5c7621bcfadf679e1372d4537b"
                "045vqw5x27sjxclaji8y0j2nkfazysqidcwg2g67vla0cbl91a99"))
    ("zlib" ,(git-origin "zlib" "https://github.com/zlib-ng/zlib-ng"
              "12731092979c6d07f42da27da673a9f6c7b13586"
              "0g4pxy7gc1slw9n6j583hzps32mml30f08gmmg1adsq4y3dl2cny"))))

(define %bun-1.3.13-node-modules
  (bun-bootstrap-node-modules "1.3.13" %bun-1.3.13-all-npm-inputs))

(define %bun-1.3.13-lol-html-cargo-inputs
  (bun-cargo-inputs 'bun-lol-html-1.3.13))

(define %bun-1.3.13-dependency-sources
  (fold (lambda (entry sources)
          (cons entry
                (remove (lambda (candidate)
                          (string=? (car candidate)
                                    (car entry))) sources)))
        %bun-1.3.1-dependency-sources %bun-1.3.13-changed-sources))

(define (make-bun-bootstrap-modern version
                                   source
                                   commit
                                   seed
                                   zig-source
                                   webkit-source
                                   node-modules
                                   cargo-inputs
                                   cargo-input-key
                                   dependency-sources)
  (package
    (inherit bun-bootstrap-1.3.1-base)
    (version version)
    (source
     source)
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:imported-modules (cons* '(roquix packages bun-bootstrap affinity)
                                '(roquix packages bun-bootstrap cargo)
                                '(roquix packages bun-bootstrap esbuild)
                                '(guix build cargo-build-system)
                                %default-gnu-imported-modules)
      #:modules (cons '(roquix packages bun-bootstrap esbuild)
                      %default-gnu-modules)
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'unpack 'install-fixed-build-inputs
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((null (open-output-file "/dev/null"))
                    (modules (assoc-ref inputs "node-modules")))
                (for-each (lambda (path)
                            (copy-recursively (string-append modules "/" path)
                                              path
                                              #:log null))
                          '("node_modules" "packages/bun-error/node_modules"
                            "src/node-fallbacks/node_modules"))
                (close-port null))
              (invoke "chmod" "-R" "u+w" ".")
              ;; npm's platform esbuild binaries were removed from the fixed
              ;; tree.  Bind their CLI locations to Guix source builds.
              (bind-bun-esbuild-tools inputs
                                      '#$%bun-bootstrap-esbuild-bindings)
              (for-each (lambda (file)
                          (unless (file-exists? file)
                            (error "lock-derived npm input is incomplete" file)))
                        '("node_modules/esbuild/package.json"
                          "packages/bun-error/node_modules/preact/package.json"
                          "src/node-fallbacks/node_modules/assert/package.json"))
              ;; The lock-derived node_modules trees are complete.  Retain the
              ;; build graph's stamps, but do not let their commands reach
              ;; the registry from the isolated build.
              (substitute* "scripts/build/codegen.ts"
                (("`cd \\$dir && \\$\\{bun\\} install --frozen-lockfile && \\$\\{touch\\} \\$stamp`")
                 "`${touch} $stamp`"))
              ;; A git-fetch origin intentionally has no .git directory, so
              ;; cfg.revision is "unknown".  UWS and usockets are in-tree at
              ;; this Bun commit; preserve their exact pinned revision in the
              ;; generated dependency version header.
              (substitute* "scripts/build/depVersionsHeader.ts"
                (("versions\\.push\\(\\[\"UWS\", cfg\\.revision\\]\\);")
                 (string-append "versions.push([\"UWS\", \""
                                #$commit "\"]);"))
                (("versions\\.push\\(\\[\"USOCKETS\", cfg\\.revision\\]\\);")
                 (string-append "versions.push([\"USOCKETS\", \""
                                #$commit "\"]);")))
              (let ((napi-source (if (file-exists? "src/jsc/bindings/napi.cpp")
                                     "src/jsc/bindings/napi.cpp"
                                     "src/bun.js/bindings/napi.cpp")))
                (substitute* napi-source
                  (("if \\(isfinite\\(js_number\\)\\)")
                   "if (std::isfinite(js_number))")))
              ;; All github-archive inputs are copied and patched below.
              ;; Treat them as local sources so the Ninja graph contains no
              ;; network fetch edge.
              (substitute* "scripts/build/source.ts"
                (("if \\(source\\.kind === \"github-archive\"\\) \\{")
                 "if (source.kind === \"github-archive\" && process.env.BUN_OFFLINE_VENDOR !== \"1\") {")
                ;; Nested builds already parallelize their own compilation.
                ;; Configure and run one dependency sub-build at a time so
                ;; several CMake processes do not compete with bun-zig.o for
                ;; memory in an isolated Guix build container.
                (("n\\.pool\\(\"dep\", 4\\);")
                 "n.pool(\"dep\", 1);")
                (("args\\.push\\(`-DBUILD_SHARED_LIBS=OFF`\\);")
                 (string-append "args.push(`-DBUILD_SHARED_LIBS=OFF`);\n"
                  "  args.push(`-DCMAKE_POLICY_VERSION_MINIMUM=3.5`);
"
                  "  args.push(`-DCMAKE_INSTALL_LIBDIR=lib`);")))
              ;; Nested CMake configure checks build and execute C++ probes.
              ;; Record the Guix libstdc++ location at link time so those
              ;; probes and generated host tools do not depend on host loader
              ;; search paths.
              (let ((gcc-lib (dirname (search-input-file inputs
                                       "/lib/libstdc++.so.6"))))
                (substitute* "scripts/build/source.ts"
                  (("-DCMAKE_EXE_LINKER_FLAGS=--ld-path=\\$\\{cfg\\.ld\\}")
                   (string-append
                    "-DCMAKE_EXE_LINKER_FLAGS=--ld-path=${cfg.ld} "
                    "-Wl,-rpath," gcc-lib))
                  (("-DCMAKE_SHARED_LINKER_FLAGS=--ld-path=\\$\\{cfg\\.ld\\}")
                   (string-append
                    "-DCMAKE_SHARED_LINKER_FLAGS=--ld-path=${cfg.ld} "
                    "-Wl,-rpath," gcc-lib))))
              ;; Embed Guix runtime paths in the original link invocation.
              ;; The finished ELF is never rewritten with patchelf.
              (let ((icu (assoc-ref inputs "icu4c"))
                    (libc (assoc-ref inputs "glibc")))
                (substitute* "scripts/build/bun.ts"
                  (("libs\\.push\\(\"-licudata\", \"-licui18n\", \"-licuuc\"\\);")
                   (string-append
                    "libs.push(\"-licudata\", \"-licui18n\", \"-licuuc\", "
                    "\"-Wl,-rpath,"
                    icu
                    "/lib\", "
                    "\"-Wl,-rpath,"
                    libc
                    "/lib\");"))))))
          (add-after 'install-fixed-build-inputs 'install-pinned-native-sources
            (lambda* (#:key inputs #:allow-other-keys)
              (let ((null (open-output-file "/dev/null")))
                (mkdir-p "vendor")
                (for-each (lambda (entry)
                            (copy-recursively (assoc-ref inputs
                                                         (string-append
                                                          "source-"
                                                          (car entry)))
                                              (string-append "vendor/"
                                                             (car entry))
                                              #:log null))
                          '#$dependency-sources)
                (copy-recursively (assoc-ref inputs "source-webkit")
                                  "vendor/WebKit"
                                  #:log null)
                (close-port null))
              (invoke "chmod" "-R" "u+w" "vendor")
              ;; fetch-cli normally applies these checked-in patches after
              ;; downloading each archive.  Apply the same patch sets to the
              ;; pinned Guix inputs before selecting offline local mode.
              (for-each (lambda (name)
                          (let ((patch-directory (string-append "patches/"
                                                                name))
                                (vendor-directory (string-append "vendor/"
                                                                 name)))
                            (when (file-exists? patch-directory)
                              (for-each (lambda (patch)
                                          (if (string-suffix? ".patch" patch)
                                              (let ((absolute-patch (canonicalize-path
                                                                     patch)))
                                                (with-directory-excursion vendor-directory
                                                  (invoke "git"
                                                   "apply"
                                                   "--ignore-whitespace"
                                                   "--ignore-space-change"
                                                   "--no-index"
                                                   "--verbose"
                                                   absolute-patch)))
                                              (copy-file patch
                                                         (string-append
                                                          vendor-directory "/"
                                                          (basename patch)))))
                                        (find-files patch-directory ".*")))))
                        (map car
                             '#$dependency-sources))
              ;; emitBun passes this legacy fetch-stamp path directly to the
              ;; Zig edge even when resolveDep selected local-source mode.
              ;; The source is already a hash-pinned Guix input, so provide a
              ;; stable local readiness stamp without re-enabling dep_fetch.
              (call-with-output-file "vendor/zstd/.ref"
                (lambda (port)
                  (display "guix-pinned-source\n" port)))
              ;; CMake 4 no longer accepts this dependency's 2.8 policy floor.
              (substitute* "vendor/lshpack/CMakeLists.txt"
                (("CMAKE_MINIMUM_REQUIRED\\(VERSION 2\\.8\\)")
                 "CMAKE_MINIMUM_REQUIRED(VERSION 3.5)"))
              ;; BUN_ZIG_PATH expects a directory containing zig and lib/.
              (mkdir-p "vendor/zig")
              (symlink (search-input-file inputs "/bin/zig") "vendor/zig/zig")
              (symlink (string-append (assoc-ref inputs "zig") "/lib/zig")
                       "vendor/zig/lib")
              ;; Pre-populate the build driver's fixed Node header cache and
              ;; identity stamp so its prebuilt fetch command is a no-op.
              (let ((node "build/cache/nodejs-headers-24.3.0"))
                (mkdir-p node)
                (invoke "tar"
                        "-xf"
                        (assoc-ref inputs "node-headers")
                        "--strip-components=1"
                        "-C"
                        node)
                (for-each (lambda (path)
                            (when (file-exists? path)
                              (if (file-is-directory? path)
                                  (delete-file-recursively path)
                                  (delete-file path))))
                          (map (lambda (path)
                                 (string-append node "/" path))
                               '("include/node/openssl" "include/node/uv"
                                 "include/node/uv.h")))
                (call-with-output-file (string-append node "/.identity")
                  (lambda (port)
                    (display "24.3.0\n" port))))
              ;; Cargo consumes only the fixed lol-html crate closure.
              (setenv "HOME"
                      (string-append (getcwd) "/.home"))
              (setenv "CARGO_HOME"
                      (string-append (getcwd) "/.cargo"))
              (mkdir-p (getenv "HOME"))
              (mkdir-p (getenv "CARGO_HOME"))
              (use-modules (roquix packages bun-bootstrap cargo))
              (install-bun-cargo-vendor #:source (assoc-ref inputs "source")
                                        #:inputs inputs
                                        #:checksums (assoc-ref inputs
                                                     "lol-html-cargo-checksums")
                                        #:vendor-dir ".cargo/vendor")
              (call-with-output-file ".cargo/config.toml"
                (lambda (port)
                  (format port
                   "[source.crates-io]~%replace-with = \"vendored-sources\"~%~%[source.vendored-sources]~%directory = \"~a/.cargo/vendor\"~%~%[net]~%offline = true~%"
                   (getcwd))))))
          (delete 'configure)
          (replace 'build
            (lambda* (#:key inputs #:allow-other-keys)
              (use-modules (roquix packages bun-bootstrap affinity))
              (let* ((seed (search-input-file inputs "/bin/bun"))
                    ;; bun-zig.o alone reaches roughly 8 GiB RSS.  Four C++
                    ;; jobs leave enough headroom for Clang and nested builds
                    ;; while still using parallel compilation.
                    (job-count (min 4 (parallel-job-count)))
                    (jobs (number->string job-count)))
                (setenv "CC"
                        (search-input-file inputs "/bin/clang"))
                (setenv "CXX"
                        (search-input-file inputs "/bin/clang++"))
                (setenv "AR"
                        (search-input-file inputs "/bin/llvm-ar"))
                (setenv "RANLIB"
                        (search-input-file inputs "/bin/llvm-ranlib"))
                ;; Source origins with a top-level include/ directory are
                ;; explicit vendor inputs, not global system headers.  In
                ;; particular, TinyCC's stddef.h must not shadow libc while
                ;; nested C++ projects run compiler feature checks.
                (letrec ((source-path? (lambda (path entries)
                                         (and (pair? entries)
                                              (let ((entry (car entries)))
                                                (or (and (string-prefix?
                                                          "source-"
                                                          (car entry))
                                                         (string-prefix? (cdr
                                                                          entry)
                                                                         path))
                                                    (source-path? path
                                                                  (cdr entries)))))))
                         (remove-source-paths (lambda (paths)
                                                (cond
                                                  ((null? paths)
                                                   '())
                                                  ((source-path? (car paths)
                                                                 inputs)
                                                   (remove-source-paths (cdr
                                                                         paths)))
                                                  (else (cons (car paths)
                                                              (remove-source-paths
                                                               (cdr paths)))))))
                         (join-paths (lambda (paths)
                                       (cond
                                         ((null? paths)
                                          "")
                                         ((null? (cdr paths))
                                          (car paths))
                                         (else (string-append (car paths) ":"
                                                              (join-paths (cdr
                                                                           paths))))))))
                  (for-each (lambda (variable)
                              (let ((value (getenv variable)))
                                (when value
                                  (setenv variable
                                          (join-paths (remove-source-paths (string-split
                                                                            value
                                                                            #\:)))))))
                            '("CPATH" "C_INCLUDE_PATH" "CPLUS_INCLUDE_PATH"
                              "OBJC_INCLUDE_PATH")))
                (setenv "BUN_ZIG_PATH"
                        (string-append (getcwd) "/vendor/zig"))
                (setenv "BUN_WEBKIT_PATH"
                        (string-append (getcwd) "/vendor/WebKit"))
                (setenv "BUN_OFFLINE_VENDOR" "1")
                (setenv "CMAKE_BUILD_PARALLEL_LEVEL" jobs)
                (call-with-limited-cpu-affinity
                 job-count
                 (lambda ()
                   ;; Configure and build BoringSSL first.  Besides surfacing
                   ;; toolchain probe failures before the long Zig edge, the
                   ;; default build below reuses this Ninja output unchanged.
                   (invoke seed
                           "scripts/build.ts"
                           "--profile=release-local"
                           "--baseline=true"
                           "--build-dir=build/release-local"
                           "--cache-dir=build/cache"
                           "--target=boringssl"
                           (string-append "-j" jobs))
                   ;; Likewise configure WebKit before starting the expensive
                   ;; Zig compilation.  Building this cache target separately
                   ;; also keeps CMake diagnostics from being interleaved with
                   ;; unrelated parallel Ninja edges.
                   (invoke "ninja" "-C" "build/release-local"
                           "deps/WebKit/CMakeCache.txt"
                           (string-append "-j" jobs))
                   (invoke seed
                           "scripts/build.ts"
                           "--profile=release-local"
                           "--baseline=true"
                           "--build-dir=build/release-local"
                           "--cache-dir=build/cache"
                           (string-append "-j" jobs)))))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let ((bin (string-append (assoc-ref outputs "out") "/bin")))
                (mkdir-p bin)
                (install-file "build/release-local/bun" bin)
                (chmod (string-append bin "/bun") #o555)
                (symlink "bun"
                         (string-append bin "/bunx")))))
          (add-after 'install 'check-bootstrap
            (lambda* (#:key outputs inputs #:allow-other-keys)
              (use-modules (ice-9 popen)
                           (ice-9 textual-ports))
              (let* ((bun (string-append (assoc-ref outputs "out") "/bin/bun"))
                     (readelf (search-input-file inputs "/bin/readelf"))
                     (port (open-pipe* OPEN_READ readelf "-dW" bun))
                     (dynamic (get-string-all port))
                     (status (close-pipe port)))
                (unless (zero? status)
                  (error "readelf failed while checking Bun"))
                (invoke bun "--version")
                (invoke bun "-e"
                 "console.log('source-bootstrap-ok', process.versions.bun)")
                (unless (string-contains dynamic
                                         (assoc-ref inputs "icu4c"))
                  (error "Bun RUNPATH does not contain the Guix ICU input"))
                (when (or (string-contains dynamic "/usr")
                          (string-contains dynamic "/lib64"))
                  (error "host path present in Bun dynamic metadata"))))))))
    (native-inputs (append `(("bun-seed" ,seed)
                             ("zig" ,zig-source)
                             ("source-webkit" ,webkit-source)
                             ("node-modules" ,node-modules)
                             ("esbuild" ,esbuild)
                             ("esbuild-node-fallbacks" ,esbuild-0.14.54)
                             ("node-headers" ,%node-24.3.0-headers)
                             ("lol-html-cargo-checksums"
                              ,(bun-cargo-checksums-input cargo-input-key
                                                         cargo-inputs))
                             ("clang-toolchain" ,clang-toolchain-21)
                             ("gcc-lib" ,gcc-14 "lib")
                             ("lld" ,lld-21)
                             ("cmake" ,cmake-minimal)
                             ("ninja" ,ninja)
                             ("pkg-config" ,pkg-config)
                             ("python" ,python)
                             ("ruby" ,ruby)
                             ("perl" ,perl)
                             ("git" ,git-minimal)
                             ("ripgrep" ,ripgrep)
                             ("rust" ,rust)
                             ("cargo" ,rust "cargo")
                             ("tar" ,tar)
                             ("binutils" ,binutils))
                           (map (lambda (entry)
                                  (list (string-append "source-"
                                                       (car entry))
                                        (cadr entry))) dependency-sources)
                           (bun-cargo-input-tuples cargo-inputs)))
    (inputs (list icu4c glibc))))

(define-public bun-bootstrap-1.3.13
  (make-bun-bootstrap-modern "1.3.13"
                             %bun-1.3.13-source
                             %bun-1.3.13-commit
                             bun-bootstrap-1.3.1
                             bun-bootstrap-zig-1.3.13
                             %bun-1.3.13-webkit-source
                             %bun-1.3.13-node-modules
                             %bun-1.3.13-lol-html-cargo-inputs
                             'bun-lol-html-1.3.13
                             %bun-1.3.13-dependency-sources))

(define %bun-1.3.14-commit
  "0d9b296af33f2b851fcbf4df3e9ec89751734ba4")

(define %bun-1.3.14-source
  (origin
    (inherit (git-origin "bun" "https://github.com/oven-sh/bun"
              %bun-1.3.14-commit
              "0zrjhig60bs81177hv35g65nfi1lbirbl3380s4k0j48hdbc27pv"))
    ;; Backport upstream PR #31024.  patchelf can add a writable PT_LOAD
    ;; before Bun's original segment; Bun must extend the segment containing
    ;; .bun rather than assuming the first writable segment is the right one.
    ;; https://github.com/oven-sh/bun/issues/31023
    ;; https://github.com/oven-sh/bun/pull/31024
    (patches (parameterize ((%patch-path (map (lambda (directory)
                                                (string-append directory
                                                 "/roquix/packages/patches"))
                                              %load-path)))
               (search-patches "bun-1.3.14-fix-patchelf-writable-load.patch")))))

(define %bun-1.3.14-webkit-source
  (git-origin "bun-webkit" "https://github.com/oven-sh/WebKit"
              "5488984d20e0dbfe4be2c3ba8fb18eb81a5e0e8b"
              "1jiq472d33izspikg67c88lirq67p15c5hwmxgq789h5jdpl4p64"))

(define %bun-1.3.14-zig-source
  (git-origin "zig" "https://github.com/oven-sh/zig"
              "04e7f6ac1e009525bc00934f20199c68f04e0a24"
              "00x1xf66s8jl6wpv9hlgcixfy6czsfrqk6py8gwgkqxbmj4cg3sv"))

(define-public bun-bootstrap-zig-1.3.14
  (package
    (inherit bun-bootstrap-zig-1.3.13)
    (version "0.15.2-bun.1.3.14")
    (source
     (origin
       (inherit %bun-1.3.14-zig-source)
       (patches (origin-patches (package-source zig-0.15)))))
    (arguments
     (substitute-keyword-arguments (package-arguments bun-bootstrap-zig-1.3.13)
       ((#:phases phases)
        #~(modify-phases #$phases
            ;; Guix uses these two phases only to export zig1.wasm for the
            ;; next package in its generic Zig bootstrap chain.  This Bun
            ;; fork intentionally cannot compile itself for wasm32-wasi;
            ;; Bun consumes the already source-built and tested stage3 ELF.
            (delete 'build-zig1)
            (delete 'install-zig1)))))
    (synopsis "Zig compiler used to build Bun 1.3.14")))

(define %bun-1.3.14-changed-sources
  `(("highway" ,(git-origin "highway" "https://github.com/google/highway"
                 "2607d3b5b0113992fe84d3848859eae13b3b52c1"
                 "043mmwkhrq1i5j2v1230rnhgmq3i85hdwcq2iwrzfzcbs8xijik1"))
    ("libuv" ,(git-origin "libuv" "https://github.com/oven-sh/libuv"
               "4dcfac4780d394e0dc2d3fb30335ca01b553eb46"
               "0ggr3zaih63w1s0r0rdhgqm565xys0k0r1r07g3n008l5mc2bfb9"))
    ("mimalloc" ,(git-origin "mimalloc" "https://github.com/oven-sh/mimalloc"
                  "f15aecb94fc8096008bf87b90c53ed682026914a"
                  "1wc5qfpw90w92ip0c6h97xf6vpspf7h2d8h6l9fa6sj3djijb8c2"))
    ("libjpeg-turbo" ,(git-origin "libjpeg-turbo"
                       "https://github.com/libjpeg-turbo/libjpeg-turbo"
                       "e352b02f794f701407b39af08576035ba3360d60"
                       "0klzz3p8r4c3cwvkb5py788d1mss296axbjm76nmw6hvrhxv14lv"))
    ("libspng" ,(git-origin "libspng" "https://github.com/randy408/libspng"
                 "fb768002d4288590083a476af628e51c3f1d47cd"
                 "116gq9dss1b08ah4qhv224j6ic665r984b7mh4c9cm0a04ynw906"))
    ("libwebp" ,(git-origin "libwebp" "https://github.com/webmproject/libwebp"
                 "b7e29b9d75bd31422b00c2a446d49d7af06c328d"
                 "112h1rfqzjr3ml1iycs3pxaz5cc0jy8z03vha69db5pm2x3aq187"))
    ("lsqpack" ,(git-origin "lsqpack"
                 "https://github.com/litespeedtech/ls-qpack"
                 "1e9c5b8e59f8161c54f168a570c8bfdc59ded0c3"
                 "1gipc7lvxxj8wnzbx4mrw4c78x78qf9j6k4j4pnfsanvin219vmi"))
    ("lsquic" ,(git-origin "lsquic" "https://github.com/litespeedtech/lsquic"
                "3181911301b1aa4f54c1ed690901abc674ee08fb"
                "1ngh34ajbzylhcyg32v16vf59ywadly7h29mzssha2bmf3g1z3sm"))))

(define %bun-1.3.14-dependency-sources
  (fold (lambda (entry sources)
          (cons entry
                (remove (lambda (candidate)
                          (string=? (car candidate)
                                    (car entry))) sources)))
        %bun-1.3.13-dependency-sources %bun-1.3.14-changed-sources))

(define %bun-1.3.14-node-modules
  (bun-bootstrap-node-modules "1.3.14" %bun-1.3.14-all-npm-inputs))

(define (make-bun-bootstrap-1.3.14 seed)
  (let ((base (make-bun-bootstrap-modern "1.3.14"
                                         %bun-1.3.14-source
                                         %bun-1.3.14-commit
                                         seed
                                         bun-bootstrap-zig-1.3.14
                                         %bun-1.3.14-webkit-source
                                         %bun-1.3.14-node-modules
                                         %bun-1.3.13-lol-html-cargo-inputs
                                         'bun-lol-html-1.3.13
                                         %bun-1.3.14-dependency-sources)))
    (package
      (inherit base)
      (arguments
       (substitute-keyword-arguments (package-arguments base)
         ((#:phases phases)
          #~(modify-phases #$phases
              (add-after 'install-fixed-build-inputs 'use-stable-cargo
                (lambda _
                  ;; Upstream rebuilds Rust std with nightly-only
                  ;; -Zbuild-std and panic=immediate-abort merely to reduce
                  ;; the final archive size.  Guix provides a fixed stable
                  ;; Rust toolchain; retain panic=abort and build the same
                  ;; pinned lol-html crate against its packaged std.
                  (substitute* "scripts/build/deps/lolhtml.ts"
                    (("if \\(cfg\\.release && canBuildStdImmediateAbort\\) \\{")
                     "if (false && cfg.release && canBuildStdImmediateAbort) {"))))
              (add-after 'check-bootstrap 'check-patchelf-regression
                (lambda* (#:key inputs outputs #:allow-other-keys)
                  (let* ((bun (string-append (assoc-ref outputs "out")
                                             "/bin/bun"))
                         (patchelf (search-input-file inputs "/bin/patchelf"))
                         (patched "patched-bun")
                         (source "patchelf-compile-check.ts")
                         (compiled "patchelf-compile-check")
                         (runpath (string-append (assoc-ref inputs "icu4c")
                                                 "/lib:"
                                                 (assoc-ref inputs "glibc")
                                                 "/lib:/tmp/"
                                                 (make-string 256 #\x))))
                    (copy-file bun patched)
                    (chmod patched #o755)
                    ;; Force patchelf to relocate dynamic metadata and add a
                    ;; writable PT_LOAD.  This directly exercises #31023.
                    (invoke patchelf "--set-rpath" runpath patched)
                    (call-with-output-file source
                      (lambda (port)
                        (display "console.log('patchelf-compile-ok')\n" port)))
                    (invoke (string-append (getcwd) "/" patched)
                            "build"
                            "--compile"
                            source
                            "--outfile"
                            compiled)
                    (invoke (string-append (getcwd) "/" compiled)))))))))
      (native-inputs (modify-inputs (package-native-inputs base)
                       (append patchelf))))))

(define-public bun-bootstrap-1.3.14
  (package
    (inherit (make-bun-bootstrap-1.3.14 bun-bootstrap-1.3.13))
    (name "bun")))

(define-public bun-bootstrap-1.3.14-self-rebuild
  (package
    (inherit (make-bun-bootstrap-1.3.14 bun-bootstrap-1.3.14))
    (name "bun-bootstrap-self-rebuild")))
