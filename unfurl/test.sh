#!/usr/bin/env bash
set -euo pipefail

unfurl --help

# Parse a local URL without sending network requests.
test "$(printf '%s\n' 'https://example.invalid/path?key=value#fragment' | unfurl domains)" = example.invalid
