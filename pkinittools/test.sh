#!/usr/bin/env bash
set -euo pipefail

# Argument parsing loads the runtime imports without contacting a KDC.
for command in pkinittools-gettgtpkinit pkinittools-getnthash pkinittools-gets4uticket; do
    echo "Testing $command --help"
    "$command" --help
done
