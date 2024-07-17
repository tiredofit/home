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
          unstable.ferdium
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
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
