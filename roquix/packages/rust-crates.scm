(define-module (roquix packages rust-crates)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust-crates)
  #:export (lookup-cargo-inputs))

(define rust-ab-glyph-0.2.31
  (crate-source "ab_glyph" "0.2.31"
                "0zgf2ax3incf7x0cpm4r82fzhym4mbzjy9i6f5md2655h12lcx70"))

(define rust-ab-glyph-rasterizer-0.1.10
  (crate-source "ab_glyph_rasterizer" "0.1.10"
                "065n6bj7kqk6f12336lm87fqmvf4lxg7rkg2j56nix228jmgnvrn"))

(define rust-accesskit-0.19.0
  (crate-source "accesskit" "0.19.0"
                "06r77dr1lij2dh7fq1mll8kdwq14i327qvbr0zgzbgb0096fhnp2"))

(define rust-addr2line-0.24.2
  (crate-source "addr2line" "0.24.2"
                "1hd1i57zxgz08j6h5qrhsnm2fi0bcqvsh389fw400xm3arz2ggnz"))

(define rust-adler2-2.0.1
  (crate-source "adler2" "2.0.1"
                "1ymy18s9hs7ya1pjc9864l30wk8p2qfqdi7mhhcc5nfakxbij09j"))

(define rust-ahash-0.8.12
  (crate-source "ahash" "0.8.12"
                "0xbsp9rlm5ki017c0w6ay8kjwinwm8knjncci95mii30rmwz25as"))

(define rust-aho-corasick-1.1.3
  (crate-source "aho-corasick" "1.1.3"
                "05mrpkvdgp5d20y2p989f187ry9diliijgwrs254fs9s1m1x6q4f"))

(define rust-android-activity-0.6.0
  (crate-source "android-activity" "0.6.0"
                "0inh88x8x2fh62jg739s9hwyvdh8i920qf0qw7bhr802j9c7hsgg"))

(define rust-android-properties-0.2.2
  (crate-source "android-properties" "0.2.2"
                "016slvg269c0y120p9qd8vdfqa2jbw4j0g18gfw6p3ain44v4zpw"))

(define rust-android-system-properties-0.1.5
  (crate-source "android_system_properties" "0.1.5"
                "04b3wrz12837j7mdczqd95b732gw5q7q66cv4yn4646lvccp57l1"))

(define rust-android-tzdata-0.1.1
  (crate-source "android-tzdata" "0.1.1"
                "1w7ynjxrfs97xg3qlcdns4kgfpwcdv824g611fq32cag4cdr96g9"))

(define rust-anstream-0.6.19
  (crate-source "anstream" "0.6.19"
                "0crr9a207dyn8k66xgvhvmlxm9raiwpss3syfa35c6265s9z26ih"))

(define rust-anstyle-1.0.11
  (crate-source "anstyle" "1.0.11"
                "1gbbzi0zbgff405q14v8hhpi1kz2drzl9a75r3qhks47lindjbl6"))

(define rust-anstyle-parse-0.2.7
  (crate-source "anstyle-parse" "0.2.7"
                "1hhmkkfr95d462b3zf6yl2vfzdqfy5726ya572wwg8ha9y148xjf"))

(define rust-anstyle-query-1.1.3
  (crate-source "anstyle-query" "1.1.3"
                "1sgs2hq54wayrmpvy784ww2ccv9f8yhhpasv12z872bx0jvdx2vc"))

(define rust-anstyle-wincon-3.0.9
  (crate-source "anstyle-wincon" "3.0.9"
                "10n8mcgr89risdf35i73zc67aaa392bhggwzqlri1fv79297ags0"))

(define rust-anyhow-1.0.98
  (crate-source "anyhow" "1.0.98"
                "11ylvjdrcjs0q9jgk1af4r5cx1qppj63plxqkq595vmc24rjsvg1"))

(define rust-arboard-3.6.1
  (crate-source "arboard" "3.6.1"
                "1byx6q5iipxkb0pyjp80k7c4akp4n5m7nsmqdbz4n7s9ak0a2j03"))

(define rust-arc-swap-1.7.1
  (crate-source "arc-swap" "1.7.1"
                "0mrl9a9r9p9bln74q6aszvf22q1ijiw089jkrmabfqkbj31zixv9"))

(define rust-arrayvec-0.7.6
  (crate-source "arrayvec" "0.7.6"
                "0l1fz4ccgv6pm609rif37sl5nv5k6lbzi7kkppgzqzh1vwix20kw"))

(define rust-as-raw-xcb-connection-1.0.1
  (crate-source "as-raw-xcb-connection" "1.0.1"
                "0sqgpz2ymv5yx76r5j2npjq2x5qvvqnw0vrs35cyv30p3pfp2m8p"))

(define rust-ash-0.38.0+1.3.281
  (crate-source "ash" "0.38.0+1.3.281"
                "0vx4yf689v1rc680jvy8bnysx5sgd8f33wnp2vqaizh0v0v4kd0b"))

(define rust-atomic-waker-1.1.2
  (crate-source "atomic-waker" "1.1.2"
                "1h5av1lw56m0jf0fd3bchxq8a30xv0b4wv8s4zkp4s0i7mfvs18m"))

(define rust-autocfg-1.5.0
  (crate-source "autocfg" "1.5.0"
                "1s77f98id9l4af4alklmzq46f21c980v13z2r1pcxx6bqgw0d1n0"))

(define rust-backtrace-0.3.75
  (crate-source "backtrace" "0.3.75"
                "00hhizz29mvd7cdqyz5wrj98vqkihgcxmv2vl7z0d0f53qrac1k8"))

(define rust-base64-0.22.1
  (crate-source "base64" "0.22.1"
                "1imqzgh7bxcikp5vx3shqvw9j09g9ly0xr0jma0q66i52r7jbcvj"))

(define rust-basic-toml-0.1.10
  (crate-source "basic-toml" "0.1.10"
                "12hp59jl28kk229q4sqx6v4fc9p66v8i2byi0vlc9922h9g6fqms"))

(define rust-better-panic-0.3.0
  (crate-source "better-panic" "0.3.0"
                "0djh7qs39z0mbkzxs4nrc9ngnyjpsxq67lqfv75q91i63b8y3abg"))

(define rust-bindgen-0.72.0
  (crate-source "bindgen" "0.72.0"
                "0vvjgfw3rq2lw163qahjdr0qr14bj4lm23syk9hhp39i6jbj0wjg"))

(define rust-bit-set-0.8.0
  (crate-source "bit-set" "0.8.0"
                "18riaa10s6n59n39vix0cr7l2dgwdhcpbcm97x1xbyfp1q47x008"))

(define rust-bit-vec-0.8.0
  (crate-source "bit-vec" "0.8.0"
                "1xxa1s2cj291r7k1whbxq840jxvmdsq9xgh7bvrxl46m80fllxjy"))

(define rust-bitflags-1.3.2
  (crate-source "bitflags" "1.3.2"
                "12ki6w8gn1ldq7yz9y680llwk5gmrhrzszaa17g1sbrw2r2qvwxy"))

(define rust-bitflags-2.9.1
  (crate-source "bitflags" "2.9.1"
                "0rz9rpp5wywwqb3mxfkywh4drmzci2fch780q7lifbf6bsc5d3hv"))

(define rust-bitflags-2.9.3
  (crate-source "bitflags" "2.9.3"
                "0pgjwsd9qgdmsmwpvg47p9ccrsc26yfjqawbhsi9qds5sg6brvrl"))

(define rust-block-buffer-0.10.4
  (crate-source "block-buffer" "0.10.4"
                "0w9sa2ypmrsqqvc20nhwr75wbb5cjr4kkyhpjm1z1lv2kdicfy1h"))

(define rust-block2-0.5.1
  (crate-source "block2" "0.5.1"
                "0pyiha5his2grzqr3mynmq244laql2j20992i59asp0gy7mjw4rc"))

(define rust-bstr-1.12.0
  (crate-source "bstr" "1.12.0"
                "195i0gd7r7jg7a8spkmw08492n7rmiabcvz880xn2z8dkp8i6h93"))

(define rust-bumpalo-3.19.0
  (crate-source "bumpalo" "3.19.0"
                "0hsdndvcpqbjb85ghrhska2qxvp9i75q2vb70hma9fxqawdy9ia6"))

(define rust-bytemuck-1.23.2
  (crate-source "bytemuck" "1.23.2"
                "0xs637lsr9p73ackjkmbjw80dp1dfdw0ydhdk0gzjcnzpkpfm59r"))

(define rust-bytemuck-derive-1.10.1
  (crate-source "bytemuck_derive" "1.10.1"
                "0a9dczfzn2c1lgg7afhqrh2drmg34w49hxhipni6pjri49blw5ag"))

(define rust-byteorder-1.5.0
  (crate-source "byteorder" "1.5.0"
                "0jzncxyf404mwqdbspihyzpkndfgda450l0893pz5xj685cg5l0z"))

(define rust-byteorder-lite-0.1.0
  (crate-source "byteorder-lite" "0.1.0"
                "15alafmz4b9az56z6x7glcbcb6a8bfgyd109qc3bvx07zx4fj7wg"))

(define rust-bytes-1.10.1
  (crate-source "bytes" "1.10.1"
                "0smd4wi2yrhp5pmq571yiaqx84bjqlm1ixqhnvfwzzc6pqkn26yp"))

(define rust-calloop-0.13.0
  (crate-source "calloop" "0.13.0"
                "1v5zgidnhsyml403rzr7vm99f8q6r5bxq5gxyiqkr8lcapwa57dr"))

(define rust-calloop-wayland-source-0.3.0
  (crate-source "calloop-wayland-source" "0.3.0"
                "086x5mq16prrcwd9k6bw9an0sp8bj9l5daz4ziz5z4snf2c6m9lm"))

(define rust-castaway-0.2.4
  (crate-source "castaway" "0.2.4"
                "0nn5his5f8q20nkyg1nwb40xc19a08yaj4y76a8q2y3mdsmm3ify"))

(define rust-cc-1.2.30
  (crate-source "cc" "1.2.30"
                "1rqs46vb04ffqlpi6kjwfmvvvf64y6jkdn1faql30sfa0yb11v6y"))

(define rust-cc-1.2.35
  (crate-source "cc" "1.2.35"
                "18vfhd6njr0lhfvfvxchj3bay4fw6hcpyy4130sl134alqj903sr"))

(define rust-cesu8-1.1.0
  (crate-source "cesu8" "1.1.0"
                "0g6q58wa7khxrxcxgnqyi9s1z2cjywwwd3hzr5c55wskhx6s0hvd"))

(define rust-cexpr-0.6.0
  (crate-source "cexpr" "0.6.0"
                "0rl77bwhs5p979ih4r0202cn5jrfsrbgrksp40lkfz5vk1x3ib3g"))

(define rust-cfg-aliases-0.2.1
  (crate-source "cfg_aliases" "0.2.1"
                "092pxdc1dbgjb6qvh83gk56rkic2n2ybm4yvy76cgynmzi3zwfk1"))

(define rust-cfg-if-1.0.1
  (crate-source "cfg-if" "1.0.1"
                "0s0jr5j797q1vqjcd41l0v5izlmlqm7lxy512b418xz5r65mfmcm"))

(define rust-cfg-if-1.0.3
  (crate-source "cfg-if" "1.0.3"
                "1afg7146gbxjvkbjx7i5sdrpqp9q5akmk9004fr8rsm90jf2il9g"))

(define rust-cgl-0.3.2
  (crate-source "cgl" "0.3.2"
                "1zs7skrsyrsm759vfy2cygkx52fx91b567a12bpaz1sf4d8hbv8c"))

(define rust-chrono-0.4.41
  (crate-source "chrono" "0.4.41"
                "0k8wy2mph0mgipq28vv3wirivhb31pqs7jyid0dzjivz0i9djsf4"))

(define rust-clang-sys-1.8.1
  ;; TODO: Check bundled sources.
  (crate-source "clang-sys" "1.8.1"
                "1x1r9yqss76z8xwpdanw313ss6fniwc1r7dzb5ycjn0ph53kj0hb"))

(define rust-clap-4.5.41
  (crate-source "clap" "4.5.41"
                "1ydd3a22bxkn2a7bajnw57cwjhawqciyhz2x3rqm8fi4h0pd74my"))

(define rust-clap-builder-4.5.41
  (crate-source "clap_builder" "4.5.41"
                "0g8w6da5y13kv93psl8c00c7f4q01753wmwx84wr2bv2x50snzkh"))

(define rust-clap-complete-4.5.55
  (crate-source "clap_complete" "4.5.55"
                "16i2qv263ndlmnms4vyzdqiqd7y4cqdqz3wbpv2p1bvd912dxax5"))

(define rust-clap-derive-4.5.41
  (crate-source "clap_derive" "4.5.41"
                "14glxqpfjs7z6m37f3ycrhgdkpyqmgwbr4vk1y34rjjrd8w54kzg"))

(define rust-clap-lex-0.7.5
  (crate-source "clap_lex" "0.7.5"
                "0xb6pjza43irrl99axbhs12pxq4sr8x7xd36p703j57f5i3n2kxr"))

(define rust-clipboard-win-5.4.1
  (crate-source "clipboard-win" "5.4.1"
                "1m44gqy11rq1ww7jls86ppif98v6kv2wkwk8p17is86zsdq3gq5x"))

(define rust-clru-0.6.2
  (crate-source "clru" "0.6.2"
                "0ngyycxpxif84wpjjn0ixywylk95h5iv8fqycg2zsr3f0rpggl6b"))

(define rust-codespan-reporting-0.12.0
  (crate-source "codespan-reporting" "0.12.0"
                "108g41xqzhr8fx8hlpy5qzmqq8ylldbj37wndkaqm34yy1d2wvgy"))

(define rust-colorchoice-1.0.4
  (crate-source "colorchoice" "1.0.4"
                "0x8ymkz1xr77rcj1cfanhf416pc4v681gmkc9dzb3jqja7f62nxh"))

(define rust-combine-4.6.7
  (crate-source "combine" "4.6.7"
                "1z8rh8wp59gf8k23ar010phgs0wgf5i8cx4fg01gwcnzfn5k0nms"))

(define rust-compact-str-0.8.1
  (crate-source "compact_str" "0.8.1"
                "0cmgp61hw4fwaakhilwznfgncw2p4wkbvz6dw3i7ibbckh3c8y9v"))

(define rust-concurrent-queue-2.5.0
  (crate-source "concurrent-queue" "2.5.0"
                "0wrr3mzq2ijdkxwndhf79k952cp4zkz35ray8hvsxl96xrx1k82c"))

(define rust-console-0.15.11
  (crate-source "console" "0.15.11"
                "1n5gmsjk6isbnw6qss043377kln20lfwlmdk3vswpwpr21dwnk05"))

(define rust-core-foundation-0.10.1
  (crate-source "core-foundation" "0.10.1"
                "1xjns6dqf36rni2x9f47b65grxwdm20kwdg9lhmzdrrkwadcv9mj"))

(define rust-core-foundation-0.9.4
  (crate-source "core-foundation" "0.9.4"
                "13zvbbj07yk3b61b8fhwfzhy35535a583irf23vlcg59j7h9bqci"))

(define rust-core-foundation-sys-0.8.7
  ;; TODO: Check bundled sources.
  (crate-source "core-foundation-sys" "0.8.7"
                "12w8j73lazxmr1z0h98hf3z623kl8ms7g07jch7n4p8f9nwlhdkp"))

(define rust-core-graphics-0.23.2
  (crate-source "core-graphics" "0.23.2"
                "10dhv3gk4kmbzl14xxkrhhky4fdp8h6nzff6h0019qgr6nz84xy0"))

(define rust-core-graphics-types-0.1.3
  (crate-source "core-graphics-types" "0.1.3"
                "1bxg8nxc8fk4kxnqyanhf36wq0zrjr552c58qy6733zn2ihhwfa5"))

(define rust-cpufeatures-0.2.17
  (crate-source "cpufeatures" "0.2.17"
                "10023dnnaghhdl70xcds12fsx2b966sxbxjq5sxs49mvxqw5ivar"))

(define rust-crc32fast-1.5.0
  (crate-source "crc32fast" "1.5.0"
                "04d51liy8rbssra92p0qnwjw8i9rm9c4m3bwy19wjamz1k4w30cl"))

(define rust-crossbeam-channel-0.5.15
  (crate-source "crossbeam-channel" "0.5.15"
                "1cicd9ins0fkpfgvz9vhz3m9rpkh6n8d3437c3wnfsdkd3wgif42"))

(define rust-crossbeam-utils-0.8.21
  (crate-source "crossbeam-utils" "0.8.21"
                "0a3aa2bmc8q35fb67432w16wvi54sfmb69rk9h5bhd18vw0c99fh"))

(define rust-crossterm-0.28.1
  (crate-source "crossterm" "0.28.1"
                "1im9vs6fvkql0sr378dfr4wdm1rrkrvr22v4i8byz05k1dd9b7c2"))

(define rust-crossterm-winapi-0.9.1
  (crate-source "crossterm_winapi" "0.9.1"
                "0axbfb2ykbwbpf1hmxwpawwfs8wvmkcka5m561l7yp36ldi7rpdc"))

(define rust-crunchy-0.2.4
  (crate-source "crunchy" "0.2.4"
                "1mbp5navim2qr3x48lyvadqblcxc1dm0lqr0swrkkwy2qblvw3s6"))

(define rust-crypto-common-0.1.6
  (crate-source "crypto-common" "0.1.6"
                "1cvby95a6xg7kxdz5ln3rl9xh66nz66w46mm3g56ri1z5x815yqv"))

(define rust-cursive-0.21.1
  (crate-source "cursive" "0.21.1"
                "0bjkmbyy5ivvvgjblmqq5lkb1mlvdi78mjsflglmdf0b08v5lv9q"))

(define rust-cursive-core-0.4.6
  (crate-source "cursive_core" "0.4.6"
                "0my2kjghn3i0zkw4yc4mj1yvsn48bw1d0d10h5pcdbvzs9scf7ij"))

(define rust-cursive-macros-0.1.0
  (crate-source "cursive-macros" "0.1.0"
                "0gm7l3xzqsgwh4sd0py2g45p6np0ahiz5mglxggxzqzd1kmw0ymc"))

