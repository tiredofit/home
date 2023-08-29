{lib, ...}:

with lib;
{
  imports = [
    ./fonts.nix
    ./mime-defaults.nix
    ./theming.nix
  ];
}
