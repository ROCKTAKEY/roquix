(define-module (roquix packages vesktop venmic)
  #:use-module (guix download)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (gnu packages node)
  #:export (build-venmic))

(define (github-archive repository version hash)
  (origin
    (method url-fetch)
    (uri (string-append "https://codeload.github.com/" repository
                        "/tar.gz/refs/tags/v" version))
    (file-name (string-append (basename repository) "-" version ".tar.gz"))
    (sha256 (base32 hash))))

;; Supply the CPM projects selected by venmic and rohrkabel to CMake's
;; offline configure step.  spdlog and the audio libraries come from Guix.
(define sources
  (list
   (github-archive "Curve/rohrkabel" "13.2.0" "19kc3aj6sh1mfcg6mfxxqd3fyz3xnfqh2mxvpqzjg23rjpg9p9jh")
   (github-archive "Curve/ereignis" "6.3.0" "0jf3kx9hmq0c1aq8vqa9z9i1sjvp507pkd0wpfc4bbqhpb6ib6p8")
   (github-archive "Curve/coco" "4.7.2" "0hiwvcjfnfg03p2h555kzkypdllx48a0hj1d48xn15vgf16ini2r")
   (github-archive "Curve/channel" "4.0.0" "01rnkgid1yb1s0cnj1fazshsplzfiwrlmyxp6z548bkk4xy6l10n")
   (github-archive "stephenberry/glaze" "7.9.1" "1qra9qxd2fsb00x1dbibyqq1z3zxwic61l1m5ikpalvg4y8y7pnn")
   (github-archive "TheLartians/PackageProject.cmake" "1.13.0" "0id5yxsg2rxpxiy9zpjg7lya35c7k92p2dzflmli96gl5xyly4id")))

(define cpm
  (origin
    (method url-fetch)
    (uri "https://github.com/cpm-cmake/CPM.cmake/releases/download/v0.43.1/CPM.cmake")
    (sha256 (base32 "0d19dk7960n41q5pyqnail9w635kr90za57bwxymsqp95h8gqh0w"))))

(define build-venmic
  #~(lambda _
      (define venmic "node_modules/@vencord/venmic")
      (define names '("rohrkabel" "ereignis" "coco" "channel" "glaze" "PackageProject"))
      (for-each (lambda (name archive)
                  (mkdir name)
                  (invoke "tar" "xf" archive "-C" name "--strip-components=1"))
                names (list #$@sources))
      (for-each (lambda (dir)
                  (let ((bootstrap (string-append dir "/cmake/cpm.cmake")))
                    (when (file-exists? bootstrap)
                      (copy-file #+cpm bootstrap))))
                (cons venmic names))
      (apply invoke "cmake" "-S" venmic "-B" "venmic-build"
             "-Dvenmic_addon=ON" "-Dvenmic_prefer_remote=OFF"
             "-DCMAKE_JS_VERSION=1" "-DCMAKE_BUILD_TYPE=Release"
             (string-append "-DCMAKE_JS_INC=" #+node "/include/node;"
                            (getcwd) "/packages/libvesktop/node_modules/node-addon-api")
             (map (lambda (name)
                    (string-append "-DCPM_" name "_SOURCE=" (getcwd) "/" name))
                  names))
      (invoke "cmake" "--build" "venmic-build" "--parallel"
              (number->string (min 4 (parallel-job-count))))
      (copy-file "venmic-build/addon/venmic-addon.node"
                 (string-append venmic "/prebuilds/venmic-addon-linux-x64/node-napi-v7.node"))))
