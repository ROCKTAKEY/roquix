#!/usr/bin/env bash

set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 rust-vX.Y.Z" >&2
  exit 1
fi

TAG="$1"
if [[ "${TAG}" != rust-v* ]]; then
  echo "Tag must start with 'rust-v'." >&2
  exit 1
fi
VERSION="${TAG#rust-v}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

WORKDIR="$(mktemp -d)"
trap 'rm -rf "${WORKDIR}"' EXIT

git clone --depth 1 --branch "${TAG}" https://github.com/openai/codex "${WORKDIR}/codex"

BASE32="$(guix hash -rx "${WORKDIR}/codex")"

LOCKFILE="${WORKDIR}/codex/codex-rs/Cargo.lock"
if [[ ! -f "${LOCKFILE}" ]]; then
  echo "Expected lockfile not found at ${LOCKFILE}" >&2
  exit 1
fi

guix import --insert="${REPO_ROOT}/channel/roquix/packages/rust-crates.scm" \
  crate codex \
  --lockfile="${LOCKFILE}"

PACKAGE_FILE="${REPO_ROOT}/channel/roquix/packages/codex.scm"
tmp_backup="$(mktemp)"
cp "${PACKAGE_FILE}" "${tmp_backup}"

export VERSION BASE32
perl -0pi -e '
  my $version = $ENV{VERSION} // die "VERSION is required\n";
  my $base32 = $ENV{BASE32} // die "BASE32 is required\n";

  s{(\(define %codex-release-version ")[^"]*("\))}
   {$1 . $version . $2}se
    or die "Failed to update codex version\n";

  s{(\(define-public codex\s+\(package.*?\(sha256\s+\(base32 ")[^"]*("\)\)\))}
   {$1 . $base32 . $2}se
    or die "Failed to update codex source hash\n";
' "${PACKAGE_FILE}"

if ! grep -q "(define %codex-release-version \"${VERSION}\")" "${PACKAGE_FILE}"; then
  echo "Failed to update version in ${PACKAGE_FILE}" >&2
  mv "${tmp_backup}" "${PACKAGE_FILE}"
  exit 1
fi

if ! grep -q "(base32 \"${BASE32}\")" "${PACKAGE_FILE}"; then
  echo "Failed to update base32 hash in ${PACKAGE_FILE}" >&2
  mv "${tmp_backup}" "${PACKAGE_FILE}"
  exit 1
fi

rm -f "${tmp_backup}"

echo "Updated codex to ${VERSION}."
echo "Regenerated channel/roquix/packages/rust-crates.scm and updated channel/roquix/packages/codex.scm."
