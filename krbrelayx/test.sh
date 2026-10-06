#!/usr/bin/env bash
set -euo pipefail

for command in krbrelayx-addspn krbrelayx-dnstool krbrelayx-krbrelayx krbrelayx-printerbug; do
    $command --help
done
