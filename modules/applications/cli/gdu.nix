{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.gdu;
in
  with lib;
{
  options = {
    host.home.applications.gdu = {
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
          gdu
        ];
    };

    programs = {
      bash = {
        {
          ncdu = "gdu --config-file ~/.config/gdu/config.yaml";
          gdu = "gdu --config-file ~/.config/gdu/config.yaml";
        };
      };

    xdg.configFile."gdu/config.yaml".text = ''
      ignore-dirs:
        - /var/lib/docker
      ignore-dir-patterns:
        - .snapshots
        - .git
    '';
  };
}
