---
name: update-roquix-opencode
description: Update roquix's OpenCode package, regenerate its Bun lock inputs, and verify its compiled CLI, embedded web UI, and native PTY support under Guix.
---

# Update Roquix OpenCode

## Release identity

Check the requested release series explicitly. OpenCode 1 uses npm
`opencode-ai`, while OpenCode 2 uses `@opencode/cli`. GitHub's Latest release
can point to 1.x even when newer 2.x tags are published. Confirm the npm
dist-tag and corresponding `anomalyco/opencode` source tag rather than relying
only on `/releases/latest`.

Update `channel/roquix/packages/opencode.scm` and its versioned dependency
export in `opencode-npm-inputs.scm`. For a clean checkout, calculate the
git-fetch hash with `guix hash -x -S nar DIRECTORY`.

## Lock inputs

Use the repository's Guile Bun importer. Hashes come from downloaded content,
not the lockfile integrity field. Run registration from the `channel`
directory with an absolute load path: Guix's read-print helpers can record
module-relative filenames, which the editor resolves against its working
directory even when the destination argument was absolute.

For a large lock, save the generated expression before registering it so a
registration failure does not discard the download and hashing work:

```sh
guix repl -L "$PWD/channel" -- scripts/import-bun.scm /path/to/bun.lock \
  > /tmp/opencode-inputs.scm 2> /tmp/opencode-import.log
```

Register the saved expression with `update-bun-lock-inputs!` from
`(guix import bun)`, using `channel` as the working directory. The normal
`scripts/update-bun-lock-inputs.sh opencode` wrapper sets that directory too.
Remove an obsolete OpenCode snapshot only after checking its
references; preserve all Bun bootstrap snapshots and their lookup entries.
Update the release expectations in `tests/opencode-package-test.scm` and
`tests/bun-generated-inputs-test.scm`.

## Build boundaries

- OpenCode 2 compiles `packages/cli/script/build.ts`. CLI settings and server
  settings have separate schema generators; inspect both when updating.
- Compare the release's `packageManager` and actual runtime APIs with the
  source-bootstrapped Guix Bun. A development-toolchain version check alone
  does not prove runtime incompatibility. Any relaxation needs a complete
  build and compiled-service checks; do not substitute an unverified Bun
  release binary for the source bootstrap.
- Compile with the current Guix Bun template. A platform-qualified compile
  target can select/download an upstream executable and lose Guix's ELF
  interpreter and RUNPATH.
- The lock-layout builder does not execute Bun installation lifecycle hooks.
  Apply upstream `patchedDependencies` with the package's `apply-patches.ts`
  helper, matching installed versions, including nested dependencies.
  If a hunk fails, compare its context with the authenticated package source;
  a release patch can itself contain incorrect indentation. Correct that
  specific patch rather than silently skipping it.
- Bun embeds native libraries and the `opencode-pty` daemon as bytes. Patch
  their Guix library paths and executable interpreter **before** compilation.
  Changing the outer executable does not repair embedded ELF files.
- Check source substitutions against the new release, including the Guix
  ripgrep path. Preserve the package's offline build and embedded web UI.

## Verification

Use `build-guix-packages` for full-build log handling and a GC root. Prefer
the explicit package expression `(@ (roquix packages opencode) opencode)`.
Run the package identity and generated-input Scheme tests with `guix repl
-L "$PWD/channel" -- FILE`, and the dependency-patch test with a Guix shell
providing `patch` and the packaged Bun.

The upstream `packages/cli/script/service-smoke.ts` exercises the compiled
service, embedded web assets, authentication, and plugin reload. Also verify
native PTY execution: start the compiled server with an isolated HOME/XDG/DB,
create a persistent terminal through its API, and inspect actual shell output
in a terminal snapshot. Shut down the terminal daemon and test server.

Check installed version, shell completions, schemas, and execution without
host library-path overrides. OpenCode 2's `--version` prints `opencode vVERSION`,
not just the numeric version. If channel helpers or module resolution change,
use `verify-guix-pull` to check discovery from a temporary profile.
