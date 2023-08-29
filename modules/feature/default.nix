{lib, ...}:

with lib;
{
  imports = [
    ./fonts.nix
    ./theming.nix
    ./mime-defaults.nix
  ];
}
