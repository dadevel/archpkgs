#!/usr/bin/env bash
set -euo pipefail

acltoolkit --help
# Help exits during argument parsing, before authentication or LDAP connections.
for action in get-objectacl set-objectowner give-genericall give-dcsync add-groupmember set-logonscript; do
    echo "Testing acltoolkit $action --help"
    acltoolkit example.invalid "$action" --help
done
