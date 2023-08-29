{lib, ...}:

with lib;
{
  imports = [
    ./wayland.nix
    ./x.nix
  ];
}
