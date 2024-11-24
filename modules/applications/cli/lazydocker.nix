{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.lazydocker;
in
  with lib;
{
  options = {
    host.home.applications.lazydocker = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Docker Interface";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          lazydocker
        ];
    };
  };
}
