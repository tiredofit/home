{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.autotiling;
in
  with lib;
{
  options = {
    host.home.applications.autotiling = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto tile windows horizontally or vertically";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          autotiling
        ];
    };
  };
}
