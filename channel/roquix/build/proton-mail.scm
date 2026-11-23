(define-module (roquix build proton-mail)
  #:use-module (guix build utils)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 match)
  #:use-module (ice-9 textual-ports)
  #:use-module (srfi srfi-1)
  #:export (stage-desktop-sources build-desktop))

(define (module-path path)
  (string-append (getenv "NODE_PATH") "/" path))

(define (link-module name target)
  (let ((link (module-path name)))
    (mkdir-p (dirname link))
    (symlink (canonicalize-path target) link)))

(define (stage-desktop-sources archives license-dir)
  (mkdir-p "node_modules")
  (setenv "NODE_PATH" (canonicalize-path "node_modules"))
  (for-each
   (match-lambda
     ((archive modules ...)
      (let ((dir (string-append "dependency-sources/" (basename archive))))
        (mkdir-p dir)
        (invoke "tar" "xf" archive "--strip-components=1" "-C" dir)
        (for-each (match-lambda
                    ((name subdir)
                     (let ((package-dir (string-append dir "/" subdir)))
                       (link-module name package-dir)
                       (let locate ((root package-dir))
                         (let ((files (scandir root (lambda (name)
                                                      (string-match "^(LICEN[SC]E|COPYING|NOTICE)([.-].*)?$"
                                                                    name)))))
                           (if (and (null? files) (not (string=? root dir)))
                               (locate (dirname root))
                               (for-each (lambda (file)
                                           (install-file (string-append root "/" file)
                                                         (string-append license-dir "/" name)))
                                         files)))))))
                  modules))))
   archives)
  (for-each (lambda (name)
              (link-module (string-append "@proton/" name)
                           (string-append "packages/" name)))
            '("shared" "metrics" "utils" "colors")))

(define (alias name path)
  (string-append "--alias:" name "=" (module-path path)))

(define (source-aliases)
  (append
   (append-map
    (lambda (scope)
      (filter-map
       (lambda (dir)
         (let ((name (string-append scope "/" (basename dir))))
           (and (not (string=? name "@sentry/electron"))
                (alias name (string-append name
                             (if (string=? name "@opentelemetry/sdk-trace-base")
                                 "/src/index-shim.ts" "/src/index.ts"))))))
       (find-files (module-path scope) (lambda (p s) (eq? 'symlink (stat:type s)))
                   #:stat lstat)))
    '("@opentelemetry" "@sentry"))
   (map (match-lambda ((name path) (alias name path)))
        '(("@sentry/electron/main" "@sentry/electron/src/main/index.ts")
          ("@sentry/core/browser" "@sentry/core/src/browser.ts")
          ("@sentry/conventions/op" "@sentry/conventions/src/op.ts")
          ("@sentry/conventions/attributes" "@sentry/conventions/src/attributes.ts")
          ("@sentry/server-utils/orchestrion" "@sentry/server-utils/src/orchestrion/index.ts")
          ("@sentry/server-utils/orchestrion/register" "@sentry/server-utils/src/orchestrion/runtime/register.ts")
          ("ajv/dist/compile/codegen" "ajv/lib/compile/codegen/index.ts")
          ("ajv/dist/compile/validate" "ajv/lib/compile/validate/index.ts")
          ("ajv/dist/compile/util" "ajv/lib/compile/util.ts")
          ("ajv/dist/runtime/uri" "ajv/lib/runtime/uri.ts")
          ("ajv/dist/runtime/equal" "ajv/lib/runtime/equal.ts")
          ("ajv" "ajv/lib/ajv.cjs")
          ("ajv-formats" "ajv-formats/src/index.cjs")
          ("conf" "conf/source/index.cjs")
          ("atomically" "atomically/src/index.ts")
          ("github-url-to-object" "github-url-to-object/index.js")
          ("update-electron-app" "update-electron-app/src/index.ts")
          ("plural-forms/minimal-safe" "plural-forms/src/minimal-safe.js")
          ("dedent" "dedent/dedent.ts")
          ("ttag" "ttag/src/index.ts")
          ("zod" "zod/src/index.ts")))))

(define (prepare-dependencies)
  (for-each (match-lambda
              ((name script)
               (with-directory-excursion (module-path name)
                 (invoke "node" script))))
            '(("fast-deep-equal" "build.js")
              ("plural-forms" "build/build-minimal-safe.js")
              ("@sentry/electron" "scripts/update-version.js")))
  (for-each
   (lambda (name)
     (with-directory-excursion (module-path (string-append "@opentelemetry/" name))
       (let locate ((dir (canonicalize-path ".")))
         (let ((script (string-append dir "/scripts/version-update.js")))
           (cond ((file-exists? script) (invoke "node" script))
                 ((string=? dir "/") (error "missing version-update.js" name))
                 (else (locate (dirname dir))))))))
   '("api" "core" "sdk-trace"))
  ;; These packages publish CommonJS constructors via module.exports.
  (substitute* (find-files (module-path "ajv/lib") "\\.ts$")
    (("import \\* as ([a-zA-Z]+) from \"(fast-uri|fast-deep-equal|json-schema-traverse)\"" _ name dep)
     (string-append "import " name " = require(\"" dep "\")")))
  (for-each (lambda (entry)
              (let ((file (module-path entry)))
                (invoke "esbuild" file "--format=cjs" "--platform=node"
                        (string-append "--outfile=" (string-drop-right file 3) ".cjs"))))
            '("ajv/lib/ajv.ts" "ajv-formats/src/index.ts" "conf/source/index.ts")))

(define (build-themes)
  (substitute* (map module-path '("css-tree/lib/data.js" "css-tree/lib/version.js" "css-tree/lib/data-patch.js"))
    (("^.*createRequire.*$") ""))
  (with-directory-excursion "packages/colors"
    (delete-file-recursively "themes/dist")
    (mkdir-p "themes/dist")
    (substitute* "gen-themes.ts"
      (("import cssTree") "import * as cssTree")
      (("^import prettier.*$") "")
      (("await prettier.format\\(cssFile,.*\\);") "cssFile;"))
    (invoke "esbuild" "gen-themes-cli.ts" "--platform=node" "--bundle"
            (alias "css-tree" "css-tree/lib/index.js")
            (alias "tinycolor2" "tinycolor2/mod.js") "--outfile=gen-themes.cjs")
    (invoke "node" "gen-themes.cjs")))

(define (build-desktop helper desktop-dir)
  (prepare-dependencies)
  (build-themes)
  (with-directory-excursion "applications/inbox-desktop"
    (substitute* "forge.config.ts"
      (("^import .*(@electron-forge/plugin-|webpack[.]|dotenv).*") "")
      (("^dotenvConf.*") "")
      (("^ *new AutoUnpackNativesPlugin.*") "")
      (("new (WebpackPlugin|FusesPlugin)\\(") "(")
      (("^ *(mainConfig,|config: rendererConfig,).*") ""))
    (copy-file helper "package-linux.cjs")
    (invoke "esbuild" "package-linux.cjs" "--bundle" "--platform=node"
            "--external:original-fs" (alias "@electron/fuses" "@electron/fuses/src/index.ts")
            (alias "@electron/asar" "@electron/asar/src/asar.ts")
            "--outfile=assemble.cjs")
    (invoke "node" "assemble.cjs" "metadata")
    (let ((aliases (source-aliases)))
      (define (bundle entry output platform . options)
        (apply invoke "esbuild" entry "--bundle" "--format=cjs" "--external:electron"
               "--define:process.env.NODE_ENV=\"production\"" "--define:__DEBUG_BUILD__=false"
               (string-append "--platform=" platform)
               (string-append "--outfile=app/" output)
               (string-append "--metafile=" (basename output) ".meta.json")
               (append options aliases))
        (invoke "node" "assemble.cjs" "audit" (string-append (basename output) ".meta.json")))
      (apply bundle "src/index.ts" ".webpack/main/index.js" "node"
             "--loader:.css=file"
             "--define:MAIN_WINDOW_PRELOAD_WEBPACK_ENTRY=preloadPath"
             "--banner:js=const preloadPath=require('node:path').join(__dirname,'../renderer/main_window/preload.js');"
             "--external:preact" "--external:@sentry/rrweb" "--external:@sentry/rrweb-snapshot"
             "--external:@sentry-internal/replay-worker" "--external:@apm-js-collab/*"
             (string-split (string-trim-right (call-with-input-file "defines" get-string-all)) #\newline))
      (bundle "src/preload.ts" ".webpack/renderer/main_window/preload.js" "browser")
      (bundle "src/renderer.ts" ".webpack/renderer/main_window/index.js" "browser")
      (bundle (module-path "@sentry/electron/src/preload/default.ts") "preload/default.js" "browser"))
    (copy-file (module-path "electron-log/src/renderer/electron-log-preload.js")
               "app/.webpack/renderer/electron-log-preload.js")
    (copy-file "src/index.html" "app/.webpack/renderer/main_window/index.html")
    (substitute* "app/.webpack/renderer/main_window/index.html"
      (("</body>") "<script src=\"index.js\"></script></body>"))
    (copy-file "package.json" "app/package.json")
    (invoke "node" "assemble.cjs" "package" desktop-dir)))
