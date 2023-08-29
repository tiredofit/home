{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.chromium;
in
  with lib;
{
  options = {
    host.home.applications.chromium = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Web Browser";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          chromium
        ];
    };
  };
}
