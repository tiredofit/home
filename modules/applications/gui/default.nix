{lib, ...}:

with lib;
{
  imports = [
    ./diffuse.nix
    ./eog.nix
    ./file-roller.nix
    ./libreoffice.nix
    ./mate-calc.nix
    ./pinta.nix
    ./smartgit.nix
    ./thunderbird.nix
    ./vivaldi.nix
    ./wpsoffice.nix
    ./zoom.nix
  ];
}
