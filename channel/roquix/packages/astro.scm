(define-module (roquix packages astro)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix build-system node)
  #:use-module (guix gexp)
  #:use-module (gnu packages node-xyz))

;; NOTE: Guix's node-build-system hard-codes --install-links in both the
;; configure and install phases.  With npm 11, this can make npm try to chmod
;; bin files in file:// dependencies from the read-only GNU store.  Although
;; the build system accepts #:npm-flags, its standard phases do not use them,
;; so replacing the phases is currently necessary to disable install links.
(define (node-build-phases-without-install-links . phases)
  #~(modify-phases %standard-phases
      (replace 'configure
        (lambda* (#:key inputs #:allow-other-keys)
          (invoke (string-append (assoc-ref inputs "node") "/bin/npm")
                  "--offline" "--ignore-scripts" "--no-audit"
                  "--no-bin-links" "install")))
      (replace 'install
        (lambda* (#:key outputs inputs #:allow-other-keys)
          (invoke (string-append (assoc-ref inputs "node") "/bin/npm")
                  "--prefix" (assoc-ref outputs "out")
                  "--global"
                  "--offline"
                  "--loglevel" "info"
                  "--production"
                  "--no-bin-links"
                  "install" "../package.tgz")))
      #$@phases))

(define-public node-s-color-0.0.15
  (package
    (name "node-s-color")
    (version "0.0.15")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/s.color/-/s.color-0.0.15.tgz")
       (sha256
        (base32 "019mmk2rqywqij4z31m61jvlrcb5zgwqlylvllybk7gqsr6gzkpr"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("jest" "ts-jest" "suf-cli"
                                                  "@types/jest" "typescript"))))))))
    (home-page "https://github.com/TheRealSyler/s.color#readme")
    (synopsis "Simple color library.")
    (description "Simple color library.")
    (license license:expat)))

(define-public node-suf-log-2.5.3
  (package
    (name "node-suf-log")
    (version "2.5.3")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/suf-log/-/suf-log-2.5.3.tgz")
       (sha256
        (base32 "0yvf7ffn7zmvsz5zg6nlgmfk4jmzy22qh8y3fi3ih3a8m41ly3f0"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/jest" "del-cli"
                                                  "jest"
                                                  "jest-store-log"
                                                  "suf-cli"
                                                  "ts-jest"
                                                  "tslib"
                                                  "typescript"))))))))
    (inputs (list node-s-color-0.0.15))
    (home-page "https://github.com/TheRealSyler/suf-log#readme")
    (synopsis
     "<span id=\"BADGE_GENERATION_MARKER_0\"></span> [![circleci](https://img.shields.io/circleci/build/github/TheRealSyler/suf-log)](https://app.circleci.com/github/TheRealSyler/suf-log/pipelines) [![Custom](https://codecov.io/gh/TheRealSyler/suf-log/branch/mast")
    (description
     "<span id=\"BADGE_GENERATION_MARKER_0\"></span> [![circleci](https://img.shields.io/circleci/build/github/TheRealSyler/suf-log)](https://app.circleci.com/github/TheRealSyler/suf-log/pipelines) [![Custom](https://codecov.io/gh/TheRealSyler/suf-log/branch/mast")
    (license license:expat)))

(define-public node-sass-formatter-0.7.9
  (package
    (name "node-sass-formatter")
    (version "0.7.9")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/sass-formatter/-/sass-formatter-0.7.9.tgz")
       (sha256
        (base32 "1260nm5d1apppd74q8jnf9v8a5yqplj6y7rqipz8665n374znl5j"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (replace 'unpack
            (lambda* (#:key source #:allow-other-keys)
              (invoke "tar" "--delay-directory-restore" "-xvf" source)
              (invoke "chmod" "-R" "u+rwX" "package")
              (chdir "package")))
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("jest" "tslib"
                                                  "del-cli"
                                                  "nodemon"
                                                  "suf-cli"
                                                  "ts-jest"
                                                  "ts-node"
                                                  "typescript"
                                                  "@types/jest"
                                                  "jest-store-log"
                                                  "known-css-properties"))))))))
    (inputs (list node-suf-log-2.5.3))
    (home-page "https://www.npmjs.com/package/node-sass-formatter")
    (synopsis "typescript sass formatter")
    (description "typescript sass formatter")
    (license license:expat)))

(define-public node-prettier-plugin-astro-0.14.1
  (package
    (name "node-prettier-plugin-astro")
    (version "0.14.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/prettier-plugin-astro/-/prettier-plugin-astro-0.14.1.tgz")
       (sha256
        (base32 "0v3hal3brlv9ii7apdcc2fxxz103xxgwp6idr0bhj62r42y679fz"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@changesets/cli"
                                                  "@rollup/plugin-commonjs"
                                                  "@rollup/plugin-typescript"
                                                  "@types/node"
                                                  "@typescript-eslint/eslint-plugin"
                                                  "@typescript-eslint/parser"
                                                  "@vitest/ui"
                                                  "eslint"
                                                  "eslint-config-prettier"
                                                  "eslint-plugin-prettier"
                                                  "eslint-plugin-prettier-doc"
                                                  "rollup"
                                                  "tslib"
                                                  "typescript"
                                                  "vitest"
                                                  "vite"))))))))
    (inputs (list node-sass-formatter-0.7.9 node-prettier-3.8.3
                  node-astrojs-compiler-2.13.1))
    (home-page "https://github.com/withastro/prettier-plugin-astro/")
    (synopsis "A Prettier Plugin for formatting Astro files")
    (description "A Prettier Plugin for formatting Astro files")
    (license license:expat)))

(define-public node-astrojs-compiler-2.13.1
  (package
    (name "node-astrojs-compiler")
    (version "2.13.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@astrojs/compiler/-/compiler-2.13.1.tgz")
       (sha256
        (base32 "023fg6i6hn7cvz22vxl4kk1wb9w9h9vhka131p7v88vqwlqqvryi"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("tsup" "acorn"
                                                  "esbuild"
                                                  "typescript"
                                                  "@types/node"
                                                  "@types/sass"
                                                  "@jridgewell/trace-mapping"))))))))
    (home-page "https://astro.build")
    (synopsis "Astro's [Go](https://golang.org/) + WASM compiler.")
    (description "Astro's [Go](https://golang.org/) + WASM compiler.")
    (license license:expat)))

(define-public node-yaml-2.8.4
  (package
    (name "node-yaml")
    (version "2.8.4")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/yaml/-/yaml-2.8.4.tgz")
       (sha256
        (base32 "14j0z4w6w6nqnis95bpan84xc3isn87a8ixgqhhlsb479g3cdavb"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("jest" "tslib"
                                                  "eslint"
                                                  "rollup"
                                                  "prettier"
                                                  "@eslint/js"
                                                  "babel-jest"
                                                  "fast-check"
                                                  "typescript"
                                                  "@babel/core"
                                                  "@types/jest"
                                                  "@types/node"
                                                  "jest-resolve"
                                                  "@babel/preset-env"
                                                  "typescript-eslint"
                                                  "@rollup/plugin-babel"
                                                  "@rollup/plugin-replace"
                                                  "eslint-config-prettier"
                                                  "@rollup/plugin-typescript"
                                                  "jest-ts-webcompat-resolver"
                                                  "@babel/plugin-transform-typescript"))))))))
    (home-page "https://eemeli.org/yaml/")
    (synopsis "JavaScript parser and stringifier for YAML")
    (description "JavaScript parser and stringifier for YAML")
    (license license:isc)))

