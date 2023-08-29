{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.eog;
in
  with lib;
{
  options = {
    host.home.applications.eog = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Gnome Image viewer";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          gnome.eog
        ];
    };
  };
}