(define rust-cursor-icon-1.2.0
  (crate-source "cursor-icon" "1.2.0"
                "0bvkw7ak1mqwcpkgd9lh7n00hcvlh87jfl7188f231nz6zfy2ypj"))

(define rust-darling-0.21.3
  (crate-source "darling" "0.21.3"
                "1h281ah78pz05450r71h3gwm2n24hy8yngbz58g426l4j1q37pww"))

(define rust-darling-core-0.21.3
  (crate-source "darling_core" "0.21.3"
                "193ya45qgac0a4siwghk0bl8im8h89p3cald7kw8ag3yrmg1jiqj"))

(define rust-darling-macro-0.21.3
  (crate-source "darling_macro" "0.21.3"
                "10ac85n4lnx3rmf5rw8lijl2c0sbl6ghcpgfmzh0s26ihbghi0yk"))

(define rust-deranged-0.5.3
  (crate-source "deranged" "0.5.3"
                "1k473y8lzjac956dm3s1cs2rz364py9zd52y9fkbanws8b6vqc6n"))

(define rust-digest-0.10.7
  (crate-source "digest" "0.10.7"
                "14p2n6ih29x81akj097lvz7wi9b6b9hvls0lwrv7b6xwyy0s5ncy"))

(define rust-dirs-6.0.0
  (crate-source "dirs" "6.0.0"
                "0knfikii29761g22pwfrb8d0nqpbgw77sni9h2224haisyaams63"))

(define rust-dirs-sys-0.5.0
  ;; TODO: Check bundled sources.
  (crate-source "dirs-sys" "0.5.0"
                "1aqzpgq6ampza6v012gm2dppx9k35cdycbj54808ksbys9k366p0"))

(define rust-dispatch-0.2.0
  (crate-source "dispatch" "0.2.0"
                "0fwjr9b7582ic5689zxj8lf7zl94iklhlns3yivrnv8c9fxr635x"))

(define rust-dispatch2-0.3.0
  (crate-source "dispatch2" "0.3.0"
                "1v1ak9w0s8z1g13x4mj2y5im9wmck0i2vf8f8wc9l1n6lqi9z849"))

(define rust-displaydoc-0.2.5
  (crate-source "displaydoc" "0.2.5"
                "1q0alair462j21iiqwrr21iabkfnb13d6x5w95lkdg21q2xrqdlp"))

(define rust-dlib-0.5.2
  (crate-source "dlib" "0.5.2"
                "04m4zzybx804394dnqs1blz241xcy480bdwf3w9p4k6c3l46031k"))

(define rust-document-features-0.2.11
  (crate-source "document-features" "0.2.11"
                "0pdhpbz687fk2rkgz45yy3gvbhlxliwb7g1lj3jbx1f1qr89n94m"))

(define rust-downcast-rs-1.2.1
  (crate-source "downcast-rs" "1.2.1"
                "1lmrq383d1yszp7mg5i7i56b17x2lnn3kb91jwsq0zykvg2jbcvm"))

(define rust-dpi-0.1.2
  (crate-source "dpi" "0.1.2"
                "0xhsvzgjvdch2fwmfc9vkb708b0q59b6imypyjlgbiigyb74rcfq"))

(define rust-dunce-1.0.5
  (crate-source "dunce" "1.0.5"
                "04y8wwv3vvcqaqmqzssi6k0ii9gs6fpz96j5w9nky2ccsl23axwj"))

(define rust-ecolor-0.32.1
  (crate-source "ecolor" "0.32.1"
                "08plb55cwn0mhvl4va5r81680ng1fx0zir1cdfb5dvy2f8qzr9xn"))

(define rust-eframe-0.32.1
  (crate-source "eframe" "0.32.1"
                "1fb4i4jpjcfdf22bgmqmsw418axbzpjg9gw42rz19903vj07l0rl"))

(define rust-egui-0.32.1
  (crate-source "egui" "0.32.1"
                "19qrx5pfm5w63dw12cc3wbpiyjf7bmpxr7x3njb58wbp5w4bxqj9"))

(define rust-egui-glow-0.32.1
  (crate-source "egui_glow" "0.32.1"
                "08rwzr5mjwrwbn2m2hsm7gsac2a5yk65qfi8f2mjxr4809v4bdha"))

(define rust-egui-plot-0.33.0
  (crate-source "egui_plot" "0.33.0"
                "08aixl9q28bvycpkrc1nsszgkqyri9gris1qqy0hracf3821hhsj"))

(define rust-egui-wgpu-0.32.1
  (crate-source "egui-wgpu" "0.32.1"
                "04hjsqbbqgz875nkim9li0ssjfhvz85kpnqd108vgh8y2xx2giv4"))

(define rust-egui-winit-0.32.1
  (crate-source "egui-winit" "0.32.1"
                "1455i09qfhbhzpb0w7wkvam0hffcp81kyd2fg4zd9r3dil7qnvgy"))

(define rust-either-1.15.0
  (crate-source "either" "1.15.0"
                "069p1fknsmzn9llaizh77kip0pqmcwpdsykv2x30xpjyija5gis8"))

(define rust-emath-0.32.1
  (crate-source "emath" "0.32.1"
                "1qyxi2xmdfb6y0bjrm2d6hhy0yfwdlaxlyig5w9yzplgqiyzcpck"))

(define rust-encode-unicode-1.0.0
  (crate-source "encode_unicode" "1.0.0"
                "1h5j7j7byi289by63s3w4a8b3g6l5ccdrws7a67nn07vdxj77ail"))

(define rust-enum-map-2.7.3
  (crate-source "enum-map" "2.7.3"
                "1sgjgl4mmz93jdkfdsmapc3dmaq8gddagw9s0fd501w2vyzz6rk8"))

(define rust-enum-map-derive-0.17.0
  (crate-source "enum-map-derive" "0.17.0"
                "1sv4mb343rsz4lc3rh7cyn0pdhf7fk18k1dgq8kfn5i5x7gwz0pj"))

(define rust-enumn-0.1.14
  (crate-source "enumn" "0.1.14"
                "0f1gagm6841sih4ipw46c7gn1idjgqfay1f5q6hchdwjg2rxd7ig"))

(define rust-enumset-1.1.10
  (crate-source "enumset" "1.1.10"
                "0d168laidd53xjyl9qrwqfqycvcnrznzkgd6q1j01z5vzf6pmc15"))

(define rust-enumset-derive-0.14.0
  (crate-source "enumset_derive" "0.14.0"
                "1kmkv1bfimvjawm74zk1yfvjywkfwhrxk3p6mq7hcf539r778gpl"))

(define rust-env-logger-0.10.2
  (crate-source "env_logger" "0.10.2"
                "1005v71kay9kbz1d5907l0y7vh9qn2fqsp2yfgb8bjvin6m0bm2c"))

(define rust-epaint-0.32.1
  (crate-source "epaint" "0.32.1"
                "18q63q2mxcmnwpx7c7mzgw9a72na4vacffmxx5yr28nkm6jw0vxn"))

(define rust-epaint-default-fonts-0.32.1
  (crate-source "epaint_default_fonts" "0.32.1"
                "0fjabglyxp61xf1hnhxx6qskajlhv85n6pjgl85005xq1z7ghv2g"))

(define rust-equivalent-1.0.2
  (crate-source "equivalent" "1.0.2"
                "03swzqznragy8n0x31lqc78g2af054jwivp7lkrbrc0khz74lyl7"))

(define rust-errno-0.3.13
  (crate-source "errno" "0.3.13"
                "1bd5g3srn66zr3bspac0150bvpg1s7zi6zwhwhlayivciz12m3kp"))

(define rust-error-code-3.3.2
  (crate-source "error-code" "3.3.2"
                "0nacxm9xr3s1rwd6fabk3qm89fyglahmbi4m512y0hr8ym6dz8ny"))

(define rust-faster-hex-0.10.0
  (crate-source "faster-hex" "0.10.0"
                "0wzvv4a1czxfxmh99cza2y0jps97hm3k1j6r6cs816qp5wnsw8vj"))

(define rust-fastrand-2.3.0
  (crate-source "fastrand" "2.3.0"
                "1ghiahsw1jd68df895cy5h3gzwk30hndidn3b682zmshpgmrx41p"))

(define rust-fax-0.2.6
  (crate-source "fax" "0.2.6"
                "1ax0jmvsszxd03hj6ga1kyl7gaqcfw0akg2wf0q6gk9pizaffpgh"))

(define rust-fax-derive-0.2.0
  (crate-source "fax_derive" "0.2.0"
                "0zap434zz4xvi5rnysmwzzivig593b4ng15vwzwl7js2nw7s3b50"))

(define rust-fdeflate-0.3.7
  (crate-source "fdeflate" "0.3.7"
                "130ga18vyxbb5idbgi07njymdaavvk6j08yh1dfarm294ssm6s0y"))

(define rust-find-crate-0.6.3
  (crate-source "find-crate" "0.6.3"
                "1ljpkh11gj7940xwz47xjhsvfbl93c2q0ql7l2v0w77amjx8paar"))

(define rust-find-msvc-tools-0.1.0
  (crate-source "find-msvc-tools" "0.1.0"
                "0l4nnivhdigxd87drmahqq99qvz7479ad65syq1njwm2m3xy8y71"))

(define rust-flate2-1.1.2
  (crate-source "flate2" "1.1.2"
                "07abz7v50lkdr5fjw8zaw2v8gm2vbppc0f7nqm8x3v3gb6wpsgaa"))

(define rust-fluent-0.17.0
  (crate-source "fluent" "0.17.0"
                "0xq4cxw4mkdh1k9i5w850sky0m41la8sm6nbpw76n3f5lbascdw1"))

(define rust-fluent-bundle-0.16.0
  (crate-source "fluent-bundle" "0.16.0"
                "1x1v8bmym6x9pl87f82lbzwlc84kdn0lgcwi73ki2mwgj6w3q801"))

(define rust-fluent-langneg-0.13.0
  (crate-source "fluent-langneg" "0.13.0"
                "152yxplc11vmxkslvmaqak9x86xnavnhdqyhrh38ym37jscd0jic"))

(define rust-fluent-syntax-0.12.0
  (crate-source "fluent-syntax" "0.12.0"
                "1661sp6kl268n445x7jjhnbkgiaa1xcpyryq0i6iiz9zqn3x5w2l"))

(define rust-fnv-1.0.7
  (crate-source "fnv" "1.0.7"
                "1hc2mcqha06aibcaza94vbi81j6pr9a1bbxrxjfhc91zin8yr7iz"))

(define rust-foldhash-0.1.5
  (crate-source "foldhash" "0.1.5"
                "1wisr1xlc2bj7hk4rgkcjkz3j2x4dhd1h9lwk7mj8p71qpdgbi6r"))

(define rust-foreign-types-0.5.0
  (crate-source "foreign-types" "0.5.0"
                "0rfr2zfxnx9rz3292z5nyk8qs2iirznn5ff3rd4vgdwza6mdjdyp"))

(define rust-foreign-types-macros-0.2.3
  (crate-source "foreign-types-macros" "0.2.3"
                "0hjpii8ny6l7h7jpns2cp9589016l8mlrpaigcnayjn9bdc6qp0s"))

(define rust-foreign-types-shared-0.3.1
  (crate-source "foreign-types-shared" "0.3.1"
                "0nykdvv41a3d4py61bylmlwjhhvdm0b3bcj9vxhqgxaxnp5ik6ma"))

(define rust-form-urlencoded-1.2.1
  (crate-source "form_urlencoded" "1.2.1"
                "0milh8x7nl4f450s3ddhg57a3flcv6yq8hlkyk6fyr3mcb128dp1"))

(define rust-form-urlencoded-1.2.2
  (crate-source "form_urlencoded" "1.2.2"
                "1kqzb2qn608rxl3dws04zahcklpplkd5r1vpabwga5l50d2v4k6b"))

(define rust-generic-array-0.14.7
  (crate-source "generic-array" "0.14.7"
                "16lyyrzrljfq424c3n8kfwkqihlimmsg5nhshbbp48np3yjrqr45"))

(define rust-gethostname-1.0.2
  (crate-source "gethostname" "1.0.2"
                "0mdfkmfr41xx1i0nlwgzncmnj2a5f18kn6ydp7j1qc1q83dpy9gw"))

(define rust-getrandom-0.2.16
  (crate-source "getrandom" "0.2.16"
                "14l5aaia20cc6cc08xdlhrzmfcylmrnprwnna20lqf746pqzjprk"))

(define rust-getrandom-0.3.3
  (crate-source "getrandom" "0.3.3"
                "1x6jl875zp6b2b6qp9ghc84b0l76bvng2lvm8zfcmwjl7rb5w516"))

(define rust-gimli-0.31.1
  (crate-source "gimli" "0.31.1"
                "0gvqc0ramx8szv76jhfd4dms0zyamvlg4whhiz11j34hh3dqxqh7"))

(define rust-gix-0.73.0
  (crate-source "gix" "0.73.0"
                "0dgnfpp5by749kgnjv5qks055cj9b9c0bhnbn2305p4vhz62jk2i"))

(define rust-gix-actor-0.35.4
  (crate-source "gix-actor" "0.35.4"
                "0rq9506midd6wzwk42kn9q92cja1z3gwwczs5nqm2az3xzwxqdid"))

(define rust-gix-chunk-0.4.11
  (crate-source "gix-chunk" "0.4.11"
                "0vxxq4q5pn5cz2xhghcjpp8z83r8xxy74gsffvf9k1lmcj3is7qb"))

(define rust-gix-command-0.6.2
  (crate-source "gix-command" "0.6.2"
                "15mibs0na7rpnk41lj3bz4sijrhc998pmchjcgl2ldcalifbccbb"))

(define rust-gix-commitgraph-0.29.0
  (crate-source "gix-commitgraph" "0.29.0"
                "01hdk0r2f91na13i1937fhllgf3c6f80is730xdkmx2jx4hk3ckb"))

(define rust-gix-config-0.46.0
  (crate-source "gix-config" "0.46.0"
                "1h1nn76xdsmmyzf68q3h8xfm8rasa8wbc2iwzjnd8pv9bf68kysx"))

(define rust-gix-config-value-0.15.1
  (crate-source "gix-config-value" "0.15.1"
                "02akr1nnljjyqszimafjwp9lssa7xjgn95pwq7367qk7xc1jf0cz"))

(define rust-gix-date-0.10.5
  (crate-source "gix-date" "0.10.5"
                "077yp7411k8i5mhxh8cj6mwdq2a3wv1p9cljmwq76a7vpa86nswr"))

(define rust-gix-diff-0.53.0
  (crate-source "gix-diff" "0.53.0"
                "1a6yphk8dx612x0zp8y8g2a1qs9yk1xdd4hcycbs6i0d0594i1fy"))

(define rust-gix-discover-0.41.0
  (crate-source "gix-discover" "0.41.0"
                "02nkg5fypjs6gwyv70wvyhk7bypqv3c67fr8x19wz8m13k4q1cgz"))

(define rust-gix-features-0.43.1
  (crate-source "gix-features" "0.43.1"
                "0nqyz111qv8fxrhkj3d5vsjcvqlf2rf6lrhsmbmvrg4akg6l65fd"))

(define rust-gix-fs-0.16.1
  (crate-source "gix-fs" "0.16.1"
                "0163s0craj3g6hazq4xrcfxgha5y64rb11qg1qisfkq6glq90kcs"))

(define rust-gix-glob-0.21.0
  (crate-source "gix-glob" "0.21.0"
                "1m9cnqyl4clvlxmk7gspwhkpzq97ksr6nkr51isplgl2cs1xnixr"))

(define rust-gix-hash-0.19.0
  (crate-source "gix-hash" "0.19.0"
                "03nmd7dlz393abhnj9yyfjafka99xsaymnb4fqm1lwvag5wss7r5"))

(define rust-gix-hashtable-0.9.0
  (crate-source "gix-hashtable" "0.9.0"
                "01sgvkg2q4h1cjfnnbwdgsdxdk1i15380h9zsmakw5cn92sh0ly3"))

(define rust-gix-lock-18.0.0
  (crate-source "gix-lock" "18.0.0"
                "1va2mpl51g447aa9pc5ky4d4f14rjxdyp17146k6hminj3d73ymr"))

(define rust-gix-object-0.50.2
  (crate-source "gix-object" "0.50.2"
                "01vw75jmgxfyic011vifxfx7i7a208ak7qdp9yymzdk7mc4f376n"))

(define rust-gix-odb-0.70.0
  (crate-source "gix-odb" "0.70.0"
                "1b09n472wxdgbj15nnmidk3b6q1mjq3xb6vz9yxz17fs1zqpm7cw"))

(define rust-gix-pack-0.60.0
  (crate-source "gix-pack" "0.60.0"
                "069h4rdyyg2r0divkqnvp3wfdxvs7wwp4crykjsap9gwkgw1smyq"))

(define rust-gix-packetline-0.19.1
  (crate-source "gix-packetline" "0.19.1"
                "14qzpxdk760rwiyiagchipriwc3nqdf0bxsn22hzx8j9cb9zp4i5"))

(define rust-gix-path-0.10.20
  (crate-source "gix-path" "0.10.20"
                "1zdjwwb5fyk934mnd9h91jx0zg7pn8vx1g7pfvdbsyy6lhs71lq6"))

(define rust-gix-protocol-0.51.0
  (crate-source "gix-protocol" "0.51.0"
                "08p9cj9j7m7166wr7nlk6jgl8mla6s2ra4dqwp0zgz3zqh3vid0j"))

(define rust-gix-quote-0.6.0
  (crate-source "gix-quote" "0.6.0"
                "1zc3gnc8z7z94sijyn0k9ij5adx230599x1vzsxfhqynnismldsa"))

(define rust-gix-ref-0.53.1
  (crate-source "gix-ref" "0.53.1"
                "0n0pfaa2y239cr356mv0ryhwqi358z77pc8k2jjz8hls0xwgarmr"))

(define rust-gix-refspec-0.31.0
  (crate-source "gix-refspec" "0.31.0"
                "0m80rqn7f6ay6z05ngs1yh2v9jpspxh5wshmwwk8h41imvhwlabx"))

