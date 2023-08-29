{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.comma;
in
  with lib;
{
  options = {
    host.home.applications.comma = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Run applications not already installed on system";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
        packages = with pkgs;
          [
            comma
          ];
    };
  };
}
