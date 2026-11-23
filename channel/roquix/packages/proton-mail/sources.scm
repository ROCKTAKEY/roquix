(define-module (roquix packages proton-mail sources)
  #:use-module (guix download)
  #:use-module (guix packages)
  #:export (desktop-sources))

(define (tarball url name hash . modules)
  (cons (origin (method url-fetch) (uri url) (file-name name)
                (sha256 (base32 hash)))
        modules))

(define (github repo commit hash . modules)
  (apply tarball (string-append "https://codeload.github.com/" repo "/tar.gz/" commit)
         (string-append commit ".tgz") hash modules))

(define desktop-sources
  (list
    (github "7rulnik/source-map-js"
            "428d49f6b1e1614f082b7706fa879a3d9c64f728"
            "06qq1qi94ibf8dy9s3sh8snfhznl9sml1lbi4jjc2dcm52qaaxii"
            '("source-map-js" "."))
    (github "RyanZim/at-least-node"
            "6b45626accdfe9431ef860c55f07420f7df2aaa7"
            "0nndcqiywcdl9k9acgk6qxb3v8bp3xalx2qmsb2iavm94j414qs8"
            '("at-least-node" "."))
    (github "RyanZim/universalify"
            "dc17e0e00fb39c8d52e97ce77e494cdadfa8d19c"
            "1f1s24yqkcchbgqp13nmfdi1r6iavkvhd941q9nd181rz07kynfn"
            '("universalify" "."))
    (github "ajv-validator/ajv"
            "0fba0b8e649909613cfce0999b149cd08f4a4987"
            "14wj448hq6bansdgb6n5k23ak3kjwavf3xcz89dardfvpc3sd7xy"
            '("ajv" "."))
    (github "ajv-validator/ajv-formats"
            "c1cb46cad79f984020a9a0ef569e9c091ce24400"
            "051ggk3apwqs1aznpqb0nayydax7whcc8jbxx3ax3sfi2njfvrf8"
            '("ajv-formats" "."))
    (github "bgrins/TinyColor"
            "a93228a6782bfe9a6154da14f5a7ece3ad9fb6c4"
            "04l05jdkwl2snhq7dzi6204ssf6py2qxhgpf8ncpps57m9gpy7vk"
            '("tinycolor2" "."))
    (github "c-3po-org/plural-forms"
            "9cd0f0e78291377dc42ebcca5c7c56fb49001a7c"
            "1h8kad0h524cn4s4imhpssqx8zgfzsc0grai3304qfsky20wfzb8"
            '("plural-forms" "."))
    (github "chalk/supports-color"
            "e2a4cd3c44eb384b075161ef32859cd29ce1aa7f"
            "0ssbfww9744agd3fgr0lgyizlcabwp18lcf5g7az6ynr08n6jb3c"
            '("supports-color" "."))
    (github "colinhacks/zod"
            "b500a2ee95134f81d74da7911d7378dd2853d042"
            "1r0byqhb22gzpjpnqj8dwwvaswnyjhpy31mvi73apyi2syyc69dc"
            '("zod" "packages/zod"))
    (github "csstree/csstree"
            "593bf37cedfbc052ad0890a6ee851510034ad437"
            "1yqrv3a0qbd8wm3cw9pa5aig4dgqabyl77j6izh32ad65d3jblbf"
            '("css-tree" "."))
    (github "debug-js/debug"
            "6b2c5fbdb7d414483d9e306ef234acb4cd7ea67c"
            "14nyqv81cmsg2ii4ns16x3mq1jhvii2m8whql5xp6pkp88jl223m"
            '("debug" "."))
    (github "dmnd/dedent"
            "d435ce3ae4b9adfd268786c780558a550e4546e0"
            "0kbqmc7n0vzkjm31k8knlyvyi11g5c14l7nqs9ifdin78ps5xkhl"
            '("dedent" "."))
    (github "electron-userland/electron-installer-common"
            "55bf32a62ad271ed62be01b66fb08c5aa5feb3b9"
            "0rxv2c139sgi1npsc8ybr05im1hlp323adn4fya1rc5i9dbq366z"
            '("electron-installer-common" "."))
    (github "electron-userland/electron-installer-debian"
            "980f47efd9767e50d028b76c6c5286696cb376db"
            "101ylr4h3wvyw3rw5qv3b6b6zxrp31d0r1m0nd8masd6pi8sp0k6"
            '("electron-installer-debian" "."))
    (github "electron/asar"
            "e4fb057678562b7b6170699a046d983ae6d31cb8"
            "03mym7bxjs5ar8sjyqpns5shjshf6nh6wpr399nq7yjq3nlayksm"
            '("@electron/asar" "."))
    (github "electron/fuses"
            "b38d2e80d9267b52d6db99cd9c9e616da3d037e8"
            "08jvacgzvn555xi1ybjavz28ikkdjpilgyk13cjgqjg2nf0j6i3g"
            '("@electron/fuses" "."))
    (github "electron/update-electron-app"
            "0eb2936456abd8b9838fc5c95e89785b585c35ce"
            "1vvgvpcn4j4avwawxs4syb1s3s3m1p7b9pphwmk622lw5ns9clfy"
            '("update-electron-app" "."))
    (github "epoberezkin/fast-deep-equal"
            "d807ffc5013e710deb1c63d463a03f729bcd144d"
            "1xpszsqjvdc6vvgjlfqkyw9vn7giwa56sm7gpdzal8fgann94437"
            '("fast-deep-equal" "."))
    (github "epoberezkin/json-schema-traverse"
            "6b45983cd76270042cc79527da5c8972f13599ec"
            "1fiqbw9raxsdn5d4z0nlyf9rfl8swb9dcf1qdgf02zldd2fmkgd5"
            '("json-schema-traverse" "."))
    (github "fabiospampinato/atomically"
            "799d961964a27383f61a349af6d4a8e00c3b8395"
            "15n60cwm5fqz8s6z3ibrbkwz1inc9zxhg3ryqnshvzcyy43hx3q7"
            '("atomically" "."))
    (github "faisalman/ua-parser-js"
            "90017c98d341788570435b7587ce1f0725022c7a"
            "0id3cr86b5xqrsdw6jhh8zrw3448rhgg1d8cimdakrpsg9vrpza9"
            '("ua-parser-js" "."))
    (github "fastify/fast-uri"
            "0def70338a0fa2f12a10c83ae8eafc2139ae9a07"
            "1jl2xynayfzwiv08616wk68w0m1hc1v474ph0qszizy9nq65bfd4"
            '("fast-uri" "."))
    (github "getsentry/sentry-conventions"
            "fd88fd9e5c0d3cab4c14bf58ba2e1131621737b1"
            "046k48227ql62l9iqziyapxshc0hg1zq1332kjycnbk9phsg0nkv"
            '("@sentry/conventions" "javascript/sentry-conventions"))
    (github "getsentry/sentry-electron"
            "53df4a74c4e305001e09d778f5208bbe18a538ad"
            "02dn0qa7lpf5aqsslpqrs6bnlf4smcsnsbl5rv8dvk796r34azgj"
            '("@sentry/electron" "."))
    (github "getsentry/sentry-javascript"
            "9ffb58c0a25b83de61490280333f98eda5366914"
            "0fav7vfl1pvgm3ra57ikh0cg0hcmrb3q6w228mhpcclwwx5f64bw"
            '("@sentry/browser" "packages/browser")
            '("@sentry/browser-utils" "packages/browser-utils")
            '("@sentry/core" "packages/core")
            '("@sentry/feedback" "packages/feedback")
            '("@sentry/node" "packages/node")
            '("@sentry/node-core" "packages/node-core")
            '("@sentry/opentelemetry" "packages/opentelemetry")
            '("@sentry/replay" "packages/replay-internal")
            '("@sentry/replay-canvas" "packages/replay-canvas")
            '("@sentry/server-utils" "packages/server-utils"))
    (tarball "https://registry.npmjs.org/@protontech/crypto/-/crypto-2.2.0.tgz"
            "crypto-2.2.0.tgz"
            "1r7avnk3s75xz27jzap53g4ccx31k5qfkv60hqzigikjxlkk6lkb"
            '("@protontech/crypto" "."))
    (tarball "https://registry.npmjs.org/concat-map/-/concat-map-0.0.1.tgz"
            "concat-map-0.0.1.tgz"
            "0qa2zqn9rrr2fqdki44s4s2dk2d8307i4556kv25h06g43b2v41m"
            '("concat-map" "."))
    (github "isaacs/fs.realpath"
            "03e7c884431fe185dfebbc9b771aeca339c1807a"
            "19xwfxbg3fklflfcd2qqgmf5xy4x36vg3g6qbsz3pnva0xvl25sb"
            '("fs.realpath" "."))
    (github "isaacs/inherits"
            "9a2c29400c6d491e0b7beefe0c32efa3b462545d"
            "114mbsa6rw9smja5zvip6x69v16dhvwxv3f7r8z5rpcsx493hk4r"
            '("inherits" "."))
    (github "isaacs/minimatch"
            "7bba97888a27a6162983056bcce2a6e28f668712"
            "04xzvakqc3mhj5iypdv1wqc1nq78h30a563jspn95rxygi723gsd"
            '("minimatch" "."))
    (github "isaacs/node-glob"
            "c3cd57ae128faa0e9190492acc743bb779ac4054"
            "0q7y8914vzkpi5clzskkl987m0zn2ygldqbmpybsannf0baa86p1"
            '("glob" "."))
    (github "isaacs/node-graceful-fs"
            "514861c372899df14beb7aaecca4cdbb498d7d11"
            "1sqwclsdhhr1flvskkl7dr3pdk61fmabacscnnvdlm8jabc4qh7f"
            '("graceful-fs" "."))
    (github "isaacs/once"
            "0e614d9f5a7e6f0305c625f6b581f6d80b33b8a6"
            "18m4wqwiw545y21kvp98y3ikk4bm4hy1h5wdzx4mdrkfaal7r4w4"
            '("once" "."))
    (github "jonschlinkert/author-regex"
            "e76ce20fafcf4610faab13756f3aa2fd734cf9d5"
            "0a47166r87px50k84irqzwzgysxif2gdypm2bhgz6dskdkrmam8z"
            '("author-regex" "."))
    (github "jonschlinkert/parse-author"
            "dc5528d371661331006cfb5b8301f151a5071f49"
            "064klqay2gfwxr4420kl3w00f408zrgjjxhjjv1ki1fj0sgqv7cx"
            '("parse-author" "."))
    (github "jprichardson/node-fs-extra"
            "1625838cdfc65a1bbf28ab5fa962a75805629b9c"
            "1hpqffzv9jkk5i5hblwwb27d3r515vr8d6dqcvhsmm20nx5zb38h"
            '("fs-extra" "."))
    (github "jprichardson/node-jsonfile"
            "9c6478a85899a9318547a6e9514b0403166d8c5c"
            "1iq8rbqjwadryvvm2skid6slhrp9422fqdkmdcxj82lk59fn2hgs"
            '("jsonfile" "."))
    (github "juliangruber/balanced-match"
            "c7412e09b95d6ad97fd1e2996f6adca7626a9ae8"
            "1xykahlp8rfx47wkmwggawcbx04ibxb8q7ah6yi5daf64jz5mszf"
            '("balanced-match" "."))
    (github "juliangruber/brace-expansion"
            "8e81e187b6e9c6c723d16c042657c00acefc2483"
            "01mhdsv9kd3wpr9zhrl80ahr3402aywc5fah40sm2b4cddzm50cp"
            '("brace-expansion" "."))
    (github "lodash/lodash"
            "4f0b76e2eca13de1c1fe8b4305abc1f7d63f4b86"
            "1g215yacjh2lkbjrhyiq9vyd8kda8ccgipy0hbiwl21y9niywvmb"
            '("lodash" "."))
    (github "mdn/data"
            "7ccf3c5d61da1c5e2cbb5c11d7ccb1147fcccff2"
            "0y8n5aaakznmc3b8crgs4dbzaj82d29ch2z334p2g3aayxpjsbmn"
            '("mdn-data" "."))
    (github "megahertz/electron-log"
            "afa8fc22911c2b57e2a1ca870bc83ae229f7547d"
            "01khq2vsqwjc5rrky1h382cjflhhn94yn9vggmvzavywvy1x03v2"
            '("electron-log" "."))
    (github "minimistjs/minimist"
            "6901ee286bc4c16da6830b48b46ce1574703cea1"
            "0knpj5kwqc8xr3vmsq3yjsqjs4dc20fmdwymmi6y71dlgqq82zrc"
            '("minimist" "."))
    (github "nodejs/import-in-the-middle"
            "f67383cbf48ade6ca9642c9f892e696ad885ed30"
            "18rkw052sy94dmc36i72xddrc0qiz1jq8sjlzdlrbfq3qi25kh8s"
            '("import-in-the-middle" "."))
    (github "nodejs/require-in-the-middle"
            "2d6cbd8f213cd51727ed6b7cee342b10b7e1456f"
            "0x6bj5lx37nrkplpa0v1m6zmjixiad6wnqhqsalk398ifrb14vvk"
            '("require-in-the-middle" "."))
    (github "npm/inflight"
            "a547881738c8f57b27795e584071d67cf6ac1a57"
            "0i278cakz9h03xki11s0kjprff5gqhr2s4v7im8wrrnfsvrs2fhh"
            '("inflight" "."))
    (github "npm/node-semver"
            "6e05b7637396ac66522cff8731f07cfe0ef49a29"
            "0asfh5cc7q6wxswxqjd0qnw1kgwanqgicpnf8k06r6vin2ps399h"
            '("semver" "."))
    (github "npm/wrappy"
            "71d91b6dc5bdeac37e218c2cf03f9ab55b60d214"
            "0ghbanp0ihb2pvai7p94flazpl3iqrs0ajxr5q248758wazlvi6l"
            '("wrappy" "."))
    (github "olado/doT"
            "6adbd819970d9093aa2ea24fcf56c7e370d9a468"
            "0hlmjj6vmk0wmphjvgqx68b0y3kaxh1m6031grm3khm3ljpbhc9l"
            '("dot" "."))
    (github "open-telemetry/opentelemetry-js"
            "40d67b7690a61bd9af0a4e5b5b9f4a14b11fc50e"
            "0bbnzh9s5hhmniz00f6ja2q0yibjgsqvpm87wwy8pj6knva5lwvd"
            '("@opentelemetry/api-logs" "experimental/packages/api-logs")
            '("@opentelemetry/instrumentation" "experimental/packages/opentelemetry-instrumentation"))
    (github "open-telemetry/opentelemetry-js"
            "76fa6b509e2b48d9cbee31cb37a2efc61dc4d384"
            "1f4hi4k4wk2nx33g19cgjzy76sk9g6pkq91cwsvi0yvzyi6xl171"
            '("@opentelemetry/core" "packages/opentelemetry-core")
            '("@opentelemetry/resources" "packages/opentelemetry-resources")
            '("@opentelemetry/sdk-trace" "packages/sdk-trace")
            '("@opentelemetry/sdk-trace-base" "packages/opentelemetry-sdk-trace-base"))
    (github "open-telemetry/opentelemetry-js"
            "7e74509a4d848e94b2970bb5262dd3e8efeed0a2"
            "0jj1kh6cyrx66apsvlxz1zb9sq9yxpklfa7x056zj956fm12s50z"
            '("@opentelemetry/api" "api"))
    (github "open-telemetry/opentelemetry-js"
            "ed6bd6d5f3a1f68b65ae25b1a8aae9c285ae83de"
            "1jswv7r095zcz4ak2nnms9wbm4zqghl62mg3zzb66yg4dgwa2cq4"
            '("@opentelemetry/semantic-conventions" "semantic-conventions"))
    (github "segmentio/is-url"
            "d20482833e861b9a0c5bb3712dfe232efa75c87c"
            "08n9pfspbbfrfzr1p2vkc13q9zrn6z4y2qqgsmplh7f5zsrksg4m"
            '("is-url" "."))
    (github "sindresorhus/conf"
            "00b0afad8e9544458d3f664711e8b60031ad2597"
            "1jk2iv41xysy1m3aj5j39pih0r2979x2lxsvh32xqv9wkff6jj1r"
            '("conf" "."))
    (github "sindresorhus/debounce-fn"
            "5c4e89ba031e039b7d23eafce148689b4a591cd4"
            "06qcfqv1w3kgrgj1hayjq5z9avr14zyz788hnqzwscisgd05r3lz"
            '("debounce-fn" "."))
    (github "sindresorhus/dot-prop"
            "badea8a415fe6d53d88711bb586c2b9966bfd9db"
            "0j8mvhy2vhf2gq8l4gxzvrl7bhbr5gz1v2lgzhqh7pdj2j2bm39p"
            '("dot-prop" "."))
    (github "sindresorhus/electron-store"
            "449b5ee30c2b449778e33829e86d2e82ae0355aa"
            "0l8cjh9xa884sd63mbc61vsic0w7bzs0w8vaiqvhvxb1zdih43q8"
            '("electron-store" "."))
    (github "sindresorhus/env-paths"
            "62d4ec8cd42f1a419e00856fab949ca8286773f6"
            "01pizm6k1yz7z6bngkg8cp5wafgjldwqlx4c70sk3wc0jfpgj1vl"
            '("env-paths" "."))
    (github "sindresorhus/find-up"
            "2319b79a9e728fc13fc1a1a15e84bf5df100719e"
            "17mx4z0d67594jb9f1jwv4lkvwvkjc8dap6vh6fgx04s8hj7di3p"
            '("find-up" "."))
    (github "sindresorhus/has-flag"
            "474aa39afca7333d356c022fc5be4d31732bbba3"
            "0qxdq95mhzm260py5gx523lga5sgsizh7bzdawd52ibj4ppjnp0y"
            '("has-flag" "."))
    (github "sindresorhus/is-obj"
            "65347b53b6a013900c4ea2fa9920ce6fb366a2ed"
            "0v9b0x31jf7lhsjm07vhpn54bnq5al9k218mh4m3j9v9w6hp4bfx"
            '("is-obj" "."))
    (github "sindresorhus/locate-path"
            "d6f19ffa31544161ee94118963deb3b683418151"
            "1ahj5df89hv01ywj3mwvm43ayqkb5z1gyywwkjrjllnp4g6rxj3n"
            '("locate-path" "."))
    (github "sindresorhus/mimic-fn"
            "d29f5387f4c19814a042d03a780ff4481ceac5a3"
            "16avcdmnc7dkia5vx0mhfcpk21qvxmi45hhr8g9ysv8g8rnp0knw"
            '("mimic-fn" "."))
    (github "sindresorhus/mimic-fn"
            "4c3a864d4e7bdcf8ce77409954d68fb20c538d5b"
            "0sp4pwvbm2xs0bnlj849vbp6an9sby7vmflhp3inlbin4inzgkjd"
            '("debounce-fn/node_modules/mimic-fn" "."))
    (github "sindresorhus/onetime"
            "4fa3c9a40798476514fec36a1720dc85b897cc04"
            "13whwl3xy1kmdx3m9lzk4zqbfi2g2xsrykgxza8i0y9sffn68dxh"
            '("onetime" "."))
    (github "sindresorhus/p-limit"
            "a11f02bc5c04490b7c3de2663d866c211fb915ea"
            "0p38chvlbn3b3i4zvhvm8pibk804hsh2d8g5457xapmli8j9arwj"
            '("p-limit" "."))
    (github "sindresorhus/p-locate"
            "d37f108c0b04779e307b4e7203981caa367bac57"
            "0nlhfknkz99vznawwb8c7cm8kp8a6m9g33xsra078f5rbkffvbm8"
            '("p-locate" "."))
    (github "sindresorhus/p-try"
            "17871e692badec152b6c98bc94981820eda9b92c"
            "0p617a3dalln8397hqv6q1nb9z06kxqz5fj667pwrx3kzvyw7n8i"
            '("p-try" "."))
    (github "sindresorhus/path-exists"
            "4696c60a8b2b9ac61902aa9eab7cb326ab6005c8"
            "15d3niyah2787lh7qrp34zcsx2msi7hh2ifk35ywkhz71xg7fplc"
            '("path-exists" "."))
    (github "sindresorhus/path-is-absolute"
            "edc91d348b21dac2ab65ea2fbec2868e2eff5eb6"
            "0aijda221ygck9sgbxk695qgjh0s4fy13rfd96rckmn1lsx77fa2"
            '("path-is-absolute" "."))
    (github "sindresorhus/pkg-up"
            "9166b423d53ffef572eedf7b62926dcc199df0ae"
            "10q1n2gjvdgx96gxk8kw1gafm6rrgmbs52xz6yb0xapl8y8cam6q"
            '("pkg-up" "."))
    (github "sindresorhus/yocto-queue"
            "af91c37f51aecf607ca2261b907b9d86b6a69e77"
            "0r324hlgqqcwss6gwq04b2yxhz6pw2lxmljs3lzqmqgygjpjl1rd"
            '("yocto-queue" "."))
    (github "ttag-org/ttag"
            "c248acd8eb89bb79e6f09137f33e42b193668cce"
            "09zv2c043zayiz8sbz7bb6s0562shnh93y595ilwjblpfgzfry3a"
            '("ttag" "."))
    (github "vercel/ms"
            "1c6264b795492e8fdecbc82cb8802fcfbfc08d26"
            "07pqdmddms8pcn1av56l75kqr2b4pnf102gdbcjng07nnhpyamx4"
            '("ms" "."))
    (github "watson/module-details-from-path"
            "a7df269d5eb0803bb26ab61cb486f7c1fb4fad9c"
            "125wixxm68x2vslxh3891anrvmdbws4n36dc81lccyyram27lhjg"
            '("module-details-from-path" "."))
    (github "zeke/github-url-to-object"
            "1d041780e2f41b9b0239d5a498072839daaf78c7"
            "1xvpkz1fjvrxn56za3rggjdvy2z5lmkhg3a3wicak6l4shnc7y24"
            '("github-url-to-object" "."))))
