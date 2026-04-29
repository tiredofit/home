{ config, inputs, lib, pkgs, ... }:
let
  shell = config.host.home.feature.gui.shell;
  windowManager = config.host.home.feature.gui.windowManager;
  displayServer = config.host.home.feature.gui.displayServer;
  dmsActive = config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "dms" shell;
  niriActive = builtins.elem "niri" windowManager;
  hyprlandActive = builtins.elem "hyprland" windowManager;
in
with lib;
{
  # DMS has its own niri integration module for config includes.
  # Imported unconditionally; it guards activation with mkIf internally.
  imports = [ inputs.dms.homeModules.niri ];

  # DankMaterialShell — a Quickshell/Go-based Wayland desktop shell that
  # replaces waybar, mako, fuzzel, hyprlock, hypridle, polkit, and OSD.
  # Works with niri, hyprland, sway, and other Wayland compositors.
  # The flake module (inputs.dms.homeModules.dank-material-shell) is imported
  # globally via flake.nix; this module gates enabling it and suppresses
  # services that would conflict.
  config = mkIf dmsActive {
    programs.dank-material-shell = {
      enable = true;
      systemd.enable = mkDefault true;
      enableDynamicTheming = mkDefault true;
      enableSystemMonitoring = mkDefault true;
      enableVPN = mkDefault false;
      enableAudioWavelength = mkDefault true;
      enableCalendarEvents = mkDefault false;

      # Niri-specific: let DMS manage niri config via includes
      niri = mkIf niriActive {
        enableKeybinds = mkDefault true;
        enableSpawn = mkDefault true;
      };
    };

    # Suppress services that DMS replaces so they don't double-start.
    # These are all set with mkDefault in the hyprland/niri modules so
    # mkForce is only needed for hyprlock which is set with a plain `= true`.
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
      # hyprpaper: keep enabled — DMS dynamic theming calls matugen which sets
      # wallpaper itself, but hyprpaper can coexist. Set to false if you want
      # DMS to fully own wallpaper:
      # hyprpaper = { enable = false; service.enable = false; };
    };
  };
}

