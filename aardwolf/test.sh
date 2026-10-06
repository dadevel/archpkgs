#!/usr/bin/env bash
set -euo pipefail

/opt/archpkgs/aardwolf/bin/ardpscan --help >/dev/null
/opt/archpkgs/bin/ardpscan --help >/dev/null
. /opt/archpkgs/aardwolf/bin/activate
[[ "$(python -c 'import sys; print(sys.prefix)')" == /opt/archpkgs/aardwolf ]] && echo ok
deactivate
