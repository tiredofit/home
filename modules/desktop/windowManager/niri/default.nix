{ config, inputs, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer;
  windowManager = config.host.home.feature.gui.windowManager;
in
with lib;
{
  imports = [
    inputs.niri.homeModules.niri
  ];
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "niri" windowManager) {
    host = {
      home = {
        applications = {
          cliphist = {
            enable = mkDefault true;
            service.enable = mkDefault true;
          };
          grim.enable = mkDefault true;
          nwg-displays.enable = mkDefault true;
          slurp.enable = mkDefault true;
          wl-clipboard.enable = mkDefault true;
          wlogout.enable = mkDefault true;
        };
      };
    };
    programs.niri = {
      enable = true;
      package = mkDefault pkgs.niri;
      settings = {
        environment = {
          NIXOS_OZONE_WL = "1";
          ELECTRON_OZONE_PLATFORM_HINT = "auto";
          MOZ_ENABLE_WAYLAND = "1";
          QT_AUTO_SCREEN_SCALE_FACTOR = "1";
          QT_QPA_PLATFORM = "wayland;xcb";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          GDK_BACKEND = "wayland,x11";
          SDL_VIDEODRIVER = "wayland";
          CLUTTER_BACKEND = "wayland";
        };

        screenshot-path = mkDefault "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
      };
    };
    xdg = {
      portal = {
        enable = mkForce true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        configPackages = with pkgs; [
          xdg-desktop-portal-gnome
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = mkDefault true;
        config = {
          niri.default = [
            "gnome"
            "gtk"
          ];
          common = {
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
          };
        };
      };
    };
  };
}

