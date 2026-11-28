#!/bin/sh
set -eu
selected=" $1 "
interfaces=$2
shift 2
directory=$(mktemp -d)
host=$DBUS_SESSION_BUS_ADDRESS
filtered=unix:path=$directory/bus
pids=
trap 'kill $pids 2>/dev/null || :; wait; rm -rf "$directory"' EXIT
for service in Desktop Documents; do
    dbus-test-tool echo --name="org.freedesktop.portal.$service" &
    pids="$pids $!"
done
xdg-dbus-proxy "$host" "$directory/bus" --filter "$@" &
pids="$pids $!"

call() {
    DBUS_SESSION_BUS_ADDRESS=$1 dbus-send --session --print-reply --reply-timeout=2000 \
        --dest="org.freedesktop.portal.$service" "$path" "org.freedesktop.portal.$member"
}

check() {
    allowed=$1
    call "$host" >/dev/null
    if call "$filtered" >"$directory/reply" 2>&1; then
        [ "$allowed" = yes ] && return 0
    else
        if [ "$allowed" = no ] && grep -Eq 'org\.freedesktop\.DBus\.Error\.(AccessDenied|UnknownMethod|ServiceUnknown)' "$directory/reply"; then
            return 0
        fi
    fi
    echo "Unexpected reply for $member at $path (allowed=$allowed)" >&2
    cat "$directory/reply" >&2
    exit 1
}

for service in Desktop Documents; do
    path=/org/freedesktop/portal/desktop
    member=Camera.Probe
    for attempt in $(seq 1 100); do
        if [ -S "$directory/bus" ] && call "$host" >/dev/null 2>&1; then break; fi
        sleep .05
    done
    call "$host" >/dev/null
done
for interface in $interfaces; do
    case "$interface" in
        Documents|FileTransfer) service=Documents; path=/org/freedesktop/portal/documents ;;
        *) service=Desktop; path=/org/freedesktop/portal/desktop ;;
    esac
    member=$interface.Probe
    case "$selected" in *" $interface "*) check yes ;; *) check no ;; esac
done
case "$selected" in " Camera "|" Usb "|"  ") ;; *) exit 0 ;; esac
service=Desktop
for kind in Request Session; do
    case "$kind" in
        Request) path=/org/freedesktop/portal/desktop/request/test/one ;;
        Session) path=/org/freedesktop/portal/desktop/session/test/one ;;
    esac
    member=$kind.Close
    case "$selected:$kind" in
        *' Usb '*) check yes ;;
        *' Camera '*:Request) check yes ;;
        *) check no ;;
    esac
    path=/org/freedesktop/portal/desktop
    check no
done
