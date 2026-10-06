#!/usr/bin/env bash
set -euo pipefail

for command in pkinittools-gettgtpkinit pkinittools-getnthash pkinittools-gets4uticket; do
    $command --help
done
