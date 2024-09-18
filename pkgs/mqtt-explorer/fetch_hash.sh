#! /usr/bin/env nix-shell
#! nix-shell -i bash -p curl jq nix gnused
#! nix-shell -I nixpkgs=https://github.com/NixOS/nixpkgs/archive/ae815cee91b417be55d43781eb4b73ae1ecc396c.tar.gz

version=$(grep "version = " default.nix | cut -d \" -f2)
url=$(grep "url = " default.nix | cut -d \" -f2 | sed "s|\${version}|${version}|g")
hash=$(nix-prefetch-url --type sha256 ${url})
sed -i "s/hash = \"(.*)\"/hash = \"${hash}\"/g" default.nix
