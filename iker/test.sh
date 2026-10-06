#!/usr/bin/env bash
set -euo pipefail

# The CLI checks root before parsing --help; load its parser without scanning.
python3 - /opt/archpkgs/bin/iker --help <<'PY'
import runpy
import sys

script = sys.argv.pop(1)
runpy.run_path(script, run_name="iker_test")["getArguments"]()
PY
