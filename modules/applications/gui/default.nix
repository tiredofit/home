{lib, ...}:

with lib;
{
  imports = [
    ./file-roller.nix
    ./pinta.nix
  ];
}
