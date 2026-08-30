#!/bin/sh
set -eu

if test "$#" -gt 0; then
  exec guix repl -L channel "$@"
fi

for test_file in \
  tests/extra-profile/paths.scm \
  tests/extra-profile/operations.scm \
  tests/extra-profile/shell.scm \
  tests/extra-profile/command.scm
do
  guix repl -L channel "$test_file"
done

exec tests/extra-profile/command.sh
