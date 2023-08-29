{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.shfmt;
in
  with lib;
{
  options = {
    host.home.applications.shfmt = {
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
          shfmt
        ];
    };
  };
}
