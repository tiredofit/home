#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix gnused

if [ "${1}" ]; then
  latest_version="${1}"
else
  latest_version=$(curl -s https://api.github.com/repos/jeffvli/feishin/releases/latest | jq -r '.tag_name')
fi

echo "Updating version in default.nix to ${latest_version}"
sed -Ei "s/version = \"(.*)\"/version = \"${latest_version}\"/g" default.nix

base_url="https://github.com/jeffvli/feishin/releases/download/${latest_version}"
file="Feishin-linux-x86_64.AppImage"
url="${base_url}/${file}"

echo "Updating hash for ${url}"
hash=$(nix-prefetch-url --type sha256 ${url})
sed -Ei "s/sha256 = \"(.*)\"/sha256 = \"${hash}\"/g" default.nix
