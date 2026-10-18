#!/bin/sh
set -eu

package=${1:-$(guix build -L channel lllmmm)}
scratch=$(mktemp -d)
trap 'rm -rf "$scratch"' EXIT HUP INT TERM

lllmmm() {
    env -i HOME="$scratch" "$package/bin/lllmmm" "$@"
}

test "$(lllmmm --version)" = 'lllmmm 0.1.0'
test -f "$package/share/doc/lllmmm/examples/lllmmm.toml"
test -f "$package/share/doc/lllmmm/examples/strata/iq3_s.json"

touch "$scratch/model.gguf"
cat > "$scratch/lllmmm.toml" <<'EOF'
[[models]]
id = "test-model"
backend = "llama_cpp"
executable = "llama-server"
port = 18081
model_file = "model.gguf"
context_size = 1024
EOF
test "$(lllmmm --config "$scratch/lllmmm.toml" check)" = \
    'configuration valid: 1 models'
