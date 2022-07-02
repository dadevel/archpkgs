#!/usr/bin/env bash
shopt -s failglob

declare failures=()
for file in */PKGBUILD; do
    dir="$(dirname "${file}")"
    echo "building ${dir}" >&2
    docker run --rm -v "$PWD/${dir}":/build -e PUID=$(id -u) -e PGID=$(id -g) localhost/archpkgs-builder makepkg -sc --noconfirm
    if [[ $? -ne 0 ]]; then
        failures+=("${dir}")
    fi
done
if [[ -n "${failures[*]}" ]]; then
    echo "failed packages: ${failures[*]}"
    exit 1
fi
