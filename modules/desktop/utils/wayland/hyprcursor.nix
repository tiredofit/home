{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hyprcursor;
cursor = "HyprBibataModernClassicSVG";
  cursorPackage = pkgs.pkg-bibata-hyprcursor;
  cursorSize = 24;
in
  with lib;
{
  options = {
    host.home.applications.hyprcursor = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "hyprcursor is a new cursor theme format that has many advantages over the widely used xcursor.";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hyprcursor
        ];

      pointerCursor = {
        #package = pkgs.bibata-cursors;
        #name = "Bibata-Modern-Classic";
        size = cursorSize;
        gtk.enable = true;
        #x11.enable = true;
      };
    };

    home.file.".icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";
    xdg.dataFile."icons/${cursor}".source = "${cursorPackage}/share/icons/${cursor}";

    wayland.windowManager.hyprland = {
      settings = {
        env = [
          "HYPRCURSOR_THEME,${cursor}"
          "HYPRCURSOR_SIZE,${toString cursorSize}"
        ];

        exec-once = [
          "${config.host.home.feature.uwsm.prefix}hyprctl setcursor ${cursor} ${toString cursorSize}"
        ];

      };
    };
  };
}
