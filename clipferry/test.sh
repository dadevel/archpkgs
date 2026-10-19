#!/usr/bin/env bash
set -euo pipefail

clipferry --version
clipferry --help
test -x /usr/bin/clipferry
test -r /usr/lib/systemd/user/clipferry.service
test -r /usr/share/licenses/clipferry/LICENSE
grep -Fxq 'ExecStart=/usr/bin/clipferry' /usr/lib/systemd/user/clipferry.service

# Display connectivity and real clipboard transfers need a graphical guest.