(define rust-gix-revision-0.35.0
  (crate-source "gix-revision" "0.35.0"
                "0gdxdicadvsa9qgw8cww7nvn5s86j8i46rqx2sw0nxigfjqz4lgn"))

(define rust-gix-revwalk-0.21.0
  (crate-source "gix-revwalk" "0.21.0"
                "0b60dvccv98w6195220540zj8bynlw7vs8b7mycy0acpf28lzrq6"))

(define rust-gix-sec-0.12.0
  (crate-source "gix-sec" "0.12.0"
                "0b6zdzgldi2y3jgxzhixmxp1dqvv6z9nxg2pdjsk6rn6swz0bxq9"))

(define rust-gix-shallow-0.5.0
  (crate-source "gix-shallow" "0.5.0"
                "1ds4i77bfzqd1yzgv2351440zyvkrrh0g7pi232y8fi40d8p8dnr"))

(define rust-gix-tempfile-18.0.0
  (crate-source "gix-tempfile" "18.0.0"
                "0mys8wfjsha2axh425ywnwjapsvxi4y6dvwvbsh5zpyypi0h0v36"))

(define rust-gix-trace-0.1.13
  (crate-source "gix-trace" "0.1.13"
                "0n76pqvz7zijlg8ybchhim6p80vnknms0b28bdlklx5in1aazk72"))

(define rust-gix-transport-0.48.0
  (crate-source "gix-transport" "0.48.0"
                "18qwfh8v1ccxsqr624xzni58d54l498wxyg1ahydb2gwg40wrxqj"))

(define rust-gix-traverse-0.47.0
  (crate-source "gix-traverse" "0.47.0"
                "1mdx05k5llll8infjqj3z48gwylw8rmnzy0mv05bm4np14jwikf7"))

(define rust-gix-url-0.32.0
  (crate-source "gix-url" "0.32.0"
                "0vyi2kjr6awl5ph54kcgn2cqg1p7i36nfi6lzy3x4ji5cv9ajxhv"))

(define rust-gix-utils-0.3.0
  (crate-source "gix-utils" "0.3.0"
                "1ici87gkggdh9bklvz16zrq0sknq4r9lbd4ffail3brc2wmsylak"))

(define rust-gix-validate-0.10.0
  (crate-source "gix-validate" "0.10.0"
                "0kbdwvnbkcw6sq0mx6zis6nsc61v95n79v98ilw52nyymh6f1fbp"))

(define rust-gl-generator-0.14.0
  (crate-source "gl_generator" "0.14.0"
                "0k8j1hmfnff312gy7x1aqjzcm8zxid7ij7dlb8prljib7b1dz58s"))

(define rust-glob-0.3.2
  (crate-source "glob" "0.3.2"
                "1cm2w34b5w45fxr522h5b0fv1bxchfswcj560m3pnjbia7asvld8"))

(define rust-glow-0.16.0
  (crate-source "glow" "0.16.0"
                "022z12nlyfpy36fvp2szq792xix1xbgkznpmicf1c404sxhfmrf5"))

(define rust-glutin-0.32.3
  (crate-source "glutin" "0.32.3"
                "098k0jv7zmndw53rxj54qls5rdxm6yxpgs40zznypkya8pl4s4hj"))

(define rust-glutin-egl-sys-0.7.1
  ;; TODO: Check bundled sources.
  (crate-source "glutin_egl_sys" "0.7.1"
                "1lh2rj77yvdqjx913nrf7xs5h3ialkkldfn3ppz29x4mc6x80ijc"))

(define rust-glutin-glx-sys-0.6.1
  ;; TODO: Check bundled sources.
  (crate-source "glutin_glx_sys" "0.6.1"
                "118ifprw3y4jwrr25x862gh9hwd7fniwpywr4ihqpa25h29v4ywa"))

(define rust-glutin-wgl-sys-0.6.1
  ;; TODO: Check bundled sources.
  (crate-source "glutin_wgl_sys" "0.6.1"
                "0gng2810jb5x133lmy17qifjx6s90lnprm86afg7mfls505y0kic"))

(define rust-glutin-winit-0.5.0
  (crate-source "glutin-winit" "0.5.0"
                "13vqsdsyn9ww7sg3cx05jfgbihwn388vp3yb527p5z7qfmqcmvc5"))

(define rust-gpu-alloc-0.6.0
  (crate-source "gpu-alloc" "0.6.0"
                "0wd1wq7qs8ja0cp37ajm9p1r526sp6w0kvjp3xx24jsrjfx2vkgv"))

(define rust-gpu-alloc-types-0.3.0
  (crate-source "gpu-alloc-types" "0.3.0"
                "190wxsp9q8c59xybkfrlzqqyrxj6z39zamadk1q7v0xad2s07zwq"))

(define rust-gpu-descriptor-0.3.2
  (crate-source "gpu-descriptor" "0.3.2"
                "1jm0acxkw9lrzzcbvjqynwdr53qsqz7vx5d8c8h77qq5j4s8775q"))

(define rust-gpu-descriptor-types-0.2.0
  (crate-source "gpu-descriptor-types" "0.2.0"
                "14ab90klss7w0ybj95fcnqxjsjya17xjhf576dpvi4zq5ml45wpx"))

(define rust-half-2.6.0
  (crate-source "half" "2.6.0"
                "1j83v0xaqvrw50ppn0g33zig0zsbdi7xiqbzgn7sd5al57nrd4a5"))

(define rust-hash32-0.3.1
  (crate-source "hash32" "0.3.1"
                "01h68z8qi5gl9lnr17nz10lay8wjiidyjdyd60kqx8ibj090pmj7"))

(define rust-hashbrown-0.15.4
  (crate-source "hashbrown" "0.15.4"
                "1mg045sm1nm00cwjm7ndi80hcmmv1v3z7gnapxyhd9qxc62sqwar"))

(define rust-hashbrown-0.15.5
  (crate-source "hashbrown" "0.15.5"
                "189qaczmjxnikm9db748xyhiw04kpmhm9xj9k9hg0sgx7pjwyacj"))

(define rust-heapless-0.8.0
  (crate-source "heapless" "0.8.0"
                "1b9zpdjv4qkl2511s2c80fz16fx9in4m9qkhbaa8j73032v9xyqb"))

(define rust-heck-0.5.0
  (crate-source "heck" "0.5.0"
                "1sjmpsdl8czyh9ywl3qcsfsq9a307dg4ni2vnlwgnzzqhc4y0113"))

(define rust-hermit-abi-0.5.2
  (crate-source "hermit-abi" "0.5.2"
                "1744vaqkczpwncfy960j2hxrbjl1q01csm84jpd9dajbdr2yy3zw"))

(define rust-hexf-parse-0.2.1
  (crate-source "hexf-parse" "0.2.1"
                "1pr3a3sk66ddxdyxdxac7q6qaqjcn28v0njy22ghdpfn78l8d9nz"))

(define rust-home-0.5.11
  (crate-source "home" "0.5.11"
                "1kxb4k87a9sayr8jipr7nq9wpgmjk4hk4047hmf9kc24692k75aq"))

(define rust-humantime-2.2.0
  (crate-source "humantime" "2.2.0"
                "17rz8jhh1mcv4b03wnknhv1shwq2v9vhkhlfg884pprsig62l4cv"))

(define rust-i18n-config-0.4.8
  (crate-source "i18n-config" "0.4.8"
                "1vv31hz9zpzqz1ddpisxm2iz6c2swchlnd4l7hh2w98di86bj1iy"))

(define rust-i18n-embed-0.16.0
  (crate-source "i18n-embed" "0.16.0"
                "0183rf7jchhy6lnd2rgjcz54b0k7q1zqjy7s5qlzpbnwfnqbn5x2"))

(define rust-i18n-embed-fl-0.10.0
  (crate-source "i18n-embed-fl" "0.10.0"
                "0c4zgqp6va5q6mkndqa058k1m6gjxscyawj6w1hjzfbxnrryv675"))

(define rust-i18n-embed-impl-0.8.4
  (crate-source "i18n-embed-impl" "0.8.4"
                "1hmnimlv310cirg8nx77nf8q1si4hq1yarkg5kyfc7rxabhc0b0g"))

(define rust-iana-time-zone-0.1.63
  (crate-source "iana-time-zone" "0.1.63"
                "1n171f5lbc7bryzmp1h30zw86zbvl5480aq02z92lcdwvvjikjdh"))

(define rust-iana-time-zone-haiku-0.1.2
  (crate-source "iana-time-zone-haiku" "0.1.2"
                "17r6jmj31chn7xs9698r122mapq85mfnv98bb4pg6spm0si2f67k"))

(define rust-icu-collections-2.0.0
  (crate-source "icu_collections" "2.0.0"
                "0izfgypv1hsxlz1h8fc2aak641iyvkak16aaz5b4aqg3s3sp4010"))

(define rust-icu-locale-core-2.0.0
  (crate-source "icu_locale_core" "2.0.0"
                "02phv7vwhyx6vmaqgwkh2p4kc2kciykv2px6g4h8glxfrh02gphc"))

(define rust-icu-normalizer-2.0.0
  (crate-source "icu_normalizer" "2.0.0"
                "0ybrnfnxx4sf09gsrxri8p48qifn54il6n3dq2xxgx4dw7l80s23"))

(define rust-icu-normalizer-data-2.0.0
  (crate-source "icu_normalizer_data" "2.0.0"
                "1lvjpzxndyhhjyzd1f6vi961gvzhj244nribfpdqxjdgjdl0s880"))

(define rust-icu-properties-2.0.1
  (crate-source "icu_properties" "2.0.1"
                "0az349pjg8f18lrjbdmxcpg676a7iz2ibc09d2wfz57b3sf62v01"))

(define rust-icu-properties-data-2.0.1
  (crate-source "icu_properties_data" "2.0.1"
                "0cnn3fkq6k88w7p86w7hsd1254s4sl783rpz4p6hlccq74a5k119"))

(define rust-icu-provider-2.0.0
  (crate-source "icu_provider" "2.0.0"
                "1bz5v02gxv1i06yhdhs2kbwxkw3ny9r2vvj9j288fhazgfi0vj03"))

(define rust-ident-case-1.0.1
  (crate-source "ident_case" "1.0.1"
                "0fac21q6pwns8gh1hz3nbq15j8fi441ncl6w4vlnd1cmc55kiq5r"))

(define rust-idna-1.0.3
  (crate-source "idna" "1.0.3"
                "0zlajvm2k3wy0ay8plr07w22hxkkmrxkffa6ah57ac6nci984vv8"))

(define rust-idna-1.1.0
  (crate-source "idna" "1.1.0"
                "1pp4n7hppm480zcx411dsv9wfibai00wbpgnjj4qj0xa7kr7a21v"))

(define rust-idna-adapter-1.2.1
  (crate-source "idna_adapter" "1.2.1"
                "0i0339pxig6mv786nkqcxnwqa87v4m94b2653f6k3aj0jmhfkjis"))

(define rust-image-0.25.7
  (crate-source "image" "0.25.7"
                "01cnnnx692nqkllgvgian8jm847d29gkd5bgvwj8wxs3c7hkqshw"))

(define rust-indexmap-2.10.0
  (crate-source "indexmap" "2.10.0"
                "0qd6g26gxzl6dbf132w48fa8rr95glly3jhbk90i29726d9xhk7y"))

(define rust-indexmap-2.11.0
  (crate-source "indexmap" "2.11.0"
                "1sb3nmhisf9pdwfcxzqlvx97xifcvlh5g0rqj9j7i7qg8f01jj7j"))

(define rust-intl-memoizer-0.5.3
  (crate-source "intl-memoizer" "0.5.3"
                "0gqn5wwhzacvj0z25r5r3l2pajg9c8i1ivh7g8g8dszm8pis439i"))

(define rust-intl-pluralrules-7.0.2
  (crate-source "intl_pluralrules" "7.0.2"
                "0wprd3h6h8nfj62d8xk71h178q7zfn3srxm787w4sawsqavsg3h7"))

(define rust-is-terminal-0.4.16
  (crate-source "is-terminal" "0.4.16"
                "1acm63whnpwiw1padm9bpqz04sz8msymrmyxc55mvlq8hqqpykg0"))

(define rust-is-terminal-polyfill-1.70.1
  (crate-source "is_terminal_polyfill" "1.70.1"
                "1kwfgglh91z33kl0w5i338mfpa3zs0hidq5j4ny4rmjwrikchhvr"))

(define rust-itertools-0.13.0
  (crate-source "itertools" "0.13.0"
                "11hiy3qzl643zcigknclh446qb9zlg4dpdzfkjaa9q9fqpgyfgj1"))

(define rust-itoa-1.0.15
  (crate-source "itoa" "1.0.15"
                "0b4fj9kz54dr3wam0vprjwgygvycyw8r0qwg7vp19ly8b2w16psa"))

(define rust-jiff-0.2.15
  (crate-source "jiff" "0.2.15"
                "0jby6kbs2ra33ji0rx4swcp66jzmcvgszc5v4izwfsgbn6w967xy"))

(define rust-jiff-static-0.2.15
  (crate-source "jiff-static" "0.2.15"
                "1d4l4pvlhz3w487gyhnzvagpbparspv4c8f35qk6g5w9zx8k8d03"))

(define rust-jiff-tzdb-0.1.4
  (crate-source "jiff-tzdb" "0.1.4"
                "09350bna4vxdn2fv7gd08ay41llkflmfyvpx5d6l088axc2kfa61"))

(define rust-jiff-tzdb-platform-0.1.3
  (crate-source "jiff-tzdb-platform" "0.1.3"
                "1s1ja692wyhbv7f60mc0x90h7kn1pv65xkqi2y4imarbmilmlnl7"))

(define rust-jni-0.21.1
  (crate-source "jni" "0.21.1"
                "15wczfkr2r45slsljby12ymf2hij8wi5b104ghck9byjnwmsm1qs"))

(define rust-jni-sys-0.3.0
  ;; TODO: Check bundled sources.
  (crate-source "jni-sys" "0.3.0"
                "0c01zb9ygvwg9wdx2fii2d39myzprnpqqhy7yizxvjqp5p04pbwf"))

(define rust-jobserver-0.1.34
  (crate-source "jobserver" "0.1.34"
                "0cwx0fllqzdycqn4d6nb277qx5qwnmjdxdl0lxkkwssx77j3vyws"))

(define rust-js-sys-0.3.77
  ;; TODO: Check bundled sources.
  (crate-source "js-sys" "0.3.77"
                "13x2qcky5l22z4xgivi59xhjjx4kxir1zg7gcj0f1ijzd4yg7yhw"))

(define rust-khronos-api-3.1.0
  (crate-source "khronos_api" "3.1.0"
                "1p0xj5mlbagqyvvnv8wmv3cr7l9y1m153888pxqwg3vk3mg5inz2"))

(define rust-khronos-egl-6.0.0
  (crate-source "khronos-egl" "6.0.0"
                "0xnzdx0n1bil06xmh8i1x6dbxvk7kd2m70bbm6nw1qzc43r1vbka"))

(define rust-lazy-static-1.5.0
  (crate-source "lazy_static" "1.5.0"
                "1zk6dqqni0193xg6iijh7i3i44sryglwgvx20spdvwk3r6sbrlmv"))

(define rust-libc-0.2.172
  (crate-source "libc" "0.2.172"
                "1ykz4skj7gac14znljm5clbnrhini38jkq3d60jggx3y5w2ayl6p"))

(define rust-libc-0.2.174
  (crate-source "libc" "0.2.174"
                "0xl7pqvw7g2874dy3kjady2fjr4rhj5lxsnxkkhr5689jcr6jw8i"))

(define rust-libc-0.2.175
  (crate-source "libc" "0.2.175"
                "0hw5sb3gjr0ivah7s3fmavlpvspjpd4mr009abmam2sr7r4sx0ka"))

(define rust-libdrm-amdgpu-sys-0.8.8
  (crate-source "libdrm_amdgpu_sys" "0.8.8"
                "1bmaxgwa10mh8j7rf9jbzpwgs5hw4zi6zi60lpj8m2jx7igzjyws"))

(define rust-libloading-0.8.8
  (crate-source "libloading" "0.8.8"
                "0rw6q94psj3d6k0bi9nymqhyrz78lbdblryphhaszsw9p9ikj0q7"))

(define rust-libm-0.2.15
  (crate-source "libm" "0.2.15"
                "1plpzf0p829viazdj57yw5dhmlr8ywf3apayxc2f2bq5a6mvryzr"))

(define rust-libredox-0.1.6
  (crate-source "libredox" "0.1.6"
                "1h43psqhnqciwlg1c8jwryvxxdyr4sqxh1mrmm4f9pi8jd5mk224"))

(define rust-libredox-0.1.9
  (crate-source "libredox" "0.1.9"
                "1qqczzfqcc3sw3bl7la6qv7i9hy1s7sxhxmdvpxkfgdd3c9904ir"))

(define rust-libz-rs-sys-0.5.1
  ;; TODO: Check bundled sources.
  (crate-source "libz-rs-sys" "0.5.1"
                "08a2grn3bp05696pd27s6kmq1icnbzffizl0nihic8m26y2phahp"))

(define rust-linux-raw-sys-0.4.15
  ;; TODO: Check bundled sources.
  (crate-source "linux-raw-sys" "0.4.15"
                "1aq7r2g7786hyxhv40spzf2nhag5xbw2axxc1k8z5k1dsgdm4v6j"))

(define rust-linux-raw-sys-0.9.4
  ;; TODO: Check bundled sources.
  (crate-source "linux-raw-sys" "0.9.4"
                "04kyjdrq79lz9ibrf7czk6cv9d3jl597pb9738vzbsbzy1j5i56d"))

(define rust-litemap-0.8.0
  (crate-source "litemap" "0.8.0"
                "0mlrlskwwhirxk3wsz9psh6nxcy491n0dh8zl02qgj0jzpssw7i4"))

(define rust-litrs-0.4.2
  (crate-source "litrs" "0.4.2"
                "1v8bxsrkm0w2k9nmbp8hsspy9i1lawajywqdw4hx87rjzqv41rgm"))