(define-public node-astrojs-yaml2ts-0.2.3
  (package
    (name "node-astrojs-yaml2ts")
    (version "0.2.3")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/@astrojs/yaml2ts/-/yaml2ts-0.2.3.tgz")
       (sha256
        (base32 "01navy9iyfdwp2044n2797nhb0yhiqvpa7rsgifn4sadi5crks10"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@volar/language-core"
                                                  "typescript"))))))))
    (inputs (list node-yaml-2.8.4))
    (home-page "https://github.com/withastro/astro#readme")
    (synopsis
     "Package to convert a YAML string to a Volar VirtualCode, to be used by the Astro language server to provide intellisense")
    (description
     "Package to convert a YAML string to a Volar VirtualCode, to be used by the Astro language server to provide intellisense")
    (license license:expat)))

(define-public node-jridgewell-sourcemap-codec-1.5.5
  (package
    (name "node-jridgewell-sourcemap-codec")
    (version "1.5.5")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@jridgewell/sourcemap-codec/-/sourcemap-codec-1.5.5.tgz")
       (sha256
        (base32 "11b5h4hihb2n8203znalqm53s7pv82a84jahsqgf7rd2406kpba7"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (home-page
     "https://github.com/jridgewell/sourcemaps/tree/main/packages/sourcemap-codec")
    (synopsis "Encode/decode sourcemap mappings")
    (description "Encode/decode sourcemap mappings")
    (license license:expat)))

(define-public node-typescript-6.0.3
  (package
    (name "node-typescript")
    (version "6.0.3")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/typescript/-/typescript-6.0.3.tgz")
       (sha256
        (base32 "0anjcm0xk05wkls2sz1dlhs4rsnxc9n87nm92nfrx35apvhhxk9k"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@dprint/formatter"
                                                  "@dprint/typescript"
                                                  "@esfx/canceltoken"
                                                  "@eslint/js"
                                                  "@octokit/rest"
                                                  "@types/chai"
                                                  "@types/minimist"
                                                  "@types/mocha"
                                                  "@types/ms"
                                                  "@types/node"
                                                  "@types/source-map-support"
                                                  "@types/which"
                                                  "@typescript-eslint/rule-tester"
                                                  "@typescript-eslint/type-utils"
                                                  "@typescript-eslint/utils"
                                                  "azure-devops-node-api"
                                                  "c8"
                                                  "chai"
                                                  "chokidar"
                                                  "diff"
                                                  "dprint"
                                                  "esbuild"
                                                  "eslint"
                                                  "eslint-plugin-regexp"
                                                  "fast-xml-parser"
                                                  "glob"
                                                  "globals"
                                                  "hereby"
                                                  "jsonc-parser"
                                                  "knip"
                                                  "minimist"
                                                  "mocha"
                                                  "mocha-fivemat-progress-reporter"
                                                  "monocart-coverage-reports"
                                                  "ms"
                                                  "picocolors"
                                                  "playwright"
                                                  "source-map-support"
                                                  "tslib"
                                                  "typescript"
                                                  "typescript-eslint"
                                                  "which"))))))))
    (home-page "https://www.typescriptlang.org/")
    (synopsis
     "TypeScript is a language for application scale JavaScript development")
    (description
     "TypeScript is a language for application scale JavaScript development")
    (license license:asl2.0)))

(define-public node-typesafe-path-0.2.2
  (package
    (name "node-typesafe-path")
    (version "0.2.2")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/typesafe-path/-/typesafe-path-0.2.2.tgz")
       (sha256
        (base32 "121l504hdyl6yip0hb2r91wpii62dmh92nwyb63f2p63rw88q7wx"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/node" "typescript"))))))))
    (home-page "https://github.com/johnsoncodehk/typesafe-path#readme")
    (synopsis
     "This library is aim to explicitly annotate path format of the code, and throwing error when passing incorrect format paths.")
    (description
     "This library is aim to explicitly annotate path format of the code, and throwing error when passing incorrect format paths.")
    (license license:expat)))

(define-public node-volar-kit-2.4.28
  (package
    (name "node-volar-kit")
    (version "2.4.28")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/@volar/kit/-/kit-2.4.28.tgz")
       (sha256
        (base32 "05n582ksk62g5gxq9hw79wv5h4wvy0dsszk0fml8swk238502lbm"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("typescript"))))))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-languageserver-textdocument-1.0.12
                  node-typesafe-path-0.2.2
                  node-volar-typescript-2.4.28
                  node-volar-language-service-2.4.28
                  node-typescript-6.0.3))
    (home-page "https://github.com/volarjs/volar.js#readme")
    (synopsis
     "```ts import * as fs from 'fs'; import * as path from 'path'; import { watch } from 'chokidar'; import * as kit from '@volar/kit';")
    (description
     "```ts import * as fs from 'fs'; import * as path from 'path'; import { watch } from 'chokidar'; import * as kit from '@volar/kit';")
    (license license:expat)))

(define-public node-volar-typescript-2.4.28
  (package
    (name "node-volar-typescript")
    (version "2.4.28")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@volar/typescript/-/typescript-2.4.28.tgz")
       (sha256
        (base32 "0sp9bil74n2y35l9hj3pn40232plwnzlr34vd9ij3nk75kmwi7s8"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/path-browserify"
                                                  "@volar/language-service"))))))))
    (inputs (list node-vscode-uri-3.1.0 node-path-browserify-1.0.1
                  node-volar-language-core-2.4.28))
    (home-page "https://github.com/volarjs/volar.js#readme")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public node-request-light-0.7.0
  (package
    (name "node-request-light")
    (version "0.7.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/request-light/-/request-light-0.7.0.tgz")
       (sha256
        (base32 "1rdchn9f57b3cixsgsaz2rrbcq772w2g1w681gzrw7icl46hvmhm"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("ava" "proxy"
                                                  "rimraf"
                                                  "webpack"
                                                  "ts-loader"
                                                  "typescript"
                                                  "vscode-nls"
                                                  "@types/node"
                                                  "webpack-cli"
                                                  "vscode-jsonrpc"
                                                  "http-proxy-agent"
                                                  "https-proxy-agent"))))))))
    (home-page "https://github.com/microsoft/node-request-light#readme")
    (synopsis
     "Lightweight request library. Promise based, with proxy support.")
    (description
     "Lightweight request library. Promise based, with proxy support.")
    (license license:expat)))

