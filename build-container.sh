#!/usr/bin/env bash
set -eu

docker login ghcr.io --username "$GITHUB_USER" --password-stdin <<< "$GITHUB_TOKEN"
trap 'docker logout ghcr.io' EXIT
docker buildx build --tag ghcr.io/dadevel/archpkgs-builder:latest --push .
