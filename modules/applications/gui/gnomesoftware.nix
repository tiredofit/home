{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.gnome-software;
in
  with lib;
{
  options = {
    host.home.applications.gnome-software = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Gnome Software Manager (Flatpak Gui)";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
            gnome.gnome-software
        ];
    };

    programs = {
      bash = {
        bashrcExtra = ''
          export XDG_DATA_DIRS=$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share
        '';
      };
    };
  };
}