(define-public node-volar-language-server-2.4.28
  (package
    (name "node-volar-language-server")
    (version "2.4.28")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@volar/language-server/-/language-server-2.4.28.tgz")
       (sha256
        (base32 "1crn4q4qvrqdxk4r5zm975j8dnznm436mldl8ff5wkpr41dil8za"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/path-browserify"))))))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-languageserver-protocol-3.17.5
                  node-vscode-languageserver-9.0.1
                  node-request-light-0.7.0
                  node-path-browserify-1.0.1
                  node-volar-typescript-2.4.28
                  node-volar-language-service-2.4.28
                  node-volar-language-core-2.4.28))
    (home-page "https://github.com/volarjs/volar.js#readme")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public node-muggle-string-0.4.1
  (package
    (name "node-muggle-string")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/muggle-string/-/muggle-string-0.4.1.tgz")
       (sha256
        (base32 "0rw04xcf7fakicpq4nfnm5xbd556mylsp6cr2c41r661gkp1aqv2"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("typescript" "vitest" "vite"))))))))
    (home-page "https://github.com/johnsoncodehk/muggle-string#readme")
    (synopsis
     "This library aims to provide codegen helpers and data structure for Vue language plugin API v1.x that does not depend on Volar runtime.")
    (description
     "This library aims to provide codegen helpers and data structure for Vue language plugin API v1.x that does not depend on Volar runtime.")
    (license license:expat)))

(define-public node-fdir-6.5.0
  (package
    (name "node-fdir")
    (version "6.5.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/fdir/-/fdir-6.5.0.tgz")
       (sha256
        (base32 "0pin1ngw51v3z7q8gs4q84bwwcw3pdyh29jk8351yahyygcxq794"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/glob"
                                                  "@types/mock-fs"
                                                  "@types/node"
                                                  "@types/picomatch"
                                                  "@types/tap"
                                                  "@vitest/coverage-v8"
                                                  "all-files-in-tree"
                                                  "benny"
                                                  "csv-to-markdown-table"
                                                  "expect"
                                                  "fast-glob"
                                                  "fdir1"
                                                  "fdir2"
                                                  "fdir3"
                                                  "fdir4"
                                                  "fdir5"
                                                  "fs-readdir-recursive"
                                                  "get-all-files"
                                                  "glob"
                                                  "klaw-sync"
                                                  "mock-fs"
                                                  "picomatch"
                                                  "prettier"
                                                  "recur-readdir"
                                                  "recursive-files"
                                                  "recursive-fs"
                                                  "recursive-readdir"
                                                  "rrdir"
                                                  "systeminformation"
                                                  "tiny-glob"
                                                  "ts-node"
                                                  "tsdown"
                                                  "typescript"
                                                  "vitest"
                                                  "walk-sync"))))))))
    (home-page "https://github.com/thecodrr/fdir#readme")
    (synopsis
     "The fastest directory crawler & globbing alternative to glob, fast-glob, & tiny-glob. Crawls 1m files in < 1s")
    (description
     "The fastest directory crawler & globbing alternative to glob, fast-glob, & tiny-glob. Crawls 1m files in < 1s")
    (license license:expat)))

(define-public node-picomatch-4.0.4
  (package
    (name "node-picomatch")
    (version "4.0.4")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/picomatch/-/picomatch-4.0.4.tgz")
       (sha256
        (base32 "072pg3ji6ib0ns6jv3ypink59pmfj8432fj82yhxk3jmcsv5lnsi"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("nyc" "mocha" "eslint"
                                                  "fill-range"
                                                  "gulp-format-md"))))))))
    (home-page "https://github.com/micromatch/picomatch")
    (synopsis
     "Blazing fast and accurate glob matcher written in JavaScript, with no dependencies and full support for standard and extended Bash glob features, including braces, extglobs, POSIX brackets, and regular expressions.")
    (description
     "Blazing fast and accurate glob matcher written in JavaScript, with no dependencies and full support for standard and extended Bash glob features, including braces, extglobs, POSIX brackets, and regular expressions.")
    (license license:expat)))

(define-public node-tinyglobby-0.2.16
  (package
    (name "node-tinyglobby")
    (version "0.2.16")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/tinyglobby/-/tinyglobby-0.2.16.tgz")
       (sha256
        (base32 "010lkihfjgsqy47vglzsv7prkwwlmbxhg4sin216wwg85pny1mg7"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@biomejs/biome"
                                                  "@types/node"
                                                  "@types/picomatch"
                                                  "fast-glob"
                                                  "fs-fixture"
                                                  "glob"
                                                  "tinybench"
                                                  "tsdown"
                                                  "typescript"))))))))
    (inputs (list node-picomatch-4.0.4 node-fdir-6.5.0))
    (home-page "https://superchupu.dev/tinyglobby")
    (synopsis "A fast and minimal alternative to globby and fast-glob")
    (description "A fast and minimal alternative to globby and fast-glob")
    (license license:expat)))

(define-public node-vscode-css-languageservice-6.3.10
  (package
    (name "node-vscode-css-languageservice")
    (version "6.3.10")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-css-languageservice/-/vscode-css-languageservice-6.3.10.tgz")
       (sha256
        (base32 "0j4lzjgplamikm9w4c7w54g718r4h9549m8pikq8v6ragd5gzpvm"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("mocha" "eslint"
                                                  "rimraf"
                                                  "typescript"
                                                  "@types/node"
                                                  "js-beautify"
                                                  "@types/mocha"
                                                  "source-map-support"
                                                  "@vscode/web-custom-data"
                                                  "@typescript-eslint/parser"
                                                  "@typescript-eslint/eslint-plugin"))))))))
    (inputs (list node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-languageserver-types-3.17.5
                  node-vscode-l10n-0.0.18 node-vscode-uri-3.1.0))
    (home-page
     "https://github.com/Microsoft/vscode-css-languageservice#readme")
    (synopsis "Language service for CSS, LESS and SCSS")
    (description "Language service for CSS, LESS and SCSS")
    (license license:expat)))

(define-public node-volar-service-css-0.0.70
  (package
    (name "node-volar-service-css")
    (version "0.0.70")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/volar-service-css/-/volar-service-css-0.0.70.tgz")
       (sha256
        (base32 "1i82fmznld9y513h8g9lmbilhza5w682yw67x40jrahz2jqpyxg2"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/node"
                                                  "@volar/language-service"))))))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-css-languageservice-6.3.10
                  node-volar-language-service-2.4.28))
    (home-page "https://github.com/volarjs/services/tree/master/packages/css")
    (synopsis "Integrate vscode-css-languageservice into Volar")
    (description "Integrate vscode-css-languageservice into Volar")
    (license license:expat)))

(define-public node-emmetio-stream-reader-2.2.0
  (package
    (name "node-emmetio-stream-reader")
    (version "2.2.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@emmetio/stream-reader/-/stream-reader-2.2.0.tgz")
       (sha256
        (base32 "1g2wkpaqdh5cw2blcxl6nb9f87z79d8a408s577cf5k4l6m5n7ly"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("babel-plugin-transform-es2015-modules-commonjs"
                                                  "babel-register" "mocha"
                                                  "rollup"))))))))
    (home-page "https://github.com/emmetio/stream-reader#readme")
    (synopsis "Reads text as stream")
    (description "Reads text as stream")
    (license license:expat)))

