{lib, ...}:

with lib;
{
  imports = [
    ./file-roller.nix
    ./libreoffice.nix
    ./pinta.nix
    ./thunderbird.nix
    ./wpsoffice.nix
    ./zoom.nix
  ];
}
