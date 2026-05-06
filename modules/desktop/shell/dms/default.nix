{ config, inputs, lib, pkgs, ... }:
let
  shell = config.host.home.feature.gui.shell;
  windowManager = config.host.home.feature.gui.windowManager;
  displayServer = config.host.home.feature.gui.displayServer;
  dmsActive = config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "dms" shell;
  niriActive = builtins.elem "niri" windowManager;
  hyprlandActive = builtins.elem "hyprland" windowManager;
in
with lib;
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.danksearch.homeModules.dsearch
    inputs.dms-plugin-registry.modules.default
  ];

  config = mkIf dmsActive {
    programs = {
      dank-material-shell = {
        enable = true;
        systemd = {
          enable = mkDefault true;
          restartIfChanged = mkDefault true;
        };

        enableSystemMonitoring = mkDefault true;     # System monitoring widgets (dgop)
        enableVPN = mkDefault true;                  # VPN management widget
        enableDynamicTheming = mkDefault true;       # Wallpaper-based theming (matugen)
        enableAudioWavelength = mkDefault true;      # Audio visualizer (cava)
        enableCalendarEvents = mkDefault true;       # Calendar integration (khal)
        enableClipboardPaste = mkDefault true;       # Pasting items from the clipboard (wtype)

        niri = mkIf niriActive {
          enableKeybinds = mkDefault false;
          enableSpawn = mkDefault false;
        };

        #plugins = {
          #dankBatteryAlerts.enable = true;
          #dankBatteryAlerts.src = inputs.dms-plugin-registry.packages.${pkgs.system}.dankBatteryAlerts;
        #};
        #settings = { # Enable to allow it to export JSON settings https://stevebinary.github.io/json2nix/
        #  theme = "dark";
        #  dynamicTheming = true;
        #};
      };
      dsearch = {
        enable = mkDefault true;
        package = mkDefault pkgs.dsearch;

        config = {
          listen_addr = mkDefault ":43654";

          index_path = mkDefault "~/.cache/danksearch/index";
          max_file_bytes = mkDefault 2097152;  # 2MB
          worker_count = mkDefault 4;
          index_all_files = mkDefault true;

          auto_reindex = mkDefault true;
          reindex_interval_hours = mkDefault 24;

          # Text file extensions
          text_extensions = [
            ".txt" ".md" ".go" ".py" ".js" ".ts"
            ".jsx" ".tsx" ".json" ".yaml" ".yml"
            ".toml" ".html" ".css" ".rs"
          ];

          # Index paths configuration
          index_paths = [
            {
              path = "~/Documents";
              max_depth = 6;
              exclude_hidden = true;
              exclude_dirs = [ "node_modules" "venv" "target" ];
            }
            {
              path = "~/src";
              max_depth = 8;
              exclude_hidden = true;
              exclude_dirs = [ "node_modules" ".git" "target" "dist" ];
            }
          ];
        };
      };
    };

    # Guard the DMS service: don't start under COSMIC desktop.
    systemd.user.services = {
      dms = {
        Service.ExecCondition = mkDefault "${pkgs.writeShellScript "dms-check-desktop" ''
          case "$XDG_CURRENT_DESKTOP" in
            COSMIC) exit 1;;
            *) exit 0;;
          esac
        ''}";
      };
      #niri-flake-polkit = mkIf niriActive {
      #  Install.WantedBy = mkForce [];
      #};
    };

    wayland.windowManager.hyprland = mkIf (dmsActive && config.programs.dank-material-shell.systemd.enable) {
      settings = {
        # === Application Launchers ===
        bind = [
          "SUPER, D, exec, dms ipc call spotlight toggle"
          "SUPER, V, exec, dms ipc call clipboard toggle"
          #"SUPER, M, exec, dms ipc call processlist focusOrToggle"
          "SUPER, comma, exec, dms ipc call settings focusOrToggle"
          "SUPER, N, exec, dms ipc call notifications toggle"
          "SUPER SHIFT, N, exec, dms ipc call notepad toggle"
          #"SUPER, Y, exec, dms ipc call dankdash wallpaper"
          "SUPER, TAB, exec, dms ipc call hypr toggleOverview"
          "SUPER, P, exec, dms ipc call powermenu toggle"
          # === Cheat sheet ===
          "SUPER SHIFT, Slash, exec, dms ipc call keybinds toggle hyprland"
          # === Security ===
          "SUPER SHIFT, X, exec, dms ipc call lock lock"
          "CTRL ALT, Delete, exec, dms ipc call processlist focusOrToggle"

          "SUPER_SHIFT, W, exec, systemctl --user restart dms.service"


          # === Screenshots ===
          #", Print, exec, dms screenshot"
          #"CTRL, Print, exec, dms screenshot full"
          #"ALT, Print, exec, dms screenshot window"

          #"SUPER SHIFT, S, exec, dms screenshot --no-file --reset"
        ];

        bindel = [
          # === Audio Controls ===
          ", XF86AudioRaiseVolume, exec, dms ipc call audio increment 1"
          ", XF86AudioLowerVolume, exec, dms ipc call audio decrement 1"
          "CTRL, XF86AudioRaiseVolume, exec, dms ipc call mpris increment 1"
          "CTRL, XF86AudioLowerVolume, exec, dms ipc call mpris decrement 1"
          # === Brightness Controls ===
          ", XF86MonBrightnessUp, exec, dms ipc call brightness increment 5 \"\""
          ", XF86MonBrightnessDown, exec, dms ipc call brightness decrement 5 \"\""
        ];
        bindl = [
          # === Audio Controls ===
          ", XF86AudioMute, exec, dms ipc call audio mute"
          ", XF86AudioMicMute, exec, dms ipc call audio micmute"
          ", XF86AudioPause, exec, dms ipc call mpris playPause"
          ", XF86AudioPlay, exec, dms ipc call mpris playPause"
          ", XF86AudioPrev, exec, dms ipc call mpris previous"
          ", XF86AudioNext, exec, dms ipc call mpris next"
        ];
        source = [
          #"./dms/binds.conf"
          "./dms/colors.conf"
          "./dms/cursor.conf"
          "./dms/layout.conf"
          "./dms/outputs.conf"
          "./dms/windowrules.conf"
        ];
        layerrule = [
          "no_anim on, match:namespace ^dms:.*"
          "no_anim on, match:namespace ^(quickshell)$"
        ];
        windowrule = [
          "float on, match:class ^(org.quickshell)$"
        ];
      };
    };
  };
}
