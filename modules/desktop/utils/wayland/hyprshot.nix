{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprshot;
in
  with lib;
{
  options = {
    host.home.applications.hyprshot = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Hyprshot is an utility to easily take screenshots in Hyprland using your mouse.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hyprshot
        ];
    };
  };
}
