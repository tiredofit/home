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
          cliphist = {
            enable = true;
            service.enable = true;
          };
          grim.enable = true;
          nwg-displays.enable = true;
          slurp.enable = true;
          wayprompt.enable = false;
          wdisplays.enable = true;
          wev.enable = true;
          wl-clipboard.enable = true;
          wl-gammarelay-rs = {
            enable = false;
            service.enable = false;
          };
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
