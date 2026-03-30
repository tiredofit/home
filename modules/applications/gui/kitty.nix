{config, lib, nix-colours, pkgs, ...}:
## PERSONALIZE
let
  cfg = config.host.home.applications.kitty;
  displayServer = config.host.home.feature.gui.displayServer ;
  windowManager = config.host.home.feature.gui.windowManager ;
in
  with lib;
{
  options = {
    host.home.applications.kitty = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Terminal Emulator";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellInit = ''
      clone() {
        case "$1" in
          tab)
            clone_arg="--type tab"
          ;;
          title)
            clone_arg="--title '$2'"
          ;;
          *)
            clone_arg=$@
          ;;
        esac

        clone-in-kitty $clone_arg
      }

      edit() {
        case "$2" in
          tab)
            edit_arg="--type tab"
          ;;
          title)
            edit_arg="--title '$3'"
          ;;
          *)
            edit_arg="$${@}"
          ;;
        esac

        edit-in-kitty $edit_arg
      }

      if [ -n "$KITTY_WINDOW_ID" ]; then
        alias ssh="kitty +kitten ssh"
        alias sssh="/run/current-system/sw/bin/ssh"
      fi
    '';
    in {
      programs = {
        kitty = {
        enable = true;
        package = pkgs.unstable.kitty;
        font = mkDefault {
          name = mkDefault "Hack Nerd Font Mono";
          size = mkDefault 11.0;
        };
        keybindings = {
          "ctrl+shift+c" = "copy_and_clear_or_interrupt";
          "ctrl+alt+enter" = "launch --location=neighbour";
          "f1" = "launch --cwd=current --type=tab";
          "f2" = "launch --cwd=current";
        };
        settings = {
          # Font
          bold_font = mkDefault "auto";
          italic_font = mkDefault "auto";
          bold_italic_font = mkDefault "auto";
          ## Cursor
          cursor_shape = mkDefault "block";
          cursor_blink_interval = mkDefault "-1" ;
          ## Scrollback
          scrollback_lines = mkDefault 10000;
          # Auto Select from Mouse Clipboard;
          copy_on_select = mkDefault "clipboard";
          strip_trailing_spaces = mkDefault "smart"; # Strip Trailing spaces from Clipboard
          focus_follows_mouse = mkDefault "yes";
          ## Bell;
          enable_audio_bell = mkDefault "no";
          visual_bell_duration = mkDefault "0.2";
          bell_on_tab = mkDefault "'🔔 '";
          # Tab;
          tab_activity_symbol = mkDefault "'⚡ '";
          tab_bar_style = mkDefault "powerline";
          tab_powerline_style = mkDefault "round";
          tab_bar_min_tabs = mkDefault 1;
          #tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}{tab.active_wd}";
          # Tab-bar colors;
          #active_tab_foreground = "#000";
          #active_tab_background = "#eee";
          active_tab_font_style = mkDefault "bold-italic";
          #inactive_tab_foreground = "#444";
          #inactive_tab_background = "#999";
          #foreground = "#${config.colorScheme.palette.base05}";
          #background = "#${config.colorScheme.palette.base00}";
          #selection_background = "#${config.colorScheme.palette.base05}";
          #selection_foreground = "#${config.colorScheme.palette.base00}";
          #url_color = "#${config.colorScheme.palette.base04}";
          #cursor = "#${config.colorScheme.palette.base05}";
          #active_border_color = "#${config.colorScheme.palette.base03}";
          #inactive_border_color = "#${config.colorScheme.palette.base01}";
          #active_tab_background = "#${config.colorScheme.palette.base00}";
          #active_tab_foreground = "#${config.colorScheme.palette.base05}";
          #inactive_tab_background = "#${config.colorScheme.palette.base01}";
          #inactive_tab_foreground = "#${config.colorScheme.palette.base04}";
          #tab_bar_background = "#${config.colorScheme.palette.base01}";
          #color0 = "#${config.colorScheme.palette.base00}";
          #color1 = "#${config.colorScheme.palette.base08}";
          #color2 = "#${config.colorScheme.palette.base0B}";
          #color3 = "#${config.colorScheme.palette.base0A}";
          #color4 = "#${config.colorScheme.palette.base0D}";
          #color5 = "#${config.colorScheme.palette.base0E}";
          #color6 = "#${config.colorScheme.palette.base0C}";
          #color7 = "#${config.colorScheme.palette.base05}";
          #color8 = "#${config.colorScheme.palette.base03}";
          #color9 = "#${config.colorScheme.palette.base08}";
          #color10 = "#${config.colorScheme.palette.base0B}";
          #color11 = "#${config.colorScheme.palette.base0A}";
          #color12 = "#${config.colorScheme.palette.base0D}";
          #color13 = "#${config.colorScheme.palette.base0E}";
          #color14 = "#${config.colorScheme.palette.base0C}";
          #color15 = "#${config.colorScheme.palette.base07}";
          #color16 = "#${config.colorScheme.palette.base09}";
          #color17 = "#${config.colorScheme.palette.base0F}";
          #color18 = "#${config.colorScheme.palette.base01}";
          #color19 = "#${config.colorScheme.palette.base02}";
          #color20 = "#${config.colorScheme.palette.base04}";
          #color21 = "#${config.colorScheme.palette.base06}";
          inactive_tab_font_style = mkDefault "normal";
          confirm_os_window_close = mkDefault 0;
          update_check_interval = mkDefault 0 ; # Disable Updates checking
          # Performance
          repaint_delay = mkDefault 9;
          input_delay = mkDefault 2;
          select_by_word_characters = mkDefault ":@-./_~?&=%+#" ; # Characters considered a word when double clicking
        };
        shellIntegration = {
          enableBashIntegration = mkDefault true;
          enableZshIntegration = mkDefault true;
        };
      };

      bash = {
        initExtra = shellInit;
      };
      zsh = {
        initContent = mkOrder 5000 shellInit;
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "hyprland") {
      settings = {
        bind = [
          #"SUPER, Return, exec, ${config.host.home.feature.uwsm.prefix}${pkgs.kitty}/bin/kitty"
        ];
      };
    };
  });
}
