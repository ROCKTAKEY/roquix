(define-module (roquix build marp)
  #:use-module (guix build utils)
  #:use-module (srfi srfi-1)
  #:export (remove-prebuilt-native-code))

(define mz-file?
  (file-header-match #vu8(#x4d #x5a)))

(define mach-o-file?
  ;; Cover both byte orders of 32/64-bit Mach-O and universal binaries.
  (let ((predicates
         (map file-header-match
              '(#vu8(#xfe #xed #xfa #xce) #vu8(#xce #xfa #xed #xfe)
                #vu8(#xfe #xed #xfa #xcf) #vu8(#xcf #xfa #xed #xfe)
                #vu8(#xca #xfe #xba #xbe) #vu8(#xbe #xba #xfe #xca)
                #vu8(#xca #xfe #xba #xbf) #vu8(#xbf #xba #xfe #xca)))))
    (lambda (file)
      (any (lambda (predicate) (predicate file)) predicates))))

(define (native-code? file)
  ;; npm archives include extensionless executables as well as Node addons.
  (or (elf-file? file) (mz-file? file) (mach-o-file? file)))

(define (remove-prebuilt-native-code directory)
  (for-each
   (lambda (file)
     (when (and (not (eq? 'symlink (stat:type (lstat file))))
                (native-code? file))
       (delete-file file)))
   (find-files directory)))
