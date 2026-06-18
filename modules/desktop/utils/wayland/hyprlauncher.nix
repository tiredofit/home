{ config, inputs, lib, pkgs, ... }:
let
  cfg = config.host.home.applications.hyprlauncher;
in
  with lib;
{
  options = {
    host.home.applications.hyprlauncher = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "HyprLauncher";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.hyprlauncher;
        description = "HyprLauncher package to use.";
      };
      service.enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Auto start on user session start";
      };
      settings = mkOption {
        type =
          with lib.types;
          let
            valueType =
              nullOr (oneOf [
                bool
                int
                float
                str
                path
                (attrsOf valueType)
                (listOf valueType)
              ])
              // {
                description = "Hyprland configuration value";
              };
          in
          valueType;
        default = { };
        example = {
          general.grab_focus = true;
          cache.enabled = true;
          ui.window_size = "400 260";
          finders = {
            math_prefix = "=";
            desktop_icons = true;
          };
        };
      };
      description = "Configuration settings for hyprlauncher. All the available options can be found here: <https://wiki.hypr.land/Hypr-Ecosystem/hyprlauncher/#config>";
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages =
        [
          cfg.package
        ];
    };

    #26.05
    #services = {
    #  hyprlauncher = {
    #    enable = true;
    #    package = pkgs.hyprlauncher;
    #    settings = {
    #    };
    #  };
    #};

    systemd.user.services.hyprlauncher = mkIf cfg.service.enable {
      Unit = {
        Description = "Application launcher for Hyprland";
        After = [ config.wayland.systemd.target ];
        PartOf = [ config.wayland.systemd.target ];
        ConditionEnvironment = [ "XDG_CURRENT_DESKTOP=Hyprland" ];
        X-Restart-Triggers = lib.mkIf (cfg.settings != { }) [
          "${config.xdg.configFile."hypr/hyprlauncher.conf".source}"
        ];
      };

      Service = {
        Type = "exec";
        ExecStart = "${lib.getExe cfg.package} -d";
        Restart = "always";
      };

      Install = {
        WantedBy = [ config.wayland.systemd.target ];
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings = {
        bind = [
          { _args = ["SUPER + T" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("${config.host.home.feature.uwsm.prefix}${lib.getExe cfg.package}")'')]; }
        ];
      };
    };

    xdg.configFile."hypr/hyprlauncher.conf" = mkIf (cfg.settings != { }) {
      text = lib.hm.generators.toHyprconf { attrs = cfg.settings; };
    };
  };
}
