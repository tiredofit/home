{config, lib, pkgs, ...}:

let
  cfg = config.host.home.feature.emulation;
in
  with lib;
{
  options = {
    host.home.feature.emulation = {
      windows = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Enable emulation";
        };
      };
    };
  };

  config = {

    home.packages = with pkgs; [
    ] ++ mkIf config.host.home.feature.emulation.windows.enable [
      winetricks
      wineWowPackages.staging
    ];
  };
}
