{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.opensnitch-ui;
in
  with lib;
{
  options = {
    host.home.applications.opensnitch-ui = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Application Firewall";
      };
    };
  };

  config = mkIf cfg.enable {
    services = {
      opensnitch-ui = {
        enable = mkDefault true;
        package = mkDefault pkgs.opensnitch-ui;
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.enable && config.host.home.feature.gui.displayServer == "wayland" && builtins.elem "hyprland" config.host.home.feature.gui.windowManager) {
      settings = {
        window_rule = [
          {
            float = true;
            match = {
              initial_class = "(^opensnitch_ui$)";
            };
          }
          {
            size = "900 600";
            match = {
              initial_class = "(^opensnitch_ui$)";
              initial_title = "(^Preferences$)";
            };
          }
          {
            size = "900 600";
            match = {
              initial_class = "(^opensnitch_ui$)";
              initial_title = "(^Rule$)";
            };
          }
          {
            size = "650 460";
            match = {
              initial_class = "(^opensnitch_ui$)";
              initial_title = "(Firewall)";
            };
          }
          {
            size = "650 460";
            match = {
              initial_class = "(^opensnitch_ui$)";
              initial_title = "(OpenSnitch Network Statistics.*)";
            };
          }
          {
            size = "650 460";
            match = {
              initial_class = "(^opensnitch_ui$)";
              initial_title = "(^OpenSnitch v[0-9]\\.[0-9]\\.[0-9]$)";
            };
          }
        ];
      };
    };
  };
}
