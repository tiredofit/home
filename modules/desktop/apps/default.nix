{lib, ...}:

with lib;
{
  imports = [
    ./autorandr.nix
    ./autotiling.nix
    ./autokey.nix
    ./cliphist.nix
    ./grim.nix
    ./hyprpaper.nix
    ./i3status-rs.nix
    ./nwg-displays.nix
    ./redshift.nix
    ./slurp.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swaynotificationcenter.nix
    ./swayosd.nix
    ./sysstat.nix
    ./waybar.nix
    ./wayprompt.nix
    ./wdisplays.nix
    ./wev.nix
    ./wl-clipboard.nix
    ./wl-gammarelay-rs.nix
    ./wlr-randr.nix
    ./wlogout.nix
    ./xbindkeys.nix
    ./xdotool.nix
    ./xbacklight.nix
    ./xdpyinfo.nix
    ./xev.nix
    ./xprop.nix
  ];
}
