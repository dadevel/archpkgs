#!/bin/sh
set -eu
/opt/archpkgs/aardwolf/bin/ardpscan --help >/dev/null
QT_QPA_PLATFORM=offscreen /opt/archpkgs/aardwolf/bin/ardpclient --help >/dev/null
/opt/archpkgs/bin/ardpscan --help >/dev/null
QT_QPA_PLATFORM=offscreen /opt/archpkgs/bin/ardpclient --help >/dev/null
