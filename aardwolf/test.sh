#!/bin/sh
set -eu
/opt/archpkgs/bin/ardpscan --help >/dev/null
QT_QPA_PLATFORM=offscreen /opt/archpkgs/bin/aardpclient --help >/dev/null
