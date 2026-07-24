command -v rustc >/dev/null && echo "Rust is installed. Skipping rustup installation." && return

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile="minimal"

. ~/.cargo/env
