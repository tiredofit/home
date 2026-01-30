{config, inputs, lib, pkgs, ...}:
let
  cfg = config.host.home.feature.theming;
in
  with lib;
{
  options = {
    host.home.feature.theming = {
      enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Enable theming";
      };
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = mkDefault true;
    };

    home = {
      packages = with pkgs;
        [
          nwg-look
        ];
    };
  };
}
