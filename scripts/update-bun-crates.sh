#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CRATES_FILE="${REPO_ROOT}/channel/roquix/packages/rust-crates.scm"
CHANNEL_DIR="${REPO_ROOT}/channel"
WORK_ROOT="$(mktemp -d /tmp/update-bun-crates.XXXXXX)"

trap 'rm -rf -- "${WORK_ROOT}"' EXIT

if ! command -v cargo >/dev/null; then
  echo "cargo is required; run under 'guix shell rust'" >&2
  exit 1
fi

declare -a CRATE_NAMES=(
  "bun-lol-html-1.0"
  "bun-lol-html-1.2.0"
  "bun-lol-html-1.2.17"
  "bun-lol-html-1.3.1"
  "bun-lol-html-1.3.13"
)

declare -a SOURCE_EXPRESSIONS=(
  '(cadr (assoc "lol-html" (@@ (roquix packages bun-bootstrap) %bun-1.0.7-dependency-sources)))'
  '(cadr (assoc "lolhtml" (@@ (roquix packages bun-bootstrap) %bun-1.2.0-changed-sources)))'
  '(cadr (assoc "lolhtml" (@@ (roquix packages bun-bootstrap) %bun-1.2.17-changed-sources)))'
  '(cadr (assoc "lolhtml" (@@ (roquix packages bun-bootstrap) %bun-1.3.1-dependency-sources)))'
  '(cadr (assoc "lolhtml" (@@ (roquix packages bun-bootstrap) %bun-1.3.13-changed-sources)))'
)

for index in "${!CRATE_NAMES[@]}"; do
  name="${CRATE_NAMES[index]}"
  source="$(guix build -L "${CHANNEL_DIR}" \
    -e "${SOURCE_EXPRESSIONS[index]}" | tail -n 1)"
  writable_source="${WORK_ROOT}/${name}"
  mkdir -p "${writable_source}"
  cp -R "${source}/." "${writable_source}/"
  chmod -R u+w "${writable_source}"

  # Use an upstream lock as the starting point when it exists.  Some lol-html
  # commits changed Cargo.toml without refreshing that lock, so resolve the
  # writable copy before importing.  Cargo preserves compatible locked
  # versions and updates only what the manifests require.
  CARGO_HOME="${WORK_ROOT}/cargo-home-${name}" \
    cargo metadata \
    --manifest-path="${writable_source}/c-api/Cargo.toml" \
    --format-version=1 >/dev/null
  lock="${writable_source}/c-api/Cargo.lock"

  guix import --insert="${CRATES_FILE}" crate "${name}" \
    --lockfile="${lock}"
done
