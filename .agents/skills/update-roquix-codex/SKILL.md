---
name: update-roquix-codex
description: Update roquix's packaged openai/codex release. Use when bumping `channel/roquix/packages/codex.scm`, regenerating `channel/roquix/packages/rust-crates.scm` from upstream `codex-rs/Cargo.lock`, fixing `scripts/update-codex.sh` or `.github/workflows/update-codex.yml`, or validating the bump with `guix build` and the existing `verify-guix-pull` workflow.
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
2. If `guix import` fails, fix the local updater and the GitHub workflow
   together. The import command is:

   ```sh
   guix import --insert=channel/roquix/packages/rust-crates.scm \
     crate codex \
     --lockfile="$lockfile"
   ```

3. Review the diff.
   - Expected package files: `channel/roquix/packages/codex.scm` and
     `channel/roquix/packages/rust-crates.scm`.
   - After every import, run Guix's `etc/teams/rust/cleanup-crates.sh` across
     the entire `rust-crates.scm`, changing its hard-coded `FILE` path for this
     channel. Check removed names for references outside that file; the
     script counts uses only within `FILE`.
   - On the final branch, rerun `guix import` with the release's `Cargo.lock`
     and confirm that `rust-crates.scm` stays unchanged. If it changes, keep
     the generated result and repeat the import before building.
   - Confirm that the release version, source tag, source hash, and generated
     crate inputs all refer to the same upstream release.
   - Match `#:rust` to the release's `codex-rs/rust-toolchain.toml`. Check each
     source substitution against the new tree, and update package comments
     and upstream source links when its reason changes.
   - When changing the updater, make it update `%codex-release-version` rather
     than replacing the exported package version expression.
   - If the updater logic changes, `scripts/update-codex.sh` and
     `.github/workflows/update-codex.yml` should change together.
4. Validate package resolution.
   - `guix build -L channel -e '(@ (roquix packages codex) codex)' -n`
5. Run a full build before closing out the bump.
   - `guix build -K -L channel -e '(@ (roquix packages codex) codex)'`
   - Capture long logs using `build-guix-packages`.
   - Run the resulting `bin/codex --version` and check the upstream version.
   - Check daemon startup from a fresh `CODEX_HOME` with
     `tests/codex-daemon-package.sh "$output"` inside a `guix shell` containing
     the Codex package. The script starts the daemon, checks the running
     version, and stops it.
6. Validate the channel with `verify-guix-pull`.
   - Use the existing `verify-guix-pull` skill for the temporary-profile
     `guix pull` check. Fix package-cache or pull failures before closing out
     the bump.

## Notes

- `guix show codex` may resolve to the official Guix package instead of
  `(roquix packages codex)`. Prefer `guix build -e '(@ (roquix packages codex)
  codex)'` or module-local checks.
