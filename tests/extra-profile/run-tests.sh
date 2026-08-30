#!/bin/sh
set -eu

exec guix repl -L channel "$@"
