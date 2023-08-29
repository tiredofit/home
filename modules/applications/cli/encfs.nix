{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.encfs;
in
  with lib;
{
  options = {
    host.home.applications.encfs = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Encrypted filesystem tools and driver";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          encfs
        ];
    };
  };
}
