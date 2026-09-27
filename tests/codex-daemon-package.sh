#!/bin/sh
set -eu

package=$1
home=$(mktemp -d "${TMPDIR:-/tmp}/codex-daemon-package.XXXXXX")
codex="$package/bin/codex"
run_codex() {
    CODEX_HOME="$home" "$codex" app-server daemon "$@"
}
cleanup() {
    run_codex stop >/dev/null 2>&1 || :
    rm -rf "$home"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM

run_codex start
version=$(run_codex version)
case "$version" in
    *'"status":"running"'*) printf '%s\n' "$version" ;;
    *) printf 'daemon did not start: %s\n' "$version" >&2; exit 1 ;;
esac
