{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.rclone;
in
  with lib;
{
  options = {
    host.home.applications.rclone = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Remote filesystem tools";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          rclone
        ];
    };
  };
}
