{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.pulsemixer;
in
  with lib;
{
  options = {
    host.home.applications.pulsemixer = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Pulseaudio Sound Control";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          pulsemixer
          pavucontrol
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings = {
        window_rule = [
          {
            float = true;
            match = {
              title = "^(pavucontrol)$";
            };
          }
        ];
      };
    };
  };
}