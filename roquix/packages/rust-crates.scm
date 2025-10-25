;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2025 Hilton Chain <hako@ultrarare.space>
;;; Copyright © 2025 ROCKTAKEY <rocktakey@gmail.com>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (roquix packages rust-crates)
  #:use-module (guix packages)
  #:use-module ((guix licenses)
                #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages rust-crates)
  #:export (lookup-cargo-inputs))


;;;
;;; This file is managed by ‘guix import’.  Do NOT add definitions manually.
;;;

;;;
;;; Rust libraries fetched from crates.io and non-workspace development
;;; snapshots.
;;;

(define qqqq-separator 'begin-of-crates)

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

(define rust-addr2line-0.25.1
  (crate-source "addr2line" "0.25.1"
                "0jwb96gv17vdr29hbzi0ha5q6jkpgjyn7rjlg5nis65k41rk0p8v"))

(define rust-adler2-2.0.0
  (crate-source "adler2" "2.0.0"
                "09r6drylvgy8vv8k20lnbvwq8gp09h7smfn6h1rxsy15pgh629si"))

(define rust-adler2-2.0.1
  (crate-source "adler2" "2.0.1"
                "1ymy18s9hs7ya1pjc9864l30wk8p2qfqdi7mhhcc5nfakxbij09j"))

(define rust-aes-0.8.4
  (crate-source "aes" "0.8.4"
                "1853796anlwp4kqim0s6wm1srl4ib621nm0cl2h3c8klsjkgfsdi"))

(define rust-ahash-0.8.12
  (crate-source "ahash" "0.8.12"
                "0xbsp9rlm5ki017c0w6ay8kjwinwm8knjncci95mii30rmwz25as"))

(define rust-aho-corasick-1.1.1
  (crate-source "aho-corasick" "1.1.1"
                "1aqqalh66jygy54fbnpglzrb9dwlrvn6zl1nhncdvynl8w376pga"))

(define rust-aho-corasick-1.1.3
  (crate-source "aho-corasick" "1.1.3"
                "05mrpkvdgp5d20y2p989f187ry9diliijgwrs254fs9s1m1x6q4f"))

(define rust-allocative-0.3.4
  (crate-source "allocative" "0.3.4"
                "1xqh0w5msvjjs3dx15ajbvdfj9690g58da1akgp8r2yv27k2rb4g"))

(define rust-allocative-derive-0.3.3
  (crate-source "allocative_derive" "0.3.3"
                "1ax4wpf0v3cfy2wmwd1h3clmri6ymj87q7a2aqdgrq23fqvkl8zy"))

(define rust-allocator-api2-0.2.21
  (crate-source "allocator-api2" "0.2.21"
                "08zrzs022xwndihvzdn78yqarv2b9696y67i6h78nla3ww87jgb8"))

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

(define rust-anes-0.1.6
  (crate-source "anes" "0.1.6"
                "16bj1ww1xkwzbckk32j2pnbn5vk6wgsl3q4p3j9551xbcarwnijb"))

(define rust-annotate-snippets-0.9.2
  (crate-source "annotate-snippets" "0.9.2"
                "07p8r6jzb7nqydq0kr5pllckqcdxlyld2g275v425axnzffpxbyc"))

(define rust-ansi-to-tui-7.0.0
  (crate-source "ansi-to-tui" "7.0.0"
                "0b4iynqcqaav8i55w8lk7ypm6xr845vh32lcw8vxffff3qgmwmb7"))

(define rust-anstream-0.6.11
  (crate-source "anstream" "0.6.11"
                "19dndamalavhjwp4i74k8hdijcixb7gsfa6ycwyc1r8xn6y1wbkf"))

(define rust-anstream-0.6.19
  (crate-source "anstream" "0.6.19"
                "0crr9a207dyn8k66xgvhvmlxm9raiwpss3syfa35c6265s9z26ih"))

(define rust-anstream-0.6.20
  (crate-source "anstream" "0.6.20"
                "14k1iqdf3dx7hdjllmql0j9sjxkwr1lfdddi3adzff0r7mjn7r9s"))

(define rust-anstream-0.6.21
  (crate-source "anstream" "0.6.21"
                "0jjgixms4qjj58dzr846h2s29p8w7ynwr9b9x6246m1pwy0v5ma3"))

(define rust-anstyle-1.0.11
  (crate-source "anstyle" "1.0.11"
                "1gbbzi0zbgff405q14v8hhpi1kz2drzl9a75r3qhks47lindjbl6"))

(define rust-anstyle-1.0.13
  (crate-source "anstyle" "1.0.13"
                "0y2ynjqajpny6q0amvfzzgw0gfw3l47z85km4gvx87vg02lcr4ji"))

(define rust-anstyle-1.0.8
  (crate-source "anstyle" "1.0.8"
                "1cfmkza63xpn1kkz844mgjwm9miaiz4jkyczmwxzivcsypk1vv0v"))

(define rust-anstyle-parse-0.2.1
  (crate-source "anstyle-parse" "0.2.1"
                "0cy38fbdlnmwyy6q8dn8dcfrpycwnpjkljsjqn3kmc40b7zp924k"))

(define rust-anstyle-parse-0.2.7
  (crate-source "anstyle-parse" "0.2.7"
                "1hhmkkfr95d462b3zf6yl2vfzdqfy5726ya572wwg8ha9y148xjf"))

(define rust-anstyle-query-1.0.0
  (crate-source "anstyle-query" "1.0.0"
                "0js9bgpqz21g0p2nm350cba1d0zfyixsma9lhyycic5sw55iv8aw"))

(define rust-anstyle-query-1.1.3
  (crate-source "anstyle-query" "1.1.3"
                "1sgs2hq54wayrmpvy784ww2ccv9f8yhhpasv12z872bx0jvdx2vc"))

(define rust-anstyle-query-1.1.4
  (crate-source "anstyle-query" "1.1.4"
                "1qir6d6fl5a4y2gmmw9a5w93ckwx6xn51aryd83p26zn6ihiy8wy"))

(define rust-anstyle-wincon-3.0.1
  (crate-source "anstyle-wincon" "3.0.1"
                "0a066gr4p7bha8qwnxyrpbrqzjdvk8l7pdg7isljimpls889ssgh"))

(define rust-anstyle-wincon-3.0.10
  (crate-source "anstyle-wincon" "3.0.10"
                "0ajz9wsf46a2l3pds7v62xbhq2cffj7wrilamkx2z8r28m0k61iy"))

(define rust-anstyle-wincon-3.0.9
  (crate-source "anstyle-wincon" "3.0.9"
                "10n8mcgr89risdf35i73zc67aaa392bhggwzqlri1fv79297ags0"))

(define rust-anyhow-1.0.100
  (crate-source "anyhow" "1.0.100"
                "0qbfmw4hhv2ampza1csyvf1jqjs2dgrj29cv3h3sh623c6qvcgm2"))

(define rust-anyhow-1.0.98
  (crate-source "anyhow" "1.0.98"
                "11ylvjdrcjs0q9jgk1af4r5cx1qppj63plxqkq595vmc24rjsvg1"))

(define rust-anyhow-1.0.99
  (crate-source "anyhow" "1.0.99"
                "001icqvkfl28rxxmk99rm4gvdzxqngj5v50yg2bh3dzcvqfllrxh"))

(define rust-arboard-3.6.0
  (crate-source "arboard" "3.6.0"
                "09sjqy9555g1nr22xfh07y2mhcnzh69vjydrbvz6y8xgw3w37xam"))

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

(define rust-ascii-1.1.0
  (crate-source "ascii" "1.1.0"
                "05nyyp39x4wzc1959kv7ckwqpkdzjd9dw4slzyjh73qbhjcfqayr"))

(define rust-ascii-canvas-3.0.0
  (crate-source "ascii-canvas" "3.0.0"
                "1in38ziqn4kh9sw89ys4naaqzvvjscfs0m4djqbfq7455v5fq948"))

(define rust-ash-0.38.0+1.3.281
  (crate-source "ash" "0.38.0+1.3.281"
                "0vx4yf689v1rc680jvy8bnysx5sgd8f33wnp2vqaizh0v0v4kd0b"))

(define rust-askama-0.12.1
  (crate-source "askama" "0.12.1"
                "0a1cmp0f1b01zzbzzp81ppa6r754zpax5372aykswz5933gr345p"))

(define rust-askama-derive-0.12.5
  (crate-source "askama_derive" "0.12.5"
                "10qxszzrwbabpd3jh6lvk3q1a81ryfba8bh75jb18irwn5n8vzhr"))

(define rust-askama-escape-0.10.3
  (crate-source "askama_escape" "0.10.3"
                "0hg3rz0cma5f6385z7qmqw3jbir76jndwd5s7dqfk92v9gil75v1"))

(define rust-askama-parser-0.2.1
  (crate-source "askama_parser" "0.2.1"
                "1h00vcnqq9qqlayx1ass4an458rk4lm3q88867cc7lb4dcf1dcdc"))

(define rust-assert-cmd-2.0.17
  (crate-source "assert_cmd" "2.0.17"
                "0rhb6b0w23pbqcj1mkgdv8j3g9602d4jjmg45ql022lpnaj8klrb"))

(define rust-assert-json-diff-2.0.2
  (crate-source "assert-json-diff" "2.0.2"
                "04mg3w0rh3schpla51l18362hsirl23q93aisws2irrj32wg5r27"))

(define rust-assert-matches-1.5.0
  (crate-source "assert_matches" "1.5.0"
                "1a9b3p9vy0msylyr2022sk5flid37ini1dxji5l3vwxsvw4xcd4v"))

(define rust-async-broadcast-0.7.2
  (crate-source "async-broadcast" "0.7.2"
                "0ckmqcwyqwbl2cijk1y4r0vy60i89gqc86ijrxzz5f2m4yjqfnj3"))

(define rust-async-channel-2.5.0
  (crate-source "async-channel" "2.5.0"
                "1ljq24ig8lgs2555myrrjighycpx2mbjgrm3q7lpa6rdsmnxjklj"))

(define rust-async-executor-1.13.3
  (crate-source "async-executor" "1.13.3"
                "1f3za9v8wkqzv6rz69g0qzvdcmghwbixijwzldwjm9w3zph00z29"))

(define rust-async-fs-2.2.0
  (crate-source "async-fs" "2.2.0"
                "1iclw9970mh4ndb0bd68a6901kqy81rf9yypvf78pvaavy0scd40"))

(define rust-async-io-2.6.0
  (crate-source "async-io" "2.6.0"
                "1z16s18bm4jxlmp6rif38mvn55442yd3wjvdfhvx4hkgxf7qlss5"))

(define rust-async-lock-3.4.1
  (crate-source "async-lock" "3.4.1"
                "1p6i1sw3mwv1msdx9jqkr0h0a2jlrp3717yyx5n9pvkw0h23dl2z"))

(define rust-async-process-2.5.0
  (crate-source "async-process" "2.5.0"
                "0xfswxmng6835hjlfhv7k0jrfp7czqxpfj6y2s5dsp05q0g94l7w"))

(define rust-async-recursion-1.1.1
  (crate-source "async-recursion" "1.1.1"
                "04ac4zh8qz2xjc79lmfi4jlqj5f92xjvfaqvbzwkizyqd4pl4hrv"))

(define rust-async-signal-0.2.13
  (crate-source "async-signal" "0.2.13"
                "0k66mpb3xp86hj4vxs7w40v7qz2jfbblrm9ddc5mglwwynxp1h23"))

(define rust-async-stream-0.3.6
  (crate-source "async-stream" "0.3.6"
                "0xl4zqncrdmw2g6241wgr11dxdg4h7byy6bz3l6si03qyfk72nhb"))

(define rust-async-stream-impl-0.3.6
  (crate-source "async-stream-impl" "0.3.6"
                "0kaplfb5axsvf1gfs2gk6c4zx6zcsns0yf3ssk7iwni7bphlvhn7"))

(define rust-async-task-4.7.1
  (crate-source "async-task" "4.7.1"
                "1pp3avr4ri2nbh7s6y9ws0397nkx1zymmcr14sq761ljarh3axcb"))

(define rust-async-trait-0.1.89
  (crate-source "async-trait" "0.1.89"
                "1fsxxmz3rzx1prn1h3rs7kyjhkap60i7xvi0ldapkvbb14nssdch"))

(define rust-atomic-waker-1.1.2
  (crate-source "atomic-waker" "1.1.2"
                "1h5av1lw56m0jf0fd3bchxq8a30xv0b4wv8s4zkp4s0i7mfvs18m"))

(define rust-auto-impl-1.3.0
  (crate-source "auto_impl" "1.3.0"
                "1rzysfb0zpwsi2lg043fj596xj2a4xir2lc0fd17im64vc5vgp7z"))

(define rust-autocfg-1.1.0
  (crate-source "autocfg" "1.1.0"
                "1ylp3cb47ylzabimazvbz9ms6ap784zhb6syaz6c1jqpmcmq0s6l"))

(define rust-autocfg-1.5.0
  (crate-source "autocfg" "1.5.0"
                "1s77f98id9l4af4alklmzq46f21c980v13z2r1pcxx6bqgw0d1n0"))

(define rust-axum-0.8.4
  (crate-source "axum" "0.8.4"
                "1d99kb3vcjnhbgrf6hysllf25hzagw7m1i1nidjpgsaa30n8c7h2"))

(define rust-axum-0.8.6
  (crate-source "axum" "0.8.6"
                "0w9qyxcp77gwswc9sz3pf2rzpm4jycpxvd70yh8i60sjccrys64a"))

(define rust-axum-core-0.5.2
  (crate-source "axum-core" "0.5.2"
                "19kwzksb4hwr3qfbrhjbqf83z6fjyng14wrkzck6fj1g8784qik8"))

(define rust-axum-core-0.5.5
  (crate-source "axum-core" "0.5.5"
                "08pa4752h96pai7j5avr2hnq35xh7qgv6vl57y1zhhnikkhnqi2r"))

(define rust-backtrace-0.3.75
  (crate-source "backtrace" "0.3.75"
                "00hhizz29mvd7cdqyz5wrj98vqkihgcxmv2vl7z0d0f53qrac1k8"))

(define rust-backtrace-0.3.76
  (crate-source "backtrace" "0.3.76"
                "1mibx75x4jf6wz7qjifynld3hpw3vq6sy3d3c9y5s88sg59ihlxv"))

(define rust-base64-0.22.1
  (crate-source "base64" "0.22.1"
                "1imqzgh7bxcikp5vx3shqvw9j09g9ly0xr0jma0q66i52r7jbcvj"))

(define rust-basic-toml-0.1.10
  (crate-source "basic-toml" "0.1.10"
                "12hp59jl28kk229q4sqx6v4fc9p66v8i2byi0vlc9922h9g6fqms"))

(define rust-beef-0.5.2
  (crate-source "beef" "0.5.2"
                "1c95lbnhld96iwwbyh5kzykbpysq0fnjfhwxa1mhap5qxgrl30is"))

(define rust-better-panic-0.3.0
  (crate-source "better-panic" "0.3.0"
                "0djh7qs39z0mbkzxs4nrc9ngnyjpsxq67lqfv75q91i63b8y3abg"))

(define rust-bindgen-0.72.0
  (crate-source "bindgen" "0.72.0"
                "0vvjgfw3rq2lw163qahjdr0qr14bj4lm23syk9hhp39i6jbj0wjg"))

(define rust-bit-set-0.5.3
  (crate-source "bit-set" "0.5.3"
                "1wcm9vxi00ma4rcxkl3pzzjli6ihrpn9cfdi0c5b4cvga2mxs007"))

(define rust-bit-set-0.8.0
  (crate-source "bit-set" "0.8.0"
                "18riaa10s6n59n39vix0cr7l2dgwdhcpbcm97x1xbyfp1q47x008"))

(define rust-bit-vec-0.6.3
  (crate-source "bit-vec" "0.6.3"
                "1ywqjnv60cdh1slhz67psnp422md6jdliji6alq0gmly2xm9p7rl"))

(define rust-bit-vec-0.8.0
  (crate-source "bit-vec" "0.8.0"
                "1xxa1s2cj291r7k1whbxq840jxvmdsq9xgh7bvrxl46m80fllxjy"))

(define rust-bitflags-1.3.2
  (crate-source "bitflags" "1.3.2"
                "12ki6w8gn1ldq7yz9y680llwk5gmrhrzszaa17g1sbrw2r2qvwxy"))

(define rust-bitflags-2.8.0
  (crate-source "bitflags" "2.8.0"
                "0dixc6168i98652jxf0z9nbyn0zcis3g6hi6qdr7z5dbhcygas4g"))

(define rust-bitflags-2.9.1
  (crate-source "bitflags" "2.9.1"
                "0rz9rpp5wywwqb3mxfkywh4drmzci2fch780q7lifbf6bsc5d3hv"))

(define rust-bitflags-2.9.3
  (crate-source "bitflags" "2.9.3"
                "0pgjwsd9qgdmsmwpvg47p9ccrsc26yfjqawbhsi9qds5sg6brvrl"))

(define rust-bitflags-2.9.4
  (crate-source "bitflags" "2.9.4"
                "157kkcv8s7vk6d17dar1pa5cqcz4c8pdrn16wm1ld7jnr86d2q92"))

(define rust-block-buffer-0.10.4
  (crate-source "block-buffer" "0.10.4"
                "0w9sa2ypmrsqqvc20nhwr75wbb5cjr4kkyhpjm1z1lv2kdicfy1h"))

(define rust-block-padding-0.3.3
  (crate-source "block-padding" "0.3.3"
                "14wdad0r1qk5gmszxqd8cky6vx8qg7c153jv981mixzrpzmlz2d8"))

(define rust-block2-0.5.1
  (crate-source "block2" "0.5.1"
                "0pyiha5his2grzqr3mynmq244laql2j20992i59asp0gy7mjw4rc"))

(define rust-blocking-1.6.2
  (crate-source "blocking" "1.6.2"
                "08bz3f9agqlp3102snkvsll6wc9ag7x5m1xy45ak2rv9pq18sgz8"))

(define rust-borrow-or-share-0.2.2
  (crate-source "borrow-or-share" "0.2.2"
                "0ciski5i69a8mx6f0fh901hn73fii3g39lpl8k3xgi88651b9siy"))

(define rust-bstr-1.12.0
  (crate-source "bstr" "1.12.0"
                "195i0gd7r7jg7a8spkmw08492n7rmiabcvz880xn2z8dkp8i6h93"))

(define rust-bumpalo-3.14.0
  (crate-source "bumpalo" "3.14.0"
                "1v4arnv9kwk54v5d0qqpv4vyw2sgr660nk0w3apzixi1cm3yfc3z"))

(define rust-bumpalo-3.19.0
  (crate-source "bumpalo" "3.19.0"
                "0hsdndvcpqbjb85ghrhska2qxvp9i75q2vb70hma9fxqawdy9ia6"))

(define rust-bytemuck-1.23.1
  (crate-source "bytemuck" "1.23.1"
                "08ilqv7x5lckj82i41j5lx2is9krcxiibgrs9pispr245rwsaxjw"))

(define rust-bytemuck-1.23.2
  (crate-source "bytemuck" "1.23.2"
                "0xs637lsr9p73ackjkmbjw80dp1dfdw0ydhdk0gzjcnzpkpfm59r"))

(define rust-bytemuck-1.24.0
  (crate-source "bytemuck" "1.24.0"
                "1x65wc9kwf0dfnmglkl8r46d29pfl7yilll5wh9bcf0g6a0gbg8z"))

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

(define rust-cassowary-0.3.0
  (crate-source "cassowary" "0.3.0"
                "0lvanj0gsk6pc1chqrh4k5k0vi1rfbgzmsk46dwy3nmrqyw711nz"))

(define rust-cast-0.3.0
  (crate-source "cast" "0.3.0"
                "1dbyngbyz2qkk0jn2sxil8vrz3rnpcj142y184p9l4nbl9radcip"))

(define rust-castaway-0.2.2
  (crate-source "castaway" "0.2.2"
                "1k1z4v61vq7la56js1azkr0k9b415vif2kaxiqk3d1gw6mbfs5wa"))

(define rust-castaway-0.2.4
  (crate-source "castaway" "0.2.4"
                "0nn5his5f8q20nkyg1nwb40xc19a08yaj4y76a8q2y3mdsmm3ify"))

(define rust-cbc-0.1.2
  (crate-source "cbc" "0.1.2"
                "19l9y9ccv1ffg6876hshd123f2f8v7zbkc4nkckqycxf8fajmd96"))

(define rust-cc-1.2.30
  (crate-source "cc" "1.2.30"
                "1rqs46vb04ffqlpi6kjwfmvvvf64y6jkdn1faql30sfa0yb11v6y"))

(define rust-cc-1.2.35
  (crate-source "cc" "1.2.35"
                "18vfhd6njr0lhfvfvxchj3bay4fw6hcpyy4130sl134alqj903sr"))

(define rust-cc-1.2.38
  (crate-source "cc" "1.2.38"
                "1sg7gd94611qhryvb0iip0zibjnhf1yha2wnp0pw2mgrd3himx40"))

(define rust-cc-1.2.41
  (crate-source "cc" "1.2.41"
                "1dvwli6fljqc7kgmihb249rmdfs5irla1h0n6vkavdi4pg6yd7xc"))

(define rust-cesu8-1.1.0
  (crate-source "cesu8" "1.1.0"
                "0g6q58wa7khxrxcxgnqyi9s1z2cjywwwd3hzr5c55wskhx6s0hvd"))

(define rust-cexpr-0.6.0
  (crate-source "cexpr" "0.6.0"
                "0rl77bwhs5p979ih4r0202cn5jrfsrbgrksp40lkfz5vk1x3ib3g"))

(define rust-cfg-aliases-0.1.1
  (crate-source "cfg_aliases" "0.1.1"
                "17p821nc6jm830vzl2lmwz60g3a30hcm33nk6l257i1rjdqw85px"))

(define rust-cfg-aliases-0.2.1
  (crate-source "cfg_aliases" "0.2.1"
                "092pxdc1dbgjb6qvh83gk56rkic2n2ybm4yvy76cgynmzi3zwfk1"))

(define rust-cfg-if-1.0.0
  (crate-source "cfg-if" "1.0.0"
                "1za0vb97n4brpzpv8lsbnzmq5r8f2b0cpqqr0sy8h5bn751xxwds"))

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

(define rust-chrono-0.4.42
  (crate-source "chrono" "0.4.42"
                "1lp8iz9js9jwxw0sj8yi59v54lgvwdvm49b9wch77f25sfym4l0l"))

(define rust-chunked-transfer-1.5.0
  (crate-source "chunked_transfer" "1.5.0"
                "00a9h3csr1xwkqrzpz5kag4h92zdkrnxq4ppxidrhrx29syf6kbf"))

(define rust-ciborium-0.2.1
  (crate-source "ciborium" "0.2.1"
                "09p9gr3jxys51v0fzwsmxym2p7pcz9mhng2xib74lnlfqzv93zgg"))

(define rust-ciborium-io-0.2.1
  (crate-source "ciborium-io" "0.2.1"
                "0mi6ci27lpz3azksxrvgzl9jc4a3dfr20pjx7y2nkcrjalbikyfd"))

(define rust-ciborium-ll-0.2.1
  (crate-source "ciborium-ll" "0.2.1"
                "0az2vabamfk75m74ylgf6nzqgqgma5yf25bc1ripfg09ri7a5yny"))

(define rust-cipher-0.4.4
  (crate-source "cipher" "0.4.4"
                "1b9x9agg67xq5nq879z66ni4l08m6m3hqcshk37d4is4ysd3ngvp"))

(define rust-clang-sys-1.8.1
  ;; TODO: Check bundled sources.
  (crate-source "clang-sys" "1.8.1"
                "1x1r9yqss76z8xwpdanw313ss6fniwc1r7dzb5ycjn0ph53kj0hb"))

(define rust-clap-4.5.40
  (crate-source "clap" "4.5.40"
                "03widrb9d7a0bka6lsf9r9f65zhfbkdkhm8iryycx1c63mx8idj0"))

(define rust-clap-4.5.41
  (crate-source "clap" "4.5.41"
                "1ydd3a22bxkn2a7bajnw57cwjhawqciyhz2x3rqm8fi4h0pd74my"))

(define rust-clap-4.5.47
  (crate-source "clap" "4.5.47"
                "0c99f6m4a7d4ffgahid49h0ci2pv4ccdf417f76nl4wx5n801b3y"))

(define rust-clap-4.5.48
  (crate-source "clap" "4.5.48"
                "1bjz3d7bavy13ph2a6rm3c9y02ak70b195xakii7h6q2xarln4z2"))

(define rust-clap-builder-4.5.40
  (crate-source "clap_builder" "4.5.40"
                "17pmcjwk6rbkizj4y5vlhrnr7b5n1ffjgh75pj66j34zrq46rip0"))

(define rust-clap-builder-4.5.41
  (crate-source "clap_builder" "4.5.41"
                "0g8w6da5y13kv93psl8c00c7f4q01753wmwx84wr2bv2x50snzkh"))

(define rust-clap-builder-4.5.47
  (crate-source "clap_builder" "4.5.47"
                "1mp1f0fz6wp9v87jc9372lg6r4514ja1l8cazf25hfz7a3vvpn9a"))

(define rust-clap-builder-4.5.48
  (crate-source "clap_builder" "4.5.48"
                "1jaxnr7ik25r4yxgz657vm8kz62f64qmwxhplmzxz9n0lfpn9fn2"))

(define rust-clap-complete-4.5.55
  (crate-source "clap_complete" "4.5.55"
                "16i2qv263ndlmnms4vyzdqiqd7y4cqdqz3wbpv2p1bvd912dxax5"))

(define rust-clap-complete-4.5.57
  (crate-source "clap_complete" "4.5.57"
                "1bbixanlxdsb47qhk9fp1jl31vbk218rmnh1xsxzf2az7yyh35ad"))

(define rust-clap-complete-4.5.58
  (crate-source "clap_complete" "4.5.58"
                "0jmg0idg96cvx51l35ypia1np3q7sfj5wqxvi7kjs59fmlr0pgvm"))

(define rust-clap-derive-4.5.40
  (crate-source "clap_derive" "4.5.40"
                "1kjp4928wy132inisss42750rzv0wasvbbf10w98agfcwix99iyj"))

(define rust-clap-derive-4.5.41
  (crate-source "clap_derive" "4.5.41"
                "14glxqpfjs7z6m37f3ycrhgdkpyqmgwbr4vk1y34rjjrd8w54kzg"))

(define rust-clap-derive-4.5.47
  (crate-source "clap_derive" "4.5.47"
                "174z9g13s85la2nmi8gv8ssjwz77im3rqg5isiinw6hg1fp7xzdv"))

(define rust-clap-lex-0.7.4
  (crate-source "clap_lex" "0.7.4"
                "19nwfls5db269js5n822vkc8dw0wjq2h1wf0hgr06ld2g52d2spl"))

(define rust-clap-lex-0.7.5
  (crate-source "clap_lex" "0.7.5"
                "0xb6pjza43irrl99axbhs12pxq4sr8x7xd36p703j57f5i3n2kxr"))

(define rust-cli-table-0.5.0
  (crate-source "cli-table" "0.5.0"
                "0b088r2jgskhq0rzrrn7cdwdaqv9fd6p96yc7kqw8z7g3jaqvnhl"))

(define rust-cli-table-derive-0.5.0
  (crate-source "cli-table-derive" "0.5.0"
                "0bl39w6cngx1sxcbcw6y031zc7m5d829dc6z519d9hz2p9h1nz4z"))

(define rust-clipboard-win-5.4.1
  (crate-source "clipboard-win" "5.4.1"
                "1m44gqy11rq1ww7jls86ppif98v6kv2wkwk8p17is86zsdq3gq5x"))

(define rust-clru-0.6.2
  (crate-source "clru" "0.6.2"
                "0ngyycxpxif84wpjjn0ixywylk95h5iv8fqycg2zsr3f0rpggl6b"))

(define rust-cmp-any-0.8.1
  (crate-source "cmp_any" "0.8.1"
                "08bydg7d4jxw1dyvpg9i4mwdn5645q3j96ijclpwx0rl4lrq5cg9"))

(define rust-codespan-reporting-0.12.0
  (crate-source "codespan-reporting" "0.12.0"
                "108g41xqzhr8fx8hlpy5qzmqq8ylldbj37wndkaqm34yy1d2wvgy"))

(define rust-color-eyre-0.6.5
  (crate-source "color-eyre" "0.6.5"
                "0vgjy8q6c4fin6inh7ik66rkkyjwar3ai8z33vbacckqnkphp4p5"))

(define rust-color-spantrace-0.3.0
  (crate-source "color-spantrace" "0.3.0"
                "09xl077fs44yvqajmr52mjbghvkfwg6fnd3jpialnd8kvylqxf5q"))

(define rust-colorchoice-1.0.0
  (crate-source "colorchoice" "1.0.0"
                "1ix7w85kwvyybwi2jdkl3yva2r2bvdcc3ka2grjfzfgrapqimgxc"))

(define rust-colorchoice-1.0.4
  (crate-source "colorchoice" "1.0.4"
                "0x8ymkz1xr77rcj1cfanhf416pc4v681gmkc9dzb3jqja7f62nxh"))

(define rust-combine-4.6.7
  (crate-source "combine" "4.6.7"
                "1z8rh8wp59gf8k23ar010phgs0wgf5i8cx4fg01gwcnzfn5k0nms"))

(define rust-compact-str-0.7.1
  (crate-source "compact_str" "0.7.1"
                "0gvvfc2c6pg1rwr2w36ra4674w3lzwg97vq2v6k791w30169qszq"))

(define rust-compact-str-0.8.1
  (crate-source "compact_str" "0.8.1"
                "0cmgp61hw4fwaakhilwznfgncw2p4wkbvz6dw3i7ibbckh3c8y9v"))

(define rust-concurrent-queue-2.5.0
  (crate-source "concurrent-queue" "2.5.0"
                "0wrr3mzq2ijdkxwndhf79k952cp4zkz35ray8hvsxl96xrx1k82c"))

(define rust-console-0.15.11
  (crate-source "console" "0.15.11"
                "1n5gmsjk6isbnw6qss043377kln20lfwlmdk3vswpwpr21dwnk05"))

(define rust-const-random-0.1.18
  (crate-source "const-random" "0.1.18"
                "0n8kqz3y82ks8znvz1mxn3a9hadca3amzf33gmi6dc3lzs103q47"))

(define rust-const-random-macro-0.1.16
  (crate-source "const-random-macro" "0.1.16"
                "03iram4ijjjq9j5a7hbnmdngj8935wbsd0f5bm8yw2hblbr3kn7r"))

(define rust-convert-case-0.6.0
  (crate-source "convert_case" "0.6.0"
                "1jn1pq6fp3rri88zyw6jlhwwgf6qiyc08d6gjv0qypgkl862n67c"))

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

(define rust-countme-3.0.1
  (crate-source "countme" "3.0.1"
                "0dn62hhvgmwyxslh14r4nlbvz8h50cp5mnn1qhqsw63vs7yva13p"))

(define rust-cpufeatures-0.2.17
  (crate-source "cpufeatures" "0.2.17"
                "10023dnnaghhdl70xcds12fsx2b966sxbxjq5sxs49mvxqw5ivar"))

(define rust-crc32fast-1.3.2
  (crate-source "crc32fast" "1.3.2"
                "03c8f29yx293yf43xar946xbls1g60c207m9drf8ilqhr25vsh5m"))

(define rust-crc32fast-1.5.0
  (crate-source "crc32fast" "1.5.0"
                "04d51liy8rbssra92p0qnwjw8i9rm9c4m3bwy19wjamz1k4w30cl"))

(define rust-criterion-0.5.1
  (crate-source "criterion" "0.5.1"
                "0bv9ipygam3z8kk6k771gh9zi0j0lb9ir0xi1pc075ljg80jvcgj"))

(define rust-criterion-plot-0.5.0
  (crate-source "criterion-plot" "0.5.0"
                "1c866xkjqqhzg4cjvg01f8w6xc1j3j7s58rdksl52skq89iq4l3b"))

(define rust-crossbeam-channel-0.5.15
  (crate-source "crossbeam-channel" "0.5.15"
                "1cicd9ins0fkpfgvz9vhz3m9rpkh6n8d3437c3wnfsdkd3wgif42"))

(define rust-crossbeam-deque-0.8.3
  (crate-source "crossbeam-deque" "0.8.3"
                "1vqczbcild7nczh5z116w8w46z991kpjyw7qxkf24c14apwdcvyf"))

(define rust-crossbeam-deque-0.8.6
  (crate-source "crossbeam-deque" "0.8.6"
                "0l9f1saqp1gn5qy0rxvkmz4m6n7fc0b3dbm6q1r5pmgpnyvi3lcx"))

(define rust-crossbeam-epoch-0.9.15
  (crate-source "crossbeam-epoch" "0.9.15"
                "1ixwc3cq816wb8rlh3ix4jnybqbyyq4l61nwlx0mfm3ck0s148df"))

(define rust-crossbeam-epoch-0.9.18
  (crate-source "crossbeam-epoch" "0.9.18"
                "03j2np8llwf376m3fxqx859mgp9f83hj1w34153c7a9c7i5ar0jv"))

(define rust-crossbeam-utils-0.8.19
  (crate-source "crossbeam-utils" "0.8.19"
                "0iakrb1b8fjqrag7wphl94d10irhbh2fw1g444xslsywqyn3p3i4"))

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

(define rust-csv-1.3.1
  (crate-source "csv" "1.3.1"
                "1bzxgbbhy27flcyafxbj7f1hbn7b8wac04ijfgj34ry9m61lip5c"))

(define rust-csv-core-0.1.12
  (crate-source "csv-core" "0.1.12"
                "0gfrjjlfagarhyclxrqv6b14iaxgvgc8kmwwdvw08racvaqg60kx"))

(define rust-ctor-0.1.26
  (crate-source "ctor" "0.1.26"
                "15m0wqhv12p25xkxz5dxvg23r7a6bkh7p8zi1cdhgswjhdl028vd"))

(define rust-ctor-0.5.0
  (crate-source "ctor" "0.5.0"
                "1nwg2zg9q3r9y8pwdncigmvknq3p4jkc84kncdm6a0v165430xv7"))

(define rust-ctor-proc-macro-0.0.6
  (crate-source "ctor-proc-macro" "0.0.6"
                "1hl2cxpv92322sqq972w257dc5d1dz6gqsnjx7c4bh1xw7vim4z2"))

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

(define rust-darling-0.20.11
  (crate-source "darling" "0.20.11"
                "1vmlphlrlw4f50z16p4bc9p5qwdni1ba95qmxfrrmzs6dh8lczzw"))

(define rust-darling-0.21.3
  (crate-source "darling" "0.21.3"
                "1h281ah78pz05450r71h3gwm2n24hy8yngbz58g426l4j1q37pww"))

(define rust-darling-core-0.20.11
  (crate-source "darling_core" "0.20.11"
                "0bj1af6xl4ablnqbgn827m43b8fiicgv180749f5cphqdmcvj00d"))

(define rust-darling-core-0.21.3
  (crate-source "darling_core" "0.21.3"
                "193ya45qgac0a4siwghk0bl8im8h89p3cald7kw8ag3yrmg1jiqj"))

(define rust-darling-macro-0.20.11
  (crate-source "darling_macro" "0.20.11"
                "1bbfbc2px6sj1pqqq97bgqn6c8xdnb2fmz66f7f40nrqrcybjd7w"))

(define rust-darling-macro-0.21.3
  (crate-source "darling_macro" "0.21.3"
                "10ac85n4lnx3rmf5rw8lijl2c0sbl6ghcpgfmzh0s26ihbghi0yk"))

(define rust-dashmap-6.1.0
  (crate-source "dashmap" "6.1.0"
                "1kvnw859xvrqyd1lk89na6797yvl5bri4wi9j0viz2a4j54wqhah"))

(define rust-dbus-0.9.9
  (crate-source "dbus" "0.9.9"
                "1sfib87472q429k3j1hwhbjc7vcpjhz8hnnzd2ssfmdbx1an42qr"))

(define rust-dbus-secret-service-4.1.0
  (crate-source "dbus-secret-service" "4.1.0"
                "19jgbqb841kbzmfgaqnbbhsc5ijck7fzl3zvgqyyb2bqvyg512vh"))

(define rust-deadpool-0.12.3
  (crate-source "deadpool" "0.12.3"
                "06wvsfyni5f04ia6jczgjnpkq4w91cnjjdz10mpq93gcsv8v3qhb"))

(define rust-deadpool-runtime-0.1.4
  (crate-source "deadpool-runtime" "0.1.4"
                "0arbchl5j887hcfvjy4gq38d32055s5cf7pkpmwn0lfw3ss6ca89"))

(define rust-debugid-0.8.0
  (crate-source "debugid" "0.8.0"
                "13f15dfvn07fa7087pmacixqqv0lmj4hv93biw4ldr48ypk55xdy"))

(define rust-debugserver-types-0.5.0
  (crate-source "debugserver-types" "0.5.0"
                "0jmgv2f77y1k20gldkvf3w7ibshb34kxz0hqwkjfh57df1587xib"))

(define rust-deranged-0.5.3
  (crate-source "deranged" "0.5.3"
                "1k473y8lzjac956dm3s1cs2rz364py9zd52y9fkbanws8b6vqc6n"))

(define rust-deranged-0.5.4
  (crate-source "deranged" "0.5.4"
                "0wch36gpg2crz2f72p7c0i5l4bzxjkwxw96sdj57c1cadzw566d4"))

(define rust-derivative-2.2.0
  (crate-source "derivative" "2.2.0"
                "02vpb81wisk2zh1d5f44szzxamzinqgq2k8ydrfjj2wwkrgdvhzw"))

(define rust-derive-more-1.0.0
  (crate-source "derive_more" "1.0.0"
                "01cd8pskdjg10dvfchi6b8a9pa1ja1ic0kbn45dl8jdyrfwrk6sa"))

(define rust-derive-more-2.0.1
  (crate-source "derive_more" "2.0.1"
                "0y3n97cc7rsvgnj211p92y1ppzh6jzvq5kvk6340ghkhfp7l4ch9"))

(define rust-derive-more-impl-1.0.0
  (crate-source "derive_more-impl" "1.0.0"
                "08mxyd456ygk68v5nfn4dyisn82k647w9ri2jl19dqpvmnp30wyb"))

(define rust-derive-more-impl-2.0.1
  (crate-source "derive_more-impl" "2.0.1"
                "1wqxcb7d5lzvpplz9szp4rwy1r23f5wmixz0zd2vcjscqknji9mx"))

(define rust-diff-0.1.13
  (crate-source "diff" "0.1.13"
                "1j0nzjxci2zqx63hdcihkp0a4dkdmzxd7my4m7zk6cjyfy34j9an"))

(define rust-difflib-0.4.0
  (crate-source "difflib" "0.4.0"
                "1s7byq4d7jgf2hcp2lcqxi2piqwl8xqlharfbi8kf90n8csy7131"))

(define rust-diffy-0.4.2
  (crate-source "diffy" "0.4.2"
                "14fjsz0gnd06fy96l1mksp7m78fv645sp19r504d1gcl072vhidm"))

(define rust-digest-0.10.7
  (crate-source "digest" "0.10.7"
                "14p2n6ih29x81akj097lvz7wi9b6b9hvls0lwrv7b6xwyy0s5ncy"))

(define rust-dirs-6.0.0
  (crate-source "dirs" "6.0.0"
                "0knfikii29761g22pwfrb8d0nqpbgw77sni9h2224haisyaams63"))

(define rust-dirs-next-2.0.0
  (crate-source "dirs-next" "2.0.0"
                "1q9kr151h9681wwp6is18750ssghz6j9j7qm7qi1ngcwy7mzi35r"))

(define rust-dirs-sys-0.5.0
  ;; TODO: Check bundled sources.
  (crate-source "dirs-sys" "0.5.0"
                "1aqzpgq6ampza6v012gm2dppx9k35cdycbj54808ksbys9k366p0"))

(define rust-dirs-sys-next-0.1.2
  (crate-source "dirs-sys-next" "0.1.2"
                "0kavhavdxv4phzj4l0psvh55hszwnr0rcz8sxbvx20pyqi2a3gaf"))

(define rust-dispatch-0.2.0
  (crate-source "dispatch" "0.2.0"
                "0fwjr9b7582ic5689zxj8lf7zl94iklhlns3yivrnv8c9fxr635x"))

(define rust-dispatch2-0.3.0
  (crate-source "dispatch2" "0.3.0"
                "1v1ak9w0s8z1g13x4mj2y5im9wmck0i2vf8f8wc9l1n6lqi9z849"))

(define rust-display-container-0.9.0
  (crate-source "display_container" "0.9.0"
                "1yk6jiijfl8gibyrb79nga5jh46pl40flgc2cn7frvbbr5shl48a"))

(define rust-displaydoc-0.2.5
  (crate-source "displaydoc" "0.2.5"
                "1q0alair462j21iiqwrr21iabkfnb13d6x5w95lkdg21q2xrqdlp"))

(define rust-dissimilar-1.0.7
  (crate-source "dissimilar" "1.0.7"
                "0cn6i035s4hsvv078lg3alsfwjy0k2y7zy5hnsr1cvpf1v4bvqw6"))

(define rust-dlib-0.5.2
  (crate-source "dlib" "0.5.2"
                "04m4zzybx804394dnqs1blz241xcy480bdwf3w9p4k6c3l46031k"))

(define rust-dlv-list-0.5.2
  (crate-source "dlv-list" "0.5.2"
                "0pqvrinxzdz7bpy4a3p450h8krns3bd0mc3w0qqvm03l2kskj824"))

(define rust-doc-comment-0.3.3
  (crate-source "doc-comment" "0.3.3"
                "043sprsf3wl926zmck1bm7gw0jq50mb76lkpk49vasfr6ax1p97y"))

(define rust-document-features-0.2.11
  (crate-source "document-features" "0.2.11"
                "0pdhpbz687fk2rkgz45yy3gvbhlxliwb7g1lj3jbx1f1qr89n94m"))

(define rust-dotenvy-0.15.7
  (crate-source "dotenvy" "0.15.7"
                "16s3n973n5aqym02692i1npb079n5mb0fwql42ikmwn8wnrrbbqs"))

(define rust-downcast-rs-1.2.1
  (crate-source "downcast-rs" "1.2.1"
                "1lmrq383d1yszp7mg5i7i56b17x2lnn3kb91jwsq0zykvg2jbcvm"))

(define rust-dpi-0.1.2
  (crate-source "dpi" "0.1.2"
                "0xhsvzgjvdch2fwmfc9vkb708b0q59b6imypyjlgbiigyb74rcfq"))

(define rust-dtor-0.1.0
  (crate-source "dtor" "0.1.0"
                "0d198g4lwkimvkrlpfpksva47phaw1dv8iskjllanmfvrmj0g2p5"))

(define rust-dtor-proc-macro-0.0.6
  (crate-source "dtor-proc-macro" "0.0.6"
                "19fg0mivy9qyvbwmqj3ysj0qm5cay0gyp5fyw1imq89cj95cyy7n"))

(define rust-dunce-1.0.5
  (crate-source "dunce" "1.0.5"
                "04y8wwv3vvcqaqmqzssi6k0ii9gs6fpz96j5w9nky2ccsl23axwj"))

(define rust-dupe-0.9.1
  (crate-source "dupe" "0.9.1"
                "175z5wxc6kvnyr6bgns6zfx5aykkacd39nvc5fy3zjdr3l0vrlkf"))

(define rust-dupe-derive-0.9.1
  (crate-source "dupe_derive" "0.9.1"
                "0al934zi1dag9zql8kgr3v02w9nbzm2ay931h9nq722yjjs9bqc3"))

(define rust-dyn-clone-1.0.19
  (crate-source "dyn-clone" "1.0.19"
                "01ahm5abl20480v48nxy4ffyx80cs6263q9zf0gnrxpvm6w8yyhw"))

(define rust-dyn-clone-1.0.20
  (crate-source "dyn-clone" "1.0.20"
                "0m956cxcg8v2n8kmz6xs5zl13k2fak3zkapzfzzp7pxih6hix26h"))

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

(define rust-either-1.9.0
  (crate-source "either" "1.9.0"
                "01qy3anr7jal5lpc20791vxrw0nl6vksb5j7x56q2fycgcyy8sm2"))

(define rust-emath-0.32.1
  (crate-source "emath" "0.32.1"
                "1qyxi2xmdfb6y0bjrm2d6hhy0yfwdlaxlyig5w9yzplgqiyzcpck"))

(define rust-ena-0.14.3
  (crate-source "ena" "0.14.3"
                "1m9a5hqk6qn5sqnrc40b55yr97drkfdzd0jj863ksqff8gfqn91x"))

(define rust-encode-unicode-1.0.0
  (crate-source "encode_unicode" "1.0.0"
                "1h5j7j7byi289by63s3w4a8b3g6l5ccdrws7a67nn07vdxj77ail"))

(define rust-encoding-rs-0.8.35
  (crate-source "encoding_rs" "0.8.35"
                "1wv64xdrr9v37rqqdjsyb8l8wzlcbab80ryxhrszvnj59wy0y0vm"))

(define rust-encoding-rs-io-0.1.7
  (crate-source "encoding_rs_io" "0.1.7"
                "10ra4l688cdadd8h1lsbahld1zbywnnqv68366mbhamn3xjwbhqw"))

(define rust-endi-1.1.0
  (crate-source "endi" "1.1.0"
                "1gxp388g2zzbncp3rdn60wxkr49xbhhx94nl9p4a6c41w4ma7n53"))

(define rust-endian-type-0.1.2
  (crate-source "endian-type" "0.1.2"
                "0bbh88zaig1jfqrm7w3gx0pz81kw2jakk3055vbgapw3dmk08ky3"))

(define rust-enum-map-2.7.3
  (crate-source "enum-map" "2.7.3"
                "1sgjgl4mmz93jdkfdsmapc3dmaq8gddagw9s0fd501w2vyzz6rk8"))

(define rust-enum-map-derive-0.17.0
  (crate-source "enum-map-derive" "0.17.0"
                "1sv4mb343rsz4lc3rh7cyn0pdhf7fk18k1dgq8kfn5i5x7gwz0pj"))

(define rust-enumflags2-0.7.12
  (crate-source "enumflags2" "0.7.12"
                "1vzcskg4dca2jiflsfx1p9yw1fvgzcakcs7cpip0agl51ilgf9qh"))

(define rust-enumflags2-derive-0.7.12
  (crate-source "enumflags2_derive" "0.7.12"
                "09rqffacafl1b83ir55hrah9gza0x7pzjn6lr6jm76fzix6qmiv7"))

(define rust-enumn-0.1.14
  (crate-source "enumn" "0.1.14"
                "0f1gagm6841sih4ipw46c7gn1idjgqfay1f5q6hchdwjg2rxd7ig"))

(define rust-enumset-1.1.10
  (crate-source "enumset" "1.1.10"
                "0d168laidd53xjyl9qrwqfqycvcnrznzkgd6q1j01z5vzf6pmc15"))

(define rust-enumset-derive-0.14.0
  (crate-source "enumset_derive" "0.14.0"
                "1kmkv1bfimvjawm74zk1yfvjywkfwhrxk3p6mq7hcf539r778gpl"))

(define rust-env-filter-0.1.3
  (crate-source "env_filter" "0.1.3"
                "1l4p6f845cylripc3zkxa0lklk8rn2q86fqm522p6l2cknjhavhq"))

(define rust-env-flags-0.1.1
  (crate-source "env-flags" "0.1.1"
                "05f4537d68a0wg9iy3kj77hb8xcrkyy2fsirr7kcbpijqrzhxzfv"))

(define rust-env-logger-0.10.2
  (crate-source "env_logger" "0.10.2"
                "1005v71kay9kbz1d5907l0y7vh9qn2fqsp2yfgb8bjvin6m0bm2c"))

(define rust-env-logger-0.11.8
  (crate-source "env_logger" "0.11.8"
                "17q6zbjam4wq75fa3m4gvvmv3rj3ch25abwbm84b28a0j3q67j0k"))

(define rust-epaint-0.32.1
  (crate-source "epaint" "0.32.1"
                "18q63q2mxcmnwpx7c7mzgw9a72na4vacffmxx5yr28nkm6jw0vxn"))

(define rust-epaint-default-fonts-0.32.1
  (crate-source "epaint_default_fonts" "0.32.1"
                "0fjabglyxp61xf1hnhxx6qskajlhv85n6pjgl85005xq1z7ghv2g"))

(define rust-equivalent-1.0.2
  (crate-source "equivalent" "1.0.2"
                "03swzqznragy8n0x31lqc78g2af054jwivp7lkrbrc0khz74lyl7"))

(define rust-erased-serde-0.3.31
  (crate-source "erased-serde" "0.3.31"
                "0v5jyid1v8irf2n2875iwhm80cw8x75gfkdh7qvzxrymz5s8j4vc"))

(define rust-errno-0.3.11
  (crate-source "errno" "0.3.11"
                "0kjrrcaa5nvickysw7z3vm5p0l7l457idf1ff3z6ang8qwnx8vcp"))

(define rust-errno-0.3.13
  (crate-source "errno" "0.3.13"
                "1bd5g3srn66zr3bspac0150bvpg1s7zi6zwhwhlayivciz12m3kp"))

(define rust-errno-0.3.14
  (crate-source "errno" "0.3.14"
                "1szgccmh8vgryqyadg8xd58mnwwicf39zmin3bsn63df2wbbgjir"))

(define rust-error-code-3.3.2
  (crate-source "error-code" "3.3.2"
                "0nacxm9xr3s1rwd6fabk3qm89fyglahmbi4m512y0hr8ym6dz8ny"))

(define rust-escargot-0.5.15
  (crate-source "escargot" "0.5.15"
                "1kyhkrxdbxlw839h3l838ck5ir96i9v2p9x6kh650yy95fisxhqi"))

(define rust-event-listener-5.4.0
  (crate-source "event-listener" "5.4.0"
                "1bii2gn3vaa33s0gr2zph7cagiq0ppcfxcxabs24ri9z9kgar4il"))

(define rust-event-listener-5.4.1
  (crate-source "event-listener" "5.4.1"
                "1asnp3agbr8shcl001yd935m167ammyi8hnvl0q1ycajryn6cfz1"))

(define rust-event-listener-strategy-0.5.4
  (crate-source "event-listener-strategy" "0.5.4"
                "14rv18av8s7n8yixg38bxp5vg2qs394rl1w052by5npzmbgz7scb"))

(define rust-eventsource-stream-0.2.3
  (crate-source "eventsource-stream" "0.2.3"
                "1awhkl4xh9f66j9m770qvn2l74cr4l59ssqmv4lz99a7j9bg9zkl"))

(define rust-expect-test-1.5.1
  (crate-source "expect-test" "1.5.1"
                "1c5c081ykm4k5rlsam9jw56w4wgs2h7r4aj78zxlis1i8kzl7bv3"))

(define rust-eyre-0.6.12
  (crate-source "eyre" "0.6.12"
                "1v1a3vb9gs5zkwp4jzkcfnpg0gvyp4ifydzx37f4qy14kzcibnbw"))

(define rust-fancy-regex-0.13.0
  (crate-source "fancy-regex" "0.13.0"
                "1wjbqjsdj8fkq6z2i9llq25iaqzd9f208vxnwg8mdbr2ba1lc7jk"))

(define rust-faster-hex-0.10.0
  (crate-source "faster-hex" "0.10.0"
                "0wzvv4a1czxfxmh99cza2y0jps97hm3k1j6r6cs816qp5wnsw8vj"))

(define rust-fastrand-2.1.1
  (crate-source "fastrand" "2.1.1"
                "19nyzdq3ha4g173364y2wijmd6jlyms8qx40daqkxsnl458jmh78"))

(define rust-fastrand-2.3.0
  (crate-source "fastrand" "2.3.0"
                "1ghiahsw1jd68df895cy5h3gzwk30hndidn3b682zmshpgmrx41p"))

(define rust-fax-0.2.6
  (crate-source "fax" "0.2.6"
                "1ax0jmvsszxd03hj6ga1kyl7gaqcfw0akg2wf0q6gk9pizaffpgh"))

(define rust-fax-derive-0.2.0
  (crate-source "fax_derive" "0.2.0"
                "0zap434zz4xvi5rnysmwzzivig593b4ng15vwzwl7js2nw7s3b50"))

(define rust-fd-lock-4.0.4
  (crate-source "fd-lock" "4.0.4"
                "0y5a22zaqns06slndm64gjdx983i6b4l4ks895rxznnn4bv2zs8c"))

(define rust-fdeflate-0.3.7
  (crate-source "fdeflate" "0.3.7"
                "130ga18vyxbb5idbgi07njymdaavvk6j08yh1dfarm294ssm6s0y"))

(define rust-fern-0.7.1
  (crate-source "fern" "0.7.1"
                "0a9v59vcq2fgd6bwgbfl7q6b0zzgxn85y6g384z728wvf1gih5j3"))

(define rust-file-id-0.2.2
  (crate-source "file-id" "0.2.2"
                "0dmylm34z6g8cg3b60sc6bk9v5wv9930vyx9wgcdpjpgpfwh9jbb"))

(define rust-filedescriptor-0.8.3
  (crate-source "filedescriptor" "0.8.3"
                "0bb8qqa9h9sj2mzf09yqxn260qkcqvmhmyrmdjvyxcn94knmh1z4"))

(define rust-filetime-0.2.22
  (crate-source "filetime" "0.2.22"
                "1w1a4zb4ciqjl1chvp9dplbacq07jv97pkdn0pzackbk7vfrw0nl"))

(define rust-find-crate-0.6.3
  (crate-source "find-crate" "0.6.3"
                "1ljpkh11gj7940xwz47xjhsvfbl93c2q0ql7l2v0w77amjx8paar"))

(define rust-find-msvc-tools-0.1.0
  (crate-source "find-msvc-tools" "0.1.0"
                "0l4nnivhdigxd87drmahqq99qvz7479ad65syq1njwm2m3xy8y71"))

(define rust-find-msvc-tools-0.1.2
  (crate-source "find-msvc-tools" "0.1.2"
                "0nbrhvk4m04hviiwbqp2jwcv9j2k70x0q2kcvfk51iygvaqp7v8w"))

(define rust-find-msvc-tools-0.1.4
  (crate-source "find-msvc-tools" "0.1.4"
                "09x1sfinrz86bkm6i2d85lpsfnxn0w797g5zisv1nwhaz1w1h1aj"))

(define rust-findshlibs-0.10.2
  (crate-source "findshlibs" "0.10.2"
                "0r3zy2r12rxzwqgz53830bk38r6b7rl8kq2br9n81q7ps2ffbfa0"))

(define rust-fixed-decimal-0.7.0
  (crate-source "fixed_decimal" "0.7.0"
                "0picdka9jxqd61iwr7f8852yjn411a8ibygck2qhr77in8i3v51m"))

(define rust-fixedbitset-0.4.2
  (crate-source "fixedbitset" "0.4.2"
                "101v41amgv5n9h4hcghvrbfk5vrncx1jwm35rn5szv4rk55i7rqc"))

(define rust-flate2-1.1.2
  (crate-source "flate2" "1.1.2"
                "07abz7v50lkdr5fjw8zaw2v8gm2vbppc0f7nqm8x3v3gb6wpsgaa"))

(define rust-flate2-1.1.4
  (crate-source "flate2" "1.1.4"
                "1a8a3pk2r2dxays4ikc47ygydhpd1dcxlgqdi3r9kiiq9rb4wnnw"))

(define rust-float-cmp-0.10.0
  (crate-source "float-cmp" "0.10.0"
                "1n760i3nxd2x0zc7fkxkg3vhvdyfbvzngna006cl9s9jacaz775h"))

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

(define rust-fluent-uri-0.3.2
  (crate-source "fluent-uri" "0.3.2"
                "1rgp9mv03bifxysy863kf38aagvyl76ca6gd3dcx6iyzjrfvc60r"))

(define rust-fnv-1.0.7
  (crate-source "fnv" "1.0.7"
                "1hc2mcqha06aibcaza94vbi81j6pr9a1bbxrxjfhc91zin8yr7iz"))

(define rust-foldhash-0.1.5
  (crate-source "foldhash" "0.1.5"
                "1wisr1xlc2bj7hk4rgkcjkz3j2x4dhd1h9lwk7mj8p71qpdgbi6r"))

(define rust-foreign-types-0.3.2
  (crate-source "foreign-types" "0.3.2"
                "1cgk0vyd7r45cj769jym4a6s7vwshvd0z4bqrb92q1fwibmkkwzn"))

(define rust-foreign-types-0.5.0
  (crate-source "foreign-types" "0.5.0"
                "0rfr2zfxnx9rz3292z5nyk8qs2iirznn5ff3rd4vgdwza6mdjdyp"))

(define rust-foreign-types-macros-0.2.3
  (crate-source "foreign-types-macros" "0.2.3"
                "0hjpii8ny6l7h7jpns2cp9589016l8mlrpaigcnayjn9bdc6qp0s"))

(define rust-foreign-types-shared-0.1.1
  (crate-source "foreign-types-shared" "0.1.1"
                "0jxgzd04ra4imjv8jgkmdq59kj8fsz6w4zxsbmlai34h26225c00"))

(define rust-foreign-types-shared-0.3.1
  (crate-source "foreign-types-shared" "0.3.1"
                "0nykdvv41a3d4py61bylmlwjhhvdm0b3bcj9vxhqgxaxnp5ik6ma"))

(define rust-form-urlencoded-1.2.1
  (crate-source "form_urlencoded" "1.2.1"
                "0milh8x7nl4f450s3ddhg57a3flcv6yq8hlkyk6fyr3mcb128dp1"))

(define rust-form-urlencoded-1.2.2
  (crate-source "form_urlencoded" "1.2.2"
                "1kqzb2qn608rxl3dws04zahcklpplkd5r1vpabwga5l50d2v4k6b"))

(define rust-fsevent-sys-4.1.0
  ;; TODO: Check bundled sources.
  (crate-source "fsevent-sys" "4.1.0"
                "1liz67v8b0gcs8r31vxkvm2jzgl9p14i78yfqx81c8sdv817mvkn"))

(define rust-futures-0.3.31
  (crate-source "futures" "0.3.31"
                "0xh8ddbkm9jy8kc5gbvjp9a4b6rqqxvc8471yb2qaz5wm2qhgg35"))

(define rust-futures-channel-0.3.31
  (crate-source "futures-channel" "0.3.31"
                "040vpqpqlbk099razq8lyn74m0f161zd0rp36hciqrwcg2zibzrd"))

(define rust-futures-core-0.3.31
  (crate-source "futures-core" "0.3.31"
                "0gk6yrxgi5ihfanm2y431jadrll00n5ifhnpx090c2f2q1cr1wh5"))

(define rust-futures-executor-0.3.31
  (crate-source "futures-executor" "0.3.31"
                "17vcci6mdfzx4gbk0wx64chr2f13wwwpvyf3xd5fb1gmjzcx2a0y"))

(define rust-futures-io-0.3.31
  (crate-source "futures-io" "0.3.31"
                "1ikmw1yfbgvsychmsihdkwa8a1knank2d9a8dk01mbjar9w1np4y"))

(define rust-futures-lite-2.6.1
  (crate-source "futures-lite" "2.6.1"
                "1ba4dg26sc168vf60b1a23dv1d8rcf3v3ykz2psb7q70kxh113pp"))

(define rust-futures-macro-0.3.31
  (crate-source "futures-macro" "0.3.31"
                "0l1n7kqzwwmgiznn0ywdc5i24z72zvh9q1dwps54mimppi7f6bhn"))

(define rust-futures-sink-0.3.31
  (crate-source "futures-sink" "0.3.31"
                "1xyly6naq6aqm52d5rh236snm08kw8zadydwqz8bip70s6vzlxg5"))

(define rust-futures-task-0.3.31
  (crate-source "futures-task" "0.3.31"
                "124rv4n90f5xwfsm9qw6y99755y021cmi5dhzh253s920z77s3zr"))

(define rust-futures-util-0.3.31
  (crate-source "futures-util" "0.3.31"
                "10aa1ar8bgkgbr4wzxlidkqkcxf77gffyj8j7768h831pcaq784z"))

(define rust-fuzzy-matcher-0.3.7
  (crate-source "fuzzy-matcher" "0.3.7"
                "153csv8rsk2vxagb68kpmiknvdd3bzqj03x805khckck28rllqal"))

(define rust-fxhash-0.2.1
  (crate-source "fxhash" "0.2.1"
                "037mb9ichariqi45xm6mz0b11pa92gj38ba0409z3iz239sns6y3"))

(define rust-generic-array-0.14.7
  (crate-source "generic-array" "0.14.7"
                "16lyyrzrljfq424c3n8kfwkqihlimmsg5nhshbbp48np3yjrqr45"))

(define rust-gethostname-0.4.3
  (crate-source "gethostname" "0.4.3"
                "063qqhznyckwx9n4z4xrmdv10s0fi6kbr17r6bi1yjifki2y0xh1"))

(define rust-gethostname-1.0.2
  (crate-source "gethostname" "1.0.2"
                "0mdfkmfr41xx1i0nlwgzncmnj2a5f18kn6ydp7j1qc1q83dpy9gw"))

(define rust-getopts-0.2.23
  (crate-source "getopts" "0.2.23"
                "1ha8a3l3w68yrw3qjfzj0pak0rppf1yghign03iri1llxdisx9nb"))

(define rust-getopts-0.2.24
  (crate-source "getopts" "0.2.24"
                "1pylvsmq7fillnxmd6g58r7igdrlby412q37ws41z39va2ngpr6g"))

(define rust-getrandom-0.2.16
  (crate-source "getrandom" "0.2.16"
                "14l5aaia20cc6cc08xdlhrzmfcylmrnprwnna20lqf746pqzjprk"))

(define rust-getrandom-0.2.9
  (crate-source "getrandom" "0.2.9"
                "1r6p47dd9f9cgiwlxmksammbfwnhsv5hjkhd0kjsgnzanad1spn8"))

(define rust-getrandom-0.3.2
  (crate-source "getrandom" "0.3.2"
                "1w2mlixa1989v7czr68iji7h67yra2pbg3s480wsqjza1r2sizkk"))

(define rust-getrandom-0.3.3
  (crate-source "getrandom" "0.3.3"
                "1x6jl875zp6b2b6qp9ghc84b0l76bvng2lvm8zfcmwjl7rb5w516"))

(define rust-gimli-0.31.1
  (crate-source "gimli" "0.31.1"
                "0gvqc0ramx8szv76jhfd4dms0zyamvlg4whhiz11j34hh3dqxqh7"))

(define rust-gimli-0.32.3
  (crate-source "gimli" "0.32.3"
                "1iqk5xznimn5bfa8jy4h7pa1dv3c624hzgd2dkz8mpgkiswvjag6"))

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

(define rust-glob-0.3.3
  (crate-source "glob" "0.3.3"
                "106jpd3syfzjfj2k70mwm0v436qbx96wig98m4q8x071yrq35hhc"))

(define rust-globset-0.4.16
  (crate-source "globset" "0.4.16"
                "1xa9ivqs74imf1q288spxh49g6iw2mn3x9snibdgapazzj6h58al"))

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

(define rust-h2-0.4.11
  (crate-source "h2" "0.4.11"
                "118771sqbsa6cn48y9waxq24jx80f5xy8af0lq5ixq7ifsi51nhp"))

(define rust-h2-0.4.12
  (crate-source "h2" "0.4.12"
                "11hk5mpid8757z6n3v18jwb62ikffrgzjlrgpzqvkqdlzjfbdh7k"))

(define rust-half-1.8.2
  (crate-source "half" "1.8.2"
                "1mqbmx2m9qd4lslkb42fzgldsklhv9c4bxsc8j82r80d8m24mfza"))

(define rust-half-2.6.0
  (crate-source "half" "2.6.0"
                "1j83v0xaqvrw50ppn0g33zig0zsbdi7xiqbzgn7sd5al57nrd4a5"))

(define rust-half-2.7.0
  (crate-source "half" "2.7.0"
                "199b3ck3is62njqgsq7lj53dnjcbkmgrq1rg41kjrx9h9xfi2k75"))

(define rust-hash32-0.3.1
  (crate-source "hash32" "0.3.1"
                "01h68z8qi5gl9lnr17nz10lay8wjiidyjdyd60kqx8ibj090pmj7"))

(define rust-hashbrown-0.12.3
  (crate-source "hashbrown" "0.12.3"
                "1268ka4750pyg2pbgsr43f0289l5zah4arir2k4igx5a8c6fg7la"))

(define rust-hashbrown-0.14.3
  (crate-source "hashbrown" "0.14.3"
                "012nywlg0lj9kwanh69my5x67vjlfmzfi9a0rq4qvis2j8fil3r9"))

(define rust-hashbrown-0.14.5
  (crate-source "hashbrown" "0.14.5"
                "1wa1vy1xs3mp11bn3z9dv0jricgr6a2j0zkf1g19yz3vw4il89z5"))

(define rust-hashbrown-0.15.4
  (crate-source "hashbrown" "0.15.4"
                "1mg045sm1nm00cwjm7ndi80hcmmv1v3z7gnapxyhd9qxc62sqwar"))

(define rust-hashbrown-0.15.5
  (crate-source "hashbrown" "0.15.5"
                "189qaczmjxnikm9db748xyhiw04kpmhm9xj9k9hg0sgx7pjwyacj"))

(define rust-hashbrown-0.16.0
  (crate-source "hashbrown" "0.16.0"
                "13blh9j2yv77a6ni236ixiwdzbc1sh2bc4bdpaz7y859yv2bs6al"))

(define rust-heapless-0.8.0
  (crate-source "heapless" "0.8.0"
                "1b9zpdjv4qkl2511s2c80fz16fx9in4m9qkhbaa8j73032v9xyqb"))

(define rust-heck-0.5.0
  (crate-source "heck" "0.5.0"
                "1sjmpsdl8czyh9ywl3qcsfsq9a307dg4ni2vnlwgnzzqhc4y0113"))

(define rust-hermit-abi-0.3.3
  (crate-source "hermit-abi" "0.3.3"
                "1dyc8qsjh876n74a3rcz8h43s27nj1sypdhsn2ms61bd3b47wzyp"))

(define rust-hermit-abi-0.4.0
  (crate-source "hermit-abi" "0.4.0"
                "1k1zwllx6nfq417hy38x4akw1ivlv68ymvnzyxs76ffgsqcskxpv"))

(define rust-hermit-abi-0.5.2
  (crate-source "hermit-abi" "0.5.2"
                "1744vaqkczpwncfy960j2hxrbjl1q01csm84jpd9dajbdr2yy3zw"))

(define rust-hex-0.4.3
  (crate-source "hex" "0.4.3"
                "0w1a4davm1lgzpamwnba907aysmlrnygbqmfis2mqjx5m552a93z"))

(define rust-hexf-parse-0.2.1
  (crate-source "hexf-parse" "0.2.1"
                "1pr3a3sk66ddxdyxdxac7q6qaqjcn28v0njy22ghdpfn78l8d9nz"))

(define rust-hkdf-0.12.4
  (crate-source "hkdf" "0.12.4"
                "1xxxzcarz151p1b858yn5skmhyrvn8fs4ivx5km3i1kjmnr8wpvv"))

(define rust-hmac-0.12.1
  (crate-source "hmac" "0.12.1"
                "0pmbr069sfg76z7wsssfk5ddcqd9ncp79fyz6zcm6yn115yc6jbc"))

(define rust-home-0.5.11
  (crate-source "home" "0.5.11"
                "1kxb4k87a9sayr8jipr7nq9wpgmjk4hk4047hmf9kc24692k75aq"))

(define rust-hostname-0.4.1
  (crate-source "hostname" "0.4.1"
                "0rbxryl68bwv8hkjdjd8f37kdb10fncgsqrqksv64qy7s4y20vx5"))

(define rust-http-1.3.1
  (crate-source "http" "1.3.1"
                "0r95i5h7dr1xadp1ac9453w0s62s27hzkam356nyx2d9mqqmva7l"))

(define rust-http-body-1.0.1
  (crate-source "http-body" "1.0.1"
                "111ir5k2b9ihz5nr9cz7cwm7fnydca7dx4hc7vr16scfzghxrzhy"))

(define rust-http-body-util-0.1.3
  (crate-source "http-body-util" "0.1.3"
                "0jm6jv4gxsnlsi1kzdyffjrj8cfr3zninnxpw73mvkxy4qzdj8dh"))

(define rust-httparse-1.10.1
  (crate-source "httparse" "1.10.1"
                "11ycd554bw2dkgw0q61xsa7a4jn1wb1xbfacmf3dbwsikvkkvgvd"))

(define rust-httpdate-1.0.3
  (crate-source "httpdate" "1.0.3"
                "1aa9rd2sac0zhjqh24c9xvir96g188zldkx0hr6dnnlx5904cfyz"))

(define rust-human-name-2.0.4
  (crate-source "human_name" "2.0.4"
                "11f0vb0qsp1bfyrx1y4gq9h6cmn92iqs9pyff2i36fhgcbchmmzv"))

(define rust-humansize-2.1.3
  (crate-source "humansize" "2.1.3"
                "1msxd1akb3dydsa8qs461sds9krwnn31szvqgaq93p4x0ad1rdbc"))

(define rust-humantime-2.2.0
  (crate-source "humantime" "2.2.0"
                "17rz8jhh1mcv4b03wnknhv1shwq2v9vhkhlfg884pprsig62l4cv"))

(define rust-hyper-1.7.0
  (crate-source "hyper" "1.7.0"
                "07n59pxzlq621z611cbpvh7p4h9h15v0r7m5wgxygpx02d5aafpb"))

(define rust-hyper-rustls-0.27.7
  (crate-source "hyper-rustls" "0.27.7"
                "0n6g8998szbzhnvcs1b7ibn745grxiqmlpg53xz206v826v3xjg3"))

(define rust-hyper-timeout-0.5.2
  (crate-source "hyper-timeout" "0.5.2"
                "1c431l5ckr698248yd6bnsmizjy2m1da02cbpmsnmkpvpxkdb41b"))

(define rust-hyper-tls-0.6.0
  (crate-source "hyper-tls" "0.6.0"
                "1q36x2yps6hhvxq5r7mc8ph9zz6xlb573gx0x3yskb0fi736y83h"))

(define rust-hyper-util-0.1.16
  (crate-source "hyper-util" "0.1.16"
                "0pmw8gqkqjnsdrxdy5wd5q8z1gh7caxqk2an7b4s53byghkhb6wd"))

(define rust-hyper-util-0.1.17
  (crate-source "hyper-util" "0.1.17"
                "1a5fcnz0alrg4lx9xf6ja66ihaab58jnm5msnky804wg39cras9w"))

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

(define rust-iana-time-zone-0.1.64
  (crate-source "iana-time-zone" "0.1.64"
                "1yz980fmhaq9bdkasz35z63az37ci6kzzfhya83kgdqba61pzr9k"))

(define rust-iana-time-zone-haiku-0.1.2
  (crate-source "iana-time-zone-haiku" "0.1.2"
                "17r6jmj31chn7xs9698r122mapq85mfnv98bb4pg6spm0si2f67k"))

(define rust-icu-collections-1.5.0
  (crate-source "icu_collections" "1.5.0"
                "09j5kskirl59mvqc8kabhy7005yyy7dp88jw9f6f3gkf419a8byv"))

(define rust-icu-collections-2.0.0
  (crate-source "icu_collections" "2.0.0"
                "0izfgypv1hsxlz1h8fc2aak641iyvkak16aaz5b4aqg3s3sp4010"))

(define rust-icu-decimal-2.0.0
  (crate-source "icu_decimal" "2.0.0"
                "1qm2p28xg56fc1v5ji1s13bz13is28rjh9shyjlniqy4zm1iripy"))

(define rust-icu-decimal-data-2.0.0
  (crate-source "icu_decimal_data" "2.0.0"
                "1m9q4xmwgchnc2h0zq302z3is74ryicg9hd5csyg3ggr6ny662dp"))

(define rust-icu-locale-2.0.0
  (crate-source "icu_locale" "2.0.0"
                "1zdy5ym97gj0aqggk8zs2fngazf33szmssbc3gd92pik50ar5rba"))

(define rust-icu-locale-core-2.0.0
  (crate-source "icu_locale_core" "2.0.0"
                "02phv7vwhyx6vmaqgwkh2p4kc2kciykv2px6g4h8glxfrh02gphc"))

(define rust-icu-locale-data-2.0.0
  (crate-source "icu_locale_data" "2.0.0"
                "0r974pj4waqfb5k935xccgmm8rc1a21r77n68fkhd7bl4k0z1pjg"))

(define rust-icu-locid-1.5.0
  (crate-source "icu_locid" "1.5.0"
                "0dznvd1c5b02iilqm044q4hvar0sqibq1z46prqwjzwif61vpb0k"))

(define rust-icu-locid-transform-1.5.0
  (crate-source "icu_locid_transform" "1.5.0"
                "0kmmi1kmj9yph6mdgkc7v3wz6995v7ly3n80vbg0zr78bp1iml81"))

(define rust-icu-locid-transform-data-1.5.0
  (crate-source "icu_locid_transform_data" "1.5.0"
                "0vkgjixm0wzp2n3v5mw4j89ly05bg3lx96jpdggbwlpqi0rzzj7x"))

(define rust-icu-normalizer-1.5.0
  (crate-source "icu_normalizer" "1.5.0"
                "0kx8qryp8ma8fw1vijbgbnf7zz9f2j4d14rw36fmjs7cl86kxkhr"))

(define rust-icu-normalizer-2.0.0
  (crate-source "icu_normalizer" "2.0.0"
                "0ybrnfnxx4sf09gsrxri8p48qifn54il6n3dq2xxgx4dw7l80s23"))

(define rust-icu-normalizer-data-1.5.0
  (crate-source "icu_normalizer_data" "1.5.0"
                "05lmk0zf0q7nzjnj5kbmsigj3qgr0rwicnn5pqi9n7krmbvzpjpq"))

(define rust-icu-normalizer-data-2.0.0
  (crate-source "icu_normalizer_data" "2.0.0"
                "1lvjpzxndyhhjyzd1f6vi961gvzhj244nribfpdqxjdgjdl0s880"))

(define rust-icu-properties-1.5.1
  (crate-source "icu_properties" "1.5.1"
                "1xgf584rx10xc1p7zjr78k0n4zn3g23rrg6v2ln31ingcq3h5mlk"))

(define rust-icu-properties-2.0.1
  (crate-source "icu_properties" "2.0.1"
                "0az349pjg8f18lrjbdmxcpg676a7iz2ibc09d2wfz57b3sf62v01"))

(define rust-icu-properties-data-1.5.0
  (crate-source "icu_properties_data" "1.5.0"
                "0scms7pd5a7yxx9hfl167f5qdf44as6r3bd8myhlngnxqgxyza37"))

(define rust-icu-properties-data-2.0.1
  (crate-source "icu_properties_data" "2.0.1"
                "0cnn3fkq6k88w7p86w7hsd1254s4sl783rpz4p6hlccq74a5k119"))

(define rust-icu-provider-1.5.0
  (crate-source "icu_provider" "1.5.0"
                "1nb8vvgw8dv2inqklvk05fs0qxzkw8xrg2n9vgid6y7gm3423m3f"))

(define rust-icu-provider-2.0.0
  (crate-source "icu_provider" "2.0.0"
                "1bz5v02gxv1i06yhdhs2kbwxkw3ny9r2vvj9j288fhazgfi0vj03"))

(define rust-icu-provider-macros-1.5.0
  (crate-source "icu_provider_macros" "1.5.0"
                "1mjs0w7fcm2lcqmbakhninzrjwqs485lkps4hz0cv3k36y9rxj0y"))

(define rust-ident-case-1.0.1
  (crate-source "ident_case" "1.0.1"
                "0fac21q6pwns8gh1hz3nbq15j8fi441ncl6w4vlnd1cmc55kiq5r"))

(define rust-idna-1.0.3
  (crate-source "idna" "1.0.3"
                "0zlajvm2k3wy0ay8plr07w22hxkkmrxkffa6ah57ac6nci984vv8"))

(define rust-idna-1.1.0
  (crate-source "idna" "1.1.0"
                "1pp4n7hppm480zcx411dsv9wfibai00wbpgnjj4qj0xa7kr7a21v"))

(define rust-idna-adapter-1.2.0
  (crate-source "idna_adapter" "1.2.0"
                "0wggnkiivaj5lw0g0384ql2d7zk4ppkn3b1ry4n0ncjpr7qivjns"))

(define rust-idna-adapter-1.2.1
  (crate-source "idna_adapter" "1.2.1"
                "0i0339pxig6mv786nkqcxnwqa87v4m94b2653f6k3aj0jmhfkjis"))

(define rust-ignore-0.4.23
  (crate-source "ignore" "0.4.23"
                "0jysggjfmlxbg60vhhiz4pb8jfb7cnq5swdsvxknbs7x18wgv2bd"))

(define rust-image-0.25.7
  (crate-source "image" "0.25.7"
                "01cnnnx692nqkllgvgian8jm847d29gkd5bgvwj8wxs3c7hkqshw"))

(define rust-image-0.25.8
  (crate-source "image" "0.25.8"
                "1rwill018gn2kwzv332kfs72ns0kwwnfxwacbhvk9lk9cwzfp7sj"))

(define rust-indenter-0.3.3
  (crate-source "indenter" "0.3.3"
                "10y6i6y4ls7xsfsc1r3p5j2hhbxhaqnk5zzk8aj52b14v05ba8yf"))

(define rust-indenter-0.3.4
  (crate-source "indenter" "0.3.4"
                "1maq7yl2px9y40f68c2g2gjsq93rabphzp5shinj8nsldplfckcn"))

(define rust-indexmap-1.9.3
  (crate-source "indexmap" "1.9.3"
                "16dxmy7yvk51wvnih3a3im6fp5lmx0wx76i03n06wyak6cwhw1xx"))

(define rust-indexmap-2.10.0
  (crate-source "indexmap" "2.10.0"
                "0qd6g26gxzl6dbf132w48fa8rr95glly3jhbk90i29726d9xhk7y"))

(define rust-indexmap-2.11.0
  (crate-source "indexmap" "2.11.0"
                "1sb3nmhisf9pdwfcxzqlvx97xifcvlh5g0rqj9j7i7qg8f01jj7j"))

(define rust-indexmap-2.11.4
  (crate-source "indexmap" "2.11.4"
                "1rc8bgcjzfcskz1zipjjm7s3m1jskzhnhr9jxmsafhdk1xv863sb"))

(define rust-indoc-2.0.6
  (crate-source "indoc" "2.0.6"
                "1gbn2pkx5sgbd9lp05d2bkqpbfgazi0z3nvharh5ajah11d29izl"))

(define rust-inflector-0.11.4
  (crate-source "Inflector" "0.11.4"
                "1lqmcni21ifzyq41fhz6k1j2b23cmsx469s4g4sf01l78miqqhzy"))

(define rust-inotify-0.11.0
  (crate-source "inotify" "0.11.0"
                "1wq8m657rl085cg59p38sc5y62xy9yhhpvxbkd7n1awi4zzwqzgk"))

(define rust-inotify-sys-0.1.5
  ;; TODO: Check bundled sources.
  (crate-source "inotify-sys" "0.1.5"
                "1syhjgvkram88my04kv03s0zwa66mdwa5v7ddja3pzwvx2sh4p70"))

(define rust-inout-0.1.4
  (crate-source "inout" "0.1.4"
                "008xfl1jn9rxsq19phnhbimccf4p64880jmnpg59wqi07kk117w7"))

(define rust-insta-1.43.2
  (crate-source "insta" "1.43.2"
                "181m173v4f7s2f3j0lq462s0r6yg60y7fgxmnm1hy06yxd3vdza6"))

(define rust-instability-0.3.9
  (crate-source "instability" "0.3.9"
                "16pbfp50y1f6qqifk77zymz7r20f96v2gjc84vb8frwk1f080pa3"))

(define rust-intl-memoizer-0.5.3
  (crate-source "intl-memoizer" "0.5.3"
                "0gqn5wwhzacvj0z25r5r3l2pajg9c8i1ivh7g8g8dszm8pis439i"))

(define rust-intl-pluralrules-7.0.2
  (crate-source "intl_pluralrules" "7.0.2"
                "0wprd3h6h8nfj62d8xk71h178q7zfn3srxm787w4sawsqavsg3h7"))

(define rust-inventory-0.3.20
  (crate-source "inventory" "0.3.20"
                "10ybwdx175d7xpvzpz0g2cczn0yvqykkwf75974z55sq5k6xf25b"))

(define rust-inventory-0.3.21
  (crate-source "inventory" "0.3.21"
                "0vml3zmj9bwixf0xfrbvw8ip5ci1c8blprxy36cv3gig12f20qdw"))

(define rust-io-uring-0.7.10
  (crate-source "io-uring" "0.7.10"
                "0yvjyygwdcqjcgw8zp254hvjbm7as1c075dl50spdshas3aa4vq4"))

(define rust-io-uring-0.7.9
  (crate-source "io-uring" "0.7.9"
                "1i60fxfbxypfgfmq883kwxgldxcjlnnwjazgjiys3893fvrqfdfr"))

(define rust-ipnet-2.11.0
  (crate-source "ipnet" "2.11.0"
                "0c5i9sfi2asai28m8xp48k5gvwkqrg5ffpi767py6mzsrswv17s6"))

(define rust-iri-string-0.7.8
  (crate-source "iri-string" "0.7.8"
                "1cl0wfq97wq4s1p4dl0ix5cfgsc5fn7l22ljgw9ab9x1qglypifv"))

(define rust-is-ci-1.2.0
  (crate-source "is_ci" "1.2.0"
                "0ifwvxmrsj4r29agfzr71bjq6y1bihkx38fbzafq5vl0jn1wjmbn"))

(define rust-is-executable-1.0.5
  (crate-source "is_executable" "1.0.5"
                "1i78ss45h94nwabbn6ki64a91djlli8zdwwbh56jj9kvhssbiaxs"))

(define rust-is-terminal-0.4.13
  (crate-source "is-terminal" "0.4.13"
                "0jwgjjz33kkmnwai3nsdk1pz9vb6gkqvw1d1vq7bs3q48kinh7r6"))

(define rust-is-terminal-0.4.16
  (crate-source "is-terminal" "0.4.16"
                "1acm63whnpwiw1padm9bpqz04sz8msymrmyxc55mvlq8hqqpykg0"))

(define rust-is-terminal-polyfill-1.70.1
  (crate-source "is_terminal_polyfill" "1.70.1"
                "1kwfgglh91z33kl0w5i338mfpa3zs0hidq5j4ny4rmjwrikchhvr"))

(define rust-isocountry-0.3.2
  (crate-source "isocountry" "0.3.2"
                "011y6sb6rs2i85g2jvifx5s54clw7nprinzzhfx08jgvy15xr88y"))

(define rust-itertools-0.10.5
  (crate-source "itertools" "0.10.5"
                "0ww45h7nxx5kj6z2y6chlskxd1igvs4j507anr6dzg99x1h25zdh"))

(define rust-itertools-0.13.0
  (crate-source "itertools" "0.13.0"
                "11hiy3qzl643zcigknclh446qb9zlg4dpdzfkjaa9q9fqpgyfgj1"))

(define rust-itertools-0.14.0
  (crate-source "itertools" "0.14.0"
                "118j6l1vs2mx65dqhwyssbrxpawa90886m3mzafdvyip41w2q69b"))

(define rust-itoa-1.0.15
  (crate-source "itoa" "1.0.15"
                "0b4fj9kz54dr3wam0vprjwgygvycyw8r0qwg7vp19ly8b2w16psa"))

(define rust-itoa-1.0.9
  (crate-source "itoa" "1.0.9"
                "0f6cpb4yqzhkrhhg6kqsw3wnmmhdnnffi6r2xzy248gzi2v0l5dg"))

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

(define rust-js-sys-0.3.64
  ;; TODO: Check bundled sources.
  (crate-source "js-sys" "0.3.64"
                "0nlkiwpm8dyqcf1xyc6qmrankcgdd3fpzc0qyfq2sw3z97z9bwf5"))

(define rust-js-sys-0.3.77
  ;; TODO: Check bundled sources.
  (crate-source "js-sys" "0.3.77"
                "13x2qcky5l22z4xgivi59xhjjx4kxir1zg7gcj0f1ijzd4yg7yhw"))

(define rust-js-sys-0.3.81
  ;; TODO: Check bundled sources.
  (crate-source "js-sys" "0.3.81"
                "01ckbf16iwh7qj92fax9zh8vf2y9sk60cli6999cn7a1jxx96j7c"))

(define rust-keyring-3.6.3
  (crate-source "keyring" "3.6.3"
                "072mzc4rk2qffdlc8c5s9h38c6fifyr9xxmsix599ra4y2pw7g7f"))

(define rust-khronos-api-3.1.0
  (crate-source "khronos_api" "3.1.0"
                "1p0xj5mlbagqyvvnv8wmv3cr7l9y1m153888pxqwg3vk3mg5inz2"))

(define rust-khronos-egl-6.0.0
  (crate-source "khronos-egl" "6.0.0"
                "0xnzdx0n1bil06xmh8i1x6dbxvk7kd2m70bbm6nw1qzc43r1vbka"))

(define rust-kqueue-1.0.8
  (crate-source "kqueue" "1.0.8"
                "033x2knkbv8d3jy6i9r32jcgsq6zm3g97zh5la43amkv3g5g2ivl"))

(define rust-kqueue-1.1.1
  (crate-source "kqueue" "1.1.1"
                "0sjrsnza8zxr1zfpv6sa0zapd54kx9wlijrz9apqvs6wsw303hza"))

(define rust-kqueue-sys-1.0.4
  ;; TODO: Check bundled sources.
  (crate-source "kqueue-sys" "1.0.4"
                "12w3wi90y4kwis4k9g6fp0kqjdmc6l00j16g8mgbhac7vbzjb5pd"))

(define rust-lalrpop-0.19.12
  (crate-source "lalrpop" "0.19.12"
                "0yw3m7br8zsby1vb7d0v952hdllg6splc85ba4l9yn1746avy70a"))

(define rust-lalrpop-util-0.19.12
  (crate-source "lalrpop-util" "0.19.12"
                "1vd0iy505h97xxm66r3m68a34v0009784syy093mlk30p4vq5i6k"))

(define rust-landlock-0.4.2
  (crate-source "landlock" "0.4.2"
                "01n7411kcxa1k6zximyycdj6yrsp7mlmwksrqszi7sc8id0fzlmk"))

(define rust-landlock-0.4.3
  (crate-source "landlock" "0.4.3"
                "1mi9b2fyh5lr4ncfmla2376pfal328dq1gchwbw75cg5vivqpzmg"))

(define rust-lazy-static-1.4.0
  (crate-source "lazy_static" "1.4.0"
                "0in6ikhw8mgl33wjv6q6xfrb5b9jr16q8ygjy803fay4zcisvaz2"))

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

(define rust-libc-0.2.177
  (crate-source "libc" "0.2.177"
                "0xjrn69cywaii1iq2lib201bhlvan7czmrm604h5qcm28yps4x18"))

(define rust-libdbus-sys-0.2.6
  ;; TODO: Check bundled sources.
  (crate-source "libdbus-sys" "0.2.6"
                "17xx4dy30fn81zhwsm4y2c84wr0apyiams8hy20lc3mmzrp8bgjw"))

(define rust-libdrm-amdgpu-sys-0.8.8
  (crate-source "libdrm_amdgpu_sys" "0.8.8"
                "1bmaxgwa10mh8j7rf9jbzpwgs5hw4zi6zi60lpj8m2jx7igzjyws"))

(define rust-libloading-0.8.8
  (crate-source "libloading" "0.8.8"
                "0rw6q94psj3d6k0bi9nymqhyrz78lbdblryphhaszsw9p9ikj0q7"))

(define rust-libm-0.2.15
  (crate-source "libm" "0.2.15"
                "1plpzf0p829viazdj57yw5dhmlr8ywf3apayxc2f2bq5a6mvryzr"))

(define rust-libredox-0.1.10
  (crate-source "libredox" "0.1.10"
                "1jswil4ai90s4rh91fg8580x8nikni1zl3wnch4h01nvidqpwvs1"))

(define rust-libredox-0.1.3
  (crate-source "libredox" "0.1.3"
                "139602gzgs0k91zb7dvgj1qh4ynb8g1lbxsswdim18hcb6ykgzy0"))

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

(define rust-linux-keyutils-0.2.4
  (crate-source "linux-keyutils" "0.2.4"
                "13nipvk2mzk76y7yfsqwnwsqk21x6xy8fkmqz5is99fqbzn4j7kn"))

(define rust-linux-raw-sys-0.11.0
  ;; TODO: Check bundled sources.
  (crate-source "linux-raw-sys" "0.11.0"
                "0fghx0nn8nvbz5yzgizfcwd6ap2pislp68j8c1bwyr6sacxkq7fz"))

(define rust-linux-raw-sys-0.4.15
  ;; TODO: Check bundled sources.
  (crate-source "linux-raw-sys" "0.4.15"
                "1aq7r2g7786hyxhv40spzf2nhag5xbw2axxc1k8z5k1dsgdm4v6j"))

(define rust-linux-raw-sys-0.9.3
  ;; TODO: Check bundled sources.
  (crate-source "linux-raw-sys" "0.9.3"
                "04zl7j4k1kgbn7rrl3i7yszaglgxp0c8dbwx8f1cabnjjwhb2zgy"))

(define rust-linux-raw-sys-0.9.4
  ;; TODO: Check bundled sources.
  (crate-source "linux-raw-sys" "0.9.4"
                "04kyjdrq79lz9ibrf7czk6cv9d3jl597pb9738vzbsbzy1j5i56d"))

(define rust-litemap-0.7.4
  (crate-source "litemap" "0.7.4"
                "012ili3vppd4952sh6y3qwcd0jkd0bq2qpr9h7cppc8sj11k7saf"))

(define rust-litemap-0.8.0
  (crate-source "litemap" "0.8.0"
                "0mlrlskwwhirxk3wsz9psh6nxcy491n0dh8zl02qgj0jzpssw7i4"))

(define rust-litrs-0.4.2
  (crate-source "litrs" "0.4.2"
                "1v8bxsrkm0w2k9nmbp8hsspy9i1lawajywqdw4hx87rjzqv41rgm"))

(define rust-lock-api-0.4.13
  (crate-source "lock_api" "0.4.13"
                "0rd73p4299mjwl4hhlfj9qr88v3r0kc8s1nszkfmnq2ky43nb4wn"))

(define rust-lock-api-0.4.14
  (crate-source "lock_api" "0.4.14"
                "0rg9mhx7vdpajfxvdjmgmlyrn20ligzqvn8ifmaz7dc79gkrjhr2"))

(define rust-log-0.4.27
  (crate-source "log" "0.4.27"
                "150x589dqil307rv0rwj0jsgz5bjbwvl83gyl61jf873a7rjvp0k"))

(define rust-log-0.4.28
  (crate-source "log" "0.4.28"
                "0cklpzrpxafbaq1nyxarhnmcw9z3xcjrad3ch55mmr58xw2ha21l"))

(define rust-logos-0.12.1
  (crate-source "logos" "0.12.1"
                "1w82qm3hck5cr6ax3j3yzrpf4zzbffahz126ahyqwyn6h8b072xz"))

(define rust-logos-0.15.0
  (crate-source "logos" "0.15.0"
                "1nzkjsi7ckhqkgq9w8baw7hyg5lq0bwa2ggpxn0wrizl39n56vxb"))

(define rust-logos-codegen-0.15.0
  (crate-source "logos-codegen" "0.15.0"
                "0kmkmyd42rsxd04avmr2z3jdnblg81v94pkyg7manc0knv8bz6qq"))

(define rust-logos-derive-0.12.1
  (crate-source "logos-derive" "0.12.1"
                "0v295x78vcskab88hshl530w9d1vn61cmlaic4d6dydsila4kn51"))

(define rust-logos-derive-0.15.0
  (crate-source "logos-derive" "0.15.0"
                "1fjwbpxr4yvwp8nhraqbp62ipq8mn8schjnirgydp78434d8xzpb"))

(define rust-lru-0.12.5
  (crate-source "lru" "0.12.5"
                "0f1a7cgqxbyhrmgaqqa11m3azwhcc36w0v5r4izgbhadl3sg8k13"))

(define rust-lru-slab-0.1.2
  (crate-source "lru-slab" "0.1.2"
                "0m2139k466qj3bnpk66bwivgcx3z88qkxvlzk70vd65jq373jaqi"))

(define rust-lsp-server-0.7.8
  (crate-source "lsp-server" "0.7.8"
                "1yanavncgsx0i0rj65q12ddfcwpvzx5x8wgiq4g9fzz1fgfc8qll"))

(define rust-lsp-types-0.94.1
  (crate-source "lsp-types" "0.94.1"
                "18aym1qfgyaf9f9504yz911gssck5rv190izzr3hdqbal12gssy6"))

(define rust-lsp-types-0.95.1
  (crate-source "lsp-types" "0.95.1"
                "0ra36fd4yr7lf5igfrdvwjx9g87z3a99mrjgzk9nq04viqxd6d4f"))

(define rust-lsp-types-f-0.99.0
  (crate-source "lsp-types-f" "0.99.0"
                "1ncw82n32sfqvpnw8x4vyyspdfl51n20cv59vz582p5dwf08fqkx"))

(define rust-malloc-buf-0.0.6
  (crate-source "malloc_buf" "0.0.6"
                "1jqr77j89pwszv51fmnknzvd53i1nkmcr8rjrvcxhm4dx1zr1fv2"))

(define rust-maplit-1.0.2
  (crate-source "maplit" "1.0.2"
                "07b5kjnhrrmfhgqm9wprjw8adx6i225lqp49gasgqg74lahnabiy"))

(define rust-matchers-0.2.0
  (crate-source "matchers" "0.2.0"
                "1sasssspdj2vwcwmbq3ra18d3qniapkimfcbr47zmx6750m5llni"))

(define rust-matchit-0.8.4
  (crate-source "matchit" "0.8.4"
                "1hzl48fwq1cn5dvshfly6vzkzqhfihya65zpj7nz7lfx82mgzqa7"))

(define rust-maybe-async-0.2.10
  (crate-source "maybe-async" "0.2.10"
                "04fvg2ywb2p9dzf7i35xqfibxc05k1pirv36jswxcqg3qw82ryaw"))

(define rust-memchr-2.7.1
  (crate-source "memchr" "2.7.1"
                "0jf1kicqa4vs9lyzj4v4y1p90q0dh87hvhsdd5xvhnp527sw8gaj"))

(define rust-memchr-2.7.5
  (crate-source "memchr" "2.7.5"
                "1h2bh2jajkizz04fh047lpid5wgw2cr9igpkdhl3ibzscpd858ij"))

(define rust-memchr-2.7.6
  (crate-source "memchr" "2.7.6"
                "0wy29kf6pb4fbhfksjbs05jy2f32r2f3r1ga6qkmpz31k79h0azm"))

(define rust-memmap2-0.9.8
  (crate-source "memmap2" "0.9.8"
                "1dqxjs89krh8cin0k7ksqc9myw9yni9kn8d8cllwq4fn1isrhfl4"))

(define rust-memoffset-0.6.5
  (crate-source "memoffset" "0.6.5"
                "1kkrzll58a3ayn5zdyy9i1f1v3mx0xgl29x0chq614zazba638ss"))

(define rust-memoffset-0.9.0
  (crate-source "memoffset" "0.9.0"
                "0v20ihhdzkfw1jx00a7zjpk2dcp5qjq6lz302nyqamd9c4f4nqss"))

(define rust-memoffset-0.9.1
  (crate-source "memoffset" "0.9.1"
                "12i17wh9a9plx869g7j4whf62xw68k5zd4k0k5nh6ys5mszid028"))

(define rust-mime-0.3.17
  (crate-source "mime" "0.3.17"
                "16hkibgvb9klh0w0jk5crr5xv90l3wlf77ggymzjmvl1818vnxv8"))

(define rust-mime-guess-2.0.5
  (crate-source "mime_guess" "2.0.5"
                "03jmg3yx6j39mg0kayf7w4a886dl3j15y8zs119zw01ccy74zi7p"))

(define rust-minimal-lexical-0.2.1
  (crate-source "minimal-lexical" "0.2.1"
                "16ppc5g84aijpri4jzv14rvcnslvlpphbszc7zzp6vfkddf4qdb8"))

(define rust-miniz-oxide-0.8.8
  (crate-source "miniz_oxide" "0.8.8"
                "0al9iy33flfgxawj789w2c8xxwg1n2r5vv6m6p5hl2fvd2vlgriv"))

(define rust-miniz-oxide-0.8.9
  (crate-source "miniz_oxide" "0.8.9"
                "05k3pdg8bjjzayq3rf0qhpirq9k37pxnasfn4arbs17phqn6m9qz"))

(define rust-mio-1.0.3
  (crate-source "mio" "1.0.3"
                "1gah0h4ia3avxbwym0b6bi6lr6rpysmj9zvw6zis5yq0z0xq91i8"))

(define rust-mio-1.0.4
  (crate-source "mio" "1.0.4"
                "073n3kam3nz8j8had35fd2nn7j6a33pi3y5w3kq608cari2d9gkq"))

(define rust-moxcms-0.7.5
  (crate-source "moxcms" "0.7.5"
                "026df3qpxn430dlngpj3gjip0m9280g3asvbia5dpsjsjfl2zlyx"))

(define rust-moxcms-0.7.7
  (crate-source "moxcms" "0.7.7"
                "0h0bgzd7k3ff4421w4399yz6zk2vrx78wgp257r4ly4260df3265"))

(define rust-multimap-0.10.1
  (crate-source "multimap" "0.10.1"
                "1150lf0hjfjj4ksb8s3y0hl7a2nqzqlbh0is7vdym2iyjfrfr1qx"))

(define rust-naga-25.0.1
  (crate-source "naga" "25.0.1"
                "0cm69nrd703v5slnk397rd16k0wb7cf678xcz5brgr16bx27r5rb"))

(define rust-native-tls-0.2.14
  (crate-source "native-tls" "0.2.14"
                "03hga800x8bzkp8h7frnm7yp545dwwawgmaq673vx7byk1139pl7"))

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

(define rust-new-debug-unreachable-1.0.6
  (crate-source "new_debug_unreachable" "1.0.6"
                "11phpf1mjxq6khk91yzcbd3ympm78m3ivl7xg6lg2c0lf66fy3k5"))

(define rust-nibble-vec-0.1.0
  (crate-source "nibble_vec" "0.1.0"
                "0hsdp3s724s30hkqz74ky6sqnadhp2xwcj1n1hzy4vzkz4yxi9bp"))

(define rust-nix-0.28.0
  (crate-source "nix" "0.28.0"
                "1r0rylax4ycx3iqakwjvaa178jrrwiiwghcw95ndzy72zk25c8db"))

(define rust-nix-0.29.0
  (crate-source "nix" "0.29.0"
                "0ikvn7s9r2lrfdm3mx1h7nbfjvcc6s9vxdzw7j5xfkd2qdnp9qki"))

(define rust-nix-0.30.1
  (crate-source "nix" "0.30.1"
                "1dixahq9hk191g0c2ydc0h1ppxj0xw536y6rl63vlnp06lx3ylkl"))

(define rust-nohash-hasher-0.2.0
  (crate-source "nohash-hasher" "0.2.0"
                "0lf4p6k01w4wm7zn4grnihzj8s7zd5qczjmzng7wviwxawih5x9b"))

(define rust-nom-7.1.3
  (crate-source "nom" "7.1.3"
                "0jha9901wxam390jcf5pfa0qqfrgh8li787jx2ip0yk5b8y9hwyj"))

(define rust-normalize-line-endings-0.3.0
  (crate-source "normalize-line-endings" "0.3.0"
                "1gp52dfn2glz26a352zra8h04351icf0fkqzw1shkwrgh1vpz031"))

(define rust-notify-8.0.0
  (crate-source "notify" "8.0.0"
                "0hz9ab68gsbkidms6kgl4v7capfqjyl40vpfdarcfsnnnc1q9vig"))

(define rust-notify-8.2.0
  (crate-source "notify" "8.2.0"
                "1hrb83451vm5cpjw83nz5skgwjg5ara28zq8nxsqbzsif690fgad"))

(define rust-notify-debouncer-full-0.5.0
  (crate-source "notify-debouncer-full" "0.5.0"
                "1ldqk50zzfayq7l4adzv2c2mj6lkgkgki0r5r18l619qfld8pn6j"))

(define rust-notify-types-2.0.0
  (crate-source "notify-types" "2.0.0"
                "0pcjm3wnvb7pvzw6mn89csv64ip0xhx857kr8jic5vddi6ljc22y"))

(define rust-nu-ansi-term-0.50.1
  (crate-source "nu-ansi-term" "0.50.1"
                "16a3isvbxx8pa3lk71h3cq2fsx2d17zzq42j4mhpxy81gl2qx8nl"))

(define rust-nu-ansi-term-0.50.3
  (crate-source "nu-ansi-term" "0.50.3"
                "1ra088d885lbd21q1bxgpqdlk1zlndblmarn948jz2a40xsbjmvr"))

(define rust-nucleo-matcher-0.3.1
  (crate-source "nucleo-matcher" "0.3.1"
                "11dc5kfin1n561qdcg0x9aflvw876a8vldmqjhs5l6ixfcwgacxz"))

(define rust-num-0.4.3
  (crate-source "num" "0.4.3"
                "08yb2fc1psig7pkzaplm495yp7c30m4pykpkwmi5bxrgid705g9m"))

(define rust-num-bigint-0.4.6
  (crate-source "num-bigint" "0.4.6"
                "1f903zd33i6hkjpsgwhqwi2wffnvkxbn6rv4mkgcjcqi7xr4zr55"))

(define rust-num-complex-0.4.6
  (crate-source "num-complex" "0.4.6"
                "15cla16mnw12xzf5g041nxbjjm9m85hdgadd5dl5d0b30w9qmy3k"))

(define rust-num-conv-0.1.0
  (crate-source "num-conv" "0.1.0"
                "1ndiyg82q73783jq18isi71a7mjh56wxrk52rlvyx0mi5z9ibmai"))

(define rust-num-cpus-1.16.0
  (crate-source "num_cpus" "1.16.0"
                "0hra6ihpnh06dvfvz9ipscys0xfqa9ca9hzp384d5m02ssvgqqa1"))

(define rust-num-cpus-1.17.0
  (crate-source "num_cpus" "1.17.0"
                "0fxjazlng4z8cgbmsvbzv411wrg7x3hyxdq8nxixgzjswyylppwi"))

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

(define rust-num-traits-0.2.16
  (crate-source "num-traits" "0.2.16"
                "1hp6x4gayrib34y14gpcfx60hbqsmh7i8whjrbzy5rrvfayhl2zk"))

(define rust-num-traits-0.2.19
  (crate-source "num-traits" "0.2.19"
                "0h984rhdkkqd4ny9cif7y2azl3xdfb7768hb9irhpsch4q3gq787"))

(define rust-oauth2-5.0.0
  (crate-source "oauth2" "5.0.0"
                "0zfn67m93qfh9gyxxx1hj6yprk9dkr3hm1mi4ni23pqlj3kikqji"))

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

(define rust-objc2-0.6.3
  (crate-source "objc2" "0.6.3"
                "01ccrb558qav2rqrmk0clzqzdd6r1rmicqnf55xqam7cw2f5khmp"))

(define rust-objc2-app-kit-0.2.2
  (crate-source "objc2-app-kit" "0.2.2"
                "1zqyi5l1bm26j1bgmac9783ah36m5kcrxlqp5carglnpwgcrms74"))

(define rust-objc2-app-kit-0.3.1
  (crate-source "objc2-app-kit" "0.3.1"
                "1k4vz0s63rpp1yyhx96mh9nndn1zzv2cwxzpvw6rnigcidb9zwp6"))

(define rust-objc2-app-kit-0.3.2
  (crate-source "objc2-app-kit" "0.3.2"
                "132ijwni8lsi8phq7wnmialkxp46zx998fns3zq5np0ya1mr77nl"))

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

(define rust-objc2-core-foundation-0.3.2
  (crate-source "objc2-core-foundation" "0.3.2"
                "0dnmg7606n4zifyjw4ff554xvjmi256cs8fpgpdmr91gckc0s61a"))

(define rust-objc2-core-graphics-0.3.1
  (crate-source "objc2-core-graphics" "0.3.1"
                "197mf2a4yvvigkd9hsp8abbpip7rn3mmc55psv1ba89hq5l6r74q"))

(define rust-objc2-core-graphics-0.3.2
  (crate-source "objc2-core-graphics" "0.3.2"
                "01x8413pxq0m5rwidlaczni8v5cz9dc3xqzq8l9zlpl9cv8cj8p0"))

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

(define rust-objc2-foundation-0.3.2
  (crate-source "objc2-foundation" "0.3.2"
                "0wijkxzzvw2xkzssds3fj8279cbykz2rz9agxf6qh7y2agpsvq73"))

(define rust-objc2-io-surface-0.3.1
  (crate-source "objc2-io-surface" "0.3.1"
                "0g0c89swz8hgfrh0j1iqhcz3ig7cyhavn3p9gi2s77sjjanfk0kj"))

(define rust-objc2-io-surface-0.3.2
  (crate-source "objc2-io-surface" "0.3.2"
                "07fqx4fmwydf2arrc4xs4awv7zyzzxh60fyqdfmrpm9n148qh1qq"))

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

(define rust-object-0.37.3
  (crate-source "object" "0.37.3"
                "1zikiy9xhk6lfx1dn2gn2pxbnfpmlkn0byd7ib1n720x0cgj0xpz"))

(define rust-once-cell-1.21.3
  (crate-source "once_cell" "1.21.3"
                "0b9x77lb9f1j6nqgf5aka4s2qj0nly176bpbrv6f9iakk5ff3xa2"))

(define rust-once-cell-polyfill-1.70.1
  (crate-source "once_cell_polyfill" "1.70.1"
                "1bg0w99srq8h4mkl68l1mza2n2f2hvrg0n8vfa3izjr5nism32d4"))

(define rust-oorandom-11.1.3
  (crate-source "oorandom" "11.1.3"
                "0xdm4vd89aiwnrk1xjwzklnchjqvib4klcihlc2bsd4x50mbrc8a"))

(define rust-openssl-0.10.73
  (crate-source "openssl" "0.10.73"
                "1y7b3kanpgb92wiqhwbyqfsdr1xdjzssxqywl4cixay88r6p61c5"))

(define rust-openssl-macros-0.1.1
  (crate-source "openssl-macros" "0.1.1"
                "173xxvfc63rr5ybwqwylsir0vq6xsj4kxiv4hmg4c3vscdmncj59"))

(define rust-openssl-probe-0.1.6
  (crate-source "openssl-probe" "0.1.6"
                "0bl52x55laalqb707k009h8kfawliwp992rlsvkzy49n47p2fpnh"))

(define rust-openssl-src-300.5.1+3.5.1
  ;; TODO: Check bundled sources.
  (crate-source "openssl-src" "300.5.1+3.5.1"
                "0ap411sii93yj2lw0sshfgn679k6cjg125y17c70135j6b430lkk"))

(define rust-openssl-src-300.5.3+3.5.4
  ;; TODO: Check bundled sources.
  (crate-source "openssl-src" "300.5.3+3.5.4"
                "1hl8z2w5va7x64pk3ll6hmdkff9hx32wjb133sbn6fr3s26assyw"))

(define rust-openssl-sys-0.9.109
  ;; TODO: Check bundled sources.
  (crate-source "openssl-sys" "0.9.109"
                "0wc54dshsac1xicq6b5wz01p358zcbf542f2s6vph3b38wp6w2ch"))

(define rust-opentelemetry-0.30.0
  (crate-source "opentelemetry" "0.30.0"
                "1rjjwlvhr7h01kl0768v9i7ng77l1axxfzbg29ancxbjrgj1dx5a"))

(define rust-opentelemetry-appender-tracing-0.30.1
  (crate-source "opentelemetry-appender-tracing" "0.30.1"
                "05pwdypdbg8sxkbafy8cr1cyjyy19w4r7s001rbpxm7slpn673z6"))

(define rust-opentelemetry-http-0.30.0
  (crate-source "opentelemetry-http" "0.30.0"
                "0vf3d9p733ms312hcbhy14h32imf22bl7qw6i3mdp5rahjg67xjh"))

(define rust-opentelemetry-otlp-0.30.0
  (crate-source "opentelemetry-otlp" "0.30.0"
                "0aw5amychdmwayfa0p724na1m7vd1jk9qlzw39riaxp08d56dvnv"))

(define rust-opentelemetry-proto-0.30.0
  (crate-source "opentelemetry-proto" "0.30.0"
                "1p4d1s7p4z5a9xy4x4dsjifc3385v5q8wx780mdgw407cvbny11f"))

(define rust-opentelemetry-sdk-0.30.0
  (crate-source "opentelemetry_sdk" "0.30.0"
                "0jvsqhdrka9ppyfr3y6rhj4ai61wgrfk0970jqcd2cayksm49xhi"))

(define rust-opentelemetry-semantic-conventions-0.30.0
  (crate-source "opentelemetry-semantic-conventions" "0.30.0"
                "1hns9n0sh89cqp7rav7gf2a5nw65wv2m78sphms3cx54jsi5kl43"))

(define rust-option-ext-0.2.0
  (crate-source "option-ext" "0.2.0"
                "0zbf7cx8ib99frnlanpyikm1bx8qn8x602sw1n7bg6p9x94lyx04"))

(define rust-orbclient-0.3.48
  (crate-source "orbclient" "0.3.48"
                "0hzxjsvvsl5i9d3aqzc6kdcsch1i6flij5dkignhhkz2qb72c2xs"))

(define rust-ordered-float-4.6.0
  (crate-source "ordered-float" "4.6.0"
                "0ldrcgilsiijd141vw51fbkziqmh5fpllil3ydhirjm67wdixdvv"))

(define rust-ordered-multimap-0.7.3
  (crate-source "ordered-multimap" "0.7.3"
                "0ygg08g2h381r3zbclba4zx4amm25zd2hsqqmlxljc00mvf3q829"))

(define rust-ordered-stream-0.2.0
  (crate-source "ordered-stream" "0.2.0"
                "0l0xxp697q7wiix1gnfn66xsss7fdhfivl2k7bvpjs4i3lgb18ls"))

(define rust-os-info-3.12.0
  (crate-source "os_info" "3.12.0"
                "1hzzmxj8z69q5l1hzlnqnaa56ip9kvmghp8k750w6hwdvrgsrqfh"))

(define rust-owned-ttf-parser-0.25.1
  (crate-source "owned_ttf_parser" "0.25.1"
                "0fsqzcbc4sq8qhkmc3rgcfg1xg389nmhlxvmvi6h38dca680x0in"))

(define rust-owo-colors-4.2.2
  (crate-source "owo-colors" "4.2.2"
                "0pjlic0x9gc12iv1rxc6gvvx0sw0wpq629a6s07l81c45i54zpa8"))

(define rust-owo-colors-4.2.3
  (crate-source "owo-colors" "4.2.3"
                "0ljavh4hfxmlyjr67hyii5875p55kjg24crkj6h937m7kxr02scw"))

(define rust-parking-2.2.1
  (crate-source "parking" "2.2.1"
                "1fnfgmzkfpjd69v4j9x737b1k8pnn054bvzcn5dm3pkgq595d3gk"))

(define rust-parking-lot-0.12.4
  (crate-source "parking_lot" "0.12.4"
                "04sab1c7304jg8k0d5b2pxbj1fvgzcf69l3n2mfpkdb96vs8pmbh"))

(define rust-parking-lot-0.12.5
  (crate-source "parking_lot" "0.12.5"
                "06jsqh9aqmc94j2rlm8gpccilqm6bskbd67zf6ypfc0f4m9p91ck"))

(define rust-parking-lot-core-0.9.11
  (crate-source "parking_lot_core" "0.9.11"
                "19g4d6m5k4ggacinqprnn8xvdaszc3y5smsmbz1adcdmaqm8v0xw"))

(define rust-parking-lot-core-0.9.12
  (crate-source "parking_lot_core" "0.9.12"
                "1hb4rggy70fwa1w9nb0svbyflzdc69h047482v2z3sx2hmcnh896"))

(define rust-paste-1.0.15
  (crate-source "paste" "1.0.15"
                "02pxffpdqkapy292harq6asfjvadgp1s005fip9ljfsn9fvxgh2p"))

(define rust-path-absolutize-3.1.1
  (crate-source "path-absolutize" "3.1.1"
                "1xc36c5lz187wy452qph3lrr41x8ffgxk1clj2s9b8czwwgkibz4"))

(define rust-path-clean-1.0.1
  (crate-source "path-clean" "1.0.1"
                "1vzwcrlz39rd94l89rppvkbsn7dvng449f1bnkyk3ayp43y9ld8p"))

(define rust-path-dedot-3.1.1
  (crate-source "path-dedot" "3.1.1"
                "15wkx8q3vra34fslzlg1lkq7liyxwqrpbxiz44a28wa7w3bhmfh7"))

(define rust-pathdiff-0.2.3
  (crate-source "pathdiff" "0.2.3"
                "1lrqp4ip05df8dzldq6gb2c1sq2gs54gly8lcnv3rhav1qhwx56z"))

(define rust-percent-encoding-2.3.1
  (crate-source "percent-encoding" "2.3.1"
                "0gi8wgx0dcy8rnv1kywdv98lwcx67hz0a0zwpib5v2i08r88y573"))

(define rust-percent-encoding-2.3.2
  (crate-source "percent-encoding" "2.3.2"
                "083jv1ai930azvawz2khv7w73xh8mnylk7i578cifndjn5y64kwv"))

(define rust-petgraph-0.6.5
  (crate-source "petgraph" "0.6.5"
                "1ns7mbxidnn2pqahbbjccxkrqkrll2i5rbxx43ns6rh6fn3cridl"))

(define rust-phf-0.11.2
  (crate-source "phf" "0.11.2"
                "1p03rsw66l7naqhpgr1a34r9yzi1gv9jh16g3fsk6wrwyfwdiqmd"))

(define rust-phf-codegen-0.11.2
  (crate-source "phf_codegen" "0.11.2"
                "0nia6h4qfwaypvfch3pnq1nd2qj64dif4a6kai3b7rjrsf49dlz8"))

(define rust-phf-generator-0.11.2
  (crate-source "phf_generator" "0.11.2"
                "1c14pjyxbcpwkdgw109f7581cc5fa3fnkzdq1ikvx7mdq9jcrr28"))

(define rust-phf-shared-0.11.2
  (crate-source "phf_shared" "0.11.2"
                "0azphb0a330ypqx3qvyffal5saqnks0xvl8rj73jlk3qxxgbkz4h"))

(define rust-phf-shared-0.11.3
  (crate-source "phf_shared" "0.11.3"
                "1rallyvh28jqd9i916gk5gk2igdmzlgvv5q0l3xbf3m6y8pbrsk7"))

(define rust-pin-project-1.1.10
  (crate-source "pin-project" "1.1.10"
                "12kadbnfm1f43cyadw9gsbyln1cy7vj764wz5c8wxaiza3filzv7"))

(define rust-pin-project-internal-1.1.10
  (crate-source "pin-project-internal" "1.1.10"
                "0qgqzfl0f4lzaz7yl5llhbg97g68r15kljzihaw9wm64z17qx4bf"))

(define rust-pin-project-lite-0.2.16
  (crate-source "pin-project-lite" "0.2.16"
                "16wzc7z7dfkf9bmjin22f5282783f6mdksnr0nv0j5ym5f9gyg1v"))

(define rust-pin-utils-0.1.0
  (crate-source "pin-utils" "0.1.0"
                "117ir7vslsl2z1a7qzhws4pd01cg2d3338c47swjyvqv2n60v1wb"))

(define rust-piper-0.2.4
  (crate-source "piper" "0.2.4"
                "0rn0mjjm0cwagdkay77wgmz3sqf8fqmv9d9czm79mvr2yj8c9j4n"))

(define rust-pkg-config-0.3.32
  (crate-source "pkg-config" "0.3.32"
                "0k4h3gnzs94sjb2ix6jyksacs52cf1fanpwsmlhjnwrdnp8dppby"))

(define rust-plist-1.7.4
  (crate-source "plist" "1.7.4"
                "1qg7zkvnm4r4n9s9hbwwjnwznvkg6v0f035hza4agib3w64vbxis"))

(define rust-plist-1.8.0
  (crate-source "plist" "1.8.0"
                "01qyv51ljbvhjbg8mva5c802b3dzrr95y6nd23wjh52xbjhvw3kl"))

(define rust-plotters-0.3.5
  (crate-source "plotters" "0.3.5"
                "0igxq58bx96gz58pqls6g3h80plf17rfl3b6bi6xvjnp02x29hnj"))

(define rust-plotters-backend-0.3.5
  (crate-source "plotters-backend" "0.3.5"
                "02cn98gsj2i1bwrfsymifmyas1wn2gibdm9mk8w82x9s9n5n4xly"))

(define rust-plotters-svg-0.3.5
  (crate-source "plotters-svg" "0.3.5"
                "1axbw82frs5di4drbyzihr5j35wpy2a75hp3f49p186cjfcd7xiq"))

(define rust-png-0.18.0
  (crate-source "png" "0.18.0"
                "187jf0m873qn5biix8z7gjdsyf8r6vj3yr495pa0jja6i39wxflp"))

(define rust-polling-3.10.0
  (crate-source "polling" "3.10.0"
                "0afqlnm45081k06sngc052k9vmh33j2rqrmjgi7q1zjhcca1kgdm"))

(define rust-polling-3.11.0
  (crate-source "polling" "3.11.0"
                "0622qfbxi3gb0ly2c99n3xawp878fkrd1sl83hjdhisx11cly3jx"))

(define rust-pollster-0.4.0
  (crate-source "pollster" "0.4.0"
                "1qqcn0h2bvmgm9rlhfrdk7lfaiw1ad86g9500bhx1rj1s0c9yfig"))

(define rust-portable-atomic-1.11.1
  (crate-source "portable-atomic" "1.11.1"
                "10s4cx9y3jvw0idip09ar52s2kymq8rq9a668f793shn1ar6fhpq"))

(define rust-portable-atomic-util-0.2.4
  (crate-source "portable-atomic-util" "0.2.4"
                "01rmx1li07ixsx3sqg2bxqrkzk7b5n8pibwwf2589ms0s3cg18nq"))

(define rust-portable-pty-0.9.0
  (crate-source "portable-pty" "0.9.0"
                "07k710gj2ixgp4r1lcfxvl2qfyvkjr52vb0zyna2sxfjnfi9d9dl"))

(define rust-potential-utf-0.1.2
  (crate-source "potential_utf" "0.1.2"
                "11dm6k3krx3drbvhgjw8z508giiv0m09wzl6ghza37176w4c79z5"))

(define rust-potential-utf-0.1.3
  (crate-source "potential_utf" "0.1.3"
                "12mhwvhpvvim6xqp6ifgkh1sniv9j2cmid6axn10fnjvpsnikpw4"))

(define rust-powerfmt-0.2.0
  (crate-source "powerfmt" "0.2.0"
                "14ckj2xdpkhv3h6l5sdmb9f1d57z8hbfpdldjc2vl5givq2y77j3"))

(define rust-ppv-lite86-0.2.21
  (crate-source "ppv-lite86" "0.2.21"
                "1abxx6qz5qnd43br1dd9b2savpihzjza8gb4fbzdql1gxp2f7sl5"))

(define rust-precomputed-hash-0.1.1
  (crate-source "precomputed-hash" "0.1.1"
                "075k9bfy39jhs53cb2fpb9klfakx2glxnf28zdw08ws6lgpq6lwj"))

(define rust-predicates-3.1.3
  (crate-source "predicates" "3.1.3"
                "0wrm57acvagx0xmh5xffx5xspsr2kbggm698x0vks132fpjrxld5"))

(define rust-predicates-core-1.0.9
  (crate-source "predicates-core" "1.0.9"
                "1yjz144yn3imq2r4mh7k9h0r8wv4yyjjj57bs0zwkscz24mlczkj"))

(define rust-predicates-tree-1.0.12
  (crate-source "predicates-tree" "1.0.12"
                "0p223d9y02ywwxs3yl68kziswz4da4vabz67jfhp7yqx71njvpbj"))

(define rust-pretty-assertions-1.4.1
  (crate-source "pretty_assertions" "1.4.1"
                "0v8iq35ca4rw3rza5is3wjxwsf88303ivys07anc5yviybi31q9s"))

(define rust-pretty-env-logger-0.5.0
  (crate-source "pretty_env_logger" "0.5.0"
                "076w9dnvcpx6d3mdbkqad8nwnsynb7c8haxmscyrz7g3vga28mw6"))

(define rust-prettyplease-0.2.33
  (crate-source "prettyplease" "0.2.33"
                "0zba9hcp50rg52j4134px0pwkx9i9zjnbp9ylv3cbx232d993vlx"))

(define rust-proc-macro-crate-3.3.0
  (crate-source "proc-macro-crate" "3.3.0"
                "0d9xlymplfi9yv3f5g4bp0d6qh70apnihvqcjllampx4f5lmikpd"))

(define rust-proc-macro-crate-3.4.0
  (crate-source "proc-macro-crate" "3.4.0"
                "10v9qi51n4phn1lrj5r94kjq7yhci9jrkqnn6wpan05yjsgb3711"))

(define rust-proc-macro-error-attr2-2.0.0
  (crate-source "proc-macro-error-attr2" "2.0.0"
                "1ifzi763l7swl258d8ar4wbpxj4c9c2im7zy89avm6xv6vgl5pln"))

(define rust-proc-macro-error2-2.0.1
  (crate-source "proc-macro-error2" "2.0.1"
                "00lq21vgh7mvyx51nwxwf822w2fpww1x0z8z0q47p8705g2hbv0i"))

(define rust-proc-macro2-1.0.101
  (crate-source "proc-macro2" "1.0.101"
                "1pijhychkpl7rcyf1h7mfk6gjfii1ywf5n0snmnqs5g4hvyl7bl9"))

(define rust-proc-macro2-1.0.89
  (crate-source "proc-macro2" "1.0.89"
                "0vlq56v41dsj69pnk7lil7fxvbfid50jnzdn3xnr31g05mkb0fgi"))

(define rust-proc-macro2-1.0.95
  (crate-source "proc-macro2" "1.0.95"
                "0y7pwxv6sh4fgg6s715ygk1i7g3w02c0ljgcsfm046isibkfbcq2"))

(define rust-process-wrap-8.2.1
  (crate-source "process-wrap" "8.2.1"
                "189vzjn8dan18cnb0qlk3b472a6imji8wqlzxj13mwi20hplzvx3"))

(define rust-prodash-30.0.1
  (crate-source "prodash" "30.0.1"
                "0fdi0wxgy3s9643dgyfkwgmm12g4a360djy56zbxkls9d1bgqvjs"))

(define rust-profiling-1.0.17
  (crate-source "profiling" "1.0.17"
                "0wqp6i1bl7azy9270dp92srbbr55mgdh9qnk5b1y44lyarmlif1y"))

(define rust-prost-0.13.5
  (crate-source "prost" "0.13.5"
                "1r8yi6zxxwv9gq5ia9p55nspgwmchs94sqpp64x33v5k3njgm5i7"))

(define rust-prost-derive-0.13.5
  (crate-source "prost-derive" "0.13.5"
                "0kgc9gbzsa998xixblfi3kfydka64zqf6rmpm53b761cjxbxfmla"))

(define rust-pulldown-cmark-0.10.3
  (crate-source "pulldown-cmark" "0.10.3"
                "14rrzqnv6j64j75558m7gzw6lc9b24057v6415smx1z7cvm9p5vn"))

(define rust-pulldown-cmark-escape-0.10.1
  (crate-source "pulldown-cmark-escape" "0.10.1"
                "1lqx7c2f0bx0qq9kkyn18gsa2dl2sk8x5jp8gvdax75w73sqyd5x"))

(define rust-pxfm-0.1.20
  (crate-source "pxfm" "0.1.20"
                "1y4n7c9m7hkykh7c9dmfd4v34xqrk2k442jzjj36wvsg360hhybf"))

(define rust-pxfm-0.1.23
  (crate-source "pxfm" "0.1.23"
                "112fz622i3l7iyfyfavy2hmf89b4jwc26cl9ljvrrlsfr3nlypzm"))

(define rust-pxfm-0.1.25
  (crate-source "pxfm" "0.1.25"
                "114x01bxzdlwbzjr2n7vs73y4f1r003qsl9v9pgpigvj74vxzjx3"))

(define rust-quick-error-2.0.1
  (crate-source "quick-error" "2.0.1"
                "18z6r2rcjvvf8cn92xjhm2qc3jpd1ljvcbf12zv0k9p565gmb4x9"))

(define rust-quick-xml-0.37.5
  (crate-source "quick-xml" "0.37.5"
                "1yxpd7rc2qn6f4agfj47ps2z89vv7lvzxpzawqirix8bmyhrf7ik"))

(define rust-quick-xml-0.38.0
  (crate-source "quick-xml" "0.38.0"
                "06vvgd9arm1nrsd4d0ii6lhnp6m11bwy7drqa4k9hnjw9xkb09w9"))

(define rust-quick-xml-0.38.3
  (crate-source "quick-xml" "0.38.3"
                "12bvsbnnmlnq9xg9in3h3080ag3sisafgpcn7lqyzhkz93kk58j2"))

(define rust-quinn-0.11.9
  (crate-source "quinn" "0.11.9"
                "086gzj666dr3slmlynkvxlndy28hahgl361d6bf93hk3i6ahmqmr"))

(define rust-quinn-proto-0.11.13
  (crate-source "quinn-proto" "0.11.13"
                "0cca3mgja9p4w66f6sl1kfhj8rdf4mwsg1jxzssh9g63n14np47i"))

(define rust-quinn-udp-0.5.14
  (crate-source "quinn-udp" "0.5.14"
                "1gacawr17a2zkyri0r3m0lc9spzmxbq1by3ilyb8v2mdvjhcdpmd"))

(define rust-quote-1.0.35
  (crate-source "quote" "1.0.35"
                "1vv8r2ncaz4pqdr78x7f138ka595sp2ncr1sa2plm4zxbsmwj7i9"))

(define rust-quote-1.0.40
  (crate-source "quote" "1.0.40"
                "1394cxjg6nwld82pzp2d4fp6pmaz32gai1zh9z5hvh0dawww118q"))

(define rust-quote-1.0.41
  (crate-source "quote" "1.0.41"
                "1lg108nb57lwbqlnpsii89cchk6i8pkcvrv88xh1p7a9gdz7c9ff"))

(define rust-r-efi-5.2.0
  (crate-source "r-efi" "5.2.0"
                "1ig93jvpqyi87nc5kb6dri49p56q7r7qxrn8kfizmqkfj5nmyxkl"))

(define rust-r-efi-5.3.0
  (crate-source "r-efi" "5.3.0"
                "03sbfm3g7myvzyylff6qaxk4z6fy76yv860yy66jiswc2m6b7kb9"))

(define rust-radix-trie-0.2.1
  (crate-source "radix_trie" "0.2.1"
                "1zaq3im5ss03w91ij11cj97vvzc5y1f3064d9pi2ysnwziww2sf0"))

(define rust-rand-0.8.5
  (crate-source "rand" "0.8.5"
                "013l6931nn7gkc23jz5mm3qdhf93jjf0fg64nz2lp4i51qd8vbrl"))

(define rust-rand-0.9.2
  (crate-source "rand" "0.9.2"
                "1lah73ainvrgl7brcxx0pwhpnqa3sm3qaj672034jz8i0q7pgckd"))

(define rust-rand-chacha-0.3.1
  (crate-source "rand_chacha" "0.3.1"
                "123x2adin558xbhvqb8w4f6syjsdkmqff8cxwhmjacpsl1ihmhg6"))

(define rust-rand-chacha-0.9.0
  (crate-source "rand_chacha" "0.9.0"
                "1jr5ygix7r60pz0s1cv3ms1f6pd1i9pcdmnxzzhjc3zn3mgjn0nk"))

(define rust-rand-core-0.6.4
  (crate-source "rand_core" "0.6.4"
                "0b4j2v4cb5krak1pv6kakv4sz6xcwbrmy2zckc32hsigbrwy82zc"))

(define rust-rand-core-0.9.3
  (crate-source "rand_core" "0.9.3"
                "0f3xhf16yks5ic6kmgxcpv1ngdhp48mmfy4ag82i1wnwh8ws3ncr"))

(define rust-ratatui-0.29.0.9b2ad12
  ;; TODO: Define standalone package if this is a workspace.
  (origin
    (method git-fetch)
    (uri (git-reference (url "https://github.com/nornagon/ratatui")
                        (commit "9b2ad1298408c45918ee9f8241a6f95498cdbed2")))
    (file-name (git-file-name "rust-ratatui" "0.29.0.9b2ad12"))
    (sha256 (base32 "06jyq7m4ch7d5y2cmsf0pqdyyycqif8qrkgp66qj1ch6rzjx66qw"))))

(define rust-ratatui-macros-0.6.0
  (crate-source "ratatui-macros" "0.6.0"
                "1x1dlns91bqs2dpg7nsccbpnbswcg1vn1yk669vs1s6vh07m9vvg"))

(define rust-raw-window-handle-0.6.2
  (crate-source "raw-window-handle" "0.6.2"
                "0ff5c648hncwx7hm2a8fqgqlbvbl4xawb6v3xxv9wkpjyrr5arr0"))

(define rust-rayon-1.10.0
  (crate-source "rayon" "1.10.0"
                "1ylgnzwgllajalr4v00y4kj22klq2jbwllm70aha232iah0sc65l"))

(define rust-rayon-core-1.12.1
  (crate-source "rayon-core" "1.12.1"
                "1qpwim68ai5h0j7axa8ai8z0payaawv3id0lrgkqmapx7lx8fr8l"))

(define rust-redox-syscall-0.3.5
  (crate-source "redox_syscall" "0.3.5"
                "0acgiy2lc1m2vr8cr33l5s7k9wzby8dybyab1a9p753hcbr68xjn"))

(define rust-redox-syscall-0.4.1
  (crate-source "redox_syscall" "0.4.1"
                "1aiifyz5dnybfvkk4cdab9p2kmphag1yad6iknc7aszlxxldf8j7"))

(define rust-redox-syscall-0.5.13
  (crate-source "redox_syscall" "0.5.13"
                "1mlzna9bcd7ss1973bmysr3hpjrys82b3bd7l03h4jkbxv8bf10d"))

(define rust-redox-syscall-0.5.15
  (crate-source "redox_syscall" "0.5.15"
                "1v28zzpfl6w2gpfbrl1vh64r8hqrjf3x8h57wq8n004lw3fz12ky"))

(define rust-redox-syscall-0.5.17
  (crate-source "redox_syscall" "0.5.17"
                "0xrvpchkaxph3r5ww2i04v9nwg3843fp3prf8kqlh1gv01b4c1sl"))

(define rust-redox-syscall-0.5.18
  (crate-source "redox_syscall" "0.5.18"
                "0b9n38zsxylql36vybw18if68yc9jczxmbyzdwyhb9sifmag4azd"))

(define rust-redox-users-0.4.6
  (crate-source "redox_users" "0.4.6"
                "0hya2cxx6hxmjfxzv9n8rjl5igpychav7zfi1f81pz6i4krry05s"))

(define rust-redox-users-0.5.0
  (crate-source "redox_users" "0.5.0"
                "0awxx66izdw6kz97r3zxrl5ms5f6dqi5l0f58mlsvlmx8wyrsvyx"))

(define rust-redox-users-0.5.2
  (crate-source "redox_users" "0.5.2"
                "1b17q7gf7w8b1vvl53bxna24xl983yn7bd00gfbii74bcg30irm4"))

(define rust-ref-cast-1.0.24
  (crate-source "ref-cast" "1.0.24"
                "1kx57g118vs9sqi6d2dcxy6vp8jbx8n5hilmv1sacip9vc8y82ja"))

(define rust-ref-cast-1.0.25
  (crate-source "ref-cast" "1.0.25"
                "0zdzc34qjva9xxgs889z5iz787g81hznk12zbk4g2xkgwq530m7k"))

(define rust-ref-cast-impl-1.0.24
  (crate-source "ref-cast-impl" "1.0.24"
                "1ir7dm7hpqqdgg60hlspsc1ck6wli7wa3xcqrsxz7wdz45f24r8i"))

(define rust-ref-cast-impl-1.0.25
  (crate-source "ref-cast-impl" "1.0.25"
                "1nkhn1fklmn342z5c4mzfzlxddv3x8yhxwwk02cj06djvh36065p"))

(define rust-regex-1.11.1
  (crate-source "regex" "1.11.1"
                "148i41mzbx8bmq32hsj1q4karkzzx5m60qza6gdw4pdc9qdyyi5m"))

(define rust-regex-1.11.2
  (crate-source "regex" "1.11.2"
                "04k9rzxd11hcahpyihlswy6f1zqw7lspirv4imm4h0lcdl8gvmr3"))

(define rust-regex-1.12.1
  (crate-source "regex" "1.12.1"
                "0cslpri2f9d4hfv4v3mp2kdb7d7gab0fd3b7yip1gnxc5k8dhlja"))

(define rust-regex-automata-0.4.10
  (crate-source "regex-automata" "0.4.10"
                "1mllcfmgjcl6d52d5k09lwwq9wj5mwxccix4bhmw5spy1gx5i53b"))

(define rust-regex-automata-0.4.12
  (crate-source "regex-automata" "0.4.12"
                "1ilg4v6vad4w7v9v6byqas64x15ckmj2rk6mljxanf3l1nm6c8bj"))

(define rust-regex-automata-0.4.8
  (crate-source "regex-automata" "0.4.8"
                "18wd530ndrmygi6xnz3sp345qi0hy2kdbsa89182nwbl6br5i1rn"))

(define rust-regex-automata-0.4.9
  (crate-source "regex-automata" "0.4.9"
                "02092l8zfh3vkmk47yjc8d631zhhcd49ck2zr133prvd3z38v7l0"))

(define rust-regex-lite-0.1.7
  (crate-source "regex-lite" "0.1.7"
                "0c5s0kyc4gch0l0rzhm54prgfs169l2zwfvnzn91rvv33hr42gwl"))

(define rust-regex-lite-0.1.8
  (crate-source "regex-lite" "0.1.8"
                "1njm055j5kfq0cqc6ray24wgwcw8hrzjqn8dy9b8yrayvyc2p54d"))

(define rust-regex-syntax-0.6.29
  (crate-source "regex-syntax" "0.6.29"
                "1qgj49vm6y3zn1hi09x91jvgkl2b1fiaq402skj83280ggfwcqpi"))

(define rust-regex-syntax-0.8.5
  (crate-source "regex-syntax" "0.8.5"
                "0p41p3hj9ww7blnbwbj9h7rwxzxg0c1hvrdycgys8rxyhqqw859b"))

(define rust-regex-syntax-0.8.6
  (crate-source "regex-syntax" "0.8.6"
                "00chjpglclfskmc919fj5aq308ffbrmcn7kzbkz92k231xdsmx6a"))

(define rust-regex-syntax-0.8.7
  (crate-source "regex-syntax" "0.8.7"
                "166jcv65vl7ncjpjpawp2qmzxf5pb7yyawfazpndakfmpci085n3"))

(define rust-renderdoc-sys-1.1.0
  ;; TODO: Check bundled sources.
  (crate-source "renderdoc-sys" "1.1.0"
                "0cj8zjs7k0gvchcx3jhpg8r9bbqy8b1hsgbz0flcq2ydn12hmcqr"))

(define rust-reqwest-0.12.23
  (crate-source "reqwest" "0.12.23"
                "1svw1k0jx17cmlwhixwqfv3bgpjapciw7klkghnd9cljh16g6afl"))

(define rust-ring-0.17.14
  (crate-source "ring" "0.17.14"
                "1dw32gv19ccq4hsx3ribhpdzri1vnrlcfqb2vj41xn4l49n9ws54"))

(define rust-rmcp-0.8.1
  (crate-source "rmcp" "0.8.1"
                "074w8vzvbwqm141wix1d0yh8xhxlsp3f7jlnikysbz49izdaqdbg"))

(define rust-rmcp-0.8.2
  (crate-source "rmcp" "0.8.2"
                "163qxqb7v1i9pz3m6nrf1k727cr5v8k38diipj1rrddyi4gx6daf"))

(define rust-rmcp-macros-0.8.1
  (crate-source "rmcp-macros" "0.8.1"
                "0x52aklb7g6nd5nbnjslxb6b60s4amx8zq827nfbf8xa18idbwf9"))

(define rust-rmcp-macros-0.8.2
  (crate-source "rmcp-macros" "0.8.2"
                "0r564kry74c9z63wn487af568p8hwm0fwkhg7yh3ki0hh6rii1fq"))

(define rust-ron-0.10.1
  (crate-source "ron" "0.10.1"
                "0zvv5mbzjd5hb4zgrw71154jn6wsdlsx2vggmrrkxiw1pzvvdkmy"))

(define rust-rowan-0.15.16
  (crate-source "rowan" "0.15.16"
                "0gdf8whwfzv41dr6xp2rhvgy83ckgg7wa7bss8rfcipsac12nm0a"))

(define rust-rust-embed-8.7.2
  (crate-source "rust-embed" "8.7.2"
                "12hprnl569f1pg2sn960gfla913mk1mxdwpn2a6vl9iad2w0hn82"))

(define rust-rust-embed-impl-8.7.2
  (crate-source "rust-embed-impl" "8.7.2"
                "171lshvdh122ypbf23gmhvrqnhbk0q9g27gaq6g82w9b76jg2rb0"))

(define rust-rust-embed-utils-8.7.2
  (crate-source "rust-embed-utils" "8.7.2"
                "151m1966qk75y10msazdp0xj4fqw1khcry0z946bf84bcj0hrk7n"))

(define rust-rust-ini-0.21.3
  (crate-source "rust-ini" "0.21.3"
                "1iw8yss8ncygd9yx5ay5gmr2jk7vcyv1d0d5pr1jlfcncqmqsvkr"))

(define rust-rustc-demangle-0.1.25
  (crate-source "rustc-demangle" "0.1.25"
                "0kxq6m0drr40434ch32j31dkg00iaf4zxmqg7sqxajhcz0wng7lq"))

(define rust-rustc-demangle-0.1.26
  (crate-source "rustc-demangle" "0.1.26"
                "1kja3nb0yhlm4j2p1hl8d7sjmn2g9fa1s4pj0qma5kj2lcndkxsn"))

(define rust-rustc-hash-1.1.0
  (crate-source "rustc-hash" "1.1.0"
                "1qkc5khrmv5pqi5l5ca9p5nl5hs742cagrndhbrlk3dhlrx3zm08"))

(define rust-rustc-hash-2.1.1
  (crate-source "rustc-hash" "2.1.1"
                "03gz5lvd9ghcwsal022cgkq67dmimcgdjghfb5yb5d352ga06xrm"))

(define rust-rustc-version-0.4.1
  (crate-source "rustc_version" "0.4.1"
                "14lvdsmr5si5qbqzrajgb6vfn69k0sfygrvfvr2mps26xwi3mjyg"))

(define rust-rustix-0.38.44
  (crate-source "rustix" "0.38.44"
                "0m61v0h15lf5rrnbjhcb9306bgqrhskrqv7i1n0939dsw8dbrdgx"))

(define rust-rustix-1.0.5
  (crate-source "rustix" "1.0.5"
                "1gsqrw9cp762ps9dl1d13n8mk5r0b6r2s002l1njxfylilwify6r"))

(define rust-rustix-1.0.8
  (crate-source "rustix" "1.0.8"
                "1j6ajqi61agdnh1avr4bplrsgydjw1n4mycdxw3v8g94pyx1y60i"))

(define rust-rustix-1.1.2
  (crate-source "rustix" "1.1.2"
                "0gpz343xfzx16x82s1x336n0kr49j02cvhgxdvaq86jmqnigh5fd"))

(define rust-rustls-0.23.29
  (crate-source "rustls" "0.23.29"
                "1lcvzvzqk8xx8jzg0x5v3mkqgwkwr7v6zdq8zw8rp6xj74h3i494"))

(define rust-rustls-0.23.32
  (crate-source "rustls" "0.23.32"
                "0h2ddlnbjhs47hcmf3rbvr32sxj5kpf0m56rgk739l192rijag6d"))

(define rust-rustls-native-certs-0.8.1
  (crate-source "rustls-native-certs" "0.8.1"
                "1ls7laa3748mkn23fmi3g4mlwk131lx6chq2lyc8v2mmabfz5kvz"))

(define rust-rustls-pki-types-1.12.0
  (crate-source "rustls-pki-types" "1.12.0"
                "0yawbdpix8jif6s8zj1p2hbyb7y3bj66fhx0y7hyf4qh4964m6i2"))

(define rust-rustls-webpki-0.103.4
  (crate-source "rustls-webpki" "0.103.4"
                "1z4jmmgasjgk9glb160a66bshvgifa64mgfjrkqp7dy1w158h5qa"))

(define rust-rustls-webpki-0.103.7
  (crate-source "rustls-webpki" "0.103.7"
                "1gqlsd0yqiqch97g0wbsnbmyrp75j6nbzfpf8dmhxa78j50ky2z1"))

(define rust-rustversion-1.0.15
  (crate-source "rustversion" "1.0.15"
                "0iyy66mldq0z7h6n2zm6fw2bndw04pifhv5s7xda8xzj668nzbw0"))

(define rust-rustversion-1.0.21
  (crate-source "rustversion" "1.0.21"
                "07bb1xx05hhwpnl43sqrhsmxyk5sd5m5baadp19nxp69s9xij3ca"))

(define rust-rustversion-1.0.22
  (crate-source "rustversion" "1.0.22"
                "0vfl70jhv72scd9rfqgr2n11m5i9l1acnk684m2w83w0zbqdx75k"))

(define rust-rustyline-14.0.0
  (crate-source "rustyline" "14.0.0"
                "0qvyckd5hbi2cf6kw4bsng6vb6rb9dzjfy24dndzszm3dn9yh0vq"))

(define rust-ryu-1.0.15
  (crate-source "ryu" "1.0.15"
                "0hfphpn1xnpzxwj8qg916ga1lyc33lc03lnf1gb3wwpglj6wrm0s"))

(define rust-ryu-1.0.20
  (crate-source "ryu" "1.0.20"
                "07s855l8sb333h6bpn24pka5sp7hjk2w667xy6a0khkf6sqv5lr8"))

(define rust-same-file-1.0.6
  (crate-source "same-file" "1.0.6"
                "00h5j1w87dmhnvbv9l8bic3y7xxsnjmssvifw2ayvgx9mb1ivz4k"))

(define rust-scc-2.4.0
  (crate-source "scc" "2.4.0"
                "1k2nwz3bysf1s3r5g437vq9xfm9i4sadfzn5c0k8xx7ynx3g1rj6"))

(define rust-schannel-0.1.28
  (crate-source "schannel" "0.1.28"
                "1qb6s5gyxfz2inz753a4z3mc1d266mwvz0c5w7ppd3h44swq27c9"))

(define rust-schemafy-0.5.2
  (crate-source "schemafy" "0.5.2"
                "1mc63prw2j3rm8y7ks3yx7sl318kr3dn92y4y8qy7nl70aj5psla"))

(define rust-schemafy-core-0.5.2
  (crate-source "schemafy_core" "0.5.2"
                "06sin2ydn55xfb9clbid0f83n3gad92p9yvy534m5zgljbh1ly21"))

(define rust-schemafy-lib-0.5.2
  (crate-source "schemafy_lib" "0.5.2"
                "1ymy532p81zchx9nq697c6xfr9znnq0hin2iqjccm6crawrdnlz9"))

(define rust-schemars-0.8.22
  (crate-source "schemars" "0.8.22"
                "05an9nbi18ynyxv1rjmwbg6j08j0496hd64mjggh53mwp3hjmgrz"))

(define rust-schemars-0.9.0
  (crate-source "schemars" "0.9.0"
                "0pqncln5hqbzbl2r3yayyr4a82jjf93h2cfxrn0xamvx77wr3lac"))

(define rust-schemars-1.0.4
  (crate-source "schemars" "1.0.4"
                "1l7w773jfk6mz0v8wpahp60aslksjijlbm65ysi4y5mwj520rll2"))

(define rust-schemars-derive-0.8.22
  (crate-source "schemars_derive" "0.8.22"
                "0kakyzrp5801s4i043l4ilv96lzimnlh01pap958h66n99w6bqij"))

(define rust-schemars-derive-1.0.4
  (crate-source "schemars_derive" "1.0.4"
                "107sprdfa5kacifxq41qv5ccv7a78msxyr8ikz0qs4qxdlwj1l1k"))

(define rust-scoped-tls-1.0.1
  (crate-source "scoped-tls" "1.0.1"
                "15524h04mafihcvfpgxd8f4bgc3k95aclz8grjkg9a0rxcvn9kz1"))

(define rust-scopeguard-1.2.0
  (crate-source "scopeguard" "1.2.0"
                "0jcz9sd47zlsgcnm1hdw0664krxwb5gczlif4qngj2aif8vky54l"))

(define rust-sdd-3.0.10
  (crate-source "sdd" "3.0.10"
                "1jj1brjjasx7r3lf6iyhhrpglx47vzr0z1qi1n0fcszjzv5wy3a9"))

(define rust-seccompiler-0.5.0
  (crate-source "seccompiler" "0.5.0"
                "1168zx8gmcp2shpp21g0ypd5yqv74v0vnnd52b8q2x47avg5bbm4"))

(define rust-secret-service-4.0.0
  (crate-source "secret-service" "4.0.0"
                "1m5zkmmhg1wv67g4lr6pqjyqg3yrh3b8bgpw1ykf06qqkbcmmlz4"))

(define rust-security-framework-2.11.1
  (crate-source "security-framework" "2.11.1"
                "00ldclwx78dm61v7wkach9lcx76awlrv0fdgjdwch4dmy12j4yw9"))

(define rust-security-framework-3.5.1
  (crate-source "security-framework" "3.5.1"
                "1vz6pf5qjgx8s0hg805hq6qbcqnll6fs63irvrpgcc7qx91p6adk"))

(define rust-security-framework-sys-2.15.0
  ;; TODO: Check bundled sources.
  (crate-source "security-framework-sys" "2.15.0"
                "1h6mijxnfrwvl1y4dzwn3m877j6dqp9qn3g37i954j5czazhq7yc"))

(define rust-self-cell-1.2.0
  (crate-source "self_cell" "1.2.0"
                "0jg70srf4hzrw96x8iclgf6i8dfgm1x8ds2i7yzcgq0i8njraz8g"))

(define rust-semver-1.0.23
  (crate-source "semver" "1.0.23"
                "12wqpxfflclbq4dv8sa6gchdh92ahhwn4ci1ls22wlby3h57wsb1"))

(define rust-semver-1.0.27
  (crate-source "semver" "1.0.27"
                "1qmi3akfrnqc2hfkdgcxhld5bv961wbk8my3ascv5068mc5fnryp"))

(define rust-sentry-0.34.0
  (crate-source "sentry" "0.34.0"
                "0rhh5rabcj5n8h9gbqi1983lhghfrr3cgm237gq840b5arjk312l"))

(define rust-sentry-backtrace-0.34.0
  (crate-source "sentry-backtrace" "0.34.0"
                "0fj6kjjydk56g1a1r3q2mz0yyq7mcx1q71h8r7bwjbhynidj5aj0"))

(define rust-sentry-contexts-0.34.0
  (crate-source "sentry-contexts" "0.34.0"
                "044rwgv5asv4zl8363v1z5nvvkagzp71j5km766cn5ixv93dg38s"))

(define rust-sentry-core-0.34.0
  (crate-source "sentry-core" "0.34.0"
                "0c2apnms1g3ycfxvb22r6qgj0svjryf2nh3a4dpqz779x37q64hn"))

(define rust-sentry-debug-images-0.34.0
  (crate-source "sentry-debug-images" "0.34.0"
                "12i3hq8fz3sxfx8s42abipqskggfcw1fxyj3gklsbjjzjigb5ilg"))

(define rust-sentry-panic-0.34.0
  (crate-source "sentry-panic" "0.34.0"
                "0qrds9n8byw31g9rnn6icjh4lm43g2zgq7s9m5qxjv8qqwlz4x5w"))

(define rust-sentry-tracing-0.34.0
  (crate-source "sentry-tracing" "0.34.0"
                "1v32ngxflzz96q4605nvvidf2klcnqws97kpvbp03k8346pmyg6d"))

(define rust-sentry-types-0.34.0
  (crate-source "sentry-types" "0.34.0"
                "0gqnddfjhgw1f9mln7fcak8wsva2jwg6gi59w8xgzf21pkvcss2x"))

(define rust-serde-1.0.219
  (crate-source "serde" "1.0.219"
                "1dl6nyxnsi82a197sd752128a4avm6mxnscywas1jq30srp2q3jz"))

(define rust-serde-1.0.225
  (crate-source "serde" "1.0.225"
                "07dxpjh0g1mq3md9yvn7jbgssgcizcircf23f04xml1mwbg28v7x"))

(define rust-serde-1.0.226
  (crate-source "serde" "1.0.226"
                "1zcm2asp9fiphbp0k96whabw02kiiqgzxhbyz85vc92v088n9jhd"))

(define rust-serde-1.0.228
  (crate-source "serde" "1.0.228"
                "17mf4hhjxv5m90g42wmlbc61hdhlm6j9hwfkpcnd72rpgzm993ls"))

(define rust-serde-core-1.0.225
  (crate-source "serde_core" "1.0.225"
                "10v3z58j5k6xhdxh90xgrv20wlnz5fnl67n04jdm47nbl3wmd4v5"))

(define rust-serde-core-1.0.226
  (crate-source "serde_core" "1.0.226"
                "1936x6cpqgyq57nm7qi416dsc4fiq3jv6d7vh74xmfgdk4wscaxs"))

(define rust-serde-core-1.0.228
  (crate-source "serde_core" "1.0.228"
                "1bb7id2xwx8izq50098s5j2sqrrvk31jbbrjqygyan6ask3qbls1"))

(define rust-serde-derive-1.0.219
  (crate-source "serde_derive" "1.0.219"
                "001azhjmj7ya52pmfiw4ppxm16nd44y15j2pf5gkcwrcgz7pc0jv"))

(define rust-serde-derive-1.0.225
  (crate-source "serde_derive" "1.0.225"
                "05j5zj2jdba3jnm7kh3fpljmhngmsa8pp5x495lpc7wbyynkda8f"))

(define rust-serde-derive-1.0.226
  (crate-source "serde_derive" "1.0.226"
                "0cyvkilp34an3f90b0idw0jjsyq20h7v47gsp8qkfmrl5zi3mdcd"))

(define rust-serde-derive-1.0.228
  (crate-source "serde_derive" "1.0.228"
                "0y8xm7fvmr2kjcd029g9fijpndh8csv5m20g4bd76w8qschg4h6m"))

(define rust-serde-derive-internals-0.29.1
  (crate-source "serde_derive_internals" "0.29.1"
                "04g7macx819vbnxhi52cx0nhxi56xlhrybgwybyy7fb9m4h6mlhq"))

(define rust-serde-json-1.0.140
  (crate-source "serde_json" "1.0.140"
                "0wwkp4vc20r87081ihj3vpyz5qf7wqkqipq17v99nv6wjrp8n1i0"))

(define rust-serde-json-1.0.141
  (crate-source "serde_json" "1.0.141"
                "1lq39h6lmkib00r4xipg26npl22pmkcy2r7cqqb84wdy3vrfzf9h"))

(define rust-serde-json-1.0.143
  (crate-source "serde_json" "1.0.143"
                "0njabwzldvj13ykrf1aaf4gh5cgl25kf9hzbpafbv3qh3ppsn0fl"))

(define rust-serde-json-1.0.145
  (crate-source "serde_json" "1.0.145"
                "1767y6kxjf7gwpbv8bkhgwc50nhg46mqwm9gy9n122f7v1k6yaj0"))

(define rust-serde-path-to-error-0.1.20
  (crate-source "serde_path_to_error" "0.1.20"
                "0mxls44p2ycmnxh03zpnlxxygq42w61ws7ir7r0ba6rp5s1gza8h"))

(define rust-serde-regex-1.1.0
  (crate-source "serde_regex" "1.1.0"
                "1pxsnxb8c198szghk1hvzvhva36w2q5zs70hqkmdf5d89qd6y4x8"))

(define rust-serde-repr-0.1.20
  (crate-source "serde_repr" "0.1.20"
                "1755gss3f6lwvv23pk7fhnjdkjw7609rcgjlr8vjg6791blf6php"))

(define rust-serde-spanned-1.0.0
  (crate-source "serde_spanned" "1.0.0"
                "10rv91337k8x8zmfir4h8aiwmwgkq07gdv7h0jxhcwwgk10lqws0"))

(define rust-serde-spanned-1.0.2
  (crate-source "serde_spanned" "1.0.2"
                "1vh4kcnzhw0fbr1jhg41p8yybnp5gmpnh171fy25bgn2a8s7h5sl"))

(define rust-serde-spanned-1.0.3
  (crate-source "serde_spanned" "1.0.3"
                "14j32cqcs6jjdl1c111lz6s0hr913dnmy2kpfd75k2761ym4ahz2"))

(define rust-serde-urlencoded-0.7.1
  (crate-source "serde_urlencoded" "0.7.1"
                "1zgklbdaysj3230xivihs30qi5vkhigg323a9m62k8jwf4a1qjfk"))

(define rust-serde-with-3.14.0
  (crate-source "serde_with" "3.14.0"
                "1manlm83865xwlvgv8frc472x19b75pd89a54mpxpagg3zb5ri7j"))

(define rust-serde-with-3.15.0
  (crate-source "serde_with" "3.15.0"
                "1igclzmh6fcxjx6f0qfr0amqy5cj2qazgq1796w64lmj066cv4v0"))

(define rust-serde-with-macros-3.14.0
  (crate-source "serde_with_macros" "3.14.0"
                "03xk9ghj2s6n331r565mgh22w0749vnq50094nd0vkk5cmg9946y"))

(define rust-serde-with-macros-3.15.0
  (crate-source "serde_with_macros" "3.15.0"
                "09qw900jb7qpf8khdlz4szgfpdsg6kswz8dgc5m045h8vf0c3rm7"))

(define rust-serial-test-3.2.0
  (crate-source "serial_test" "3.2.0"
                "1a8zg87gi28952hzj363ykwd8p1ssrakl1gi3f4xdqa4y84q298v"))

(define rust-serial-test-derive-3.2.0
  (crate-source "serial_test_derive" "3.2.0"
                "1vwyz2k5kiy5jmba0fvp6ph8ia707801bz918n2ff7bm11d2csax"))

(define rust-serial2-0.2.31
  (crate-source "serial2" "0.2.31"
                "1fympa15yl83xxfmcjc7a80qi2bpnlvy6bfffbfrv9h3d2aybq96"))

(define rust-serial2-0.2.33
  (crate-source "serial2" "0.2.33"
                "0g3g1jhjnwabgysd6p70jcqbxw3y8hywbqx15i4p3rr5isk6ziwc"))

(define rust-sha1-0.10.6
  (crate-source "sha1" "0.10.6"
                "1fnnxlfg08xhkmwf2ahv634as30l1i3xhlhkvxflmasi5nd85gz3"))

(define rust-sha1-checked-0.10.0
  (crate-source "sha1-checked" "0.10.0"
                "08s4h1drgwxzfn1mk11rn0r9i0rbjra1m0l2c0fbngij1jn9kxc9"))

(define rust-sha2-0.10.9
  (crate-source "sha2" "0.10.9"
                "10xjj843v31ghsksd9sl9y12qfc48157j1xpb8v1ml39jy0psl57"))

(define rust-sharded-slab-0.1.7
  (crate-source "sharded-slab" "0.1.7"
                "1xipjr4nqsgw34k7a2cgj9zaasl2ds6jwn89886kww93d32a637l"))

(define rust-shared-library-0.1.9
  (crate-source "shared_library" "0.1.9"
                "04fs37kdak051hm524a360978g58ayrcarjsbf54vqps5c7px7js"))

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

(define rust-signal-hook-registry-1.4.5
  (crate-source "signal-hook-registry" "1.4.5"
                "042lkqrpnlrgvrrcirgigxyp1zk70d8v0fsr5w7a18k3bw2vh0wj"))

(define rust-signal-hook-registry-1.4.6
  (crate-source "signal-hook-registry" "1.4.6"
                "12y2v1ms5z111fymaw1v8k93m5chnkp21h0jknrydkj8zydp395j"))

(define rust-simd-adler32-0.3.7
  (crate-source "simd-adler32" "0.3.7"
                "1zkq40c3iajcnr5936gjp9jjh1lpzhy44p3dq3fiw75iwr1w2vfn"))

(define rust-simdutf8-0.1.5
  (crate-source "simdutf8" "0.1.5"
                "0vmpf7xaa0dnaikib5jlx6y4dxd3hxqz6l830qb079g7wcsgxag3"))

(define rust-similar-2.7.0
  (crate-source "similar" "2.7.0"
                "1aidids7ymfr96s70232s6962v5g9l4zwhkvcjp4c5hlb6b5vfxv"))

(define rust-siphasher-0.3.11
  (crate-source "siphasher" "0.3.11"
                "03axamhmwsrmh0psdw3gf7c0zc4fyl5yjxfifz9qfka6yhkqid9q"))

(define rust-siphasher-1.0.1
  (crate-source "siphasher" "1.0.1"
                "17f35782ma3fn6sh21c027kjmd227xyrx06ffi8gw4xzv9yry6an"))

(define rust-slab-0.4.11
  (crate-source "slab" "0.4.11"
                "12bm4s88rblq02jjbi1dw31984w61y2ldn13ifk5gsqgy97f8aks"))

(define rust-slotmap-1.0.7
  (crate-source "slotmap" "1.0.7"
                "0amqb2fn9lcy1ri0risblkcp88dl0rnfmynw7lx0nqwza77lmzyv"))

(define rust-smallvec-1.13.2
  (crate-source "smallvec" "1.13.2"
                "0rsw5samawl3wsw6glrsb127rx6sh89a8wyikicw6dkdcjd1lpiw"))

(define rust-smallvec-1.15.1
  (crate-source "smallvec" "1.15.1"
                "00xxdxxpgyq5vjnpljvkmy99xij5rxgh913ii1v16kzynnivgcb7"))

(define rust-smawk-0.3.2
  (crate-source "smawk" "0.3.2"
                "0344z1la39incggwn6nl45k8cbw2x10mr5j0qz85cdz9np0qihxp"))

(define rust-smithay-client-toolkit-0.19.2
  (crate-source "smithay-client-toolkit" "0.19.2"
                "05h05hg4dn3v6br5jbdbs5nalk076a64s7fn6i01nqzby2hxwmrl"))

(define rust-smithay-clipboard-0.7.2
  (crate-source "smithay-clipboard" "0.7.2"
                "0inqnr4x458nqz0wdcanbgn77dad3bj0m7pjj074lrv3qkp1d0nc"))

(define rust-smol-str-0.2.2
  (crate-source "smol_str" "0.2.2"
                "1bfylqf2vnqaglw58930vpxm2rfzji5gjp15a2c0kh8aj6v8ylyx"))

(define rust-socket2-0.5.10
  (crate-source "socket2" "0.5.10"
                "0y067ki5q946w91xlz2sb175pnfazizva6fi3kfp639mxnmpc8z2"))

(define rust-socket2-0.6.0
  (crate-source "socket2" "0.6.0"
                "01qqdzfnr0bvdwq6wl56c9c4m2cvbxn43dfpcv8gjx208sph8d93"))

(define rust-spirv-0.3.0+sdk-1.3.268.0
  (crate-source "spirv" "0.3.0+sdk-1.3.268.0"
                "0i3qj7yvvprai1s03dvll2gkfy8398nl64wvllkhaaa4vh1i197d"))

(define rust-sse-stream-0.2.1
  (crate-source "sse-stream" "0.2.1"
                "16j734awsc6rmaxhap6z3xp6a8hr6l563dc6sckizv387k9w8kgb"))

(define rust-stable-deref-trait-1.2.0
  (crate-source "stable_deref_trait" "1.2.0"
                "1lxjr8q2n534b2lhkxd6l6wcddzjvnksi58zv11f9y0jjmr15wd8"))

(define rust-stable-deref-trait-1.2.1
  (crate-source "stable_deref_trait" "1.2.1"
                "15h5h73ppqyhdhx6ywxfj88azmrpml9gl6zp3pwy2malqa6vxqkc"))

(define rust-starlark-0.13.0
  (crate-source "starlark" "0.13.0"
                "13raj6jh6506qfiv9h96sizqg4yyxs9bs8dj0nvrspghb6c88lqg"))

(define rust-starlark-derive-0.13.0
  (crate-source "starlark_derive" "0.13.0"
                "0ah87ysmlf1n0dmaw8gyxd1dn4ij1hh4i3wz9kza303ridnbqn7y"))

(define rust-starlark-map-0.13.0
  (crate-source "starlark_map" "0.13.0"
                "0g8pa2wynpdgqp2yqkhdx289lykvb0rhn8mvq30hrpr0y5q9jrcj"))

(define rust-starlark-syntax-0.13.0
  (crate-source "starlark_syntax" "0.13.0"
                "1cv1hiij806c34vqxn477c72i0sgv5ifv7vbrgbsyskp1mlv6lzy"))

(define rust-static-assertions-1.1.0
  (crate-source "static_assertions" "1.1.0"
                "0gsl6xmw10gvn3zs1rv99laj5ig7ylffnh71f9l34js4nr4r7sx2"))

(define rust-streaming-iterator-0.1.9
  (crate-source "streaming-iterator" "0.1.9"
                "0845zdv8qb7zwqzglpqc0830i43xh3fb6vqms155wz85qfvk28ib"))

(define rust-string-cache-0.8.9
  (crate-source "string_cache" "0.8.9"
                "03z7km2kzlwiv2r2qifq5riv4g8phazwng9wnvs3py3lzainnxxz"))

(define rust-strsim-0.10.0
  (crate-source "strsim" "0.10.0"
                "08s69r4rcrahwnickvi0kq49z524ci50capybln83mg6b473qivk"))

(define rust-strsim-0.11.0
  (crate-source "strsim" "0.11.0"
                "00gsdp2x1gkkxsbjxgrjyil2hsbdg49bwv8q2y1f406dwk4p7q2y"))

(define rust-strsim-0.11.1
  (crate-source "strsim" "0.11.1"
                "0kzvqlw8hxqb7y598w1s0hxlnmi84sg5vsipp3yg5na5d1rvba3x"))

(define rust-strum-0.26.3
  (crate-source "strum" "0.26.3"
                "01lgl6jvrf4j28v5kmx9bp480ygf1nhvac8b4p7rcj9hxw50zv4g"))

(define rust-strum-0.27.2
  (crate-source "strum" "0.27.2"
                "1ksb9jssw4bg9kmv9nlgp2jqa4vnsa3y4q9zkppvl952q7vdc8xg"))

(define rust-strum-macros-0.26.4
  (crate-source "strum_macros" "0.26.4"
                "1gl1wmq24b8md527cpyd5bw9rkbqldd7k1h38kf5ajd2ln2ywssc"))

(define rust-strum-macros-0.27.2
  (crate-source "strum_macros" "0.27.2"
                "19xwikxma0yi70fxkcy1yxcv0ica8gf3jnh5gj936jza8lwcx5bn"))

(define rust-subtle-2.6.1
  (crate-source "subtle" "2.6.1"
                "14ijxaymghbl1p0wql9cib5zlwiina7kall6w7g89csprkgbvhhk"))

(define rust-supports-color-3.0.2
  (crate-source "supports-color" "3.0.2"
                "1mk7r2j6l7zmqk3pg7av0l6viq413lmk1vz4bjnf9lnq5liwfky6"))

(define rust-syn-1.0.109
  (crate-source "syn" "1.0.109"
                "0ds2if4600bd59wsv7jjgfkayfzy3hnazs394kz6zdkmna8l3dkj"))

(define rust-syn-2.0.102
  (crate-source "syn" "2.0.102"
                "0qh4v2nj61y82cc713fakjckhmwyvllq9n0gpmcg147sjjppsfgn"))

(define rust-syn-2.0.104
  (crate-source "syn" "2.0.104"
                "0h2s8cxh5dsh9h41dxnlzpifqqn59cqgm0kljawws61ljq2zgdhp"))

(define rust-syn-2.0.106
  (crate-source "syn" "2.0.106"
                "19mddxp1ia00hfdzimygqmr1jqdvyl86k48427bkci4d08wc9rzd"))

(define rust-syn-2.0.87
  (crate-source "syn" "2.0.87"
                "0bd3mfcswvn4jkrp7ich5kk58kmpph8412yxd36nsfnh8vilrai5"))

(define rust-sync-wrapper-1.0.2
  (crate-source "sync_wrapper" "1.0.2"
                "0qvjyasd6w18mjg5xlaq5jgy84jsjfsvmnn12c13gypxbv75dwhb"))

(define rust-synstructure-0.13.1
  (crate-source "synstructure" "0.13.1"
                "0wc9f002ia2zqcbj0q2id5x6n7g1zjqba7qkg2mr0qvvmdk7dby8"))

(define rust-synstructure-0.13.2
  (crate-source "synstructure" "0.13.2"
                "1lh9lx3r3jb18f8sbj29am5hm9jymvbwh6jb1izsnnxgvgrp12kj"))

(define rust-sys-locale-0.3.2
  (crate-source "sys-locale" "0.3.2"
                "1i16hq9mkwpzqvixjfy1ph4i2q5klgagjg4hibz6k894l2crmawf"))

(define rust-system-configuration-0.6.1
  (crate-source "system-configuration" "0.6.1"
                "0sxslml567zm0v8g732314vd2gk9sd3k4xj22xk6p64xir29v1rw"))

(define rust-system-configuration-sys-0.6.0
  ;; TODO: Check bundled sources.
  (crate-source "system-configuration-sys" "0.6.0"
                "1i5sqrmgy58l4704hibjbl36hclddglh73fb3wx95jnmrq81n7cf"))

(define rust-tempfile-3.19.1
  (crate-source "tempfile" "3.19.1"
                "1grmcj8y6rcavndw2dm18ndzdimsq5f8lcrwyg627cdrcdvsqdvl"))

(define rust-tempfile-3.21.0
  (crate-source "tempfile" "3.21.0"
                "07kx58ibjk3ydq1gcb7q637fs5zkxaa550lxckhgg9p3427izdhm"))

(define rust-tempfile-3.22.0
  (crate-source "tempfile" "3.22.0"
                "0lza9r7dzm4k9fghw24yql6iz59wq8xgs46a7i29ir6xz88lvyl4"))

(define rust-tempfile-3.23.0
  (crate-source "tempfile" "3.23.0"
                "05igl2gml6z6i2va1bv49f9f1wb3f752c2i63lvlb9s2vxxwfc9d"))

(define rust-term-0.7.0
  (crate-source "term" "0.7.0"
                "07xzxmg7dbhlirpyfq09v7cfb9gxn0077sqqvszgjvyrjnngi7f5"))

(define rust-termcolor-1.4.1
  (crate-source "termcolor" "1.4.1"
                "0mappjh3fj3p2nmrg4y7qv94rchwi9mzmgmfflr8p2awdj7lyy86"))

(define rust-terminal-size-0.4.2
  (crate-source "terminal_size" "0.4.2"
                "1vdm5xhzn7sqcsr762vmnavkhid3hs8w8qjyh9iwrr1990f4iij5"))

(define rust-terminal-size-0.4.3
  (crate-source "terminal_size" "0.4.3"
                "1l7cicmz49c0cyskfp5a389rsai649xi7y032v73475ikjbwpf30"))

(define rust-termsize-0.1.9
  (crate-source "termsize" "0.1.9"
                "1zb80dcqngbvw1mgkdsagwx6hvcsxr1zpql5bf6n0wn14mfgy4bg"))

(define rust-termtree-0.5.1
  (crate-source "termtree" "0.5.1"
                "10s610ax6nb70yi7xfmwcb6d3wi9sj5isd0m63gy2pizr2zgwl4g"))

(define rust-test-log-0.2.18
  (crate-source "test-log" "0.2.18"
                "0yxywma018rfr4mb409b1yz4ppg8ir9rg87bd08vx81fb25bjcqy"))

(define rust-test-log-macros-0.2.18
  (crate-source "test-log-macros" "0.2.18"
                "0djzwzwqnalwf00r81lv0yv71s4sqwmx7y7fn40pc3ck552kf6s5"))

(define rust-text-size-1.1.1
  (crate-source "text-size" "1.1.1"
                "0cwjbkl7w3xc8mnkhg1nwij6p5y2qkcfldgss8ddnawvhf3s32pi"))

(define rust-textwrap-0.11.0
  (crate-source "textwrap" "0.11.0"
                "0q5hky03ik3y50s9sz25r438bc4nwhqc6dqwynv4wylc807n29nk"))

(define rust-textwrap-0.16.2
  (crate-source "textwrap" "0.16.2"
                "0mrhd8q0dnh5hwbwhiv89c6i41yzmhw4clwa592rrp24b9hlfdf1"))

(define rust-thiserror-1.0.69
  (crate-source "thiserror" "1.0.69"
                "0lizjay08agcr5hs9yfzzj6axs53a2rgx070a1dsi3jpkcrzbamn"))

(define rust-thiserror-2.0.12
  (crate-source "thiserror" "2.0.12"
                "024791nsc0np63g2pq30cjf9acj38z3jwx9apvvi8qsqmqnqlysn"))

(define rust-thiserror-2.0.16
  (crate-source "thiserror" "2.0.16"
                "1h30bqyjn5s9ypm668yd9849371rzwk185klwgjg503k2hadcrrl"))

(define rust-thiserror-2.0.17
  (crate-source "thiserror" "2.0.17"
                "1j2gixhm2c3s6g96vd0b01v0i0qz1101vfmw0032mdqj1z58fdgn"))

(define rust-thiserror-impl-1.0.69
  (crate-source "thiserror-impl" "1.0.69"
                "1h84fmn2nai41cxbhk6pqf46bxqq1b344v8yz089w1chzi76rvjg"))

(define rust-thiserror-impl-2.0.12
  (crate-source "thiserror-impl" "2.0.12"
                "07bsn7shydaidvyyrm7jz29vp78vrxr9cr9044rfmn078lmz8z3z"))

(define rust-thiserror-impl-2.0.16
  (crate-source "thiserror-impl" "2.0.16"
                "0q3r1ipr1rhff6cgrcvc0njffw17rpcqz9hdc7p754cbqkhinpkc"))

(define rust-thiserror-impl-2.0.17
  (crate-source "thiserror-impl" "2.0.17"
                "04y92yjwg1a4piwk9nayzjfs07sps8c4vq9jnsfq9qvxrn75rw9z"))

(define rust-thread-local-1.1.7
  (crate-source "thread_local" "1.1.7"
                "0lp19jdgvp5m4l60cgxdnl00yw1hlqy8gcywg9bddwng9h36zp9z"))

(define rust-thread-local-1.1.9
  (crate-source "thread_local" "1.1.9"
                "1191jvl8d63agnq06pcnarivf63qzgpws5xa33hgc92gjjj4c0pn"))

(define rust-threadpool-1.8.1
  (crate-source "threadpool" "1.8.1"
                "1amgfyzvynbm8pacniivzq9r0fh3chhs7kijic81j76l6c5ycl6h"))

(define rust-tiff-0.10.3
  (crate-source "tiff" "0.10.3"
                "0vrkdk9cdk07rh7iifcxpn6m8zv3wz695mizhr8rb3gfgzg0b5mg"))

(define rust-tiktoken-rs-0.7.0
  (crate-source "tiktoken-rs" "0.7.0"
                "09aniql43g63nsh89zr0rnx4fmcszrqb7s17ynn71mq4m7mkwmi5"))

(define rust-time-0.3.42
  (crate-source "time" "0.3.42"
                "1qz8x3xsy90w6k5f8mspsjn82gnhh5yldvc6il2vi3lxkwvngacc"))

(define rust-time-0.3.44
  (crate-source "time" "0.3.44"
                "179awlwb36zly3nmz5h9awai1h4pbf1d83g2pmvlw4v1pgixkrwi"))

(define rust-time-core-0.1.5
  (crate-source "time-core" "0.1.5"
                "0s0asjj3mz5ahpymx7wbqsns852aliays3cm9ck0f6w6h2rqn459"))

(define rust-time-core-0.1.6
  (crate-source "time-core" "0.1.6"
                "0sqwhg7n47gbffyr0zhipqcnskxgcgzz1ix8wirqs2rg3my8x1j0"))

(define rust-time-macros-0.2.23
  (crate-source "time-macros" "0.2.23"
                "0k1k1c4rrxpqsnp3j9ixv7xazhgi701xjjdkj3jlq9m78n97k0ki"))

(define rust-time-macros-0.2.24
  (crate-source "time-macros" "0.2.24"
                "1wzb6hnl35856f58cx259q7ijc4c7yis0qsnydvw5n8jbw9b1krh"))

(define rust-tiny-http-0.12.0
  (crate-source "tiny_http" "0.12.0"
                "10nw9kk2i2aq4l4csy0825qkq0l66f9mz2c1n57yg8hkckgib69q"))

(define rust-tiny-keccak-2.0.2
  (crate-source "tiny-keccak" "2.0.2"
                "0dq2x0hjffmixgyf6xv9wgsbcxkd65ld0wrfqmagji8a829kg79c"))

(define rust-tinystr-0.7.6
  (crate-source "tinystr" "0.7.6"
                "0bxqaw7z8r2kzngxlzlgvld1r6jbnwyylyvyjbv1q71rvgaga5wi"))

(define rust-tinystr-0.8.1
  (crate-source "tinystr" "0.8.1"
                "12sc6h3hnn6x78iycm5v6wrs2xhxph0ydm43yyn7gdfw8l8nsksx"))

(define rust-tinytemplate-1.2.1
  (crate-source "tinytemplate" "1.2.1"
                "1g5n77cqkdh9hy75zdb01adxn45mkh9y40wdr7l68xpz35gnnkdy"))

(define rust-tinyvec-1.10.0
  (crate-source "tinyvec" "1.10.0"
                "1yhk0qdqyiaa4v2j9h8pzax5gxgwpz4da0lcphfil6g6pk1zv9dz"))

(define rust-tinyvec-1.6.0
  (crate-source "tinyvec" "1.6.0"
                "0l6bl2h62a5m44jdnpn7lmj14rd44via8180i7121fvm73mmrk47"))

(define rust-tinyvec-macros-0.1.1
  (crate-source "tinyvec_macros" "0.1.1"
                "081gag86208sc3y6sdkshgw3vysm5d34p431dzw0bshz66ncng0z"))

(define rust-titlecase-3.6.0
  (crate-source "titlecase" "3.6.0"
                "0h4xcxck5pvq6czki6idxdfhvqawpvi4k08caa9b8n8xm6470mpb"))

(define rust-tokio-1.47.1
  (crate-source "tokio" "1.47.1"
                "0f2hp5v3payg6x04ijj67si1wsdhksskhmjs2k9p5f7bmpyrmr49"))

(define rust-tokio-macros-2.5.0
  (crate-source "tokio-macros" "2.5.0"
                "1f6az2xbvqp7am417b78d1za8axbvjvxnmkakz9vr8s52czx81kf"))

(define rust-tokio-native-tls-0.3.1
  (crate-source "tokio-native-tls" "0.3.1"
                "1wkfg6zn85zckmv4im7mv20ca6b1vmlib5xwz9p7g19wjfmpdbmv"))

(define rust-tokio-rustls-0.26.2
  (crate-source "tokio-rustls" "0.26.2"
                "16wf007q3584j46wc4s0zc4szj6280g23hka6x6bgs50l4v7nwlf"))

(define rust-tokio-rustls-0.26.4
  (crate-source "tokio-rustls" "0.26.4"
                "0qggwknz9w4bbsv1z158hlnpkm97j3w8v31586jipn99byaala8p"))

(define rust-tokio-stream-0.1.17
  (crate-source "tokio-stream" "0.1.17"
                "0ix0770hfp4x5rh5bl7vsnr3d4iz4ms43i522xw70xaap9xqv9gc"))

(define rust-tokio-test-0.4.4
  (crate-source "tokio-test" "0.4.4"
                "1xzri2m3dg8nzdyznm77nymvil9cyh1gfdfrbnska51iqfmvls14"))

(define rust-tokio-util-0.7.16
  (crate-source "tokio-util" "0.7.16"
                "1r9wdrg1k5hna3m0kc8kcb8jdb6n52g7vnw93kw2xxw4cyc7qc0l"))

(define rust-toml-0.5.11
  (crate-source "toml" "0.5.11"
                "0d2266nx8b3n22c7k24x4428z6di8n83a9n466jm7a2hipfz1xzl"))

(define rust-toml-0.9.2
  (crate-source "toml" "0.9.2"
                "1b0fcp0la720p82vcsv3lrkdgsz1lmhv02rfj2bi19rgq6bfw2pd"))

(define rust-toml-0.9.5
  (crate-source "toml" "0.9.5"
                "1s7n4l40hvpf46jmgidfknnzpyblz4hip7gfkymgn2q0qlfrw4km"))

(define rust-toml-0.9.7
  (crate-source "toml" "0.9.7"
                "187av4nsjc0cdfixpc24sqpxqwy5ijvdm7hd9yfsqx94pzcybr80"))

(define rust-toml-0.9.8
  (crate-source "toml" "0.9.8"
                "1n569s0dgdmqjy21wf85df7kx3vb1zgin3pc2rvy4j8lnqgqpp7h"))

(define rust-toml-datetime-0.6.11
  (crate-source "toml_datetime" "0.6.11"
                "077ix2hb1dcya49hmi1avalwbixmrs75zgzb3b2i7g2gizwdmk92"))

(define rust-toml-datetime-0.7.0
  (crate-source "toml_datetime" "0.7.0"
                "1qwivxqkjxxwcqsvfhxnphpwphci0grdfk197wyxfn1gj0z1rpms"))

(define rust-toml-datetime-0.7.2
  (crate-source "toml_datetime" "0.7.2"
                "1hgff8gdk9yx7dljkqfijmj0sc5ln4xhpj045divdhi7xifhiw9j"))

(define rust-toml-datetime-0.7.3
  (crate-source "toml_datetime" "0.7.3"
                "0cs5f8y4rdsmmwipjclmq97lrwppjy2qa3vja4f9d5xwxcwvdkgj"))

(define rust-toml-edit-0.22.27
  (crate-source "toml_edit" "0.22.27"
                "16l15xm40404asih8vyjvnka9g0xs9i4hfb6ry3ph9g419k8rzj1"))

(define rust-toml-edit-0.23.4
  (crate-source "toml_edit" "0.23.4"
                "14yfvnljknmh8bp0n2szl8fbxslnwgzsjz9vcvhxlfhdiwdzy4bj"))

(define rust-toml-edit-0.23.7
  (crate-source "toml_edit" "0.23.7"
                "13cgp4y6prad1lh18bbg64zkq48hafq7xzs4fb0hwpcv1mnyz1b4"))

(define rust-toml-parser-1.0.1
  (crate-source "toml_parser" "1.0.1"
                "0c6a77v4i8zll5dbpyr306iq02msjsr1fhd12b2p97h6vdr0a84p"))

(define rust-toml-parser-1.0.2
  (crate-source "toml_parser" "1.0.2"
                "042wp5ni22yqcbrfqq9c63g2vbbp4m59zamxw97hvacs8ipqhldm"))

(define rust-toml-parser-1.0.3
  (crate-source "toml_parser" "1.0.3"
                "09x6i0b57lwc7yn6w1kbd2ypm4vpcrgd2vdax7h745g77g1r7y2c"))

(define rust-toml-parser-1.0.4
  (crate-source "toml_parser" "1.0.4"
                "03l0750d1cyliij9vac4afpp1syh1a6yhbbalnslpnsvsdlf5jy0"))

(define rust-toml-writer-1.0.2
  (crate-source "toml_writer" "1.0.2"
                "0r7x3m050c66s9lssaq965vmrsxvxj131db4fq0m5vrd3w4l5j7w"))

(define rust-toml-writer-1.0.3
  (crate-source "toml_writer" "1.0.3"
                "0281l7bgchmlbvxmci01p9x2w5br9p61ylns5ji65rbc24yacqyi"))

(define rust-toml-writer-1.0.4
  (crate-source "toml_writer" "1.0.4"
                "1wkvcdy1ymp2qfipmb74fv3xa7m7qz7ps9hndllasx1nfda2p2yz"))

(define rust-tonic-0.13.1
  (crate-source "tonic" "0.13.1"
                "1acvnjzh61y0m829mijj6z2nzqnwshdsnmbcl2g4spw3bahinn3y"))

(define rust-tower-0.5.2
  (crate-source "tower" "0.5.2"
                "1ybmd59nm4abl9bsvy6rx31m4zvzp5rja2slzpn712y9b68ssffh"))

(define rust-tower-http-0.6.6
  (crate-source "tower-http" "0.6.6"
                "1wh51y4rf03f91c6rvli6nwzsarx7097yx6sqlm75ag27pbjzj5d"))

(define rust-tower-layer-0.3.3
  (crate-source "tower-layer" "0.3.3"
                "03kq92fdzxin51w8iqix06dcfgydyvx7yr6izjq0p626v9n2l70j"))

(define rust-tower-lsp-f-0.24.0
  (crate-source "tower-lsp-f" "0.24.0"
                "0ny4scgd85qhvcn2psl9qilndsjgiqm9z6jv4iya5v9z09s97qcc"))

(define rust-tower-service-0.3.3
  (crate-source "tower-service" "0.3.3"
                "1hzfkvkci33ra94xjx64vv3pp0sq346w06fpkcdwjcid7zhvdycd"))

(define rust-tracing-0.1.41
  (crate-source "tracing" "0.1.41"
                "1l5xrzyjfyayrwhvhldfnwdyligi1mpqm8mzbi2m1d6y6p2hlkkq"))

(define rust-tracing-appender-0.2.3
  (crate-source "tracing-appender" "0.2.3"
                "1kq69qyjvb4dxch5c9zgii6cqhy9nkk81z0r4pj3y2nc537fhrim"))

(define rust-tracing-attributes-0.1.30
  (crate-source "tracing-attributes" "0.1.30"
                "00v9bhfgfg3v101nmmy7s3vdwadb7ngc8c1iw6wai9vj9sv3lf41"))

(define rust-tracing-core-0.1.34
  (crate-source "tracing-core" "0.1.34"
                "0y3nc4mpnr79rzkrcylv5f5bnjjp19lsxwis9l4kzs97ya0jbldr"))

(define rust-tracing-error-0.2.1
  (crate-source "tracing-error" "0.2.1"
                "1nzk6qcvhmxxy3lw1nj71anmfmvxlnk78l5lym1389vs1l1825cb"))

(define rust-tracing-log-0.2.0
  (crate-source "tracing-log" "0.2.0"
                "1hs77z026k730ij1a9dhahzrl0s073gfa2hm5p0fbl0b80gmz1gf"))

(define rust-tracing-subscriber-0.3.20
  (crate-source "tracing-subscriber" "0.3.20"
                "1m9447bxq7236avgl6n5yb2aqwplrghm61dgipw03mh7ad7s2m10"))

(define rust-tracing-test-0.2.5
  (crate-source "tracing-test" "0.2.5"
                "0s0x076wpga7k1a3cl8da76rrgvs45zzq9rl6q75w3gy6qa8jysm"))

(define rust-tracing-test-macro-0.2.5
  (crate-source "tracing-test-macro" "0.2.5"
                "0s3m7a3pycn8r4xyql5gv5b85sdrqp4w24k1aqy26zf80vdrsr84"))

(define rust-tree-sitter-0.25.10
  (crate-source "tree-sitter" "0.25.10"
                "11yclfj8884c2imv4z4pv4jd2zla629msn8wdyq63195bm3p7y3q"))

(define rust-tree-sitter-0.25.9
  (crate-source "tree-sitter" "0.25.9"
                "1yilgbnyawwicdsap4p8s279rvzg448cwz3gz45wxzkcm1ca1lnc"))

(define rust-tree-sitter-bash-0.25.0
  (crate-source "tree-sitter-bash" "0.25.0"
                "19nqdv5x8rcq74mx2h9ivjzsxq2nf06ipp7b6w98msb7wq30c6w7"))

(define rust-tree-sitter-cmake-0.7.1
  (crate-source "tree-sitter-cmake" "0.7.1"
                "16jh11mbnknjx7aqkf95j5zfq5drfpwv0sw27r5x55kkvp8ka6vw"))

(define rust-tree-sitter-highlight-0.25.10
  (crate-source "tree-sitter-highlight" "0.25.10"
                "1wvg02kgbm0y9184ql1vbsvsiwac09bka75qikl993wdmn0giidd"))

(define rust-tree-sitter-language-0.1.5
  (crate-source "tree-sitter-language" "0.1.5"
                "1f14p8i09yrfsf9708jmayy0km78n9pqzxmf31xzd0vk45q3j0f4"))

(define rust-treesitter-kind-collector-0.2.0
  (crate-source "treesitter_kind_collector" "0.2.0"
                "19pzf7lybm9m6vzlry67fs8xkzv6hhff370mf7ffl2pkinxgb1pz"))

(define rust-try-lock-0.2.5
  (crate-source "try-lock" "0.2.5"
                "0jqijrrvm1pyq34zn1jmy2vihd4jcrjlvsh4alkjahhssjnsn8g4"))

(define rust-ts-rs-11.0.1
  (crate-source "ts-rs" "11.0.1"
                "1gk82pp8b3zg7vxd9pmwhwvr123hxcksj7wfxlkl38qlv6kbgwbf"))

(define rust-ts-rs-macros-11.0.1
  (crate-source "ts-rs-macros" "11.0.1"
                "02iaa2l9k5cz25paz0874a8qfs7sxjhrw7had851bk0q9ixyvm79"))

(define rust-ttf-parser-0.25.1
  (crate-source "ttf-parser" "0.25.1"
                "0cbgqglcwwjg3hirwq6xlza54w04mb5x02kf7zx4hrw50xmr1pyj"))

(define rust-type-map-0.5.1
  (crate-source "type-map" "0.5.1"
                "143v32wwgpymxfy4y8s694vyq0wdi7li4s5dmms5w59nj2yxnc6b"))

(define rust-typenum-1.18.0
  (crate-source "typenum" "1.18.0"
                "0gwgz8n91pv40gabrr1lzji0b0hsmg0817njpy397bq7rvizzk0x"))

(define rust-typenum-1.19.0
  (crate-source "typenum" "1.19.0"
                "1fw2mpbn2vmqan56j1b3fbpcdg80mz26fm53fs16bq5xcq84hban"))

(define rust-uds-windows-1.1.0
  (crate-source "uds_windows" "1.1.0"
                "1fb4y65pw0rsp0gyfyinjazlzxz1f6zv7j4zmb20l5pxwv1ypnl9"))

(define rust-uname-0.1.1
  (crate-source "uname" "0.1.1"
                "1j1xd1rryml4j1hf07kahva9d5ym8m9jz9z20hfdpr1jrbq8jbxp"))

(define rust-unic-langid-0.9.6
  (crate-source "unic-langid" "0.9.6"
                "01bx59sqsx2jz4z7ppxq9kldcjq9dzadkmb2dr7iyc85kcnab2x2"))

(define rust-unic-langid-impl-0.9.6
  (crate-source "unic-langid-impl" "0.9.6"
                "0n66kdan4cz99n8ra18i27f7w136hmppi4wc0aa7ljsd0h4bzqfw"))

(define rust-unicase-2.8.1
  (crate-source "unicase" "2.8.1"
                "0fd5ddbhpva7wrln2iah054ar2pc1drqjcll0f493vj3fv8l9f3m"))

(define rust-unicode-bom-2.0.3
  (crate-source "unicode-bom" "2.0.3"
                "05s2sqyjanqrbds3fxam35f92npp5ci2wz9zg7v690r0448mvv3y"))

(define rust-unicode-case-mapping-0.4.0
  (crate-source "unicode-case-mapping" "0.4.0"
                "17rrnk7vbk995qdcm0jdj0hhslrvx59s7bzx41i5pg7zc8f3jsli"))

(define rust-unicode-ident-1.0.12
  (crate-source "unicode-ident" "1.0.12"
                "0jzf1znfpb2gx8nr8mvmyqs1crnv79l57nxnbiszc7xf7ynbjm1k"))

(define rust-unicode-ident-1.0.18
  (crate-source "unicode-ident" "1.0.18"
                "04k5r6sijkafzljykdq26mhjpmhdx4jwzvn1lh90g9ax9903jpss"))

(define rust-unicode-ident-1.0.19
  (crate-source "unicode-ident" "1.0.19"
                "17bx1j1zf6b9j3kpyf74mraary7ava3984km0n8kh499h5a58fpn"))

(define rust-unicode-linebreak-0.1.5
  (crate-source "unicode-linebreak" "0.1.5"
                "07spj2hh3daajg335m4wdav6nfkl0f6c0q72lc37blr97hych29v"))

(define rust-unicode-normalization-0.1.24
  (crate-source "unicode-normalization" "0.1.24"
                "0mnrk809z3ix1wspcqy97ld5wxdb31f3xz6nsvg5qcv289ycjcsh"))

(define rust-unicode-segmentation-1.10.1
  (crate-source "unicode-segmentation" "1.10.1"
                "0dky2hm5k51xy11hc3nk85p533rvghd462b6i0c532b7hl4j9mhx"))

(define rust-unicode-segmentation-1.12.0
  (crate-source "unicode-segmentation" "1.12.0"
                "14qla2jfx74yyb9ds3d2mpwpa4l4lzb9z57c6d2ba511458z5k7n"))

(define rust-unicode-truncate-1.1.0
  (crate-source "unicode-truncate" "1.1.0"
                "1gr7arjjhrhy8dww7hj8qqlws97xf9d276svr4hs6pxgllklcr5k"))

(define rust-unicode-width-0.1.14
  (crate-source "unicode-width" "0.1.14"
                "1bzn2zv0gp8xxbxbhifw778a7fc93pa6a1kj24jgg9msj07f7mkx"))

(define rust-unicode-width-0.2.1
  (crate-source "unicode-width" "0.2.1"
                "0k0mlq7xy1y1kq6cgv1r2rs2knn6rln3g3af50rhi0dkgp60f6ja"))

(define rust-unicode-xid-0.2.6
  (crate-source "unicode-xid" "0.2.6"
                "0lzqaky89fq0bcrh6jj6bhlz37scfd8c7dsj5dq7y32if56c1hgb"))

(define rust-unidecode-0.3.0
  (crate-source "unidecode" "0.3.0"
                "1p0sm8j9223kw3iincv60s746s88k09xcaqf8nkx3w83isfv2as0"))

(define rust-untrusted-0.9.0
  (crate-source "untrusted" "0.9.0"
                "1ha7ib98vkc538x0z60gfn0fc5whqdd85mb87dvisdcaifi6vjwf"))

(define rust-ureq-2.12.1
  (crate-source "ureq" "2.12.1"
                "07f0qdn6459k4rmdnkivkz0y7j28vxh5c8q8sr0gcxgdfxiadl82"))

(define rust-url-2.5.4
  (crate-source "url" "2.5.4"
                "0q6sgznyy2n4l5lm16zahkisvc9nip9aa5q1pps7656xra3bdy1j"))

(define rust-url-2.5.7
  (crate-source "url" "2.5.7"
                "0nzghdv0kcksyvri0npxbjzyx2ihprks5k590y77bld355m17g08"))

(define rust-urlencoding-2.1.3
  (crate-source "urlencoding" "2.1.3"
                "1nj99jp37k47n0hvaz5fvz7z6jd0sb4ppvfy3nphr1zbnyixpy6s"))

(define rust-utf16-iter-1.0.5
  (crate-source "utf16_iter" "1.0.5"
                "0ik2krdr73hfgsdzw0218fn35fa09dg2hvbi1xp3bmdfrp9js8y8"))

(define rust-utf8-iter-1.0.4
  (crate-source "utf8_iter" "1.0.4"
                "1gmna9flnj8dbyd8ba17zigrp9c4c3zclngf5lnb5yvz1ri41hdn"))

(define rust-utf8parse-0.2.1
  (crate-source "utf8parse" "0.2.1"
                "02ip1a0az0qmc2786vxk2nqwsgcwf17d3a38fkf0q7hrmwh9c6vi"))

(define rust-utf8parse-0.2.2
  (crate-source "utf8parse" "0.2.2"
                "088807qwjq46azicqwbhlmzwrbkz7l4hpw43sdkdyyk524vdxaq6"))

(define rust-uuid-1.18.1
  (crate-source "uuid" "1.18.1"
                "18kh01qmfayn4psap52x8xdjkzw2q8bcbpnhhxjs05dr22mbi1rg"))

(define rust-valuable-0.1.1
  (crate-source "valuable" "0.1.1"
                "0r9srp55v7g27s5bg7a2m095fzckrcdca5maih6dy9bay6fflwxs"))

(define rust-vcpkg-0.2.15
  (crate-source "vcpkg" "0.2.15"
                "09i4nf5y8lig6xgj3f7fyrvzd3nlaw4znrihw8psidvv5yk4xkdc"))

(define rust-version-check-0.9.5
  (crate-source "version_check" "0.9.5"
                "0nhhi4i5x89gm911azqbn7avs9mdacw2i3vcz3cnmz3mv4rqz4hb"))

(define rust-versions-6.3.2
  (crate-source "versions" "6.3.2"
                "0ff12avdiqhiv6nanikkjl1x3s2y7amkj3r5nivb7zficf5ljpgj"))

(define rust-vt100-0.16.2
  (crate-source "vt100" "0.16.2"
                "1nbgsgamgibyx6y4xiyk6nkz7zggzbs6s445wq4yd0zsp1gzfkq5"))

(define rust-vte-0.15.0
  (crate-source "vte" "0.15.0"
                "1g9xgnw7q7zdwgfqa6zfcfsp92wn0j0h13kzsqy0dq3c80c414m5"))

(define rust-wait-timeout-0.2.1
  (crate-source "wait-timeout" "0.2.1"
                "04azqv9mnfxgvnc8j2wp362xraybakh2dy1nj22gj51rdl93pb09"))

(define rust-walkdir-2.4.0
  (crate-source "walkdir" "2.4.0"
                "1vjl9fmfc4v8k9ald23qrpcbyb8dl1ynyq8d516cm537r1yqa7fp"))

(define rust-walkdir-2.5.0
  (crate-source "walkdir" "2.5.0"
                "0jsy7a710qv8gld5957ybrnc07gavppp963gs32xk4ag8130jy99"))

(define rust-want-0.3.1
  (crate-source "want" "0.3.1"
                "03hbfrnvqqdchb5kgxyavb9jabwza0dmh2vw5kg0dq8rxl57d9xz"))

(define rust-wasi-0.11.0+wasi-snapshot-preview1
  (crate-source "wasi" "0.11.0+wasi-snapshot-preview1"
                "08z4hxwkpdpalxjps1ai9y7ihin26y9f476i53dv98v45gkqg3cw"))

(define rust-wasi-0.11.1+wasi-snapshot-preview1
  (crate-source "wasi" "0.11.1+wasi-snapshot-preview1"
                "0jx49r7nbkbhyfrfyhz0bm4817yrnxgd3jiwwwfv0zl439jyrwyc"))

(define rust-wasi-0.14.2+wasi-0.2.4
  (crate-source "wasi" "0.14.2+wasi-0.2.4"
                "1cwcqjr3dgdq8j325awgk8a715h0hg0f7jqzsb077n4qm6jzk0wn"))

(define rust-wasi-0.14.3+wasi-0.2.4
  (crate-source "wasi" "0.14.3+wasi-0.2.4"
                "158c0cy561zlncw71hjh1pficw60p1nj7ki8kqm2gpbv0f1swlba"))

(define rust-wasi-0.14.7+wasi-0.2.4
  (crate-source "wasi" "0.14.7+wasi-0.2.4"
                "133fq3mq7h65mzrsphcm7bbbx1gsz7srrbwh01624zin43g7hd48"))

(define rust-wasip2-1.0.1+wasi-0.2.4
  (crate-source "wasip2" "1.0.1+wasi-0.2.4"
                "1rsqmpspwy0zja82xx7kbkbg9fv34a4a2if3sbd76dy64a244qh5"))

(define rust-wasm-bindgen-0.2.100
  (crate-source "wasm-bindgen" "0.2.100"
                "1x8ymcm6yi3i1rwj78myl1agqv2m86i648myy3lc97s9swlqkp0y"))

(define rust-wasm-bindgen-0.2.104
  (crate-source "wasm-bindgen" "0.2.104"
                "0b8f4l6pqm0bz0lj5xgwmchb6977n71vmh7srd0axwg93b011nn1"))

(define rust-wasm-bindgen-0.2.92
  (crate-source "wasm-bindgen" "0.2.92"
                "1a4mcw13nsk3fr8fxjzf9kk1wj88xkfsmnm0pjraw01ryqfm7qjb"))

(define rust-wasm-bindgen-backend-0.2.100
  (crate-source "wasm-bindgen-backend" "0.2.100"
                "1ihbf1hq3y81c4md9lyh6lcwbx6a5j0fw4fygd423g62lm8hc2ig"))

(define rust-wasm-bindgen-backend-0.2.104
  (crate-source "wasm-bindgen-backend" "0.2.104"
                "069vnhhn2j4w2gwd8rch6g8d3iwkrgi45fas6i3qm7glcrd9l737"))

(define rust-wasm-bindgen-backend-0.2.92
  (crate-source "wasm-bindgen-backend" "0.2.92"
                "1nj7wxbi49f0rw9d44rjzms26xlw6r76b2mrggx8jfbdjrxphkb1"))

(define rust-wasm-bindgen-futures-0.4.50
  (crate-source "wasm-bindgen-futures" "0.4.50"
                "0q8ymi6i9r3vxly551dhxcyai7nc491mspj0j1wbafxwq074fpam"))

(define rust-wasm-bindgen-futures-0.4.54
  (crate-source "wasm-bindgen-futures" "0.4.54"
                "0p5c10vfd7p7c607x3cgyfw9h77z1k33d6zzw2x77k3qwi0qs0vy"))

(define rust-wasm-bindgen-macro-0.2.100
  (crate-source "wasm-bindgen-macro" "0.2.100"
                "01xls2dvzh38yj17jgrbiib1d3nyad7k2yw9s0mpklwys333zrkz"))

(define rust-wasm-bindgen-macro-0.2.104
  (crate-source "wasm-bindgen-macro" "0.2.104"
                "06d1m5bg272h6jabq0snm7c50fifjz6r20f5hqlmz7y5wivh99kw"))

(define rust-wasm-bindgen-macro-0.2.92
  (crate-source "wasm-bindgen-macro" "0.2.92"
                "09npa1srjjabd6nfph5yc03jb26sycjlxhy0c2a1pdrpx4yq5y51"))

(define rust-wasm-bindgen-macro-support-0.2.100
  (crate-source "wasm-bindgen-macro-support" "0.2.100"
                "1plm8dh20jg2id0320pbmrlsv6cazfv6b6907z19ys4z1jj7xs4a"))

(define rust-wasm-bindgen-macro-support-0.2.104
  (crate-source "wasm-bindgen-macro-support" "0.2.104"
                "1mr18kx7ima1pmsqlkk982q4a0vf3r8s1x6901jb59sd1prd41wz"))

(define rust-wasm-bindgen-macro-support-0.2.92
  (crate-source "wasm-bindgen-macro-support" "0.2.92"
                "1dqv2xs8zcyw4kjgzj84bknp2h76phmsb3n7j6hn396h4ssifkz9"))

(define rust-wasm-bindgen-shared-0.2.100
  (crate-source "wasm-bindgen-shared" "0.2.100"
                "0gffxvqgbh9r9xl36gprkfnh3w9gl8wgia6xrin7v11sjcxxf18s"))

(define rust-wasm-bindgen-shared-0.2.104
  (crate-source "wasm-bindgen-shared" "0.2.104"
                "1la1xj9v3gmawnlyi7lc3mb3xi447r6frb98hi2fb9m1nb47vmms"))

(define rust-wasm-bindgen-shared-0.2.92
  (crate-source "wasm-bindgen-shared" "0.2.92"
                "15kyavsrna2cvy30kg03va257fraf9x00ny554vxngvpyaa0q6dg"))

(define rust-wasm-streams-0.4.2
  (crate-source "wasm-streams" "0.4.2"
                "0rddn007hp6k2cm91mm9y33n79b0jxv0c3znzszcvv67hn6ks18m"))

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

(define rust-web-sys-0.3.64
  ;; TODO: Check bundled sources.
  (crate-source "web-sys" "0.3.64"
                "16r4fww3l99kxhb66hka3kxkmhhgzhnqkzdf0ay6l2i2ikpwp1cv"))

(define rust-web-sys-0.3.77
  ;; TODO: Check bundled sources.
  (crate-source "web-sys" "0.3.77"
                "1lnmc1ffbq34qw91nndklqqm75rasaffj2g4f8h1yvqqz4pdvdik"))

(define rust-web-sys-0.3.81
  ;; TODO: Check bundled sources.
  (crate-source "web-sys" "0.3.81"
                "0871ifd79ni9813sp5amk7wb3avznkijlsly2ap4r9r4m4bw8rwk"))

(define rust-web-time-1.1.0
  (crate-source "web-time" "1.1.0"
                "1fx05yqx83dhx628wb70fyy10yjfq1jpl20qfqhdkymi13rq0ras"))

(define rust-webbrowser-1.0.5
  (crate-source "webbrowser" "1.0.5"
                "166yrfz20a5qzxq881acw973537v0dq1bi6cwns853l3pb0g7x5a"))

(define rust-webpki-roots-1.0.2
  (crate-source "webpki-roots" "1.0.2"
                "1ck1wa1prinrvz3q34c3xp4cpa2f3i4x5npwgj0gpmikmg1q72by"))

(define rust-webpki-roots-1.0.3
  (crate-source "webpki-roots" "1.0.3"
                "1f49w0s7f3fgczvjri179wh2a9g8jpkmdi5bi5l8p7ylsb031c9j"))

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

(define rust-which-6.0.3
  (crate-source "which" "6.0.3"
                "07yg74dsq644hq5a35546c9mja6rsjdsg92rykr9hkflxf7r5vml"))

(define rust-wildmatch-2.5.0
  (crate-source "wildmatch" "2.5.0"
                "10nk5s864iczsdrxn38iypixp5mk36pwyv2k0xkfzfka4dxd1drr"))

(define rust-winapi-0.3.9
  (crate-source "winapi" "0.3.9"
                "06gl025x418lchw1wxj64ycr7gha83m44cjr5sarhynd9xkrm0sw"))

(define rust-winapi-i686-pc-windows-gnu-0.4.0
  (crate-source "winapi-i686-pc-windows-gnu" "0.4.0"
                "1dmpa6mvcvzz16zg6d5vrfy4bxgg541wxrcip7cnshi06v38ffxc"))

(define rust-winapi-util-0.1.10
  (crate-source "winapi-util" "0.1.10"
                "08hb8rj3aq9lcrfmliqs4l7v9zh6srbcn0376yn0pndkf5qvyy09"))

(define rust-winapi-util-0.1.11
  (crate-source "winapi-util" "0.1.11"
                "08hdl7mkll7pz8whg869h58c1r9y7in0w0pk8fm24qc77k0b39y2"))

(define rust-winapi-util-0.1.6
  (crate-source "winapi-util" "0.1.6"
                "15i5lm39wd44004i9d5qspry2cynkrpvwzghr6s2c3dsk28nz7pj"))

(define rust-winapi-util-0.1.9
  (crate-source "winapi-util" "0.1.9"
                "1fqhkcl9scd230cnfj8apfficpf5c9vhwnk4yy9xfc1sw69iq8ng"))

(define rust-winapi-x86-64-pc-windows-gnu-0.4.0
  (crate-source "winapi-x86_64-pc-windows-gnu" "0.4.0"
                "0gqq64czqb64kskjryj8isp62m2sgvx25yyj3kpc2myh85w24bki"))

(define rust-windows-0.58.0
  (crate-source "windows" "0.58.0"
                "1dkjj94b0gn91nn1n22cvm4afsj98f5qrhcl3112v6f4jcfx816x"))

(define rust-windows-0.61.3
  (crate-source "windows" "0.61.3"
                "14v8dln7i4ccskd8danzri22bkjkbmgzh284j3vaxhd4cykx7awv"))

(define rust-windows-aarch64-gnullvm-0.42.2
  (crate-source "windows_aarch64_gnullvm" "0.42.2"
                "1y4q0qmvl0lvp7syxvfykafvmwal5hrjb4fmv04bqs0bawc52yjr"))

(define rust-windows-aarch64-gnullvm-0.48.5
  (crate-source "windows_aarch64_gnullvm" "0.48.5"
                "1n05v7qblg1ci3i567inc7xrkmywczxrs1z3lj3rkkxw18py6f1b"))

(define rust-windows-aarch64-gnullvm-0.52.6
  (crate-source "windows_aarch64_gnullvm" "0.52.6"
                "1lrcq38cr2arvmz19v32qaggvj8bh1640mdm9c2fr877h0hn591j"))

(define rust-windows-aarch64-gnullvm-0.53.0
  (crate-source "windows_aarch64_gnullvm" "0.53.0"
                "0r77pbpbcf8bq4yfwpz2hpq3vns8m0yacpvs2i5cn6fx1pwxbf46"))

(define rust-windows-aarch64-gnullvm-0.53.1
  (crate-source "windows_aarch64_gnullvm" "0.53.1"
                "0lqvdm510mka9w26vmga7hbkmrw9glzc90l4gya5qbxlm1pl3n59"))

(define rust-windows-aarch64-msvc-0.42.2
  (crate-source "windows_aarch64_msvc" "0.42.2"
                "0hsdikjl5sa1fva5qskpwlxzpc5q9l909fpl1w6yy1hglrj8i3p0"))

(define rust-windows-aarch64-msvc-0.48.5
  (crate-source "windows_aarch64_msvc" "0.48.5"
                "1g5l4ry968p73g6bg6jgyvy9lb8fyhcs54067yzxpcpkf44k2dfw"))

(define rust-windows-aarch64-msvc-0.52.6
  (crate-source "windows_aarch64_msvc" "0.52.6"
                "0sfl0nysnz32yyfh773hpi49b1q700ah6y7sacmjbqjjn5xjmv09"))

(define rust-windows-aarch64-msvc-0.53.0
  (crate-source "windows_aarch64_msvc" "0.53.0"
                "0v766yqw51pzxxwp203yqy39ijgjamp54hhdbsyqq6x1c8gilrf7"))

(define rust-windows-aarch64-msvc-0.53.1
  (crate-source "windows_aarch64_msvc" "0.53.1"
                "01jh2adlwx043rji888b22whx4bm8alrk3khjpik5xn20kl85mxr"))

(define rust-windows-collections-0.2.0
  (crate-source "windows-collections" "0.2.0"
                "1s65anr609qvsjga7w971p6iq964h87670dkfqfypnfgwnswxviv"))

(define rust-windows-core-0.58.0
  (crate-source "windows-core" "0.58.0"
                "16czypy425jzmiys4yb3pwsh7cm6grxn9kjp889iqnf2r17d99kb"))

(define rust-windows-core-0.61.2
  (crate-source "windows-core" "0.61.2"
                "1qsa3iw14wk4ngfl7ipcvdf9xyq456ms7cx2i9iwf406p7fx7zf0"))

(define rust-windows-core-0.62.2
  (crate-source "windows-core" "0.62.2"
                "1swxpv1a8qvn3bkxv8cn663238h2jccq35ff3nsj61jdsca3ms5q"))

(define rust-windows-future-0.2.1
  (crate-source "windows-future" "0.2.1"
                "13mdzcdn51ckpzp3frb8glnmkyjr1c30ym9wnzj9zc97hkll2spw"))

(define rust-windows-i686-gnu-0.42.2
  (crate-source "windows_i686_gnu" "0.42.2"
                "0kx866dfrby88lqs9v1vgmrkk1z6af9lhaghh5maj7d4imyr47f6"))

(define rust-windows-i686-gnu-0.48.5
  (crate-source "windows_i686_gnu" "0.48.5"
                "0gklnglwd9ilqx7ac3cn8hbhkraqisd0n83jxzf9837nvvkiand7"))

(define rust-windows-i686-gnu-0.52.6
  (crate-source "windows_i686_gnu" "0.52.6"
                "02zspglbykh1jh9pi7gn8g1f97jh1rrccni9ivmrfbl0mgamm6wf"))

(define rust-windows-i686-gnu-0.53.0
  (crate-source "windows_i686_gnu" "0.53.0"
                "1hvjc8nv95sx5vdd79fivn8bpm7i517dqyf4yvsqgwrmkmjngp61"))

(define rust-windows-i686-gnu-0.53.1
  (crate-source "windows_i686_gnu" "0.53.1"
                "18wkcm82ldyg4figcsidzwbg1pqd49jpm98crfz0j7nqd6h6s3ln"))

(define rust-windows-i686-gnullvm-0.52.6
  (crate-source "windows_i686_gnullvm" "0.52.6"
                "0rpdx1537mw6slcpqa0rm3qixmsb79nbhqy5fsm3q2q9ik9m5vhf"))

(define rust-windows-i686-gnullvm-0.53.0
  (crate-source "windows_i686_gnullvm" "0.53.0"
                "04df1in2k91qyf1wzizvh560bvyzq20yf68k8xa66vdzxnywrrlw"))

(define rust-windows-i686-gnullvm-0.53.1
  (crate-source "windows_i686_gnullvm" "0.53.1"
                "030qaxqc4salz6l4immfb6sykc6gmhyir9wzn2w8mxj8038mjwzs"))

(define rust-windows-i686-msvc-0.42.2
  (crate-source "windows_i686_msvc" "0.42.2"
                "0q0h9m2aq1pygc199pa5jgc952qhcnf0zn688454i7v4xjv41n24"))

(define rust-windows-i686-msvc-0.48.5
  (crate-source "windows_i686_msvc" "0.48.5"
                "01m4rik437dl9rdf0ndnm2syh10hizvq0dajdkv2fjqcywrw4mcg"))

(define rust-windows-i686-msvc-0.52.6
  (crate-source "windows_i686_msvc" "0.52.6"
                "0rkcqmp4zzmfvrrrx01260q3xkpzi6fzi2x2pgdcdry50ny4h294"))

(define rust-windows-i686-msvc-0.53.0
  (crate-source "windows_i686_msvc" "0.53.0"
                "0pcvb25fkvqnp91z25qr5x61wyya12lx8p7nsa137cbb82ayw7sq"))

(define rust-windows-i686-msvc-0.53.1
  (crate-source "windows_i686_msvc" "0.53.1"
                "1hi6scw3mn2pbdl30ji5i4y8vvspb9b66l98kkz350pig58wfyhy"))

(define rust-windows-implement-0.58.0
  (crate-source "windows-implement" "0.58.0"
                "16spr5z65z21qyv379rv2mb1s5q2i9ibd1p2pkn0dr9qr535pg9b"))

(define rust-windows-implement-0.60.0
  (crate-source "windows-implement" "0.60.0"
                "0dm88k3hlaax85xkls4gf597ar4z8m5vzjjagzk910ph7b8xszx4"))

(define rust-windows-implement-0.60.2
  (crate-source "windows-implement" "0.60.2"
                "1psxhmklzcf3wjs4b8qb42qb6znvc142cb5pa74rsyxm1822wgh5"))

(define rust-windows-interface-0.58.0
  (crate-source "windows-interface" "0.58.0"
                "059mxmfvx3x88q74ms0qlxmj2pnidmr5mzn60hakn7f95m34qg05"))

(define rust-windows-interface-0.59.1
  (crate-source "windows-interface" "0.59.1"
                "1a4zr8740gyzzhq02xgl6vx8l669jwfby57xgf0zmkcdkyv134mx"))

(define rust-windows-interface-0.59.3
  (crate-source "windows-interface" "0.59.3"
                "0n73cwrn4247d0axrk7gjp08p34x1723483jxjxjdfkh4m56qc9z"))

(define rust-windows-link-0.1.3
  (crate-source "windows-link" "0.1.3"
                "12kr1p46dbhpijr4zbwr2spfgq8i8c5x55mvvfmyl96m01cx4sjy"))

(define rust-windows-link-0.2.0
  (crate-source "windows-link" "0.2.0"
                "0r9w2z96d5phmm185aq92z54jp9h2nqisa4wgc71idxbc436rr25"))

(define rust-windows-link-0.2.1
  (crate-source "windows-link" "0.2.1"
                "1rag186yfr3xx7piv5rg8b6im2dwcf8zldiflvb22xbzwli5507h"))

(define rust-windows-numerics-0.2.0
  (crate-source "windows-numerics" "0.2.0"
                "1cf2j8nbqf0hqqa7chnyid91wxsl2m131kn0vl3mqk3c0rlayl4i"))

(define rust-windows-registry-0.5.3
  (crate-source "windows-registry" "0.5.3"
                "17j9cxlnksdypanazss6cnh36v3rwvs86j4mpixwkvv5hz99x2jv"))

(define rust-windows-result-0.2.0
  (crate-source "windows-result" "0.2.0"
                "03mf2z1xcy2slhhsm15z24p76qxgm2m74xdjp8bihyag47c4640x"))

(define rust-windows-result-0.3.4
  (crate-source "windows-result" "0.3.4"
                "1il60l6idrc6hqsij0cal0mgva6n3w6gq4ziban8wv6c6b9jpx2n"))

(define rust-windows-result-0.4.1
  (crate-source "windows-result" "0.4.1"
                "1d9yhmrmmfqh56zlj751s5wfm9a2aa7az9rd7nn5027nxa4zm0bp"))

(define rust-windows-strings-0.1.0
  (crate-source "windows-strings" "0.1.0"
                "042dxvi3133f7dyi2pgcvknwkikk47k8bddwxbq5s0l6qhjv3nac"))

(define rust-windows-strings-0.4.2
  (crate-source "windows-strings" "0.4.2"
                "0mrv3plibkla4v5kaakc2rfksdd0b14plcmidhbkcfqc78zwkrjn"))

(define rust-windows-strings-0.5.1
  (crate-source "windows-strings" "0.5.1"
                "14bhng9jqv4fyl7lqjz3az7vzh8pw0w4am49fsqgcz67d67x0dvq"))

(define rust-windows-sys-0.45.0
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.45.0"
                "1l36bcqm4g89pknfp8r9rl1w4bn017q6a8qlx8viv0xjxzjkna3m"))