(define rust-lock-api-0.4.13
  (crate-source "lock_api" "0.4.13"
                "0rd73p4299mjwl4hhlfj9qr88v3r0kc8s1nszkfmnq2ky43nb4wn"))

(define rust-log-0.4.27
  (crate-source "log" "0.4.27"
                "150x589dqil307rv0rwj0jsgz5bjbwvl83gyl61jf873a7rjvp0k"))

(define rust-malloc-buf-0.0.6
  (crate-source "malloc_buf" "0.0.6"
                "1jqr77j89pwszv51fmnknzvd53i1nkmcr8rjrvcxhm4dx1zr1fv2"))

(define rust-maybe-async-0.2.10
  (crate-source "maybe-async" "0.2.10"
                "04fvg2ywb2p9dzf7i35xqfibxc05k1pirv36jswxcqg3qw82ryaw"))

(define rust-memchr-2.7.5
  (crate-source "memchr" "2.7.5"
                "1h2bh2jajkizz04fh047lpid5wgw2cr9igpkdhl3ibzscpd858ij"))

(define rust-memmap2-0.9.8
  (crate-source "memmap2" "0.9.8"
                "1dqxjs89krh8cin0k7ksqc9myw9yni9kn8d8cllwq4fn1isrhfl4"))

(define rust-memoffset-0.9.1
  (crate-source "memoffset" "0.9.1"
                "12i17wh9a9plx869g7j4whf62xw68k5zd4k0k5nh6ys5mszid028"))

(define rust-minimal-lexical-0.2.1
  (crate-source "minimal-lexical" "0.2.1"
                "16ppc5g84aijpri4jzv14rvcnslvlpphbszc7zzp6vfkddf4qdb8"))

(define rust-miniz-oxide-0.8.9
  (crate-source "miniz_oxide" "0.8.9"
                "05k3pdg8bjjzayq3rf0qhpirq9k37pxnasfn4arbs17phqn6m9qz"))

(define rust-mio-1.0.4
  (crate-source "mio" "1.0.4"
                "073n3kam3nz8j8had35fd2nn7j6a33pi3y5w3kq608cari2d9gkq"))

(define rust-moxcms-0.7.5
  (crate-source "moxcms" "0.7.5"
                "026df3qpxn430dlngpj3gjip0m9280g3asvbia5dpsjsjfl2zlyx"))

(define rust-naga-25.0.1
  (crate-source "naga" "25.0.1"
                "0cm69nrd703v5slnk397rd16k0wb7cf678xcz5brgr16bx27r5rb"))

(define rust-ndk-0.9.0
  (crate-source "ndk" "0.9.0"
                "1m32zpmi5w1pf3j47k6k5fw395dc7aj8d0mdpsv53lqkprxjxx63"))

(define rust-ndk-context-0.1.1
  (crate-source "ndk-context" "0.1.1"
                "12sai3dqsblsvfd1l1zab0z6xsnlha3xsfl7kagdnmj3an3jvc17"))

(define rust-ndk-sys-0.5.0+25.2.9519653
  ;; TODO: Check bundled sources.
  (crate-source "ndk-sys" "0.5.0+25.2.9519653"
                "14bnxww0f17xl8pyn6j5kpkl98snjl9lin8i7qv4zzb0vmlnf6cc"))

(define rust-ndk-sys-0.6.0+11769913
  ;; TODO: Check bundled sources.
  (crate-source "ndk-sys" "0.6.0+11769913"
                "0wx8r6pji20if4xs04g73gxl98nmjrfc73z0v6w1ypv6a4qdlv7f"))

(define rust-nix-0.30.1
  (crate-source "nix" "0.30.1"
                "1dixahq9hk191g0c2ydc0h1ppxj0xw536y6rl63vlnp06lx3ylkl"))

(define rust-nohash-hasher-0.2.0
  (crate-source "nohash-hasher" "0.2.0"
                "0lf4p6k01w4wm7zn4grnihzj8s7zd5qczjmzng7wviwxawih5x9b"))

(define rust-nom-7.1.3
  (crate-source "nom" "7.1.3"
                "0jha9901wxam390jcf5pfa0qqfrgh8li787jx2ip0yk5b8y9hwyj"))

(define rust-num-0.4.3
  (crate-source "num" "0.4.3"
                "08yb2fc1psig7pkzaplm495yp7c30m4pykpkwmi5bxrgid705g9m"))

(define rust-num-complex-0.4.6
  (crate-source "num-complex" "0.4.6"
                "15cla16mnw12xzf5g041nxbjjm9m85hdgadd5dl5d0b30w9qmy3k"))

(define rust-num-conv-0.1.0
  (crate-source "num-conv" "0.1.0"
                "1ndiyg82q73783jq18isi71a7mjh56wxrk52rlvyx0mi5z9ibmai"))

(define rust-num-enum-0.7.4
  (crate-source "num_enum" "0.7.4"
                "0ykvfah4ddfi2dwjcksc33j34i84kb7plycxwr6dijp69kjb8wx9"))

(define rust-num-enum-derive-0.7.4
  (crate-source "num_enum_derive" "0.7.4"
                "03gr5218x4rs52kx4srx3jn1c6vmx3drd506vl0axax88v47is3p"))

(define rust-num-integer-0.1.46
  (crate-source "num-integer" "0.1.46"
                "13w5g54a9184cqlbsq80rnxw4jj4s0d8wv75jsq5r2lms8gncsbr"))

(define rust-num-iter-0.1.45
  (crate-source "num-iter" "0.1.45"
                "1gzm7vc5g9qsjjl3bqk9rz1h6raxhygbrcpbfl04swlh0i506a8l"))

(define rust-num-rational-0.4.2
  (crate-source "num-rational" "0.4.2"
                "093qndy02817vpgcqjnj139im3jl7vkq4h68kykdqqh577d18ggq"))

(define rust-num-threads-0.1.7
  (crate-source "num_threads" "0.1.7"
                "1ngajbmhrgyhzrlc4d5ga9ych1vrfcvfsiqz6zv0h2dpr2wrhwsw"))

(define rust-num-traits-0.2.19
  (crate-source "num-traits" "0.2.19"
                "0h984rhdkkqd4ny9cif7y2azl3xdfb7768hb9irhpsch4q3gq787"))

(define rust-objc-0.2.7
  (crate-source "objc" "0.2.7"
                "1cbpf6kz8a244nn1qzl3xyhmp05gsg4n313c9m3567625d3innwi"))

(define rust-objc-sys-0.3.5
  ;; TODO: Check bundled sources.
  (crate-source "objc-sys" "0.3.5"
                "0423gry7s3rmz8s3pzzm1zy5mdjif75g6dbzc2lf2z0c77fipffd"))

(define rust-objc2-0.5.2
  (crate-source "objc2" "0.5.2"
                "015qa2d3vh7c1j2736h5wjrznri7x5ic35vl916c22gzxva8b9s6"))

(define rust-objc2-0.6.2
  (crate-source "objc2" "0.6.2"
                "1g3qa1vxp6nlh4wllll921z299d3s1is31m1ccasd8pklxxka7sn"))

(define rust-objc2-app-kit-0.2.2
  (crate-source "objc2-app-kit" "0.2.2"
                "1zqyi5l1bm26j1bgmac9783ah36m5kcrxlqp5carglnpwgcrms74"))

(define rust-objc2-app-kit-0.3.1
  (crate-source "objc2-app-kit" "0.3.1"
                "1k4vz0s63rpp1yyhx96mh9nndn1zzv2cwxzpvw6rnigcidb9zwp6"))

(define rust-objc2-cloud-kit-0.2.2
  (crate-source "objc2-cloud-kit" "0.2.2"
                "02dhjvmcq8c2bwj31jx423jygif1scs9f0lmlab0ayhw75b3ppbl"))

(define rust-objc2-contacts-0.2.2
  (crate-source "objc2-contacts" "0.2.2"
                "12a8m927xrrxa54xhqhqnkkl1a6l07pyrpnqfk9jz09kkh755zx5"))

(define rust-objc2-core-data-0.2.2
  (crate-source "objc2-core-data" "0.2.2"
                "1vvk8zjylfjjj04dzawydmqqz5ajvdkhf22cnb07ihbiw14vyzv1"))

(define rust-objc2-core-foundation-0.3.1
  (crate-source "objc2-core-foundation" "0.3.1"
                "0rn19d70mwxyv74kx7aqm5in6x320vavq9v0vrm81vbg9a4w440w"))

(define rust-objc2-core-graphics-0.3.1
  (crate-source "objc2-core-graphics" "0.3.1"
                "197mf2a4yvvigkd9hsp8abbpip7rn3mmc55psv1ba89hq5l6r74q"))

(define rust-objc2-core-image-0.2.2
  (crate-source "objc2-core-image" "0.2.2"
                "102csfb82zi2sbzliwsfd589ckz0gysf7y6434c9zj97lmihj9jm"))

(define rust-objc2-core-location-0.2.2
  (crate-source "objc2-core-location" "0.2.2"
                "10apgsrigqryvi4rcc0f6yfjflvrl83f4bi5hkr48ck89vizw300"))

(define rust-objc2-encode-4.1.0
  (crate-source "objc2-encode" "4.1.0"
                "0cqckp4cpf68mxyc2zgnazj8klv0z395nsgbafa61cjgsyyan9gg"))

(define rust-objc2-foundation-0.2.2
  (crate-source "objc2-foundation" "0.2.2"
                "1a6mi77jsig7950vmx9ydvsxaighzdiglk5d229k569pvajkirhf"))

(define rust-objc2-foundation-0.3.1
  (crate-source "objc2-foundation" "0.3.1"
                "0g5hl47dxzabs7wndcg6kz3q137v9hwfay1jd2da1q9gglj3224h"))

(define rust-objc2-io-surface-0.3.1
  (crate-source "objc2-io-surface" "0.3.1"
                "0g0c89swz8hgfrh0j1iqhcz3ig7cyhavn3p9gi2s77sjjanfk0kj"))

(define rust-objc2-link-presentation-0.2.2
  (crate-source "objc2-link-presentation" "0.2.2"
                "160k4qh00yrx57dabn3hzas4r98kmk9bc0qsy1jvwday3irax8d1"))

(define rust-objc2-metal-0.2.2
  (crate-source "objc2-metal" "0.2.2"
                "1mmdga66qpxrcfq3gxxhysfx3zg1hpx4z886liv3j0pnfq9bl36x"))

(define rust-objc2-quartz-core-0.2.2
  (crate-source "objc2-quartz-core" "0.2.2"
                "0ynw8819c36l11rim8n0yzk0fskbzrgaqayscyqi8swhzxxywaz4"))

(define rust-objc2-symbols-0.2.2
  (crate-source "objc2-symbols" "0.2.2"
                "1p04hjkxan18g2b7h9n2n8xxsvazapv2h6mfmmdk06zc7pz4ws0a"))

(define rust-objc2-ui-kit-0.2.2
  (crate-source "objc2-ui-kit" "0.2.2"
                "0vrb5r8z658l8c19bx78qks8c5hg956544yirf8npk90idwldfxq"))

(define rust-objc2-uniform-type-identifiers-0.2.2
  (crate-source "objc2-uniform-type-identifiers" "0.2.2"
                "1ziv4wkbxcaw015ypg0q49ycl7m14l3x56mpq2k1rznv92bmzyj4"))

(define rust-objc2-user-notifications-0.2.2
  (crate-source "objc2-user-notifications" "0.2.2"
                "1cscv2w3vxzaslz101ddv0z9ycrrs4ayikk4my4qd3im8bvcpkvn"))

(define rust-object-0.36.7
  (crate-source "object" "0.36.7"
                "11vv97djn9nc5n6w1gc6bd96d2qk2c8cg1kw5km9bsi3v4a8x532"))

(define rust-once-cell-1.21.3
  (crate-source "once_cell" "1.21.3"
                "0b9x77lb9f1j6nqgf5aka4s2qj0nly176bpbrv6f9iakk5ff3xa2"))

(define rust-once-cell-polyfill-1.70.1
  (crate-source "once_cell_polyfill" "1.70.1"
                "1bg0w99srq8h4mkl68l1mza2n2f2hvrg0n8vfa3izjr5nism32d4"))

(define rust-option-ext-0.2.0
  (crate-source "option-ext" "0.2.0"
                "0zbf7cx8ib99frnlanpyikm1bx8qn8x602sw1n7bg6p9x94lyx04"))

(define rust-orbclient-0.3.48
  (crate-source "orbclient" "0.3.48"
                "0hzxjsvvsl5i9d3aqzc6kdcsch1i6flij5dkignhhkz2qb72c2xs"))

(define rust-ordered-float-4.6.0
  (crate-source "ordered-float" "4.6.0"
                "0ldrcgilsiijd141vw51fbkziqmh5fpllil3ydhirjm67wdixdvv"))

(define rust-owned-ttf-parser-0.25.1
  (crate-source "owned_ttf_parser" "0.25.1"
                "0fsqzcbc4sq8qhkmc3rgcfg1xg389nmhlxvmvi6h38dca680x0in"))

(define rust-parking-lot-0.12.4
  (crate-source "parking_lot" "0.12.4"
                "04sab1c7304jg8k0d5b2pxbj1fvgzcf69l3n2mfpkdb96vs8pmbh"))

(define rust-parking-lot-core-0.9.11
  (crate-source "parking_lot_core" "0.9.11"
                "19g4d6m5k4ggacinqprnn8xvdaszc3y5smsmbz1adcdmaqm8v0xw"))

(define rust-percent-encoding-2.3.1
  (crate-source "percent-encoding" "2.3.1"
                "0gi8wgx0dcy8rnv1kywdv98lwcx67hz0a0zwpib5v2i08r88y573"))

(define rust-percent-encoding-2.3.2
  (crate-source "percent-encoding" "2.3.2"
                "083jv1ai930azvawz2khv7w73xh8mnylk7i578cifndjn5y64kwv"))

(define rust-pin-project-1.1.10
  (crate-source "pin-project" "1.1.10"
                "12kadbnfm1f43cyadw9gsbyln1cy7vj764wz5c8wxaiza3filzv7"))

(define rust-pin-project-internal-1.1.10
  (crate-source "pin-project-internal" "1.1.10"
                "0qgqzfl0f4lzaz7yl5llhbg97g68r15kljzihaw9wm64z17qx4bf"))

(define rust-pin-project-lite-0.2.16
  (crate-source "pin-project-lite" "0.2.16"
                "16wzc7z7dfkf9bmjin22f5282783f6mdksnr0nv0j5ym5f9gyg1v"))

(define rust-pkg-config-0.3.32
  (crate-source "pkg-config" "0.3.32"
                "0k4h3gnzs94sjb2ix6jyksacs52cf1fanpwsmlhjnwrdnp8dppby"))

(define rust-png-0.18.0
  (crate-source "png" "0.18.0"
                "187jf0m873qn5biix8z7gjdsyf8r6vj3yr495pa0jja6i39wxflp"))

(define rust-polling-3.10.0
  (crate-source "polling" "3.10.0"
                "0afqlnm45081k06sngc052k9vmh33j2rqrmjgi7q1zjhcca1kgdm"))

(define rust-pollster-0.4.0
  (crate-source "pollster" "0.4.0"
                "1qqcn0h2bvmgm9rlhfrdk7lfaiw1ad86g9500bhx1rj1s0c9yfig"))

(define rust-portable-atomic-1.11.1
  (crate-source "portable-atomic" "1.11.1"
                "10s4cx9y3jvw0idip09ar52s2kymq8rq9a668f793shn1ar6fhpq"))

(define rust-portable-atomic-util-0.2.4
  (crate-source "portable-atomic-util" "0.2.4"
                "01rmx1li07ixsx3sqg2bxqrkzk7b5n8pibwwf2589ms0s3cg18nq"))

(define rust-potential-utf-0.1.2
  (crate-source "potential_utf" "0.1.2"
                "11dm6k3krx3drbvhgjw8z508giiv0m09wzl6ghza37176w4c79z5"))

(define rust-potential-utf-0.1.3
  (crate-source "potential_utf" "0.1.3"
                "12mhwvhpvvim6xqp6ifgkh1sniv9j2cmid6axn10fnjvpsnikpw4"))

(define rust-powerfmt-0.2.0
  (crate-source "powerfmt" "0.2.0"
                "14ckj2xdpkhv3h6l5sdmb9f1d57z8hbfpdldjc2vl5givq2y77j3"))

(define rust-pretty-env-logger-0.5.0
  (crate-source "pretty_env_logger" "0.5.0"
                "076w9dnvcpx6d3mdbkqad8nwnsynb7c8haxmscyrz7g3vga28mw6"))

(define rust-prettyplease-0.2.33
  (crate-source "prettyplease" "0.2.33"
                "0zba9hcp50rg52j4134px0pwkx9i9zjnbp9ylv3cbx232d993vlx"))

(define rust-proc-macro-crate-3.3.0
  (crate-source "proc-macro-crate" "3.3.0"
                "0d9xlymplfi9yv3f5g4bp0d6qh70apnihvqcjllampx4f5lmikpd"))

(define rust-proc-macro-error-attr2-2.0.0
  (crate-source "proc-macro-error-attr2" "2.0.0"
                "1ifzi763l7swl258d8ar4wbpxj4c9c2im7zy89avm6xv6vgl5pln"))

(define rust-proc-macro-error2-2.0.1
  (crate-source "proc-macro-error2" "2.0.1"
                "00lq21vgh7mvyx51nwxwf822w2fpww1x0z8z0q47p8705g2hbv0i"))

(define rust-proc-macro2-1.0.101
  (crate-source "proc-macro2" "1.0.101"
                "1pijhychkpl7rcyf1h7mfk6gjfii1ywf5n0snmnqs5g4hvyl7bl9"))

(define rust-proc-macro2-1.0.95
  (crate-source "proc-macro2" "1.0.95"
                "0y7pwxv6sh4fgg6s715ygk1i7g3w02c0ljgcsfm046isibkfbcq2"))

(define rust-prodash-30.0.1
  (crate-source "prodash" "30.0.1"
                "0fdi0wxgy3s9643dgyfkwgmm12g4a360djy56zbxkls9d1bgqvjs"))

