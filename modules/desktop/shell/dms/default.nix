{ config, inputs, lib, pkgs, ... }:
let
  windowManager = config.host.home.feature.gui.windowManager;
  niriActive = builtins.elem "niri" windowManager;
  dmsCfg = config.host.home.feature.gui.shell.dms;
in
with lib;
{
  imports = [
    inputs.dms.homeModules.dank-material-shell
    inputs.dms.homeModules.niri
    inputs.danksearch.homeModules.dsearch
    inputs.dms-plugin-registry.nixosModules.default
  ];

  options.host.home.feature.gui.shell.dms = {
    material = {
      enableSystemMonitoring = mkOption {
        type = types.bool;
        default = true;
        description = "Enable system monitoring widgets (dgop)";
      };
      enableVPN = mkOption {
        type = types.bool;
        default = true;
        description = "Enable VPN management widget";
      };
      enableDynamicTheming = mkOption {
        type = types.bool;
        default = true;
        description = "Enable wallpaper-based theming (matugen)";
      };
      enableAudioWavelength = mkOption {
        type = types.bool;
        default = true;
        description = "Enable audio visualizer (cava)";
      };
      enableCalendarEvents = mkOption {
        type = types.bool;
        default = true;
        description = "Enable calendar integration (khal)";
      };
      enableClipboardPaste = mkOption {
        type = types.bool;
        default = true;
        description = "Enable pasting items from clipboard (wtype)";
      };
    };
    search = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable dsearch indexing daemon";
      };
      package = mkOption {
        type = types.package;
        default = pkgs.dsearch;
        description = "dsearch package to use";
      };
      config = {
        listen_addr = mkOption {
          type = types.str;
          default = ":43654";
          description = "Address for dsearch to listen on";
        };
        index_path = mkOption {
          type = types.str;
          default = "~/.cache/danksearch/index";
          description = "Path for the search index";
        };
        max_file_bytes = mkOption {
          type = types.int;
          default = 2097152;
          description = "Maximum file size in bytes to index (2MB default)";
        };
        worker_count = mkOption {
          type = types.int;
          default = 4;
          description = "Number of indexing workers";
        };
        index_all_files = mkOption {
          type = types.bool;
          default = true;
          description = "Index all file types";
        };
        auto_reindex = mkOption {
          type = types.bool;
          default = true;
          description = "Automatically reindex on interval";
        };
        reindex_interval_hours = mkOption {
          type = types.int;
          default = 160;
          description = "Interval in hours between reindexes";
        };
        text_extensions = mkOption {
          type = types.listOf types.str;
          default = [
            ".txt" ".md" ".go" ".py" ".js" ".ts"
            ".jsx" ".tsx" ".json" ".yaml" ".yml"
            ".toml" ".html" ".css" ".rs"
          ];
          description = "Text file extensions to index";
        };
        index_paths = mkOption {
          type = types.listOf (types.submodule {
            options = {
              path = mkOption {
                type = types.str;
                description = "Path to index";
              };
              max_depth = mkOption {
                type = types.int;
                default = 6;
                description = "Maximum directory depth";
              };
              exclude_hidden = mkOption {
                type = types.bool;
                default = true;
                description = "Exclude hidden files/directories";
              };
              exclude_dirs = mkOption {
                type = types.listOf types.str;
                default = [];
                description = "Additional directories to exclude";
              };
            };
          });
          default = [];
          description = "List of paths to index";
        };
      };
    };
  };

  config = mkIf config.host.home.feature.gui.isDms {
    programs = {
      dank-material-shell = {
        enable = true;
        systemd = {
          enable = mkDefault true;
          restartIfChanged = mkDefault true;
        };

        enableSystemMonitoring = mkDefault dmsCfg.material.enableSystemMonitoring;
        enableVPN = mkDefault dmsCfg.material.enableVPN;
        enableDynamicTheming = mkDefault dmsCfg.material.enableDynamicTheming;
        enableAudioWavelength = mkDefault dmsCfg.material.enableAudioWavelength;
        enableCalendarEvents = mkDefault dmsCfg.material.enableCalendarEvents;
        enableClipboardPaste = mkDefault dmsCfg.material.enableClipboardPaste;

        niri = mkIf niriActive {
          enableKeybinds = mkDefault false;
          enableSpawn = mkDefault false;
        };
      };
      dsearch = {
        enable = mkDefault dmsCfg.search.enable;
        package = mkDefault dmsCfg.search.package;

        config = {
          listen_addr = mkDefault dmsCfg.search.config.listen_addr;
          index_path = mkDefault dmsCfg.search.config.index_path;
          max_file_bytes = mkDefault dmsCfg.search.config.max_file_bytes;
          worker_count = mkDefault dmsCfg.search.config.worker_count;
          index_all_files = mkDefault dmsCfg.search.config.index_all_files;
          auto_reindex = mkDefault dmsCfg.search.config.auto_reindex;
          reindex_interval_hours = mkDefault dmsCfg.search.config.reindex_interval_hours;
          text_extensions = mkDefault dmsCfg.search.config.text_extensions;
          index_paths = mkDefault dmsCfg.search.config.index_paths;
        };
      };
    };

    xdg.configFile.niri-config-dms = mkIf (!niriActive) {
      enable = mkForce false;
    };

    systemd.user.services = {
      dms = {
        Service.ExecCondition = mkDefault "${pkgs.writeShellScript "dms-check-desktop" ''
          case "$XDG_CURRENT_DESKTOP" in
            COSMIC) exit 1;;
            *) exit 0;;
          esac
        ''}";
      };
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
        bind = [
          { _args = ["SUPER + D" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call spotlight-bar toggle")'')]; }
          { _args = ["SUPER + V" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call clipboard toggle")'')]; }
          { _args = ["SUPER + comma" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call settings focusOrToggle")'')]; }
          { _args = ["SUPER + N" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call notifications toggle")'')]; }
          { _args = ["SUPER + SHIFT + N" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call notepad toggle")'')]; }
          { _args = ["SUPER + TAB" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call hypr toggleOverview")'')]; }
          { _args = ["SUPER + P" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call powermenu toggle")'')]; }
          { _args = ["SUPER + SHIFT + Slash" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call keybinds toggle hyprland")'')]; }
          { _args = ["SUPER + SHIFT + X" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call lock lock")'')]; }
          { _args = ["CTRL + ALT + Delete" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call processlist focusOrToggle")'')]; }
          { _args = ["SUPER + SHIFT + W" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("systemctl --user restart dms.service")'')]; }
          {_args = ["XF86AudioRaiseVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call audio increment 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["XF86AudioLowerVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call audio decrement 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["CTRL + XF86AudioRaiseVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call mpris increment 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["CTRL + XF86AudioLowerVolume" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call mpris decrement 1")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["XF86MonBrightnessUp" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call brightness increment 5 \"\"")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
          {_args = ["XF86MonBrightnessDown" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("dms ipc call brightness decrement 5 \"\"")'') (lib.generators.mkLuaInline "{repeating=true,locked=true}")];}
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
