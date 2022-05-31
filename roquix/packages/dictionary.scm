(define-module
  (roquix packages dictionary)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system copy))

(define-public skk-jisyo
  (package
   (name "skk-jisyo")
   (version "0")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/skk-dev/dict")
           (commit "c6e6a8822b673bfe3e7182f99cdffd1f7735a61e")))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "1hafjawl2nyvcdm8lffz61ry1jsvyr0ssz4b5n95p6wjldq4l4ld"))))
   (build-system copy-build-system)
   (arguments
    `(#:install-plan
      ',(map
         (lambda (arg)
           (list arg "share/skk/"))
         '("SKK-JISYO.JIS2"
           "SKK-JISYO.JIS2004"
           "SKK-JISYO.JIS3_4"
           "SKK-JISYO.L"
           "SKK-JISYO.L.unannotated"
           "SKK-JISYO.M"
           "SKK-JISYO.ML"
           "SKK-JISYO.S"
           "SKK-JISYO.assoc"
           "SKK-JISYO.china_taiwan"
           "SKK-JISYO.china_taiwan.header"
           "SKK-JISYO.edict"
           "SKK-JISYO.edict2"
           "SKK-JISYO.emoji"
           "SKK-JISYO.fullname"
           "SKK-JISYO.geo"
           "SKK-JISYO.hukugougo"
           "SKK-JISYO.itaiji"
           "SKK-JISYO.itaiji.JIS3_4"
           "SKK-JISYO.ivd"
           "SKK-JISYO.jinmei"
           "SKK-JISYO.law"
           "SKK-JISYO.lisp"
           "SKK-JISYO.mazegaki"
           "SKK-JISYO.noregist"
           "SKK-JISYO.not_wrong"
           "SKK-JISYO.notes"
           "SKK-JISYO.okinawa"
           "SKK-JISYO.pinyin"
           "SKK-JISYO.propernoun"
           "SKK-JISYO.pubdic+"
           "SKK-JISYO.requested"
           "SKK-JISYO.station"
           "SKK-JISYO.wrong"
           "SKK-JISYO.wrong.annotated"))))
   (home-page "https://skk-dev.github.io/dict/")
   (synopsis "SKK-JISYO")
   (description
    "SKK dictionary")
   (license license:gpl2+)))
