(define-module (roquix packages bun)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module (guix records)
  #:use-module (guix utils)
  #:use-module (guix build-system copy)
  #:use-module (guix build-system gnu)
  #:use-module (gnu packages)
  #:use-module (gnu packages base)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages build-tools)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages elf)
  #:use-module (gnu packages icu4c)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages node)
  #:use-module (gnu packages nss)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages python)
  #:use-module (gnu packages ruby)
  #:use-module (gnu packages rust)
  #:use-module (gnu packages version-control)
  #:use-module (gnu packages zig))

(define %bun-version "1.3.14")
(define %bun-commit
  "0d9b296af33f2b851fcbf4df3e9ec89751734ba4")
(define %bun-webkit-commit
  "5488984d20e0dbfe4be2c3ba8fb18eb81a5e0e8b")
(define %bun-zig-commit
  "04e7f6ac1e009525bc00934f20199c68f04e0a24")

(define %bun-aarch64?
  (string=? (%current-system) "aarch64-linux"))

(define %bun-loader
  (if %bun-aarch64?
      "ld-linux-aarch64.so.1"
      "ld-linux-x86-64.so.2"))

(define %bun-source
  (origin
    (method git-fetch)
    (uri (git-reference
          (url "https://github.com/oven-sh/bun")
          (commit %bun-commit)))
    (file-name (git-file-name "bun" %bun-version))
    (patches
     (parameterize
         ((%patch-path
           (map (lambda (directory)
                  (string-append directory "/roquix/packages/patches"))
                %load-path)))
       (search-patches "bun-1.3.14-fix-patchelf-writable-load.patch")))
    (sha256
     (base32 "0zrjhig60bs81177hv35g65nfi1lbirbl3380s4k0j48hdbc27pv"))))

(define-record-type* <bun-webkit-reference>
  bun-webkit-reference make-bun-webkit-reference
  bun-webkit-reference?
  (url bun-webkit-reference-url)
  (commit bun-webkit-reference-commit))

(define* (bun-webkit-fetch ref hash-algo hash
                           #:optional name
                           #:key (system (%current-system))
                           #:allow-other-keys)
  "Fetch the JSC-only subset of Bun's pinned WebKit fork."
  (let ((url (bun-webkit-reference-url ref))
        (commit (bun-webkit-reference-commit ref)))
    (with-imported-modules '((guix build utils))
      (gexp->derivation
       (or name "bun-webkit")
       #~(begin
           (use-modules (guix build utils))
           (setenv "PATH"
                   (string-append #+bash-minimal "/bin:"
                                  #+coreutils "/bin:"
                                  #+git-minimal "/bin"))
           (setenv "SSL_CERT_FILE"
                   (string-append #$nss-certs-for-test
                                  "/etc/ssl/certs/ca-certificates.crt"))
           (invoke "git" "init" "source")
           (with-directory-excursion "source"
             (invoke "git" "remote" "add" "origin" #$url)
             (invoke "git" "sparse-checkout" "init" "--cone")
             (invoke "git" "sparse-checkout" "set"
                     "Configurations" "Source" "Tools/Scripts"
                     "Tools/TestWebKitAPI")
             (invoke "git" "fetch" "--depth=1" "--filter=blob:none"
                     "origin" #$commit)
             (invoke "git" "checkout" "--detach" "FETCH_HEAD")
             (delete-file-recursively ".git"))
           (copy-recursively "source" #$output))
       #:system system
       #:hash-algo hash-algo
       #:hash hash
       #:recursive? #t
       #:local-build? #t
       #:leaked-env-vars '("http_proxy" "https_proxy" "HTTP_PROXY"
                           "HTTPS_PROXY" "no_proxy" "NO_PROXY")))))

(define %bun-webkit-source
  (origin
    (method bun-webkit-fetch)
    (uri (bun-webkit-reference
          (url "https://github.com/oven-sh/WebKit")
          (commit %bun-webkit-commit)))
    (file-name (git-file-name "bun-webkit" %bun-webkit-commit))
    (sha256
     (base32 "10fls25277bg675996z1g80s467phx8ncln6bacl2dsc70gv6pgz"))))

;; Bun carries compiler changes that are not part of upstream Zig 0.15.2.
;; Build that pinned fork through Guix's source bootstrap chain instead of
;; using the prebuilt compiler archive downloaded by Bun's build scripts.
(define bun-zig
  (package
    (inherit zig-0.15)
    (name "bun-zig")
    (version (git-version "0.15.2-bun" "0" %bun-zig-commit))
    (source
     (origin
       (inherit (package-source zig-0.15))
       (uri (git-reference
             (url "https://github.com/oven-sh/zig")
             (commit %bun-zig-commit)))
       (file-name (git-file-name "bun-zig" %bun-zig-commit))
       (sha256
        (base32 "00x1xf66s8jl6wpv9hlgcixfy6czsfrqk6py8gwgkqxbmj4cg3sv"))))
    (arguments
     (substitute-keyword-arguments (package-arguments zig-0.15)
       ((#:tests? _ #t) #f)
       ((#:phases phases '%standard-phases)
        #~(modify-phases #$phases
            ;; The public Bun compiler is already installed at this point.
            ;; These inherited phases only rebuild and export zig1.wasm for
            ;; the next step in Guix's Zig bootstrap chain; Bun neither uses
            ;; nor installs that secondary output.
            (delete 'build-zig1)
            (delete 'install-zig1)))))
    (home-page "https://github.com/oven-sh/zig")
    (synopsis "Bun's pinned Zig compiler fork")))

(define %bun-bootstrap-archive
  (if %bun-aarch64?
      "bun-linux-aarch64.zip"
      "bun-linux-x64-baseline.zip"))

(define %bun-bootstrap-hash
  (if %bun-aarch64?
      "0fwsl5rijcv53j17rhw8ig8xia3zw656cvqdds1pa0rim1iznzx2"
      "1iz66qxxfr9xx3f0557vx2ydlggdrv3bv6wk23554y4bw2590qx0"))

;; Bun's source generator uses Bun-specific APIs.  This stage0 seed breaks the
;; self-hosting cycle only; the public package below installs the executable
;; compiled from %bun-source and never copies this binary to its output.
(define bun-bootstrap
  (package
    (name "bun-bootstrap")
    (version %bun-version)
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "https://github.com/oven-sh/bun/releases/download/bun-v"
             %bun-version "/" %bun-bootstrap-archive))
       (sha256 (base32 %bun-bootstrap-hash))))
    (build-system copy-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (arguments
     (list
      #:install-plan #~'(("bun" "libexec/bun/bun"))
      #:strip-binaries? #f
      ;; This private, upstream-provided seed predates the source backport of
      ;; PR #31024 and cannot safely be resized by patchelf.  It is never
      ;; copied to the public output.  A shorter build-only interpreter is
      ;; written in place without adding or reordering PT_LOAD segments.
      #:validate-runpath? #f
      #:phases
      #~(modify-phases %standard-phases
          (add-after 'install 'set-bootstrap-interpreter
            (lambda* (#:key inputs outputs #:allow-other-keys)
              ;; `patchelf --set-interpreter` fits /tmp/bun-ld.so into the
              ;; existing .interp section (15 bytes versus the original 28)
              ;; and therefore leaves every PT_LOAD offset/size unchanged.
              ;; --no-sort additionally preserves program-header order.  The
              ;; public Bun receives upstream PR #31024's general fix instead.
              ;; See bun-elf-investigation.md and:
              ;; https://github.com/oven-sh/bun/issues/31023
              ;; https://github.com/NixOS/patchelf/blob/0.18.0/README.md
              (let ((file (string-append (assoc-ref outputs "out")
                                         "/libexec/bun/bun"))
                    (patchelf (string-append (assoc-ref inputs "patchelf")
                                             "/bin/patchelf")))
                (invoke patchelf "--no-sort" "--set-interpreter"
                        "/tmp/bun-ld.so" file)))))))
    (native-inputs (list patchelf unzip))
    (home-page "https://bun.sh/")
    (synopsis "Stage0 Bun seed for source builds")
    (description
     "Private stage0 seed used only to run Bun's self-hosted source generators.")
    (license license:expat)))

(define-record-type* <bun-node-modules-reference>
  bun-node-modules-reference make-bun-node-modules-reference
  bun-node-modules-reference?
  (source bun-node-modules-reference-source)
  (bun bun-node-modules-reference-bun))

(define* (bun-node-modules-fetch ref hash-algo hash
                                 #:optional name
                                 #:key (system (%current-system))
                                 #:allow-other-keys)
  "Return a fixed-output derivation containing Bun's build-time node_modules."
  (let ((source (bun-node-modules-reference-source ref))
        (bootstrap (bun-node-modules-reference-bun ref)))
    (with-imported-modules '((guix build utils))
      (gexp->derivation
       (or name "bun-node-modules")
       #~(begin
           (use-modules (guix build utils))
           (setenv "PATH"
                   (string-append #+bash-minimal "/bin:"
                                  #+coreutils "/bin:"
                                  #+findutils "/bin"))
           (setenv "SSL_CERT_FILE"
                   (string-append #$nss-certs-for-test
                                  "/etc/ssl/certs/ca-certificates.crt"))
           (setenv "CARGO_HTTP_CAINFO" (getenv "SSL_CERT_FILE"))
           (setenv "HOME" (string-append (getcwd) "/.home"))
           (setenv "XDG_CACHE_HOME" (string-append (getcwd) "/.cache"))
           (setenv "BUN_INSTALL_CACHE_DIR"
                   (string-append (getcwd) "/.bun-cache"))
           (false-if-exception (delete-file "/tmp/bun-ld.so"))
           (symlink #$(file-append glibc "/lib/" %bun-loader)
                    "/tmp/bun-ld.so")
           (mkdir-p (getenv "HOME"))
           (copy-recursively #+source "source")
           (with-directory-excursion "source"
             (invoke #$(file-append coreutils "/bin/chmod")
                     "-R" "u+w" ".")
             (for-each
              (lambda (directory)
                (with-directory-excursion directory
                  (invoke #$(file-append bootstrap "/libexec/bun/bun")
                          "install" "--frozen-lockfile" "--ignore-scripts"
                          "--no-progress")))
              '("." "packages/bun-error" "src/node-fallbacks"))
             (mkdir-p #$output)
             (invoke #$(file-append findutils "/bin/find")
                     "." "-type" "d" "-name" "node_modules"
                     "-exec" #$(file-append coreutils "/bin/cp")
                     "-R" "--parents" "{}" #$output ";")))
       #:system system
       #:hash-algo hash-algo
       #:hash hash
       #:recursive? #t
       #:local-build? #t
       #:leaked-env-vars '("http_proxy" "https_proxy" "HTTP_PROXY"
                           "HTTPS_PROXY" "no_proxy" "NO_PROXY")))))

(define %bun-node-modules
  (origin
    (method bun-node-modules-fetch)
    (uri (bun-node-modules-reference
          (source %bun-source)
          (bun bun-bootstrap)))
    (file-name (string-append "bun-node-modules-" %bun-version))
    (sha256
     (base32 "107kq7v0fk0rgqhaz28cdwc7mqxdjr44cllfcan339wimjvcw492"))))

(define (bun-archive name url hash key)
  (list name url key
        (origin
          (method url-fetch)
          (uri url)
          (file-name (string-append "bun-" name ".tar.gz"))
          (sha256 (base32 hash)))))

;; Raw archives are supplied through upstream's content-addressed prefetch
;; directory.  Upstream still performs its normal extraction and patching,
;; but cannot access the network inside the Guix build container.
(define %bun-dependency-archives
  (list
   (bun-archive "boringssl" "https://github.com/oven-sh/boringssl/archive/0c5fce43b7ed5eb6001487ee48ac65766f5ddcd1.tar.gz" "1f4ribbl90xf65ljgalyhj4p9ikzbyzc0a3lgdlhbwgy0p8v2554" "5e15ff95948095748fb85d4697e511b4")
   (bun-archive "brotli" "https://github.com/google/brotli/archive/v1.1.0.tar.gz" "1zqkxacqb89pi1vzdvcplfmqyfgmf4bkfrfi98zq12s2575ac877" "723494d4c3a9902a1edf3613ad3d0cdb")
   (bun-archive "cares" "https://github.com/c-ares/c-ares/archive/3ac47ee46edd8ea40370222f91613fc16c434853.tar.gz" "1f74lb8d4z07vy7zi9pg579qfqkkgsglvnl7wi24mbk6ndn1354c" "4e43539b43c0f4aea018742c50ab0561")
   (bun-archive "hdrhistogram" "https://github.com/HdrHistogram/HdrHistogram_c/archive/be60a9987ee48d0abf0d7b6a175bad8d6c1585d1.tar.gz" "1jfzbiiiigc6h7v8amzca7wx5mdayq58i206wnnpafihwmd5w741" "97084f213075a65efe2e2346b2ee6c5c")
   (bun-archive "highway" "https://github.com/google/highway/archive/2607d3b5b0113992fe84d3848859eae13b3b52c1.tar.gz" "098cjkvvl3yr38x05s3w4chi7q5s9yciz3yspq3f9cz0h5bp07bl" "b2dcc6002e95cc474624da9a4aaea204")
   (bun-archive "libarchive" "https://github.com/libarchive/libarchive/archive/ded82291ab41d5e355831b96b0e1ff49e24d8939.tar.gz" "18hx3g8nv15qj8svzg84pny4ksc0s27a7w8hpbwky1j7f7z0wbq4" "4296b191210d6b1b3f6c85bbce59eddf")
   (bun-archive "libdeflate" "https://github.com/ebiggers/libdeflate/archive/c8c56a20f8f621e6a966b716b31f1dedab6a41e3.tar.gz" "10ga3mkfiabhjwibis1zqn5kqzjhixcf7jc9idfj9qgkvdmw0p0y" "ce0e2d9805b30dcc2686113111c1dfba")
   (bun-archive "libjpeg-turbo" "https://github.com/libjpeg-turbo/libjpeg-turbo/archive/e352b02f794f701407b39af08576035ba3360d60.tar.gz" "1w3bg6sxz1cq70p43179jbjlicpns922kfbliywfly0c76a3l3s4" "297099166a01f75e9a0caaa17f7b74f3")
   (bun-archive "libspng" "https://github.com/randy408/libspng/archive/fb768002d4288590083a476af628e51c3f1d47cd.tar.gz" "0spqmdki9jjp9vdjz31fikgmm1xkyczk4s77d45pa2npj0r82mnn" "e6aca86c593b51adc54a86edcb58b3ce")
   (bun-archive "libuv" "https://github.com/oven-sh/libuv/archive/4dcfac4780d394e0dc2d3fb30335ca01b553eb46.tar.gz" "0n8gnfyf6lvp67qih81bz8r512mc1w0f7hkixvg98r19vyrjcrib" "3174c684f27ae5473e3f68be478c60f8")
   (bun-archive "libwebp" "https://github.com/webmproject/libwebp/archive/b7e29b9d75bd31422b00c2a446d49d7af06c328d.tar.gz" "1dmj8p4kg95lqay2zx0f3c0b9f0r5s1wz8ncn0didwjg8ns8kyvn" "2ced709f169b40bd84b3e0dc2765aff8")
   (bun-archive "lolhtml" "https://github.com/cloudflare/lol-html/archive/77127cd2b8545998756e8d64e36ee2313c4bb312.tar.gz" "0ygkkcn6rjsjj76a2609kwcvinfmmzdzvsn4rydajgv3vwg1clrc" "929339b1d898e66b532d6b7085573adb")
   (bun-archive "lshpack" "https://github.com/litespeedtech/ls-hpack/archive/8905c024b6d052f083a3d11d0a169b3c2735c8a1.tar.gz" "0wzr1q9yzmjisvrm5nxsxq8157ji70wx5awfyd1mbcdi3f8bzn07" "73e0c55d12ea4fc2665ba0e3b1461100")
   (bun-archive "lsqpack" "https://github.com/litespeedtech/ls-qpack/archive/1e9c5b8e59f8161c54f168a570c8bfdc59ded0c3.tar.gz" "0bfcpfp04zi9qxrivh5bgda1f7bwrlm1wlm912cmpqy1nzjspn79" "ceeb8e315778b9385bcaa3d3cd60390b")
   (bun-archive "lsquic" "https://github.com/litespeedtech/lsquic/archive/3181911301b1aa4f54c1ed690901abc674ee08fb.tar.gz" "0d8p8v692j58kcfncnz31db8460ddicvyqriqabibfby6bxr1jzq" "d3ef6cf1fbedd7f9d706da665bc05f6b")
   (bun-archive "mimalloc" "https://github.com/oven-sh/mimalloc/archive/f15aecb94fc8096008bf87b90c53ed682026914a.tar.gz" "1z3p8ajpi749k6xqxflb5x1fksiwyzhsfdky7ga2rf0nbwqpz2yr" "4a1c4f1f45e31b88abdaba5a116c17e5")
   (bun-archive "picohttpparser" "https://github.com/h2o/picohttpparser/archive/066d2b1e9ab820703db0837a7255d92d30f0c9f5.tar.gz" "1vi32dfgzzrmz6mcxjjgfpaaizpjbhykkp5mll2pwzswdymz4zv3" "fad59b16ad4752cc63c8a23339da36f5")
   (bun-archive "tinycc" "https://github.com/oven-sh/tinycc/archive/12882eee073cfe5c7621bcfadf679e1372d4537b.tar.gz" "1aphjvnck3ckw4ixnpkx6wscsk81j9m2p3kfqnchmadzrdglhl3b" "2f1f629056328c7bb07dbad712b887e9")
   (bun-archive "zlib" "https://github.com/zlib-ng/zlib-ng/archive/12731092979c6d07f42da27da673a9f6c7b13586.tar.gz" "1mp8j9fvxiz3g5msixwv8svjxyr76ff3lmd1jfkmcjy84b8sblm0" "655c6ecdb6fc9cd5621eb37cad3758da")
   (bun-archive "zstd" "https://github.com/facebook/zstd/archive/f8745da6ff1ad1e7bab384bd1f9d742439278e99.tar.gz" "0b55bvl4jn3lzl03llfjq2sga3skjmrz4d9w22wn2pmjrzqd22sb" "e010993a240724688a560d14f80491f4")
   (bun-archive "nodejs-headers" "https://nodejs.org/dist/v24.3.0/node-v24.3.0-headers.tar.gz" "01yx2n8qxf09xp8f70f5wbgxx17plwxsdhgqcznb0pfdfzs9nph4" "d79d5920ee9b0fc1a5884f2886724b69")))

(define (bun-dependency-source name)
  (let loop ((archives %bun-dependency-archives))
    (if (null? archives)
        (error "unknown Bun dependency" name)
        (let ((entry (car archives)))
          (if (string=? name (car entry))
              (cadddr entry)
              (loop (cdr archives)))))))

(define-record-type* <bun-rust-vendor-reference>
  bun-rust-vendor-reference make-bun-rust-vendor-reference
  bun-rust-vendor-reference?
  (source bun-rust-vendor-reference-source))

(define* (bun-rust-vendor-fetch ref hash-algo hash
                                #:optional name
                                #:key (system (%current-system))
                                #:allow-other-keys)
  "Return a fixed-output Cargo vendor tree for Bun's lol-html dependency."
  (let ((source (bun-rust-vendor-reference-source ref)))
    (with-imported-modules '((guix build utils))
      (gexp->derivation
       (or name "bun-rust-vendor")
       #~(begin
           (use-modules (guix build utils)
                        (ice-9 ftw))
           (setenv "PATH"
                   (string-append #+bash-minimal "/bin:"
                                  #+coreutils "/bin:"
                                  #+gzip "/bin:"
                                  #+tar "/bin:"
                                  #+zstd "/bin:"
                                  #$rust:cargo "/bin:"
                                  #$rust "/bin"))
           (setenv "SSL_CERT_FILE"
                   (string-append #$nss-certs-for-test
                                  "/etc/ssl/certs/ca-certificates.crt"))
           (setenv "CARGO_HTTP_CAINFO" (getenv "SSL_CERT_FILE"))
           (setenv "RUSTC_BOOTSTRAP" "1")
           (setenv "HOME" (string-append (getcwd) "/.home"))
           (setenv "CARGO_HOME" (string-append (getcwd) "/.cargo"))
           (mkdir-p (getenv "HOME"))
           (mkdir-p "source")
           (invoke "tar" "-xzf" #+source "-C" "source"
                   "--strip-components=1")
           (mkdir-p "rust-source")
           (invoke "tar"
                   (string-append "--use-compress-program="
                                  #+zstd "/bin/zstd -d")
                   "-xf" #+(package-source rust)
                   "-C" "rust-source" "--strip-components=1")
           (mkdir-p #$output)
           (with-directory-excursion "source/c-api"
             (invoke (string-append #$rust:cargo "/bin/cargo")
                     "vendor" "--locked" "vendor-lol"))
           (let ((vendor-std
                  (string-append (getcwd)
                                 "/source/c-api/vendor-std")))
             (with-directory-excursion
                 "rust-source/library"
               (invoke (string-append #$rust:cargo "/bin/cargo")
                       "vendor" "--locked" vendor-std)))
           (mkdir-p (string-append #$output "/vendor"))
           (for-each
            (lambda (directory suffix)
              (for-each
               (lambda (crate)
                 (copy-recursively
                  (string-append "source/c-api/" directory "/" crate)
                  (string-append #$output "/vendor/" crate suffix)))
               (scandir
                (string-append "source/c-api/" directory)
                (lambda (name)
                  (not (member name '("." "..")))))))
            '("vendor-lol" "vendor-std")
            '("-lol" "-std"))
           (with-output-to-file (string-append #$output "/config.toml")
             (lambda _
               (display "[source.crates-io]\n")
               (display "replace-with = \"vendored-sources\"\n\n")
               (display "[source.vendored-sources]\n")
               (display "directory = \"vendor\"\n")))
           (copy-file "rust-source/library/Cargo.lock"
                      (string-append #$output "/rust-Cargo.lock")))
       #:system system
       #:hash-algo hash-algo
       #:hash hash
       #:recursive? #t
       #:local-build? #t
       #:leaked-env-vars '("http_proxy" "https_proxy" "HTTP_PROXY"
                           "HTTPS_PROXY" "no_proxy" "NO_PROXY")))))

(define %bun-rust-vendor
  (origin
    (method bun-rust-vendor-fetch)
    (uri (bun-rust-vendor-reference
          (source (bun-dependency-source "lolhtml"))))
    (file-name (string-append "bun-rust-vendor-" %bun-version))
    (sha256
     (base32 "03syrfi1nsp1c6188xmbvd6pp1v3hn33r4q2nzkmnwkyxafqkzy7"))))

(define-public bun
  (package
    (name "bun")
    (version %bun-version)
    (source %bun-source)
    (build-system gnu-build-system)
    (supported-systems '("x86_64-linux" "aarch64-linux"))
    (arguments
     (list
      #:tests? #f
      #:strip-binaries? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'bootstrap)
          (delete 'configure)
          (add-after 'unpack 'prepare-offline-sources
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (use-modules (ice-9 ftw))
              (let* ((cwd (getcwd))
                     (build-root
                      (string-append (assoc-ref outputs "out")
                                     "/.bun-build"))
                     (prefetch (string-append cwd "/.prefetch"))
                     (by-url (string-append prefetch "/by-url"))
                     (webkit (string-append build-root "/WebKit"))
                     (zig-dir (string-append cwd "/vendor/zig-guix"))
                     (zig (assoc-ref inputs "zig"))
                     (rust (assoc-ref inputs "rust"))
                     (rust-vendor (assoc-ref inputs "rust-vendor"))
                     (rust-sysroot (string-append cwd "/.rust-sysroot"))
                     (rustlib (string-append rust "/lib/rustlib"))
                     (null-log (open-output-file "/dev/null"))
                     (shadow-rustlib
                      (string-append rust-sysroot "/lib/rustlib")))
                (mkdir-p by-url)
                (for-each
                 (lambda (entry)
                   (let ((name (car entry))
                         (key (cadr entry)))
                     (symlink (assoc-ref inputs name)
                              (string-append by-url "/" key))))
                 '#$(map (lambda (entry)
                           (list (car entry) (caddr entry)))
                         %bun-dependency-archives))
                (mkdir-p build-root)
                (copy-recursively (assoc-ref inputs "webkit") webkit
                                  #:log null-log)
                (invoke "chmod" "-R" "u+w" webkit)
                (mkdir-p zig-dir)
                (symlink (string-append zig "/bin/zig")
                         (string-append zig-dir "/zig"))
                (symlink (string-append zig "/lib/zig")
                         (string-append zig-dir "/lib"))
                (copy-recursively (assoc-ref inputs "node_modules") "."
                                  #:log null-log)
                (close-port null-log)
                (invoke "chmod" "-R" "u+w" ".")
                (mkdir-p ".cargo")
                (copy-file
                 (string-append (assoc-ref inputs "rust-vendor")
                                "/config.toml")
                 ".cargo/config.toml")
                (substitute* ".cargo/config.toml"
                  (("directory = \"vendor\"")
                   "directory = \".cargo-vendor\""))
                (mkdir-p ".cargo-vendor")
                (for-each
                 (lambda (crate)
                   (symlink
                    (string-append (assoc-ref inputs "rust-vendor")
                                   "/vendor/" crate)
                    (string-append ".cargo-vendor/" crate)))
                 (scandir
                  (string-append (assoc-ref inputs "rust-vendor") "/vendor")
                  (lambda (name)
                    (not (member name '("." ".."))))))
                (mkdir-p (string-append rust-sysroot "/bin"))
                (for-each
                 (lambda (name)
                   (unless (string=? name "rustc")
                     (symlink (string-append rust "/bin/" name)
                              (string-append rust-sysroot "/bin/" name))))
                 (scandir (string-append rust "/bin")
                          (lambda (name)
                            (not (member name '("." ".."))))))
                (with-output-to-file
                    (string-append rust-sysroot "/bin/rustc")
                  (lambda _
                    (format #t "#!~a~%exec ~a/bin/rustc --sysroot ~a \"$@\"~%"
                            #$(file-append bash-minimal "/bin/sh")
                            rust rust-sysroot)))
                (chmod (string-append rust-sysroot "/bin/rustc") #o555)
                (mkdir-p (string-append rust-sysroot "/lib"))
                (for-each
                 (lambda (name)
                   (unless (string=? name "rustlib")
                     (symlink (string-append rust "/lib/" name)
                              (string-append rust-sysroot "/lib/" name))))
                 (scandir (string-append rust "/lib")
                          (lambda (name)
                            (not (member name '("." ".."))))))
                (mkdir-p shadow-rustlib)
                (for-each
                 (lambda (name)
                   (unless (string=? name "src")
                     (symlink (string-append rustlib "/" name)
                              (string-append shadow-rustlib "/" name))))
                 (scandir rustlib
                          (lambda (name)
                            (not (member name '("." ".."))))))
                (let* ((library
                        (string-append rustlib "/src/rust/library"))
                       (shadow-library
                        (string-append shadow-rustlib
                                       "/src/rust/library")))
                  (mkdir-p shadow-library)
                  (for-each
                   (lambda (name)
                     (unless (string=? name "Cargo.lock")
                       (symlink (string-append library "/" name)
                                (string-append shadow-library "/" name))))
                   (scandir library
                            (lambda (name)
                              (not (member name '("." ".."))))))
                  (copy-file (string-append rust-vendor
                                            "/rust-Cargo.lock")
                             (string-append shadow-library "/Cargo.lock")))
                (setenv "BUN_BUILD_PREFETCH_DIR" prefetch)
                (setenv "BUN_WEBKIT_PATH" webkit)
                (setenv "BUN_ZIG_PATH" zig-dir)
                ;; WebKit's inspector generator falls back to /usr/bin/gcc
                ;; unless CC is explicit; there is intentionally no /usr in
                ;; a Guix build container.
                (setenv "CC"
                        (string-append (assoc-ref inputs "clang-toolchain")
                                       "/bin/clang"))
                (setenv "CXX"
                        (string-append (assoc-ref inputs "clang-toolchain")
                                       "/bin/clang++"))
                ;; Local/source WebKit links system ICU dynamically.  Add the
                ;; Guix runtime paths during Bun's original link, preserving
                ;; the linker-produced ELF layout instead of post-processing
                ;; it with patchelf.  glibc is included because its libc.so
                ;; linker script can retain ld-linux as an AS_NEEDED entry.
                (substitute* "scripts/build/flags.ts"
                  (("export const linkerFlags: Flag\\[] = \\[")
                   (string-append
                    "export const linkerFlags: Flag[] = [\n"
                    "  {\n"
                    "    flag: [\n"
                    "      \"-Wl,-rpath,"
                    (assoc-ref inputs "icu4c") "/lib\",\n"
                    "      \"-Wl,-rpath,"
                    (assoc-ref inputs "glibc") "/lib\",\n"
                    "    ],\n"
                    "    when: c => c.linux && c.abi === \"gnu\",\n"
                    "    desc: \"Guix runtime library search paths\",\n"
                    "  },")))
                ;; Bun's outer Ninja build starts nested CMake/Ninja builds.
                ;; Bound the inner WebKit build so the two schedulers cannot
                ;; overcommit memory nondeterministically.
                (setenv "CMAKE_BUILD_PARALLEL_LEVEL" "4")
                (setenv "HOME" (string-append cwd "/.home"))
                (setenv "XDG_CACHE_HOME" (string-append cwd "/.cache"))
                (setenv "CARGO_HOME" (string-append cwd "/.cargo-home"))
                (setenv "RUSTUP_HOME" (string-append cwd "/.rustup-home"))
                ;; Bun builds lol-html's standard library with Cargo's
                ;; -Zbuild-std.  Guix's Rust includes rust-src; permit that
                ;; nightly-gated Cargo interface without rustup downloads.
                (setenv "RUSTC_BOOTSTRAP" "1")
                (setenv "RUSTC" (string-append rust-sysroot "/bin/rustc"))
                ;; The build directory lives in the output so WebKit and Zig
                ;; intermediates do not exhaust /tmp.  Run Zig from Bun's
                ;; source root so it can still discover build.zig.
                (substitute* "scripts/build/zig.ts"
                  (("\\$zig build \\$step \\$args")
                   "--cwd=${quote(cfg.cwd)} $zig build $step $args"))
                ;; Upstream exits stream.ts immediately when a child fails,
                ;; before its asynchronous prefixed output is flushed.  That
                ;; can hide the actual compiler diagnostic behind Ninja's
                ;; generic failure.  Drain queued output before propagating
                ;; the status.
                (substitute* "scripts/build/stream.ts"
                  (("process\\.exit\\(code \\?\\? 1\\);")
                   "out.write(\"\", () => process.exit(code ?? 1));"))
                ;; Avoid keeping a stage0 Bun process in the middle of long,
                ;; high-volume nested CMake builds (notably WebKit).  Ninja
                ;; can invoke CMake directly and then owns complete failure
                ;; output without changing the generated build itself.
                (substitute* "scripts/build/source.ts"
                  (("command: `\\$\\{stream\\} \\$\\{cmake\\} --build \\$builddir --config \\$buildtype \\$targets`,")
                   (string-append
                    "command: `${cmake} --build $builddir --config "
                    "$buildtype $targets -- --quiet`,")))
                ;; git-fetch deliberately strips .git.  Preserve the pinned
                ;; release revision for UWS/USOCKETS version constants and
                ;; Bun's embedded revision instead of allowing "unknown".
                (substitute* "scripts/build/config.ts"
                  (("const revision = getGitRevision\\(cwd\\);")
                   (string-append "const revision = \""
                                  #$%bun-commit "\";")))
                ;; Newer libstdc++ exposes the C++ overload only in namespace
                ;; std.  Upstream's unqualified call happens to work with its
                ;; release toolchain, but not with Guix's Clang 21/GCC 14
                ;; headers.
                (substitute* "src/jsc/bindings/napi.cpp"
                  (("if \\(isfinite\\(js_number\\)\\)")
                   "if (std::isfinite(js_number))"))
                (mkdir-p (getenv "HOME"))
                (false-if-exception (delete-file "/tmp/bun-ld.so"))
                (symlink (string-append (assoc-ref inputs "glibc")
                                        "/lib/" #$%bun-loader)
                         "/tmp/bun-ld.so"))))
          (replace 'build
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((build-root
                      (string-append (assoc-ref outputs "out")
                                     "/.bun-build"))
                     (bootstrap
                      (string-append (assoc-ref inputs "bun-bootstrap")
                                     "/libexec/bun/bun")))
                ;; Bun is needed to evaluate the TypeScript build graph, but
                ;; it need not remain the parent of a multi-hour native
                ;; build.  Emit build.ninja first, then let Guix supervise
                ;; Ninja directly.
                (invoke bootstrap "scripts/build.ts"
                        "--profile=release-local"
                        "--configure-only"
                        (string-append "--build-dir=" build-root "/release")
                        (string-append "--cache-dir=" build-root "/cache"))
                ;; Zig code generation and WebKit are each highly parallel
                ;; internally.  Serialize the outer graph so their memory
                ;; peaks do not overlap; WebKit retains the bounded inner
                ;; parallelism configured above.
                (invoke "ninja" "-j1" "-C"
                        (string-append build-root "/release")))))
          (replace 'install
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (build-root (string-append out "/.bun-build"))
                     (bin (string-append out "/bin")))
                (mkdir-p bin)
                (install-file (string-append build-root "/release/bun")
                              bin)
                (chmod (string-append bin "/bun") #o555)
                (symlink "bun" (string-append bin "/bunx"))
                (install-file "LICENSE.md"
                              (string-append out "/share/licenses/bun"))
                (install-file "completions/bun.bash"
                              (string-append out
                                             "/share/bash-completion/completions"))
                (rename-file
                 (string-append out
                                "/share/bash-completion/completions/bun.bash")
                 (string-append out
                                "/share/bash-completion/completions/bun"))
                (install-file "completions/bun.fish"
                              (string-append out
                                             "/share/fish/vendor_completions.d"))
                (install-file "completions/bun.zsh"
                              (string-append out "/share/zsh/site-functions"))
                (rename-file
                 (string-append out "/share/zsh/site-functions/bun.zsh")
                 (string-append out "/share/zsh/site-functions/_bun"))
                (delete-file-recursively build-root))))
          (add-after 'install 'check-built-bun
            (lambda* (#:key inputs outputs #:allow-other-keys)
              (let* ((bun (string-append (assoc-ref outputs "out")
                                         "/bin/bun"))
                     (patchelf (string-append (assoc-ref inputs "patchelf")
                                              "/bin/patchelf"))
                     (source (string-append (getcwd) "/compile-check.ts"))
                     (compiled (string-append (getcwd) "/compile-check"))
                     (patched-bun (string-append (getcwd) "/patched-bun"))
                     (patched-compiled
                      (string-append (getcwd) "/patched-compile-check"))
                     (runtime-path
                      (string-append
                       (assoc-ref inputs "icu4c") "/lib:"
                       (assoc-ref inputs "glibc") "/lib:/tmp/"
                       (make-string 256 #\x))))
                (unsetenv "LD_LIBRARY_PATH")
                (invoke bun "--version")
                (invoke bun "-e" "console.log('ok')")
                (call-with-output-file source
                  (lambda (port)
                    (display "console.log('compiled-ok')\n" port)))
                (invoke bun "build" "--compile" source
                        "--outfile" compiled)
                (invoke compiled)
                ;; Regression test for upstream issue #31023 and PR #31024:
                ;; force patchelf to relocate dynamic metadata and add another
                ;; writable PT_LOAD, then compile from that modified template.
                ;; https://github.com/oven-sh/bun/issues/31023
                ;; https://github.com/oven-sh/bun/pull/31024
                (copy-file bun patched-bun)
                (chmod patched-bun #o755)
                (invoke patchelf "--set-rpath" runtime-path patched-bun)
                (invoke patched-bun "build" "--compile" source
                        "--outfile" patched-compiled)
                (invoke patched-compiled)
                (for-each delete-file
                          (list source compiled patched-bun
                                patched-compiled))))))))
    (native-inputs
     (append
      `(("bun-bootstrap" ,bun-bootstrap)
        ("node_modules" ,%bun-node-modules)
        ("rust-vendor" ,%bun-rust-vendor)
        ("webkit" ,%bun-webkit-source)
        ("clang-toolchain" ,clang-toolchain-21)
        ("llvm" ,llvm-21)
        ("lld" ,lld-21)
        ("zig" ,bun-zig)
        ("node" ,node)
        ("cmake" ,cmake)
        ("ninja" ,ninja)
        ("pkg-config" ,pkg-config)
        ("python" ,python)
        ("ruby" ,ruby)
        ("perl" ,perl)
        ("git" ,git-minimal)
        ("rust" ,rust)
        ("cargo" ,rust "cargo")
        ("unzip" ,unzip)
        ("patchelf" ,patchelf))
      (map (lambda (entry)
             (list (car entry) (cadddr entry)))
           %bun-dependency-archives)))
    (inputs (list glibc icu4c))
    (home-page "https://bun.sh/")
    (synopsis "JavaScript runtime, bundler, test runner, and package manager")
    (description
     "Bun is an all-in-one JavaScript runtime and toolkit.  This package
compiles Bun itself, its WebKit/JavaScriptCore engine, and native dependencies
from pinned source inputs.  A private stage0 Bun seed is used only to break the
self-hosting cycle for Bun-specific code generation.")
    (license (list license:expat license:lgpl2.1))))
