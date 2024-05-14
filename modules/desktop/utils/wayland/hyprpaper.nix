{ config, inputs, lib, pkgs, specialArgs, ... }:
let
  inherit (specialArgs) displays display_center display_left display_right role;
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
    };

    services = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      hyprpaper = {
        enable = true;
        settings = {
          splash = false;

          preload = mkMerge [
            (mkIf (displays >= 1) (mkAfter [
              "~/.config/hypr/background/middle.jpg"
            ]))

            (mkIf (displays >= 2) (mkAfter [
              "~/.config/hypr/background/right.jpg"
            ]))

            (mkIf (displays >= 3) (mkAfter [
              "~/.config/hypr/background/left.jpg"
            ]))
          ];

          wallpaper = mkMerge [
            (mkIf (displays >= 1) (mkAfter [
              "${display_center},~/.config/hypr/background/middle.jpg"
            ]))

            (mkIf (displays >= 2) (mkAfter [
              "${display_right},~/.config/hypr/background/right.jpg"
            ]))

            (mkIf (displays >= 3) (mkAfter [
              "${display_left},~/.config/hypr/background/left.jpg"
            ]))
          ];
        };
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        exec-once = [
          "hyprpaper"
        ];
      };
    };
  };
}
