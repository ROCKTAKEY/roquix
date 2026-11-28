#!/bin/sh
# Run under dbus-run-session with a built portal-container fixture as argument.
set -eu
XDG_RUNTIME_DIR=$(mktemp -d)
export XDG_RUNTIME_DIR
export XDG_STATE_HOME="$XDG_RUNTIME_DIR/state" WAYLAND_DISPLAY=wayland-test
dbus-test-tool echo --name=org.freedesktop.portal.Desktop &
service=$!
weston --backend=headless --renderer=pixman --shell=desktop --socket=wayland-test \
    --no-config --idle-time=0 >"$XDG_RUNTIME_DIR/weston.log" 2>&1 &
compositor=$!
trap 'kill "$service" "$compositor" 2>/dev/null || :; wait; rm -rf "$XDG_RUNTIME_DIR"' EXIT
for attempt in $(seq 1 100); do
    if [ -S "$XDG_RUNTIME_DIR/wayland-test" ] && dbus-send --session --print-reply \
        --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop \
        org.freedesktop.portal.ScreenCast.CreateSession >/dev/null 2>&1; then
        "$1/bin/portal-probe"
        exit
    fi
    sleep .05
done
echo 'Headless compositor or test desktop service did not start' >&2
exit 1