(define rust-windows-sys-0.48.0
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.48.0"
                "1aan23v5gs7gya1lc46hqn9mdh8yph3fhxmhxlw36pn6pqc28zb7"))

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

(define rust-windows-sys-0.61.0
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.61.0"
                "1ajpwsmzfcsa1r7i0dxzvfn24dp3525rcd7aq95ydvdj8171h0g2"))

(define rust-windows-sys-0.61.1
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.61.1"
                "03vg2rxm0lyiyq64b5sm95lkg2x95sjdb0zb0y4q8g2avm0rw43g"))

(define rust-windows-sys-0.61.2
  ;; TODO: Check bundled sources.
  (crate-source "windows-sys" "0.61.2"
                "1z7k3y9b6b5h52kid57lvmvm05362zv1v8w0gc7xyv5xphlp44xf"))

(define rust-windows-targets-0.42.2
  (crate-source "windows-targets" "0.42.2"
                "0wfhnib2fisxlx8c507dbmh97kgij4r6kcxdi0f9nk6l1k080lcf"))

(define rust-windows-targets-0.48.5
  (crate-source "windows-targets" "0.48.5"
                "034ljxqshifs1lan89xwpcy1hp0lhdh4b5n0d2z4fwjx2piacbws"))

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

(define rust-windows-targets-0.53.5
  (crate-source "windows-targets" "0.53.5"
                "1wv9j2gv3l6wj3gkw5j1kr6ymb5q6dfc42yvydjhv3mqa7szjia9"))

