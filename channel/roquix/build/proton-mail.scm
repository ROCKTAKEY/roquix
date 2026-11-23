(define-module (roquix build proton-mail)
  #:use-module (guix build utils)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 regex)
  #:use-module (ice-9 popen)
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
      (let ((dir (string-append "dependency-sources/node_modules/" (basename archive))))
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
                (list name (string-append name
                             (if (string=? name "@opentelemetry/sdk-trace-base")
                                 "/src/index-shim.ts" "/src/index.ts"))))))
       (find-files (module-path scope) (lambda (p s) (eq? 'symlink (stat:type s)))
                   #:stat lstat)))
    '("@opentelemetry" "@sentry"))
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
     ("zod" "zod/src/index.ts"))))

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
     (string-append "import " name " from \"" dep "\"")))
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

(define (build-desktop tools desktop-dir)
  (prepare-dependencies)
  (build-themes)
  (substitute* (module-path "debounce-fn/index.js")
    (("require[(]'mimic-fn'[)]") "require('./node_modules/mimic-fn')"))
  (with-directory-excursion "applications/inbox-desktop"
    ;; Node resolves Forge and its plugins from the build-tool tree.  Webpack
    ;; resolves application imports exclusively against the source checkouts.
    (setenv "DESKTOP_SOURCES" (getenv "NODE_PATH"))
    ;; Sentry's release bundles tree-shake optional browser integrations. Build
    ;; its main entry from TypeScript so webpack sees the same Node-only API.
    (call-with-output-file "sentry-main.ts"
      (lambda (port)
        (display "export { addBreadcrumb, childProcessIntegration, electronMinidumpIntegration,
                  init, setTag, setTags, setUser, flush, captureException, withScope
                  } from '@sentry/electron/main';" port)))
    (apply invoke "esbuild" "sentry-main.ts"
           "--platform=node" "--bundle" "--format=cjs" "--external:electron"
           "--define:__DEBUG_BUILD__=false" "--external:preact"
           "--external:@sentry/rrweb" "--external:@sentry/rrweb-snapshot"
           "--external:@sentry-internal/replay-worker" "--external:@apm-js-collab/*"
           (string-append "--define:__SENTRY_SDK_VERSION__="
                          (call-with-port
                           (open-input-pipe "node -p 'JSON.stringify(require(\"@sentry/core/package.json\").version)'")
                           (lambda (port) (string-trim-right (get-string-all port)))))
           (string-append "--outfile=" (module-path "@sentry/electron/cjs/main/index.js"))
           (map (lambda (entry) (apply alias entry)) (source-aliases)))
    ;; Forge's asset relocator recognizes filesystem paths; webpack turns
    ;; require.resolve into a module ID, which Electron cannot use as a preload.
    (substitute* (module-path "@sentry/electron/cjs/main/index.js")
      (("require[.]resolve[(]\"[.][.]/[.][.]/preload/default[.]js\"[)]")
       "require('path').join(__dirname, require('../../preload/default.js?preload-file'))"))
    (call-with-output-file "source-aliases.json"
      (lambda (port)
        (display "{" port)
        (display (string-join
                  (map (match-lambda
                         ((name path)
                          (format #f "~s:~s" (string-append name "$")
                                  (module-path
                                   (if (string=? name "@sentry/electron/main")
                                       "@sentry/electron/cjs/main/index.js" path)))))
                       (source-aliases)) ",\n") port)
        (display "}" port)))
    (invoke "esbuild" (module-path "@sentry/electron/src/preload/default.ts")
            "--platform=browser" "--format=cjs" "--bundle" "--external:electron"
            (string-append "--outfile=" (module-path "@sentry/electron/preload/default.js")))
    (call-with-output-file "/dev/null"
      (lambda (port) (copy-recursively tools "node_modules" #:log port)))
    (patch-shebang (canonicalize-path "node_modules/.bin/electron-forge"))
    (setenv "NODE_PATH" (canonicalize-path "node_modules"))
    (substitute* '("webpack.main.config.ts" "webpack.renderer.config.ts")
      (("resolve: [{]")
       "resolve: { modules: [process.env.DESKTOP_SOURCES!], alias: require('./source-aliases.json'), extensionAlias: { '.js': ['.js', '.ts', '.tsx'] },"))
    (substitute* "webpack.main.config.ts"
      (("rules: \\[")
       "rules: [{ resourceQuery: /preload-file/, type: 'asset/resource', generator: { filename: 'native_modules/default.js', publicPath: '' } },"))
    (substitute* "webpack.rules.ts"
      (("^ *exclude: .*") "        exclude: /[.]webpack/,\n"))
    (substitute* "forge.config.ts"
      (("mimeType: [[]") "mimeType: [\"x-scheme-handler/proton-inbox\", ")
      (("packagerConfig: [{]")
       "packagerConfig: { electronZipDir: process.env.ELECTRON_ZIP_DIR,")
      (("config: rendererConfig,") "config: { ...rendererConfig, plugins: [] },"))
    (setenv "PATH" (string-append (canonicalize-path "node_modules/.bin") ":" (getenv "PATH")))
    (invoke "npm" "run" "make" "--" "--targets=@electron-forge/maker-deb")
    (match (find-files "out/make" "\\.deb$")
      ((deb)
       (invoke "dpkg-deb" "--extract" deb "debian")
       (install-file "debian/usr/share/applications/proton-mail.desktop" desktop-dir)))))
