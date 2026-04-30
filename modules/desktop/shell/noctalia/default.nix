{ config, inputs, lib, pkgs, ... }:
let
  shell = config.host.home.feature.gui.shell;
  windowManager = config.host.home.feature.gui.windowManager;
  displayServer = config.host.home.feature.gui.displayServer;
  noctaliaActive = config.host.home.feature.gui.enable && displayServer == "wayland" && builtins.elem "noctalia" shell;
  niriActive = builtins.elem "niri" windowManager;
  hyprlandActive = builtins.elem "hyprland" windowManager;
in
with lib;
{
  imports = [
    inputs.noctalia-shell.homeModules.default
  ];

  config = mkIf noctaliaActive {
    programs.noctalia-shell = {
      enable = true;
    };

    # Guard the Noctalia service: don't start under COSMIC desktop.
    systemd.user.services.noctalia-shell = {
      Service.ExecCondition = mkDefault "${pkgs.writeShellScript "noctalia-check-desktop" ''
        case "$XDG_CURRENT_DESKTOP" in
          COSMIC) exit 1;;
          *) exit 0;;
        esac
      ''}";
    };
  };
}
