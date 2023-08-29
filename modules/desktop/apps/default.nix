{lib, ...}:

with lib;
{
  imports = [
    ./redshift.nix
    ./xbindkeys.nix
    ./xdotool.nix
    ./xbacklight.nix
    ./xdpyinfo.nix
    ./xev.nix
  ];
}
