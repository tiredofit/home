{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.ferdium;
  flags = [
    "--enable-features=UseOzonePlatform,WaylandWindowDecorations,WebRTCPipeWireCapturer"
    "--ozone-platform=wayland"
    "--enable-smooth-scrolling"
  ];
  ferdium-wrapped = pkgs.writeShellScriptBin "ferdium" ''
    exec ${pkgs.unstable.ferdium}/bin/ferdium ${builtins.toString flags} "$@"
  '';
in
  with lib;
{
  options = {
    host.home.applications.ferdium = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Multi Messaging tool";
      };
      service = {
        enable = mkOption {
          default = false;
          type = with types; bool;
          description = "Enable to start as a systemd user service";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        ferdium-wrapped
      ];
    };

    systemd.user.services.ferdium = mkIf cfg.service.enable {
      Unit = {
        Description = "Ferdium - Multi Messaging Tool";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = "${ferdium-wrapped}/bin/ferdium";
        Restart = "on-failure";
        RestartSec = "3";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && builtins.elem "hyprland" config.host.home.feature.gui.windowManager && config.host.home.feature.gui.enable) {
      settings = {
        on = mkIf (!cfg.service.enable) [{ _args = ["hyprland.start" (lib.generators.mkLuaInline "function() hl.exec_cmd('${config.host.home.feature.uwsm.prefix}ferdium') end")]; }];
        window_rule = [
          {
            workspace = "3";
            match = {
              class = "(^Ferdium)$";
            };
          }
        ];
      };
    };
  };
}
