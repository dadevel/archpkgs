#!/usr/bin/env bash
set -euo pipefail

# Electron's Node mode checks the runtime and app entry point without a display.
output=$(ELECTRON_RUN_AS_NODE=1 certipy-bloodhound -e '
    const fs = require("fs");
    const path = require("path");
    const root = "/opt/archpkgs/certipy-bloodhound/resources/app";
    const app = require(root + "/package.json");
    if (!process.versions.electron || !app.main || !fs.existsSync(path.join(root, app.main))) {
        throw new Error("Missing Electron runtime or BloodHound entry point");
    }
    console.log("BloodHound runtime OK");
')
printf '%s\n' "$output"
if [[ "$output" != "BloodHound runtime OK" ]]; then
    echo "BloodHound wrapper did not execute the runtime check" >&2
    exit 1
fi
