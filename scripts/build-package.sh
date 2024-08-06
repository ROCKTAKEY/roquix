#!/bin/bash

PACKAGE_TO_BUILD=$*

for package in $PACKAGE_TO_BUILD; do
    echo "::group::Build $package";
    guix build "$package"
    echo "::endgroup::"
done
