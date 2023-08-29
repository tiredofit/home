{lib, ...}:

with lib;
{
  imports = [
    ./autorandr.nix
    ./autokey.nix
    ./grim.nix
    ./nwg-displays.nix
    ./redshift.nix
    ./sysstat.nix
    ./wdisplays.nix
    ./wev.nix
    ./wlr-randr.nix
    ./xbindkeys.nix
    ./xdotool.nix
    ./xbacklight.nix
    ./xdpyinfo.nix
    ./xev.nix
    ./xprop.nix
  ];
}
