{lib, ...}:

with lib;
{
  imports = [
    ./alttab.nix
    ./arandr.nix
    ./autotiling.nix
    ./autokey.nix
    ./betterlockscreen.nix
    ./i3status-rs.nix
    ./nitrogen.nix
    ./numlockx.nix
    ./picom.nix
    ./redshift.nix
    ./sysstat.nix
    ./volctl.nix
    ./xbanish.nix
    ./xbindkeys.nix
    ./xdotool.nix
    ./xbacklight.nix
    ./xidlehook.nix
    ./xdpyinfo.nix
    ./xev.nix
    ./xprop.nix
  ];
}
