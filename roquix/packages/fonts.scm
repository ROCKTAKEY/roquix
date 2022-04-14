(define-module (roquix packages fonts)
  #:use-module (guix packages)
  #:use-module (guix licenses)
  #:use-module (guix download)
  #:use-module (guix build-system font))

(define-public font-cica
  (package
   (name "font-cica")
   (version "5.0.3")
   (source (origin
            (method url-fetch)
            (uri (string-append
                  "https://github.com/miiton/Cica/releases/download/"
                  "v" version "/Cica_v" version ".zip"))
            (sha256
             (base32
              "0vshn2cd70mnbavsw9cbagcasa95wiv9qdj4wkzxn7gxygqvrlfb"))))
   (build-system font-build-system)
   (home-page "https://github.com/miiton/Cica")
   (synopsis "プログラミング用日本語等幅フォント Cica(シカ)")
   (description "Cicaはプログラミング用日本語等幅フォントです。
英数字、記号類に Hack + DejaVu Sans Mono、それ以外の文字に Rounded Mgen+
を用い、さらにNerd Fonts (= Powerlineパッチ、その他適用済。Pomiconsは除外※)、
Noto Emoji、Icons for Devs、RictyジェネレータからForkした各種調整を、
合成後に調整したものとなっています。")
   (license silofl1.1)))
