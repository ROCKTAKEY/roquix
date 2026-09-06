#!/bin/sh
set -eu

repository=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)
scheme_test_runner="$repository/tests/extra-profile/run-scheme-test.scm"

if test "$#" -gt 0; then
  exec guix repl -L "$repository/channel" -- \
    "$scheme_test_runner" "$1"
fi

sh "$repository/tests/extra-profile/test-runner.sh"

for test_file in \
  "$repository/tests/extra-profile/paths.scm" \
  "$repository/tests/extra-profile/operations.scm" \
  "$repository/tests/extra-profile/shell.scm" \
  "$repository/tests/extra-profile/command.scm"
do
  guix repl -L "$repository/channel" -- \
    "$scheme_test_runner" "$test_file"
done

exec "$repository/tests/extra-profile/command.sh"
