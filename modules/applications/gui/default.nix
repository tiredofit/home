{lib, ...}:

with lib;
{
  imports = [
    ./diffuse.nix
    ./eog.nix
    ./file-roller.nix
    ./geeqie.nix
    ./libreoffice.nix
    ./mate-calc.nix
    ./pinta.nix
    ./seahorse.nix
    ./smartgit.nix
    ./thunderbird.nix
    ./vivaldi.nix
    ./wpsoffice.nix
    ./zoom.nix
  ];
}