(define-public node-emmetio-stream-reader-utils-0.1.0
  (package
    (name "node-emmetio-stream-reader-utils")
    (version "0.1.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@emmetio/stream-reader-utils/-/stream-reader-utils-0.1.0.tgz")
       (sha256
        (base32 "047kja6fbrgwkhbgqscjylia75m75zp13fl78kdwczc2w62vv832"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@emmetio/stream-reader"
                                                  "babel-plugin-transform-es2015-modules-commonjs"
                                                  "babel-register" "mocha"
                                                  "rollup" "rollup-watch"))))))))
    (home-page "https://github.com/emmetio/stream-reader-utils#readme")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public node-emmetio-css-parser-0.4.1
  (package
    (name "node-emmetio-css-parser")
    (version "0.4.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@emmetio/css-parser/-/css-parser-0.4.1.tgz")
       (sha256
        (base32 "1nymfkddrn3rzhv9dsq33cyzvlxbyhshlli1nnpk0qf5vzglf65j"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("babel-plugin-transform-es2015-modules-commonjs"
                                                  "babel-register" "mocha"
                                                  "rollup"
                                                  "rollup-plugin-node-resolve"
                                                  "rollup-watch"))))))))
    (inputs (list node-emmetio-stream-reader-utils-0.1.0
                  node-emmetio-stream-reader-2.2.0))
    (home-page "https://github.com/emmetio/css-parser#readme")
    (synopsis "CSS/LESS/SCSS fast and minimalistic parser")
    (description "CSS/LESS/SCSS fast and minimalistic parser")
    (license license:expat)))

(define-public node-emmetio-abbreviation-2.3.3
  (package
    (name "node-emmetio-abbreviation")
    (version "2.3.3")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@emmetio/abbreviation/-/abbreviation-2.3.3.tgz")
       (sha256
        (base32 "1f3nvnp2b107sf1assi6hfa6yh1nsbbqbrvivn8n6zv6yfc8bgq4"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@rollup/plugin-typescript"
                                                  "@types/mocha"
                                                  "@types/node"
                                                  "mocha"
                                                  "rimraf"
                                                  "rollup"
                                                  "ts-node"
                                                  "typescript"))))))))
    (inputs (list node-emmetio-scanner-1.0.4))
    (home-page "https://github.com/emmetio/emmet#readme")
    (synopsis "Emmet standalone abbreviation parser")
    (description "Emmet standalone abbreviation parser")
    (license license:expat)))

(define-public node-emmetio-css-abbreviation-2.1.8
  (package
    (name "node-emmetio-css-abbreviation")
    (version "2.1.8")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@emmetio/css-abbreviation/-/css-abbreviation-2.1.8.tgz")
       (sha256
        (base32 "0fr22mcgag9sbr68pkyzzg3m4bw74456faa8wrap9g3q49811pzb"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@rollup/plugin-typescript"
                                                  "@types/mocha"
                                                  "@types/node"
                                                  "mocha"
                                                  "rimraf"
                                                  "rollup"
                                                  "ts-node"
                                                  "typescript"))))))))
    (inputs (list node-emmetio-scanner-1.0.4))
    (home-page "https://github.com/emmetio/emmet#readme")
    (synopsis "Parses Emmet CSS abbreviation into AST tree")
    (description "Parses Emmet CSS abbreviation into AST tree")
    (license license:expat)))

(define-public node-emmet-2.4.11
  (package
    (name "node-emmet")
    (version "2.4.11")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/emmet/-/emmet-2.4.11.tgz")
       (sha256
        (base32 "080gg0187a7mfdg8i1g46vg3jpsvm3bl0zp3qllja2bkv727m1hi"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare"))
                                          #:strict? #f)
                           (delete-dependencies '("@rollup/plugin-node-resolve"
                                                  "@rollup/plugin-typescript"
                                                  "@types/node"
                                                  "lerna"
                                                  "rimraf"
                                                  "rollup"
                                                  "tsx"
                                                  "typescript"))))))))
    (inputs (list node-emmetio-css-abbreviation-2.1.8
                  node-emmetio-abbreviation-2.3.3))
    (home-page "https://github.com/emmetio/emmet#readme")
    (synopsis "Emmet - the essential toolkit for web-developers")
    (description "Emmet - the essential toolkit for web-developers")
    (license license:expat)))

(define-public node-jsonc-parser-2.3.1
  (package
    (name "node-jsonc-parser")
    (version "2.3.1")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/jsonc-parser/-/jsonc-parser-2.3.1.tgz")
       (sha256
        (base32 "135by7iq337mzybb25gwmmcdcc4nrymgcqbnchxcmgyhh5i15a5h"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("mocha" "eslint"
                                                  "rimraf"
                                                  "typescript"
                                                  "@types/node"
                                                  "@types/mocha"
                                                  "@typescript-eslint/parser"
                                                  "@typescript-eslint/eslint-plugin"))))))))
    (home-page "https://github.com/microsoft/node-jsonc-parser#readme")
    (synopsis "Scanner and parser for JSON with comments.")
    (description "Scanner and parser for JSON with comments.")
    (license license:expat)))

(define-public node-vscode-emmet-helper-2.11.0
  (package
    (name "node-vscode-emmet-helper")
    (version "2.11.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@vscode/emmet-helper/-/emmet-helper-2.11.0.tgz")
       (sha256
        (base32 "1qkv9clr963qf994v84ijdhx1qwvkk49ldgzdpb82d31w43km427"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/mocha" "@types/node"
                                                  "@types/vscode" "mocha"
                                                  "typescript"))))))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-languageserver-types-3.17.5
                  node-vscode-languageserver-textdocument-1.0.12
                  node-jsonc-parser-2.3.1 node-emmet-2.4.11))
    (home-page "https://www.npmjs.com/package/node-vscode-emmet-helper")
    (synopsis "Helper to use emmet modules in Visual Studio Code")
    (description "Helper to use emmet modules in Visual Studio Code")
    (license license:expat)))

(define-public node-emmetio-scanner-1.0.4
  (package
    (name "node-emmetio-scanner")
    (version "1.0.4")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/@emmetio/scanner/-/scanner-1.0.4.tgz")
       (sha256
        (base32 "1jdck44dzfz0yq2qvmighpcf0m71mky3biazra61xg1an98ap6hy"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@rollup/plugin-typescript"
                                                  "@types/mocha"
                                                  "@types/node"
                                                  "mocha"
                                                  "rimraf"
                                                  "rollup"
                                                  "ts-node"
                                                  "typescript"))))))))
    (home-page "https://github.com/emmetio/emmet#readme")
    (synopsis "Scans given text character-by-character")
    (description "Scans given text character-by-character")
    (license license:expat)))

(define-public node-emmetio-html-matcher-1.3.0
  (package
    (name "node-emmetio-html-matcher")
    (version "1.3.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@emmetio/html-matcher/-/html-matcher-1.3.0.tgz")
       (sha256
        (base32 "0abafk4asg06hsaa521mqxa4jwvlspc643lysqh4p886ycpdnwch"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/mocha" "@types/node"
                                                  "mocha"
                                                  "rollup"
                                                  "rollup-plugin-node-resolve"
                                                  "rollup-plugin-typescript2"
                                                  "ts-node"
                                                  "tslint"
                                                  "typescript"))))))))
    (inputs (list node-emmetio-scanner-1.0.4))
    (home-page "https://github.com/emmetio/html-matcher#readme")
    (synopsis "Minimalistic and ultra-fast HTML parser & matcher")
    (description "Minimalistic and ultra-fast HTML parser & matcher")
    (license license:isc)))

