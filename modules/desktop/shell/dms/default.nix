{ config, inputs, lib, pkgs, ... }:
let
  shell = config.host.home.feature.gui.shell;
  windowManager = config.host.home.feature.gui.windowManager;
  displayServer = config.host.home.feature.gui.displayServer;
  niriActive = builtins.elem "niri" windowManager;
  hyprlandActive = builtins.elem "hyprland" windowManager;
in
with lib;
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.danksearch.homeModules.dsearch
    inputs.dms-plugin-registry.nixosModules.default
  ];

  config = mkIf config.host.home.feature.gui.isDms {
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

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isDms && config.programs.dank-material-shell.systemd.enable) {
      extraConfig = ''
        require("dms.colors")
        require("dms.outputs")
        require("dms.layout")
        require("dms.cursor")
        require("dms.binds")
        require("dms.binds-user")
        require("dms.windowrules")
      '';
      settings = {
        ## Application Launchers
        bind = [
          { _args = ["SUPER + D" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle")'')]; }
          { _args = ["SUPER + V" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call clipboard toggle")'')]; }
          { _args = ["SUPER + comma" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call settings focusOrToggle")'')]; }
          { _args = ["SUPER + N" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call notifications toggle")'')]; }
          { _args = ["SUPER + SHIFT + N" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call notepad toggle")'')]; }
          { _args = ["SUPER + TAB" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call hypr toggleOverview")'')]; }
          { _args = ["SUPER + P" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call powermenu toggle")'')]; }
          # Cheat sheet
          { _args = ["SUPER + SHIFT + Slash" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland")'')]; }
          # Security
          { _args = ["SUPER + SHIFT + X" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call lock lock")'')]; }
          { _args = ["CTRL + ALT + Delete" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle")'')]; }

          { _args = ["SUPER + SHIFT + W" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("systemctl --user restart dms.service")'')]; }

          # Audio Controls (repeating + locked)
          {_args = ["XF86AudioRaiseVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call audio increment 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["XF86AudioLowerVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call audio decrement 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["CTRL + XF86AudioRaiseVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call mpris increment 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["CTRL + XF86AudioLowerVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call mpris decrement 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          # Brightness Controls (repeating + locked)
          {_args = ["XF86MonBrightnessUp" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call brightness increment 5 \"\"")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["XF86MonBrightnessDown" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call brightness decrement 5 \"\"")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          # Audio Mute (locked)
          {_args = ["XF86AudioMute" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('dms ipc call audio mute')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioMicMute" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('dms ipc call audio micmute')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioPause" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('dms ipc call mpris playPause')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioPlay" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('dms ipc call mpris playPause')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioPrev" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('dms ipc call mpris previous')") (lib.generators.mkLuaInline "{locked=true}")];}
          {_args = ["XF86AudioNext" (lib.generators.mkLuaInline "hl.dsp.exec_cmd('dms ipc call mpris next')") (lib.generators.mkLuaInline "{locked=true}")];}
        ];

        layer_rule = [
          {
            no_anim = true;
            match = {
              namespace = "^dms:.*";
            };
          }
          {
            no_anim = true;
            match = {
              namespace = "^(quickshell)$";
            };
          }
        ];
        window_rule = [
          {
            float = true;
            match = {
              class = "^(org.quickshell)$";
            };
          }
        ];
      };
    };
  };
}
