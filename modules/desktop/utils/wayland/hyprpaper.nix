{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprpaper;
in
  with lib;
{
  options = {
    host.home.applications.hyprpaper = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Wallpaper Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        ".config/hypr/background".source = ../../../../dotfiles/hypr/background;
      };

      packages = with pkgs;
        [
          hyprpaper
        ];
    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "hyprpaper"
        ];
      };
    };

    ## TODO This should be dynamic based on amount of monitors
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload = ~/.config/hypr/background/left.jpg
      preload = ~/.config/hypr/background/middle.jpg
      preload = ~/.config/hypr/background/right.jpg

      wallpaper = HDMI-A-1,~/.config/hypr/background/right.jpg
      wallpaper = DP-2,~/.config/hypr/background/middle.jpg
      wallpaper = DP-3,~/.config/hypr/background/left.jpg
      splash = false
    '';
  };
}