(define-public node-volar-service-emmet-0.0.70
  (package
    (name "node-volar-service-emmet")
    (version "0.0.70")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/volar-service-emmet/-/volar-service-emmet-0.0.70.tgz")
       (sha256
        (base32 "17rbl3znyn737z2rw1xhprq7sr1wfivlwdk86iyfjix9rspxyqd2"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/node"
                                                  "@volar/language-service"))))))))
    (inputs (list node-emmetio-html-matcher-1.3.0
                  node-vscode-emmet-helper-2.11.0
                  node-emmetio-css-parser-0.4.1 node-vscode-uri-3.1.0
                  node-volar-language-service-2.4.28))
    (home-page
     "https://github.com/volarjs/services/tree/master/packages/emmet")
    (synopsis "Integrate @vscode/emmet-helper into Volar")
    (description "Integrate @vscode/emmet-helper into Volar")
    (license license:expat)))

(define-public node-volar-service-html-0.0.70
  (package
    (name "node-volar-service-html")
    (version "0.0.70")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/volar-service-html/-/volar-service-html-0.0.70.tgz")
       (sha256
        (base32 "1nb7il024f9nzasgsn0pw4syz0fxmpfcrfs3l68p8bhhwav2ph55"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/node"
                                                  "@volar/language-service"))))))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-html-languageservice-5.6.2
                  node-volar-language-service-2.4.28))
    (home-page "https://github.com/volarjs/services/tree/master/packages/html")
    (synopsis "Integrate vscode-languageservice-html into Volar")
    (description "Integrate vscode-languageservice-html into Volar")
    (license license:expat)))

(define-public node-volar-service-prettier-0.0.70
  (package
    (name "node-volar-service-prettier")
    (version "0.0.70")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/volar-service-prettier/-/volar-service-prettier-0.0.70.tgz")
       (sha256
        (base32 "0lfj5a6hfjpx3lhg83gdmvvajsnlpsqqpxmrqdxwjsl5csqi9rq4"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/node" "prettier"
                                                  "@volar/language-service"))))))))
    (inputs (list node-vscode-uri-3.1.0 node-prettier-3.8.3
                  node-volar-language-service-2.4.28))
    (home-page
     "https://github.com/volarjs/services/tree/master/packages/prettier")
    (synopsis "Integrate Prettier into Volar")
    (description "Integrate Prettier into Volar")
    (license license:expat)))

(define-public node-path-browserify-1.0.1
  (package
    (name "node-path-browserify")
    (version "1.0.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/path-browserify/-/path-browserify-1.0.1.tgz")
       (sha256
        (base32 "0ggrp0bhy58j19j1gd87az58w8y3jn0d960pgg8n3jzqqrjnkbbl"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("tape"))))))))
    (home-page "https://github.com/browserify/path-browserify")
    (synopsis "the path module from node core for browsers")
    (description "the path module from node core for browsers")
    (license license:expat)))

(define-public node-semver-7.7.4
  (package
    (name "node-semver")
    (version "7.7.4")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/semver/-/semver-7.7.4.tgz")
       (sha256
        (base32 "1321x4pnc5cvfxkmlinc013kn43rn0yxrf69j1khwc7yik87l9h9"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("tap" "benchmark"
                                                  "@npmcli/template-oss"
                                                  "@npmcli/eslint-config"))))))))
    (home-page "https://github.com/npm/node-semver#readme")
    (synopsis "The semantic version parser used by npm.")
    (description "The semantic version parser used by npm.")
    (license license:isc)))

(define-public node-typescript-auto-import-cache-0.3.6
  (package
    (name "node-typescript-auto-import-cache")
    (version "0.3.6")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/typescript-auto-import-cache/-/typescript-auto-import-cache-0.3.6.tgz")
       (sha256
        (base32 "0zm1nrkv1vydrs7mak4n1k0m8mkgqv695wa5c60nzf44gki48iac"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/semver" "typescript"))))))))
    (inputs (list node-semver-7.7.4))
    (home-page
     "https://github.com/volarjs/typescript-auto-import-cache#readme")
    (synopsis
     "TypeScript Language Service Completion API is slow when calculate auto-import.")
    (description
     "TypeScript Language Service Completion API is slow when calculate auto-import.")
    (license license:expat)))

(define-public node-volar-service-typescript-0.0.70
  (package
    (name "node-volar-service-typescript")
    (version "0.0.70")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/volar-service-typescript/-/volar-service-typescript-0.0.70.tgz")
       (sha256
        (base32 "1nyr25ny9y1jkciqv53vghscccgpm08pyzg8ydidlnypf4ybf0pb"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/path-browserify"
                                                  "@types/semver"
                                                  "@volar/typescript"
                                                  "@volar/language-service"))))))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-nls-5.2.0
                  node-vscode-languageserver-textdocument-1.0.12
                  node-typescript-auto-import-cache-0.3.6
                  node-semver-7.7.4
                  node-path-browserify-1.0.1
                  node-volar-language-service-2.4.28))
    (home-page
     "https://github.com/volarjs/services/tree/master/packages/typescript")
    (synopsis "Integrate TypeScript into Volar")
    (description "Integrate TypeScript into Volar")
    (license license:expat)))

(define-public node-volar-service-typescript-twoslash-queries-0.0.70
  (package
    (name "node-volar-service-typescript-twoslash-queries")
    (version "0.0.70")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/volar-service-typescript-twoslash-queries/-/volar-service-typescript-twoslash-queries-0.0.70.tgz")
       (sha256
        (base32 "0mdgf7r2lhyca9d5d2sjdx0dc6w02l1635ac6dzl832nwqrrirvw"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("volar-service-typescript"
                                                  "@volar/language-service"))))))))
    (inputs (list node-vscode-uri-3.1.0 node-volar-language-service-2.4.28))
    (home-page
     "https://github.com/volarjs/services/tree/master/packages/typescript-twoslash-queries")
    (synopsis "Integrate TypeScript Twoslash into Volar")
    (description "Integrate TypeScript Twoslash into Volar")
    (license license:expat)))