(define rust-windows-threading-0.1.0
  (crate-source "windows-threading" "0.1.0"
                "19jpn37zpjj2q7pn07dpq0ay300w65qx7wdp13wbp8qf5snn6r5n"))

(define rust-windows-x86-64-gnu-0.42.2
  (crate-source "windows_x86_64_gnu" "0.42.2"
                "0dnbf2xnp3xrvy8v9mgs3var4zq9v9yh9kv79035rdgyp2w15scd"))

(define rust-windows-x86-64-gnu-0.48.5
  (crate-source "windows_x86_64_gnu" "0.48.5"
                "13kiqqcvz2vnyxzydjh73hwgigsdr2z1xpzx313kxll34nyhmm2k"))

(define rust-windows-x86-64-gnu-0.52.6
  (crate-source "windows_x86_64_gnu" "0.52.6"
                "0y0sifqcb56a56mvn7xjgs8g43p33mfqkd8wj1yhrgxzma05qyhl"))

(define rust-windows-x86-64-gnu-0.53.0
  (crate-source "windows_x86_64_gnu" "0.53.0"
                "1flh84xkssn1n6m1riddipydcksp2pdl45vdf70jygx3ksnbam9f"))

(define rust-windows-x86-64-gnu-0.53.1
  (crate-source "windows_x86_64_gnu" "0.53.1"
                "16d4yiysmfdlsrghndr97y57gh3kljkwhfdbcs05m1jasz6l4f4w"))

