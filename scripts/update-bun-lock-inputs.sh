#!/bin/sh
set -eu

repository=$(CDPATH='' cd -- "$(dirname -- "$0")/.." && pwd)
channel="$repository/channel"
output="$channel/roquix/packages/bun-lock-inputs.scm"

source_origin()
{
    module=$1
    variable=$2
    guix build -L "$channel" -e "(@@ ($module) $variable)"
}

import_lock()
{
    source=$1
    relative_lock=$2
    project=$3
    lock="$source/$relative_lock"

    set -- guix repl -L "$channel" -- "$repository/scripts/import-bun.scm" \
        "--insert=$output" "$lock"
    if test "${relative_lock##*.}" = lockb; then
        set -- "$@" "--source=$source"
    fi
    if test "$project" != .; then
        set -- "$@" "--project=$project"
    fi

    echo "importing $lock"
    "$@"
}

import_bun_version()
{
    version=$1
    root_lock=$2
    bun_error=$3
    node_fallbacks=$4
    source=$(source_origin roquix\ packages\ bun-bootstrap \
                           "%bun-$version-source")

    import_lock "$source" "$root_lock" .
    if test "$bun_error" = yes; then
        import_lock "$source" \
            "packages/bun-error/$root_lock" packages/bun-error
    fi
    if test "$node_fallbacks" = yes; then
        import_lock "$source" \
            "src/node-fallbacks/$root_lock" src/node-fallbacks
    fi
}

if test "$#" -eq 0; then
    set -- 1.0.7 1.0.30 1.1.4 1.1.26 1.1.30 1.1.38 1.2.0 1.2.17 \
        1.3.1 1.3.13 1.3.14 opencode
fi

for target in "$@"; do
    case $target in
        1.0.7|1.0.30|1.1.4|1.1.26)
            import_bun_version "$target" bun.lockb yes yes
            ;;
        1.1.30|1.1.38)
            import_bun_version "$target" bun.lockb no yes
            ;;
        1.2.0|1.2.17)
            import_bun_version "$target" bun.lock no yes
            ;;
        1.3.1|1.3.13|1.3.14)
            import_bun_version "$target" bun.lock yes yes
            ;;
        opencode)
            opencode_source=$(source_origin roquix\ packages\ opencode \
                                           %opencode-source)
            import_lock "$opencode_source" bun.lock .
            ;;
        *)
            echo "unknown Bun lock input target: $target" >&2
            exit 1
            ;;
    esac
done
