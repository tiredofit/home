#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix gnused

latest_version=$(curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.tag_name')
base_url="https://github.com/zen-browser/desktop/releases/download/${latest_version}"
files=("zen.macos-universal.dmg" "zen.linux-x86_64.tar.xz")

echo 'Updating version in default.nix'
sed -Ei "s/rev = \"(.*)\"/rev = \"${latest_version}\"/g" default.nix

for file in "${files[@]}" ; do
    url="${base_url}/${file}"
    echo "Updating hash for ${url}"
    rev=$(nix-prefetch-url --type sha256 ${url})
    # Update aarch64 MacOS version
    [[ "$file" == "zen.macos-universal.dmg" ]] && sed -Ei "s/darwin_universal-hash = \"(.*)\"/darwin_universal-hash = \"${rev}\"/g" default.nix
    # Update x86_64 Linux version
    [[ "$file" == "zen.linux-x86_64.tar.xz" ]] && sed -Ei "s/linux_x86_64-hash = \"(.*)\"/linux_x86_64-hash = \"${rev}\"/g" default.nix
done