(define-public node-volar-source-map-2.4.28
  (package
    (name "node-volar-source-map")
    (version "2.4.28")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@volar/source-map/-/source-map-2.4.28.tgz")
       (sha256
        (base32 "19kicv609j8ff1sli2xpw0am793i34cc4g7zmkaay13s00da4g05"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (home-page "https://github.com/volarjs/volar.js#readme")
    (synopsis "Provides functionality related to source maps.")
    (description "Provides functionality related to source maps.")
    (license license:expat)))

(define-public node-volar-language-core-2.4.28
  (package
    (name "node-volar-language-core")
    (version "2.4.28")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@volar/language-core/-/language-core-2.4.28.tgz")
       (sha256
        (base32 "11ljrz1wncsl2xb5zx3xamawdb8ffjp812h6gapra6kljzba4d4n"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (inputs (list node-volar-source-map-2.4.28))
    (home-page "https://github.com/volarjs/volar.js#readme")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public node-volar-language-service-2.4.28
  (package
    (name "node-volar-language-service")
    (version "2.4.28")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@volar/language-service/-/language-service-2.4.28.tgz")
       (sha256
        (base32 "0r59xvcwnhp4jss1mhnrxh56plcwg6ra1bn11cicjjpw9n1kn81a"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-languageserver-protocol-3.17.5
                  node-volar-language-core-2.4.28))
    (home-page "https://github.com/volarjs/volar.js#readme")
    (synopsis "")
    (description "")
    (license license:expat)))

(define-public node-yaml-2.7.1
  (package
    (name "node-yaml")
    (version "2.7.1")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/yaml/-/yaml-2.7.1.tgz")
       (sha256
        (base32 "1h5227adkbpk75dv12xv07zg62vbn54kf3icn6bn5mi1cpvnd77b"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("jest" "tslib"
                                                  "eslint"
                                                  "rollup"
                                                  "prettier"
                                                  "cross-env"
                                                  "@eslint/js"
                                                  "babel-jest"
                                                  "fast-check"
                                                  "typescript"
                                                  "@babel/core"
                                                  "@types/jest"
                                                  "@types/node"
                                                  "@babel/preset-env"
                                                  "typescript-eslint"
                                                  "@rollup/plugin-babel"
                                                  "@rollup/plugin-replace"
                                                  "eslint-config-prettier"
                                                  "@rollup/plugin-typescript"
                                                  "jest-ts-webcompat-resolver"
                                                  "@babel/plugin-transform-typescript"))))))))
    (home-page "https://eemeli.org/yaml/")
    (synopsis "JavaScript parser and stringifier for YAML")
    (description "JavaScript parser and stringifier for YAML")
    (license license:isc)))

(define-public node-prettier-3.8.3
  (package
    (name "node-prettier")
    (version "3.8.3")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/prettier/-/prettier-3.8.3.tgz")
       (sha256
        (base32 "1phgk25wl0ir84a6jfwz01l73m19z6r0apl8q6xg2rkk3gkm1a68"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (home-page "https://prettier.io")
    (synopsis "Prettier is an opinionated code formatter")
    (description "Prettier is an opinionated code formatter")
    (license license:expat)))

(define-public node-fast-deep-equal-3.1.3
  (package
    (name "node-fast-deep-equal")
    (version "3.1.3")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/fast-deep-equal/-/fast-deep-equal-3.1.3.tgz")
       (sha256
        (base32 "13vvwib6za4zh7054n3fg86y127ig3jb0djqz31qsqr71yca06dh"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("coveralls" "dot"
                                                  "eslint"
                                                  "mocha"
                                                  "nyc"
                                                  "pre-commit"
                                                  "react"
                                                  "react-test-renderer"
                                                  "sinon"
                                                  "typescript"))))))))
    (home-page "https://github.com/epoberezkin/fast-deep-equal#readme")
    (synopsis "Fast deep equal")
    (description "Fast deep equal")
    (license license:expat)))

(define-public node-fast-uri-3.1.2
  (package
    (name "node-fast-uri")
    (version "3.1.2")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/fast-uri/-/fast-uri-3.1.2.tgz")
       (sha256
        (base32 "0hy16g7i9f5yw6spsl90fh2gygl7h17kr9hvg28sp3gz07ly7zlk"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("ajv" "eslint" "neostandard"
                                                  "playwright-test" "tape"
                                                  "tsd"))))))))
    (home-page "https://github.com/fastify/fast-uri")
    (synopsis "Dependency-free RFC 3986 URI toolbox")
    (description "Dependency-free RFC 3986 URI toolbox")
    (license license:bsd-3)))

(define-public node-json-schema-traverse-1.0.0
  (package
    (name "node-json-schema-traverse")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/json-schema-traverse/-/json-schema-traverse-1.0.0.tgz")
       (sha256
        (base32 "08cvg5wysj4r0ax2lvhx7j74l7da8w75klz5pmsc57zj5mi24ch2"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("eslint" "mocha" "nyc"
                                                  "pre-commit"))))))))
    (home-page "https://github.com/epoberezkin/json-schema-traverse#readme")
    (synopsis "Traverse JSON Schema passing each schema object to callback")
    (description "Traverse JSON Schema passing each schema object to callback")
    (license license:expat)))

(define-public node-require-from-string-2.0.2
  (package
    (name "node-require-from-string")
    (version "2.0.2")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/require-from-string/-/require-from-string-2.0.2.tgz")
       (sha256
        (base32 "10ldp2bzb86czf47kmvirn9x2976yh6g0my7l1spg3whcm4llsfb"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("mocha"))))))))
    (home-page "https://github.com/floatdrop/require-from-string#readme")
    (synopsis "Require module from string")
    (description "Require module from string")
    (license license:expat)))

(define-public node-ajv-8.20.0
  (package
    (name "node-ajv")
    (version "8.20.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/ajv/-/ajv-8.20.0.tgz")
       (sha256
        (base32 "1cz7yr42yf4kb0znhwyxslqrxqcr2j5z0538zdgcrf5vjflb7w5j"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@ajv-validator/config"
                                                  "@rollup/plugin-commonjs"
                                                  "@rollup/plugin-json"
                                                  "@rollup/plugin-node-resolve"
                                                  "@rollup/plugin-typescript"
                                                  "@types/chai"
                                                  "@types/mocha"
                                                  "@types/node"
                                                  "@types/require-from-string"
                                                  "@typescript-eslint/eslint-plugin"
                                                  "@typescript-eslint/parser"
                                                  "ajv-formats"
                                                  "browserify"
                                                  "chai"
                                                  "cross-env"
                                                  "dayjs"
                                                  "dayjs-plugin-utc"
                                                  "eslint"
                                                  "eslint-config-prettier"
                                                  "glob"
                                                  "husky"
                                                  "jimp"
                                                  "js-beautify"
                                                  "json-schema-test"
                                                  "karma"
                                                  "karma-chrome-launcher"
                                                  "karma-mocha"
                                                  "lint-staged"
                                                  "mocha"
                                                  "module-from-string"
                                                  "node-fetch"
                                                  "nyc"
                                                  "prettier"
                                                  "re2"
                                                  "rollup"
                                                  "rollup-plugin-terser"
                                                  "ts-node"
                                                  "tsify"
                                                  "typescript"
                                                  "uri-js"))))))))
    (inputs (list node-require-from-string-2.0.2
                  node-json-schema-traverse-1.0.0 node-fast-uri-3.1.2
                  node-fast-deep-equal-3.1.3))
    (home-page "https://ajv.js.org")
    (synopsis "Another JSON Schema Validator")
    (description "Another JSON Schema Validator")
    (license license:expat)))

(define-public node-ajv-draft-04-1.0.0
  (package
    (name "node-ajv-draft-04")
    (version "1.0.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/ajv-draft-04/-/ajv-draft-04-1.0.0.tgz")
       (sha256
        (base32 "1ry2341w27h9av009j8kb5mxhknk5l67g2c714x1nnrskg7qlcmj"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@ajv-validator/config"
                                                  "@types/jest"
                                                  "@types/node"
                                                  "@typescript-eslint/eslint-plugin"
                                                  "@typescript-eslint/parser"
                                                  "ajv-formats"
                                                  "eslint"
                                                  "eslint-config-prettier"
                                                  "husky"
                                                  "jest"
                                                  "json-schema-test"
                                                  "lint-staged"
                                                  "prettier"
                                                  "ts-jest"
                                                  "typescript"
                                                  "ajv"))))))))
    (home-page "https://github.com/ajv-validator/ajv-draft-04#readme")
    (synopsis "Ajv class for JSON Schema draft-04")
    (description "Ajv class for JSON Schema draft-04")
    (license license:expat)))

