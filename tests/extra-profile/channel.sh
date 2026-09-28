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

printf '(list "-E" "EXTRA_PROFILE_SHELL_SAVED=value with spaces")\n' \
  >"$XDG_CONFIG_HOME/guix/extra-profiles/channel/shell-arguments.scm"
# Expand the variable inside the Guix shell, after saved options take effect.
# shellcheck disable=SC2016
"$guix" extra-profile shell channel -- -- \
  sh -c 'test "$EXTRA_PROFILE_SHELL_SAVED" = "value with spaces"'

arguments_only="$XDG_CONFIG_HOME/guix/extra-profiles/arguments-only"
mkdir -p "$arguments_only"
cat >"$arguments_only/shell-arguments.scm" <<'EOF'
(define home (getenv "HOME"))
(list "-E" (string-append "EXTRA_PROFILE_TEST_HOME=" home))
EOF
test ! -e "$arguments_only/manifest.scm"
"$guix" extra-profile list | grep '^arguments-only$' >/dev/null
# The Scheme expression uses HOME before Guix launches the command.
# shellcheck disable=SC2016
"$guix" extra-profile shell arguments-only -- -- \
  sh -c 'test "$EXTRA_PROFILE_TEST_HOME" = "$HOME"'

mkdir -p "$HOME/shared with spaces" "$HOME/exposed with spaces"
printf '%s\n' shared >"$HOME/shared with spaces/input"
printf '%s\n' exposed >"$HOME/exposed with spaces/input"
cat >"$arguments_only/shell-arguments.scm" <<'EOF'
(let ((home (getenv "HOME")))
  (list "--container"
        (string-append "--share=" home "/shared with spaces=/shared-data")
        (string-append "--expose=" home "/exposed with spaces=/exposed-data")))
EOF
# The host profile symlink is not mounted in the container; its store target is.
container_shell=$(readlink -f "$(command -v sh)")
# shellcheck disable=SC2016
"$guix" extra-profile shell arguments-only -- -- "$container_shell" -c '
  IFS= read -r shared < /shared-data/input
  IFS= read -r exposed < /exposed-data/input
  test "$shared" = shared
  test "$exposed" = exposed
  printf "%s\n" written > /shared-data/output
  if (printf "%s\n" forbidden > /exposed-data/output) 2>/dev/null; then
    exit 1
  fi
'
test "$(cat "$HOME/shared with spaces/output")" = written
test ! -e "$HOME/exposed with spaces/output"
