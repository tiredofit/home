{config, lib, nix-colours, pkgs, ...}:

let
  cfg = config.host.home.applications.kitty;
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

  config = mkIf cfg.enable {
    programs = {
      kitty = {
        enable = true;
        package = pkgs.unstable.kitty;
        font = {
          name = "Hack";
          size = 11.0;
        };
        keybindings = {
          "ctrl+shift+c" = "copy_and_clear_or_interrupt";
          "ctrl+alt+enter" = "launch --location=neighbour";
          "f1" = "launch --cwd=current --type=tab";
          "f2" = "launch --cwd=current";
        };
        settings = {
          # Font
          bold_font = "auto";
          italic_font = "auto";
          bold_italic_font = "auto";
          ## Cursor
          cursor_shape = "block";
          cursor_blink_interval = -1 ;
          ## Scrollback
          scrollback_lines = 10000;
          # Auto Select from Mouse Clipboard;
          copy_on_select = "yes";
          strip_trailing_spaces = "smart"; # Strip Trailing spaces from Clipboard
          focus_follows_mouse = "yes";
          ## Bell;
          enable_audio_bell = "no";
          visual_bell_duration = "0.2";
          bell_on_tab  = "'🔔 '";
          # Tab;
          tab_activity_symbol = "'⚡ '";
          tab_bar_style = "powerline";
          tab_powerline_style = "round";
          tab_bar_min_tabs = 1;
          #tab_title_template "{fmt.fg.red}{bell_symbol}{activity_symbol}{fmt.fg.tab}{title}{tab.active_wd}";
          # Tab-bar colors;
          #active_tab_foreground = "#000";
          #active_tab_background = "#eee";
          active_tab_font_style = "bold-italic";
          #inactive_tab_foreground = "#444";
          #inactive_tab_background = "#999";
          foreground = "#${config.colorscheme.colors.base05}";
          background = "#${config.colorscheme.colors.base00}";
          selection_background = "#${config.colorscheme.colors.base05}";
          selection_foreground = "#${config.colorscheme.colors.base00}";
          url_color = "#${config.colorscheme.colors.base04}";
          cursor = "#${config.colorscheme.colors.base05}";
          active_border_color = "#${config.colorscheme.colors.base03}";
          inactive_border_color = "#${config.colorscheme.colors.base01}";
          active_tab_background = "#${config.colorscheme.colors.base00}";
          active_tab_foreground = "#${config.colorscheme.colors.base05}";
          inactive_tab_background = "#${config.colorscheme.colors.base01}";
          inactive_tab_foreground = "#${config.colorscheme.colors.base04}";
          tab_bar_background = "#${config.colorscheme.colors.base01}";
          color0 = "#${config.colorscheme.colors.base00}";
          color1 = "#${config.colorscheme.colors.base08}";
          color2 = "#${config.colorscheme.colors.base0B}";
          color3 = "#${config.colorscheme.colors.base0A}";
          color4 = "#${config.colorscheme.colors.base0D}";
          color5 = "#${config.colorscheme.colors.base0E}";
          color6 = "#${config.colorscheme.colors.base0C}";
          color7 = "#${config.colorscheme.colors.base05}";
          color8 = "#${config.colorscheme.colors.base03}";
          color9 = "#${config.colorscheme.colors.base08}";
          color10 = "#${config.colorscheme.colors.base0B}";
          color11 = "#${config.colorscheme.colors.base0A}";
          color12 = "#${config.colorscheme.colors.base0D}";
          color13 = "#${config.colorscheme.colors.base0E}";
          color14 = "#${config.colorscheme.colors.base0C}";
          color15 = "#${config.colorscheme.colors.base07}";
          color16 = "#${config.colorscheme.colors.base09}";
          color17 = "#${config.colorscheme.colors.base0F}";
          color18 = "#${config.colorscheme.colors.base01}";
          color19 = "#${config.colorscheme.colors.base02}";
          color20 = "#${config.colorscheme.colors.base04}";
          color21 = "#${config.colorscheme.colors.base06}";
          inactive_tab_font_style = "normal";
          confirm_os_window_close = 0;
          update_check_interval = 0 ; # Disable Updates checking
          # Performance
          repaint_delay = 9;
          input_delay = 2;
          select_by_word_characters = ":@-./_~?&=%+#" ; # Characters considered a word when double clicking
        };
        shellIntegration.enableBashIntegration = true;
        #theme = " ";
      };

      bash = {
        initExtra = ''
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
      };
    };
  };
}
