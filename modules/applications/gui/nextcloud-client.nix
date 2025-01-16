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
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          nextcloud-client
        ];
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "${config.host.home.feature.uwsm.prefix}nextcloud --background"
        ];
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
