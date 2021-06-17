#!/usr/bin/env bash
set -eux

BIN_DIR="$(pwd)/bin"
mkdir -p "${BIN_DIR}"
# docs: https://github.com/pkgdeps/verify-checksum-cheatsheet
KUSTOMIZE_VERSION=4.1.3
# Download kustomize and checksum file
curl -sLO "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_darwin_amd64.tar.gz" && \
curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/checksums.txt" -o kustomize.checksums.txt
# Verify the checksum
grep -e "kustomize_v${KUSTOMIZE_VERSION}_darwin_amd64.tar.gz$" kustomize.checksums.txt | shasum --check - || (echo "Error: Not match kustomize checksum." && exit 1)
# Extract tar.gz to bin/
tar zxvf "kustomize_v${KUSTOMIZE_VERSION}_darwin_amd64.tar.gz" -C "${BIN_DIR}"
# Add permission for executable
chmod +x "${BIN_DIR}/kustomize"