#!/usr/bin/env bash
exec docker run --rm -v "$PWD/$1:/build" ghcr.io/dadevel/archpkgs-builder:latest makepkg -scf --noconfirm
