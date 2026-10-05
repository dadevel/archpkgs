#!/usr/bin/env bash
set -euo pipefail

package_dir="${1:?usage: build-package.sh PACKAGE}"
"${CONTAINER_ENGINE:-docker}" run --rm \
  -v "$PWD/$package_dir:/build" \
  --user root --entrypoint bash \
  ghcr.io/dadevel/archpkgs-builder:latest -c '
    set -euo pipefail
    pacman -Sy --noconfirm
    chown -R builder:builder /build
    sudo -u builder paru --build /build --rebuild --noconfirm --useask
  '

"$(dirname "$0")/test-package.sh" "$package_dir"
