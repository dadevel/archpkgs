#!/usr/bin/env bash
set -euo pipefail

if type podman &> /dev/null; then
    declare -r container_engine=podman
else
    declare -r container_engine=docker
fi

declare -a engine_args=()
if [[ "${container_engine}" == podman ]]; then
  # The image's builder has UID/GID 1000; map it to the invoking host user.
  engine_args=(--userns=keep-id:uid=1000,gid=1000)
fi

"${container_engine}" run --rm "${engine_args[@]}" -v "$PWD/$1:/build" --user root --entrypoint bash ghcr.io/dadevel/archpkgs-builder:latest -c 'set -euo pipefail;pacman -Sy --noconfirm;chown -R builder:builder /build;sudo -u builder paru --build /build --rebuild --noconfirm --useask'
