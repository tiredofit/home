{ config, lib, pkgs, ... }:
let
  displayServer = config.host.home.feature.gui.displayServer;
  windowManager = config.host.home.feature.gui.windowManager;
in
with lib; {
  config = mkIf (config.host.home.feature.gui.enable && displayServer == "wayland" && windowManager == "sway") {
    host = {
      home = {
        applications = {
        };
      };
    };
    wayland.windowManager.sway = {
      enable = true;
    };
    xsession = {
      enable = true;
      scriptPath = ".hm-xsession";
      windowManager.command = ''
        export MOZ_ENABLE_WAYLAND=1
        export NIXOS_OZONE_WL=1
        export XDG_SESSION_TYPE=wayland
        export XDG_SESSION_DESKTOP=sway
        export XDG_CURRENT_DESKTOP=sway
        export CLUTTER_BACKEND=wayland
        export QT_QPA_PLATFORM=wayland-egl
        export ECORE_EVAS_ENGINE=wayland-egl
        export ELM_ENGINE=wayland_egl
        export SDL_VIDEODRIVER=wayland
        export _JAVA_AWT_WM_NONREPARENTING=1
        export NO_AT_BRIDGE=1
        sway
      '';
    };
  };
}