(define rust-windows-x86-64-gnullvm-0.42.2
  (crate-source "windows_x86_64_gnullvm" "0.42.2"
                "18wl9r8qbsl475j39zvawlidp1bsbinliwfymr43fibdld31pm16"))

(define rust-windows-x86-64-gnullvm-0.48.5
  (crate-source "windows_x86_64_gnullvm" "0.48.5"
                "1k24810wfbgz8k48c2yknqjmiigmql6kk3knmddkv8k8g1v54yqb"))

(define rust-windows-x86-64-gnullvm-0.52.6
  (crate-source "windows_x86_64_gnullvm" "0.52.6"
                "03gda7zjx1qh8k9nnlgb7m3w3s1xkysg55hkd1wjch8pqhyv5m94"))

(define rust-windows-x86-64-gnullvm-0.53.0
  (crate-source "windows_x86_64_gnullvm" "0.53.0"
                "0mvc8119xpbi3q2m6mrjcdzl6afx4wffacp13v76g4jrs1fh6vha"))

(define rust-windows-x86-64-gnullvm-0.53.1
  (crate-source "windows_x86_64_gnullvm" "0.53.1"
                "1qbspgv4g3q0vygkg8rnql5c6z3caqv38japiynyivh75ng1gyhg"))

(define rust-windows-x86-64-msvc-0.42.2
  (crate-source "windows_x86_64_msvc" "0.42.2"
                "1w5r0q0yzx827d10dpjza2ww0j8iajqhmb54s735hhaj66imvv4s"))

