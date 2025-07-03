#!/usr/bin/env bash
set -euo pipefail

# Fetch JSON
echo "Fetching latest VyOS ISO URL..."
ISO_JSON_URL="https://raw.githubusercontent.com/vyos/vyos-nightly-build/refs/heads/current/version.json"
ISO_URL=$(curl -s "${ISO_JSON_URL}" | jq -r '.[0].url')

echo "Building Docker image using ISO: ${ISO_URL}"
docker build --build-arg VYOS_ISO_URL="${ISO_URL}" -t vyos-container:latest .