(define-public node-request-light-0.5.8
  (package
    (name "node-request-light")
    (version "0.5.8")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/request-light/-/request-light-0.5.8.tgz")
       (sha256
        (base32 "1fbm8gr69sr9nx2bna7svpkf1jxs0kwsb900ncsn8185z944nvab"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("ava" "proxy"
                                                  "rimraf"
                                                  "webpack"
                                                  "ts-loader"
                                                  "typescript"
                                                  "vscode-nls"
                                                  "@types/node"
                                                  "webpack-cli"
                                                  "http-proxy-agent"
                                                  "https-proxy-agent"))))))))
    (home-page "https://github.com/microsoft/node-request-light#readme")
    (synopsis
     "Lightweight request library. Promise based, with proxy support.")
    (description
     "Lightweight request library. Promise based, with proxy support.")
    (license license:expat)))

(define-public node-vscode-jsonrpc-8.2.0
  (package
    (name "node-vscode-jsonrpc")
    (version "8.2.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.2.0.tgz")
       (sha256
        (base32 "1jy7p4l0fbzl8z472wdcz2wkabw2k8sqwwnbfi859wcqqcqlb91x"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("msgpack-lite"
                                                  "@types/msgpack-lite"))))))))
    (home-page
     "https://github.com/Microsoft/vscode-languageserver-node#readme")
    (synopsis "A json rpc implementation over streams")
    (description "A json rpc implementation over streams")
    (license license:expat)))

(define-public node-vscode-languageserver-protocol-3.17.5
  (package
    (name "node-vscode-languageserver-protocol")
    (version "3.17.5")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.5.tgz")
       (sha256
        (base32 "1j6cwf1yams1djad6rbbb5g1k6kq0gcgji4nl2zgiwv344nynwvl"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (inputs (list node-vscode-languageserver-types-3.17.5
                  node-vscode-jsonrpc-8.2.0))
    (home-page
     "https://github.com/Microsoft/vscode-languageserver-node#readme")
    (synopsis "VSCode Language Server Protocol implementation")
    (description "VSCode Language Server Protocol implementation")
    (license license:expat)))

(define-public node-vscode-languageserver-9.0.1
  (package
    (name "node-vscode-languageserver")
    (version "9.0.1")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-9.0.1.tgz")
       (sha256
        (base32 "04i4c100bsqmwy0rll0p6pjk5zkmjhadapnxlj4fawkqmriz9mvc"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("vscode-languageserver-textdocument"))))))))
    (inputs (list node-vscode-languageserver-protocol-3.17.5))
    (home-page
     "https://github.com/Microsoft/vscode-languageserver-node#readme")
    (synopsis "Language server implementation for node")
    (description "Language server implementation for node")
    (license license:expat)))

(define-public node-vscode-nls-5.2.0
  (package
    (name "node-vscode-nls")
    (version "5.2.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/vscode-nls/-/vscode-nls-5.2.0.tgz")
       (sha256
        (base32 "0yd7kkd6wif95acfp7d61gf17v92llch4xv95zzlwap5d8wra7s4"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/mocha" "@types/node"
                                                  "@typescript-eslint/parser"
                                                  "eslint"
                                                  "mocha"
                                                  "rimraf"
                                                  "typescript"))))))))
    (home-page "https://github.com/Microsoft/vscode-nls#readme")
    (synopsis "NPM module to externalize and localize VSCode extensions")
    (description "NPM module to externalize and localize VSCode extensions")
    (license license:expat)))

(define-public node-vscode-json-languageservice-4.1.8
  (package
    (name "node-vscode-json-languageservice")
    (version "4.1.8")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-json-languageservice/-/vscode-json-languageservice-4.1.8.tgz")
       (sha256
        (base32 "041nb74f79ayadvhsjzhi3yilmsf0hsd3wh4vp09047r2pjasb68"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("mocha" "eslint"
                                                  "rimraf"
                                                  "typescript"
                                                  "@types/node"
                                                  "@types/mocha"
                                                  "@typescript-eslint/parser"
                                                  "@typescript-eslint/eslint-plugin"))))))))
    (inputs (list node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-languageserver-types-3.17.5
                  node-jsonc-parser node-vscode-uri-3.1.0
                  node-vscode-nls-5.2.0))
    (home-page
     "https://github.com/Microsoft/vscode-json-languageservice#readme")
    (synopsis "Language service for JSON")
    (description "Language service for JSON")
    (license license:expat)))

(define-public node-yaml-language-server-1.20.0
  (package
    (name "node-yaml-language-server")
    (version "1.20.0")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/yaml-language-server/-/yaml-language-server-1.20.0.tgz")
       (sha256
        (base32 "1cadcsi9hpwwimvcbxnkmfpbk9s5zklgsbh2lwljf8hw2vqjmbb6"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("nyc" "chai"
                                                  "mocha"
                                                  "sinon"
                                                  "eslint"
                                                  "rimraf"
                                                  "ts-node"
                                                  "sinon-chai"
                                                  "typescript"
                                                  "@types/chai"
                                                  "@types/node"
                                                  "@types/mocha"
                                                  "@types/sinon"
                                                  "http-proxy-agent"
                                                  "@types/sinon-chai"
                                                  "https-proxy-agent"
                                                  "source-map-support"
                                                  "mocha-lcov-reporter"
                                                  "eslint-plugin-import"
                                                  "eslint-config-prettier"
                                                  "eslint-plugin-prettier"
                                                  "@typescript-eslint/parser"
                                                  "@typescript-eslint/eslint-plugin"
                                                  "@microsoft/eslint-formatter-sarif"))))))))
    (inputs (list node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-languageserver-types-3.17.5
                  node-vscode-json-languageservice-4.1.8
                  node-vscode-languageserver-9.0.1
                  node-request-light-0.5.8
                  node-ajv-draft-04-1.0.0
                  node-vscode-l10n-0.0.18
                  node-vscode-uri-3.1.0
                  node-prettier-3.8.3
                  node-yaml-2.7.1
                  node-ajv-8.20.0))
    (home-page
     "https://github.com/redhat-developer/yaml-language-server#readme")
    (synopsis "YAML language server")
    (description "YAML language server")
    (license license:expat)))

(define-public node-volar-service-yaml-0.0.70
  (package
    (name "node-volar-service-yaml")
    (version "0.0.70")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/volar-service-yaml/-/volar-service-yaml-0.0.70.tgz")
       (sha256
        (base32 "0fvd1mfiwnykqpkcrw8vhfrmzhprkfik7cj5y5djl13z45m69y7j"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("vscode-languageserver-textdocument"
                                                  "@volar/language-service"))))))))
    (inputs (list node-yaml-language-server-1.20.0 node-vscode-uri-3.1.0
                  node-volar-language-service-2.4.28))
    (home-page "https://github.com/volarjs/services/tree/master/packages/yaml")
    (synopsis "Integrate yaml-language-server into Volar")
    (description "Integrate yaml-language-server into Volar")
    (license license:expat)))

