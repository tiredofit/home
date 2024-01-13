{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.veracrypt;
in
  with lib;
{
  options = {
    host.home.applications.veracrypt = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "File / Block encryption tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          veracrypt
        ];
    };
  };
}
