#!/usr/bin/env bash

docker run -i --rm -v "$PWD":/build localhost/archpkgs-builder << EOF
set -eu
shopt -s nullglob

rm -rf ./repo
mkdir ./repo
cp ./index.html ./repo
mv ./*/*.pkg.tar.zst ./*/*.pkg.tar.zst.sig ./repo
cd ./repo
repo-add ./archpkgs.db.tar.gz ./*.pkg.tar.zst
EOF