(define-public node-vscode-l10n-0.0.18
  (package
    (name "node-vscode-l10n")
    (version "0.0.18")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/@vscode/l10n/-/l10n-0.0.18.tgz")
       (sha256
        (base32 "0p3wxm8k570rah3mbjldgignlv2waagqc891nimmync8fj4xrhpi"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("jest" "eslint"
                                                  "rimraf"
                                                  "esbuild"
                                                  "mock-fs"
                                                  "ts-jest"
                                                  "typescript"
                                                  "@types/node"
                                                  "@jest/globals"
                                                  "@types/mock-fs"
                                                  "jest-fetch-mock"
                                                  "http-proxy-agent"
                                                  "https-proxy-agent"
                                                  "@microsoft/api-extractor"
                                                  "@typescript-eslint/parser"
                                                  "@typescript-eslint/eslint-plugin"))))))))
    (home-page "https://github.com/Microsoft/vscode-l10n#readme")
    (synopsis
     "A helper library to assist in localizing subprocesses spun up by VS Code extensions")
    (description
     "A helper library to assist in localizing subprocesses spun up by VS Code extensions")
    (license license:expat)))

(define-public node-vscode-languageserver-types-3.17.5
  (package
    (name "node-vscode-languageserver-types")
    (version "3.17.5")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.5.tgz")
       (sha256
        (base32 "1h6a173990rn6g36pf7bf2k9gynwshr8ziaipr8i7rdvz3kzjwyn"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (home-page
     "https://github.com/Microsoft/vscode-languageserver-node#readme")
    (synopsis "Types used by the Language server for node")
    (description "Types used by the Language server for node")
    (license license:expat)))

(define-public node-vscode-languageserver-textdocument-1.0.12
  (package
    (name "node-vscode-languageserver-textdocument")
    (version "1.0.12")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.12.tgz")
       (sha256
        (base32 "1nxhygxja2js6ih8kr3dxcihlsmv434whnrgymki5s3f9n0jh7cz"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build))))
    (home-page
     "https://github.com/Microsoft/vscode-languageserver-node#readme")
    (synopsis "A simple text document implementation for Node LSP servers")
    (description "A simple text document implementation for Node LSP servers")
    (license license:expat)))

(define-public node-vscode-html-languageservice-5.6.2
  (package
    (name "node-vscode-html-languageservice")
    (version "5.6.2")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/vscode-html-languageservice/-/vscode-html-languageservice-5.6.2.tgz")
       (sha256
        (base32 "0aijjjhqzwb8xyj64n2h7hh5yqrqf0q85n7n9iylvkx8kl1f86d5"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("mocha" "eslint"
                                                  "rimraf"
                                                  "typescript"
                                                  "@types/node"
                                                  "js-beautify"
                                                  "@types/mocha"
                                                  "@vscode/web-custom-data"
                                                  "@typescript-eslint/parser"
                                                  "@typescript-eslint/eslint-plugin"))))))))
    (inputs (list node-vscode-languageserver-textdocument-1.0.12
                  node-vscode-languageserver-types-3.17.5
                  node-vscode-l10n-0.0.18 node-vscode-uri-3.1.0))
    (home-page
     "https://github.com/Microsoft/vscode-html-languageservice#readme")
    (synopsis "Language service for HTML")
    (description "Language service for HTML")
    (license license:expat)))

(define-public node-vscode-uri-3.1.0
  (package
    (name "node-vscode-uri")
    (version "3.1.0")
    (source
     (origin
       (method url-fetch)
       (uri "https://registry.npmjs.org/vscode-uri/-/vscode-uri-3.1.0.tgz")
       (sha256
        (base32 "0m7w7kj30ixmm49d47070vvg3hh5mkav8gxji5rj6n28g8npbv66"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      #~(modify-phases %standard-phases
          (delete 'build)
          (add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("mocha" "rimraf"
                                                  "webpack"
                                                  "ts-loader"
                                                  "typescript"
                                                  "@types/node"
                                                  "webpack-cli"
                                                  "@types/mocha"
                                                  "path-browserify"))))))))
    (home-page "https://github.com/microsoft/vscode-uri#readme")
    (synopsis
     "The URI implementation that is used by VS Code and its extensions")
    (description
     "The URI implementation that is used by VS Code and its extensions")
    (license license:expat)))

(define-public node-astrojs-language-server
  (package
    (name "node-astrojs-language-server")
    (version "2.16.8")
    (source
     (origin
       (method url-fetch)
       (uri
        "https://registry.npmjs.org/@astrojs/language-server/-/language-server-2.16.8.tgz")
       (sha256
        (base32 "0ixk3428xgk798lyys4ca0vg33bdgdlxg2wa2mv66r1gmnbsj8rf"))))
    (build-system node-build-system)
    (arguments
     (list
      #:tests? #f
      #:phases
      (node-build-phases-without-install-links
          '(delete 'build)
          '(add-after 'patch-dependencies 'delete-dev-dependencies
            (lambda _
              (modify-json (delete-fields '(("scripts" "prepare")) #:strict? #f)
                           (delete-dependencies '("@types/node"
                                                  "@volar/test-utils"
                                                  "@volar/typescript"
                                                  "tsx"
                                                  "typescript"
                                                  "vscode-languageserver-protocol"
                                                  "vscode-languageserver-textdocument"
                                                  "astro-scripts"
                                                  "prettier-plugin-astro"
                                                  "prettier")))))
          '(add-after 'install 'link-astro-ls
            (lambda* (#:key outputs #:allow-other-keys)
              (let* ((out (assoc-ref outputs "out"))
                     (bin (string-append out "/bin"))
                     (target (string-append
                              out
                              "/lib/node_modules/@astrojs/language-server"
                              "/bin/nodeServer.js")))
                (mkdir-p bin)
                (symlink target (string-append bin "/astro-ls"))))))))
    (inputs (list node-vscode-uri-3.1.0
                  node-vscode-html-languageservice-5.6.2
                  node-volar-service-yaml-0.0.70
                  node-volar-service-typescript-twoslash-queries-0.0.70
                  node-volar-service-typescript-0.0.70
                  node-volar-service-prettier-0.0.70
                  node-volar-service-html-0.0.70
                  node-volar-service-emmet-0.0.70
                  node-volar-service-css-0.0.70
                  node-tinyglobby-0.2.16
                  node-muggle-string-0.4.1
                  node-volar-language-service-2.4.28
                  node-volar-language-server-2.4.28
                  node-volar-language-core-2.4.28
                  node-volar-kit-2.4.28
                  node-jridgewell-sourcemap-codec-1.5.5
                  node-astrojs-yaml2ts-0.2.3
                  node-astrojs-compiler-2.13.1
                  node-prettier-plugin-astro-0.14.1
                  node-prettier-3.8.3))
    (home-page "https://github.com/withastro/astro#readme")
    (synopsis
     "The Astro language server, implement the [language server protocol](https://microsoft.github.io/language-server-protocol/)")
    (description
     "The Astro language server, implement the [language server protocol](https://microsoft.github.io/language-server-protocol/)")
    (license license:expat)))
