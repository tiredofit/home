{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.act;
in
  with lib;
{
  options = {
    host.home.applications.nmap = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Network Mapper";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          nmap
        ];
    };
  };
}
