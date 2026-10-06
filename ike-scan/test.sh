#!/usr/bin/env bash
set -euo pipefail

for command in ike-scan psk-crack; do
    "$command" --help
done
