{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.digikam;
in
  with lib;
{
  options = {
    host.home.applications.digikam = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Phto Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          digikam
        ];
    };

  };
}
