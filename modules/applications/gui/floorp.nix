{ config, lib, pkgs, specialArgs, ... }:

let
  inherit (specialArgs) username;
  cfg = config.host.home.applications.floorp;
in with lib; {
  options = {
    host.home.applications.floorp = {
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
      defaultSettings = {
        enable = mkOption {
          description = "Apply default 'shared' settings for downstream profiles";
          type = with types; bool;
          default = false;
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [
        pkgs.nur.repos.rycee.mozilla-addons-to-nix
      ];
    };

    programs.floorp = {
      enable = true;
      package = pkgs.unstable.floorp-bin;
      profiles = {
        default = mkIf cfg.defaultSettings.enable {
          name = mkDefault username;
          isDefault = mkDefault true;

          search = {
            force = mkDefault true;
            default = mkDefault "ddg";

            engines = {
              "bing".metaData.hidden = mkDefault true;
              "google".metaData.alias = mkDefault "@g";
              "wikipedia".metaData.hidden = mkDefault true;
              "ebay".metaData.hidden = mkDefault true;

              "youtube" = {
                definedAliases = ["@youtube" "@yt"];
                icon = "https://www.youtube.com/s/desktop/8b6c1f4c/img/favicon_144x144.png";
                urls = [
                  {
                    template = "https://www.youtube.com/results";
                    params = [
                      {
                        name = "search_query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
              };
            };
          };

          extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            undoclosetabbutton
          ];

          settings = {
          };

          extraConfig = ''
          '';

          userChrome = ''
          '';

          userContent = "\n";
        };
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
           ### Make Floorp PiP window floating and sticky
           "float on, pin on, match:title ^(Picture-in-Picture)$"

           ### Throw sharing indicators away
           "workspace special silent, match:title ^(Floorp — Sharing Indicator)$"
           "workspace special silent, match:title ^(.*is sharing (your screen|a window).)$"
           "float on, size 720 312, match:class ^(firefox)$, match:title ^Extension: (Bitwarden Password Manager) - — Floorp$"
         ];
      };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "floorp.desktop")
    );
  };
}
