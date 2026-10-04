#!/bin/sh
set -eu

command -v bash >/dev/null
for argument in "$@"; do
  case "$argument" in
  --require-private-display)
    globals=$(wayland-info)
    if printf '%s\n' "$globals" | grep -q 'weston_debug_v1'; then
      echo 'host compositor protocols are directly accessible'
      exit 1
    fi
    ;;
  --host-netns=*)
    [ "$(readlink /proc/self/ns/net)" != "${argument#--host-netns=}" ] || {
      echo 'host network namespace is shared'
      exit 1
    }
    ;;
  --server-url=*)
    [ "$(curl --noproxy '*' --max-time 3 --fail --silent \
      "${argument#--server-url=}")" = 'server-ok' ]
    ;;
  --require-playback)
    [ -n "${PULSE_SERVER-}" ]
    sources=$(pactl list short sources)
    [ "$(printf '%s\n' "$sources" | wc -l)" -eq 1 ]
    printf '%s\n' "$sources" | grep -q 'playback.monitor'
    if pactl load-module module-null-source source_name=host-recording; then
      echo 'audio clients can load recording modules'
      exit 1
    fi
    yes "$(printf '\100\300')" | head -c 192000 | \
      pacat --playback --raw --rate=48000 --format=u8 --channels=1
    ;;
  --*) ;;
  *)
    [ ! -e "$argument" ] || {
      echo "host path is visible: $argument"
      exit 1
    }
    for fd in /proc/self/fd/*; do
      [ "$(readlink "$fd" || true)" != "$argument" ] || {
        echo 'host file descriptor is inherited'
        exit 1
      }
    done
    ;;
  esac
done

[ -z "${DISPLAY-}${XAUTHORITY-}${XDG_CONFIG_HOME-}${XDG_DATA_HOME-}${XDG_CACHE_HOME-}${SSH_AUTH_SOCK-}" ]
[ -S "$XDG_RUNTIME_DIR/wayland-0" ]
[ ! -e "$XDG_RUNTIME_DIR/host-service" ]
[ ! -e /dev/dri ] && [ ! -e /dev/snd ]
if dbus-send --session --print-reply --dest=org.freedesktop.secrets \
  /org/freedesktop/secrets org.freedesktop.DBus.Peer.Ping; then
  echo 'host Secret Service is reachable'
  exit 1
fi
printf 'state=private\n' >"$HOME/state-token"
printf 'isolation=ok\n'
case " $* " in
  *' --wait-for-interrupt '*)
    touch "$HOME/interrupt-ready"
    sleep 60
    ;;
esac
