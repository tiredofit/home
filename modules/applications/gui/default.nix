{lib, ...}:

with lib;
{
  imports = [
    ./file-roller.nix
    ./pinta.nix
    ./thunderbird.nix
    ./zoom.nix
  ];
}
