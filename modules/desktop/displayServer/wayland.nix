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
          cliphist.enable = true;
          grim.enable = true;
          hyprpaper.enable = true;
          nwg-displays.enable = true;
          slurp.enable = true;
          sway-notification-center.enable = true;
          swayidle.enable = true;
          swaylock.enable = true;
          swayosd.enable = true;
          waybar.enable = true;
          wayprompt.enable = true;
          wdisplays.enable = true;
          wev.enable = true;
          wl-clipboard.enable = true;
          wl-gammarelay-rs.enable = true;
          wl-logout.enable = true;
          wlr-randr.enable = true;
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
          #swayidle
          #swaylock-effects
          #swayosd
          #wayprompt
          #wdisplays
          #wev
          #wl-clipboard
          #wlogout
          #wl-gammarelay-rs
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