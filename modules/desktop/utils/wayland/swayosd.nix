{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.swayosd;
  prefixUWSM =
    if config.host.network.firewall.fail2ban.enable
    then "VERBOSE"
    else "INFO";
in
  with lib;
{
  options = {
    host.home.applications.swayosd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Sway On Screen Display";
      };
      service.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto start on user session start";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          swayosd
        ];
    };

    systemd.user.services.swayosd = mkIf cfg.service.enable {
      Unit = {
        Description = "A GTK based on screen display for keyboard shortcuts like caps-lock and volume ";
        Documentation = "https://github.com/ErikReider/SwayOSD";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
      };

      Service = {
        Type = "dbus";

        ExecStart = "${pkgs.swayosd}/bin/swayosd-server";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    ## TODO Make this work for dynamic Display (monitor_primary)
    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bindl = [
          ",XF86AudioMute, exec, ${config.host.home.feature.uwsm.prefix}swayosd-client --output-volume mute-toggle"
        ];
        bindle = [
          ",XF86AudioRaiseVolume, exec, ${config.host.home.feature.uwsm.prefix}swayosd-client --output-volume +1 --max-volume=100"
          ",XF86AudioLowerVolume, exec, ${config.host.home.feature.uwsm.prefix}swayosd-client --output-volume -1"
        ];
        #exec-once = [
        #  "${config.host.home.feature.uwsm.prefix}swayosd-server"
        #];
      };
    };

    xdg.configFile."swayosd/style.css".text = ''
      window {
          padding: 12px 20px;
          border-radius: 999px;
          border: 10px;
          background: alpha(#000000, 0.4);
      }

      #container {
          margin: 16px;
      }

      image, label {
          color: #FFFFFF;
      }

      progressbar:disabled,
      image:disabled {
          opacity: 0.8;
      }

      progressbar {
          min-height: 6px;
          border-radius: 999px;
          background: transparent;
          border: none;
      }
      trough {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: alpha(#CCCCCC, 0.1);
      }
      progress {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: #FFFFFF;
      }
    '';
  };
}
