{lib, ...}:

with lib;
{
  imports = [
    ./file-roller.nix
    ./pinta.nix
    ./thunderbird.nix
    ./wpsoffice.nix
    ./zoom.nix
  ];
}
