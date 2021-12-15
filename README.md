# kustomize checksum example

Download `kustomize` command and verify the checksum using `shasum`.

- https://github.com/kubernetes-sigs/kustomize

This documentation is a part of [verify-checksum-cheatsheet](https://github.com/pkgdeps/verify-checksum-cheatsheet).

## Example

- Binary: https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.1.3/kustomize_v4.1.3_darwin_amd64.tar.gz
- Checksum: https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv4.1.3/checksums.txt

```bash
#!/usr/bin/env bash
set -eux

BIN_DIR="$(pwd)/bin"
mkdir -p "${BIN_DIR}"
# docs: https://github.com/pkgdeps/verify-checksum-cheatsheet
KUSTOMIZE_VERSION=4.1.3

# defined sha256sum command
if   command -v sha256sum > /dev/null; then sha256sum="sha256sum"
elif command -v sha256 > /dev/null;    then sha256sum="sha256 -r"
elif command -v shasum > /dev/null;    then sha256sum="shasum -a 256"
fi
# Download kustomize and checksum file
curl -sLO "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_darwin_amd64.tar.gz" && \
curl -sL "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/checksums.txt" -o kustomize.checksums.txt
# Verify the checksum
grep -e "kustomize_v${KUSTOMIZE_VERSION}_darwin_amd64.tar.gz$" kustomize.checksums.txt | sha256sum -c
# Extract tar.gz to bin/
tar zxvf "kustomize_v${KUSTOMIZE_VERSION}_darwin_amd64.tar.gz" -C "${BIN_DIR}"
# Add permission for executable
chmod +x "${BIN_DIR}/kustomize"
```

## Test

    ./bin/kustomize version

## Related

- [verify-checksum-cheatsheet](https://github.com/pkgdeps/verify-checksum-cheatsheet).
- [pkgdeps/curl-jq-checksum-example](https://github.com/pkgdeps/curl-jq-checksum-example)
