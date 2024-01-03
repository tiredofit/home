{lib, ...}:

with lib;
{
  imports = [
    ./emulation
    ./fonts.nix
    ./mime-defaults.nix
    ./theming.nix
  ];
}
