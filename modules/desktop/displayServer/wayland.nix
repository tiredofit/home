{ config, lib, pkgs, ... }:
with lib;
let
  inherit (specialArgs) kioskUsername kioskURL;
  displayServer = config.host.home.feature.gui.displayServer ;
in
{
  config = mkIf (displayServer == "wayland" && config.host.home.feature.gui.enable ) {

    host = {
      home = {
        applications = {
          cliphist.enable = true;
          grim.enable = true;
          nwg-displays.enable = true;
          slurp.enable = true;
          sway-notification-center.enable = true;
          swayosd.enable = true;
          waybar.enable = true;
          wayprompt.enable = true;
          wdisplays.enable = true;
          wev.enable = true;
          wl-clipboard.enable = true;
          wl-gammarelay-rs.enable = true;
          wlogout.enable = true;
          wlr-randr.enable = true;
        };
      };
    };

    home = {
      packages = with pkgs;
        [
          libnotify
          qt5.qtwayland
          qt6.qtwayland
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