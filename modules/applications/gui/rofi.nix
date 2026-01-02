{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.host.home.applications.rofi;
  #displayServer = config.host.home.feature.gui.displayServer;
  #rofiPackage = if displayServer == "wayland" then pkgs.unstable.rofi-wayland else pkgs.unstable.rofi;
  rofiPackage = pkgs.unstable.rofi;
  rofiCalculator = pkgs.writeShellScriptBin "rofi-calculator" ''
    # rofi -show run -modi calc: rofi-calculator.sh
    ROFI_CALC_HISTORY_FILE=$HOME/.local/share/rofi/rofi_calc_history
    ROFI_CALC_HISTORY_MAXCOUNT=8

    if [ ! -d $(dirname "''${ROFI_CALC_HISTORY_FILE}") ]; then
      mkdir -p "$(dirname "''${ROFI_CALC_HISTORY_FILE}")"
    fi

    if [ -z ''${@} ]; then
      cat "''${ROFI_CALC_HISTORY_FILE}"
    else
      _formula=''${@}

      if [ -n "''${_formula}" ]; then
        if [[ "''${_formula}" =~ "=" ]]; then
          _output=''${_formula}
        else
          _result=$(echo "''${_formula}" | ${pkgs.bc}/bin/bc -l)
          _output="''${_formula} = ''${_result}"
        fi

        echo -e "''${_output}\n$(cat "''${ROFI_CALC_HISTORY_FILE}")" > "''${ROFI_CALC_HISTORY_FILE}"
        if [ $( wc -l < "''${ROFI_CALC_HISTORY_FILE}" ) -gt ''${ROFI_CALC_HISTORY_MAXCOUNT} ]; then
          echo "$(head -n "''${ROFI_CALC_HISTORY_MAXCOUNT}" "''${ROFI_CALC_HISTORY_FILE}")" > "''${ROFI_CALC_HISTORY_FILE}"
        fi
            cat "''${ROFI_CALC_HISTORY_FILE}"
        fi
    fi
  '';
in {
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
    home = {
      packages = with pkgs;
        [
          rofiCalculator
        ];
    };
    programs.rofi = {
      enable = true;
      plugins = with pkgs; [
        #rofi-emoji
        #rofi-calc
      ];
      terminal = "${pkgs.kitty}/bin/kitty";
      package = rofiPackage;
      extraConfig = {
        combi-modi = "run,drun";
        cycle = true;
        disable-history = false;
        display-Network = " 󰤨  Network";
        display-drun = "   Apps ";
        display-run = "   Run ";
        display-window = " █  Window";
        drun-display-format = "{icon} {name}";
        font = "Noto Sans NF 12";
        hide-scrollbar = true;
        icon-theme = "Papirus";
        lines = 6;
        modi = "drun,run,ssh";
        run-command = "${config.host.home.feature.uwsm.prefix}{cmd}";
        show-icons = true;
        sidebar-mode = true;
        sort = true;
        ssh-client = "ssh";
      };
      theme = "~/.config/rofi/themes/toi.rasi";
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        bind = mkMerge [
          (mkAfter [
            # Regular Launcher
            "SUPER, D, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -combi-modi drun,run,ssh -show drun -show-icons -show-icons -theme-str 'window{width:30%; height:30%;} listview{columns:1;}'"
            # Run a shell comamnd shortcut
            "SUPER, R, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -show run -run-shell-command '${pkgs.kitty}/bin/kitty --hold \"{cmd} && read\"' -no-show-icons -no-drun-show-actions -no-cycle -combi-display run -no-sidebar-mode -theme-str 'window{width:50%; height:40%;} listview{columns:1;}'"
            # SSH
            "SUPER, S, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -show ssh -no-parse-known-hosts -modi ssh -show-icons -theme-str 'window{width:30%; height:30%;} listview{columns:1;}'"
            # Open a new terminal and execute command
            "SUPER_SHIFT, R, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -show run -run-shell-command '${pkgs.kitty}/bin/kitty --hold \"{cmd}\"' -no-history -no-auto-select -disable-history -no-show-icons -no-drun-show-actions -no-cycle -no-sidebar-mode -theme-str 'window{width:50%; height:8%;} listview{columns:1;}'"
            # Open Calculator
            "SUPER_SHIFT, C, exec, pkill rofi || ${config.programs.rofi.package}/bin/rofi -show calc -modi calc:${rofiCalculator}/bin/rofi-calculator -theme-str 'window{width:50%; height:30%;} listview{columns:1;}'"
          ])
          (mkIf (config.host.home.applications.cliphist.enable) (mkAfter [
            "CONTROLALT, V, exec, pkill rofi || ${pkgs.cliphist}/bin/cliphist list | ${config.programs.rofi.package}/bin/rofi -dmenu -columns 1 -theme-str 'window{width:50%; height:40%;} listview{columns:1;}'| ${pkgs.cliphist}/bin/cliphist decode | wl-copy"
          ]))
        ];
        windowrule = [
        ];
      };
    };

    xdg = {
      configFile = {
        "rofi/themes/top-down.rasi" = {
          text = ''
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
              font:                            "Noto Sans NF 10";
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
        "rofi/themes/toi.rasi" = {
          text = ''
            * {
              bg-col:  #1E1D2F;
              bg-col-light: #1E1D2F;
              border-col: #1E1D2F;
              selected-col: #1E1D2F;
              peach: #FAB387;
              fg-col: #D9E0EE;
              fg-col2: #F28FAD;
              grey: #D9E0EE;
              width: 600;
            }

            element-text, element-icon , mode-switcher {
              background-color: inherit;
              text-color:       inherit;
            }

            window {
              height: 360px;
              width: 30%;
              border: 3px;
              border-radius:6px;
              background-color: @bg-col;
              border-color:@peach;
            }

            mainbox {
              background-color: @bg-col;
            }

            inputbar {
              children: [prompt,entry];
              background-color: @bg-col;
              border-radius: 6px;
              padding: 2px;
            }

            prompt {
              background-color: @peach;
              padding: 6px;
              text-color: @bg-col;
              border-radius: 6px;
              margin: 20px 0px 0px 20px;
            }

            textbox-prompt-colon {
              expand: false;
              str: ":";
            }

            entry {
              padding: 6px;
              margin: 20px 10px 0px 10px;
              text-color: @fg-col;
              background-color: @bg-col;
              border: 2px;
              border-radius: 3px;
              border-color: @peach;
              placeholder:"Search";
            }

            listview {
              border: 0px 0px 0px;
              padding: 6px 0px 0px;
              margin: 10px 0px 0px 20px;
              columns: 2;
              background-color: @bg-col;
            }

            element {
              padding: 5px;
              background-color: @bg-col;
              text-color: @fg-col  ;
            }

            element-icon {
              size: 25px;
            }

            element selected {
              background-color:  @selected-col ;
              text-color: @fg-col2  ;
            }

            mode-switcher {
              spacing: 0;
            }

            button {
              padding: 10px;
              background-color: @bg-col-light;
              text-color: @grey;
              vertical-align: 0.5;
              horizontal-align: 0.5;
            }

            button selected {
              background-color: @bg-col;
              text-color: @peach;
            }
          '';
        };
      };
    };
  };
}
