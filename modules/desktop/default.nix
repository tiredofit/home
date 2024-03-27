{config, lib, pkgs, ...}:

let
  displayServer = config.host.home.feature.gui.displayServer.server ;
  cfg = config.host.home.feature.gui ;
in
with lib;
{
  imports = [
    ./displayServer
    ./windowManager
    ./utils
  ];

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
        type = types.enum ["cinnamon" "hyprland" "i3" "sway" ];
        default = null;
        description = "Type of window manager (yes, I know some are desktop environments)";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          polkit        # Allows unprivileged processes to speak to privileged processes
          polkit_gnome  # Used to bring up authentication dialogs
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
