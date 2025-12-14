{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.chromium;
in
  with lib;
{
  options = {
    host.home.applications.chromium = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Web Browser";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [
            "application/x-extension-htm"
            "application/x-extension-html"
            "application/x-extension-shtml"
            "application/x-extension-xht"
            "application/x-extension-xhtml"
            "application/xhtml+xml"
            "text/html"
            "x-scheme-handler/about"
            "x-scheme-handler/chrome"
            "x-scheme-handler/http"
            "x-scheme-handler/https"
            "x-scheme-handler/unknown"
          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          chromium
        ];
    };
    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
          # Chrome PWA Zoom
          "workspace 3,initialClass:(^chrome-fdbibeljcgcjkpedilpdafnjdmbjjjep-zoom$)"
          "size 1200 1155,initialClass:(^chrome-fdbibeljcgcjkpedilpdafnjdmbjjjep-zoom$)"
          "float,initialClass:chrome-fdbibeljcgcjkpedilpdafnjdmbjjjep-zoom"
          #"pin,initialClass:chrome-fdbibeljcgcjkpedilpdafnjdmbjjjep-zoom"
        ];
      };
    };
    xdg  = {
      desktopEntries = {
        chromium-browser = {
          name = "chromium";
          noDisplay = mkDefault true;
        };
      };
    };
  };
}
