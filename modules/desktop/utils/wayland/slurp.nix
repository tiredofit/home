{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.slurp;
in
  with lib;
{
  options = {
    host.home.applications.slurp = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland screenshot tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          slurp
        ];
    };
  };
}
