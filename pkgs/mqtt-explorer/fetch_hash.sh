#! /usr/bin/env nix-shell
#! nix-shell -i bash -p nix gnused

version=$(grep "version = " default.nix | cut -d \" -f2)
url=$(grep "url = " default.nix | cut -d \" -f2 | sed "s|\${version}|${version}|g")
hash=$(nix-prefetch-url --type sha256 ${url})
sed -i "s/hash = \"(.*)\"/hash = \"${hash}\"/g" default.nix
