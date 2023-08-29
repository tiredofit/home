{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.file-roller;
in
  with lib;
{
  options = {
    host.home.applications.file-roller = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Gnome File Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          gnome.file-roller
        ];
    };
  };
}
