#!/bin/sh
set -eu

repository=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

export HOME="$test_root/home"
export XDG_CONFIG_HOME="$test_root/config"
export XDG_CACHE_HOME="$test_root/cache"
export GUIX_PROFILE="$test_root/guix-profile"
export GUIX_EXTENSIONS_PATH="$repository/channel/guix/extensions"
export GUILE_LOAD_PATH="$repository/channel${GUILE_LOAD_PATH:+:$GUILE_LOAD_PATH}"

definitions="$XDG_CONFIG_HOME/guix/extra-profiles"
fixtures="$repository/tests"
mkdir -p "$HOME" "$definitions/profile-a" "$definitions/profile-b"
cp "$repository/tests/extra-profile/fixtures/profile-a.scm" \
   "$definitions/profile-a/manifest.scm"
cp "$repository/tests/extra-profile/fixtures/profile-b.scm" \
   "$definitions/profile-b/manifest.scm"

test "$(guix extra-profile list)" = "$(printf 'profile-a\nprofile-b')"
guix extra-profile show profile-a | grep 'Profile: .* (not-configured)' >/dev/null

guix extra-profile reconfigure --all -L "$fixtures"

profile_a=$(guix extra-profile path profile-a)
profile_b=$(guix extra-profile path profile-b)
test -L "$profile_a"
test -L "$profile_b"

generation_before=$(readlink "$profile_a")
guix extra-profile reconfigure profile-a -L "$fixtures"
test "$(readlink "$profile_a")" = "$generation_before"

guix extra-profile shell profile-a profile-b -- \
  -- sh -c 'test "$(collision)" = a && command -v profile-a && command -v profile-b'
guix extra-profile shell profile-b profile-a -- \
  -- sh -c 'test "$(collision)" = b'
guix extra-profile shell profile-a -- \
  -L "$fixtures" \
  -m "$repository/tests/extra-profile/fixtures/project.scm" \
  -- sh -c 'test "$(collision)" = project && command -v profile-a && command -v project-command'

set +e
guix extra-profile shell profile-a -- -- sh -c 'exit 17'
status=$?
set -e
test "$status" -eq 17

set +e
guix extra-profile shell profile-a -- -- sh -c 'kill -TERM $$'
status=$?
set -e
test "$status" -eq 143

guix extra-profile shell profile-a -- \
  -- sh -c 'test "$1" = --profile' sh --profile

set +e
guix extra-profile shell profile-a -- -p "$profile_b" \
  >"$test_root/profile-option.out" 2>&1
status=$?
set -e
test "$status" -ne 0
grep "cannot be used with package options" "$test_root/profile-option.out" >/dev/null

set +e
guix extra-profile shell profile-a -- --profile="$profile_b" \
  >"$test_root/long-profile-option.out" 2>&1
status=$?
set -e
test "$status" -ne 0
grep "cannot be used with package options" \
  "$test_root/long-profile-option.out" >/dev/null

cache_directory="$XDG_CACHE_HOME/guix/extra-profile/shell-manifests"
test "$(stat -c %a "$cache_directory")" = 700
find "$cache_directory" -type f -name '*.scm' \
  -exec sh -c 'test "$(stat -c %a "$1")" = 600' sh {} \;

cp "$repository/tests/extra-profile/fixtures/invalid.scm" \
   "$definitions/profile-a/manifest.scm"
guix extra-profile shell profile-a -- -- sh -c 'command -v profile-a'

mkdir -p "$definitions/unconfigured"
cp "$repository/tests/extra-profile/fixtures/profile-a.scm" \
   "$definitions/unconfigured/manifest.scm"
set +e
guix extra-profile shell unconfigured -- -- true \
  >"$test_root/unconfigured.out" 2>&1
status=$?
set -e
test "$status" -ne 0
grep "has not been configured" "$test_root/unconfigured.out" >/dev/null
grep "reconfigure unconfigured" "$test_root/unconfigured.out" >/dev/null

cp "$repository/tests/extra-profile/fixtures/profile-a-v2.scm" \
   "$definitions/profile-a/manifest.scm"
guix extra-profile reconfigure profile-a -L "$fixtures"
test "$(readlink "$profile_a")" != "$generation_before"
guix extra-profile shell profile-a -- -- sh -c 'test "$(collision)" = a2'

guix extra-profile generations profile-a >/dev/null
guix extra-profile roll-back profile-a
test "$(readlink "$profile_a")" = "$generation_before"
guix extra-profile shell profile-a -- -- sh -c 'test "$(collision)" = a'

mkdir -p "$definitions/dry-run"
cp "$repository/tests/extra-profile/fixtures/profile-a.scm" \
   "$definitions/dry-run/manifest.scm"
guix extra-profile reconfigure dry-run --dry-run -L "$fixtures"
test ! -e "$HOME/.guix-extra-profiles/dry-run/dry-run"

set +e
guix extra-profile shell -- --help >"$test_root/missing-name.out" 2>&1
status=$?
set -e
test "$status" -ne 0
grep "at least one profile name" "$test_root/missing-name.out" >/dev/null

set +e
guix extra-profile shell profile-a -CWNF \
  >"$test_root/missing-boundary.out" 2>&1
status=$?
set -e
test "$status" -ne 0
grep "invalid profile name '-CWNF'" "$test_root/missing-boundary.out" >/dev/null
