#!/bin/sh
set -eu

profile=$(CDPATH='' cd -- "${1:?Usage: bun-import-cli.sh GUIX_PROFILE}" && pwd)
test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT HUP INT TERM
export HOME="$test_root/home"
export XDG_CONFIG_HOME="$test_root/config"
export XDG_CACHE_HOME="$test_root/cache"
export XDG_DATA_HOME="$test_root/data"
export XDG_STATE_HOME="$test_root/state"
export LC_ALL=C
unset GUILE_LOAD_PATH GUILE_LOAD_COMPILED_PATH GUIX_PACKAGE_PATH GUIX_EXTENSIONS_PATH GUIX_PROFILE
export GUILE_AUTO_COMPILE=0
mkdir -p "$HOME" "$test_root/source"
guix="$profile/bin/guix"

"$guix" import-bun --help > "$test_root/help"
grep -q 'Usage: guix import-bun' "$test_root/help"
"$guix" import crate --help > /dev/null

cat > "$test_root/source/package.json" <<'EOF'
{"name":"cli-fixture","version":"1.0.0"}
EOF
cat > "$test_root/source/bun.lock" <<'EOF'
{"lockfileVersion":1,"workspaces":{"":{"name":"cli-fixture"}},"packages":{}}
EOF

"$guix" import-bun "$test_root/source/bun.lock" > "$test_root/expression"
grep -q '%cli-fixture-1.0.0-npm-inputs' "$test_root/expression"
printf '%s\n' '(define-module (cli-fixture) #:use-module (roquix build-system bun))' > "$test_root/inputs.scm"
"$guix" import-bun --insert="$test_root/inputs.scm" "$test_root/source/bun.lock"
grep -q '%cli-fixture-1.0.0-npm-inputs' "$test_root/inputs.scm"
cp "$test_root/inputs.scm" "$test_root/first.scm"
"$guix" import-bun --insert="$test_root/inputs.scm" "$test_root/source/bun.lock"
cmp "$test_root/first.scm" "$test_root/inputs.scm"

if "$guix" import-bun > "$test_root/error" 2>&1; then
    echo 'import-bun accepted a missing lockfile' >&2
    exit 1
fi
grep -q 'too few arguments' "$test_root/error"
