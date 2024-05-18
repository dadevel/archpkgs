#!/usr/bin/env bash
set -euo pipefail

# add repo
if ! grep -Fq '[archpkgs]' /etc/pacman.conf 2> /dev/null; then
    echo >> /etc/pacman.conf
    echo '[archpkgs]' >> /etc/pacman.conf
    echo 'Server = https://cdn.archpkgs.net' >> /etc/pacman.conf
fi

# trust signing key
curl -sSf https://raw.githubusercontent.com/dadevel/archpkgs/main/signature.gpg | pacman-key --add -
pacman-key --lsign-key admin@archpkgs.net

# refresh cache
pacman -Sy

# configure path
echo 'export "PATH=/opt/archpkgs/bin:$PATH"' > /etc/profile.d/archpkgs.sh

# configure sudo
if grep -q secure_path= /etc/sudoers; then
    if ! grep -q /opt/archpkgs/bin /etc/sudoers; then
        echo 'WARNING: Please prepend "/opt/archpkgs/bin" to the "secure_path" option in /etc/sudoers'
    fi
fi
