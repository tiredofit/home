{config, lib, nix-colours, pkgs, ...}:

let
  cfg = config.host.home.applications.ghostty;
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
  with lib;
{
  options = {
    host.home.applications.ghostty = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Terminal Emulator";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      ghostty = {
        enable = true;
        package = pkgs.unstable.ghostty;
        enableBashIntegration = mkDefault true;
        installBatSyntax = mkDefault true;
        settings = {
          theme = "hybrid-krompus";
          font-family = "Hack";
          font-size = 11;
gtk-titlebar = true;
quit-after-last-window-closed = false;
bold-is-bright = true;
          cursor-style = "block";
          cursor-style-blink = true;
          keybind = [
            "ctrl+h=goto_split:left"
            "ctrl+l=goto_split:right"
            "ctrl+enter=new_window"
      "ctrl+t=new_split:down"
      "ctrl+shift+r=new_split:right"
      "ctrl+shift+t=new_tab"
      "ctrl+s=goto_split:next"
      "ctrl+shift+s=next_tab"
      "ctrl+w=close_surface"
          ];
        };
        themes = {
          catppuccin-mocha = {
            background = "1e1e2e";
            cursor-color = "f5e0dc";
            foreground = "cdd6f4";
            palette = [
              "0=#45475a"
              "1=#f38ba8"
              "2=#a6e3a1"
              "3=#f9e2af"
              "4=#89b4fa"
              "5=#f5c2e7"
              "6=#94e2d5"
              "7=#bac2de"
              "8=#585b70"
              "9=#f38ba8"
              "10=#a6e3a1"
              "11=#f9e2af"
              "12=#89b4fa"
              "13=#f5c2e7"
              "14=#94e2d5"
              "15=#a6adc8"
            ];
            selection-background = "353749";
            selection-foreground = "cdd6f4";
          };
          hybrid-krompus = {
            palette = [
              # black
              "0=#0a0a0a"
              "8=#73645d"

              # red
              "1=#e61f00"
              "9=#ff3f3d"

              # green
              "2=#6dd200"
              "10=#c1ff05"

              # yellow
              "3=#fa6800"
              "11=#ffa726"

              # blue
              "4=#255ae4"
              "12=#00ccff"

              # magenta
              "5=#ff0084"
              "13=#ff65a0"

              # cyan
              "6=#36fcd3"
              "14=#96ffe3"

              # white
              "7=#b6afab"
              "15=#fff5ed"
            ];
            background = "0d0c0c";
            foreground = "fff5ed";
            cursor-color = "00ccff";
          };
        };
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
      settings = {
        ## See more in modules/applications/* and modules/desktop/utils/*
        bind = [
          "SUPER, P, exec, ghostty +new-window"
        ];
      };
    };
  };
}
