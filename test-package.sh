#!/usr/bin/env bash
set -euo pipefail

package_dir="${1:?usage: test-package.sh PACKAGE}"
if [[ ! -f "$package_dir/test.sh" ]]; then
  echo "No runtime test defined for $package_dir; skipping."
  exit 0
fi

# Test the installed archive, including its final paths and declared dependencies.
"${CONTAINER_ENGINE:-docker}" run --rm \
  -v "$PWD/$package_dir:/package:ro" \
  --user root --workdir /tmp --entrypoint bash \
  ghcr.io/dadevel/archpkgs-builder:latest -c '
    set -euo pipefail
    pacman -Syu --noconfirm
    pacman -U --noconfirm /package/*.pkg.tar.zst
    export PATH="/opt/archpkgs/bin:$PATH"
    timeout --kill-after=10s 120s sudo -u builder --preserve-env=PATH bash /package/test.sh
  '
