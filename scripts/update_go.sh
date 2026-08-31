#!/usr/bin/env bash
set -euo pipefail

# 1. Check for required dependencies
if ! command -v jq &> /dev/null; then
    echo "Error: 'jq' is required to parse the version JSON. Please install it first."
    exit 1
fi

# 2. Automatically detect System OS and Architecture (e.g., linux, amd64/arm64)
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)
case "$ARCH" in
    x86_64)  ARCH="amd64" ;;
    aarch64) ARCH="arm64" ;;
    armv7l)  ARCH="armv6l" ;; # Fallback for 32-bit ARM
esac

echo "Target System: ${OS}_${ARCH}"

# 3. Query Go's official API to get the absolute newest stable release version
echo "Checking official Go API for the newest stable release..."
LATEST_VERSION=$(curl -s 'https://go.dev/dl/?mode=json' | jq -r '.[0].version')

if [ -z "$LATEST_VERSION" ] || [ "$LATEST_VERSION" == "null" ]; then
    echo "Error: Could not retrieve the latest version from the Go API."
    exit 1
fi

TARBALL="${LATEST_VERSION}.${OS}-${ARCH}.tar.gz"
DOWNLOAD_URL="https://go.dev{TARBALL}"

echo "Newest version found: ${LATEST_VERSION}"
echo "Downloading archive from: ${DOWNLOAD_URL}"

# 4. Download the latest archive using curl
curl -OL "$DOWNLOAD_URL"

# 5. Remove any older installations and extract the fresh archive
echo "Installing ${LATEST_VERSION} to /usr/local/go..."
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "$TARBALL"

# 6. Cleanup the downloaded archive file
rm "$TARBALL"

echo "Successfully updated! Verify your version by opening a new terminal and running: go version"

