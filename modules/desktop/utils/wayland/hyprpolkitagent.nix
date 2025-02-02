{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprpolkitagent;
in
  with lib;
{
  options = {
    host.home.applications.hyprpolkitagent = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Polkit authentication agent written in QT/QML";
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
          hyprpolkitagent
        ];
    };

    systemd.user.services.hyprpolkit = mkIf cfg.service.enable {
      Unit = {
        Description = "Hyprland Polkit Authentication Agent";
        Documentation = "https://github.com/hyprwm/hyprpolkitagent";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = [ "WAYLAND_DISPLAY" ];
      };

      Service = {
        ExecStart = "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent";
        Slice = "session.slice";
        TimeoutStopSec = "5sec";
        Restart = "on-failure";
      };
    };

    #wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
    #  settings = {
    #    #exec-once = [
    #    #  "${config.host.home.feature.uwsm.prefix}systemctl --user start hyprpolkitagent"
    #    #];
    #  };
    #};
  };
}
