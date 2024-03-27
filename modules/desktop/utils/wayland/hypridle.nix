{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hypridle;
in
  with lib;
{
  options = {
    host.home.applications.hypridle = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Hyprland Idle Monitor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hypridle
        ];
    };

    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
          lock_cmd = pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock       # avoid starting multiple hyprlock instances.
          before_sleep_cmd = loginctl lock-session                         # lock before suspend.
          after_sleep_cmd = hyprctl dispatch dpms on                       # to avoid having to press a key twice to turn on the display.
      }

      listener {
          timeout = 600                                 # 10min
          on-timeout = loginctl lock-session            # lock screen when timeout has passed
      }

      listener {
          timeout = 660                                 # 11min
          on-timeout = hyprctl dispatch dpms off        # screen off when timeout has passed
          on-resume = hyprctl dispatch dpms on          # screen on when activity is detected after timeout has fired.
      }

      listener {
          timeout = 900                                 # 15min
          on-timeout = systemctl suspend                # suspend pc
      }
    '';
  };
}
