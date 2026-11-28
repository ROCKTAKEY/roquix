#!/bin/sh
set -eu
call() {
    dbus-send --session --print-reply --reply-timeout=2000 \
        --dest=org.freedesktop.portal.Desktop /org/freedesktop/portal/desktop \
        "org.freedesktop.portal.$1"
}
case " $* " in
    *" --network-monitor "*) call NetworkMonitor.GetStatus; exit ;;
esac
call Camera.AccessCamera
if error=$(call ScreenCast.CreateSession 2>&1); then
    echo 'ScreenCast was reachable with only Camera enabled' >&2
    exit 1
fi
case "$error" in
    *org.freedesktop.DBus.Error.AccessDenied*|*org.freedesktop.DBus.Error.UnknownMethod*) ;;
    *) echo "$error" >&2; exit 1 ;;
esac