(define rust-profiling-1.0.17
  (crate-source "profiling" "1.0.17"
                "0wqp6i1bl7azy9270dp92srbbr55mgdh9qnk5b1y44lyarmlif1y"))

(define rust-pxfm-0.1.20
  (crate-source "pxfm" "0.1.20"
                "1y4n7c9m7hkykh7c9dmfd4v34xqrk2k442jzjj36wvsg360hhybf"))

(define rust-quick-error-2.0.1
  (crate-source "quick-error" "2.0.1"
                "18z6r2rcjvvf8cn92xjhm2qc3jpd1ljvcbf12zv0k9p565gmb4x9"))

(define rust-quick-xml-0.37.5
  (crate-source "quick-xml" "0.37.5"
                "1yxpd7rc2qn6f4agfj47ps2z89vv7lvzxpzawqirix8bmyhrf7ik"))

(define rust-quote-1.0.40
  (crate-source "quote" "1.0.40"
                "1394cxjg6nwld82pzp2d4fp6pmaz32gai1zh9z5hvh0dawww118q"))

(define rust-r-efi-5.3.0
  (crate-source "r-efi" "5.3.0"
                "03sbfm3g7myvzyylff6qaxk4z6fy76yv860yy66jiswc2m6b7kb9"))

(define rust-raw-window-handle-0.6.2
  (crate-source "raw-window-handle" "0.6.2"
                "0ff5c648hncwx7hm2a8fqgqlbvbl4xawb6v3xxv9wkpjyrr5arr0"))

(define rust-redox-syscall-0.4.1
  (crate-source "redox_syscall" "0.4.1"
                "1aiifyz5dnybfvkk4cdab9p2kmphag1yad6iknc7aszlxxldf8j7"))

(define rust-redox-syscall-0.5.17
  (crate-source "redox_syscall" "0.5.17"
                "0xrvpchkaxph3r5ww2i04v9nwg3843fp3prf8kqlh1gv01b4c1sl"))

(define rust-redox-users-0.5.0
  (crate-source "redox_users" "0.5.0"
                "0awxx66izdw6kz97r3zxrl5ms5f6dqi5l0f58mlsvlmx8wyrsvyx"))

(define rust-regex-1.11.1
  (crate-source "regex" "1.11.1"
                "148i41mzbx8bmq32hsj1q4karkzzx5m60qza6gdw4pdc9qdyyi5m"))

(define rust-regex-automata-0.4.10
  (crate-source "regex-automata" "0.4.10"
                "1mllcfmgjcl6d52d5k09lwwq9wj5mwxccix4bhmw5spy1gx5i53b"))

(define rust-regex-automata-0.4.9
  (crate-source "regex-automata" "0.4.9"
                "02092l8zfh3vkmk47yjc8d631zhhcd49ck2zr133prvd3z38v7l0"))

(define rust-regex-syntax-0.8.5
  (crate-source "regex-syntax" "0.8.5"
                "0p41p3hj9ww7blnbwbj9h7rwxzxg0c1hvrdycgys8rxyhqqw859b"))

(define rust-renderdoc-sys-1.1.0
  ;; TODO: Check bundled sources.
  (crate-source "renderdoc-sys" "1.1.0"
                "0cj8zjs7k0gvchcx3jhpg8r9bbqy8b1hsgbz0flcq2ydn12hmcqr"))

(define rust-ron-0.10.1
  (crate-source "ron" "0.10.1"
                "0zvv5mbzjd5hb4zgrw71154jn6wsdlsx2vggmrrkxiw1pzvvdkmy"))

(define rust-rust-embed-8.7.2
  (crate-source "rust-embed" "8.7.2"
                "12hprnl569f1pg2sn960gfla913mk1mxdwpn2a6vl9iad2w0hn82"))

(define rust-rust-embed-impl-8.7.2
  (crate-source "rust-embed-impl" "8.7.2"
                "171lshvdh122ypbf23gmhvrqnhbk0q9g27gaq6g82w9b76jg2rb0"))

(define rust-rust-embed-utils-8.7.2
  (crate-source "rust-embed-utils" "8.7.2"
                "151m1966qk75y10msazdp0xj4fqw1khcry0z946bf84bcj0hrk7n"))

(define rust-rustc-demangle-0.1.25
  (crate-source "rustc-demangle" "0.1.25"
                "0kxq6m0drr40434ch32j31dkg00iaf4zxmqg7sqxajhcz0wng7lq"))

(define rust-rustc-hash-1.1.0
  (crate-source "rustc-hash" "1.1.0"
                "1qkc5khrmv5pqi5l5ca9p5nl5hs742cagrndhbrlk3dhlrx3zm08"))

(define rust-rustc-hash-2.1.1
  (crate-source "rustc-hash" "2.1.1"
                "03gz5lvd9ghcwsal022cgkq67dmimcgdjghfb5yb5d352ga06xrm"))

(define rust-rustix-0.38.44
  (crate-source "rustix" "0.38.44"
                "0m61v0h15lf5rrnbjhcb9306bgqrhskrqv7i1n0939dsw8dbrdgx"))

(define rust-rustix-1.0.8
  (crate-source "rustix" "1.0.8"
                "1j6ajqi61agdnh1avr4bplrsgydjw1n4mycdxw3v8g94pyx1y60i"))

(define rust-rustversion-1.0.21
  (crate-source "rustversion" "1.0.21"
                "07bb1xx05hhwpnl43sqrhsmxyk5sd5m5baadp19nxp69s9xij3ca"))

(define rust-rustversion-1.0.22
  (crate-source "rustversion" "1.0.22"
                "0vfl70jhv72scd9rfqgr2n11m5i9l1acnk684m2w83w0zbqdx75k"))

(define rust-ryu-1.0.20
  (crate-source "ryu" "1.0.20"
                "07s855l8sb333h6bpn24pka5sp7hjk2w667xy6a0khkf6sqv5lr8"))

(define rust-same-file-1.0.6
  (crate-source "same-file" "1.0.6"
                "00h5j1w87dmhnvbv9l8bic3y7xxsnjmssvifw2ayvgx9mb1ivz4k"))

(define rust-scoped-tls-1.0.1
  (crate-source "scoped-tls" "1.0.1"
                "15524h04mafihcvfpgxd8f4bgc3k95aclz8grjkg9a0rxcvn9kz1"))

(define rust-scopeguard-1.2.0
  (crate-source "scopeguard" "1.2.0"
                "0jcz9sd47zlsgcnm1hdw0664krxwb5gczlif4qngj2aif8vky54l"))

(define rust-self-cell-1.2.0
  (crate-source "self_cell" "1.2.0"
                "0jg70srf4hzrw96x8iclgf6i8dfgm1x8ds2i7yzcgq0i8njraz8g"))

(define rust-serde-1.0.219
  (crate-source "serde" "1.0.219"
                "1dl6nyxnsi82a197sd752128a4avm6mxnscywas1jq30srp2q3jz"))

(define rust-serde-derive-1.0.219
  (crate-source "serde_derive" "1.0.219"
                "001azhjmj7ya52pmfiw4ppxm16nd44y15j2pf5gkcwrcgz7pc0jv"))

(define rust-serde-json-1.0.141
  (crate-source "serde_json" "1.0.141"
                "1lq39h6lmkib00r4xipg26npl22pmkcy2r7cqqb84wdy3vrfzf9h"))

(define rust-serde-json-1.0.143
  (crate-source "serde_json" "1.0.143"
                "0njabwzldvj13ykrf1aaf4gh5cgl25kf9hzbpafbv3qh3ppsn0fl"))

(define rust-serde-spanned-1.0.0
  (crate-source "serde_spanned" "1.0.0"
                "10rv91337k8x8zmfir4h8aiwmwgkq07gdv7h0jxhcwwgk10lqws0"))

(define rust-sha1-0.10.6
  (crate-source "sha1" "0.10.6"
                "1fnnxlfg08xhkmwf2ahv634as30l1i3xhlhkvxflmasi5nd85gz3"))

(define rust-sha1-checked-0.10.0
  (crate-source "sha1-checked" "0.10.0"
                "08s4h1drgwxzfn1mk11rn0r9i0rbjra1m0l2c0fbngij1jn9kxc9"))

(define rust-sha2-0.10.9
  (crate-source "sha2" "0.10.9"
                "10xjj843v31ghsksd9sl9y12qfc48157j1xpb8v1ml39jy0psl57"))

(define rust-shell-words-1.1.0
  (crate-source "shell-words" "1.1.0"
                "1plgwx8r0h5ismbbp6cp03740wmzgzhip85k5hxqrrkaddkql614"))

(define rust-shellexpand-3.1.1
  (crate-source "shellexpand" "3.1.1"
                "1fwhid2r117rbis2f6lj8mpfjf0w6lq6nqfxjha86cb3vmjxy7wb"))

(define rust-shlex-1.3.0
  (crate-source "shlex" "1.3.0"
                "0r1y6bv26c1scpxvhg2cabimrmwgbp4p3wy6syj9n0c4s3q2znhg"))

(define rust-signal-hook-0.3.18
  (crate-source "signal-hook" "0.3.18"
                "1qnnbq4g2vixfmlv28i1whkr0hikrf1bsc4xjy2aasj2yina30fq"))

(define rust-signal-hook-mio-0.2.4
  (crate-source "signal-hook-mio" "0.2.4"
                "1k8pl9aafiadr4czsg8zal9b4jdk6kq5985p90i19jc5sh31mnrl"))

(define rust-signal-hook-registry-1.4.6
  (crate-source "signal-hook-registry" "1.4.6"
                "12y2v1ms5z111fymaw1v8k93m5chnkp21h0jknrydkj8zydp395j"))

(define rust-simd-adler32-0.3.7
  (crate-source "simd-adler32" "0.3.7"
                "1zkq40c3iajcnr5936gjp9jjh1lpzhy44p3dq3fiw75iwr1w2vfn"))

(define rust-slab-0.4.11
  (crate-source "slab" "0.4.11"
                "12bm4s88rblq02jjbi1dw31984w61y2ldn13ifk5gsqgy97f8aks"))

(define rust-slotmap-1.0.7
  (crate-source "slotmap" "1.0.7"
                "0amqb2fn9lcy1ri0risblkcp88dl0rnfmynw7lx0nqwza77lmzyv"))

(define rust-smallvec-1.15.1
  (crate-source "smallvec" "1.15.1"
                "00xxdxxpgyq5vjnpljvkmy99xij5rxgh913ii1v16kzynnivgcb7"))

(define rust-smithay-client-toolkit-0.19.2
  (crate-source "smithay-client-toolkit" "0.19.2"
                "05h05hg4dn3v6br5jbdbs5nalk076a64s7fn6i01nqzby2hxwmrl"))

(define rust-smithay-clipboard-0.7.2
  (crate-source "smithay-clipboard" "0.7.2"
                "0inqnr4x458nqz0wdcanbgn77dad3bj0m7pjj074lrv3qkp1d0nc"))

(define rust-smol-str-0.2.2
  (crate-source "smol_str" "0.2.2"
                "1bfylqf2vnqaglw58930vpxm2rfzji5gjp15a2c0kh8aj6v8ylyx"))

(define rust-spirv-0.3.0+sdk-1.3.268.0
  (crate-source "spirv" "0.3.0+sdk-1.3.268.0"
                "0i3qj7yvvprai1s03dvll2gkfy8398nl64wvllkhaaa4vh1i197d"))

(define rust-stable-deref-trait-1.2.0
  (crate-source "stable_deref_trait" "1.2.0"
                "1lxjr8q2n534b2lhkxd6l6wcddzjvnksi58zv11f9y0jjmr15wd8"))

(define rust-static-assertions-1.1.0
  (crate-source "static_assertions" "1.1.0"
                "0gsl6xmw10gvn3zs1rv99laj5ig7ylffnh71f9l34js4nr4r7sx2"))

(define rust-strsim-0.11.1
  (crate-source "strsim" "0.11.1"
                "0kzvqlw8hxqb7y598w1s0hxlnmi84sg5vsipp3yg5na5d1rvba3x"))

(define rust-strum-0.26.3
  (crate-source "strum" "0.26.3"
                "01lgl6jvrf4j28v5kmx9bp480ygf1nhvac8b4p7rcj9hxw50zv4g"))

(define rust-strum-macros-0.26.4
  (crate-source "strum_macros" "0.26.4"
                "1gl1wmq24b8md527cpyd5bw9rkbqldd7k1h38kf5ajd2ln2ywssc"))

(define rust-syn-2.0.102
  (crate-source "syn" "2.0.102"
                "0qh4v2nj61y82cc713fakjckhmwyvllq9n0gpmcg147sjjppsfgn"))

(define rust-syn-2.0.104
  (crate-source "syn" "2.0.104"
                "0h2s8cxh5dsh9h41dxnlzpifqqn59cqgm0kljawws61ljq2zgdhp"))

(define rust-syn-2.0.106
  (crate-source "syn" "2.0.106"
                "19mddxp1ia00hfdzimygqmr1jqdvyl86k48427bkci4d08wc9rzd"))

(define rust-synstructure-0.13.2
  (crate-source "synstructure" "0.13.2"
                "1lh9lx3r3jb18f8sbj29am5hm9jymvbwh6jb1izsnnxgvgrp12kj"))

(define rust-sys-locale-0.3.2
  (crate-source "sys-locale" "0.3.2"
                "1i16hq9mkwpzqvixjfy1ph4i2q5klgagjg4hibz6k894l2crmawf"))

(define rust-tempfile-3.21.0
  (crate-source "tempfile" "3.21.0"
                "07kx58ibjk3ydq1gcb7q637fs5zkxaa550lxckhgg9p3427izdhm"))

(define rust-termcolor-1.4.1
  (crate-source "termcolor" "1.4.1"
                "0mappjh3fj3p2nmrg4y7qv94rchwi9mzmgmfflr8p2awdj7lyy86"))

(define rust-termsize-0.1.9
  (crate-source "termsize" "0.1.9"
                "1zb80dcqngbvw1mgkdsagwx6hvcsxr1zpql5bf6n0wn14mfgy4bg"))

(define rust-thiserror-1.0.69
  (crate-source "thiserror" "1.0.69"
                "0lizjay08agcr5hs9yfzzj6axs53a2rgx070a1dsi3jpkcrzbamn"))

(define rust-thiserror-2.0.12
  (crate-source "thiserror" "2.0.12"
                "024791nsc0np63g2pq30cjf9acj38z3jwx9apvvi8qsqmqnqlysn"))

(define rust-thiserror-2.0.16
  (crate-source "thiserror" "2.0.16"
                "1h30bqyjn5s9ypm668yd9849371rzwk185klwgjg503k2hadcrrl"))

(define rust-thiserror-impl-1.0.69
  (crate-source "thiserror-impl" "1.0.69"
                "1h84fmn2nai41cxbhk6pqf46bxqq1b344v8yz089w1chzi76rvjg"))

(define rust-thiserror-impl-2.0.12
  (crate-source "thiserror-impl" "2.0.12"
                "07bsn7shydaidvyyrm7jz29vp78vrxr9cr9044rfmn078lmz8z3z"))

(define rust-thiserror-impl-2.0.16
  (crate-source "thiserror-impl" "2.0.16"
                "0q3r1ipr1rhff6cgrcvc0njffw17rpcqz9hdc7p754cbqkhinpkc"))

(define rust-tiff-0.10.3
  (crate-source "tiff" "0.10.3"
                "0vrkdk9cdk07rh7iifcxpn6m8zv3wz695mizhr8rb3gfgzg0b5mg"))

(define rust-time-0.3.42
  (crate-source "time" "0.3.42"
                "1qz8x3xsy90w6k5f8mspsjn82gnhh5yldvc6il2vi3lxkwvngacc"))

(define rust-time-core-0.1.5
  (crate-source "time-core" "0.1.5"
                "0s0asjj3mz5ahpymx7wbqsns852aliays3cm9ck0f6w6h2rqn459"))

(define rust-time-macros-0.2.23
  (crate-source "time-macros" "0.2.23"
                "0k1k1c4rrxpqsnp3j9ixv7xazhgi701xjjdkj3jlq9m78n97k0ki"))

(define rust-tinystr-0.8.1
  (crate-source "tinystr" "0.8.1"
                "12sc6h3hnn6x78iycm5v6wrs2xhxph0ydm43yyn7gdfw8l8nsksx"))

(define rust-tinyvec-1.10.0
  (crate-source "tinyvec" "1.10.0"
                "1yhk0qdqyiaa4v2j9h8pzax5gxgwpz4da0lcphfil6g6pk1zv9dz"))

(define rust-tinyvec-macros-0.1.1
  (crate-source "tinyvec_macros" "0.1.1"
                "081gag86208sc3y6sdkshgw3vysm5d34p431dzw0bshz66ncng0z"))

(define rust-toml-0.5.11
  (crate-source "toml" "0.5.11"
                "0d2266nx8b3n22c7k24x4428z6di8n83a9n466jm7a2hipfz1xzl"))

(define rust-toml-0.9.2
  (crate-source "toml" "0.9.2"
                "1b0fcp0la720p82vcsv3lrkdgsz1lmhv02rfj2bi19rgq6bfw2pd"))

(define rust-toml-datetime-0.6.11
  (crate-source "toml_datetime" "0.6.11"
                "077ix2hb1dcya49hmi1avalwbixmrs75zgzb3b2i7g2gizwdmk92"))

(define rust-toml-datetime-0.7.0
  (crate-source "toml_datetime" "0.7.0"
                "1qwivxqkjxxwcqsvfhxnphpwphci0grdfk197wyxfn1gj0z1rpms"))

(define rust-toml-edit-0.22.27
  (crate-source "toml_edit" "0.22.27"
                "16l15xm40404asih8vyjvnka9g0xs9i4hfb6ry3ph9g419k8rzj1"))

(define rust-toml-parser-1.0.1
  (crate-source "toml_parser" "1.0.1"
                "0c6a77v4i8zll5dbpyr306iq02msjsr1fhd12b2p97h6vdr0a84p"))

