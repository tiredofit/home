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

    services = {
      nextcloud-client = {
        enable = mkDefault cfg.service.enable;
        package = mkDefault pkgs.nextcloud-client;
        startInBackground = mkDefault cfg.service.background;
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
          "float on, border_size 0, no_blur on, no_initial_focus on, no_anim on, match:class (com.nextcloud.desktopclient.nextcloud)"
        ];
      };
    };
  };
}
