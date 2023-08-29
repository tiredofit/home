{lib, ...}:

with lib;
{
  imports = [
    ./calibre.nix
    ./chromium.nix
    ./diffuse.nix
    ./drawio.nix
    ./eog.nix
    ./ferdium.nix
    ./file-roller.nix
    ./geeqie.nix
    ./gparted.nix
    ./greenclip.nix
    ./libreoffice.nix
    ./mate-calc.nix
    ./nextcloud-client.nix
    ./pinta.nix
    ./seahorse.nix
    ./smartgit.nix
    ./smplayer.nix
    ./thunar.nix
    ./thunderbird.nix
    ./vivaldi.nix
    ./wpsoffice.nix
    ./zoom.nix
  ];
}