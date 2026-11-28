#!/bin/sh
# Run with weston, dbus and xdg-desktop-portal in a Guix shell.
set -eu
runtime=$(mktemp -d)
trap 'rm -rf "$runtime"' EXIT
export XDG_RUNTIME_DIR="$runtime" XDG_STATE_HOME="$runtime/state"
export WAYLAND_DISPLAY=wayland-test
dbus-run-session -- sh -eu -c '
    weston --backend=headless --renderer=pixman --shell=desktop --socket="$WAYLAND_DISPLAY" \
        --no-config --idle-time=0 >"$XDG_RUNTIME_DIR/weston.log" 2>&1 &
    compositor=$!
    trap "kill $compositor 2>/dev/null || :; wait" EXIT
    for attempt in $(seq 1 100); do
        [ ! -S "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" ] || break
        sleep .05
    done
    "$1/bin/portal-probe" --network-monitor
' sh "$1"
