#!/bin/bash

GITHUB_REPOSITORY=$1
GITHUB_EVENT_BEFORE=$2
GITHUB_EVENT_AFTER=$3


CHANGED_FILES=$(curl --silent "https://api.github.com/repos/${GITHUB_REPOSITORY}/compare/${GITHUB_EVENT_BEFORE}...${GITHUB_EVENT_AFTER}" | jq -r '.files[] | .filename');

for file in $CHANGED_FILES; do
    PACKAGES_TO_BUILD=$(printf "%s\n%s" "$PACKAGES_TO_BUILD" "$(guix package -A | awk -v file="$file" '$4 ~ file { print $1 }')")
    export PACKAGES_TO_BUILD
done

echo PACKAGES_TO_BUILD="$PACKAGES_TO_BUILD" >> "$GITHUB_OUTPUT"
echo "$PACKAGES_TO_BUILD"
