{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wps-office;
in
  with lib;
{
  options = {
    host.home.applications.wps-office = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Word processor, Spreadsheet, Presentations";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [

          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wpsoffice
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrulev2 = [
          "tile,title:(^WPS Spreadsheets$)"
        ];
      };
    };
  };
}
