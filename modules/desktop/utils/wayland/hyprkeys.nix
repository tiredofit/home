{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprkeys;
in
  with lib;
{
  options = {
    host.home.applications.hyprkeys = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "A simple, scriptable keybind retrieval utility for Hyprland";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hyprkeys
        ];
    };
  };
}