(define rust-windows-x86-64-msvc-0.48.5
  (crate-source "windows_x86_64_msvc" "0.48.5"
                "0f4mdp895kkjh9zv8dxvn4pc10xr7839lf5pa9l0193i2pkgr57d"))

(define rust-windows-x86-64-msvc-0.52.6
  (crate-source "windows_x86_64_msvc" "0.52.6"
                "1v7rb5cibyzx8vak29pdrk8nx9hycsjs4w0jgms08qk49jl6v7sq"))

(define rust-windows-x86-64-msvc-0.53.0
  (crate-source "windows_x86_64_msvc" "0.53.0"
                "11h4i28hq0zlnjcaqi2xdxr7ibnpa8djfggch9rki1zzb8qi8517"))

(define rust-windows-x86-64-msvc-0.53.1
  (crate-source "windows_x86_64_msvc" "0.53.1"
                "0l6npq76vlq4ksn4bwsncpr8508mk0gmznm6wnhjg95d19gzzfyn"))

(define rust-winit-0.30.12
  (crate-source "winit" "0.30.12"
                "0cn7wvli4s0l3v5rf6s3rn4j72mdc5p2sxhz6bv0jh4wssg4nvf6"))

(define rust-winnow-0.7.12
  (crate-source "winnow" "0.7.12"
                "159y8inpy86xswmr4yig9hxss0v2fssyqy1kk12504n8jbsfpvgk"))

