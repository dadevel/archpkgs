#!/usr/bin/env bash
set -euo pipefail

if type podman &> /dev/null; then
    declare -r container_engine=podman
else
    declare -r container_engine=docker
fi

"${container_engine}" run --rm -v "$PWD/$1:/package:ro" --user root --workdir /tmp --entrypoint bash ghcr.io/dadevel/archpkgs-builder:latest -c '
    set -euo pipefail
    pacman -Syu --noconfirm
    pacman -U --noconfirm /package/*.pkg.tar.zst
    export PATH="/opt/archpkgs/bin:$PATH"
    if timeout --kill-after=10s 120s sudo -u builder --preserve-env=PATH bash /package/test.sh; then
        echo "test succeeded" >&2
    else
        test_status=$?
        echo "test failed, exit code ${test_status}" >&2
        exit "${test_status}"
    fi
'
