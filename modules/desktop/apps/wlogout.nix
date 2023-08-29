{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wlogout;
in
  with lib;
{
  options = {
    host.home.applications.wlogout = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Logout Menu";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wlogout
        ];
    };
  };
}
