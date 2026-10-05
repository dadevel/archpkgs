#!/usr/bin/env bash
set -euo pipefail

package_dir="${1:?usage: build-package.sh PACKAGE}"
container_engine="${CONTAINER_ENGINE:-docker}"
userns_args=()
if [[ "${container_engine##*/}" == podman ]]; then
  # The image's builder has UID/GID 1000; map it to the invoking host user.
  userns_args=(--userns=keep-id:uid=1000,gid=1000)
fi
"$container_engine" run --rm "${userns_args[@]}" \
  -v "$PWD/$package_dir:/build" \
  --user root --entrypoint bash \
  ghcr.io/dadevel/archpkgs-builder:latest -c '
    set -euo pipefail
    pacman -Sy --noconfirm
    chown -R builder:builder /build
    sudo -u builder paru --build /build --rebuild --noconfirm --useask
  '

"$(dirname "$0")/test-package.sh" "$package_dir"
