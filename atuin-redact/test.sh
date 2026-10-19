#!/usr/bin/env bash
set -euo pipefail

atuin --version

# A replacement rule rewrites a command before it is stored.
dir=$(mktemp -d)
trap 'rm -rf -- "$dir"' EXIT
mkdir -p "$dir/config" "$dir/data"
cat > "$dir/config/config.toml" << 'TOML'
auto_sync = false
[security]
redact_patterns = [
  { pattern = '(\s-p\s+)\S+', replacement = '${1}$$PASSWORD' },
]
TOML
export ATUIN_CONFIG_DIR="$dir/config" ATUIN_DATA_DIR="$dir/data" ATUIN_SESSION=0198f0c0aaaa7000a000000000000001
id=$(atuin history start -- 'nxc smb 192.0.2.1 -u alice -p hunter2')
atuin history end --exit 0 "$id" >/dev/null
stored=$(atuin history list --cmd-only)
[[ "$stored" == 'nxc smb 192.0.2.1 -u alice -p $PASSWORD' ]]
