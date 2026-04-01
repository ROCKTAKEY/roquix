---
name: update-roquix-codex
description: Update roquix's packaged openai/codex release. Use when bumping `channel/roquix/packages/codex.scm`, regenerating `channel/roquix/packages/rust-crates.scm` from upstream `codex-rs/Cargo.lock`, fixing `scripts/update-codex.sh` or `.github/workflows/update-codex.yml`, or validating the bump with `guix build` and the existing `verify-guix-pull` workflow.
---

# Update Roquix Codex

## Overview

Use the repository's existing updater first. Keep the package files and the
automation that maintains them in sync with the current Guix CLI.

## Workflow

1. Run the updater from the repository root.
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
   - If the updater logic changes, `scripts/update-codex.sh` and
     `.github/workflows/update-codex.yml` should change together.
4. Validate package resolution.
   - `guix build -L channel -e '(@ (roquix packages codex) codex)' -n`
5. Run a full build before closing out the bump.
   - `guix build -K -L channel -e '(@ (roquix packages codex) codex)'`
   - Expect long logs. `cargo install` in the `install` phase can rebuild a
     large part of the workspace in release mode even after the earlier
     `build` phase succeeded.
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

- `guix show codex` may resolve to Guix's upstream package instead of
  `(roquix packages codex)`. Prefer `guix build -e '(@ (roquix packages codex)
  codex)'` or module-local checks.
- `cargo-build-system` can treat a bare `origin` in `native-inputs` as a cargo
  source to unpack. Wrap helper archives that are not Rust crates in a small
  package instead of passing the raw `origin` directly.
- If `verify-guix-pull` reports a package-cache or `guix pull` failure, treat
  it as a channel breakage and fix it before closing out the bump.
