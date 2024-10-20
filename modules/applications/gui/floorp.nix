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
    };
  };

  config = mkIf cfg.enable {
    programs.floorp = {
      enable = true;
      profiles = {
        dave = mkIf (username == "dave" || username == "media") {
          name = username;
          #id = 777;
          isDefault = true;

          search = {
            force = true;
            default = "DuckDuckGo";
            engines = {
              "Home Manager Options" = {
                urls = [{
                  template =
                    "https://mipmip.github.io/home-manager-option-search/";
                  params = [{
                    name = "query";
                    value = "{searchTerms}";
                  }];
                }];
                icon =
                  "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@hmo" ];
              };

              "Wikipedia (en)".metaData.alias = "@wiki";
              "Google".metaData.hidden = true;
            };
          };

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            clearurls
            copy-selected-links
            copy-selection-as-markdown
            #decentraleyes
            enhanced-github
            facebook-container
            floccus
            hover-zoom-plus
            multi-account-containers
            image-search-options
            #localcdn
            reddit-enhancement-suite
            sidebery
            ublock-origin
            undoclosetabbutton
            user-agent-string-switcher

            ### Missing:
            ## Canadian English Dictionary dictionary 3.1.3 true en-CA@dictionaries.addons.mozilla.org
            ## Download Manager (S3) extension 5.12 true s3download@statusbar
            ## F.B Purity - Cleans up Facebook extension 36.8.0.0 true fbpElectroWebExt@fbpurity.com
            ## Hard Refresh Button extension 1.0.0 true {b6da57d3-9727-4bc0-b974-d13e7c004af0}
            ## Open With extension 7.2.6 true openggwith@darktrojan.net
            ## PasswordMaker X extension 0.2.2 true passwordmaker@emersion.fr
            ## Rakuten Canada Button extension 7.8.1 true ebatesca@ebates.com
            ## StockTrack.ca plugin extension 0.2.4 true {50b98f8c-707d-4dd8-86e4-7c0e15745027}
            ## The Camelizer extension 3.0.15 true izer@camelcamelcamel.com
            ## Language: English (CA) locale 114.0.20230608.214645 false langpack-en-CA@firefox.mozilla.org

            # firefox-addons.json | mozilla-addons-to-nix firefox-addons.json output.json
            #[
            #  { "slug": "en-CA@dictionaries.addons.mozilla.org" },
            #  { "slug": "{b6da57d3-9727-4bc0-b974-d13e7c004af0}",
            #    "pname": "Hard Refresh Button"
            #  },
            #  { "slug": "openwith@darktrojan.net" },
            #  { "slug": "passwordmaker@emersion.fr" },
            #  { "slug": "ebatesca@ebates.com" },
            #  { "slug": "{50b98f8c-707d-4dd8-86e4-7c0e15745027}",
            #    "pname": "StockTrack.ca"
            #  },
            #  { "slug": "izer@camelcamelcamel.com" },
            #  { "slug": "langpack-en-CA@firefox.mozilla.org" },
            #  { "slug": "s3download@statusbar" }
            #]
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

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "floorp.desktop")
    );
  };
}
