{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nextcloud-client;
in
  with lib;
{
  options = {
    host.home.applications.nextcloud-client = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "File synchronization";
      };
      service = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Enable to start as service";
        };
        background = mkOption {
          default = true;
          type = with types; bool;
          description = "Start in background";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          nextcloud-client
        ];
    };

    systemd.user.services.nextcloud-client = {
      Unit = {
        Description = "Nextcloud Client";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Environment = [ "PATH=${config.home.profileDirectory}/bin" ];
        ExecStart = "${pkgs.nextcloud-client}/bin/nextcloud"
          + (optionalString cfg.service.background " --background");
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrulev2 = [
          "float,class:(com.nextcloud.desktopclient.nextcloud)"
          "noborder,class:(com.nextcloud.desktopclient.nextcloud)"
          "noblur,class:(com.nextcloud.desktopclient.nextcloud)"
          "noinitialfocus,class:(com.nextcloud.desktopclient.nextcloud)"
          "move onscreen cursor 50% 0%,class:(com.nextcloud.desktopclient.nextcloud)"
          "noanim,class:(com.nextcloud.desktopclient.nextcloud)"
        ];
      };
    };
  };
}
