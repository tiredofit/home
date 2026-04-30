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
  ];

  config = mkIf dmsActive {
    programs = {
      dank-material-shell = {
        enable = true;
        systemd= {
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

          auto_reindex = mkDefault false;
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
              path = "~/Projects";
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
  };
}