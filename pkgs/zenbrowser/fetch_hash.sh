#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix gnused
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/ae815cee91b417be55d43781eb4b73ae1ecc396c.tar.gz

latest_version=$(curl -s https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.tag_name')
base_url="https://github.com/zen-browser/desktop/releases/download/${latest_version}"
files=("zen.macos-aarch64.dmg" "zen.linux-x86_64.tar.bz2")

echo 'Updating version in default.nix'
sed -Ei "s/rev = \"(.*)\"/rev = \"${latest_version}\"/g" default.nix

for file in "${files[@]}" ; do
    url="${base_url}/${file}"
    echo "Updating hash for ${url}"
    rev=$(nix-prefetch-url --type sha256 ${url})
    # Update aarch64 MacOS version
    [[ "$file" == "zen.macos-aarch64.dmg" ]] && sed -Ei "s/darwin_aarch64-hash = \"(.*)\"/darwin_aarch64-hash = \"${rev}\"/g" default.nix
    # Update x86_64 Linux version
    [[ "$file" == "zen.linux-x86_64.tar.bz2" ]] && sed -Ei "s/linux_x86_64-hash = \"(.*)\"/linux_x86_64-hash = \"${rev}\"/g" default.nix
done
