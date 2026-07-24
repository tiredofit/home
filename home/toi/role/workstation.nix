{ config, lib, pkgs, ... }:
with lib;
{
  imports = [
  ];

  home.preferXdgDirectories = true;
  host = {
    home = {
      applications = {
      };
      feature = {
      };
      service = {
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = mkDefault true;
    };
  };

  wayland.windowManager.hyprland = {
    package = null;
    portalPackage = null;
  };
}
