#!/usr/bin/env bash
set -euo pipefail

exrex --help

# Exercise local regex generation, beyond argument parsing.
test "$(exrex 'a[0-2]')" = $'a0\na1\na2'
