{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.ncdu;
in
  with lib;
{
  options = {
    host.home.applications.ncdu = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Disk Usage monitor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          ncdu
        ];
    };

    xdg.configFile."ncdu/config".text = ''
      -e
      --exclude .git
      --exclude .snapshots
      --exclude-kernfs
      --exclude /var/lib/docker
    '';
  };
}
