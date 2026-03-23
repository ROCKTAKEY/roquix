(define-module (roquix build appimage-build-system)
  #:use-module ((guix build copy-build-system) #:prefix copy:)
  #:use-module (guix build utils)
  #:use-module (ice-9 format)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (ice-9 popen)
  #:use-module (ice-9 rdelim)
  #:use-module (srfi srfi-1)
  #:use-module (srfi srfi-13)
  #:use-module (rnrs bytevectors)
  #:use-module (rnrs io ports)
  #:export (%standard-phases
            appimage-build))

(define %appimage-type-1-magic
  #vu8(#x41 #x49 #x01))

(define %appimage-type-2-magic
  #vu8(#x41 #x49 #x02))

(define %squashfs-magic
  #vu8(#x68 #x73 #x71 #x73))

(define %icon-extensions
  '("" ".png" ".svg" ".xpm"))

(define (call-with-binary-input-file file proc)
  (call-with-input-file file proc))

(define (bytevector-append* left right)
  (let* ((left-length (bytevector-length left))
         (right-length (bytevector-length right))
         (result (make-bytevector (+ left-length right-length))))
    (bytevector-copy! left 0 result 0 left-length)
    (bytevector-copy! right 0 result left-length right-length)
    result))

(define (subbytevector bytevector start end)
  (let* ((length (- end start))
         (result (make-bytevector length)))
    (bytevector-copy! bytevector start result 0 length)
    result))

(define (read-appimage-magic file)
  (call-with-binary-input-file
   file
   (lambda (port)
     (let ((header (get-bytevector-n port 11)))
       (and (bytevector? header)
            (= (bytevector-length header) 11)
            (subbytevector header 8 11))))))

(define (appimage-type file)
  (let ((magic (read-appimage-magic file)))
    (cond
     ((and magic (bytevector=? magic %appimage-type-1-magic)) 1)
     ((and magic (bytevector=? magic %appimage-type-2-magic)) 2)
     (else #f))))

(define* (bytevector-index haystack needle #:optional (start 0))
  (let ((haystack-length (bytevector-length haystack))
        (needle-length (bytevector-length needle)))
    (let outer ((index start))
      (cond
       ((> (+ index needle-length) haystack-length)
        #f)
       ((let inner ((offset 0))
          (or (= offset needle-length)
              (and (= (bytevector-u8-ref haystack (+ index offset))
                      (bytevector-u8-ref needle offset))
                   (inner (+ offset 1)))))
        index)
       (else
        (outer (+ index 1)))))))

(define (valid-squashfs-offset? file offset)
  (zero? (system* "unsquashfs" "-s" "-o" (number->string offset) file)))

(define (find-squashfs-offset file)
  (define chunk-size 65536)
  (define needle-length (bytevector-length %squashfs-magic))
  (define (next-carry window)
    (let* ((window-length (bytevector-length window))
           (carry-start (max 0 (- window-length (- needle-length 1)))))
      (subbytevector window carry-start window-length)))
  (define (search-window window base-offset)
    (let loop ((start 0))
      (let ((index (bytevector-index window %squashfs-magic start)))
        (cond
         ((not index)
          #f)
         ((valid-squashfs-offset? file (+ base-offset index))
          (+ base-offset index))
         (else
          (loop (+ index 1)))))))

  (call-with-binary-input-file
   file
   (lambda (port)
     (let loop ((bytes-read 0)
                (carry #vu8()))
       (let ((chunk (get-bytevector-n port chunk-size)))
         (if (eof-object? chunk)
             #f
             (let* ((window (bytevector-append* carry chunk))
                    (base-offset (- bytes-read (bytevector-length carry)))
                    (match (search-window window base-offset)))
               (or match
                   (loop (+ bytes-read (bytevector-length chunk))
                         (next-carry window))))))))))

(define (make-tree-writable)
  (for-each (lambda (file)
              (false-if-exception (make-file-writable file)))
            (find-files "." (lambda _ #t) #:directories? #t)))

(define (root-file? directory file)
  (let ((relative (string-drop file (+ (string-length directory) 1))))
    (not (string-contains relative "/"))))

(define (find-root-files directory regexp)
  (filter (lambda (file)
            (root-file? directory file))
          (find-files directory regexp)))

(define (root-desktop-files directory)
  (find-root-files directory "\\.desktop$"))

(define (read-all-lines port)
  (let loop ((lines '()))
    (let ((line (read-line port 'concat)))
      (if (eof-object? line)
          (apply string-append (reverse lines))
          (loop (cons line lines))))))

(define (command-output . command)
  (let* ((port (apply open-pipe* OPEN_READ command))
         (output (read-all-lines port))
         (status (close-pipe port)))
    (unless (zero? (status:exit-val status))
      (error "command failed" command))
    (string-trim-both output)))

(define (desktop-entry-field file field)
  (call-with-input-file
   file
   (lambda (port)
     (let loop ((line (read-line port 'concat)))
       (cond
        ((eof-object? line)
         #f)
        ((string-prefix? (string-append field "=") line)
         (string-trim-both
          (string-drop line (+ (string-length field) 1))))
        (else
         (loop (read-line port 'concat))))))))

(define (icon-candidate-names icon-name)
  (delete-duplicates
   (if (any (lambda (extension)
              (string-suffix? extension icon-name))
            (cdr %icon-extensions))
       (list icon-name)
       (append (map (lambda (extension)
                      (string-append icon-name extension))
                    (cdr %icon-extensions))
               (list icon-name)))))

(define (icon-file-candidate? file)
  (and (file-exists? file)
       (let ((type (stat:type (lstat file))))
         (or (eq? 'symlink type)
             (any (lambda (extension)
                    (and (not (string-null? extension))
                         (string-suffix? extension file)))
                  (cdr %icon-extensions))
             (not (access? file X_OK))))))

(define (image-extension file)
  (find (lambda (extension)
          (and (not (string-null? extension))
               (string-suffix? extension file)))
        (cdr %icon-extensions)))

(define (find-root-icon directory icon-name)
  (and icon-name
       (not (string-contains icon-name "/"))
       (find icon-file-candidate?
             (map (lambda (candidate)
                    (string-append directory "/" candidate))
                  (icon-candidate-names icon-name)))))

(define (resolve-symlink file)
  (let loop ((file file))
    (let ((stat (lstat file)))
      (if (eq? 'symlink (stat:type stat))
          (let ((target (readlink file)))
            (loop (if (string-prefix? "/" target)
                      target
                      (string-append (dirname file) "/" target))))
          file))))

(define (copy-file* source target)
  (mkdir-p (dirname target))
  (copy-file (resolve-symlink source) target))

(define (file-has-elf-interpreter? file)
  (call-with-output-file "/dev/null"
    (lambda (port)
      (zero?
       (status:exit-val
        (with-output-to-port port
          (lambda ()
            (with-error-to-port port
              (lambda ()
                (system* "patchelf" "--print-interpreter" file))))))))))

(define (binary-is-64-bit? file)
  (string-contains (command-output "file" "-b" file) "ELF 64-bit"))

(define (interpreter-for-binary inputs file)
  (let* ((libc-directory (if (binary-is-64-bit? file)
                             (assoc-ref inputs "libc")
                             (assoc-ref inputs "libc32")))
         (interpreter (and libc-directory
                           (car (find-files libc-directory "ld-linux.*\\.so")))))
    (unless interpreter
      (error "failed to locate dynamic linker for ELF file" file))
    interpreter))

(define* (lookup-rpath-directory outputs inputs entry)
  (match entry
    ((name extra-path)
     (let ((base (or (assoc-ref outputs name)
                     (assoc-ref inputs name))))
       (unless base
         (error "patchelf-plan entry not found among inputs or outputs" name))
       (string-append base extra-path)))
    (name
     (lookup-rpath-directory outputs inputs (list name "/lib")))))

(define (existing-rpath-entries file)
  (let ((rpath (command-output "patchelf" "--print-rpath" file)))
    (filter (lambda (entry)
              (and (not (string-null? entry))
                   (or (string-contains entry "$ORIGIN")
                       (file-exists? entry))))
            (string-split rpath #\:))))

(define (patch-binary file inputs outputs runpath)
  (when (file-has-elf-interpreter? file)
    (invoke "patchelf" "--set-interpreter"
            (interpreter-for-binary inputs file)
            file))
  (when runpath
    (let* ((directories (map (lambda (entry)
                               (lookup-rpath-directory outputs inputs entry))
                             runpath))
           (rpath (string-join
                   (delete-duplicates
                    (append (existing-rpath-entries file)
                            directories))
                   ":")))
      (unless (string-null? rpath)
        (invoke "patchelf" "--set-rpath" rpath file)))))

(define* (unpack-appimage #:key source #:allow-other-keys)
  (case (appimage-type source)
    ((2)
     (let ((offset (find-squashfs-offset source)))
       (unless offset
         (error "failed to locate embedded SquashFS image in AppImage" source))
       (format #t "extracting type 2 AppImage from offset ~a~%" offset)
       (mkdir "AppDir")
       (invoke "unsquashfs" "-no-progress" "-dest" "AppDir"
               "-offset" (number->string offset) source)
       (chdir "AppDir")
       (make-tree-writable)
       #t))
    ((1)
     (error "type 1 AppImages are deprecated and not supported by this build-system"
            source))
    (else
     (error "source does not look like an AppImage" source))))

(define* (validate-appdir #:key (source #f) #:allow-other-keys)
  (let ((desktop-files (root-desktop-files ".")))
    (unless (access? "AppRun" X_OK)
      (error "AppDir is missing an executable AppRun"))
    (unless (file-exists? ".DirIcon")
      (error "AppDir is missing .DirIcon"))
    (unless (= 1 (length desktop-files))
      (error "AppDir must contain exactly one root desktop file"
             desktop-files))
    (let* ((desktop-file (car desktop-files))
           (icon-name (desktop-entry-field desktop-file "Icon"))
           (icon-file (find-root-icon "." icon-name)))
      (unless icon-name
        (error "desktop file is missing Icon entry" desktop-file))
      (unless icon-file
        (error "desktop file Icon entry does not resolve to a root icon"
               icon-name))))
  #t)

(define* (patchelf-binaries #:key inputs outputs appdir
                            (patchelf-plan '())
                            #:allow-other-keys)
  (if (null? patchelf-plan)
      #t
      (let* ((out (assoc-ref outputs "out"))
             (installed-appdir (string-append out "/" appdir)))
        (display "Using patchelf version: ")
        (force-output)
        (invoke "patchelf" "--version")
        (for-each
         (match-lambda
           ((relative-file runpath)
            (patch-binary (string-append installed-appdir "/" relative-file)
                          inputs outputs runpath))
           ((relative-file)
            (patch-binary (string-append installed-appdir "/" relative-file)
                          inputs outputs #f)))
         patchelf-plan)
        #t)))

(define* (wrapper-library-path outputs inputs ld-library-path-inputs)
  (string-join
   (delete-duplicates
    (map (lambda (entry)
           (lookup-rpath-directory outputs inputs entry))
         ld-library-path-inputs))
   ":"))

(define* (install-wrapper #:key inputs outputs appdir launcher-name
                          (ld-library-path-inputs '())
                          (install-wrapper? #t)
                          #:allow-other-keys)
  (if (not install-wrapper?)
      #t
      (let* ((out (assoc-ref outputs "out"))
             (installed-appdir (string-append out "/" appdir))
             (bin (string-append out "/bin"))
             (launcher (string-append bin "/" launcher-name))
             (shell (search-input-file inputs "/bin/sh"))
             (library-path (wrapper-library-path outputs inputs
                                                 ld-library-path-inputs)))
        (mkdir-p bin)
        (call-with-output-file launcher
          (lambda (port)
            (format port "#!~a~%" shell)
            (format port "export APPDIR=\"~a\"~%" installed-appdir)
            (unless (string-null? library-path)
              (format port
                      "export LD_LIBRARY_PATH=\"~a${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}\"~%"
                      library-path))
            (format port "exec \"$APPDIR/AppRun\" \"$@\"~%")))
        (chmod launcher #o555)
        #t)))

(define* (rewrite-desktop-file file launcher #:optional icon-file)
  (substitute* file
    (("^Exec=[^[:space:]]+(.*)" _ rest)
     (string-append "Exec=" launcher rest))
    (("^TryExec=[^[:space:]]+(.*)" _ rest)
     (string-append "TryExec=" launcher rest)))
  (when icon-file
    (substitute* file
      (("^Icon=.*")
       (string-append "Icon=" icon-file "\n")))))

(define* (install-desktop-file #:key outputs appdir launcher-name
                               (install-desktop-file? #t)
                               #:allow-other-keys)
  (if (not install-desktop-file?)
      #t
      (let* ((out (assoc-ref outputs "out"))
             (installed-appdir (string-append out "/" appdir))
             (desktop-files (root-desktop-files installed-appdir))
             (applications (string-append out "/share/applications"))
             (launcher (string-append out "/bin/" launcher-name)))
        (unless (null? desktop-files)
          (let* ((source (car desktop-files))
                 (icon-name (desktop-entry-field source "Icon"))
                 (icon-file (and icon-name
                                 (find-root-icon installed-appdir icon-name)))
                 (target (string-append applications "/" launcher-name ".desktop")))
            (mkdir-p applications)
            (copy-file* source target)
            (rewrite-desktop-file target launcher
                                  (and icon-file
                                       (resolve-symlink icon-file)))))
        #t)))

(define %standard-phases
  (modify-phases copy:%standard-phases
    (replace 'unpack unpack-appimage)
    (add-after 'patch-source-shebangs 'validate-appdir validate-appdir)
    (add-after 'install 'patchelf-binaries patchelf-binaries)
    (add-after 'patchelf-binaries 'install-wrapper install-wrapper)
    (add-after 'install-wrapper 'install-desktop-file install-desktop-file)))

(define* (appimage-build #:key inputs
                         install-plan
                         (appdir "lib/appimage")
                         (launcher-name "appimage")
                         (ld-library-path-inputs '())
                         (install-wrapper? #t)
                         (install-desktop-file? #t)
                         (patchelf-plan '())
                         (phases %standard-phases)
                         #:allow-other-keys
                         #:rest args)
  "Extract the given type 2 AppImage and install its AppDir content according
to INSTALL-PLAN."
  (apply copy:copy-build
         #:inputs inputs
         #:phases phases
         #:install-plan (or install-plan
                            `(("." ,(string-append appdir "/"))))
         #:appdir appdir
         #:launcher-name launcher-name
         #:ld-library-path-inputs ld-library-path-inputs
         #:install-wrapper? install-wrapper?
         #:install-desktop-file? install-desktop-file?
         #:patchelf-plan patchelf-plan
         args))
