{ config, lib, pkgs, ...}:
{
  imports = [
    ./common.nix
  ];

  host = {
    home = {
      applications = {
        sway-notification-center.enable = true;
        waybar.enable = true;
      };
    };
  };

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
