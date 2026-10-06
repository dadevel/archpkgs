#!/usr/bin/env bash
set -euo pipefail

for command in impacket-unstable-secretsdump impacket-unstable-getnpusers impacket-unstable-getuserspns impacket-unstable-gettgt impacket-unstable-getst impacket-unstable-ntlmrelayx impacket-unstable-smbclient impacket-unstable-smbexec impacket-unstable-wmiexec impacket-unstable-psexec impacket-unstable-atexec impacket-unstable-ticketer impacket-unstable-dacledit impacket-unstable-rbcd impacket-unstable-reg impacket-unstable-dpapi; do
    $command -h
done
