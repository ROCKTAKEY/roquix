(define-module
  (roquix packages migemo)
  #:use-module (guix packages)
  #:use-module ((guix licenses)  #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system gnu))

(define-public cmigemo
  (package
   (name "cmigemo")
   (version "1.3e")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/koron/cmigemo")
           (commit "9a1cec4622621e78953ffa8c55cdb561e45657ba")))
     (file-name (git-file-name name version))
     (sha256
      (base32
       "1bwjf7w2f1li7q59d244q3b6xaygpaw5rwp5z0bj055qbkz22sah"))))
   (build-system gnu-build-system)
   (arguments
     `(#:tests? #f))
   (home-page "https://www.kaoriya.net/software/cmigemo/")
   (synopsis "ローマ字入力から日本語を(インクリメンタルに)検索するための正規表現を生成する")
   (description "C/MigemoはMigemo(Ruby/Migemo)をC言語で実装したものです。C/Migemoライブラリを
利用するソフトウェアは「ローマ字のまま日本語を(インクリメンタルに)検索する」
機能を持つことが可能になります。C言語で実装したことにより、本家Ruby/Migemoに
比べ、C言語で書かれた多くのソフトウェアからの利用が容易になること、及び(たぶ
ん)実行速度の向上が期待できます。")
   (license license:expat)))
