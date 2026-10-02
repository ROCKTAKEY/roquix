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

cat >"$XDG_CONFIG_HOME/guix/extra-profiles/channel/shell.scm" <<'EOF'
(use-modules (roquix extra-profiles shell-configuration))
(shell-configuration
 (pure? #t)
 (preserve '("^EXTRA_PROFILE_SHELL_KEEP$"))
 (environment-variables '(("EXTRA_PROFILE_SHELL_SAVED" . "value with spaces=ok"))))
EOF
export EXTRA_PROFILE_SHELL_KEEP='inherited spaces'
export EXTRA_PROFILE_SHELL_DROP=unwanted
test_shell=$(command -v sh)
# Check environment settings in the actual Guix process.
# shellcheck disable=SC2016
"$guix" extra-profile shell channel -- -- \
  "$test_shell" -c 'test "$EXTRA_PROFILE_SHELL_SAVED" = "value with spaces=ok" &&
    test "$EXTRA_PROFILE_SHELL_KEEP" = "inherited spaces" &&
    test "${EXTRA_PROFILE_SHELL_DROP-unset}" = unset'

shell_only="$XDG_CONFIG_HOME/guix/extra-profiles/shell-only"
mkdir -p "$shell_only"
cat >"$shell_only/shell.scm" <<'EOF'
(use-modules (roquix extra-profiles shell-configuration))
(define home (getenv "HOME"))
(shell-configuration
 (environment-variables (list (cons "EXTRA_PROFILE_TEST_HOME" home)
                              (cons "EXTRA_PROFILE_SHELL_SAVED" "profile override"))))
EOF
test ! -e "$shell_only/manifest.scm"
"$guix" extra-profile list | grep '^shell-only$' >/dev/null
# The Scheme expression uses HOME before Guix launches the command.
# shellcheck disable=SC2016
"$guix" extra-profile shell shell-only -- -- \
  sh -c 'test "$EXTRA_PROFILE_TEST_HOME" = "$HOME"'

# Later profiles override assignments; explicit options follow saved settings.
# shellcheck disable=SC2016
"$guix" extra-profile shell channel shell-only -- -- \
  "$test_shell" -c 'test "$EXTRA_PROFILE_SHELL_SAVED" = "profile override"'
# shellcheck disable=SC2016
"$guix" extra-profile shell channel shell-only -- \
  -E 'EXTRA_PROFILE_SHELL_SAVED=explicit override' -- \
  "$test_shell" -c 'test "$EXTRA_PROFILE_SHELL_SAVED" = "explicit override"'

mkdir -p "$HOME/shared with spaces" "$HOME/exposed with spaces"
printf '%s\n' shared >"$HOME/shared with spaces/input"
printf '%s\n' exposed >"$HOME/exposed with spaces/input"
cat >"$shell_only/shell.scm" <<'EOF'
(use-modules (roquix extra-profiles shell-configuration))
(let ((home (getenv "HOME")))
  (shell-configuration
   (container? #t)
   (mounts
    (list (share (string-append home "/shared with spaces") #:target "/shared-data")
          (expose (string-append home "/exposed with spaces") #:target "/exposed-data")
          (share (string-append home "/private/cache") #:target "/cache"
                 #:on-missing 'create-directory)
          (expose (string-append home "/absent") #:target "/absent"
                  #:on-missing 'skip)))))
EOF
# The host profile symlink is not mounted in the container; its store target is.
container_shell=$(readlink -f "$(command -v sh)")
# shellcheck disable=SC2016
"$guix" extra-profile shell shell-only -- -- "$container_shell" -c '
  IFS= read -r shared < /shared-data/input
  IFS= read -r exposed < /exposed-data/input
  test "$shared" = shared
  test "$exposed" = exposed
  test ! -e /absent
  printf "%s\n" cached > /cache/output
  printf "%s\n" written > /shared-data/output
  if (printf "%s\n" forbidden > /exposed-data/output) 2>/dev/null; then
    exit 1
  fi
'
test "$(cat "$HOME/shared with spaces/output")" = written
test ! -e "$HOME/exposed with spaces/output"
test "$(cat "$HOME/private/cache/output")" = cached
test "$(stat -c %a "$HOME/private")" = 700
test "$(stat -c %a "$HOME/private/cache")" = 700
