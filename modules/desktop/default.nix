{config, lib, pkgs, ...}:

let
  displayServer = config.host.home.feature.gui.displayServer.server ;
  cfg = config.host.home.feature.gui ;

  dir = ./.;
  files = builtins.readDir dir;
  ignoreList = [
  ];
  importable = lib.filterAttrs (name: type:
    (type == "regular" && lib.hasSuffix ".nix" name && name != "default.nix" && !(lib.elem name ignoreList))
    || (
      type == "directory"
      && name != "default.nix"
      && !(lib.elem name ignoreList)
      && builtins.pathExists (dir + "/${name}/default.nix")
    )
  ) files;
  imports = lib.mapAttrsToList (name: type:
    if type == "regular"
    then ./${name}
    else ./${name}/default.nix
  ) importable;
in
with lib;
{
  imports = imports;

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
        type = types.enum ["cinnamon" "hyprland" "sway" ];
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
