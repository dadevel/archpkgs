#!/usr/bin/env bash
set -euo pipefail

titus --help

# Check the packaged Burp extension without launching Burp.
entries=$(bsdtar -tf /opt/archpkgs/titus/titus-burp.jar)
if [[ "$entries" != *"com/praetorian/titus/burp/TitusExtension.class"* ]]; then
    echo "Missing Titus Burp extension class" >&2
    exit 1
fi
