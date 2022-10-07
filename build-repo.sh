#!/bin/sh
exec docker run -i --rm -v "$PWD:/build" ghcr.io/dadevel/archpkgs-builder:latest bash << EOF
set -euv
shopt -s nullglob

cd /build
rm -rf ./public
mkdir ./public
cp ./index.html ./public
ls -lA ./artifacts
mv ./artifacts/*/*.pkg.tar.zst ./artifacts/*/*.pkg.tar.zst.sig ./public
cd ./public
ls -lA
repo-add ./archpkgs.db.tar.gz ./*.pkg.tar.zst
EOF