(define rust-toml-writer-1.0.2
  (crate-source "toml_writer" "1.0.2"
                "0r7x3m050c66s9lssaq965vmrsxvxj131db4fq0m5vrd3w4l5j7w"))

(define rust-tracing-0.1.41
  (crate-source "tracing" "0.1.41"
                "1l5xrzyjfyayrwhvhldfnwdyligi1mpqm8mzbi2m1d6y6p2hlkkq"))

(define rust-tracing-core-0.1.34
  (crate-source "tracing-core" "0.1.34"
                "0y3nc4mpnr79rzkrcylv5f5bnjjp19lsxwis9l4kzs97ya0jbldr"))

(define rust-ttf-parser-0.25.1
  (crate-source "ttf-parser" "0.25.1"
                "0cbgqglcwwjg3hirwq6xlza54w04mb5x02kf7zx4hrw50xmr1pyj"))

(define rust-type-map-0.5.1
  (crate-source "type-map" "0.5.1"
                "143v32wwgpymxfy4y8s694vyq0wdi7li4s5dmms5w59nj2yxnc6b"))

(define rust-typenum-1.18.0
  (crate-source "typenum" "1.18.0"
                "0gwgz8n91pv40gabrr1lzji0b0hsmg0817njpy397bq7rvizzk0x"))

(define rust-unic-langid-0.9.6
  (crate-source "unic-langid" "0.9.6"
                "01bx59sqsx2jz4z7ppxq9kldcjq9dzadkmb2dr7iyc85kcnab2x2"))

(define rust-unic-langid-impl-0.9.6
  (crate-source "unic-langid-impl" "0.9.6"
                "0n66kdan4cz99n8ra18i27f7w136hmppi4wc0aa7ljsd0h4bzqfw"))

(define rust-unicode-bom-2.0.3
  (crate-source "unicode-bom" "2.0.3"
                "05s2sqyjanqrbds3fxam35f92npp5ci2wz9zg7v690r0448mvv3y"))

(define rust-unicode-ident-1.0.18
  (crate-source "unicode-ident" "1.0.18"
                "04k5r6sijkafzljykdq26mhjpmhdx4jwzvn1lh90g9ax9903jpss"))

(define rust-unicode-normalization-0.1.24
  (crate-source "unicode-normalization" "0.1.24"
                "0mnrk809z3ix1wspcqy97ld5wxdb31f3xz6nsvg5qcv289ycjcsh"))

(define rust-unicode-segmentation-1.12.0
  (crate-source "unicode-segmentation" "1.12.0"
                "14qla2jfx74yyb9ds3d2mpwpa4l4lzb9z57c6d2ba511458z5k7n"))

(define rust-unicode-width-0.1.14
  (crate-source "unicode-width" "0.1.14"
                "1bzn2zv0gp8xxbxbhifw778a7fc93pa6a1kj24jgg9msj07f7mkx"))

(define rust-unicode-width-0.2.1
  (crate-source "unicode-width" "0.2.1"
                "0k0mlq7xy1y1kq6cgv1r2rs2knn6rln3g3af50rhi0dkgp60f6ja"))

(define rust-url-2.5.4
  (crate-source "url" "2.5.4"
                "0q6sgznyy2n4l5lm16zahkisvc9nip9aa5q1pps7656xra3bdy1j"))

(define rust-url-2.5.7
  (crate-source "url" "2.5.7"
                "0nzghdv0kcksyvri0npxbjzyx2ihprks5k590y77bld355m17g08"))

(define rust-utf8-iter-1.0.4
  (crate-source "utf8_iter" "1.0.4"
                "1gmna9flnj8dbyd8ba17zigrp9c4c3zclngf5lnb5yvz1ri41hdn"))

(define rust-utf8parse-0.2.2
  (crate-source "utf8parse" "0.2.2"
                "088807qwjq46azicqwbhlmzwrbkz7l4hpw43sdkdyyk524vdxaq6"))

(define rust-version-check-0.9.5
  (crate-source "version_check" "0.9.5"
                "0nhhi4i5x89gm911azqbn7avs9mdacw2i3vcz3cnmz3mv4rqz4hb"))

(define rust-walkdir-2.5.0
  (crate-source "walkdir" "2.5.0"
                "0jsy7a710qv8gld5957ybrnc07gavppp963gs32xk4ag8130jy99"))

(define rust-wasi-0.11.1+wasi-snapshot-preview1
  (crate-source "wasi" "0.11.1+wasi-snapshot-preview1"
                "0jx49r7nbkbhyfrfyhz0bm4817yrnxgd3jiwwwfv0zl439jyrwyc"))

(define rust-wasi-0.14.3+wasi-0.2.4
  (crate-source "wasi" "0.14.3+wasi-0.2.4"
                "158c0cy561zlncw71hjh1pficw60p1nj7ki8kqm2gpbv0f1swlba"))

(define rust-wasm-bindgen-0.2.100
  (crate-source "wasm-bindgen" "0.2.100"
                "1x8ymcm6yi3i1rwj78myl1agqv2m86i648myy3lc97s9swlqkp0y"))

(define rust-wasm-bindgen-backend-0.2.100
  (crate-source "wasm-bindgen-backend" "0.2.100"
                "1ihbf1hq3y81c4md9lyh6lcwbx6a5j0fw4fygd423g62lm8hc2ig"))

(define rust-wasm-bindgen-futures-0.4.50
  (crate-source "wasm-bindgen-futures" "0.4.50"
                "0q8ymi6i9r3vxly551dhxcyai7nc491mspj0j1wbafxwq074fpam"))

(define rust-wasm-bindgen-macro-0.2.100
  (crate-source "wasm-bindgen-macro" "0.2.100"
                "01xls2dvzh38yj17jgrbiib1d3nyad7k2yw9s0mpklwys333zrkz"))

(define rust-wasm-bindgen-macro-support-0.2.100
  (crate-source "wasm-bindgen-macro-support" "0.2.100"
                "1plm8dh20jg2id0320pbmrlsv6cazfv6b6907z19ys4z1jj7xs4a"))

(define rust-wasm-bindgen-shared-0.2.100
  (crate-source "wasm-bindgen-shared" "0.2.100"
                "0gffxvqgbh9r9xl36gprkfnh3w9gl8wgia6xrin7v11sjcxxf18s"))

(define rust-wayland-backend-0.3.11
  (crate-source "wayland-backend" "0.3.11"
                "0dcvwkhz45gsm7f9dwr31pxijkhpza09a4vb3blsv9a8631k6fk7"))

(define rust-wayland-client-0.31.11
  (crate-source "wayland-client" "0.31.11"
                "17a4vl5qw4jnnh2azm0d3kcpajyb9qz4psv448zpj86w83l4fsn6"))

(define rust-wayland-csd-frame-0.3.0
  (crate-source "wayland-csd-frame" "0.3.0"
                "0zjcmcqprfzx57hlm741n89ssp4sha5yh5cnmbk2agflvclm0p32"))

(define rust-wayland-cursor-0.31.11
  (crate-source "wayland-cursor" "0.31.11"
                "0agb7ryc8p7bnylh00jvp44sl3yn4rbzg2crksqp24l8192cqz24"))

(define rust-wayland-protocols-0.32.9
  (crate-source "wayland-protocols" "0.32.9"
                "00cripl4m7hzhl0gzp4bqayal8n0zlf1llnj7cl73zgvfpnr19zg"))

(define rust-wayland-protocols-plasma-0.3.9
  (crate-source "wayland-protocols-plasma" "0.3.9"
                "0cn0qbr99snsh41p34qv11bvylbqk2xzii47k4kv6yh7ghji8ym0"))

(define rust-wayland-protocols-wlr-0.3.9
  (crate-source "wayland-protocols-wlr" "0.3.9"
                "1v3qbg18vsb3i62c6042xhjm7dcflmylzjlhl0w9kks3xmilkngg"))

(define rust-wayland-scanner-0.31.7
  (crate-source "wayland-scanner" "0.31.7"
                "1qqalp551blcxjzx80zvs7ckc19k966892zxpm81kacxqjfixjsl"))

(define rust-wayland-sys-0.31.7
  ;; TODO: Check bundled sources.
  (crate-source "wayland-sys" "0.31.7"
                "0hk157yawv9y7aj7fxbldhlvv8p33c65v3nv85mq4m91h919p51l"))

(define rust-web-sys-0.3.77
  ;; TODO: Check bundled sources.
  (crate-source "web-sys" "0.3.77"
                "1lnmc1ffbq34qw91nndklqqm75rasaffj2g4f8h1yvqqz4pdvdik"))

(define rust-web-time-1.1.0
  (crate-source "web-time" "1.1.0"
                "1fx05yqx83dhx628wb70fyy10yjfq1jpl20qfqhdkymi13rq0ras"))

(define rust-webbrowser-1.0.5
  (crate-source "webbrowser" "1.0.5"
                "166yrfz20a5qzxq881acw973537v0dq1bi6cwns853l3pb0g7x5a"))

(define rust-weezl-0.1.10
  (crate-source "weezl" "0.1.10"
                "1wqnxqn8n90bgazs6djlibf58ppdxki4slblwp9lgnq0fwkv6ld7"))

(define rust-wgpu-25.0.2
  (crate-source "wgpu" "25.0.2"
                "1nbx35282pg22qynl7rk58xvcvpm75rn9hqbv3j2niqry6cb73zc"))

(define rust-wgpu-core-25.0.2
  (crate-source "wgpu-core" "25.0.2"
                "0075aj6shyc86bwdvsvacjv0s5jm0v4fwsiwc4fm2s43dwcq5f7p"))

(define rust-wgpu-core-deps-emscripten-25.0.0
  (crate-source "wgpu-core-deps-emscripten" "25.0.0"
                "0i84q3r5q5ih3hqlwgvgb1smfiyk97q7kimc74jya61qxfndg6ph"))

(define rust-wgpu-core-deps-windows-linux-android-25.0.0
  (crate-source "wgpu-core-deps-windows-linux-android" "25.0.0"
                "0ilfyld68pwq2ywgamnz6d45f9ff7bv49m49r2kvm64wgxgzp9fb"))

(define rust-wgpu-hal-25.0.2
  (crate-source "wgpu-hal" "25.0.2"
                "05xdnkm5syz6jxaknwsxym8n83xzap6kqiyipd3kglykwizpcs7r"))

(define rust-wgpu-types-25.0.0
  (crate-source "wgpu-types" "25.0.0"
                "1g780ryy2rr7fvd6l21fbgc4v40dahjl79gwlgdqxvm8q9h9991a"))

(define rust-winapi-0.3.9
  (crate-source "winapi" "0.3.9"
                "06gl025x418lchw1wxj64ycr7gha83m44cjr5sarhynd9xkrm0sw"))

(define rust-winapi-i686-pc-windows-gnu-0.4.0
  (crate-source "winapi-i686-pc-windows-gnu" "0.4.0"
                "1dmpa6mvcvzz16zg6d5vrfy4bxgg541wxrcip7cnshi06v38ffxc"))

(define rust-winapi-util-0.1.10
  (crate-source "winapi-util" "0.1.10"
                "08hb8rj3aq9lcrfmliqs4l7v9zh6srbcn0376yn0pndkf5qvyy09"))

(define rust-winapi-util-0.1.9
  (crate-source "winapi-util" "0.1.9"
                "1fqhkcl9scd230cnfj8apfficpf5c9vhwnk4yy9xfc1sw69iq8ng"))

(define rust-winapi-x86-64-pc-windows-gnu-0.4.0
  (crate-source "winapi-x86_64-pc-windows-gnu" "0.4.0"
                "0gqq64czqb64kskjryj8isp62m2sgvx25yyj3kpc2myh85w24bki"))

(define rust-windows-0.58.0
  (crate-source "windows" "0.58.0"
                "1dkjj94b0gn91nn1n22cvm4afsj98f5qrhcl3112v6f4jcfx816x"))

(define rust-windows-aarch64-gnullvm-0.42.2
  (crate-source "windows_aarch64_gnullvm" "0.42.2"
                "1y4q0qmvl0lvp7syxvfykafvmwal5hrjb4fmv04bqs0bawc52yjr"))

(define rust-windows-aarch64-gnullvm-0.52.6
  (crate-source "windows_aarch64_gnullvm" "0.52.6"
                "1lrcq38cr2arvmz19v32qaggvj8bh1640mdm9c2fr877h0hn591j"))

(define rust-windows-aarch64-gnullvm-0.53.0
  (crate-source "windows_aarch64_gnullvm" "0.53.0"
                "0r77pbpbcf8bq4yfwpz2hpq3vns8m0yacpvs2i5cn6fx1pwxbf46"))

(define rust-windows-aarch64-msvc-0.42.2
  (crate-source "windows_aarch64_msvc" "0.42.2"
                "0hsdikjl5sa1fva5qskpwlxzpc5q9l909fpl1w6yy1hglrj8i3p0"))

(define rust-windows-aarch64-msvc-0.52.6
  (crate-source "windows_aarch64_msvc" "0.52.6"
                "0sfl0nysnz32yyfh773hpi49b1q700ah6y7sacmjbqjjn5xjmv09"))

(define rust-windows-aarch64-msvc-0.53.0
  (crate-source "windows_aarch64_msvc" "0.53.0"
                "0v766yqw51pzxxwp203yqy39ijgjamp54hhdbsyqq6x1c8gilrf7"))

(define rust-windows-core-0.58.0
  (crate-source "windows-core" "0.58.0"
                "16czypy425jzmiys4yb3pwsh7cm6grxn9kjp889iqnf2r17d99kb"))

(define rust-windows-core-0.61.2
  (crate-source "windows-core" "0.61.2"
                "1qsa3iw14wk4ngfl7ipcvdf9xyq456ms7cx2i9iwf406p7fx7zf0"))

(define rust-windows-i686-gnu-0.42.2
  (crate-source "windows_i686_gnu" "0.42.2"
                "0kx866dfrby88lqs9v1vgmrkk1z6af9lhaghh5maj7d4imyr47f6"))

(define rust-windows-i686-gnu-0.52.6
  (crate-source "windows_i686_gnu" "0.52.6"
                "02zspglbykh1jh9pi7gn8g1f97jh1rrccni9ivmrfbl0mgamm6wf"))

(define rust-windows-i686-gnu-0.53.0
  (crate-source "windows_i686_gnu" "0.53.0"
                "1hvjc8nv95sx5vdd79fivn8bpm7i517dqyf4yvsqgwrmkmjngp61"))

(define rust-windows-i686-gnullvm-0.52.6
  (crate-source "windows_i686_gnullvm" "0.52.6"
                "0rpdx1537mw6slcpqa0rm3qixmsb79nbhqy5fsm3q2q9ik9m5vhf"))

(define rust-windows-i686-gnullvm-0.53.0
  (crate-source "windows_i686_gnullvm" "0.53.0"
                "04df1in2k91qyf1wzizvh560bvyzq20yf68k8xa66vdzxnywrrlw"))

(define rust-windows-i686-msvc-0.42.2
  (crate-source "windows_i686_msvc" "0.42.2"
                "0q0h9m2aq1pygc199pa5jgc952qhcnf0zn688454i7v4xjv41n24"))

(define rust-windows-i686-msvc-0.52.6
  (crate-source "windows_i686_msvc" "0.52.6"
                "0rkcqmp4zzmfvrrrx01260q3xkpzi6fzi2x2pgdcdry50ny4h294"))

(define rust-windows-i686-msvc-0.53.0
  (crate-source "windows_i686_msvc" "0.53.0"
                "0pcvb25fkvqnp91z25qr5x61wyya12lx8p7nsa137cbb82ayw7sq"))

(define rust-windows-implement-0.58.0
  (crate-source "windows-implement" "0.58.0"
                "16spr5z65z21qyv379rv2mb1s5q2i9ibd1p2pkn0dr9qr535pg9b"))

(define rust-windows-implement-0.60.0
  (crate-source "windows-implement" "0.60.0"
                "0dm88k3hlaax85xkls4gf597ar4z8m5vzjjagzk910ph7b8xszx4"))

(define rust-windows-interface-0.58.0
  (crate-source "windows-interface" "0.58.0"
                "059mxmfvx3x88q74ms0qlxmj2pnidmr5mzn60hakn7f95m34qg05"))

(define rust-windows-interface-0.59.1
  (crate-source "windows-interface" "0.59.1"
                "1a4zr8740gyzzhq02xgl6vx8l669jwfby57xgf0zmkcdkyv134mx"))

(define rust-windows-link-0.1.3
  (crate-source "windows-link" "0.1.3"
                "12kr1p46dbhpijr4zbwr2spfgq8i8c5x55mvvfmyl96m01cx4sjy"))

(define rust-windows-result-0.2.0
  (crate-source "windows-result" "0.2.0"
                "03mf2z1xcy2slhhsm15z24p76qxgm2m74xdjp8bihyag47c4640x"))

(define rust-windows-result-0.3.4
  (crate-source "windows-result" "0.3.4"
                "1il60l6idrc6hqsij0cal0mgva6n3w6gq4ziban8wv6c6b9jpx2n"))

(define rust-windows-strings-0.1.0
  (crate-source "windows-strings" "0.1.0"
                "042dxvi3133f7dyi2pgcvknwkikk47k8bddwxbq5s0l6qhjv3nac"))

(define rust-windows-strings-0.4.2
  (crate-source "windows-strings" "0.4.2"
                "0mrv3plibkla4v5kaakc2rfksdd0b14plcmidhbkcfqc78zwkrjn"))

(define rust-windows-sys-0.45.0
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.45.0"
                "1l36bcqm4g89pknfp8r9rl1w4bn017q6a8qlx8viv0xjxzjkna3m"))

(define rust-windows-sys-0.52.0
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.52.0"
                "0gd3v4ji88490zgb6b5mq5zgbvwv7zx1ibn8v3x83rwcdbryaar8"))

(define rust-windows-sys-0.59.0
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.59.0"
                "0fw5672ziw8b3zpmnbp9pdv1famk74f1l9fcbc3zsrzdg56vqf0y"))

(define rust-windows-sys-0.60.2
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.60.2"
                "1jrbc615ihqnhjhxplr2kw7rasrskv9wj3lr80hgfd42sbj01xgj"))

