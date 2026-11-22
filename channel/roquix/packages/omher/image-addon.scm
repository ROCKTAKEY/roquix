(define-module (roquix packages omher image-addon)
  #:use-module (gnu packages bash)
  #:use-module (gnu packages node)
  #:use-module (gnu packages web)
  #:use-module (gnu packages nss)
  #:use-module (guix build-system gnu)
  #:use-module (guix gexp)
  #:use-module (guix git-download)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (roquix packages wasm)
  #:export (image-addon))

(define (github-source repository commit hash)
  (origin
    (method git-fetch)
    (uri (git-reference
          (url (string-append "https://github.com/" repository))
          (commit commit)))
    (file-name (git-file-name (basename repository) commit))
    (sha256 (base32 hash))))

(define xterm-wasm-parts
  (github-source "jerch/xterm-wasm-parts" "92c6434eb98c16abfcb5d0b3b339baa2a836c7ee"
                 "15madd67dj6n8rz04zskjsdihp9p3hm4ylaldlacgxbi21whj3qk"))

(define node-sixel
  (github-source "jerch/node-sixel" "35f542f8b1b9a8867fab133aea5d43cb3da6108a"
                 "1jszzpx1i07aixvy8fdz3vgbx1wkw8lv61fj2rw7q5gqz6ix4wz9"))

(define* (fetch-codec-inputs uri hash-algo hash #:optional name
                             #:key system guile #:allow-other-keys)
  (gexp->derivation
   name
   (with-imported-modules '((guix build utils))
     #~(begin
         (use-modules (guix build utils))
         (setenv "PATH" (string-append #+node "/bin:" #+bash-minimal "/bin"))
         (setenv "HOME" (getcwd))
         (setenv "NODE_EXTRA_CA_CERTS"
                 #+(file-append nss-certs-for-test "/etc/ssl/certs/ca-certificates.crt"))
         (for-each
          (lambda (source project)
            (mkdir project)
            (with-directory-excursion project
              (for-each (lambda (file) (copy-file (string-append source "/" file) file))
                        '("package.json" "package-lock.json"))
              (invoke "npm" "ci" "--ignore-scripts" "--no-audit" "--no-fund")
              (copy-recursively "node_modules" (string-append #$output "/" project)
                                #:log (%make-void-port "w"))))
          (list #+xterm-wasm-parts #+node-sixel) '("parts" "sixel"))))
   #:system system #:guile-for-build guile #:hash-algo hash-algo #:hash hash
   #:recursive? #t))

(define codec-inputs
  (origin
    (method fetch-codec-inputs)
    (uri "omher-image-codec-inputs")
    (file-name "omher-image-codec-inputs")
    (sha256 (base32 "1vhdr5yq2dwhbzjp6ayjh42fpkpcyg1hww8san0gnpi2hk9vpfs6"))))

(define image-addon
  (hidden-package
   (package
     (name "omher-xterm-addon-image")
     (version "0.10.0-beta.333")
     (source
      (github-source "xtermjs/xterm.js" "c9cc4785d24c9fad658627d5a458350d0baf3f1d"
                     "0irs8a2sb8md3j8gdsjhfdnqj67w8szxpsy9pmqhcajd1qr6b7wm"))
     (build-system gnu-build-system)
     (arguments
      (list
       #:phases
       #~(modify-phases %standard-phases
           (delete 'configure)
           (replace 'build
             (lambda _
               (setenv "HOME" (getcwd))
               (setenv "npm_config_script_shell" (which "bash"))
               (setenv "EM_CACHE" (string-append (getcwd) "/em-cache"))
               ;; Both projects accept a preinstalled emsdk. Guix provides its
               ;; tools on PATH and the Clang binaries in a separate directory.
               (let ((sdk (string-append (getcwd) "/emsdk")))
                 (mkdir-p (string-append sdk "/upstream"))
                 (symlink #$(file-append emscripten-4 "/share/emscripten/llvm-bin")
                          (string-append sdk "/upstream/bin"))
                 (call-with-output-file (string-append sdk "/emsdk_env.sh") newline)
                 (setenv "PATH" (string-append sdk "/upstream/bin:" (getenv "PATH")))
                 (setenv "INWASM_EMSDK_PATH" sdk))
               (mkdir-p "node_modules")
               (symlink #$(file-append node-esbuild "/lib/node_modules/esbuild")
                        "node_modules/esbuild")
               (for-each
                (lambda (source project modules)
                  (let ((dir (string-append "node_modules/" project)))
                    (copy-recursively source dir)
                    (with-directory-excursion dir
                      (copy-recursively modules "node_modules" #:log (%make-void-port "w"))
                      (for-each (lambda (file) (patch-shebang (canonicalize-path file)))
                                (find-files "node_modules/.bin" ".*")))))
                (list #$xterm-wasm-parts #$node-sixel) '("xterm-wasm-parts" "sixel")
                (list #$(file-append codec-inputs "/parts") #$(file-append codec-inputs "/sixel")))
               (with-directory-excursion "node_modules/xterm-wasm-parts"
                 ;; Node's execSync defaults to /bin/sh for this lookup.
                 (substitute* "node_modules/inwasm/lib/config.js"
                   (("execSync\\('which bash'.*\\)\\.trim\\(\\)") (format #f "~s" (which "bash"))))
                 (invoke "npm" "run" "build"))
               (with-directory-excursion "node_modules/sixel"
                 (symlink (getenv "INWASM_EMSDK_PATH") "emsdk")
                 (for-each patch-shebang '("bin/install_emscripten.sh" "wasm/build.sh"))
                 ;; Emscripten 4 uses STACK_SIZE and has retired SUPPORT_ERRNO.
                 (substitute* "wasm/build.sh"
                   (("-s SUPPORT_ERRNO=0 .*") "")
                   (("TOTAL_STACK=") "STACK_SIZE="))
                 (invoke "npm" "run" "build-wasm")
                 (invoke "npm" "run" "tsc"))
               (invoke "node" "bin/esbuild.mjs" "--prod" "--addon=image")))
           (replace 'check
             (lambda _
               (with-directory-excursion "node_modules/xterm-wasm-parts"
                 (invoke "npm" "test"))
               (with-directory-excursion "node_modules/sixel"
                 (invoke "node" "node_modules/mocha/bin/mocha" "lib/Decoder.test.js"))))
           (replace 'install
             (lambda _
               (with-directory-excursion "addons/addon-image"
                 (install-file "lib/addon-image.mjs" (string-append #$output "/lib"))
                 (install-file "typings/addon-image.d.ts" (string-append #$output "/typings"))
                 (invoke "npm" "pkg" "set" "main=lib/addon-image.mjs"
                         #$(string-append "version=" version))
                 (install-file "package.json" #$output)))))))
     (native-inputs (list node emscripten-4))
     (synopsis "Terminal image support for omher")
     (description "This xterm.js add-on decodes images displayed in omher terminals.")
     (home-page "https://xtermjs.org/")
     (license license:expat))))
