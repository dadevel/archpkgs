#!/usr/bin/env bash
usermod --uid "${PUID:-1000}" --gid "${PGID:-1000}" builder
chown -R builder:builder /build
exec sudo -u builder -- env --chdir=/build -- "${@:-bash}"
