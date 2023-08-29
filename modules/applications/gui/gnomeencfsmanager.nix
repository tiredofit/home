{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.gnome-encfs-manager;
in
  with lib;
{
  options = {
    host.home.applications.gnome-encfs-manager = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Encryption Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          encfs
          gencfsm
        ];
    };
  };
}
