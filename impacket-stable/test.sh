#!/usr/bin/env bash
set -euo pipefail

for command in impacket-secretsdump impacket-getnpusers impacket-getuserspns impacket-gettgt impacket-getst impacket-ntlmrelayx impacket-smbclient impacket-smbexec impacket-wmiexec impacket-psexec impacket-atexec impacket-ticketer impacket-dacledit impacket-rbcd impacket-reg impacket-dpapi; do
    "$command" -h
done