(define rust-winnow-0.7.13
  (crate-source "winnow" "0.7.13"
                "1krrjc1wj2vx0r57m9nwnlc1zrhga3fq41d8w9hysvvqb5mj7811"))

(define rust-winreg-0.10.1
  (crate-source "winreg" "0.10.1"
                "17c6h02z88ijjba02bnxi5k94q5cz490nf3njh9yypf8fbig9l40"))

(define rust-winsafe-0.0.19
  (crate-source "winsafe" "0.0.19"
                "0169xy9mjma8dys4m8v4x0xhw2gkbhv2v1wsbvcjl9bhnxxd2dfi"))

(define rust-wiremock-0.6.5
  (crate-source "wiremock" "0.6.5"
                "0cahz2c4lwaw8f7g5d805wlqh824fjhaw8g588akr6sxn3gixnq8"))

(define rust-wit-bindgen-0.45.0
  (crate-source "wit-bindgen" "0.45.0"
                "053q28k1hn9qgm0l05gr9751d8q34zcz6lbzviwxiqxs3n1q68h5"))

(define rust-wit-bindgen-0.46.0
  (crate-source "wit-bindgen" "0.46.0"
                "0ngysw50gp2wrrfxbwgp6dhw1g6sckknsn3wm7l00vaf7n48aypi"))