(define rust-windows-targets-0.42.2
  (crate-source "windows-targets" "0.42.2"
                "0wfhnib2fisxlx8c507dbmh97kgij4r6kcxdi0f9nk6l1k080lcf"))

(define rust-windows-targets-0.52.6
  (crate-source "windows-targets" "0.52.6"
                "0wwrx625nwlfp7k93r2rra568gad1mwd888h1jwnl0vfg5r4ywlv"))

(define rust-windows-targets-0.53.1
  (crate-source "windows-targets" "0.53.1"
                "1sfy7zr2xw2smdvzk3aj0ijv063mqjnjkp7wzgw31rydj71pwd9h"))

(define rust-windows-targets-0.53.2
  (crate-source "windows-targets" "0.53.2"
                "1vwanhx2br7dh8mmrszdbcf01bccjr01mcyxcscxl4ffr7y6jvy6"))

(define rust-windows-targets-0.53.3
  (crate-source "windows-targets" "0.53.3"
                "14fwwm136dhs3i1impqrrip7nvkra3bdxa4nqkblj604qhqn1znm"))

(define rust-windows-x86-64-gnu-0.42.2
  (crate-source "windows_x86_64_gnu" "0.42.2"
                "0dnbf2xnp3xrvy8v9mgs3var4zq9v9yh9kv79035rdgyp2w15scd"))

(define rust-windows-x86-64-gnu-0.52.6
  (crate-source "windows_x86_64_gnu" "0.52.6"
                "0y0sifqcb56a56mvn7xjgs8g43p33mfqkd8wj1yhrgxzma05qyhl"))

(define rust-windows-x86-64-gnu-0.53.0
  (crate-source "windows_x86_64_gnu" "0.53.0"
                "1flh84xkssn1n6m1riddipydcksp2pdl45vdf70jygx3ksnbam9f"))

(define rust-windows-x86-64-gnullvm-0.42.2
  (crate-source "windows_x86_64_gnullvm" "0.42.2"
                "18wl9r8qbsl475j39zvawlidp1bsbinliwfymr43fibdld31pm16"))

(define rust-windows-x86-64-gnullvm-0.52.6
  (crate-source "windows_x86_64_gnullvm" "0.52.6"
                "03gda7zjx1qh8k9nnlgb7m3w3s1xkysg55hkd1wjch8pqhyv5m94"))

(define rust-windows-x86-64-gnullvm-0.53.0
  (crate-source "windows_x86_64_gnullvm" "0.53.0"
                "0mvc8119xpbi3q2m6mrjcdzl6afx4wffacp13v76g4jrs1fh6vha"))

(define rust-windows-x86-64-msvc-0.42.2
  (crate-source "windows_x86_64_msvc" "0.42.2"
                "1w5r0q0yzx827d10dpjza2ww0j8iajqhmb54s735hhaj66imvv4s"))

(define rust-windows-x86-64-msvc-0.52.6
  (crate-source "windows_x86_64_msvc" "0.52.6"
                "1v7rb5cibyzx8vak29pdrk8nx9hycsjs4w0jgms08qk49jl6v7sq"))

(define rust-windows-x86-64-msvc-0.53.0
  (crate-source "windows_x86_64_msvc" "0.53.0"
                "11h4i28hq0zlnjcaqi2xdxr7ibnpa8djfggch9rki1zzb8qi8517"))

(define rust-winit-0.30.12
  (crate-source "winit" "0.30.12"
                "0cn7wvli4s0l3v5rf6s3rn4j72mdc5p2sxhz6bv0jh4wssg4nvf6"))

(define rust-winnow-0.7.12
  (crate-source "winnow" "0.7.12"
                "159y8inpy86xswmr4yig9hxss0v2fssyqy1kk12504n8jbsfpvgk"))

(define rust-winnow-0.7.13
  (crate-source "winnow" "0.7.13"
                "1krrjc1wj2vx0r57m9nwnlc1zrhga3fq41d8w9hysvvqb5mj7811"))

(define rust-wit-bindgen-0.45.0
  (crate-source "wit-bindgen" "0.45.0"
                "053q28k1hn9qgm0l05gr9751d8q34zcz6lbzviwxiqxs3n1q68h5"))

(define rust-writeable-0.6.1
  (crate-source "writeable" "0.6.1"
                "1fx29zncvbrqzgz7li88vzdm8zvgwgwy2r9bnjqxya09pfwi0bza"))

(define rust-x11-dl-2.21.0
  (crate-source "x11-dl" "2.21.0"
                "0vsiq62xpcfm0kn9zjw5c9iycvccxl22jya8wnk18lyxzqj5jwrq"))

(define rust-x11rb-0.13.2
  (crate-source "x11rb" "0.13.2"
                "053lvnaw9ycbl791mgwly2hw27q6vqgzrb1y5kz1as52wmdsm4wr"))

(define rust-x11rb-protocol-0.13.2
  (crate-source "x11rb-protocol" "0.13.2"
                "1g81cznbyn522b0fbis0i44wh3adad2vhsz5pzf99waf3sbc4vza"))

(define rust-xcursor-0.3.10
  (crate-source "xcursor" "0.3.10"
                "0awgy98awg4ydcfmynqfcwvl4bnnfcm4i2vvnk2n926a02jy9jdy"))

(define rust-xi-unicode-0.3.0
  (crate-source "xi-unicode" "0.3.0"
                "12mvjgrhr7557cib69wm4q5s4srba27pg2df9l1zihrxgnbh0wx6"))

(define rust-xkbcommon-dl-0.4.2
  (crate-source "xkbcommon-dl" "0.4.2"
                "1iai0r3b5skd9vbr8z5b0qixiz8jblzfm778ddm8ba596a0dwffh"))

(define rust-xkeysym-0.2.1
  (crate-source "xkeysym" "0.2.1"
                "0mksx670cszyd7jln6s7dhkw11hdfv7blwwr3isq98k22ljh1k5r"))

(define rust-xml-rs-0.8.27
  (crate-source "xml-rs" "0.8.27"
                "1irplg223x6w3lvj0yig6czbiwci06495wc9xg3660kh6cvl1n3g"))

(define rust-yoke-0.8.0
  (crate-source "yoke" "0.8.0"
                "1k4mfr48vgi7wh066y11b7v1ilakghlnlhw9snzz8vi2p00vnhaz"))

(define rust-yoke-derive-0.8.0
  (crate-source "yoke-derive" "0.8.0"
                "1dha5jrjz9jaq8kmxq1aag86b98zbnm9lyjrihy5sv716sbkrniq"))

(define rust-zerocopy-0.8.26
  (crate-source "zerocopy" "0.8.26"
                "0bvsj0qzq26zc6nlrm3z10ihvjspyngs7n0jw1fz031i7h6xsf8h"))

(define rust-zerocopy-derive-0.8.26
  (crate-source "zerocopy-derive" "0.8.26"
                "10aiywi5qkha0mpsnb1zjwi44wl2rhdncaf3ykbp4i9nqm65pkwy"))

(define rust-zerofrom-0.1.6
  (crate-source "zerofrom" "0.1.6"
                "19dyky67zkjichsb7ykhv0aqws3q0jfvzww76l66c19y6gh45k2h"))

(define rust-zerofrom-derive-0.1.6
  (crate-source "zerofrom-derive" "0.1.6"
                "00l5niw7c1b0lf1vhvajpjmcnbdp2vn96jg4nmkhq2db0rp5s7np"))

(define rust-zerotrie-0.2.2
  (crate-source "zerotrie" "0.2.2"
                "15gmka7vw5k0d24s0vxgymr2j6zn2iwl12wpmpnpjgsqg3abpw1n"))

(define rust-zerovec-0.11.2
  (crate-source "zerovec" "0.11.2"
                "0a2457fmz39k9vrrj3rm82q5ykdhgxgbwfz2r6fa6nq11q4fn1aa"))

(define rust-zerovec-0.11.4
  (crate-source "zerovec" "0.11.4"
                "0fz7j1ns8d86m2fqg2a4bzi5gnh5892bxv4kcr9apwc6a3ajpap7"))

(define rust-zerovec-derive-0.11.1
  (crate-source "zerovec-derive" "0.11.1"
                "13zms8hj7vzpfswypwggyfr4ckmyc7v3di49pmj8r1qcz9z275jv"))

(define rust-zlib-rs-0.5.1
  (crate-source "zlib-rs" "0.5.1"
                "12nvshiq19nd4ksn3453ym9p0kcqf0hpaq301p2iyx9ljzxdjsv2"))

(define rust-zune-core-0.4.12
  (crate-source "zune-core" "0.4.12"
                "0jj1ra86klzlcj9aha9als9d1dzs7pqv3azs1j3n96822wn3lhiz"))

(define rust-zune-jpeg-0.4.20
  (crate-source "zune-jpeg" "0.4.20"
                "12fhlnyr254d3hys1xkrgk5qb5sqydamy76p7kdb57p7bhh7w7zw"))

