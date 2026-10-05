#!/bin/sh
set -eu
/opt/archpkgs/aardwolf/bin/ardpscan --help >/dev/null
/opt/archpkgs/bin/ardpscan --help >/dev/null
. /opt/archpkgs/aardwolf/bin/activate
test "$(python -c 'import sys; print(sys.prefix)')" = /opt/archpkgs/aardwolf
deactivate
