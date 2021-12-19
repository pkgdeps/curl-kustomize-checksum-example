#!/usr/bin/env bash
set -eux

BIN_DIR="$(pwd)/bin"
mkdir -p "${BIN_DIR}"
# docs: https://github.com/pkgdeps/verify-checksum-cheatsheet
KUSTOMIZE_VERSION=4.1.3
KUSTOMIZE_ARCHITECTURE="linux_arm64"
# defined _sha256sum command
function _sha256sum {
  local cmd
  if command -v sha256sum &> /dev/null; then
    cmd=(sha256sum)
  elif command -v sha256 &> /dev/null; then
    cmd=(ssha256 -r)
  elif command -v shasum &> /dev/null; then
    cmd=(shasum -a 256)
  else
    echo "ERROR: could not find shasum or sha256sum."
    return 1
  fi
  "${cmd[@]}" "$@"
}
# Download kustomize and checksum file
curl -sLO "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCHITECTURE}.tar.gz" && \
curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/checksums.txt" -o kustomize.checksums.txt
# Verify the checksum
grep -e "kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCHITECTURE}.tar.gz$" kustomize.checksums.txt | _sha256sum -c
# Extract tar.gz to bin/
tar zxvf "kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCHITECTURE}.tar.gz" -C "${BIN_DIR}"
# Add permission for executable
chmod +x "${BIN_DIR}/kustomize"
# delete unused files
rm "kustomize_v${KUSTOMIZE_VERSION}_${KUSTOMIZE_ARCHITECTURE}.tar.gz" kustomize.checksums.txt
