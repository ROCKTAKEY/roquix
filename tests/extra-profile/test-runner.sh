#!/bin/sh
set -eu

repository=$(CDPATH= cd -- "$(dirname "$0")/../.." && pwd)

set +e
"$repository/tests/extra-profile/run-tests.sh" \
  "$repository/tests/extra-profile/fixtures/failing-test.scm" >/dev/null 2>&1
status=$?
set -e

test "$status" -ne 0
