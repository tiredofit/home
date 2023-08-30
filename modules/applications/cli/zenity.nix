{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.zenity;
in
  with lib;
{
  options = {
    host.home.applications.zenity = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Display dialogs from command line and shellscripts";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          gnome.zenity
        ];
    };
  };
}
