#!/usr/bin/env bash
set -euo pipefail

netexec --help
nxcdb --help
for protocol in smb ldap winrm wmi ssh rdp mssql ftp nfs vnc; do
    netexec "$protocol" --help
done
