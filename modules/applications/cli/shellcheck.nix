{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.shellcheck;
in
  with lib;
{
  options = {
    host.home.applications.shellcheck = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Lint shell scripts";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          shellcheck
        ];
    };
  };
}
