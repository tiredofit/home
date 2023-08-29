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
  ];

  options = {
    host.home.feature.gui = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Enable Graphical User Interface";
      };

      displayServer = = mkOption {
        type = types.enum ["x" "wayland"];
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
    ## TODO These should be seperated at some point to modules and loaded all as common to desktop environment
    home = {
      packages = with pkgs;
        [
          gnome.zenity
          pavucontrol      # Pulse Audio Volume Control
          polkit
          polkit_gnome
          xdg-utils
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