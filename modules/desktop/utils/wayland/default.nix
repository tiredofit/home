{lib, ...}:

with lib;
{
  imports = [
    ./cliphist.nix
    ./grim.nix
    ./hyprcursor.nix
    ./hyprdim.nix
    ./hypridle.nix
    ./hyprkeys.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hyprpicker.nix
    ./hyprshot.nix
    ./nwg-displays.nix
    ./satty.nix
    ./slurp.nix
    ./swayidle.nix
    ./swaylock.nix
    ./swaync.nix
    ./swayosd.nix
    ./waybar.nix
    ./wayprompt.nix
    ./wdisplays.nix
    ./wev.nix
    ./wl-clipboard.nix
    ./wl-gammarelay-rs.nix
    ./wlr-randr.nix
    ./wlogout.nix
  ];
}
