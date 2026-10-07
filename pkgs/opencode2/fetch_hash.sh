#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix gnused

# Usage: ./fetch_hash.sh [version]
#   With no argument, the latest @opencode/cli version is read from npm.

set -euo pipefail
cd "$(dirname "$0")"

if [ "${1:-}" ]; then
  latest_version="${1}"
else
  latest_version=$(curl -s https://registry.npmjs.org/@opencode/cli/latest | jq -r '.version')
fi

echo "Updating version in default.nix to ${latest_version}"
sed -Ei "s/version = \"(.*)\"/version = \"${latest_version}\"/g" default.nix

update_hash() {
  local nix_system="${1}"    # e.g. x86_64-linux
  local npm_platform="${2}"  # e.g. linux-x64
  local url="https://registry.npmjs.org/@opencode/cli-${npm_platform}/-/cli-${npm_platform}-${latest_version}.tgz"

  echo "Fetching hash for ${url}"
  local hash
  hash=$(nix --extra-experimental-features nix-command store prefetch-file --json "${url}" | jq -r '.hash')

  echo "Updating ${nix_system} hash to ${hash}"
  sed -Ei "/${nix_system} = fetchurl \{/,/\};/ s|hash = \".*\"|hash = \"${hash}\"|" default.nix
}

update_hash "x86_64-linux" "linux-x64"
update_hash "aarch64-linux" "linux-arm64"
update_hash "aarch64-darwin" "darwin-arm64"

echo "Done. Review changes with: git diff default.nix"
