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
          wdisplays.enable = mkDefault true;
          wev.enable = mkDefault true;
          wlr-randr.enable = mkDefault true;
        };
      };
    };

    home = {
      packages = with pkgs;
        [
          libnotify
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
