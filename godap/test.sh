#!/bin/sh
set -eu
/opt/archpkgs/bin/godap --help >/dev/null
test -n "$(/opt/archpkgs/bin/godap version)"
