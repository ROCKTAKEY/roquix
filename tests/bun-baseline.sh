#!/usr/bin/env bash
set -eu
ulimit -c 0

program=${1:?Usage: bun-baseline.sh BUN_BINARY EXPECTED_VERSION}
version=${2:?Usage: bun-baseline.sh BUN_BINARY EXPECTED_VERSION}
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT HUP INT TERM
export HOME="$test_root"
export XDG_CONFIG_HOME="$test_root/config"
export XDG_CACHE_HOME="$test_root/cache"
export XDG_DATA_HOME="$test_root/data"
export XDG_STATE_HOME="$test_root/state"
unset LD_LIBRARY_PATH LD_PRELOAD

# Every seed runs on the build host, so the entire chain must work without AVX2.
test "$(qemu-x86_64 -cpu Nehalem "$program" --version)" = "$version"
printf '%s\n' 'console.log(6 * 7)' > "$test_root/probe.js"
test "$(qemu-x86_64 -cpu Nehalem "$program" "$test_root/probe.js")" = 42
