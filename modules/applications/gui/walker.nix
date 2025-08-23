{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.host.home.applications.walker;
in {
  options = {
    host.home.applications.walker = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Launcher";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          unstable.walker
        ];
    };

    #services.walker = {
    #  enable = false;
    #  package = pkgs.unstable.walker;
    #  systemd.enable = true;
    #  settings = {
    #    app_launch_prefix = "";
    #    as_window = false;
    #    close_when_open = false;
    #    disable_click_to_close = false;
    #    force_keyboard_focus = false;
    #    hotreload_theme = false;
    #    locale = "";
    #    monitor = "";
    #    terminal_title_flag = "";
    #    timeout = 0;
    #  };
    #  theme = {
    #    name = "";
    #    layout = "default";
    #    style = "";
    #  };
    #};

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = [
          "SUPER_SHIFT, Z, exec, walker"
        ];
        windowrule = [
        ];
      };
    };

  };
}
