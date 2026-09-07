#!/bin/sh
set -eu

repository=$(CDPATH='' cd -- "$(dirname "$0")/../.." && pwd)
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

guix repl -- "$repository/tests/extra-profile/channel-profile.scm" \
  "$repository" "$test_root" "$(command -v guix)"

export HOME="$test_root/home"
export XDG_CONFIG_HOME="$test_root/config"
export XDG_CACHE_HOME="$test_root/cache"
unset GUILE_LOAD_PATH GUILE_LOAD_COMPILED_PATH GUIX_PACKAGE_PATH GUIX_EXTENSIONS_PATH GUIX_PROFILE
export GUILE_AUTO_COMPILE=0
guix="$test_root/profile/bin/guix"
definition="$XDG_CONFIG_HOME/guix/extra-profiles/channel/manifest.scm"
mkdir -p "$HOME" "$(dirname "$definition")"
printf '%s\n' '(specifications->manifest (list "fixture-profile-a"))' > "$definition"

# No -L or module-path environment variables may bypass channel discovery.
"$guix" extra-profile reconfigure channel --dry-run
test ! -e "$HOME/.guix-extra-profiles/channel/channel"
"$guix" extra-profile reconfigure channel
profile=$("$guix" extra-profile path channel)
test "$("$profile/bin/profile-a")" = a2
# Resolve profile-a inside the composed environment, not in this test driver.
# shellcheck disable=SC2016
"$guix" extra-profile shell channel -- -- sh -c 'test "$(profile-a)" = a2'
