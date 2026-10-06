#!/usr/bin/env bash
set -euo pipefail

for command in roadtools-createsyncaccount roadtools-modifyuser roadtools-partialtofulltgt roadtools-setcert roadtools-setsynceduserpassword; do
    "$command" --help
done

# krbsso prints usage with no arguments; --help would be treated as a ticket.
roadtools-krbsso
