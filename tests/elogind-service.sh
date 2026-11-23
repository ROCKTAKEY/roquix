set -eu
test "$(loginctl show-session "${XDG_SESSION_ID:?}" -p Name)" = Name=tester
test "$(stat -fc %T /sys/fs/cgroup)" = cgroup2fs
! grep -q ' - cgroup ' /proc/self/mountinfo
