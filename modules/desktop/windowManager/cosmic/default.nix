{ config, lib, pkgs, ... }:
let
  windowManager = config.host.home.feature.gui.windowManager;
in
with lib;
{
  # Cosmic desktop is installed and managed at the NixOS system level.
  # This module gates home-manager services and applications that are
  # specific to (or redundant under) the Cosmic desktop environment.
  config = mkIf (config.host.home.feature.gui.enable && builtins.elem "cosmic" windowManager) {
    # Ensure gnome-keyring is running — Cosmic relies on it for secrets
    services.gnome-keyring = {
      enable = mkDefault true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };

    # XDG portal — cosmic provides xdg-desktop-portal-cosmic at the system level,
    # but we declare gtk as a fallback here for home-manager portals config.
    xdg = {
      portal = {
        enable = mkForce true;
        extraPortals = with pkgs; [
          xdg-desktop-portal-gtk
        ];
        xdgOpenUsePortal = mkDefault true;
        config = {
          common = {
            "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
            default = [ "cosmic" "gtk" ];
          };
        };
      };
    };
  };
}
