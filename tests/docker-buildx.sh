#!/bin/sh
set -eu

package=${1:?usage: docker-buildx.sh PACKAGE DOCKER}
docker=${2:?usage: docker-buildx.sh PACKAGE DOCKER}
config=$(mktemp -d)
trap 'rm -rf "$config"' EXIT HUP INT TERM

"$package/bin/docker-buildx" version | grep -F 'github.com/docker/buildx v0.38.2'
test -x "$package/lib/docker/cli-plugins/docker-buildx"
printf '{"cliPluginsExtraDirs":["%s/lib/docker/cli-plugins"]}\n' "$package" > "$config/config.json"
"$docker" --config "$config" buildx version | grep -F 'github.com/docker/buildx v0.38.2'
"$docker" --config "$config" buildx bake --help > /dev/null
