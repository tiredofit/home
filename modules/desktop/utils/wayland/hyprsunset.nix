{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprsunset;
in
  with lib;
{
  options = {
    host.home.applications.hyprsunset = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Application to enable a blue-light filter on Hyprland";
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
          hyprsunset
        ];
    };

    systemd.user.services.hyprsunset = mkIf cfg.service.enable {
      Unit = {
        Description = "Control display temperature and brightness under wayland";
        Documentation = "https://github.com/hyprwm/hyprsunset";
        After = [ "graphical-session.target" ];
      };

      Service = {
        ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
