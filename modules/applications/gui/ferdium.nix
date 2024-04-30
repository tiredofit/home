{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.ferdium;
in
  with lib;
{
  options = {
    host.home.applications.ferdium = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Multi Messaging tool";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          ferdium
        ];
    };


    ## TODO - Only write this is hyprland.enable
    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "ferdium --ozone-platform=wayland --enable-features-WaylandWindowDecorations"
        ];
        windowrulev2 = [
          "workspace 3,class:(^Ferdium)$"
        ];
      };
    };
  };
}
