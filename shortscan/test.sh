#!/usr/bin/env bash
set -euo pipefail

for command in shortscan shortutil; do
    $command --help
done