(define-cargo-inputs lookup-cargo-inputs
                     (amdgpu-top =>
                                 (list rust-ab-glyph-0.2.31
                                  rust-ab-glyph-rasterizer-0.1.10
                                  rust-accesskit-0.19.0
                                  rust-adler2-2.0.1
                                  rust-ahash-0.8.12
                                  rust-android-activity-0.6.0
                                  rust-android-properties-0.2.2
                                  rust-android-system-properties-0.1.5
                                  rust-arboard-3.6.1
                                  rust-arc-swap-1.7.1
                                  rust-arrayvec-0.7.6
                                  rust-as-raw-xcb-connection-1.0.1
                                  rust-ash-0.38.0+1.3.281
                                  rust-atomic-waker-1.1.2
                                  rust-autocfg-1.5.0
                                  rust-base64-0.22.1
                                  rust-basic-toml-0.1.10
                                  rust-bit-set-0.8.0
                                  rust-bit-vec-0.8.0
                                  rust-bitflags-1.3.2
                                  rust-bitflags-2.9.3
                                  rust-block-buffer-0.10.4
                                  rust-block2-0.5.1
                                  rust-bstr-1.12.0
                                  rust-bumpalo-3.19.0
                                  rust-bytemuck-1.23.2
                                  rust-bytemuck-derive-1.10.1
                                  rust-byteorder-1.5.0
                                  rust-byteorder-lite-0.1.0
                                  rust-bytes-1.10.1
                                  rust-calloop-0.13.0
                                  rust-calloop-wayland-source-0.3.0
                                  rust-castaway-0.2.4
                                  rust-cc-1.2.35
                                  rust-cesu8-1.1.0
                                  rust-cfg-if-1.0.3
                                  rust-cfg-aliases-0.2.1
                                  rust-cgl-0.3.2
                                  rust-clipboard-win-5.4.1
                                  rust-clru-0.6.2
                                  rust-codespan-reporting-0.12.0
                                  rust-combine-4.6.7
                                  rust-compact-str-0.8.1
                                  rust-concurrent-queue-2.5.0
                                  rust-core-foundation-0.9.4
                                  rust-core-foundation-0.10.1
                                  rust-core-foundation-sys-0.8.7
                                  rust-core-graphics-0.23.2
                                  rust-core-graphics-types-0.1.3
                                  rust-cpufeatures-0.2.17
                                  rust-crc32fast-1.5.0
                                  rust-crossbeam-channel-0.5.15
                                  rust-crossbeam-utils-0.8.21
                                  rust-crossterm-0.28.1
                                  rust-crossterm-winapi-0.9.1
                                  rust-crunchy-0.2.4
                                  rust-crypto-common-0.1.6
                                  rust-cursive-0.21.1
                                  rust-cursive-macros-0.1.0
                                  rust-cursive-core-0.4.6
                                  rust-cursor-icon-1.2.0
                                  rust-darling-0.21.3
                                  rust-darling-core-0.21.3
                                  rust-darling-macro-0.21.3
                                  rust-deranged-0.5.3
                                  rust-digest-0.10.7
                                  rust-dispatch-0.2.0
                                  rust-dispatch2-0.3.0
                                  rust-displaydoc-0.2.5
                                  rust-dlib-0.5.2
                                  rust-document-features-0.2.11
                                  rust-downcast-rs-1.2.1
                                  rust-dpi-0.1.2
                                  rust-dunce-1.0.5
                                  rust-ecolor-0.32.1
                                  rust-eframe-0.32.1
                                  rust-egui-0.32.1
                                  rust-egui-wgpu-0.32.1
                                  rust-egui-winit-0.32.1
                                  rust-egui-glow-0.32.1
                                  rust-egui-plot-0.33.0
                                  rust-emath-0.32.1
                                  rust-enum-map-2.7.3
                                  rust-enum-map-derive-0.17.0
                                  rust-enumn-0.1.14
                                  rust-enumset-1.1.10
                                  rust-enumset-derive-0.14.0
                                  rust-epaint-0.32.1
                                  rust-epaint-default-fonts-0.32.1
                                  rust-equivalent-1.0.2
                                  rust-errno-0.3.13
                                  rust-error-code-3.3.2
                                  rust-faster-hex-0.10.0
                                  rust-fastrand-2.3.0
                                  rust-fax-0.2.6
                                  rust-fax-derive-0.2.0
                                  rust-fdeflate-0.3.7
                                  rust-find-crate-0.6.3
                                  rust-find-msvc-tools-0.1.0
                                  rust-flate2-1.1.2
                                  rust-fluent-0.17.0
                                  rust-fluent-bundle-0.16.0
                                  rust-fluent-langneg-0.13.0
                                  rust-fluent-syntax-0.12.0
                                  rust-fnv-1.0.7
                                  rust-foldhash-0.1.5
                                  rust-foreign-types-0.5.0
                                  rust-foreign-types-macros-0.2.3
                                  rust-foreign-types-shared-0.3.1
                                  rust-form-urlencoded-1.2.2
                                  rust-generic-array-0.14.7
                                  rust-gethostname-1.0.2
                                  rust-getrandom-0.3.3
                                  rust-gix-0.73.0
                                  rust-gix-actor-0.35.4
                                  rust-gix-chunk-0.4.11
                                  rust-gix-command-0.6.2
                                  rust-gix-commitgraph-0.29.0
                                  rust-gix-config-0.46.0
                                  rust-gix-config-value-0.15.1
                                  rust-gix-date-0.10.5
                                  rust-gix-diff-0.53.0
                                  rust-gix-discover-0.41.0
                                  rust-gix-features-0.43.1
                                  rust-gix-fs-0.16.1
                                  rust-gix-glob-0.21.0
                                  rust-gix-hash-0.19.0
                                  rust-gix-hashtable-0.9.0
                                  rust-gix-lock-18.0.0
                                  rust-gix-object-0.50.2
                                  rust-gix-odb-0.70.0
                                  rust-gix-pack-0.60.0
                                  rust-gix-packetline-0.19.1
                                  rust-gix-path-0.10.20
                                  rust-gix-protocol-0.51.0
                                  rust-gix-quote-0.6.0
                                  rust-gix-ref-0.53.1
                                  rust-gix-refspec-0.31.0
                                  rust-gix-revision-0.35.0
                                  rust-gix-revwalk-0.21.0
                                  rust-gix-sec-0.12.0
                                  rust-gix-shallow-0.5.0
                                  rust-gix-tempfile-18.0.0
                                  rust-gix-trace-0.1.13
                                  rust-gix-transport-0.48.0
                                  rust-gix-traverse-0.47.0
                                  rust-gix-url-0.32.0
                                  rust-gix-utils-0.3.0
                                  rust-gix-validate-0.10.0
                                  rust-gl-generator-0.14.0
                                  rust-glow-0.16.0
                                  rust-glutin-0.32.3
                                  rust-glutin-winit-0.5.0
                                  rust-glutin-egl-sys-0.7.1
                                  rust-glutin-glx-sys-0.6.1
                                  rust-glutin-wgl-sys-0.6.1
                                  rust-gpu-alloc-0.6.0
                                  rust-gpu-alloc-types-0.3.0
                                  rust-gpu-descriptor-0.3.2
                                  rust-gpu-descriptor-types-0.2.0
                                  rust-half-2.6.0
                                  rust-hash32-0.3.1
                                  rust-hashbrown-0.15.5
                                  rust-heapless-0.8.0
                                  rust-heck-0.5.0
                                  rust-hermit-abi-0.5.2
                                  rust-hexf-parse-0.2.1
                                  rust-home-0.5.11
                                  rust-i18n-config-0.4.8
                                  rust-i18n-embed-0.16.0
                                  rust-i18n-embed-fl-0.10.0
                                  rust-i18n-embed-impl-0.8.4
                                  rust-icu-collections-2.0.0
                                  rust-icu-locale-core-2.0.0
                                  rust-icu-normalizer-2.0.0
                                  rust-icu-normalizer-data-2.0.0
                                  rust-icu-properties-2.0.1
                                  rust-icu-properties-data-2.0.1
                                  rust-icu-provider-2.0.0
                                  rust-ident-case-1.0.1
                                  rust-idna-1.1.0
                                  rust-idna-adapter-1.2.1
                                  rust-image-0.25.7
                                  rust-indexmap-2.11.0
                                  rust-intl-memoizer-0.5.3
                                  rust-intl-pluralrules-7.0.2
                                  rust-itoa-1.0.15
                                  rust-jiff-0.2.15
                                  rust-jiff-static-0.2.15
                                  rust-jiff-tzdb-0.1.4
                                  rust-jiff-tzdb-platform-0.1.3
                                  rust-jni-0.21.1
                                  rust-jni-sys-0.3.0
                                  rust-jobserver-0.1.34
                                  rust-js-sys-0.3.77
                                  rust-khronos-egl-6.0.0
                                  rust-khronos-api-3.1.0
                                  rust-lazy-static-1.5.0
                                  rust-libc-0.2.175
                                  rust-libdrm-amdgpu-sys-0.8.8
                                  rust-libloading-0.8.8
                                  rust-libm-0.2.15
                                  rust-libredox-0.1.9
                                  rust-libz-rs-sys-0.5.1
                                  rust-linux-raw-sys-0.4.15
                                  rust-linux-raw-sys-0.9.4
                                  rust-litemap-0.8.0
                                  rust-litrs-0.4.2
                                  rust-lock-api-0.4.13
                                  rust-log-0.4.27
                                  rust-malloc-buf-0.0.6
                                  rust-maybe-async-0.2.10
                                  rust-memchr-2.7.5
                                  rust-memmap2-0.9.8
                                  rust-memoffset-0.9.1
                                  rust-miniz-oxide-0.8.9
                                  rust-mio-1.0.4
                                  rust-moxcms-0.7.5
                                  rust-naga-25.0.1
                                  rust-ndk-0.9.0
                                  rust-ndk-context-0.1.1
                                  rust-ndk-sys-0.5.0+25.2.9519653
                                  rust-ndk-sys-0.6.0+11769913
                                  rust-nix-0.30.1
                                  rust-nohash-hasher-0.2.0
                                  rust-num-0.4.3
                                  rust-num-complex-0.4.6
                                  rust-num-conv-0.1.0
                                  rust-num-integer-0.1.46
                                  rust-num-iter-0.1.45
                                  rust-num-rational-0.4.2
                                  rust-num-traits-0.2.19
                                  rust-num-enum-0.7.4
                                  rust-num-enum-derive-0.7.4
                                  rust-num-threads-0.1.7
                                  rust-objc-0.2.7
                                  rust-objc-sys-0.3.5
                                  rust-objc2-0.5.2
                                  rust-objc2-0.6.2
                                  rust-objc2-app-kit-0.2.2
                                  rust-objc2-app-kit-0.3.1
                                  rust-objc2-cloud-kit-0.2.2
                                  rust-objc2-contacts-0.2.2
                                  rust-objc2-core-data-0.2.2
                                  rust-objc2-core-foundation-0.3.1
                                  rust-objc2-core-graphics-0.3.1
                                  rust-objc2-core-image-0.2.2
                                  rust-objc2-core-location-0.2.2
                                  rust-objc2-encode-4.1.0
                                  rust-objc2-foundation-0.2.2
                                  rust-objc2-foundation-0.3.1
                                  rust-objc2-io-surface-0.3.1
                                  rust-objc2-link-presentation-0.2.2
                                  rust-objc2-metal-0.2.2
                                  rust-objc2-quartz-core-0.2.2
                                  rust-objc2-symbols-0.2.2
                                  rust-objc2-ui-kit-0.2.2
                                  rust-objc2-uniform-type-identifiers-0.2.2
                                  rust-objc2-user-notifications-0.2.2
                                  rust-once-cell-1.21.3
                                  rust-orbclient-0.3.48
                                  rust-ordered-float-4.6.0
                                  rust-owned-ttf-parser-0.25.1
                                  rust-parking-lot-0.12.4
                                  rust-parking-lot-core-0.9.11
                                  rust-percent-encoding-2.3.2
                                  rust-pin-project-1.1.10
                                  rust-pin-project-internal-1.1.10
                                  rust-pin-project-lite-0.2.16
                                  rust-pkg-config-0.3.32
                                  rust-png-0.18.0
                                  rust-polling-3.10.0
                                  rust-pollster-0.4.0
                                  rust-portable-atomic-1.11.1
                                  rust-portable-atomic-util-0.2.4
                                  rust-potential-utf-0.1.3
                                  rust-powerfmt-0.2.0
                                  rust-proc-macro-crate-3.3.0
                                  rust-proc-macro-error-attr2-2.0.0
                                  rust-proc-macro-error2-2.0.1
                                  rust-proc-macro2-1.0.101
                                  rust-prodash-30.0.1
                                  rust-profiling-1.0.17
                                  rust-pxfm-0.1.20
                                  rust-quick-error-2.0.1
                                  rust-quick-xml-0.37.5
                                  rust-quote-1.0.40
                                  rust-r-efi-5.3.0
                                  rust-raw-window-handle-0.6.2
                                  rust-redox-syscall-0.4.1
                                  rust-redox-syscall-0.5.17
                                  rust-regex-automata-0.4.10
                                  rust-renderdoc-sys-1.1.0
                                  rust-ron-0.10.1
                                  rust-rust-embed-8.7.2
                                  rust-rust-embed-impl-8.7.2
                                  rust-rust-embed-utils-8.7.2
                                  rust-rustc-hash-1.1.0
                                  rust-rustc-hash-2.1.1
                                  rust-rustix-0.38.44
                                  rust-rustix-1.0.8
                                  rust-rustversion-1.0.22
                                  rust-ryu-1.0.20
                                  rust-same-file-1.0.6
                                  rust-scoped-tls-1.0.1
                                  rust-scopeguard-1.2.0
                                  rust-self-cell-1.2.0
                                  rust-serde-1.0.219
                                  rust-serde-derive-1.0.219
                                  rust-serde-json-1.0.143
                                  rust-sha1-0.10.6
                                  rust-sha1-checked-0.10.0
                                  rust-sha2-0.10.9
                                  rust-shell-words-1.1.0
                                  rust-shlex-1.3.0
                                  rust-signal-hook-0.3.18
                                  rust-signal-hook-mio-0.2.4
                                  rust-signal-hook-registry-1.4.6
                                  rust-simd-adler32-0.3.7
                                  rust-slab-0.4.11
                                  rust-slotmap-1.0.7
                                  rust-smallvec-1.15.1
                                  rust-smithay-client-toolkit-0.19.2
                                  rust-smithay-clipboard-0.7.2
                                  rust-smol-str-0.2.2
                                  rust-spirv-0.3.0+sdk-1.3.268.0
                                  rust-stable-deref-trait-1.2.0
                                  rust-static-assertions-1.1.0
                                  rust-strsim-0.11.1
                                  rust-strum-0.26.3
                                  rust-strum-macros-0.26.4
                                  rust-syn-2.0.106
                                  rust-synstructure-0.13.2
                                  rust-sys-locale-0.3.2
                                  rust-tempfile-3.21.0
                                  rust-termcolor-1.4.1
                                  rust-termsize-0.1.9
                                  rust-thiserror-1.0.69
                                  rust-thiserror-2.0.16
                                  rust-thiserror-impl-1.0.69
                                  rust-thiserror-impl-2.0.16
                                  rust-tiff-0.10.3
                                  rust-time-0.3.42
                                  rust-time-core-0.1.5
                                  rust-time-macros-0.2.23
                                  rust-tinystr-0.8.1
                                  rust-tinyvec-1.10.0
                                  rust-tinyvec-macros-0.1.1
                                  rust-toml-0.5.11
                                  rust-toml-datetime-0.6.11
                                  rust-toml-edit-0.22.27
                                  rust-tracing-0.1.41
                                  rust-tracing-core-0.1.34
                                  rust-ttf-parser-0.25.1
                                  rust-type-map-0.5.1
                                  rust-typenum-1.18.0
                                  rust-unic-langid-0.9.6
                                  rust-unic-langid-impl-0.9.6
                                  rust-unicode-bom-2.0.3
                                  rust-unicode-ident-1.0.18
                                  rust-unicode-normalization-0.1.24
                                  rust-unicode-segmentation-1.12.0
                                  rust-unicode-width-0.1.14
                                  rust-unicode-width-0.2.1
                                  rust-url-2.5.7
                                  rust-utf8-iter-1.0.4
                                  rust-version-check-0.9.5
                                  rust-walkdir-2.5.0
                                  rust-wasi-0.11.1+wasi-snapshot-preview1
                                  rust-wasi-0.14.3+wasi-0.2.4
                                  rust-wasm-bindgen-0.2.100
                                  rust-wasm-bindgen-backend-0.2.100
                                  rust-wasm-bindgen-futures-0.4.50
                                  rust-wasm-bindgen-macro-0.2.100
                                  rust-wasm-bindgen-macro-support-0.2.100
                                  rust-wasm-bindgen-shared-0.2.100
                                  rust-wayland-backend-0.3.11
                                  rust-wayland-client-0.31.11
                                  rust-wayland-csd-frame-0.3.0
                                  rust-wayland-cursor-0.31.11
                                  rust-wayland-protocols-0.32.9
                                  rust-wayland-protocols-plasma-0.3.9
                                  rust-wayland-protocols-wlr-0.3.9
                                  rust-wayland-scanner-0.31.7
                                  rust-wayland-sys-0.31.7
                                  rust-web-sys-0.3.77
                                  rust-web-time-1.1.0
                                  rust-webbrowser-1.0.5
                                  rust-weezl-0.1.10
                                  rust-wgpu-25.0.2
                                  rust-wgpu-core-25.0.2
                                  rust-wgpu-core-deps-emscripten-25.0.0
                                  rust-wgpu-core-deps-windows-linux-android-25.0.0
                                  rust-wgpu-hal-25.0.2
                                  rust-wgpu-types-25.0.0
                                  rust-winapi-0.3.9
                                  rust-winapi-i686-pc-windows-gnu-0.4.0
                                  rust-winapi-util-0.1.10
                                  rust-winapi-x86-64-pc-windows-gnu-0.4.0
                                  rust-windows-0.58.0
                                  rust-windows-core-0.58.0
                                  rust-windows-implement-0.58.0
                                  rust-windows-interface-0.58.0
                                  rust-windows-link-0.1.3
                                  rust-windows-result-0.2.0
                                  rust-windows-strings-0.1.0
                                  rust-windows-sys-0.45.0
                                  rust-windows-sys-0.52.0
                                  rust-windows-sys-0.59.0
                                  rust-windows-sys-0.60.2
                                  rust-windows-targets-0.42.2
                                  rust-windows-targets-0.52.6
                                  rust-windows-targets-0.53.3
                                  rust-windows-aarch64-gnullvm-0.42.2
                                  rust-windows-aarch64-gnullvm-0.52.6
                                  rust-windows-aarch64-gnullvm-0.53.0
                                  rust-windows-aarch64-msvc-0.42.2
                                  rust-windows-aarch64-msvc-0.52.6
                                  rust-windows-aarch64-msvc-0.53.0
                                  rust-windows-i686-gnu-0.42.2
                                  rust-windows-i686-gnu-0.52.6
                                  rust-windows-i686-gnu-0.53.0
                                  rust-windows-i686-gnullvm-0.52.6
                                  rust-windows-i686-gnullvm-0.53.0
                                  rust-windows-i686-msvc-0.42.2
                                  rust-windows-i686-msvc-0.52.6
                                  rust-windows-i686-msvc-0.53.0
                                  rust-windows-x86-64-gnu-0.42.2
                                  rust-windows-x86-64-gnu-0.52.6
                                  rust-windows-x86-64-gnu-0.53.0
                                  rust-windows-x86-64-gnullvm-0.42.2
                                  rust-windows-x86-64-gnullvm-0.52.6
                                  rust-windows-x86-64-gnullvm-0.53.0
                                  rust-windows-x86-64-msvc-0.42.2
                                  rust-windows-x86-64-msvc-0.52.6
                                  rust-windows-x86-64-msvc-0.53.0
                                  rust-winit-0.30.12
                                  rust-winnow-0.7.13
                                  rust-wit-bindgen-0.45.0
                                  rust-writeable-0.6.1
                                  rust-x11-dl-2.21.0
                                  rust-x11rb-0.13.2
                                  rust-x11rb-protocol-0.13.2
                                  rust-xcursor-0.3.10
                                  rust-xi-unicode-0.3.0
                                  rust-xkbcommon-dl-0.4.2
                                  rust-xkeysym-0.2.1
                                  rust-xml-rs-0.8.27
                                  rust-yoke-0.8.0
                                  rust-yoke-derive-0.8.0
                                  rust-zerocopy-0.8.26
                                  rust-zerocopy-derive-0.8.26
                                  rust-zerofrom-0.1.6
                                  rust-zerofrom-derive-0.1.6
                                  rust-zerotrie-0.2.2
                                  rust-zerovec-0.11.4
                                  rust-zerovec-derive-0.11.1
                                  rust-zlib-rs-0.5.1
                                  rust-zune-core-0.4.12
                                  rust-zune-jpeg-0.4.20))
                     (rhq =>
                          (list rust-addr2line-0.24.2
                                rust-adler2-2.0.1
                                rust-aho-corasick-1.1.3
                                rust-android-tzdata-0.1.1
                                rust-android-system-properties-0.1.5
                                rust-anstream-0.6.19
                                rust-anstyle-1.0.11
                                rust-anstyle-parse-0.2.7
                                rust-anstyle-query-1.1.3
                                rust-anstyle-wincon-3.0.9
                                rust-anyhow-1.0.98
                                rust-autocfg-1.5.0
                                rust-backtrace-0.3.75
                                rust-better-panic-0.3.0
                                rust-bitflags-2.9.1
                                rust-bumpalo-3.19.0
                                rust-cc-1.2.30
                                rust-cfg-if-1.0.1
                                rust-chrono-0.4.41
                                rust-clap-4.5.41
                                rust-clap-builder-4.5.41
                                rust-clap-complete-4.5.55
                                rust-clap-derive-4.5.41
                                rust-clap-lex-0.7.5
                                rust-colorchoice-1.0.4
                                rust-console-0.15.11
                                rust-core-foundation-sys-0.8.7
                                rust-dirs-6.0.0
                                rust-dirs-sys-0.5.0
                                rust-displaydoc-0.2.5
                                rust-encode-unicode-1.0.0
                                rust-env-logger-0.10.2
                                rust-equivalent-1.0.2
                                rust-form-urlencoded-1.2.1
                                rust-getrandom-0.2.16
                                rust-gimli-0.31.1
                                rust-glob-0.3.2
                                rust-hashbrown-0.15.4
                                rust-heck-0.5.0
                                rust-hermit-abi-0.5.2
                                rust-humantime-2.2.0
                                rust-iana-time-zone-0.1.63
                                rust-iana-time-zone-haiku-0.1.2
                                rust-icu-collections-2.0.0
                                rust-icu-locale-core-2.0.0
                                rust-icu-normalizer-2.0.0
                                rust-icu-normalizer-data-2.0.0
                                rust-icu-properties-2.0.1
                                rust-icu-properties-data-2.0.1
                                rust-icu-provider-2.0.0
                                rust-idna-1.0.3
                                rust-idna-adapter-1.2.1
                                rust-indexmap-2.10.0
                                rust-is-terminal-0.4.16
                                rust-is-terminal-polyfill-1.70.1
                                rust-itoa-1.0.15
                                rust-js-sys-0.3.77
                                rust-libc-0.2.174
                                rust-libredox-0.1.6
                                rust-litemap-0.8.0
                                rust-log-0.4.27
                                rust-memchr-2.7.5
                                rust-miniz-oxide-0.8.9
                                rust-num-traits-0.2.19
                                rust-object-0.36.7
                                rust-once-cell-1.21.3
                                rust-once-cell-polyfill-1.70.1
                                rust-option-ext-0.2.0
                                rust-percent-encoding-2.3.1
                                rust-potential-utf-0.1.2
                                rust-pretty-env-logger-0.5.0
                                rust-proc-macro2-1.0.95
                                rust-quote-1.0.40
                                rust-redox-users-0.5.0
                                rust-regex-1.11.1
                                rust-regex-automata-0.4.9
                                rust-regex-syntax-0.8.5
                                rust-rustc-demangle-0.1.25
                                rust-rustversion-1.0.21
                                rust-ryu-1.0.20
                                rust-same-file-1.0.6
                                rust-serde-1.0.219
                                rust-serde-derive-1.0.219
                                rust-serde-json-1.0.141
                                rust-serde-spanned-1.0.0
                                rust-shellexpand-3.1.1
                                rust-shlex-1.3.0
                                rust-smallvec-1.15.1
                                rust-stable-deref-trait-1.2.0
                                rust-strsim-0.11.1
                                rust-syn-2.0.104
                                rust-synstructure-0.13.2
                                rust-termcolor-1.4.1
                                rust-thiserror-2.0.12
                                rust-thiserror-impl-2.0.12
                                rust-tinystr-0.8.1
                                rust-toml-0.9.2
                                rust-toml-datetime-0.7.0
                                rust-toml-parser-1.0.1
                                rust-toml-writer-1.0.2
                                rust-unicode-ident-1.0.18
                                rust-url-2.5.4
                                rust-utf8-iter-1.0.4
                                rust-utf8parse-0.2.2
                                rust-walkdir-2.5.0
                                rust-wasi-0.11.1+wasi-snapshot-preview1
                                rust-wasm-bindgen-0.2.100
                                rust-wasm-bindgen-backend-0.2.100
                                rust-wasm-bindgen-macro-0.2.100
                                rust-wasm-bindgen-macro-support-0.2.100
                                rust-wasm-bindgen-shared-0.2.100
                                rust-winapi-util-0.1.9
                                rust-windows-core-0.61.2
                                rust-windows-implement-0.60.0
                                rust-windows-interface-0.59.1
                                rust-windows-link-0.1.3
                                rust-windows-result-0.3.4
                                rust-windows-strings-0.4.2
                                rust-windows-sys-0.59.0
                                rust-windows-sys-0.60.2
                                rust-windows-targets-0.52.6
                                rust-windows-targets-0.53.2
                                rust-windows-aarch64-gnullvm-0.52.6
                                rust-windows-aarch64-gnullvm-0.53.0
                                rust-windows-aarch64-msvc-0.52.6
                                rust-windows-aarch64-msvc-0.53.0
                                rust-windows-i686-gnu-0.52.6
                                rust-windows-i686-gnu-0.53.0
                                rust-windows-i686-gnullvm-0.52.6
                                rust-windows-i686-gnullvm-0.53.0
                                rust-windows-i686-msvc-0.52.6
                                rust-windows-i686-msvc-0.53.0
                                rust-windows-x86-64-gnu-0.52.6
                                rust-windows-x86-64-gnu-0.53.0
                                rust-windows-x86-64-gnullvm-0.52.6
                                rust-windows-x86-64-gnullvm-0.53.0
                                rust-windows-x86-64-msvc-0.52.6
                                rust-windows-x86-64-msvc-0.53.0
                                rust-winnow-0.7.12
                                rust-writeable-0.6.1
                                rust-yoke-0.8.0
                                rust-yoke-derive-0.8.0
                                rust-zerofrom-0.1.6
                                rust-zerofrom-derive-0.1.6
                                rust-zerotrie-0.2.2
                                rust-zerovec-0.11.2
                                rust-zerovec-derive-0.11.1)))
