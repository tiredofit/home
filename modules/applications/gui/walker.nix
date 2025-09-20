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

    services.walker = {
      enable = true;
      package = pkgs.unstable.walker;
      systemd.enable = mkDefault true;
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
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = mkMerge [
              (mkAfter [
                # Regular Launcher
                "SUPER, D, exec, ${config.host.home.feature.uwsm.prefix}${config.services.walker.package}/bin/walker"
                # Run a shell comamnd shortcut
                "SUPER, R, exec, ${config.host.home.feature.uwsm.prefix}${config.services.walker.package}/bin/walker --modules runner"
                # SSH
                "SUPER, S, exec, ${config.host.home.feature.uwsm.prefix}${config.services.walker.package}/bin/walker --modules ssh"
                # Open Calculator
                "SUPER_SHIFT, C, exec, ${config.host.home.feature.uwsm.prefix}${config.services.walker.package}/bin/walker --modules calculator"
              ])
              (mkIf (config.host.home.applications.cliphist.enable) (mkAfter [
                "CONTROLALT, V, exec, ${config.host.home.feature.uwsm.prefix}${config.services.walker.package}/bin/walker --modules clipboard"
              ]))
            ];
        windowrule = [
        ];
      };
    };
  };
}
