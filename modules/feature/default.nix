{lib, ...}:

with lib;
{
  imports = [
    ./emulation.nix
    ./fonts.nix
    ./mime-defaults.nix
    ./theming.nix
  ];
}
