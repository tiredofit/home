{config, lib, nix-colours, pkgs, ...}:
## PERSONALIZE
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
            clone_arg="$@"
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
            edit_arg="$@"
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
          # Tokyo Night Night
          background = mkDefault "#1a1b26";
          foreground = mkDefault "#c0caf5";
          selection_background = mkDefault "#283457";
          selection_foreground = mkDefault "#c0caf5";
          url_color = mkDefault "#73daca";
          cursor = mkDefault "#c0caf5";
          cursor_text_color = mkDefault "#1a1b26";
          active_tab_background = mkDefault "#7aa2f7";
          active_tab_foreground = mkDefault "#16161e";
          inactive_tab_background = mkDefault "#292e42";
          inactive_tab_foreground = mkDefault "#545c7e";
          active_border_color = mkDefault "#7aa2f7";
          inactive_border_color = mkDefault "#292e42";
          color0 = mkDefault "#15161e";
          color1 = mkDefault "#f7768e";
          color2 = mkDefault "#9ece6a";
          color3 = mkDefault "#e0af68";
          color4 = mkDefault "#7aa2f7";
          color5 = mkDefault "#bb9af7";
          color6 = mkDefault "#7dcfff";
          color7 = mkDefault "#a9b1d6";
          color8 = mkDefault "#414868";
          color9 = mkDefault "#ff899d";
          color10 = mkDefault "#9fe044";
          color11 = mkDefault "#faba4a";
          color12 = mkDefault "#8db0ff";
          color13 = mkDefault "#c7a9ff";
          color14 = mkDefault "#a4daff";
          color15 = mkDefault "#c0caf5";
          color16 = mkDefault "#ff9e64";
          color17 = mkDefault "#db4b4b";
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
          active_tab_font_style = mkDefault "bold-italic";
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

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.isHyprland) {
      settings = {
        bind = [
          {_args = ["SUPER + SHIFT + Return" (lib.generators.mkLuaInline ''hl.dsp.exec_cmd("kitty")'')];}
        ];
      };
    };
  });
}
