{config, lib, pkgs, ...}:
let
  cfg = config.host.home.feature.emulation.windows;
in
  with lib;
{
  options = {
    host.home.feature.emulation.windows = {
      enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Enable emulation";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = true;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [
            "application/vnd.microsoft.portable-executable"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      winetricks
      wineWowPackages.staging
    ];

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "wine.desktop")
    );
  };
}
