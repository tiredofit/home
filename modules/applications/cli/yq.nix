{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.yq;
in
  with lib;
{
  options = {
    host.home.applications.yq = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "YAML Parser";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          unstable.yq-go
        ];
    };
  };
}
