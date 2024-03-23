{config, lib, pkgs, ...}:
  with lib;
let
  cfg = config.host.home.applications.rofi;
  displayServer = config.host.home.feature.gui.displayServer ;
  rofiPackage =
    if displayServer == "wayland"
    then pkgs.rofi-wayland
    else pkgs.rofi;
in
{
  options = {
    host.home.applications.rofi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Launcher";
      };
    };
  };

  config = mkIf cfg.enable {
    programs.rofi = {
      enable = true;
      terminal = "${pkgs.kitty}/bin/kitty";
      package = rofiPackage;
      extraConfig = {
        combi-modi = "window,drun,run,emoji";
        cycle = true;
        disable-history = false;
        display-drun = "";
        drun-display-format = "{name}";
        font = "Noto Sans 10";
        icon-theme = "Papirus";
        modi = "window,drun,run,combi";
        show-icons = true;
        sidebar-mode = true;
        sort = true;
        ssh-client =  "ssh";
      };
      theme = "~/.config/rofi/themes/top-down.rasi";
    };

    xdg.configFile."rofi/themes/top-down.rasi".text = ''
      * {
          background:                     #EFF0F1FF;
          background-alt:                 #00000000;
          background-bar:                 #93CEE999;
          foreground:                     #000000A6;
          accent:                         #3DAEE9FF;

      }

      window {
          transparency:                   "real";
          background-color:               @background;
          text-color:                     @foreground;
          border:                         0px;
          border-color:                   @border;
          border-radius:                  0px;
          width:                          38%;
          location:                       north;
          x-offset:                       0;
          y-offset:                       0;
      }

      prompt {
          enabled:                         true;
          padding:                         0.30% 0.75% 0% -0.5%;
          background-color:                @background-alt;
          text-color:                      @foreground;
          font:                            "Noto Sans 10";
      }

      entry {
          background-color:               @background-alt;
          text-color:                     @foreground;
          placeholder-color:              @foreground;
          expand:                         true;
          horizontal-align:               0;
          placeholder:                    "Search";
          padding:                        -0.15% 0% 0% 0%;
          blink:                          true;
      }

      inputbar {
          children:                       [ prompt, entry ];
          background-color:               @background;
          text-color:                     @foreground;
          expand:                         false;
          border:                         0.1%;
          border-radius:                  4px;
          border-color:                   @accent;
          margin:                         0% 0% 0% 0%;
          padding:                        1%;
      }

      listview {
          background-color:               @background-alt;
          columns:                        1;
          lines:                          9;
          spacing:                        0.5%;
          cycle:                          true;
          dynamic:                        true;
          layout:                         vertical;
      }

      mainbox {
          background-color:               @background-alt;
          border:                         0% 0% 0% 0%;
          border-radius:                  0% 0% 0% 0%;
          border-color:                   @accent;
          children:                       [ inputbar, listview ];
          spacing:                        1%;
          padding:                        1% 0.5% 1% 0.5%;
      }

      element {
          background-color:               @background-alt;
          text-color:                     @foreground;
          orientation:                    horizontal;
          border-radius:                  0%;
          padding:                        0.5%;
      }

      element-icon {
          background-color:               @background-alt;
          text-color:                     inherit;
          horizontal-align:               0.5;
          vertical-align:                 0.5;
          size:                           32px;
          border:                         0px;
      }

      element-text {
          background-color:               @background-alt;
          text-color:                     inherit;
          expand:                         true;
          horizontal-align:               0;
          vertical-align:                 0.5;
          margin:                         0% 0% 0% 0.25%;
      }

      element selected {
          background-color:               @background-bar;
          text-color:                     @foreground;
          border:                         0.1%;
          border-radius:                  4px;
          border-color:                   @accent;
      }
    '';
  };
}
