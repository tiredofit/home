{ config, lib, pkgs, ... }:

let
  cfg = config.host.home.applications.hyprcursor;
in
  with lib; {
  options = {
    host.home.applications.hyprcursor = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Hyprcursor is a new cursor theme format that has many advantages over the widely used xcursor.";
      };
      cursor = {
        name = mkOption {
          type = types.str;
          default = "HyprBibataModernClassicSVG";
          description = "Cursor theme name.";
        };
        package = mkOption {
          type = types.package;
          default = pkgs.pkg-bibata-hyprcursor;
          description = "Cursor package.";
        };
        size = mkOption {
          type = types.int;
          default = 24;
          description = "Cursor size.";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      file = {
        ".icons/${cfg.cursor.name}".source = "${cfg.cursor.package}/share/icons/${cfg.cursor.name}";
      };

      packages = with pkgs; [
        hyprcursor
      ];

      pointerCursor = {
        package = mkDefault cfg.cursor.package;
        name = mkDefault cfg.cursor.name;
        size = mkDefault cfg.cursor.size;
        hyprcursor = {
          enable = mkDefault true;
        };
        gtk.enable = mkDefault true;
      };
    };

    xdg = {
      configFile = {
      };
      dataFile = {
        "icons/${cfg.cursor.name}".source = "${cfg.cursor.package}/share/icons/${cfg.cursor.name}";
      };
    };

    wayland.windowManager.hyprland = {
      settings = {
        exec-once = [
          "${config.host.home.feature.uwsm.prefix}hyprctl setcursor ${cfg.cursor.name} ${toString cfg.cursor.size}"
        ];
      };
    };
  };
}