(define rust-wit-bindgen-rt-0.39.0
  (crate-source "wit-bindgen-rt" "0.39.0"
                "1hd65pa5hp0nl664m94bg554h4zlhrzmkjsf6lsgsb7yc4734hkg"))

(define rust-write16-1.0.0
  (crate-source "write16" "1.0.0"
                "0dnryvrrbrnl7vvf5vb1zkmwldhjkf2n5znliviam7bm4900z2fi"))

(define rust-writeable-0.5.5
  (crate-source "writeable" "0.5.5"
                "0lawr6y0bwqfyayf3z8zmqlhpnzhdx0ahs54isacbhyjwa7g778y"))

(define rust-writeable-0.6.1
  (crate-source "writeable" "0.6.1"
                "1fx29zncvbrqzgz7li88vzdm8zvgwgwy2r9bnjqxya09pfwi0bza"))

(define rust-x11-dl-2.21.0
  (crate-source "x11-dl" "2.21.0"
                "0vsiq62xpcfm0kn9zjw5c9iycvccxl22jya8wnk18lyxzqj5jwrq"))

(define rust-x11rb-0.13.1
  (crate-source "x11rb" "0.13.1"
                "04jyfm0xmc538v09pzsyr2w801yadsgvyl2p0p76hzzffg5gz4ax"))

(define rust-x11rb-0.13.2
  (crate-source "x11rb" "0.13.2"
                "053lvnaw9ycbl791mgwly2hw27q6vqgzrb1y5kz1as52wmdsm4wr"))

(define rust-x11rb-protocol-0.13.1
  (crate-source "x11rb-protocol" "0.13.1"
                "0gfbxf2k7kbk577j3rjhfx7hm70kmwln6da7xyc4l2za0d2pq47c"))

(define rust-x11rb-protocol-0.13.2
  (crate-source "x11rb-protocol" "0.13.2"
                "1g81cznbyn522b0fbis0i44wh3adad2vhsz5pzf99waf3sbc4vza"))

(define rust-xcursor-0.3.10
  (crate-source "xcursor" "0.3.10"
                "0awgy98awg4ydcfmynqfcwvl4bnnfcm4i2vvnk2n926a02jy9jdy"))

(define rust-xdg-home-1.3.0
  (crate-source "xdg-home" "1.3.0"
                "1xm122zz0wjc8p8cmchij0j9nw34hwncb39jc7dc0mgvb2rdl77c"))

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

(define rust-yansi-1.0.1
  (crate-source "yansi" "1.0.1"
                "0jdh55jyv0dpd38ij4qh60zglbw9aa8wafqai6m0wa7xaxk3mrfg"))

(define rust-yoke-0.7.5
  (crate-source "yoke" "0.7.5"
                "0h3znzrdmll0a7sglzf9ji0p5iqml11wrj1dypaf6ad6kbpnl3hj"))

(define rust-yoke-0.8.0
  (crate-source "yoke" "0.8.0"
                "1k4mfr48vgi7wh066y11b7v1ilakghlnlhw9snzz8vi2p00vnhaz"))

(define rust-yoke-derive-0.7.5
  (crate-source "yoke-derive" "0.7.5"
                "0m4i4a7gy826bfvnqa9wy6sp90qf0as3wps3wb0smjaamn68g013"))

(define rust-yoke-derive-0.8.0
  (crate-source "yoke-derive" "0.8.0"
                "1dha5jrjz9jaq8kmxq1aag86b98zbnm9lyjrihy5sv716sbkrniq"))

(define rust-zbus-4.4.0
  (crate-source "zbus" "4.4.0"
                "09f7916lp7haxv1y5zgcg99ny15whi6dn3waf1afcafxx8mh35xv"))

(define rust-zbus-macros-4.4.0
  (crate-source "zbus_macros" "4.4.0"
                "0glqn6ddgv4ra734p343a41rrxb0phy1v13dljzhpsc1f10bjz96"))

(define rust-zbus-names-3.0.0
  (crate-source "zbus_names" "3.0.0"
                "0v1f0ajwafj47bf11yp0xdgp26r93lslr9nb2v6624h2gppiz6sb"))

(define rust-zerocopy-0.8.26
  (crate-source "zerocopy" "0.8.26"
                "0bvsj0qzq26zc6nlrm3z10ihvjspyngs7n0jw1fz031i7h6xsf8h"))

(define rust-zerocopy-0.8.27
  (crate-source "zerocopy" "0.8.27"
                "0b1870gf2zzlckca69v2k4mqwmf8yh2li37qldnzvvd3by58g508"))

(define rust-zerocopy-derive-0.8.26
  (crate-source "zerocopy-derive" "0.8.26"
                "10aiywi5qkha0mpsnb1zjwi44wl2rhdncaf3ykbp4i9nqm65pkwy"))

(define rust-zerocopy-derive-0.8.27
  (crate-source "zerocopy-derive" "0.8.27"
                "0c9qrylm2p55dvaplxsl24ma48add9qk4y0d6kjbkllaqvcvill8"))

(define rust-zerofrom-0.1.5
  (crate-source "zerofrom" "0.1.5"
                "0bnd8vjcllzrvr3wvn8x14k2hkrpyy1fm3crkn2y3plmr44fxwyg"))

(define rust-zerofrom-0.1.6
  (crate-source "zerofrom" "0.1.6"
                "19dyky67zkjichsb7ykhv0aqws3q0jfvzww76l66c19y6gh45k2h"))

(define rust-zerofrom-derive-0.1.5
  (crate-source "zerofrom-derive" "0.1.5"
                "022q55phhb44qbrcfbc48k0b741fl8gnazw3hpmmndbx5ycfspjr"))

(define rust-zerofrom-derive-0.1.6
  (crate-source "zerofrom-derive" "0.1.6"
                "00l5niw7c1b0lf1vhvajpjmcnbdp2vn96jg4nmkhq2db0rp5s7np"))

(define rust-zeroize-1.8.1
  (crate-source "zeroize" "1.8.1"
                "1pjdrmjwmszpxfd7r860jx54cyk94qk59x13sc307cvr5256glyf"))

(define rust-zeroize-1.8.2
  (crate-source "zeroize" "1.8.2"
                "1l48zxgcv34d7kjskr610zqsm6j2b4fcr2vfh9jm9j1jgvk58wdr"))

(define rust-zeroize-derive-1.4.2
  (crate-source "zeroize_derive" "1.4.2"
                "0sczjlqjdmrp3wn62g7mw6p438c9j4jgp2f9zamd56991mdycdnf"))

(define rust-zerotrie-0.2.2
  (crate-source "zerotrie" "0.2.2"
                "15gmka7vw5k0d24s0vxgymr2j6zn2iwl12wpmpnpjgsqg3abpw1n"))

(define rust-zerovec-0.10.4
  (crate-source "zerovec" "0.10.4"
                "0yghix7n3fjfdppwghknzvx9v8cf826h2qal5nqvy8yzg4yqjaxa"))

(define rust-zerovec-0.11.2
  (crate-source "zerovec" "0.11.2"
                "0a2457fmz39k9vrrj3rm82q5ykdhgxgbwfz2r6fa6nq11q4fn1aa"))

(define rust-zerovec-0.11.4
  (crate-source "zerovec" "0.11.4"
                "0fz7j1ns8d86m2fqg2a4bzi5gnh5892bxv4kcr9apwc6a3ajpap7"))

(define rust-zerovec-derive-0.10.3
  (crate-source "zerovec-derive" "0.10.3"
                "1ik322dys6wnap5d3gcsn09azmssq466xryn5czfm13mn7gsdbvf"))

(define rust-zerovec-derive-0.11.1
  (crate-source "zerovec-derive" "0.11.1"
                "13zms8hj7vzpfswypwggyfr4ckmyc7v3di49pmj8r1qcz9z275jv"))

(define rust-zlib-rs-0.5.1
  (crate-source "zlib-rs" "0.5.1"
                "12nvshiq19nd4ksn3453ym9p0kcqf0hpaq301p2iyx9ljzxdjsv2"))

(define rust-zune-core-0.4.12
  (crate-source "zune-core" "0.4.12"
                "0jj1ra86klzlcj9aha9als9d1dzs7pqv3azs1j3n96822wn3lhiz"))

(define rust-zune-jpeg-0.4.19
  (crate-source "zune-jpeg" "0.4.19"
                "0sisqjhwi6pwlnjyr80vl5s6p5w9z2vi8pz967h5i9m6y1d557ic"))

(define rust-zune-jpeg-0.4.20
  (crate-source "zune-jpeg" "0.4.20"
                "12fhlnyr254d3hys1xkrgk5qb5sqydamy76p7kdb57p7bhh7w7zw"))

(define rust-zune-jpeg-0.4.21
  (crate-source "zune-jpeg" "0.4.21"
                "04r7g6y9jp7d4c9bq23rz3gwzlr1dsl7vdk4yly35bc4jf52rki9"))

(define rust-zvariant-4.2.0
  (crate-source "zvariant" "4.2.0"
                "1zl1ika7zd9bxkd0bqc78h9bykvk6xc98965iz1p3i51p452k110"))

(define rust-zvariant-derive-4.2.0
  (crate-source "zvariant_derive" "4.2.0"
                "0jf408h0s83krxwm7wl62fnssin1kcklmb1bcn83ls6sddabmqkk"))

(define rust-zvariant-utils-2.1.0
  (crate-source "zvariant_utils" "2.1.0"
                "0h43h3jcw8rmjr390rdqnhkb9nn3913pgkvb75am1frxrkvwy6y5"))

