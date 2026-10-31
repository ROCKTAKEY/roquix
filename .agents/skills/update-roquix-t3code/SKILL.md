---
name: update-roquix-t3code
description: Update roquix's T3 Code packages and rebase the ROCKTAKEY session-sharing variant onto the same upstream release. Use for t3code updates, fork revision bumps, dependency cache regeneration, and Guix verification of desktop and CLI packages.
---

# Update Roquix T3 Code

## Scope and completion

Every T3 Code update includes both the upstream packages (`t3code`,
`t3code-cli`) and the session-sharing variants (`t3code-rocktakey`,
`t3code-cli-rocktakey`), unless the user explicitly narrows the scope.
Rebase the variant onto the selected upstream release and update its pinned
revision as part of the same task. An upstream-only version bump with the
variant left on its old base does not complete the update.

The definitions live in `channel/roquix/packages/t3code.scm`. Use
`test-driven-development` for implementation and regression checks,
`build-guix-packages` for build execution and logs, and `verify-guix-pull`
for channel verification.

## Select the release and rebase the variant

1. Confirm the requested release, or the latest stable tag of
   [pingdotgg/t3code](https://github.com/pingdotgg/t3code/releases), from
   upstream. Compare its manifests, `pnpm-lock.yaml`, `pnpm-workspace.yaml`,
   patches, native Cargo locks, Electron version, Ghostty revision, and SPDX
   data version with the currently packaged sources.
2. Read the fork URL, branch, and pinned commit from the package definition.
   The session-sharing source is
   [ROCKTAKEY/t3code](https://github.com/ROCKTAKEY/t3code), branch
   `feat/opencode-session-sharing`. Fetch the actual branch tip and upstream
   release into a dedicated checkout; preserve unrelated work in existing
   checkouts. Inspect differences between the pinned commit and branch tip
   before selecting the commits to carry forward.
3. Identify the fork's base and rebase its feature commits onto the selected
   release tag. Resolve conflicts by preserving Codex and OpenCode session
   sharing against the release's current interfaces. Inspect the resulting
   commit range and use `git range-diff` where useful. Follow the fork
   checkout's `AGENTS.md` and run `vp run check:changed <release-tag>`; the
   explicit base includes the rebased feature changes rather than comparing
   against an unrelated default branch. Account for functionality already
   supplied by upstream rather than blindly retaining duplicate patches.
   Verify that the selected release commit is an ancestor of the rebased tip.
4. Make the rebased revision available at the repository used by the package's
   source URL, within the session's publication authorization. A local-only SHA
   cannot serve as a reproducible codeload source. When rewriting an authorized
   fork branch, use a lease tied to the fetched remote tip; a changed remote
   tip requires reconciliation rather than an unconditional force push.
5. Pin the full rebased commit and derive the variant version from its actual
   release base using `git-version`. Download that exact commit's archive and
   compute its hash. Verify that the archive is reachable before declaring
   the package update complete. Report any unresolved publication constraint
   explicitly, together with the local rebased SHA and remaining work.

## Source and dependency identities

- Update the release version, release archive hash, fork commit, fork archive
  hash, and variant version together. Hash codeload archives with `guix hash`;
  these origins use `url-fetch`, not a recursive checkout hash.
- Match Electron to the desktop manifest and verify its release archive hash.
  The Electron origin uses `url-fetch/zipbomb`; retain that origin method.
- Regenerate `%t3code-node-modules` through the package's fixed-output builder.
  It performs a filtered pnpm install with `--frozen-lockfile --ignore-scripts`
  and normalizes generated paths. A deliberately incorrect temporary hash can
  reveal the actual recursive hash; replace it and successfully rebuild the
  origin before committing. Do not hash an ordinary local `node_modules`
  directory as a substitute for this builder.
- Generate or verify the variant's dependency cache against its rebased
  source. Share a cache only when the actual dependency inputs and generated
  output agree. A matching lockfile alone does not establish equality when
  workspace manifests or patches differ. Keep distinct origins when needed,
  and do not carry an old cache hash forward without verifying it.
- Compare the native helper Cargo locks and native addon versions with
  `rust-crates.scm`. Use `package-rust-for-guix` when native Rust inputs or
  packaging need changes. Preserve source-built addons and the offline
  application build; npm prebuilt native binaries must not bypass them.
- Match document dependency versions to the source pins in
  `channel/roquix/packages/t3code-wasm.scm` (Office and SQL) and
  `channel/roquix/packages/pdfjs.scm` (PDF.js and its codecs). Shared Emscripten,
  wasm-bindgen, and Rust WASM sysroots live in
  `channel/roquix/packages/wasm.scm`. Betteroffice module settings use the
  validated `wasm-module` constructor. Betteroffice needs its matching
  TypeScript sources and generated wasm-bindgen JavaScript; replacing only
  the WASM can break the binding ABI. Preserve shared source modules and
  worker entry resolution when staging those sources. PDF.js also needs its
  worker rebuilt against the generated codec bindings; the codecs have
  independent derivations. Keep PDF.js's version and commit authoritative for
  its source, dependency cache, and generated worker metadata.
  SQL.js's conditional browser export requires the browser build as well as
  its default entry.
  Keep ordinary dependency staging and Linux icon generation in Scheme phases.
  JavaScript helpers handle Office source transformations and npm dependency
  resolution, where package metadata and upstream JavaScript APIs are needed.
- Reuse Guix WASM toolchain packages where their versions match. Rust's WASM
  sysroot is a hidden package binding, so an unsuccessful name search does
  not prove its absence. A separately built sysroot must match the compiler;
  verify it by linking a WASM program, including the paired `.rlib` and
  `.rmeta` files used by recent Rust releases. Regenerate changed WASM Cargo
  input groups from the corresponding upstream locks.
- Check source substitutions against the new source, including the packaged
  Chromium preview service and test-toolchain Vite resolution. Keep the Guix
  package version authoritative for application version output because the
  release tag can be newer than workspace manifest versions.

Example dependency-cache build:

```sh
guix build -L channel \
  -e '(@@ (roquix packages t3code) %t3code-node-modules)' \
  > /tmp/t3code-dependencies.log 2>&1
```

pnpm itself can require a substantial Rust build and test run before this
cache is generated. Distinguish that prerequisite from application failures.

## Verification

Update the release and fork expectations in `tests/t3code-cli-package.scm`.
Run the repository checks:

```sh
guix repl -L channel -- tests/t3code-cli-package.scm
guix repl -L channel -- tests/t3code-home-service.scm
guix repl -L channel -- tests/t3code-wasm-module.scm
guix repl -L channel -- tests/pdfjs-package.scm
node --test tests/t3code-runtime-dependencies.mjs tests/t3code-office-sources.mjs
```

Build all four exact package definitions, retaining build logs:

```sh
guix build -L channel --max-jobs=1 --cores=4 \
  t3code t3code-cli t3code-rocktakey t3code-cli-rocktakey \
  > /tmp/t3code-build.log 2>&1
```

The installed checks in
`channel/roquix/packages/aux-files/t3code/package-tests/` exercise native
modules, terminal execution, desktop resources, the Web UI, and CLI pairing.
Keep these checks enabled. If an HTTP assertion fails, inspect the selected
source's route definitions and authentication middleware before changing the
expected status. An unknown GET route can return the SPA HTML with status
200; that is not evidence of successful API authentication. The authenticated
POST `/api/auth/websocket-ticket` is suitable for checking unauthenticated
rejection and paired access when present in the selected release. Verify
single-use pairing credentials as well, and keep credentials out of logs.

The installed WASM check compares module hashes with declared source-build
outputs and rejects Windows or macOS executables. Its expected count must
follow the selected release's actual assets. Run staging regressions with the
package's Node version too: directory permissions preserved by `cpSync` can
differ from the Node version in the working shell.

Verify both variant-specific functionality and shared runtime contracts.
Run relevant lint and `git diff --check`. Use a temporary-profile `guix pull`
on the final source state, then check package discovery and helper resolution
with the pulled Guix without `-L channel`. Verify the ordinary grafted output,
including its reported version, rather than only an ungrafted derivation.

Commit the validated roquix changes with `t3code: Update to VERSION.`. Report
both the upstream version and the variant's new base and pinned commit, along
with build and pull results. Distinguish repository/package updates from
installation into the user's running environment.
