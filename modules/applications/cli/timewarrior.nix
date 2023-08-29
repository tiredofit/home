{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.timewarrior;
in
  with lib;
{
  options = {
    host.home.applications.timewarrior = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Time tracker";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          timewarrior
        ];
    };
  };
}
