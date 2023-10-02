{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.bleachbit;
in
  with lib;
{
  options = {
    host.home.applications.bleachbit = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "System cleaner";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          bleachbit
        ];
    };
  };
}
