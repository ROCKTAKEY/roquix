---
name: update-roquix-codex
description: Update roquix's packaged openai/codex release. Use when bumping `channel/roquix/packages/codex.scm`, regenerating `channel/roquix/packages/rust-crates.scm` from upstream `codex-rs/Cargo.lock`, fixing `scripts/update-codex.sh` or `.github/workflows/update-codex.yml`, or validating the bump with `guix build` and the existing `verify-guix-pull` workflow.
---

# Update Roquix Codex

## Overview

Use the repository's existing updater first. Keep the package files and the
automation that maintains them in sync with the current Guix CLI.

## Workflow

1. Confirm the latest stable tag with the official GitHub releases API, then
   run the updater from the repository root.
   - `bash scripts/update-codex.sh rust-vX.Y.Z`
   - Upstream Codex tags use the `rust-v...` prefix.
2. If `guix import` fails, fix the local updater and the GitHub workflow
   together.
   - Current working form:

```sh
guix import --insert=channel/roquix/packages/rust-crates.scm \
  crate codex \
  --lockfile="$lockfile"
```

   - Do not reintroduce the older `guix import crate --recursive --insert=...`
     form unless Guix changes back.
3. Review the diff.
   - Expected package files: `channel/roquix/packages/codex.scm` and
     `channel/roquix/packages/rust-crates.scm`.
   - Keep the OpenAI Codex release in `%codex-release-version`.  The exported
     package appends `-roquix` so Guix selects the channel package when the
     official Guix package has the same release version.  Source tags must use
     the unsuffixed release version.
   - Match `#:rust` to the release's `codex-rs/rust-toolchain.toml`.
     Check patched source paths against the new tree; remove patches for
     deleted components instead of silently ignoring missing files.
   - When changing the updater, make it update `%codex-release-version` rather
     than replacing the exported package version expression.
   - If the updater logic changes, `scripts/update-codex.sh` and
     `.github/workflows/update-codex.yml` should change together.
4. Validate package resolution.
   - `guix build -L channel -e '(@ (roquix packages codex) codex)' -n`
5. Run a full build before closing out the bump.
   - `guix build -K -L channel -e '(@ (roquix packages codex) codex)'`
   - Capture long logs using `build-guix-packages`. The package builds the
     CLI and code-mode host together, then installs those binaries directly
     to preserve Cargo feature resolution and avoid duplicate compilation.
   - Run the resulting `bin/codex --version` and check the upstream version.
   - If the build fails in `v8` while downloading
     `librusty_v8_release_<target>.a.gz`, package the prebuilt archive as an
     input and set `RUSTY_V8_ARCHIVE` in a pre-build phase instead of relying
     on network access from the Guix build sandbox.
6. Validate the channel with `verify-guix-pull`.
   - Use the existing `verify-guix-pull` skill for the temporary-profile
     `guix pull` check.
   - Keep this skill focused on the Codex bump itself; do not add another
     project-local `guix pull` verifier unless the shared workflow becomes
     unavailable.

## Notes

- `guix show codex` may resolve to the official Guix package instead of
  `(roquix packages codex)`. Prefer `guix build -e '(@ (roquix packages codex)
  codex)'` or module-local checks.
- `cargo-build-system` can treat a bare `origin` in `native-inputs` as a cargo
  source to unpack. Wrap helper archives that are not Rust crates in a small
  package instead of passing the raw `origin` directly.
- An upstream release can add a target-specific workspace git dependency. A
  generated origin is not sufficient when the workspace root is not a
  standalone crate, because Cargo's offline vendor directory cannot provide
  it. For this Linux-only package, remove Windows-only workspace dependency
  declarations in the consuming member manifests before Cargo resolves them,
  and confirm the result with the offline full build. Inspect the new tag: the
  MXC dependencies are consumed by `mxc-sandbox/Cargo.toml`, including
  `wxc_common` alongside `appcontainer_common` and `learning_mode_windows`.
- If `verify-guix-pull` reports a package-cache or `guix pull` failure, treat
  it as a channel breakage and fix it before closing out the bump.
