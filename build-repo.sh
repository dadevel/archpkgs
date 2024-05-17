#!/usr/bin/env bash
exec docker run -i --rm -v "$PWD:/build" -e SIGNING_KEY ghcr.io/dadevel/archpkgs-builder:latest bash << EOF
set -euo pipefail
cd /build
echo "$SIGNING_KEY" | gpg --import -
mkdir ./public
mv ./artifacts/package-*/*.pkg.tar.zst ./public
for pkg in ./public/*.pkg.tar.zst; do
    gpg --detach-sign --output "\${pkg}.sig" --sign "\${pkg}"
done
repo-add ./public/archpkgs.db.tar.zst ./public/*.pkg.tar.zst
echo 'Options +Indexes' > ./public/.htaccess
EOF
