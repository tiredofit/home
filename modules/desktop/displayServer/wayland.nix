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
            enable = mkDefault true;
            service.enable = mkDefault true;
          };
          grim.enable = mkDefault true;
          nwg-displays.enable = mkDefault true;
          slurp.enable = mkDefault true;
          wayprompt.enable = mkDefault false;
          wdisplays.enable = mkDefault true;
          wev.enable = mkDefault true;
          wl-clipboard.enable = mkDefault true;
          wl-gammarelay-rs = {
            enable = mkDefault false;
            service.enable = mkDefault false;
          };
          wlogout.enable = mkDefault true;
          wlr-randr.enable = mkDefault true;
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
