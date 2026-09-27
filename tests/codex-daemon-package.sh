#!/bin/sh
set -eu

package=$1
home=$(mktemp -d "${TMPDIR:-/tmp}/codex-daemon-package.XXXXXX")
cleanup() {
    CODEX_HOME="$home" "$package/bin/codex" app-server daemon stop >/dev/null 2>&1 || :
    rm -rf "$home"
}
trap cleanup EXIT HUP INT TERM

CODEX_HOME="$home" "$package/bin/codex" app-server daemon start
version=$(CODEX_HOME="$home" "$package/bin/codex" app-server daemon version)
case "$version" in
    *'"status":"running"'*) printf '%s\n' "$version" ;;
    *) printf 'daemon did not start: %s\n' "$version" >&2; exit 1 ;;
esac
