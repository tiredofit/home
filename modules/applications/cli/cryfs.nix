{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.cryfs;
in
  with lib;
{
  options = {
    host.home.applications.cryfs = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Tools to access encrypted filesystems";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          cryfs
        ];
    };
  };
}
