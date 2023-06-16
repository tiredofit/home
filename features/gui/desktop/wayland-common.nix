{ pkgs, config, lib, ...}:
{
  imports = [
    ./common.nix
    ../apps/swaync.nix
    ../apps/waybar.nix
  ];

  home = {
    packages = with pkgs;
      [
        cliphist
        grim
        hyprpaper
        nwg-displays
        qt5.qtwayland
        qt6.qtwayland
        rofi-wayland
        slurp
        swayidle
        swaylock-effects
        swayosd
        waybar
        wayprompt
        wdisplays
        wev
        wl-clipboard
        wlogout
        wl-gammarelay-rs
        wlr-randr
      ];
    sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_SESSION_TYPE = "wayland";
    };
  };

  programs = {

  };
}
