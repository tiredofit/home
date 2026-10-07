#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix gnused

# Usage: ./fetch_hash.sh [version]
#   With no argument, the latest stable MQTT-Explorer release is used

set -euo pipefail
cd "$(dirname "$0")"

if [ "${1:-}" ]; then
  latest_version="${1}"
else
  latest_version=$(curl -s https://api.github.com/repos/thomasnordquist/MQTT-Explorer/releases/latest | jq -r '.tag_name' | sed 's/^v//')
fi

echo "Updating version in default.nix to ${latest_version}"
sed -Ei "s/version = \"(.*)\"/version = \"${latest_version}\"/g" default.nix

version="${latest_version}"
url=$(grep "url = " default.nix | cut -d \" -f2 | sed "s|\${version}|${version}|g")
echo "Updating hash for ${url}"
hash=$(nix-prefetch-url --type sha256 ${url})
sed -Ei "s/hash = \"(.*)\"/hash = \"${hash}\"/g" default.nix
