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
  --host-port=*)
    if timeout 2 bash -c 'exec 3<>/dev/tcp/127.0.0.1/$1' bash \
      "${argument#--host-port=}" 2>/dev/null; then
      echo 'host loopback is reachable'
      exit 1
    fi
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

[ -z "${DISPLAY-}${XAUTHORITY-}${PULSE_SERVER-}${XDG_CONFIG_HOME-}${XDG_DATA_HOME-}${XDG_CACHE_HOME-}${SSH_AUTH_SOCK-}" ]
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
