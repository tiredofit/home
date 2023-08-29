{ config, ... }: {

  imports = [
    ./cursor.nix
    ./favorites.nix
    ./tab.nix
    ./terminal.nix
    ./toggles.nix
  ];

}