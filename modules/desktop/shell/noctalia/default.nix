{ config, lib, pkgs, ... }:
let
  shell = config.host.home.feature.gui.shell;
  windowManager = config.host.home.feature.gui.windowManager;
  displayServer = config.host.home.feature.gui.displayServer;
  noctaliaActive = config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "noctalia" shell;
  hyprlandActive = builtins.elem "hyprland" windowManager;
in
with lib;
{
  # Noctalia Shell — a Quickshell/QML-based Wayland desktop shell with a
  # lavender aesthetic, wallpaper management, lock screen, notifications,
  # OSD, dock, and widgets. Supports niri, hyprland, sway, and others.
  # The flake module (inputs.noctalia-shell.homeModules.default) is imported
  # globally via flake.nix; this module gates enabling it and suppresses
  # services that would conflict with the compositors.
  config = mkIf noctaliaActive {
    programs.noctalia-shell = {
      enable = true;
      # package defaults to the flake's own package via mkDefault in homeModules.default
    };

    # Suppress services that Noctalia replaces so they don't double-start.
    # These are the same services DMS also replaces.
    host.home.applications = mkIf hyprlandActive {
      waybar = {
        enable = false;
        service.enable = false;
      };
      sway-notification-center = {
        enable = false;
        service.enable = false;
      };
      swayosd = {
        enable = false;
        service.enable = false;
      };
      hypridle = {
        enable = false;
        service.enable = false;
      };
      hyprlock.enable = mkForce false;   # set with plain `true`, needs mkForce
      hyprpolkitagent.enable = false;
      rofi.enable = false;
    };
  };
}