(define ssss-separator 'end-of-crates)


;;;
;;; Cargo inputs.
;;;

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
                     (codex =>
                            (list rust-inflector-0.11.4
                             rust-addr2line-0.24.2
                             rust-adler2-2.0.1
                             rust-aes-0.8.4
                             rust-ahash-0.8.12
                             rust-aho-corasick-1.1.3
                             rust-allocative-0.3.4
                             rust-allocative-derive-0.3.3
                             rust-allocator-api2-0.2.21
                             rust-android-system-properties-0.1.5
                             rust-annotate-snippets-0.9.2
                             rust-ansi-to-tui-7.0.0
                             rust-anstream-0.6.19
                             rust-anstyle-1.0.11
                             rust-anstyle-parse-0.2.7
                             rust-anstyle-query-1.1.3
                             rust-anstyle-wincon-3.0.9
                             rust-anyhow-1.0.99
                             rust-arboard-3.6.0
                             rust-arrayvec-0.7.6
                             rust-ascii-1.1.0
                             rust-ascii-canvas-3.0.0
                             rust-askama-0.12.1
                             rust-askama-derive-0.12.5
                             rust-askama-escape-0.10.3
                             rust-askama-parser-0.2.1
                             rust-assert-json-diff-2.0.2
                             rust-assert-cmd-2.0.17
                             rust-assert-matches-1.5.0
                             rust-async-broadcast-0.7.2
                             rust-async-channel-2.5.0
                             rust-async-executor-1.13.3
                             rust-async-fs-2.2.0
                             rust-async-io-2.6.0
                             rust-async-lock-3.4.1
                             rust-async-process-2.5.0
                             rust-async-recursion-1.1.1
                             rust-async-signal-0.2.13
                             rust-async-stream-0.3.6
                             rust-async-stream-impl-0.3.6
                             rust-async-task-4.7.1
                             rust-async-trait-0.1.89
                             rust-atomic-waker-1.1.2
                             rust-autocfg-1.5.0
                             rust-axum-0.8.4
                             rust-axum-core-0.5.2
                             rust-backtrace-0.3.75
                             rust-base64-0.22.1
                             rust-basic-toml-0.1.10
                             rust-beef-0.5.2
                             rust-bit-set-0.5.3
                             rust-bit-vec-0.6.3
                             rust-bitflags-1.3.2
                             rust-bitflags-2.9.1
                             rust-block-buffer-0.10.4
                             rust-block-padding-0.3.3
                             rust-blocking-1.6.2
                             rust-bstr-1.12.0
                             rust-bumpalo-3.19.0
                             rust-bytemuck-1.23.1
                             rust-byteorder-1.5.0
                             rust-byteorder-lite-0.1.0
                             rust-bytes-1.10.1
                             rust-cassowary-0.3.0
                             rust-castaway-0.2.4
                             rust-cbc-0.1.2
                             rust-cc-1.2.30
                             rust-cesu8-1.1.0
                             rust-cfg-if-1.0.1
                             rust-cfg-aliases-0.1.1
                             rust-cfg-aliases-0.2.1
                             rust-chrono-0.4.42
                             rust-chunked-transfer-1.5.0
                             rust-cipher-0.4.4
                             rust-clap-4.5.47
                             rust-clap-builder-4.5.47
                             rust-clap-complete-4.5.57
                             rust-clap-derive-4.5.47
                             rust-clap-lex-0.7.5
                             rust-clipboard-win-5.4.1
                             rust-cmp-any-0.8.1
                             rust-color-eyre-0.6.5
                             rust-color-spantrace-0.3.0
                             rust-colorchoice-1.0.4
                             rust-combine-4.6.7
                             rust-compact-str-0.8.1
                             rust-concurrent-queue-2.5.0
                             rust-console-0.15.11
                             rust-convert-case-0.6.0
                             rust-core-foundation-0.9.4
                             rust-core-foundation-0.10.1
                             rust-core-foundation-sys-0.8.7
                             rust-cpufeatures-0.2.17
                             rust-crc32fast-1.5.0
                             rust-crossbeam-channel-0.5.15
                             rust-crossbeam-deque-0.8.6
                             rust-crossbeam-epoch-0.9.18
                             rust-crossbeam-utils-0.8.21
                             rust-crossterm-0.28.1
                             rust-crossterm-winapi-0.9.1
                             rust-crunchy-0.2.4
                             rust-crypto-common-0.1.6
                             rust-ctor-0.1.26
                             rust-ctor-0.5.0
                             rust-ctor-proc-macro-0.0.6
                             rust-darling-0.20.11
                             rust-darling-0.21.3
                             rust-darling-core-0.20.11
                             rust-darling-core-0.21.3
                             rust-darling-macro-0.20.11
                             rust-darling-macro-0.21.3
                             rust-dbus-0.9.9
                             rust-dbus-secret-service-4.1.0
                             rust-deadpool-0.12.3
                             rust-deadpool-runtime-0.1.4
                             rust-debugid-0.8.0
                             rust-debugserver-types-0.5.0
                             rust-deranged-0.5.4
                             rust-derivative-2.2.0
                             rust-derive-more-1.0.0
                             rust-derive-more-2.0.1
                             rust-derive-more-impl-1.0.0
                             rust-derive-more-impl-2.0.1
                             rust-diff-0.1.13
                             rust-difflib-0.4.0
                             rust-diffy-0.4.2
                             rust-digest-0.10.7
                             rust-dirs-6.0.0
                             rust-dirs-next-2.0.0
                             rust-dirs-sys-0.5.0
                             rust-dirs-sys-next-0.1.2
                             rust-dispatch2-0.3.0
                             rust-display-container-0.9.0
                             rust-displaydoc-0.2.5
                             rust-doc-comment-0.3.3
                             rust-dotenvy-0.15.7
                             rust-downcast-rs-1.2.1
                             rust-dtor-0.1.0
                             rust-dtor-proc-macro-0.0.6
                             rust-dunce-1.0.5
                             rust-dupe-0.9.1
                             rust-dupe-derive-0.9.1
                             rust-dyn-clone-1.0.19
                             rust-either-1.15.0
                             rust-ena-0.14.3
                             rust-encode-unicode-1.0.0
                             rust-encoding-rs-0.8.35
                             rust-endi-1.1.0
                             rust-endian-type-0.1.2
                             rust-enumflags2-0.7.12
                             rust-enumflags2-derive-0.7.12
                             rust-env-flags-0.1.1
                             rust-env-filter-0.1.3
                             rust-env-logger-0.11.8
                             rust-equivalent-1.0.2
                             rust-erased-serde-0.3.31
                             rust-errno-0.3.13
                             rust-error-code-3.3.2
                             rust-escargot-0.5.15
                             rust-event-listener-5.4.0
                             rust-event-listener-strategy-0.5.4
                             rust-eventsource-stream-0.2.3
                             rust-eyre-0.6.12
                             rust-fancy-regex-0.13.0
                             rust-fastrand-2.3.0
                             rust-fax-0.2.6
                             rust-fax-derive-0.2.0
                             rust-fd-lock-4.0.4
                             rust-fdeflate-0.3.7
                             rust-filedescriptor-0.8.3
                             rust-findshlibs-0.10.2
                             rust-fixed-decimal-0.7.0
                             rust-fixedbitset-0.4.2
                             rust-flate2-1.1.2
                             rust-float-cmp-0.10.0
                             rust-fnv-1.0.7
                             rust-foldhash-0.1.5
                             rust-foreign-types-0.3.2
                             rust-foreign-types-shared-0.1.1
                             rust-form-urlencoded-1.2.1
                             rust-fsevent-sys-4.1.0
                             rust-futures-0.3.31
                             rust-futures-channel-0.3.31
                             rust-futures-core-0.3.31
                             rust-futures-executor-0.3.31
                             rust-futures-io-0.3.31
                             rust-futures-lite-2.6.1
                             rust-futures-macro-0.3.31
                             rust-futures-sink-0.3.31
                             rust-futures-task-0.3.31
                             rust-futures-util-0.3.31
                             rust-fxhash-0.2.1
                             rust-generic-array-0.14.7
                             rust-gethostname-0.4.3
                             rust-getopts-0.2.23
                             rust-getrandom-0.2.16
                             rust-getrandom-0.3.3
                             rust-gimli-0.31.1
                             rust-globset-0.4.16
                             rust-h2-0.4.11
                             rust-half-2.6.0
                             rust-hashbrown-0.12.3
                             rust-hashbrown-0.14.5
                             rust-hashbrown-0.15.4
                             rust-heck-0.5.0
                             rust-hermit-abi-0.5.2
                             rust-hex-0.4.3
                             rust-hkdf-0.12.4
                             rust-hmac-0.12.1
                             rust-home-0.5.11
                             rust-hostname-0.4.1
                             rust-http-1.3.1
                             rust-http-body-1.0.1
                             rust-http-body-util-0.1.3
                             rust-httparse-1.10.1
                             rust-httpdate-1.0.3
                             rust-humansize-2.1.3
                             rust-hyper-1.7.0
                             rust-hyper-rustls-0.27.7
                             rust-hyper-timeout-0.5.2
                             rust-hyper-tls-0.6.0
                             rust-hyper-util-0.1.16
                             rust-iana-time-zone-0.1.63
                             rust-iana-time-zone-haiku-0.1.2
                             rust-icu-collections-2.0.0
                             rust-icu-decimal-2.0.0
                             rust-icu-decimal-data-2.0.0
                             rust-icu-locale-2.0.0
                             rust-icu-locale-core-2.0.0
                             rust-icu-locale-data-2.0.0
                             rust-icu-normalizer-2.0.0
                             rust-icu-normalizer-data-2.0.0
                             rust-icu-properties-2.0.1
                             rust-icu-properties-data-2.0.1
                             rust-icu-provider-2.0.0
                             rust-ident-case-1.0.1
                             rust-idna-1.0.3
                             rust-idna-adapter-1.2.1
                             rust-ignore-0.4.23
                             rust-image-0.25.8
                             rust-indenter-0.3.3
                             rust-indexmap-1.9.3
                             rust-indexmap-2.10.0
                             rust-indoc-2.0.6
                             rust-inotify-0.11.0
                             rust-inotify-sys-0.1.5
                             rust-inout-0.1.4
                             rust-insta-1.43.2
                             rust-instability-0.3.9
                             rust-inventory-0.3.20
                             rust-io-uring-0.7.9
                             rust-ipnet-2.11.0
                             rust-iri-string-0.7.8
                             rust-is-terminal-0.4.16
                             rust-is-ci-1.2.0
                             rust-is-terminal-polyfill-1.70.1
                             rust-itertools-0.10.5
                             rust-itertools-0.13.0
                             rust-itertools-0.14.0
                             rust-itoa-1.0.15
                             rust-jiff-0.2.15
                             rust-jiff-static-0.2.15
                             rust-jni-0.21.1
                             rust-jni-sys-0.3.0
                             rust-js-sys-0.3.77
                             rust-keyring-3.6.3
                             rust-kqueue-1.1.1
                             rust-kqueue-sys-1.0.4
                             rust-lalrpop-0.19.12
                             rust-lalrpop-util-0.19.12
                             rust-landlock-0.4.2
                             rust-lazy-static-1.5.0
                             rust-libc-0.2.175
                             rust-libdbus-sys-0.2.6
                             rust-libm-0.2.15
                             rust-libredox-0.1.6
                             rust-linux-keyutils-0.2.4
                             rust-linux-raw-sys-0.4.15
                             rust-linux-raw-sys-0.9.4
                             rust-litemap-0.8.0
                             rust-lock-api-0.4.13
                             rust-log-0.4.28
                             rust-logos-0.12.1
                             rust-logos-derive-0.12.1
                             rust-lru-0.12.5
                             rust-lru-slab-0.1.2
                             rust-lsp-types-0.94.1
                             rust-maplit-1.0.2
                             rust-matchers-0.2.0
                             rust-matchit-0.8.4
                             rust-memchr-2.7.5
                             rust-memoffset-0.6.5
                             rust-memoffset-0.9.1
                             rust-mime-0.3.17
                             rust-mime-guess-2.0.5
                             rust-minimal-lexical-0.2.1
                             rust-miniz-oxide-0.8.9
                             rust-mio-1.0.4
                             rust-moxcms-0.7.5
                             rust-multimap-0.10.1
                             rust-native-tls-0.2.14
                             rust-ndk-context-0.1.1
                             rust-new-debug-unreachable-1.0.6
                             rust-nibble-vec-0.1.0
                             rust-nix-0.28.0
                             rust-nix-0.29.0
                             rust-nix-0.30.1
                             rust-nom-7.1.3
                             rust-normalize-line-endings-0.3.0
                             rust-notify-8.2.0
                             rust-notify-types-2.0.0
                             rust-nu-ansi-term-0.50.1
                             rust-nucleo-matcher-0.3.1
                             rust-num-0.4.3
                             rust-num-bigint-0.4.6
                             rust-num-complex-0.4.6
                             rust-num-conv-0.1.0
                             rust-num-integer-0.1.46
                             rust-num-iter-0.1.45
                             rust-num-rational-0.4.2
                             rust-num-traits-0.2.19
                             rust-num-cpus-1.17.0
                             rust-num-threads-0.1.7
                             rust-oauth2-5.0.0
                             rust-objc2-0.6.2
                             rust-objc2-app-kit-0.3.1
                             rust-objc2-core-foundation-0.3.1
                             rust-objc2-core-graphics-0.3.1
                             rust-objc2-encode-4.1.0
                             rust-objc2-foundation-0.3.1
                             rust-objc2-io-surface-0.3.1
                             rust-object-0.36.7
                             rust-once-cell-1.21.3
                             rust-once-cell-polyfill-1.70.1
                             rust-openssl-0.10.73
                             rust-openssl-macros-0.1.1
                             rust-openssl-probe-0.1.6
                             rust-openssl-src-300.5.1+3.5.1
                             rust-openssl-sys-0.9.109
                             rust-opentelemetry-0.30.0
                             rust-opentelemetry-appender-tracing-0.30.1
                             rust-opentelemetry-http-0.30.0
                             rust-opentelemetry-otlp-0.30.0
                             rust-opentelemetry-proto-0.30.0
                             rust-opentelemetry-semantic-conventions-0.30.0
                             rust-opentelemetry-sdk-0.30.0
                             rust-option-ext-0.2.0
                             rust-ordered-stream-0.2.0
                             rust-os-info-3.12.0
                             rust-owo-colors-4.2.2
                             rust-parking-2.2.1
                             rust-parking-lot-0.12.4
                             rust-parking-lot-core-0.9.11
                             rust-paste-1.0.15
                             rust-path-absolutize-3.1.1
                             rust-path-dedot-3.1.1
                             rust-pathdiff-0.2.3
                             rust-percent-encoding-2.3.1
                             rust-petgraph-0.6.5
                             rust-phf-shared-0.11.3
                             rust-pin-project-1.1.10
                             rust-pin-project-internal-1.1.10
                             rust-pin-project-lite-0.2.16
                             rust-pin-utils-0.1.0
                             rust-piper-0.2.4
                             rust-pkg-config-0.3.32
                             rust-plist-1.7.4
                             rust-png-0.18.0
                             rust-polling-3.11.0
                             rust-portable-atomic-1.11.1
                             rust-portable-atomic-util-0.2.4
                             rust-portable-pty-0.9.0
                             rust-potential-utf-0.1.2
                             rust-powerfmt-0.2.0
                             rust-ppv-lite86-0.2.21
                             rust-precomputed-hash-0.1.1
                             rust-predicates-3.1.3
                             rust-predicates-core-1.0.9
                             rust-predicates-tree-1.0.12
                             rust-pretty-assertions-1.4.1
                             rust-proc-macro-crate-3.4.0
                             rust-proc-macro2-1.0.95
                             rust-process-wrap-8.2.1
                             rust-prost-0.13.5
                             rust-prost-derive-0.13.5
                             rust-pulldown-cmark-0.10.3
                             rust-pulldown-cmark-escape-0.10.1
                             rust-pxfm-0.1.23
                             rust-quick-error-2.0.1
                             rust-quick-xml-0.38.0
                             rust-quinn-0.11.9
                             rust-quinn-proto-0.11.13
                             rust-quinn-udp-0.5.14
                             rust-quote-1.0.40
                             rust-r-efi-5.3.0
                             rust-radix-trie-0.2.1
                             rust-rand-0.8.5
                             rust-rand-0.9.2
                             rust-rand-chacha-0.3.1
                             rust-rand-chacha-0.9.0
                             rust-rand-core-0.6.4
                             rust-rand-core-0.9.3
                             rust-ratatui-0.29.0.9b2ad12
                             rust-ratatui-macros-0.6.0
                             rust-redox-syscall-0.5.15
                             rust-redox-users-0.4.6
                             rust-redox-users-0.5.0
                             rust-ref-cast-1.0.24
                             rust-ref-cast-impl-1.0.24
                             rust-regex-1.11.1
                             rust-regex-automata-0.4.9
                             rust-regex-lite-0.1.7
                             rust-regex-syntax-0.6.29
                             rust-regex-syntax-0.8.5
                             rust-reqwest-0.12.23
                             rust-ring-0.17.14
                             rust-rmcp-0.8.2
                             rust-rmcp-macros-0.8.2
                             rust-rustc-demangle-0.1.25
                             rust-rustc-hash-1.1.0
                             rust-rustc-hash-2.1.1
                             rust-rustc-version-0.4.1
                             rust-rustix-0.38.44
                             rust-rustix-1.0.8
                             rust-rustls-0.23.29
                             rust-rustls-native-certs-0.8.1
                             rust-rustls-pki-types-1.12.0
                             rust-rustls-webpki-0.103.4
                             rust-rustversion-1.0.21
                             rust-rustyline-14.0.0
                             rust-ryu-1.0.20
                             rust-same-file-1.0.6
                             rust-scc-2.4.0
                             rust-schannel-0.1.28
                             rust-schemafy-0.5.2
                             rust-schemafy-core-0.5.2
                             rust-schemafy-lib-0.5.2
                             rust-schemars-0.8.22
                             rust-schemars-0.9.0
                             rust-schemars-1.0.4
                             rust-schemars-derive-0.8.22
                             rust-schemars-derive-1.0.4
                             rust-scopeguard-1.2.0
                             rust-sdd-3.0.10
                             rust-seccompiler-0.5.0
                             rust-secret-service-4.0.0
                             rust-security-framework-2.11.1
                             rust-security-framework-3.5.1
                             rust-security-framework-sys-2.15.0
                             rust-semver-1.0.27
                             rust-sentry-0.34.0
                             rust-sentry-backtrace-0.34.0
                             rust-sentry-contexts-0.34.0
                             rust-sentry-core-0.34.0
                             rust-sentry-debug-images-0.34.0
                             rust-sentry-panic-0.34.0
                             rust-sentry-tracing-0.34.0
                             rust-sentry-types-0.34.0
                             rust-serde-1.0.226
                             rust-serde-core-1.0.226
                             rust-serde-derive-1.0.226
                             rust-serde-derive-internals-0.29.1
                             rust-serde-json-1.0.145
                             rust-serde-path-to-error-0.1.20
                             rust-serde-repr-0.1.20
                             rust-serde-spanned-1.0.0
                             rust-serde-urlencoded-0.7.1
                             rust-serde-with-3.14.0
                             rust-serde-with-macros-3.14.0
                             rust-serial2-0.2.31
                             rust-serial-test-3.2.0
                             rust-serial-test-derive-3.2.0
                             rust-sha1-0.10.6
                             rust-sha2-0.10.9
                             rust-sharded-slab-0.1.7
                             rust-shared-library-0.1.9
                             rust-shell-words-1.1.0
                             rust-shlex-1.3.0
                             rust-signal-hook-0.3.18
                             rust-signal-hook-mio-0.2.4
                             rust-signal-hook-registry-1.4.5
                             rust-simd-adler32-0.3.7
                             rust-simdutf8-0.1.5
                             rust-similar-2.7.0
                             rust-siphasher-1.0.1
                             rust-slab-0.4.11
                             rust-smallvec-1.15.1
                             rust-smawk-0.3.2
                             rust-socket2-0.5.10
                             rust-socket2-0.6.0
                             rust-sse-stream-0.2.1
                             rust-stable-deref-trait-1.2.0
                             rust-starlark-0.13.0
                             rust-starlark-derive-0.13.0
                             rust-starlark-map-0.13.0
                             rust-starlark-syntax-0.13.0
                             rust-static-assertions-1.1.0
                             rust-streaming-iterator-0.1.9
                             rust-string-cache-0.8.9
                             rust-strsim-0.10.0
                             rust-strsim-0.11.1
                             rust-strum-0.26.3
                             rust-strum-0.27.2
                             rust-strum-macros-0.26.4
                             rust-strum-macros-0.27.2
                             rust-subtle-2.6.1
                             rust-supports-color-3.0.2
                             rust-syn-1.0.109
                             rust-syn-2.0.104
                             rust-sync-wrapper-1.0.2
                             rust-synstructure-0.13.2
                             rust-sys-locale-0.3.2
                             rust-system-configuration-0.6.1
                             rust-system-configuration-sys-0.6.0
                             rust-tempfile-3.23.0
                             rust-term-0.7.0
                             rust-termcolor-1.4.1
                             rust-terminal-size-0.4.2
                             rust-termtree-0.5.1
                             rust-test-log-0.2.18
                             rust-test-log-macros-0.2.18
                             rust-textwrap-0.11.0
                             rust-textwrap-0.16.2
                             rust-thiserror-1.0.69
                             rust-thiserror-2.0.16
                             rust-thiserror-impl-1.0.69
                             rust-thiserror-impl-2.0.16
                             rust-thread-local-1.1.9
                             rust-tiff-0.10.3
                             rust-tiktoken-rs-0.7.0
                             rust-time-0.3.44
                             rust-time-core-0.1.6
                             rust-time-macros-0.2.24
                             rust-tiny-keccak-2.0.2
                             rust-tiny-http-0.12.0
                             rust-tinystr-0.8.1
                             rust-tinyvec-1.10.0
                             rust-tinyvec-macros-0.1.1
                             rust-tokio-1.47.1
                             rust-tokio-macros-2.5.0
                             rust-tokio-native-tls-0.3.1
                             rust-tokio-rustls-0.26.2
                             rust-tokio-stream-0.1.17
                             rust-tokio-test-0.4.4
                             rust-tokio-util-0.7.16
                             rust-toml-0.9.5
                             rust-toml-datetime-0.7.0
                             rust-toml-edit-0.23.4
                             rust-toml-parser-1.0.2
                             rust-toml-writer-1.0.2
                             rust-tonic-0.13.1
                             rust-tower-0.5.2
                             rust-tower-http-0.6.6
                             rust-tower-layer-0.3.3
                             rust-tower-service-0.3.3
                             rust-tracing-0.1.41
                             rust-tracing-appender-0.2.3
                             rust-tracing-attributes-0.1.30
                             rust-tracing-core-0.1.34
                             rust-tracing-error-0.2.1
                             rust-tracing-log-0.2.0
                             rust-tracing-subscriber-0.3.20
                             rust-tracing-test-0.2.5
                             rust-tracing-test-macro-0.2.5
                             rust-tree-sitter-0.25.10
                             rust-tree-sitter-bash-0.25.0
                             rust-tree-sitter-highlight-0.25.10
                             rust-tree-sitter-language-0.1.5
                             rust-try-lock-0.2.5
                             rust-ts-rs-11.0.1
                             rust-ts-rs-macros-11.0.1
                             rust-typenum-1.18.0
                             rust-uds-windows-1.1.0
                             rust-uname-0.1.1
                             rust-unicase-2.8.1
                             rust-unicode-ident-1.0.18
                             rust-unicode-linebreak-0.1.5
                             rust-unicode-segmentation-1.12.0
                             rust-unicode-truncate-1.1.0
                             rust-unicode-width-0.1.14
                             rust-unicode-width-0.2.1
                             rust-unicode-xid-0.2.6
                             rust-untrusted-0.9.0
                             rust-ureq-2.12.1
                             rust-url-2.5.4
                             rust-urlencoding-2.1.3
                             rust-utf8-iter-1.0.4
                             rust-utf8parse-0.2.2
                             rust-uuid-1.18.1
                             rust-valuable-0.1.1
                             rust-vcpkg-0.2.15
                             rust-version-check-0.9.5
                             rust-vt100-0.16.2
                             rust-vte-0.15.0
                             rust-wait-timeout-0.2.1
                             rust-walkdir-2.5.0
                             rust-want-0.3.1
                             rust-wasi-0.11.1+wasi-snapshot-preview1
                             rust-wasi-0.14.2+wasi-0.2.4
                             rust-wasm-bindgen-0.2.100
                             rust-wasm-bindgen-backend-0.2.100
                             rust-wasm-bindgen-futures-0.4.50
                             rust-wasm-bindgen-macro-0.2.100
                             rust-wasm-bindgen-macro-support-0.2.100
                             rust-wasm-bindgen-shared-0.2.100
                             rust-wasm-streams-0.4.2
                             rust-web-sys-0.3.77
                             rust-web-time-1.1.0
                             rust-webbrowser-1.0.5
                             rust-webpki-roots-1.0.2
                             rust-weezl-0.1.10
                             rust-which-6.0.3
                             rust-wildmatch-2.5.0
                             rust-winapi-0.3.9
                             rust-winapi-i686-pc-windows-gnu-0.4.0
                             rust-winapi-util-0.1.9
                             rust-winapi-x86-64-pc-windows-gnu-0.4.0
                             rust-windows-0.61.3
                             rust-windows-collections-0.2.0
                             rust-windows-core-0.61.2
                             rust-windows-future-0.2.1
                             rust-windows-implement-0.60.0
                             rust-windows-interface-0.59.1
                             rust-windows-link-0.1.3
                             rust-windows-link-0.2.0
                             rust-windows-numerics-0.2.0
                             rust-windows-registry-0.5.3
                             rust-windows-result-0.3.4
                             rust-windows-strings-0.4.2
                             rust-windows-sys-0.45.0
                             rust-windows-sys-0.52.0
                             rust-windows-sys-0.59.0
                             rust-windows-sys-0.60.2
                             rust-windows-sys-0.61.1
                             rust-windows-targets-0.42.2
                             rust-windows-targets-0.48.5
                             rust-windows-targets-0.52.6
                             rust-windows-targets-0.53.2
                             rust-windows-threading-0.1.0
                             rust-windows-aarch64-gnullvm-0.42.2
                             rust-windows-aarch64-gnullvm-0.48.5
                             rust-windows-aarch64-gnullvm-0.52.6
                             rust-windows-aarch64-gnullvm-0.53.0
                             rust-windows-aarch64-msvc-0.42.2
                             rust-windows-aarch64-msvc-0.48.5
                             rust-windows-aarch64-msvc-0.52.6
                             rust-windows-aarch64-msvc-0.53.0
                             rust-windows-i686-gnu-0.42.2
                             rust-windows-i686-gnu-0.48.5
                             rust-windows-i686-gnu-0.52.6
                             rust-windows-i686-gnu-0.53.0
                             rust-windows-i686-gnullvm-0.52.6
                             rust-windows-i686-gnullvm-0.53.0
                             rust-windows-i686-msvc-0.42.2
                             rust-windows-i686-msvc-0.48.5
                             rust-windows-i686-msvc-0.52.6
                             rust-windows-i686-msvc-0.53.0
                             rust-windows-x86-64-gnu-0.42.2
                             rust-windows-x86-64-gnu-0.48.5
                             rust-windows-x86-64-gnu-0.52.6
                             rust-windows-x86-64-gnu-0.53.0
                             rust-windows-x86-64-gnullvm-0.42.2
                             rust-windows-x86-64-gnullvm-0.48.5
                             rust-windows-x86-64-gnullvm-0.52.6
                             rust-windows-x86-64-gnullvm-0.53.0
                             rust-windows-x86-64-msvc-0.42.2
                             rust-windows-x86-64-msvc-0.48.5
                             rust-windows-x86-64-msvc-0.52.6
                             rust-windows-x86-64-msvc-0.53.0
                             rust-winnow-0.7.12
                             rust-winreg-0.10.1
                             rust-winsafe-0.0.19
                             rust-wiremock-0.6.5
                             rust-wit-bindgen-rt-0.39.0
                             rust-writeable-0.6.1
                             rust-x11rb-0.13.1
                             rust-x11rb-protocol-0.13.1
                             rust-xdg-home-1.3.0
                             rust-yansi-1.0.1
                             rust-yoke-0.8.0
                             rust-yoke-derive-0.8.0
                             rust-zbus-4.4.0
                             rust-zbus-macros-4.4.0
                             rust-zbus-names-3.0.0
                             rust-zerocopy-0.8.26
                             rust-zerocopy-derive-0.8.26
                             rust-zerofrom-0.1.6
                             rust-zerofrom-derive-0.1.6
                             rust-zeroize-1.8.1
                             rust-zeroize-derive-1.4.2
                             rust-zerotrie-0.2.2
                             rust-zerovec-0.11.2
                             rust-zerovec-derive-0.11.1
                             rust-zune-core-0.4.12
                             rust-zune-jpeg-0.4.19
                             rust-zvariant-4.2.0
                             rust-zvariant-derive-4.2.0
                             rust-zvariant-utils-2.1.0))
                     (neocmakelsp =>
                                  (list rust-addr2line-0.24.2
                                   rust-adler2-2.0.1
                                   rust-aho-corasick-1.1.3
                                   rust-anstream-0.6.20
                                   rust-anstyle-1.0.11
                                   rust-anstyle-parse-0.2.7
                                   rust-anstyle-query-1.1.4
                                   rust-anstyle-wincon-3.0.10
                                   rust-anyhow-1.0.99
                                   rust-assert-cmd-2.0.17
                                   rust-auto-impl-1.3.0
                                   rust-autocfg-1.5.0
                                   rust-backtrace-0.3.75
                                   rust-bitflags-2.9.4
                                   rust-borrow-or-share-0.2.2
                                   rust-bstr-1.12.0
                                   rust-bytes-1.10.1
                                   rust-cc-1.2.38
                                   rust-cfg-if-1.0.3
                                   rust-clap-4.5.47
                                   rust-clap-builder-4.5.47
                                   rust-clap-complete-4.5.58
                                   rust-clap-derive-4.5.47
                                   rust-clap-lex-0.7.5
                                   rust-cli-table-0.5.0
                                   rust-cli-table-derive-0.5.0
                                   rust-colorchoice-1.0.4
                                   rust-const-random-0.1.18
                                   rust-const-random-macro-0.1.16
                                   rust-crossbeam-deque-0.8.6
                                   rust-crossbeam-epoch-0.9.18
                                   rust-crossbeam-utils-0.8.21
                                   rust-crunchy-0.2.4
                                   rust-csv-1.3.1
                                   rust-csv-core-0.1.12
                                   rust-dashmap-6.1.0
                                   rust-difflib-0.4.0
                                   rust-dirs-6.0.0
                                   rust-dirs-sys-0.5.0
                                   rust-dlv-list-0.5.2
                                   rust-doc-comment-0.3.3
                                   rust-equivalent-1.0.2
                                   rust-errno-0.3.14
                                   rust-fastrand-2.3.0
                                   rust-find-msvc-tools-0.1.2
                                   rust-fluent-uri-0.3.2
                                   rust-futures-0.3.31
                                   rust-futures-channel-0.3.31
                                   rust-futures-core-0.3.31
                                   rust-futures-io-0.3.31
                                   rust-futures-macro-0.3.31
                                   rust-futures-sink-0.3.31
                                   rust-futures-task-0.3.31
                                   rust-futures-util-0.3.31
                                   rust-getrandom-0.2.16
                                   rust-getrandom-0.3.3
                                   rust-gimli-0.31.1
                                   rust-glob-0.3.3
                                   rust-globset-0.4.16
                                   rust-hashbrown-0.14.5
                                   rust-hashbrown-0.16.0
                                   rust-heck-0.5.0
                                   rust-httparse-1.10.1
                                   rust-ignore-0.4.23
                                   rust-indexmap-2.11.4
                                   rust-io-uring-0.7.10
                                   rust-is-executable-1.0.5
                                   rust-is-terminal-polyfill-1.70.1
                                   rust-itoa-1.0.15
                                   rust-lazy-static-1.5.0
                                   rust-libc-0.2.175
                                   rust-libredox-0.1.10
                                   rust-linux-raw-sys-0.11.0
                                   rust-lock-api-0.4.13
                                   rust-log-0.4.28
                                   rust-lsp-types-f-0.99.0
                                   rust-memchr-2.7.5
                                   rust-miniz-oxide-0.8.9
                                   rust-mio-1.0.4
                                   rust-nu-ansi-term-0.50.1
                                   rust-object-0.36.7
                                   rust-once-cell-1.21.3
                                   rust-once-cell-polyfill-1.70.1
                                   rust-option-ext-0.2.0
                                   rust-ordered-multimap-0.7.3
                                   rust-parking-lot-0.12.4
                                   rust-parking-lot-core-0.9.11
                                   rust-path-absolutize-3.1.1
                                   rust-path-dedot-3.1.1
                                   rust-pathdiff-0.2.3
                                   rust-percent-encoding-2.3.2
                                   rust-pin-project-lite-0.2.16
                                   rust-pin-utils-0.1.0
                                   rust-predicates-3.1.3
                                   rust-predicates-core-1.0.9
                                   rust-predicates-tree-1.0.12
                                   rust-proc-macro2-1.0.101
                                   rust-quote-1.0.40
                                   rust-r-efi-5.3.0
                                   rust-redox-syscall-0.5.17
                                   rust-redox-users-0.5.2
                                   rust-ref-cast-1.0.24
                                   rust-ref-cast-impl-1.0.24
                                   rust-regex-1.11.2
                                   rust-regex-automata-0.4.10
                                   rust-regex-syntax-0.8.6
                                   rust-rust-ini-0.21.3
                                   rust-rustc-demangle-0.1.26
                                   rust-rustix-1.1.2
                                   rust-ryu-1.0.20
                                   rust-same-file-1.0.6
                                   rust-scopeguard-1.2.0
                                   rust-serde-1.0.225
                                   rust-serde-core-1.0.225
                                   rust-serde-derive-1.0.225
                                   rust-serde-json-1.0.145
                                   rust-serde-repr-0.1.20
                                   rust-serde-spanned-1.0.2
                                   rust-sharded-slab-0.1.7
                                   rust-shlex-1.3.0
                                   rust-signal-hook-registry-1.4.6
                                   rust-slab-0.4.11
                                   rust-smallvec-1.15.1
                                   rust-socket2-0.6.0
                                   rust-streaming-iterator-0.1.9
                                   rust-strsim-0.11.1
                                   rust-syn-2.0.106
                                   rust-sync-wrapper-1.0.2
                                   rust-tempfile-3.22.0
                                   rust-termcolor-1.4.1
                                   rust-termtree-0.5.1
                                   rust-thiserror-2.0.16
                                   rust-thiserror-impl-2.0.16
                                   rust-thread-local-1.1.9
                                   rust-tiny-keccak-2.0.2
                                   rust-tokio-1.47.1
                                   rust-tokio-macros-2.5.0
                                   rust-tokio-util-0.7.16
                                   rust-toml-0.9.7
                                   rust-toml-datetime-0.7.2
                                   rust-toml-parser-1.0.3
                                   rust-toml-writer-1.0.3
                                   rust-tower-0.5.2
                                   rust-tower-layer-0.3.3
                                   rust-tower-lsp-f-0.24.0
                                   rust-tower-service-0.3.3
                                   rust-tracing-0.1.41
                                   rust-tracing-attributes-0.1.30
                                   rust-tracing-core-0.1.34
                                   rust-tracing-log-0.2.0
                                   rust-tracing-subscriber-0.3.20
                                   rust-tree-sitter-0.25.9
                                   rust-tree-sitter-cmake-0.7.1
                                   rust-tree-sitter-language-0.1.5
                                   rust-treesitter-kind-collector-0.2.0
                                   rust-unicode-ident-1.0.19
                                   rust-unicode-width-0.2.1
                                   rust-utf8parse-0.2.2
                                   rust-valuable-0.1.1
                                   rust-wait-timeout-0.2.1
                                   rust-walkdir-2.5.0
                                   rust-wasi-0.11.1+wasi-snapshot-preview1
                                   rust-wasi-0.14.7+wasi-0.2.4
                                   rust-wasip2-1.0.1+wasi-0.2.4
                                   rust-winapi-util-0.1.11
                                   rust-windows-link-0.1.3
                                   rust-windows-link-0.2.0
                                   rust-windows-sys-0.52.0
                                   rust-windows-sys-0.59.0
                                   rust-windows-sys-0.60.2
                                   rust-windows-sys-0.61.0
                                   rust-windows-targets-0.52.6
                                   rust-windows-targets-0.53.3
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
                                   rust-winnow-0.7.13
                                   rust-wit-bindgen-0.46.0))
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
                                rust-zerovec-derive-0.11.1))
                     (texlab =>
                             (list rust-adler2-2.0.0
                                   rust-aho-corasick-1.1.1
                                   rust-anes-0.1.6
                                   rust-anstream-0.6.11
                                   rust-anstyle-1.0.8
                                   rust-anstyle-parse-0.2.1
                                   rust-anstyle-query-1.0.0
                                   rust-anstyle-wincon-3.0.1
                                   rust-anyhow-1.0.98
                                   rust-autocfg-1.1.0
                                   rust-beef-0.5.2
                                   rust-bitflags-1.3.2
                                   rust-bitflags-2.8.0
                                   rust-bstr-1.12.0
                                   rust-bumpalo-3.14.0
                                   rust-cast-0.3.0
                                   rust-castaway-0.2.2
                                   rust-cfg-if-1.0.0
                                   rust-chrono-0.4.41
                                   rust-ciborium-0.2.1
                                   rust-ciborium-io-0.2.1
                                   rust-ciborium-ll-0.2.1
                                   rust-clap-4.5.40
                                   rust-clap-builder-4.5.40
                                   rust-clap-derive-4.5.40
                                   rust-clap-lex-0.7.4
                                   rust-colorchoice-1.0.0
                                   rust-compact-str-0.7.1
                                   rust-countme-3.0.1
                                   rust-crc32fast-1.3.2
                                   rust-criterion-0.5.1
                                   rust-criterion-plot-0.5.0
                                   rust-crossbeam-channel-0.5.15
                                   rust-crossbeam-deque-0.8.3
                                   rust-crossbeam-epoch-0.9.15
                                   rust-crossbeam-utils-0.8.19
                                   rust-dirs-6.0.0
                                   rust-dirs-sys-0.5.0
                                   rust-displaydoc-0.2.5
                                   rust-dissimilar-1.0.7
                                   rust-either-1.9.0
                                   rust-encoding-rs-0.8.35
                                   rust-encoding-rs-io-0.1.7
                                   rust-errno-0.3.11
                                   rust-expect-test-1.5.1
                                   rust-fastrand-2.1.1
                                   rust-fern-0.7.1
                                   rust-file-id-0.2.2
                                   rust-filetime-0.2.22
                                   rust-flate2-1.1.2
                                   rust-fnv-1.0.7
                                   rust-form-urlencoded-1.2.1
                                   rust-fsevent-sys-4.1.0
                                   rust-fuzzy-matcher-0.3.7
                                   rust-getrandom-0.2.9
                                   rust-getrandom-0.3.2
                                   rust-half-1.8.2
                                   rust-hashbrown-0.14.3
                                   rust-heck-0.5.0
                                   rust-hermit-abi-0.3.3
                                   rust-hermit-abi-0.4.0
                                   rust-human-name-2.0.4
                                   rust-icu-collections-1.5.0
                                   rust-icu-locid-1.5.0
                                   rust-icu-locid-transform-1.5.0
                                   rust-icu-locid-transform-data-1.5.0
                                   rust-icu-normalizer-1.5.0
                                   rust-icu-normalizer-data-1.5.0
                                   rust-icu-properties-1.5.1
                                   rust-icu-properties-data-1.5.0
                                   rust-icu-provider-1.5.0
                                   rust-icu-provider-macros-1.5.0
                                   rust-idna-1.0.3
                                   rust-idna-adapter-1.2.0
                                   rust-inotify-0.11.0
                                   rust-inotify-sys-0.1.5
                                   rust-is-terminal-0.4.13
                                   rust-isocountry-0.3.2
                                   rust-itertools-0.10.5
                                   rust-itertools-0.13.0
                                   rust-itoa-1.0.9
                                   rust-js-sys-0.3.64
                                   rust-kqueue-1.0.8
                                   rust-kqueue-sys-1.0.4
                                   rust-lazy-static-1.4.0
                                   rust-libc-0.2.174
                                   rust-libredox-0.1.3
                                   rust-linux-raw-sys-0.9.3
                                   rust-litemap-0.7.4
                                   rust-lock-api-0.4.13
                                   rust-log-0.4.27
                                   rust-logos-0.15.0
                                   rust-logos-codegen-0.15.0
                                   rust-logos-derive-0.15.0
                                   rust-lsp-server-0.7.8
                                   rust-lsp-types-0.95.1
                                   rust-memchr-2.7.1
                                   rust-memoffset-0.9.0
                                   rust-minimal-lexical-0.2.1
                                   rust-miniz-oxide-0.8.8
                                   rust-mio-1.0.3
                                   rust-multimap-0.10.1
                                   rust-nom-7.1.3
                                   rust-notify-8.0.0
                                   rust-notify-debouncer-full-0.5.0
                                   rust-notify-types-2.0.0
                                   rust-num-traits-0.2.16
                                   rust-num-cpus-1.16.0
                                   rust-once-cell-1.21.3
                                   rust-oorandom-11.1.3
                                   rust-option-ext-0.2.0
                                   rust-parking-lot-0.12.4
                                   rust-parking-lot-core-0.9.11
                                   rust-pathdiff-0.2.3
                                   rust-percent-encoding-2.3.1
                                   rust-phf-0.11.2
                                   rust-phf-codegen-0.11.2
                                   rust-phf-generator-0.11.2
                                   rust-phf-shared-0.11.2
                                   rust-plotters-0.3.5
                                   rust-plotters-backend-0.3.5
                                   rust-plotters-svg-0.3.5
                                   rust-proc-macro2-1.0.89
                                   rust-quote-1.0.35
                                   rust-r-efi-5.2.0
                                   rust-rand-0.8.5
                                   rust-rand-core-0.6.4
                                   rust-rayon-1.10.0
                                   rust-rayon-core-1.12.1
                                   rust-redox-syscall-0.3.5
                                   rust-redox-syscall-0.5.13
                                   rust-redox-users-0.5.0
                                   rust-regex-1.11.1
                                   rust-regex-automata-0.4.8
                                   rust-regex-syntax-0.8.5
                                   rust-rowan-0.15.16
                                   rust-rustc-hash-1.1.0
                                   rust-rustc-hash-2.1.1
                                   rust-rustc-version-0.4.1
                                   rust-rustix-1.0.5
                                   rust-rustversion-1.0.15
                                   rust-ryu-1.0.15
                                   rust-same-file-1.0.6
                                   rust-scopeguard-1.2.0
                                   rust-semver-1.0.23
                                   rust-serde-1.0.219
                                   rust-serde-derive-1.0.219
                                   rust-serde-json-1.0.140
                                   rust-serde-regex-1.1.0
                                   rust-serde-repr-0.1.20
                                   rust-shellexpand-3.1.1
                                   rust-siphasher-0.3.11
                                   rust-smallvec-1.13.2
                                   rust-stable-deref-trait-1.2.0
                                   rust-static-assertions-1.1.0
                                   rust-strsim-0.11.0
                                   rust-syn-2.0.87
                                   rust-synstructure-0.13.1
                                   rust-tempfile-3.19.1
                                   rust-text-size-1.1.1
                                   rust-thiserror-1.0.69
                                   rust-thiserror-2.0.12
                                   rust-thiserror-impl-1.0.69
                                   rust-thiserror-impl-2.0.12
                                   rust-thread-local-1.1.7
                                   rust-threadpool-1.8.1
                                   rust-tinystr-0.7.6
                                   rust-tinytemplate-1.2.1
                                   rust-tinyvec-1.6.0
                                   rust-tinyvec-macros-0.1.1
                                   rust-titlecase-3.6.0
                                   rust-uds-windows-1.1.0
                                   rust-unicode-case-mapping-0.4.0
                                   rust-unicode-ident-1.0.12
                                   rust-unicode-normalization-0.1.24
                                   rust-unicode-segmentation-1.10.1
                                   rust-unidecode-0.3.0
                                   rust-url-2.5.4
                                   rust-utf16-iter-1.0.5
                                   rust-utf8-iter-1.0.4
                                   rust-utf8parse-0.2.1
                                   rust-versions-6.3.2
                                   rust-walkdir-2.4.0
                                   rust-wasi-0.11.0+wasi-snapshot-preview1
                                   rust-wasi-0.14.2+wasi-0.2.4
                                   rust-wasm-bindgen-0.2.92
                                   rust-wasm-bindgen-backend-0.2.92
                                   rust-wasm-bindgen-macro-0.2.92
                                   rust-wasm-bindgen-macro-support-0.2.92
                                   rust-wasm-bindgen-shared-0.2.92
                                   rust-web-sys-0.3.64
                                   rust-winapi-0.3.9
                                   rust-winapi-i686-pc-windows-gnu-0.4.0
                                   rust-winapi-util-0.1.6
                                   rust-winapi-x86-64-pc-windows-gnu-0.4.0
                                   rust-windows-sys-0.48.0
                                   rust-windows-sys-0.52.0
                                   rust-windows-sys-0.59.0
                                   rust-windows-targets-0.48.5
                                   rust-windows-targets-0.52.6
                                   rust-windows-aarch64-gnullvm-0.48.5
                                   rust-windows-aarch64-gnullvm-0.52.6
                                   rust-windows-aarch64-msvc-0.48.5
                                   rust-windows-aarch64-msvc-0.52.6
                                   rust-windows-i686-gnu-0.48.5
                                   rust-windows-i686-gnu-0.52.6
                                   rust-windows-i686-gnullvm-0.52.6
                                   rust-windows-i686-msvc-0.48.5
                                   rust-windows-i686-msvc-0.52.6
                                   rust-windows-x86-64-gnu-0.48.5
                                   rust-windows-x86-64-gnu-0.52.6
                                   rust-windows-x86-64-gnullvm-0.48.5
                                   rust-windows-x86-64-gnullvm-0.52.6
                                   rust-windows-x86-64-msvc-0.48.5
                                   rust-windows-x86-64-msvc-0.52.6
                                   rust-wit-bindgen-rt-0.39.0
                                   rust-write16-1.0.0
                                   rust-writeable-0.5.5
                                   rust-yoke-0.7.5
                                   rust-yoke-derive-0.7.5
                                   rust-zerofrom-0.1.5
                                   rust-zerofrom-derive-0.1.5
                                   rust-zerovec-0.10.4
                                   rust-zerovec-derive-0.10.3)))
