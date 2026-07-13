{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.flameshot;
in
  with lib;
{

  options = {
    host.home.applications.flameshot = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Screenshot grabber";
      };
      service.enable = mkOption {
        default = true;
        type = with types; bool;
        description = "Auto start on user session start";
      };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      flameshot
      jq
      (pkgs.writeShellScriptBin "flameshot-active-monitor" ''
        set -euo pipefail

        pkill -f "flameshot screen" 2>/dev/null || true

        target="''${1:-}"
        monitors_json=$(hyprctl monitors -j)

        if [ -z "$target" ]; then
          target=$(echo "$monitors_json" | ${pkgs.jq}/bin/jq -r '
            .[] | select(.focused == true) | .name
          ')
        fi

        idx=$(echo "$monitors_json" | ${pkgs.jq}/bin/jq -r --arg t "$target" '
          [.[].name] | index($t) // 0
        ')

        exec flameshot screen --number "$idx" --edit
      '')
    ];

    services.flameshot = mkIf cfg.service.enable {
      enable = true;
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings = {
        bind = [
          {
            _args = [
              "Print"
              (lib.generators.mkLuaInline ''
                function()
                  local mon = hl.get_active_monitor()
                  local name = mon and mon.name or ""
                  hl.exec_cmd("exec flameshot-active-monitor " .. name)
                end
              '')
            ];
          }
          {
            _args = [
              "SUPER + SHIFT + S" (lib.generators.mkLuaInline ''
                function()
                  local mon = hl.get_active_monitor()
                  local name = mon and mon.name or ""
                  hl.exec_cmd("exec flameshot-active-monitor " .. name)
                end
              '')
            ];
          }
        ];
        window_rule = [
          {
            match = {
              class = "^(flameshot)$";
            };
            no_anim = true;
            no_dim = true;
            pin = true;
            float = true;
            decorate = false;
            no_blur = true;
            no_shadow = true;
            stay_focused = true;
          }
          {
            match = {
              class = "flameshot";
              title = "flameshot";
            };
            move = "0 0";
          }
          {
            match = {
              class = "flameshot";
              title = "flameshot-pin";
            };
            move = "cursor_x-(window_w*0.5) cursor_y-(window_h*0.5)";
          }
        ];
      };
    };

    xdg.configFile."flameshot/flameshot.ini".text = ''
      [General]
      buttons=@Variant(\0\0\0\x7f\0\0\0\vQList<int>\0\0\0\0\x13\0\0\0\0\0\0\0\x1\0\0\0\x2\0\0\0\x3\0\0\0\x4\0\0\0\x5\0\0\0\x6\0\0\0\x12\0\0\0\xf\0\0\0\x16\0\0\0\x13\0\0\0\b\0\0\0\t\0\0\0\x10\0\0\0\n\0\0\0\v\0\0\0\x17\0\0\0\xe\0\0\0\f)
      contrastOpacity=188
      copyOnDoubleClick=true
      disabledTrayIcon=true
      drawColor=#0000ff
      drawThickness=13
      jpegQuality=75
      showDesktopNotification=false
      showHelp=false
      showMagnifier=true
      showSelectionGeometryHideTime=2996
      showSidePanelButton=false
      showStartupLaunchMessage=false
      squareMagnifier=false
      uiColor=#ff1a1e
      uiLanguage=en
    '';
  };
}
