{config, lib, pkgs, ...}:

let
  displayServer = config.host.home.feature.gui.displayServer ;
  cfg = config.host.home.feature.gui ;
in
with lib;
{
  imports = import ../../lib/import-dir.nix { inherit lib; } ./. { };

  options = {
    host.home.feature.gui = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable Graphical User Interface";
      };

      displayServer = mkOption {
        type = types.enum ["x" "wayland" null];
        default = null;
        description = "Type of displayServer";
      };

      windowManager = mkOption {
        type = types.listOf (types.enum ["cinnamon" "cosmic" "hyprland" "niri" ]);
        default = [];
        description = "List of window managers / desktop environments to enable";
      };

      isHyprland = mkOption {
        readOnly = true;
        default = config.host.home.feature.gui.enable
          && config.host.home.feature.gui.displayServer == "wayland"
          && builtins.elem "hyprland" config.host.home.feature.gui.windowManager;
        type = types.bool;
        description = "Whether Hyprland is the active window manager";
      };

      shell = mkOption {
        type = types.listOf (types.enum ["dms"]);
        default = [];
        description = "List of desktop shells to layer on top of the window manager";
      };

      isDms = mkOption {
        readOnly = true;
        default = config.host.home.feature.gui.enable
          && config.host.home.feature.gui.displayServer == "wayland"
          && builtins.elem "dms" config.host.home.feature.gui.shell;
        type = types.bool;
        description = "Whether DMS is the active desktop shell";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          polkit        # Allows unprivileged processes to speak to privileged processes
          #polkit_gnome  # Used to bring up authentication dialogs
          xdg-utils     # Desktop integration
        ];
    };

    services = {
      gnome-keyring = {
        enable = true;
        components = [
          "pkcs11"
          "secrets"
          "ssh"
        ];
      };
    };
  };
}
