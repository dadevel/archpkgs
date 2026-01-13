#!/usr/bin/env bash
exec docker run --rm -v "$PWD/$1:/build" --user root --entrypoint bash ghcr.io/dadevel/archpkgs-builder:latest -c 'set -eu;pacman -Sy;chown -R builder:builder .;sudo -u builder paru -B . --noconfirm'
