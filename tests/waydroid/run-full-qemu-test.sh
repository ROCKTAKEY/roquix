#!/bin/sh
set -eu

repo_root=$(CDPATH= cd -- "$(dirname -- "$0")/../.." && pwd)
log=${WAYDROID_FULL_QEMU_LOG:-"$repo_root/.test-logs/waydroid/full-qemu-test.log"}
timeout_seconds=${WAYDROID_FULL_QEMU_TIMEOUT:-14400}

if ! command -v guix >/dev/null 2>&1; then
  echo "guix is required" >&2
  exit 127
fi

if ! command -v timeout >/dev/null 2>&1; then
  echo "timeout is required" >&2
  exit 127
fi

mkdir -p "$(dirname -- "$log")"
vm_script=$(guix build -L "$repo_root/channel" \
  -f "$repo_root/tests/waydroid/full-qemu-test.scm")

echo "running Waydroid full QEMU test"
echo "vm:  $vm_script"
echo "log: $log"

set +e
timeout "$timeout_seconds" "$vm_script" \
  -accel tcg,thread=multi \
  -cpu max \
  >"$log" 2>&1
status=$?
set -e

cat "$log"

if [ "$status" -ne 0 ]; then
  echo "QEMU run failed with status $status" >&2
  exit "$status"
fi

grep -q "WAYDROID-FULL-CHECK: network access: PASS" "$log"
grep -q "WAYDROID-FULL-CHECK: waydroid init: PASS" "$log"
grep -q "WAYDROID-FULL-CHECK: herd start waydroid-container: PASS" "$log"
grep -q "WAYDROID-FULL-CHECK: herd status waydroid-container: PASS" "$log"
grep -q "WAYDROID-FULL-CHECK: waydroid status: PASS" "$log"
grep -q "WAYDROID-FULL-CHECK: headless Wayland session and show-full-ui: PASS" "$log"
grep -q "WAYDROID-FULL-CHECK: failures=0" "$log"

if grep -q "WAYDROID-FULL-CHECK: failures=[1-9]" "$log"; then
  echo "Waydroid full QEMU test reported failures" >&2
  exit 1
fi

echo "Waydroid full QEMU test passed"
