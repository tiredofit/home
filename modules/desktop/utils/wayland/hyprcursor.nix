{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprcursor;
in
  with lib;
{
  options = {
    host.home.applications.hyprcursor = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "hyprcursor is a new cursor theme format that has many advantages over the widely used xcursor.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hyprcursor
        ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        env = [
          "HYPRCURSOR_SIZE,24"
        ];
      };
    };
  };
}
