#!/usr/bin/env bash
exec docker run --rm -v "$PWD/$1:/build" --user root --entrypoint bash ghcr.io/dadevel/archpkgs-builder:latest -c 'set -eu;pacman -Sy;chown -R builder:builder /build;sudo -u builder paru --build /build --rebuild --noconfirm --useask;if [ -f /build/test.sh ]; then pacman -U --noconfirm /build/*.pkg.tar.zst;sudo -u builder /build/test.sh;fi'
