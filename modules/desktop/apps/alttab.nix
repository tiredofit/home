{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.alttab;
in
  with lib;
{
  options = {
    host.home.applications.alttab = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Application Picker";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          alttab
        ];
    };
  };
}
