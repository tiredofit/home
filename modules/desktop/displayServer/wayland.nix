{ config, lib, pkgs, ... }:
with lib;
let
  inherit (specialArgs) kioskUsername kioskURL;
  displayServer = config.host.home.feature.gui.displayServer ;
in
{
  config = mkIf (displayServer == "wayland" && config.host.home.feature.gui.enable ) {
    ## TODO This should be modularized as these are common settings for all wayland desktops or window managers
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
          #cliphist
          #grim
          #hyprpaper
          #nwg-displays
          qt5.qtwayland
          qt6.qtwayland
          rofi-wayland
          #slurp
          swayidle
          swaylock-effects
          swayosd
          wayprompt
          #wdisplays
          #wev
          #wl-clipboard
          #wlogout
          wl-gammarelay-rs
          #wlr-randr
        ];

      sessionVariables = {
        QT_QPA_PLATFORM = "wayland";
        SDL_VIDEODRIVER = "wayland";
        XDG_SESSION_TYPE = "wayland";
      };
    };

    programs = {

    };
  };
}