---
name: update-roquix-codex
description: Update roquix's packaged openai/codex release. Use when bumping `channel/roquix/packages/codex.scm`, regenerating `channel/roquix/packages/rust-crates.scm` from upstream `codex-rs/Cargo.lock`, fixing `scripts/update-codex.sh`, or validating the bump with `guix build` and the existing `verify-guix-pull` workflow.
---

# Update Roquix Codex

## Overview

Use the repository's updater and validate the resulting package and channel.
Keep package-specific implementation reasons beside the relevant definitions
in `channel/roquix/packages/codex.scm`.

## Workflow

1. Confirm the latest stable tag with the official GitHub releases API, then
   run the updater from the repository root.
   - `bash scripts/update-codex.sh rust-vX.Y.Z`
   - Upstream Codex tags use the `rust-v...` prefix.
2. If `guix import` fails, fix the local updater. The import command is:

   ```sh
   guix import --insert=channel/roquix/packages/rust-crates.scm \
     crate codex \
     --lockfile="$lockfile"
   ```

3. Review the diff.
   - Expected package files: `channel/roquix/packages/codex.scm` and
     `channel/roquix/packages/rust-crates.scm`.
   - For pinned Git workspaces such as the MCP SDK, also update the hidden
     package in `rust-sources.scm` and its member aliases in `rust-crates.scm`.
     Follow `package-rust-for-guix`: raw workspace origins from the importer
     do not expose member crates to Cargo's offline registry directory.
   - After every import, run Guix's `etc/teams/rust/cleanup-crates.scm` across
     the entire `rust-crates.scm`, changing its `file` binding to this channel's
     absolute path. Run it from `channel/` with that directory on Guix's load
     path so relative source locations resolve. Check removed names for
     references outside that file; the scan sees only that module.
   - On the final branch, rerun `guix import` with the release's `Cargo.lock`
     and confirm that `rust-crates.scm` stays unchanged. If it changes, keep
     the generated result and repeat the import before building.
   - Confirm that the release version, source tag, source hash, and generated
     crate inputs all refer to the same upstream release.
   - Check `codex-rs/rust-toolchain.toml` and dependency `rust-version`
     requirements against the available Guix compilers. Prefer the pinned
     compiler when available; a toolchain pin alone does not establish the
     minimum supported Rust version. Before adding another toolchain or
     channel dependency, try the packaged compiler and require the full build
     and runtime checks below. Report the compiler version used.
   - Check each source substitution against the new tree, and update package
     comments and upstream source links when its reason changes.
   - When changing the updater, make it update `%codex-release-version` rather
     than replacing the exported package version expression. Accept Scheme
     formatting with the value on a separate line.
   - Run `python3 tests/codex/test-update.py` locally for updater changes.
4. Validate release identity and package resolution.
   - Run `guix repl -L channel -- tests/codex/release.scm X.Y.Z`. The test
     checks both the channel package version and the upstream source tag.
   - `guix build -L channel -e '(@ (roquix packages codex) codex)' -n`
5. Run a full build before closing out the bump.
   - `guix build -K -L channel -e '(@ (roquix packages codex) codex)'`
   - Capture long logs using `build-guix-packages`.
   - Run the resulting `bin/codex --version` and check the upstream version.
   - Cargo tests are disabled in this package; distinguish successful builds
     and runtime checks from upstream test-suite coverage.
   - Check daemon startup from a fresh `CODEX_HOME` in a pure environment.
     This verifies that process-management tools come from the package's
     propagated inputs rather than the host PATH.

     ```sh
     guix shell --pure -L channel \
       -e '(@ (roquix packages codex) codex)' bash-minimal coreutils \
       -- sh tests/codex-daemon-package.sh "$output"
     ```

     The script starts the daemon, checks its running status, and stops it.
     Confirm that `managedCodexVersion`, `cliVersion`, and `appServerVersion`
     in the reported JSON all match the requested release.
     Check for a surviving `pid-update-loop` from this temporary `CODEX_HOME`:
     in 0.163.0 it can outlive `daemon stop`. Terminate only the test-owned
     helper and verify that it exits.
6. Validate the channel with `verify-guix-pull`.
   - Use the existing `verify-guix-pull` skill for the temporary-profile
     `guix pull` check. Fix package-cache or pull failures before closing out
     the bump.

## Notes

- `guix show codex` may resolve to the official Guix package instead of
  `(roquix packages codex)`. Prefer `guix build -e '(@ (roquix packages codex)
  codex)'` or module-local checks.
