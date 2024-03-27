{lib, ...}:

with lib;
{
  imports = [
    ./dunst.nix
    ./playerctl.nix
  ];
}
