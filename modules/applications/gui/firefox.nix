{ config, lib, pkgs, specialArgs, ... }:

let
  inherit (specialArgs) username;
  cfg = config.host.home.applications.firefox;
in with lib; {
  options = {
    host.home.applications.firefox = {
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
      packages = with pkgs; [
        pkgs.nur.repos.rycee.mozilla-addons-to-nix
      ];
    };

    programs.firefox = {
      enable = true;
      package = if pkgs.stdenv.isLinux then pkgs.firefox else pkgs.firefox-bin;
      nativeMessagingHosts = with pkgs; mkIf (username == "dave") [
        pkgs.firefoxpwa
      ];
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

              "NixOS Options" = {
                urls = [{
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "type";
                      value = "options";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }];
                icon =
                  "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@no" ];
              };

              "Nix Packages" = {
                urls = [{
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }];
                icon =
                  "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };

              "NixOS Wiki" = {
                urls = [{
                  template =
                    "https://nixos.wiki/index.php?search={searchTerms}";
                }];
                iconUpdateURL = "https://nixos.wiki/favicon.png";
                updateInterval = 24 * 60 * 60 * 1000;
                definedAliases = [ "@nw" ];
              };

              "Wikipedia (en)".metaData.alias = "@wiki";
              "Google".metaData.hidden = true;
            };
          };

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            #bypass-paywalls-clean
            clearurls
            copy-selected-links
            copy-selection-as-markdown
            decentraleyes
            enhanced-github
            #enhancer-for-youtube
            facebook-container
            floccus
            hover-zoom-plus
            multi-account-containers
            image-search-options
            localcdn
            reddit-enhancement-suite
            sidebery
            sponsorblock
            torrent-control
            ublock-origin
            undoclosetabbutton
            user-agent-string-switcher
            video-downloadhelper

            ### Missing:
            ## Canadian English Dictionary dictionary 3.1.3 true en-CA@dictionaries.addons.mozilla.org
            ## Download Manager (S3) extension 5.12 true s3download@statusbar
            ## F.B Purity - Cleans up Facebook extension 36.8.0.0 true fbpElectroWebExt@fbpurity.com
            ## Hard Refresh Button extension 1.0.0 true {b6da57d3-9727-4bc0-b974-d13e7c004af0}
            ## Open With extension 7.2.6 true openwith@darktrojan.net
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
            # Disable Telemetry (https://support.mozilla.org/kb/share-telemetry-data-mozilla-help-improve-firefox) sends data about the performance and responsiveness of Firefox to Mozilla.
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.rejected" = true;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.unifiedIsOptIn" = false;
            "toolkit.telemetry.prompted" = 2;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.cachedClientID" = "";
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            # Disable health report - Disable sending Firefox health reports(https://www.mozilla.org/privacy/firefox/#health-report) to Mozilla.
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.service.enabled" = false;
            # Disable shield studies (https://wiki.mozilla.org/Firefox/Shield) is a feature which allows mozilla to remotely install experimental addons.
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "app.shield.optoutstudies.enabled" = false;
            "extensions.shield-recipe-client.enabled" = false;
            "extensions.shield-recipe-client.api_url" = "";
            # Disable experiments (https://wiki.mozilla.org/Telemetry/Experiments) allows automatically download and run specially-designed restartless addons based on certain conditions.
            "experiments.enabled" = false;
            "experiments.manifest.uri" = "";
            "experiments.supported" = false;
            "experiments.activeExperiment" = false;
            "network.allow-experiments" = false;
            # Disable Crash Reports (https://www.mozilla.org/privacy/firefox/#crash-reporter) as it may contain data that identifies you or is otherwise sensitive to you.
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "extensions.getAddons.cache.enabled" = false; # Opt out metadata updates about installed addons as metadata updates (https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/), so Mozilla is able to recommend you other addons.
            # Disable google safebrowsing - Detect phishing and malware but it also sends informations to google together with an unique id called wrkey (http://electroholiker.de/?p=1594).
            "browser.safebrowsing.enabled" = false;
            "browser.safebrowsing.downloads.remote.url" = "";
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.blockedURIs.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "browser.safebrowsing.appRepURL" = "";
            "browser.safebrowsing.malware.enabled" = false; # Disable malware scan -  sends an unique identifier for each downloaded file to Google.
            "network.trr.mode" = 5; # Disable DNS over HTTPS  aka. Trusted Recursive Resolver (TRR)
            "browser.newtab.preload" = false; # Disable preloading of the new tab page. By default Firefox preloads the new tab page (with website thumbnails) in the background before it is even opened.
            "extensions.getAddons.showPane" = false; # Disable about:addons' Get Add-ons panel  The start page with recommended addons uses google analytics.
            "extensions.webservice.discoverURL" = ""; # Disable about:addons' Get Add-ons panel  The start page with recommended addons uses google analytics.
            "network.captive-portal-service.enabled" = false; # Disable check for captive portal. By default, Firefox checks for the presence of a captive portal on every startup.  This involves traffic to Akamai. (https://support.mozilla.org/questions/1169302).
            "media.eme.enabled" = true; # Disables playback of DRM-controlled HTML5 content otherwise automatically downloads the Widevine Content Decryption Module provided by Google Inc.
            "media.gmp-widevinecdm.enabled" = true; # Disables the Widevine Content Decryption Module provided by Google Inc. Used for the playback of DRM-controlled HTML5 content Details (https://support.mozilla.org/en-US/kb/enable-drm#w_disable-the-google-widevine-cdm-without-uninstalling)
            "device.sensors.ambientLight.enabled" = false; # Disable access to device sensor data - Disallow websites to access sensor data (ambient light, motion, device orientation and proximity data).
            "device.sensors.enabled" = false; # Disable access to device sensor data - Disallow websites to access sensor data (ambient light, motion, device orientation and proximity data).
            "device.sensors.motion.enabled" = false; # Disable access to device sensor data - Disallow websites to access sensor data (ambient light, motion, device orientation and proximity data).
            "device.sensors.orientation.enabled" = false; # Disable access to device sensor data - Disallow websites to access sensor data (ambient light, motion, device orientation and proximity data).
            "device.sensors.proximity.enabled" = false; # Disable access to device sensor data - Disallow websites to access sensor data (ambient light, motion, device orientation and proximity data).
            "browser.urlbar.groupLabels.enabled" = false; # Disable Firefox Suggest(https://support.mozilla.org/en-US/kb/navigate-web-faster-firefox-suggest) feature allows Mozilla to provide search suggestions in the US, which uses your city location and search keywords to send suggestions. This is also used to serve advertisements.
            "browser.urlbar.quicksuggest.enabled" = false; # Disable Firefox Suggest(https://support.mozilla.org/en-US/kb/navigate-web-faster-firefox-suggest) feature allows Mozilla to provide search suggestions in the US, which uses your city location and search keywords to send suggestions. This is also used to serve advertisements.
            "pdfjs.enableScripting" = true; # Disable Javascript in PDF viewer - It is possible that some PDFs are not rendered correctly due to missing functions.

            ## Privacy
            "browser.cache.offline.enable" = false; # Disable the Offline Cache.
            "browser.fixup.alternate.enabled" = false; # Disable Fixup URLs
            "browser.search.suggest.enabled" = false; # Disable Search Suggestions
            "browser.sessionstore.privacy_level" = 2; # Sessionstore Privacy
            "browser.urlbar.speculativeConnect.enabled" = false; # Disable speculative website loading.
            "dom.event.clipboardevents.enabled" = true; # Disable the clipboardevents.
            "dom.indexedDB.enabled" = true; # Enable IndexedDB (disabling breaks things)
            "dom.storage.enabled" = true; # Disable DOM storage
            "keyword.enabled" = true; # Disable Search Keyword
            "media.peerconnection.enabled" = true; # Disable WebRTC
            "network.cookie.cookieBehavior" = 1; # Block 3rd-Party cookies or even all cookies. 0 Default 1 Originating Server 2 None 3 Third only if site already has stored
            "network.dns.disablePrefetch" = true; # Disable Link Prefetching
            "network.dns.disablePrefetchFromHTTPS" = true; # Disable Link Prefetching
            "network.http.referer.spoofSource" = false; # Block Referer - This breaks Google Docs if true
            "network.http.speculative-parallel-limit" = 0; # Disable speculative website loading.
            "network.predictor.enable-prefetch" = false; # Disable Link Prefetching
            "network.predictor.enabled" = false; # Disable Link Prefetching
            "network.prefetch-next" = false; # Disable Link Prefetching
            "privacy.usercontext.about_newtab_segregation.enabled" = true; # Use a private container for new tab page thumbnails
            "webgl.disabled" = false; # WebGL is part of some fingerprinting scripts used in the wild. Some interactive websites will not work, which are mostly games.
            "webgl.renderer-string-override" = " "; # Override graphics card vendor and model strings in the WebGL API
            "webgl.vendor-string-override" = " "; # Override graphics card vendor and model strings in the WebGL API

            ## Security
            "app.update.auto" = true; # Disable automatic updates.
            "browser.aboutConfig.showWarning" = false; # Disable about:config warning.
            "browser.disableResetPrompt" = true; # Disable reset prompt.
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false; # Disable Pocket
            "browser.newtabpage.enhanced" = false; # Content of the new tab page
            "browser.newtabpage.introShown" = false; # Disable the intro to the newtab page on the first run
            "browser.selfsupport.url" = ""; # Disable Heartbeat Userrating
            "browser.shell.checkDefaultBrowser" = false; # Disable checking if Firefox is the default browser
            "browser.startup.homepage_override.mstone" = "ignore"; # Disable the first run tabs with advertisements for the latest firefox features.
            "browser.urlbar.trimURLs" = false; # Do not trim URLs in navigation bar
            "dom.security.https_only_mode" = true; # Enable HTTPS only mode
            "dom.security.https_only_mode_ever_enabled" = true; # Enable HTTPS only mode
            "extensions.blocklist.enabled" = false; # Disable extension blocklist from mozilla.
            "extensions.pocket.enabled" = false; # Disable Pocket
            "media.autoplay.default" = 0; # Disable autoplay of video tags.
            "media.autoplay.enabled" = true; # Disable autoplay of video tags.
            "network.IDN_show_punycode" = true; # Show Punycode.
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false; # Disable Sponsored Top Sites

            ## Extra Settings
            "browser.cache.disk.enable" = false;
            "browser.compactmode.show" = true;
            "browser.download.always_ask_before_handling_new_types" = true;
            "browser.engagement.ctrlTab.has-used" = true;
            "browser.engagement.downloads-button.has-used" = true;
            "browser.engagement.fxa-toolbar-menu-button.has-used" = true;
            "browser.engagement.library-button.has-used" = true;
            "browser.formfill.enable" = false;
            "browser.tabs.closeTabByDblclick" = true;
            "browser.tabs.insertAfterCurrent" = true;
            "browser.tabs.loadBookmarksInTabs" = true;
            "browser.tabs.tabmanager.enabled" = false; # Tab
            "browser.tabs.warnOnClose" = false;
            "browser.toolbars.bookmarks.visibility" = "always";
            "browser.uitour.enabled" = false;
            "browser.urlbar.clickSelectsAll" = true;
            "browser.urlbar.suggest.quickactions" = false; # URL Suggestions
            "browser.urlbar.suggest.topsites" = false; # URL Suggestions
            "devtools.everOpened" = true;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "extensions.formautofill.heuristics.enabled" = false;
            "extensions.screenshots.disabled" = true;
            "font.internaluseonly.changed" = false; # Fonts
            "font.name.monospace.x-western" = "Droid Sans Mono"; # Fonts
            "font.name.sans-serif.x-western" = "Noto Sans"; # Fonts
            "font.name.serif.x-western" = "Noto Sans"; # Fonts
            "font.size.fixed.x-western" = "11"; # Fonts
            "font.size.variable.x-western" = "15"; # Fonts
            "general.smoothScroll" = true; # enable smooth scrolling
            "gfx.webrender.all" = true; # Force using WebRender. Improve performance
            "gfx.webrender.enabled" = true; # Force using WebRender. Improve performance
            "media.ffmpeg.vaapi.enabled" = true; # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
            "media.ffvpx.enabled" = false; # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
            "media.videocontrols.picture-in-picture.allow-multiple" = true; # Enable multi-pip
            "pref.general.disable_button.default_browser" = false;
            "pref.privacy.disable_button.cookie_exceptions" = false;
            "pref.privacy.disable_button.tracking_protection_exceptions" = false;
            "pref.privacy.disable_button.view_passwords" = false;
            "print.more-settings.open" = true;
            "privacy.clearOnShutdown.cache" = false; # Privacy
            "privacy.clearOnShutdown.cookies" = false; # Privacy
            "privacy.clearOnShutdown.downloads" = false; # Privacy
            "privacy.clearOnShutdown.formdata" = false; # Privacy
            "privacy.clearOnShutdown.history" = false; # Privacy
            "privacy.clearOnShutdown.sessions" = false; # Privacy
            "privacy.cpd.cache" = false; # Privacy
            "privacy.cpd.cookies" = false; # Privacy
            "privacy.cpd.downloads" = false; # Privacy
            "privacy.cpd.formdata" = false; # Privacy
            "privacy.cpd.history" = false; # Privacy
            "privacy.cpd.offlineApps" = true; # Privacy
            "privacy.cpd.sessions" = false; # Privacy
            "privacy.donottrackheader.enabled" = true; # Privacy
            "privacy.history.custom" = true; # Privacy
            "privacy.partition.network_state.ocsp_cache" = true; # Privacy
            "privacy.trackingprotection.enabled" = true; # Privacy
            "privacy.trackingprotection.socialtracking.enabled" = true; # Privacy
            "privacy.userContext.enabled" = true; # Privacy
            "privacy.userContext.longPressBehavior" = "2"; # Privacy
            "privacy.userContext.newTabContainerOnLeftClick.enabled" = false; # Privacy
            "privacy.userContext.ui.enabled" = true; # Privacy
            "signon.management.page.breach-alerts.enabled" = false;
            "signon.rememberSignons" = false;
            "ui.context_menus.after_mouseup" = true;
            "widget.use-xdg-desktop-portal" = true;
          };

          extraConfig = ''
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("full-screen-api.ignore-widgets", true);
            user_pref("media.ffmpeg.vaapi.enabled", true);
            user_pref("media.rdd-vpx.enabled", true);
          '';

          userChrome = ''
            /* CUSTOM: General *?
                :root {

                /* custom height for default tabs [disabled by default] */
                /*--tab-min-height: 24px !important; /**/

                /* custom height for 'photon tabs' only */
                --photon_tabs_tab_height: 28px !important;

                /* custom height for 'classic squared tabs' only */
                --classic_squared_tabs_tab_height: 26px !important;

                /* set to '0px' for fully classic squared tabs */
                --classic_squared_tabs-border-radius: 3px !important;

                /* set to '0px' for fully squared tabs */
                --default_tab_border_roundness: 5px !important;

                /* for default icon only */
                --classic_squared_tabs_tab_default_loading_icon_color: #0A84FF !important;

                /* for tab_close_icon_size.css */
                --tab_close_icons_size: 16px !important; /* 14-20px */

                /* for 'tab_maxwidth.css'
                - unlock 'min width' code inside file first for '--tab_min_width' to work */
                /* --tab-min-width: 50px !important; */
                --tab_min_width: 50px !important;
                --tab_max_width: 250px !important;

                /* for tabs_multiple_lines.css */
                --tab_min_width_mlt: 100px !important;
                --tab_max_width_mlt: 200px !important;
                --tabs-lines: 3 !important;

                /* for bookmarks_toolbar_multiple_lines.css */
                --bookmark_items_height: 22px !important; /* <- bookmark items - line height */
                --bookmark_items_lines: 3 !important; /* <- maximum amount of lines */

                /* for increase_ui_font_size.css */
                --general_ui_font_size: 10pt !important;

                /* for searchbar_popup_engines_show_labels_scrollbars.css */
                --search-one-offs_labels_height: 100px !important;

                /* for addonbar_move_bookmarks_toolbar_to_bottom.css */
                --addonbar_height: 27px !important;

                /* for ac_popup_result_font_size.css */
                --results_font_size: var(--general_ui_font_size,10pt) !important; /* 10pt */

                /* for urlbar_border_roundness.css */
                --megabar_border_roundness: 20px !important;

                /* for top_toolbar_colors.css */
                --top_toolbars_background: hsl(235,33%,19%) !important; /* #0063b1 */ /* hsl(235,33%,19%) was used by old accent color option  */
                --top_toolbars_background_inactive: hsl(235,13%,9%) !important; /* #ffffff */
                --top_toolbars_text: hsl(240,9%,98%) !important;
                --top_toolbars_text_inactive: #999999 !important;

                /* for urlbar_background_color.css */
                --urlbar_background_color: white !important;
                --urlbar_text_color: black !important;

                /* for popup_compact_menus_squared.css */
                --custom_border-radius: 0px !important;
                }

                :root[uidensity="touch"] {
                /* custom height for 'classic squared tabs' only */
                --classic_squared_tabs_tab_height: 36px !important;
                }

                /* CUSTOM: Colours */
                /* Colors inside  / *  ...   * /  are from the old  'custom_colors_for_squared_tabs.css' file.
                Example: replace 'linear-gradient(#f9f9fa,#f9f9fa)' with 'linear-gradient(to bottom,#FFCC99,#FFCC99)'

                Tab colors have to be set as gradients.
                Example: If the active tab has to be blue, the variable has to look like
                '--classic_squared_tabs_active_tab: linear-gradient(blue,blue) !important;'
                and not (!) just '--classic_squared_tabs_active_tab: blue !important;'
                */

                /* default colors */
                :root {
                --general_toolbar_color_toolbars: linear-gradient(#f9f9fa,#f9f9fa) !important; /* (to bottom,#FFCC99,#FFCC99) */
                --general_toolbar_color_navbar: linear-gradient(#f9f9fa,#f9f9fa) !important; /* (to bottom,#FFCC99,#FFCC99) */
                --general_toolbar_text_color: inherit !important;
                --general_toolbar_text_shadow: transparent !important;
                --tabs_toolbar_color_tabs_not_on_top: linear-gradient(#f9f9fa,#f9f9fa) !important;  /* (to bottom,#FFCC99,#FFCC99) */
                --tabs_toolbar_border-tnot_normal_mode_size: 1px !important;
                --tabs_toolbar_border-tnot_normal_mode: var(--tabs-border-color) !important;
                --colored_menubar_background_image: linear-gradient(#f9f9fa,#f9f9fa) !important;  /* (to bottom,#FFCC99,#FFCC99) */
                --colored_menubar_text_color: black !important;
                --statusbar_background_color: linear-gradient(#f9f9fa,#f9f9fa) !important;
                --statusbar_font_color: inherit !important;

                /* tab colors
                */
                --classic_squared_tabs_active_tab: linear-gradient(to top,#f9f9fa,#f9f9fa,#f9f9fa) !important; /* (to bottom,#FF8800,#FFCC99) */
                --classic_squared_tabs_hovered_tabs: linear-gradient(to top,#cac7c1,#d5d2cc,#e8e6e2) !important; /* (to bottom,#FF9900,#FF6600) */
                --classic_squared_tabs_other_tabs: linear-gradient(to top,#aeaba5,#c1beb7,#c9c6be) !important; /* (to bottom,#FFCC99,#CCCCCC) */
                --classic_squared_tabs_unloaded_tabs: linear-gradient(to top,#aeaba5,#c1beb7,#c9c6be) !important; /* (to bottom,#FFCC99,#CCCCCC) */
                --classic_squared_tabs-border_size: 1px;
                --classic_squared_tabs-border1: #5f7181 !important;
                --classic_squared_tabs-border2: rgba(0,0,0,.2) !important;
                --classic_squared_tabs-border3: rgba(0,0,0,.5) !important;
                --classic_squared_tabs_new_tab_icon_color: black !important;
                --classic_squared_tabs_tab_text_color: black !important;
                --classic_squared_tabs_tab_text_shadow: transparent !important;

                /* tab colors - dark text, but bright themes:
                */
                --classic_squared_tabs_lwt-dark_active_tab: inherit !important; /* linear-gradient(blue, hsla(0,0%,60%,.5) 80%) */
                --classic_squared_tabs_lwt-dark_hovered_tabs: linear-gradient(hsla(0,0%,80%,.5), hsla(0,0%,60%,.5) 80%) !important;
                --classic_squared_tabs_lwt-dark_other_tabs: linear-gradient(hsla(0,0%,60%,.5), hsla(0,0%,45%,.5) 80%) !important;

                /* tab colors - bright text, but dark themes:
                */
                --classic_squared_tabs_lwt-bright_hovered_tabs: linear-gradient(hsla(0,0%,60%,.6), hsla(0,0%,45%,.6) 80%) !important;
                --classic_squared_tabs_lwt-bright_other_tabs: linear-gradient(hsla(0,0%,40%,.6), hsla(0,0%,30%,.6) 80%) !important;
                --classic_squared_tabs_lwt-bright_active_tab: inherit !important; /* linear-gradient(blue, hsla(0,0%,60%,.5) 80%) */
                }

            /* CUSTOM: Icons Colorized */
                /******* button icon colors ******/

                /* red */
                :is(#containers-panelmenu,#web-apps-button,#e10s-button,#panic-button,#cut-button,#zoom-out-button,#stop-button,#logins-button),
                #pocket-button:not([open]),
                #PanelUI-quit:not(:hover),
                .tabs-closebutton:hover,
                .tab-close-button:hover,
                #stop-button .toolbarbutton-animatable-image,
                #stop-reload-button[animate] > #reload-button[displaystop] + #stop-button > .toolbarbutton-animatable-box > .toolbarbutton-animatable-image{
                fill: red !important;
                }
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#containers-panelmenu,#web-apps-button,#e10s-button,#panic-button,#cut-button,#zoom-out-button,#stop-button,#logins-button),
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #pocket-button:not([open]),
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #PanelUI-quit:not(:hover),
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext .tabs-closebutton:hover,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext .tab-close-button:hover,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #stop-button .toolbarbutton-animatable-image,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #stop-reload-button[animate] > #reload-button[displaystop] + #stop-button > .toolbarbutton-animatable-box > .toolbarbutton-animatable-image {
                fill: #ff5a5a !important;
                }
                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#containers-panelmenu,#web-apps-button,#e10s-button,#panic-button,#cut-button,#zoom-out-button,#stop-button,#logins-button),
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #pocket-button:not([open]),
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #PanelUI-quit:not(:hover),
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme .tabs-closebutton:hover,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme .tab-close-button:hover,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #stop-button .toolbarbutton-animatable-image,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #stop-reload-button[animate] > #reload-button[displaystop] + #stop-button > .toolbarbutton-animatable-box > .toolbarbutton-animatable-image {
                    fill: #ff5a5a !important;
                    }
                }

                /*ROYAL BLUE*/
                toolbar:not(#TabsToolbar):not(:-moz-lwtheme) :is(.scrollbutton-up,.scrollbutton-down,#new-tab-button,#alltabs-button),
                #downloads-button[indicator="true"]:not([attention="success"]) #downloads-indicator-icon,
                :is(#save-page-button,#back-button,#forward-button,#new-window-button,.search-go-button,#downloads-button,#zoom-in-button,#copy-button,#find-button,#sidebar-button,#fullscreen-button,#PanelUI-customize,#password-notification-icon,#PanelUI-fxa-status,#sync-button,#tabview-button,#social-share-button) {
                fill: #4169e1 !important;
                }
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext toolbar:not(#TabsToolbar):not(:-moz-lwtheme) :is(.scrollbutton-up,.scrollbutton-down,#new-tab-button,#alltabs-button),
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #downloads-button[indicator="true"]:not([attention="success"]) #downloads-indicator-icon,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#save-page-button,#back-button,#forward-button,#new-window-button,.search-go-button,#downloads-button,#zoom-in-button,#copy-button,#find-button,#sidebar-button,#fullscreen-button,#PanelUI-customize,#password-notification-icon,#PanelUI-fxa-status,#sync-button,#tabview-button,#social-share-button) {
                fill: #00d2ff !important;
                }
                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme toolbar:not(#TabsToolbar):not(:-moz-lwtheme) :is(.scrollbutton-up,.scrollbutton-down,#new-tab-button,#alltabs-button),
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #downloads-button[indicator="true"]:not([attention="success"]) #downloads-indicator-icon,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#save-page-button,#back-button,#forward-button,#new-window-button,.search-go-button,#downloads-button,#zoom-in-button,#copy-button,#find-button,#sidebar-button,#fullscreen-button,#PanelUI-customize,#password-notification-icon,#PanelUI-fxa-status,#sync-button,#tabview-button,#social-share-button) {
                    fill: #00d2ff !important;
                    }
                }

                /*green*/
                :is(#add-ons-button,#unified-extensions-button,#search-go-button,.search-go-button,#urlbar-go-button,.urlbar-go-button,#paste-button,#email-link-button,#reload-button,#import-button),
                #reload-button .toolbarbutton-animatable-image {
                fill: green !important;
                }
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#add-ons-button,#unified-extensions-button,#search-go-button,.search-go-button,#urlbar-go-button,.urlbar-go-button,#paste-button,#email-link-button,#reload-button,#import-button),
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #reload-button .toolbarbutton-animatable-image {
                fill: lightgreen !important;
                }
                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#add-ons-button,#unified-extensions-button,#search-go-button,.search-go-button,#urlbar-go-button,.urlbar-go-button,#paste-button,#email-link-button,#reload-button,#import-button),
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #reload-button .toolbarbutton-animatable-image {
                    fill: lightgreen !important;
                    }
                }

                /*orange*/
                :is(#open-file-button,#home-button,#feed-button){
                fill: orange !important;
                }

                /*PURPLE*/
                :is(#history-button,#history-panelmenu,#library-button,#privatebrowsing-button,#print-button,#fxa-toolbar-menu-button){
                fill: #800080 !important;
                }
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#history-button,#history-panelmenu,#library-button,#privatebrowsing-button,#print-button,#fxa-toolbar-menu-button) {
                fill: #ff00ff !important;
                }
                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#history-button,#history-panelmenu,#library-button,#privatebrowsing-button,#print-button,#fxa-toolbar-menu-button) {
                    fill: #ff00ff !important;
                    }
                }

                /*AZURE*/
                :is(#webide-button,#PanelUI-menu-button,#nav-bar-overflow-button,#bookmarks-menu-button,#bookmarks-button,#bookmarks-toolbar-placeholder,#screenshot-button),
                #bookmarks-menu-button > .toolbarbutton-menubutton-dropmarker > .dropmarker-icon {
                -moz-context-properties: fill;
                fill: #336699 !important;
                }
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#webide-button,#PanelUI-menu-button,#nav-bar-overflow-button,#bookmarks-menu-button,#bookmarks-button,#bookmarks-toolbar-placeholder,#screenshot-button),
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #bookmarks-menu-button > .toolbarbutton-menubutton-dropmarker > .dropmarker-icon {
                fill: #64a3e2 !important;
                }
                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#webide-button,#PanelUI-menu-button,#nav-bar-overflow-button,#bookmarks-menu-button,#bookmarks-button,#bookmarks-toolbar-placeholder,#screenshot-button),
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #bookmarks-menu-button > .toolbarbutton-menubutton-dropmarker > .dropmarker-icon {
                    fill: #64a3e2 !important;
                    }
                }

                /* grey*/
                :is(#developer-button,#preferences-button,#characterencoding-button) {
                fill: grey !important;
                }
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#developer-button,#preferences-button,#characterencoding-button) {
                fill: lightgrey !important;
                }
                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#developer-button,#preferences-button,#characterencoding-button) {
                    fill: lightgrey !important;
                    }
                }

            /* CUSTOM: Menu button localized label on bookmarks toolbar */
                #PersonalToolbar #bookmarks-menu-button .toolbarbutton-text {
                visibility: visible !important;
                display: flex !important;
                }

            /* CUSTOM: What's new button hidden always */
                #PanelUI-button #whats-new-menu-button {
                    display: none !important;
                }

            /* CUSTOM: App Button popup Icons */
                :root {
                --y_padding_before_label_am: 4px !important;
                }

                #appMenu-fxa-label2::before,
                #fxa-manage-account-button::before {
                content:"" !important;
                display: block !important;
                width: 16px !important;
                height: 16px !important;
                -moz-context-properties: fill;
                background-image: url("chrome://browser/skin/fxa/avatar.svg") !important; /* tab.svg */
                margin-inline-end: 4px !important;
                fill: currentColor;
                }

                #PanelUI-fxa-menu-syncnow-button::before {
                content:"" !important;
                display: block !important;
                width: 16px !important;
                height: 16px !important;
                -moz-context-properties: fill;
                background-image: url("chrome://browser/skin/sync.svg") !important;
                background-size: 16px !important;
                margin-inline-end: 4px !important;
                fill: currentColor;
                }

                #PanelUI-fxa-menu-setup-sync-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/developer.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu_helpSwitchDevice > .toolbarbutton-icon,
                #PanelUI-fxa-menu-connect-device-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/device-desktop.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-fxa-menu-sendtab-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/fxa/send.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-fxa-menu-sync-prefs-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/settings.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-fxa-menu-account-signout-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/close.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-new-tab-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/new-tab.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-new-window-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/window.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-new-private-window-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/privateBrowsing.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-bookmarks-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/bookmark.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenuSearchHistory > .toolbarbutton-icon,
                #appMenu-history-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/history.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-downloads-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/downloads/downloads.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-passwords-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/login.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-extensions-themes-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://mozapps/skin/extensions/extension.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-print-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/print.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-save-file-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/save.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-find-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/search-glass.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-translate-button  > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/translations.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                :is(#appMenu-zoom-controls,#appMenu-zoom-controls2)::before {
                content:"" !important;
                display: block !important;
                width: 16px !important;
                height: 16px !important;
                -moz-context-properties: fill;
                background-image: url("chrome://devtools/skin/images/tool-inspector.svg") !important;
                margin-inline-end: 4px !important;
                fill: currentColor;
                }

                #appMenu-settings-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/settings.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-more-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/chevron.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-help-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/help.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu-quit-button2 > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/close.svg"); /* ../../image/quit.svg */
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appmenu-moreTools-button > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/customize.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-bookmarks #panelMenuBookmarkThisPage > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/bookmark.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-bookmarks #panelMenu_searchBookmarks > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/search-glass.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-bookmarks #panelMenu_viewBookmarksToolbar > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/bookmarks-toolbar.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-history #appMenuRecentlyClosedTabs > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/tab.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-history #appMenuRecentlyClosedWindows > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/window.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-history #appMenuClearRecentHistory > .toolbarbutton-icon,
                #PanelUI-history :is(#appMenuRestoreSession,#appMenu-restoreSession) > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://browser/skin/forget.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"]:not([checked=true]) > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://global/content/aboutconfig/toggle.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_inspector"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-inspector.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_webconsole"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-webconsole.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://global/skin/icons/performance.svg"); /**/
                width: 16px !important;
                height: 16px !important;
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-debugger.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_netmonitor"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-network.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_styleeditor"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-styleeditor.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_performance"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-profiler.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_storage"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-storage.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_accessibility"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-accessibility.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_application"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-application.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_dom"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-dom.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_browserConsole"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-webconsole.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_responsiveDesignMode"] > image.toolbarbutton-icon {
                -moz-context-properties: fill, fill-opacity;
                fill-opacity: 0;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/command-responsivemode.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_viewSource"] > image.toolbarbutton-icon { /* Re-using the DOM icon since I expect everyone uses the Inspector instead */
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/tool-dom.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[data-l10n-id="appmenu-developer-tools-extensions"] > image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://mozapps/skin/extensions/extension.svg");
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"]:not([checked=true]) > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_inspector"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_webconsole"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton  > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_netmonitor"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_styleeditor"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_performance"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_storage"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_accessibility"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_application"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_dom"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_browserConsole"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_responsiveDesignMode"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_viewSource"] > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[data-l10n-id="appmenu-developer-tools-extensions"] > label.toolbarbutton-text {
                    padding-inline-start: 8px !important;
                }

                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"]:not([checked=true]) > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_inspector"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_webconsole"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_jsdebugger"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_netmonitor"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_styleeditor"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_performance"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_storage"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_accessibility"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_application"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_dom"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_browserConsole"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_responsiveDesignMode"] > image.toolbarbutton-icon,
                #main-window:-moz-lwtheme:-moz-lwtheme-brighttext #appmenu-developer-tools-view toolbarbutton[key="key_viewSource"] > image.toolbarbutton-icon {
                    fill: currentColor !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"]:not([checked=true]) > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_inspector"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_webconsole"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_jsdebugger"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_netmonitor"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_styleeditor"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_performance"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_storage"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_accessibility"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_application"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_dom"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_browserConsole"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_responsiveDesignMode"] > image.toolbarbutton-icon,
                    #main-window:-moz-lwtheme #appmenu-developer-tools-view toolbarbutton[key="key_viewSource"] > image.toolbarbutton-icon {
                        fill: currentColor !important;
                    }
                }


                /* Eye Dropper & Get More Tools */

                #appmenu-developer-tools-view toolbarbutton[key="key_responsiveDesignMode"] + toolbarbutton image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://devtools/skin/images/command-eyedropper.svg");
                }
                /*
                #appmenu-developer-tools-view toolbarbutton[key="key_viewSource"] + toolbarbutton image.toolbarbutton-icon {
                -moz-context-properties: fill;
                fill: currentColor;
                list-style-image: url("chrome://browser/skin/developer.svg");
                }*/

                #appmenu-developer-tools-view toolbarbutton[key="key_responsiveDesignMode"] + toolbarbutton > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_viewSource"] + toolbarbutton > label.toolbarbutton-text {
                padding-inline-start: 8px !important;
                }

                /* Browser Toolbox (by Key) and Browser Content Toolbox  */

                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton > image.toolbarbutton-icon,
                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton + toolbarbutton > image.toolbarbutton-icon {
                list-style-image: url("../../image/command-tilt.png");
                filter: grayscale(100%) brightness(10%);
                }

                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton > label.toolbarbutton-text,
                #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton + toolbarbutton > label.toolbarbutton-text {
                padding-inline-start: 8px !important;
                }

                #appmenu-developer-tools-view toolbarbutton:-moz-lwtheme-brighttext[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton > image.toolbarbutton-icon,
                #appmenu-developer-tools-view toolbarbutton:-moz-lwtheme-brighttext[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton + toolbarbutton > image.toolbarbutton-icon {
                list-style-image: url("../../image/command-tilt.png");
                filter: grayscale(100%) brightness(220%) !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton > image.toolbarbutton-icon,
                    #appmenu-developer-tools-view toolbarbutton[key="key_toggleToolbox"] + toolbarbutton + toolbarbutton + toolbarbutton + toolbarbutton > image.toolbarbutton-icon {
                    list-style-image: url("../../image/command-tilt.png");
                    filter: grayscale(100%) brightness(220%) !important;
                    }
                }



                /* support for restart_item_in_menu.uc.js script */
                #appMenu-restart-button > .toolbarbutton-icon {
                margin-inline-end: -4px !important;
                }

                /**/
                #panelMenu_showAllBookmarks > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/chevron.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #PanelUI-historyMore > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/chevron.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                /**/
                #appMenu_menu_openHelp > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/help.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu_feedbackPage > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://devtools/skin/images/tool-network.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu_helpSafeMode > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/info.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu_troubleShooting > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/info.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu_help_reportSiteIssue > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/info.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu_menu_HelpPopup_reportPhishingtoolmenu > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/info.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

                #appMenu_aboutName > .toolbarbutton-icon {
                -moz-context-properties: fill;
                list-style-image: url("chrome://global/skin/icons/help.svg");
                padding-inline-end: 4px;
                fill: currentColor;
                }

              /* CUSTOM: App Button Popup Icons Colorized */
                                /* blue */
                #appMenu-fxa-label2::before,
                #fxa-manage-account-button::before,
                :is(#appMenu-new-window-button2,#appMenu-downloads-button,#appMenu-save-file-button2,#appMenu-zoomEnlarge-button2,#PanelUI-fxa-menu-sync-prefs-button,#appMenu_aboutName) > .toolbarbutton-icon {
                fill: #4169e1 !important;
                }

                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #fxa-manage-account-button::before,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #appMenu-fxa-label2::before,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-new-window-button2,#appMenu-downloads-button,#appMenu-save-file-button2,#appMenu-zoomEnlarge-button2,#PanelUI-fxa-menu-sync-prefs-button,#appMenu_aboutName) > .toolbarbutton-icon {
                fill: #00d2ff !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #fxa-manage-account-button::before,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #appMenu-fxa-label2::before,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-new-window-button2,#appMenu-downloads-button,#appMenu-save-file-button2,#appMenu-zoomEnlarge-button2,#PanelUI-fxa-menu-sync-prefs-button,#appMenu_aboutName) > .toolbarbutton-icon {
                    fill: #00d2ff !important;
                    }
                }

                /* purple */
                :is(#appMenu-new-private-window-button2,#appMenu-history-button,#appMenuSearchHistory,#appMenu-print-button2,#appMenu-translate-button) > .toolbarbutton-icon,
                #PanelUI-history :is(#appMenuRecentlyClosedTabs,#appMenuRecentlyClosedWindows,#appMenuRestoreSession,#appMenu-restoreSession) > .toolbarbutton-icon {
                fill: #800080 !important;
                }

                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-new-private-window-button2,#appMenu-history-button,#appMenuSearchHistory,#appMenu-print-button2,#appMenu-translate-button) > .toolbarbutton-icon,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #PanelUI-history :is(#appMenuRecentlyClosedTabs,#appMenuRecentlyClosedWindows,#appMenuRestoreSession,#appMenu-restoreSession) > .toolbarbutton-icon {
                fill: #ff00ff !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-new-private-window-button2,#appMenu-history-button,#appMenuSearchHistory,#appMenu-print-button2) > .toolbarbutton-icon,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #PanelUI-history :is(#appMenuRecentlyClosedTabs,#appMenuRecentlyClosedWindows,#appMenuRestoreSession,#appMenu-restoreSession) > .toolbarbutton-icon {
                    fill: #ff00ff !important;
                    }
                }

                /* dark blue */
                :is(#appMenu-bookmarks-button,#appMenu-find-button2,#appMenu-more-button2,#appMenu-help-button2,#appmenu-moreTools-button,#panelMenu_showAllBookmarks,#PanelUI-historyMore,#appMenu_menu_openHelp) > .toolbarbutton-icon,
                :is(#appMenu-zoom-controls,#appMenu-zoom-controls2)::before,
                #PanelUI-bookmarks :is(#panelMenuBookmarkThisPage,#panelMenu_searchBookmarks) > .toolbarbutton-icon {
                fill: #336699 !important;
                }

                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-bookmarks-button,#appMenu-find-button2,#appMenu-more-button2,#appMenu-help-button2,#appmenu-moreTools-button,#panelMenu_showAllBookmarks,#PanelUI-historyMore,#appMenu_menu_openHelp) > .toolbarbutton-icon,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-zoom-controls,#appMenu-zoom-controls2)::before,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #PanelUI-bookmarks :is(#panelMenuBookmarkThisPage,#panelMenu_searchBookmarks) > .toolbarbutton-icon {
                fill: #64a3e2 !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-bookmarks-button,#appMenu-find-button2,#appMenu-more-button2,#appMenu-help-button2,#appmenu-moreTools-button,#panelMenu_showAllBookmarks,#PanelUI-historyMore,#appMenu_menu_openHelp) > .toolbarbutton-icon,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-zoom-controls,#appMenu-zoom-controls2)::before,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #PanelUI-bookmarks :is(#panelMenuBookmarkThisPage,#panelMenu_searchBookmarks) > .toolbarbutton-icon {
                    fill: #64a3e2 !important;
                    }
                }

                /* red */
                #PanelUI-fxa-menu-syncnow-button::before,
                :is(#appMenu-passwords-button,#appMenu-quit-button2,#appMenu-zoomReduce-button2,#appMenuClearRecentHistory,#PanelUI-fxa-menu-account-signout-button,#appMenu_help_reportSiteIssue,#appMenu_menu_HelpPopup_reportPhishingtoolmenu) > .toolbarbutton-icon {
                fill: red !important;
                }

                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext #PanelUI-fxa-menu-syncnow-button::before,
                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-passwords-button,#appMenu-quit-button2,#appMenu-zoomReduce-button2,#appMenuClearRecentHistory,#PanelUI-fxa-menu-account-signout-button,#appMenu_help_reportSiteIssue,#appMenu_menu_HelpPopup_reportPhishingtoolmenu) > .toolbarbutton-icon {
                fill: #ff5a5a !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme #PanelUI-fxa-menu-syncnow-button::before,
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-passwords-button,#appMenu-quit-button2,#appMenu-zoomReduce-button2,#appMenuClearRecentHistory,#PanelUI-fxa-menu-account-signout-button,#appMenu_help_reportSiteIssue,#appMenu_menu_HelpPopup_reportPhishingtoolmenu) > .toolbarbutton-icon {
                    fill: #ff5a5a !important;
                    }
                }

                /* green */
                :is(#appMenu-extensions-themes-button,#PanelUI-fxa-menu-sendtab-button,#appMenu_feedbackPage) > .toolbarbutton-icon {
                fill: green !important;
                }

                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-extensions-themes-button,#PanelUI-fxa-menu-sendtab-button,#appMenu_feedbackPage) > .toolbarbutton-icon {
                fill: lightgreen !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-extensions-themes-button,#PanelUI-fxa-menu-sendtab-button,#appMenu_feedbackPage) > .toolbarbutton-icon {
                    fill: lightgreen !important;
                    }
                }

                /* orange */
                :is(#appMenu-new-tab-button2,#appMenu-fullscreen-button2,#panelMenu_viewBookmarksToolbar,#PanelUI-fxa-menu-connect-device-button,#appMenu_helpSwitchDevice,#appMenu_helpSafeMode,#appMenu_troubleShooting) > .toolbarbutton-icon {
                fill: orange !important;
                }

                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-new-tab-button2,#appMenu-fullscreen-button2,#panelMenu_viewBookmarksToolbar,#PanelUI-fxa-menu-connect-device-button,#appMenu_helpSwitchDevice,#appMenu_helpSafeMode,#appMenu_troubleShooting) > .toolbarbutton-icon {
                fill: orange !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-new-tab-button2,#appMenu-fullscreen-button2,#panelMenu_viewBookmarksToolbar,#PanelUI-fxa-menu-connect-device-button,#appMenu_helpSwitchDevice,#appMenu_helpSafeMode,#appMenu_troubleShooting) > .toolbarbutton-icon {
                    fill: orange !important;
                    }
                }

                /* grey */
                :is(#appMenu-settings-button,#PanelUI-fxa-menu-setup-sync-button) > .toolbarbutton-icon {
                fill: grey !important;
                }

                #main-window:not([style*='--lwt-header-image']):-moz-lwtheme:-moz-lwtheme-brighttext :is(#appMenu-settings-button,#PanelUI-fxa-menu-setup-sync-button) > .toolbarbutton-icon {
                fill: lightgrey !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window:not([style*='--lwt-header-image']):-moz-lwtheme :is(#appMenu-settings-button,#PanelUI-fxa-menu-setup-sync-button) > .toolbarbutton-icon {
                    fill: lightgrey !important;
                    }
                }

            /* CUSTOM: App button in Titlebar */
                /************************************************/
                /* cheat main menu button into title bar ********/
                /************************************************/

                /* menubar adjustments */
                #main-window[tabsintitlebar] #toolbar-menubar {
                margin-inline-start: 95px !important;
                }

                #main-window[tabsintitlebar][sizemode="maximized"] #toolbar-menubar {
                margin-inline-start: 94px !important;
                }

                #main-window[uidensity=compact][tabsintitlebar] #toolbar-menubar {
                margin-inline-start: 93px !important;
                }

                #main-window[uidensity=compact][tabsintitlebar][sizemode="maximized"] #toolbar-menubar {
                margin-inline-start: 92px !important;
                }

                /* tabs toolbar adjustments */
                #main-window[tabsintitlebar] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar {
                padding-inline-start: 95px !important;
                }

                #main-window[tabsintitlebar][sizemode="maximized"] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar {
                padding-inline-start: 94px !important;
                }

                #main-window[uidensity=compact][tabsintitlebar] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar {
                padding-inline-start: 93px !important;
                }

                #main-window[uidensity=compact][tabsintitlebar][sizemode="maximized"] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar {
                padding-inline-start: 92px !important;
                }

                #main-window[tabsintitlebar][sizemode="fullscreen"] #TabsToolbar {
                padding-inline-start: 95px !important;
                }

                #main-window[tabsintitlebar]:not([sizemode="fullscreen"]) #toolbar-menubar[autohide="true"]:not([inactive="true"]) ~ #TabsToolbar,
                #main-window[tabsintitlebar]:not([sizemode="fullscreen"]) #toolbar-menubar[autohide="false"] ~ #TabsToolbar {
                margin-top: 4px !important;
                }

                /* appbutton */
                #main-window[tabsintitlebar] #PanelUI-button {
                appearance: none !important;
                position: fixed !important;
                display: flex !important;
                height: 22px !important;
                margin: 0 !important;
                margin-inline-start: 0px !important;
                border: unset !important;
                box-shadow: unset !important;
                padding-left: 0px !important;
                padding-right: 0px !important;
                top: 0px !important;
                }

                @media (-moz-platform: windows-win7), (-moz-os-version:windows-win7), (-moz-platform: windows-win8), (-moz-os-version:windows-win8) {

                    #main-window[tabsintitlebar][sizemode="normal"] #PanelUI-button {
                    top: 0px !important;
                    }

                    #main-window[tabsintitlebar][sizemode="maximized"] #PanelUI-button {
                    top: 8px !important;
                    }

                    @media (min-resolution: 110dpi) {
                        #main-window[tabsintitlebar][sizemode="maximized"] #PanelUI-button {
                        top: 6px !important;
                        }
                    }

                    @media (min-resolution: 120dpi) {
                        #main-window[tabsintitlebar][sizemode="maximized"] #PanelUI-button {
                        top: 5px !important;
                        }
                    }

                    @media (min-resolution: 140dpi) {
                        #main-window[tabsintitlebar][sizemode="normal"] #PanelUI-button {
                        top: 0px !important;
                        }
                        #main-window[tabsintitlebar][sizemode="maximized"] #PanelUI-button {
                        top: 4px !important;
                        }
                    }

                    @media (min-resolution: 160dpi) {
                        #main-window[tabsintitlebar][sizemode="maximized"] #nav-bar #PanelUI-button {
                        top: 2px !important;
                        }
                    }

                    @media (-moz-windows-classic) {
                        #main-window[tabsintitlebar][sizemode="maximized"] #nav-bar #PanelUI-button {
                        top: 2px !important;
                        }
                    }
                }

                /* code for Unix (macOS/Linux) */
                @media (not (-moz-os-version: windows-win10)) and (not (-moz-os-version: windows-win8)) and (not (-moz-os-version: windows-win7)) {
                    #main-window[tabsintitlebar][sizemode="maximized"] #PanelUI-button {
                    top: 0px !important;
                    }
                }

                @media not (-moz-platform: windows) {
                    #main-window[tabsintitlebar][sizemode="maximized"] #PanelUI-button {
                    top: 0px !important;
                    }
                }

                #main-window[tabsintitlebar][sizemode="fullscreen"] #PanelUI-button {
                top: 0px !important;
                }

                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button {
                background-clip: padding-box !important;
                padding: 0 1.4em 0 !important;
                padding-top: 0 !important;
                padding-bottom: 0 !important;
                padding-inline-start: 1.4em !important;
                padding-inline-end: 2.1em !important;
                height: 22px !important;
                border-radius: 0 0 4px 4px;
                border-top: none !important;
                border-right: 1px solid !important;
                border-left: 1px solid !important;
                border-bottom: 1px solid !important;
                }

                /* code for Unix (macOS/Linux) */
                @media (not (-moz-os-version: windows-win10)) and (not (-moz-os-version: windows-win8)) and (not (-moz-os-version: windows-win7)) {
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button {
                    max-width: 90px !important;
                }
                }

                @media not (-moz-platform: windows) {
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button {
                    max-width: 90px !important;
                }
                }

                /* hide button in fullscreen mode, if toolbars get automatically hidden */
                #main-window[tabsintitlebar][sizemode="fullscreen"] #navigator-toolbox[style*="margin-top: -"] #PanelUI-button {
                visibility: collapse !important;
                }

                /* dropmarker icon / arrow */
                #main-window[tabsintitlebar] #PanelUI-button .toolbarbutton-icon {
                margin-top: 2px !important;
                margin-bottom: 0px !important;
                list-style-image: url("../../image/dropdown-arrow-inverted.svg") !important;
                width: 9px !important;
                height: 7px !important;
                background: unset !important;
                box-shadow: unset !important;
                }

                /* code for Unix (macOS/Linux) *//*
                @media (not (-moz-os-version: windows-win10)) and (not (-moz-os-version: windows-win8)) and (not (-moz-os-version: windows-win7)) {
                #main-window[tabsintitlebar] #PanelUI-button .toolbarbutton-icon  {
                    list-style-image: none !important;
                }
                }

                @media not (-moz-platform: windows) {
                #main-window[tabsintitlebar] #PanelUI-button .toolbarbutton-icon  {
                    list-style-image: none !important;
                }
                }*/

                #main-window[tabsintitlebar] #PanelUI-menu-button::after {
                display: block !important;
                color: white !important;
                font-weight: bold !important;
                text-shadow: 0 0 1px rgba(0,0,0,.7),
                            0 1px 1.5px rgba(0,0,0,.5) !important;
                border: unset !important;
                box-shadow: unset !important;
                margin-inline-start: 8px !important;
                }

                #main-window[tabsintitlebar] #PanelUI-menu-button .toolbarbutton-badge-stack {
                position: absolute;
                right: 0px;
                }

                /* 'Firefox' title */
                #main-window[tabsintitlebar] #PanelUI-menu-button[label="Firefox"]::after,
                #main-window[tabsintitlebar] #PanelUI-menu-button:not([label="Nightly"],[label="Firefox Nightly"],[label="Firefox Developer Edition"],[label="Firefox"],[label="Tor Browser"],[label="Tor-Browser"])::after {
                content: "Firefox" !important;
                }

                /* 'DevFox' title */
                #main-window[tabsintitlebar] #PanelUI-menu-button[label="Firefox Developer Edition"]::after {
                content: "DevFox" !important;
                }

                /* 'Nightly' title */
                #main-window[tabsintitlebar] #PanelUI-menu-button:is([label="Nightly"],[label="Firefox Nightly"])::after {
                content: "Nightly" !important;
                }

                /* 'Tor-Browser' title */
                #main-window[tabsintitlebar] #PanelUI-menu-button:-moz-any([label="Tor Browser"],[label="Tor-Browser"])::after {
                content: "TorFox" !important;
                }

                /* adjust button badge stack */
                #main-window[tabsintitlebar] :is(#PanelUI-button,#PanelUI-menu-button):not([checked],[open],:active) > .toolbarbutton-badge-stack,
                #main-window[tabsintitlebar] :is(#PanelUI-button,#PanelUI-menu-button):not([disabled=true],[checked],[open],:active):hover > .toolbarbutton-badge-stack,
                #main-window[tabsintitlebar] :is(#PanelUI-button,#PanelUI-menu-button):not([disabled=true]):is([open],[checked],:hover:active) > .toolbarbutton-badge-stack{
                background: unset !important;
                border-color: unset !important;
                border: 0 !important;
                box-shadow: unset !important;
                }

                /* adjust button badge */
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button .toolbarbutton-badge-stack .toolbarbutton-badge  {
                position: fixed !important;
                left: 10px !important;
                top: 5px !important;
                }

                /* button color/border */

                /* orange (default) */
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button {
                background-image: linear-gradient(rgb(247,182,82), rgb(215,98,10) 95%) !important;
                border-right-color:hsla(214,89%,21%,.5) !important;
                border-left-color: hsla(214,89%,21%,.5) !important;
                border-bottom-color: hsla(214,89%,21%,.5) !important;
                box-shadow: 0 1px 0 hsla(0,0%,100%,.2) inset,
                            0 0 2px 1px hsla(0,0%,100%,.25) inset,
                            0 1px 0 0px rgba(255,255,255,.6),
                            0 -1px 0 0px rgba(255,255,255,.6),
                            1px 0 0 0px rgba(255,255,255,.6),
                            -1px 0 0 0px rgba(255,255,255,.6) !important;
                }
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button:hover:not(:active):not([open]){
                background-image: radial-gradient(farthest-side at center bottom, rgba(252,240,89,.5) 10%, rgba(252,240,89,0) 70%),
                                    radial-gradient(farthest-side at center bottom, rgb(236,133,0), rgba(255,229,172,0)),
                                    linear-gradient(rgb(246,170,69), rgb(209,74,0) 95%) !important;
                border-color: rgba(83,42,6,.9) !important;
                box-shadow: 0 1px 0 hsla(0,0%,100%,.15) inset,
                            0 0 2px 1px hsla(0,0%,100%,.5) inset,
                            0 -1px 0 hsla(0,0%,100%,.2),
                            0 1px 0 0px rgba(255,255,255,.6),
                            0 -1px 0 0px rgba(255,255,255,.6),
                            1px 0 0 0px rgba(255,255,255,.6),
                            -1px 0 0 0px rgba(255,255,255,.6) !important;
                }
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button:is(:hover:active,[open]){
                background-image: linear-gradient(rgb(246,170,69), rgb(209,74,0) 95%) !important;
                box-shadow: 0 2px 3px rgba(0,0,0,.4) inset,
                            0 1px 1px rgba(0,0,0,.2) inset,
                            0 1px 0 0px rgba(255,255,255,.6),
                            0 -1px 0 0px rgba(255,255,255,.6),
                            1px 0 0 0px rgba(255,255,255,.6),
                            -1px 0 0 0px rgba(255,255,255,.6) !important;
                }

                /*private browsing - purple */
                #main-window[privatebrowsingmode=temporary][tabsintitlebar] #navigator-toolbox #PanelUI-button #PanelUI-menu-button{
                background-image: linear-gradient(rgb(153,38,211), rgb(105,19,163) 95%) !important;
                }
                #main-window[privatebrowsingmode=temporary][tabsintitlebar] #navigator-toolbox #PanelUI-button #PanelUI-menu-button:hover:not(:active):not([open]){
                background-image: radial-gradient(farthest-side at center bottom, rgba(240,193,255,.5) 10%, rgba(240,193,255,0) 70%),
                                    radial-gradient(farthest-side at center bottom, rgb(192,81,247), rgba(236,172,255,0)),
                                    linear-gradient(rgb(144,20,207), rgb(95,0,158) 95%) !important;
                }
                #main-window[privatebrowsingmode=temporary][tabsintitlebar] #navigator-toolbox #PanelUI-button #PanelUI-menu-button:is(:hover:active,[open]) {
                background-image: linear-gradient(rgb(144,20,207), rgb(95,0,158) 95%) !important;
                }

                /* fix for 'buttons_on_navbar_squared_buttons.css' */
                #main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-badge-stack,
                #main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-badge-stack,
                #main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-badge-stack {
                padding-top: 0px !important;
                padding-bottom: 0px !important;
                width: unset !important;
                height: 22px !important;
                }

                #main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-icon,
                #main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-icon,
                #main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-icon {
                padding: 6px !important;
                width: 9px !important;
                height: 7px !important;
                }

                /* fix for toolbar + text mode */
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button,
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button,
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) .toolbarbutton-1[type="menu-button"] #PanelUI-menu-button{
                appearance: unset !important;
                }
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button .toolbarbutton-text,
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button:not([type="menu-button"]) .toolbarbutton-text,
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) .toolbarbutton-1[type="menu-button"] #PanelUI-menu-button .toolbarbutton-text{
                display: none !important;
                }
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button:not([type="menu-button"]),
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button:not([type="menu-button"]),
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) .toolbarbutton-1[type="menu-button"] #PanelUI-menu-button{
                -moz-box-orient: unset !important;
                flex-direction: unset !important;
                min-width: unset !important;
                }

                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) toolbaritem #PanelUI-menu-button:not(#nav-bar-overflow-button):not(#PlacesChevron) > :is(.toolbarbutton-icon,.toolbarbutton-badge-stack),
                #main-window[tabsintitlebar] toolbox toolbar:not(#TabsToolbar) #PanelUI-menu-button:not([type="menu-button"]):not(#nav-bar-overflow-button):not(#PlacesChevron) > :is(.toolbarbutton-icon,.toolbarbutton-badge-stack) {
                opacity: 1.0 !important;
                margin-bottom: unset !important;
                }

                /* support for tab title in Firefox titlebar option*/
                #main-window[tabsintitlebar]::after {
                margin-inline-start: 95px !important;
                }

                /* remove this nonsense button, a menuitem is inside menu button anyways */
                #PanelUI-button #whats-new-menu-button {
                display: none !important;
                }

                /* workaround for Firefox 71+ *******************/
                #main-window[tabsintitlebar] #PanelUI-button > *:not(#PanelUI-menu-button) {
                display: none !important;
                }

                #main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-badge-stack,
                #main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-badge-stack,
                #main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-badge-stack,
                #main-window[tabsintitlebar][uidensity=compact] #PanelUI-menu-button .toolbarbutton-icon,
                #main-window[tabsintitlebar]:not([uidensity=compact]):not([uidensity=touch]) #PanelUI-menu-button .toolbarbutton-icon,
                #main-window[tabsintitlebar][uidensity=touch] #PanelUI-menu-button .toolbarbutton-icon {
                width: unset !important;
                height: unset !important;
                }

                #TabsToolbar .titlebar-spacer[type="pre-tabs"] {
                display: none !important;
                }

                /* workaround for Firefox 102+ *******************/
                panel[id="appMenu-popup"][type="arrow"][side="top"],
                panel[id="appMenu-popup"][type="arrow"][side="bottom"] {
                margin-inline: 0 !important;
                }

            /* CUSTOM: LINUX GTK - Maximize and Minimize and Close buttons */
                .titlebar-buttonbox{
                    -moz-box-align: stretch !important; /* Fx <112 compatibility */
                    align-items: stretch !important;
                }
                .titlebar-button {
                    -moz-appearance: none !important;
                    -moz-context-properties: fill, stroke, fill-opacity;
                    fill: currentColor;
                    padding: 4px 6px !important;
                    -moz-box-flex: 1;
                    flex-grow: 1;
                    overflow: -moz-hidden-unscrollable;
                }
                .titlebar-button:hover{ display:none }
                .titlebar-min { display:none  }
                .titlebar-close{ display: none);
                }
                */

                /* Autocolor */
                /* Aurora */
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button[label="Firefox Developer Edition"] {
                background-image: linear-gradient(hsl(208,99%,37%), hsl(214,90%,23%) 95%) !important;
                }
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button[label="Firefox Developer Edition"]:hover:not(:active):not([open]){
                background-image: radial-gradient(farthest-side at center bottom, hsla(202,100%,85%,.5) 10%, hsla(202,100%,85%,0) 70%),
                                    radial-gradient(farthest-side at center bottom, hsla(205,100%,72%,.7), hsla(205,100%,72%,0)),
                                    linear-gradient(hsl(208,98%,34%), hsl(213,87%,20%) 95%) !important;
                }
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button[label="Firefox Developer Edition"]:is(:hover:active,[open]) {
                background-image: linear-gradient(hsl(208,95%,30%), hsl(214,85%,17%) 95%) !important;
                }

                /* Nightly */
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button:is([label="Nightly"],[label="Firefox Nightly"]) {
                background-image: linear-gradient(hsl(211,33%,32%), hsl(209,53%,10%) 95%) !important;
                }
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button:is([label="Nightly"],[label="Firefox Nightly"]):hover:not(:active):not([open]){
                background-image: radial-gradient(farthest-side at center bottom, hsla(210,48%,90%,.5) 10%, hsla(210,48%,90%,0) 70%),
                                    radial-gradient(farthest-side at center bottom, hsla(211,70%,83%,.5), hsla(211,70%,83%,0)),
                                    linear-gradient(hsl(211,33%,32%), hsl(209,53%,10%) 95%) !important;
                }
                #main-window[tabsintitlebar] #PanelUI-button #PanelUI-menu-button:is([label="Nightly"],[label="Firefox Nightly"]):is(:hover:active,[open]) {
                background-image: linear-gradient(hsl(211,33%,26%), hsl(209,53%,6%) 95%) !important;
                }

                /* Tor-Browser */
                #main-window[tabsintitlebar] #navigator-toolbox #PanelUI-button #PanelUI-menu-button:is([label="Tor Browser"],[label="Tor-Browser"]) {
                background-image: linear-gradient(rgb(153,38,211), rgb(105,19,163) 95%) !important;
                }
                #main-window[tabsintitlebar] #navigator-toolbox #PanelUI-button #PanelUI-menu-button:is([label="Tor Browser"],[label="Tor-Browser"]):hover:not(:active):not([open]){
                background-image: radial-gradient(farthest-side at center bottom, rgba(240,193,255,.5) 10%, rgba(240,193,255,0) 70%),
                                    radial-gradient(farthest-side at center bottom, rgb(192,81,247), rgba(236,172,255,0)),
                                    linear-gradient(rgb(144,20,207), rgb(95,0,158) 95%) !important;
                }
                #main-window[tabsintitlebar] #navigator-toolbox #PanelUI-button #PanelUI-menu-button:is([label="Tor Browser"],[label="Tor-Browser"]):is(:hover:active,[open]) {
                background-image: linear-gradient(rgb(144,20,207), rgb(95,0,158) 95%) !important;
                }

            /* CUSTOM: Square Tabs (take it oldschool Firefox 4-28) */
                :root {
                --classic_squared_tabs_tab_height: 26px;
                --classic_squared_tabs_tab_default_loading_icon_color: #0A84FF;
                --classic_squared_tabs_active_tab: linear-gradient(to top,#f9f9fa,#f9f9fa,#f9f9fa);
                --classic_squared_tabs_hovered_tabs: linear-gradient(to top,#cac7c1,#d5d2cc,#e8e6e2);
                --classic_squared_tabs_other_tabs: linear-gradient(to top,#aeaba5,#c1beb7,#c9c6be);
                --classic_squared_tabs_unloaded_tabs: linear-gradient(to top,#aeaba5,#c1beb7,#c9c6be);
                --classic_squared_tabs_lwt-dark_active_tab: inherit;
                --classic_squared_tabs_lwt-dark_hovered_tabs: linear-gradient(hsla(0,0%,80%,.5), hsla(0,0%,60%,.5) 80%);
                --classic_squared_tabs_lwt-dark_other_tabs: linear-gradient(hsla(0,0%,60%,.5), hsla(0,0%,45%,.5) 80%);
                --classic_squared_tabs_lwt-bright_active_tab: inherit;
                --classic_squared_tabs_lwt-bright_hovered_tabs: linear-gradient(hsla(0,0%,60%,.6), hsla(0,0%,45%,.6) 80%);
                --classic_squared_tabs_lwt-bright_other_tabs: linear-gradient(hsla(0,0%,40%,.6), hsla(0,0%,30%,.6) 80%);
                --classic_squared_tabs-border_size: 1px;
                --classic_squared_tabs-border1: #5f7181;
                --classic_squared_tabs-border2: rgba(0,0,0,.2);
                --classic_squared_tabs-border3: rgba(0,0,0,.5);
                --classic_squared_tabs-border-radius: 3px;
                --classic_squared_tabs_new_tab_icon_color: black;
                --classic_squared_tabs_tab_text_color: black;
                --classic_squared_tabs_tab_text_shadow: transparent;

                --tab-min-height: var(--classic_squared_tabs_tab_height) !important;
                --mltabs-newtab-height: calc( var(--classic_squared_tabs_tab_height) + 1px ) !important;
                --tab-min-height_tnot: calc( var(--classic_squared_tabs_tab_height) - 1px ) !important; /* for tabs_below_navigation_toolbar_alt.css */

                --tab_below_navigation_toolbar_bottom_padding: var(--classic_squared_tabs_tab_height) !important;

                --tab_below_main_content_bottom_margin: calc(2px + var(--classic_squared_tabs_tab_height)) !important;
                --tab_below_main_content_toolbar_height: calc(1px + var(--classic_squared_tabs_tab_height)) !important;
                --tab_below_main_content_top_margin: 0 !important;

                /* variables for tabs below navigation toolbar option on macOS */
                --tab_below_navigation_toolbar_bottom_padding_macOS: var(--classic_squared_tabs_tab_height) !important;
                --tab_below_navigation_toolbar_toolbox_top_padding_macOS: calc(-2px + var(--classic_squared_tabs_tab_height)) !important;

                /* variables for tab_close_at_tabs_start.css */
                --ctb_start_padding: 2px !important;
                --ctb_width: 14px !important;
                --ctb_start_margin: -4px !important;
                --ctb_end_margin: 12px !important;
                }

                /* remove default tab colors */
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab:is([selected],[multiselected]),
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab,
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab .tab-background {
                background: unset !important;
                border: unset !important;
                }

                /*******************************************/
                /**** default themes tab colors [start] ****/
                /*******************************************/

                /* black tab text color */
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab {
                color: var(--classic_squared_tabs_tab_text_color) !important;
                text-shadow: 1px 1px 1px var(--classic_squared_tabs_tab_text_shadow) !important;
                }

                /* default tabs color */
                #TabsToolbar:not(:-moz-lwtheme) :is(.tabs-newtab-button,#tabs-newtab-button),
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab .tab-content {
                background-image: var(--classic_squared_tabs_other_tabs) !important;
                }
                /* selected tabs color */
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab .tab-content:is([selected],[multiselected]) {
                background-image: var(--classic_squared_tabs_active_tab) !important;
                }
                /* hovered tabs color */
                #TabsToolbar:not(:-moz-lwtheme) :is(.tabs-newtab-button,#tabs-newtab-button):hover,
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab:hover .tab-content:not([selected],[multiselected]) {
                background-image: var(--classic_squared_tabs_hovered_tabs) !important;
                }

                /* unloaded/pending tabs color */
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab[pending] .tab-content {
                background-image: var(--classic_squared_tabs_unloaded_tabs) !important;
                }

                /* tab border color */
                #TabsToolbar:not(:-moz-lwtheme) :is(.tabs-newtab-button,#tabs-newtab-button),
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab .tab-content {
                border-top: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border1) !important;
                border-left: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border1) !important;
                border-right: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border1) !important;
                }

                #TabsToolbar :is(.tabs-newtab-button,#tabs-newtab-button) {
                border-top: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border2) !important;
                border-left: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border2) !important;
                border-right: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border2) !important;
                }

                #TabsToolbar .tabbrowser-tab:not(:-moz-lwtheme):not([selected],[multiselected]) .tab-content {
                border-top: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border3) !important;
                border-left: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border3) !important;
                border-right: var(--classic_squared_tabs-border_size) solid var(--classic_squared_tabs-border3) !important;
                }

                /* new tab icon color */
                #TabsToolbar:not(:-moz-lwtheme) :is(.tabs-newtab-button,#tabs-newtab-button) {
                fill: var(--classic_squared_tabs_new_tab_icon_color) !important;
                color: var(--classic_squared_tabs_new_tab_icon_color) !important;
                }
                /*******************************************/
                /***** default themes tab colors [end] *****/
                /*******************************************/

                /********************************************/
                /******* lw-themes tab colors [start] *******/
                /********************************************/

                /* lightweight theme tab colors*/
                /* lightweight theme tab colors*/
                #TabsToolbar:is([darktext],:-moz-lwtheme-darktext):-moz-lwtheme .tabbrowser-tab:is([selected],[multiselected]) .tab-content {
                background-image: var(--classic_squared_tabs_lwt-dark_active_tab) !important;
                }
                #TabsToolbar:is([darktext],:-moz-lwtheme-darktext):-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button),
                #TabsToolbar:not([selected],[multiselected]):-moz-lwtheme-darktext:-moz-lwtheme .tabbrowser-tab .tab-content {
                background-image: var(--classic_squared_tabs_lwt-dark_other_tabs) !important;
                }
                #TabsToolbar:is([darktext],:-moz-lwtheme-darktext):-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button):hover,
                #TabsToolbar:is([darktext],:-moz-lwtheme-darktext):-moz-lwtheme .tabbrowser-tab:not([selected],[multiselected]):hover .tab-content {
                background-image: var(--classic_squared_tabs_lwt-dark_hovered_tabs) !important;
                }

                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme .tabbrowser-tab:is([selected],[multiselected]) .tab-content {
                background-image: var(--classic_squared_tabs_lwt-bright_active_tab) !important;
                }
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button),
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme .tabbrowser-tab:not([selected],[multiselected]) .tab-content {
                background-image: var(--classic_squared_tabs_lwt-bright_other_tabs) !important;
                }
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button):hover,
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme .tabbrowser-tab:not([selected],[multiselected]):hover .tab-content {
                background-image: var(--classic_squared_tabs_lwt-bright_hovered_tabs) !important;
                }
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme .tabbrowser-tab:not([selected],[multiselected]):not(:hover) {
                background: unset !important;
                }

                #TabsToolbar:is([darktext],:-moz-lwtheme-darktext):-moz-lwtheme .tabbrowser-tab:is([selected],[multiselected]) .tab-content {
                border-top: 1px solid rgba(0,0,0,.5) !important;
                border-left: 1px solid rgba(0,0,0,.4) !important;
                border-right: 1px solid rgba(0,0,0,.4) !important;
                }
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme .tabbrowser-tab:is([selected],[multiselected]) .tab-content {
                border-top: 1px solid rgba(255,255,255,.6) !important;
                border-left: 1px solid rgba(255,255,255,.2) !important;
                border-right: 1px solid rgba(255,255,255,.2) !important;
                }

                #TabsToolbar:is([darktext],:-moz-lwtheme-darktext):-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button),
                #TabsToolbar:is([darktext],:-moz-lwtheme-darktext):-moz-lwtheme .tabbrowser-tab .tab-content {
                border-top: 1px solid rgba(0,0,0,.2) !important;
                border-left: 1px solid rgba(0,0,0,.2) !important;
                border-right: 1px solid rgba(0,0,0,.2) !important;
                }
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button),
                #TabsToolbar:is([brighttext],:-moz-lwtheme-brighttext):-moz-lwtheme .tabbrowser-tab .tab-content {
                border-top: 1px solid rgba(255,255,255,.6) !important;
                border-left: 1px solid rgba(255,255,255,.2) !important;
                border-right: 1px solid rgba(255,255,255,.2) !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    .tabbrowser-tab:is([selected],[multiselected]):-moz-lwtheme .tab-content {
                    background-image: var(--classic_squared_tabs_lwt-bright_active_tab) !important;
                    }
                    :is(.tabs-newtab-button,#tabs-newtab-button):-moz-lwtheme,
                    .tabbrowser-tab:not([selected],[multiselected]):-moz-lwtheme .tab-content {
                    background-image: var(--classic_squared_tabs_lwt-bright_other_tabs) !important;
                    }
                    :is(.tabs-newtab-button,#tabs-newtab-button):hover:-moz-lwtheme,
                    .tabbrowser-tab:not([selected],[multiselected]):hover:-moz-lwtheme .tab-content {
                    background-image: var(--classic_squared_tabs_lwt-bright_hovered_tabs) !important;
                    }
                    .tabbrowser-tab:not([selected],[multiselected]):not(:hover):-moz-lwtheme {
                    background: unset !important;
                    }
                    .tabbrowser-tab:is([selected],[multiselected]):-moz-lwtheme .tab-content {
                    border-top: 1px solid rgba(255,255,255,.6) !important;
                    border-left: 1px solid rgba(255,255,255,.2) !important;
                    border-right: 1px solid rgba(255,255,255,.2) !important;
                    }
                    #TabsToolbar:-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button):-moz-lwtheme,
                    .tabbrowser-tab .tab-content:-moz-lwtheme {
                    border-top: 1px solid rgba(255,255,255,.6) !important;
                    border-left: 1px solid rgba(255,255,255,.2) !important;
                    border-right: 1px solid rgba(255,255,255,.2) !important;
                    }
                }

                @media (-moz-content-prefers-color-scheme: light) {
                    .tabbrowser-tab:is([selected],[multiselected]):-moz-lwtheme .tab-content {
                    background-image: var(--classic_squared_tabs_lwt-dark_active_tab) !important;
                    }
                    :is(.tabs-newtab-button,#tabs-newtab-button):-moz-lwtheme,
                    .tabbrowser-tab:not([selected],[multiselected]):-moz-lwtheme .tab-content {
                    background-image: var(--classic_squared_tabs_lwt-dark_other_tabs) !important;
                    }
                    :is(.tabs-newtab-button,#tabs-newtab-button):hover:-moz-lwtheme,
                    .tabbrowser-tab:not([selected],[multiselected]):hover:-moz-lwtheme .tab-content {
                    background-image: var(--classic_squared_tabs_lwt-dark_hovered_tabs) !important;
                    }

                    .tabbrowser-tab:is([selected],[multiselected]):-moz-lwtheme .tab-content {
                    border-top: 1px solid rgba(0,0,0,.5) !important;
                    border-left: 1px solid rgba(0,0,0,.4) !important;
                    border-right: 1px solid rgba(0,0,0,.4) !important;
                    }
                    #TabsToolbar:-moz-lwtheme :is(.tabs-newtab-button,#tabs-newtab-button):-moz-lwtheme,
                    .tabbrowser-tab .tab-content:-moz-lwtheme {
                    border-top: 1px solid rgba(0,0,0,.2) !important;
                    border-left: 1px solid rgba(0,0,0,.2) !important;
                    border-right: 1px solid rgba(0,0,0,.2) !important;
                    }
                }

                /* Fx 100+ outline fix */
                #TabsToolbar #firefox-view-button[open] > .toolbarbutton-icon:-moz-lwtheme,
                .tab-background:is([selected],[multiselected]):-moz-lwtheme {
                outline: unset !important;
                }


                /********************************************/
                /******** lw-themes tab colors [end] ********/
                /********************************************/

                /* tab line & tab background*/
                .tabbrowser-tab:-moz-lwtheme:is([selected],[multiselected]) .tab-line:is([selected],[multiselected]) {
                height: 0px !important;
                }

                .tabbrowser-tab > .tab-stack > .tab-background > .tab-line:is([selected],[multiselected]),
                .tabbrowser-tab:hover > .tab-stack > .tab-background > .tab-line:not([selected],[multiselected]) {
                background-color: rgba(0,0,0,.2);
                opacity: 0 !important;
                }

                .tabbrowser-tab .tab-background:is([selected],[multiselected]) {
                border-image: unset !important;
                border-image-slice: 0 !important;
                }

                /*
                .tabbrowser-tab:not([selected],[multiselected]) .tab-background{
                display: none !important;
                }
                */

                .tab-background {
                margin-block: unset !important;
                }

                .tabbrowser-tab:hover > .tab-stack > .tab-background:not([selected],[multiselected]) {
                background-color: rgba(0,0,0,.0) !important;
                }

                /* tab top border roundness */
                #TabsToolbar :is(.tabs-newtab-button,#tabs-newtab-button),
                #TabsToolbar .tabbrowser-tab,
                #TabsToolbar .tabbrowser-tab .tab-stack,
                #TabsToolbar .tabbrowser-tab .tab-background,
                #TabsToolbar .tabbrowser-tab .tab-content {
                border-top-left-radius: var(--classic_squared_tabs-border-radius) !important;
                border-top-right-radius: var(--classic_squared_tabs-border-radius) !important;
                }

                /* loading animation color */
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab,
                #TabsToolbar:not(:-moz-lwtheme) .tabbrowser-tab:not([selected],[multiselected]) {
                --tab-loading-fill: var(--classic_squared_tabs_tab_default_loading_icon_color) !important;
                }
                .tab-throbber[busy]::before,
                .tab-throbber[progress]::before {
                fill: var(--classic_squared_tabs_tab_default_loading_icon_color) !important;
                }

                /* space between tabs */
                :is(.tabs-newtab-button,#tabs-newtab-button),
                .tabbrowser-tab:not([pinned]) {
                margin-inline-start: 0px !important;
                }

                /* width of new tab tab */
                #TabsToolbar :is(.tabs-newtab-button,#tabs-newtab-button){
                min-width: 0px !important;
                width: 28px !important;
                margin-bottom: -1px !important;
                }

                /* size of new tab tabs '+' icon */
                #TabsToolbar :is(.tabs-newtab-button,#tabs-newtab-button) .toolbarbutton-icon{
                min-width: 0px !important;
                min-height: 0px !important;
                width: 14px !important;
                height: 14px !important;
                margin: 0px !important;
                margin-bottom: 0px !important;
                padding: 0px !important;
                background: unset !important;
                box-shadow: unset !important;
                }


                /*tab favicon position*/
                .tabbrowser-tab:not([pinned]):not([locked]) .tab-throbber,
                .tabbrowser-tab:not([pinned]) .tab-icon-image{
                margin-inline-start: -6px !important;
                }

                /* reduce minimum tab height */
                #tabbrowser-tabs,
                #tabbrowser-tabs > .tabbrowser-arrowscrollbox,
                .tabbrowser-tabs[positionpinnedtabs] > .tabbrowser-tab[pinned] {
                min-height: var(--classic_squared_tabs_tab_height) !important;
                }

                #TabsToolbar #tabbrowser-tabs[overflow="true"] .tabbrowser-tab[pinned] {
                min-height: calc( var(--classic_squared_tabs_tab_height) - 1px ) !important;
                max-height: calc( var(--classic_squared_tabs_tab_height) - 1px ) !important;
                }

                /* Windows 10 fix */
                @media (-moz-platform: windows-win10), (-moz-os-version: windows-win10) {
                    #toolbar-menubar .titlebar-button {
                    padding-top: 6px !important;
                    padding-bottom: 6px !important;
                    }
                    #main-window[sizemode="maximized"][tabsintitlebar] #toolbar-menubar[autohide="true"]:not([inactive="true"]) .titlebar-button {
                    padding-top: 4px !important;
                    padding-bottom: 4px !important;
                    }
                }

                /*pinned tabs*/
                #TabsToolbar .tab-content[pinned] {
                padding: 0 6px !important;
                }

                /* remove top line above tabs for lw-themes */
                #main-window:-moz-lwtheme #browser-panel{
                border: unset !important;
                box-shadow: unset !important;
                }

                /* hide tab separators and borders set by Firefox */
                .tabbrowser-tab::after,
                .tabbrowser-tab::before {
                opacity: 0 !important;
                border-image: unset !important;
                border-image-slice: unset !important;
                width: unset !important;
                }

                #tabbrowser-tabs[movingtab] > .tabbrowser-tab[beforeselected]:not([last-visible-tab])::after,
                .tabbrowser-tab:not([selected]):not([afterselected-visible]):not([afterhovered]):not([first-visible-tab]):not(:hover)::before,
                #tabbrowser-tabs:not([overflow]) > .tabbrowser-tab[last-visible-tab]:not([selected],[multiselected]):not([beforehovered]):not(:hover)::after {
                content: unset !important;
                display: unset !important;
                }

                .tabbrowser-tab::after,
                .tabbrowser-tab::before {
                border-left: unset !important;
                border-image: unset !important;
                border-image-slice: unset !important;
                border-top-left-radius: 3px !important;
                border-top-right-radius: 3px !important;
                }

                :root[tabsintitlebar]:not([extradragspace]) #toolbar-menubar[autohide=true] ~ #TabsToolbar > #tabbrowser-tabs > .tabbrowser-tab::after,
                :root[tabsintitlebar]:not([extradragspace]) #toolbar-menubar[autohide=true] ~ #TabsToolbar > #tabbrowser-tabs > .tabbrowser-tab::before,
                .tabbrowser-tab:hover::before,
                .tabbrowser-tab[last-visible-tab]:hover::after,
                #tabbrowser-tabs:not([movingtab]) > .tabbrowser-tab[afterhovered]::before {
                border-image: unset !important;
                border-image-slice: unset !important;
                border-top-left-radius: 3px !important;
                border-top-right-radius: 3px !important;
                }

                .tabbrowser-tab,
                .tab-stack,
                .tab-background {
                border: unset !important;
                }

                /* remove titlebar placerholders */
                #TabsToolbar .titlebar-placeholder[type="pre-tabs"],
                #TabsToolbar .titlebar-placeholder[type="post-tabs"]{
                opacity: 0 !important;
                }

                #TabsToolbar .titlebar-spacer[type="pre-tabs"],
                #TabsToolbar .titlebar-spacer[type="post-tabs"] {
                display: none !important;
                }

                /* make sure toolbar buttons do not increase toolbar height */
                #TabsToolbar toolbarbutton .toolbarbutton-badge-stack,
                #TabsToolbar > toolbarpaletteitem,
                #TabsToolbar > toolbarbutton {
                min-height: unset !important;
                padding: unset !important;
                margin: 0 2px !important;
                }

                #TabsToolbar > toolbarpaletteitem .toolbarbutton-icon,
                #TabsToolbar > toolbarbutton .toolbarbutton-icon {
                min-width: 16px !important;
                width: unset !important;
                min-height: 16px !important;
                height: unset !important;
                padding: unset !important;
                margin: unset !important;
                }

                #TabsToolbar toolbarbutton .toolbarbutton-badge-stack .toolbarbutton-icon {
                width: 16px !important;
                height: 16px !important;
                }

                #TabsToolbar-customization-target > toolbarpaletteitem toolbarbutton .toolbarbutton-icon,
                #TabsToolbar-customization-target > toolbarbutton .toolbarbutton-icon {
                padding: unset !important;
                height: unset !important;
                width: unset !important;
                }

                /* indicator for multiselected tabs */
                .tabbrowser-tab[multiselected] .tab-stack .tab-content {
                box-shadow:	inset 2px 0 0 Highlight,
                                inset -2px 0 0 Highlight,
                                inset 0 2px 0 Highlight,
                                inset 0 -2px 0 Highlight !important;
                }

                /* remove non-required icon pending */
                .tab-icon-pending {
                display: none !important;
                }

                /* Fx65+ fixes */
                #main-window[sizemode="maximized"][tabsintitlebar] #TabsToolbar {
                margin-top: -3px !important;
                }

                #main-window #navigator-toolbox #titlebar #TabsToolbar > .toolbar-items {
                padding-top: 0 !important;
                margin-top: 0 !important;
                }

                @media (-moz-platform: windows-win10), (-moz-os-version: windows-win10) {
                #main-window[sizemode="maximized"] .titlebar-buttonbox-container {
                    margin-inline-end: -2px !important;
                }
                }

                #scrollbutton-up,
                #scrollbutton-down {
                width: unset !important;
                height: unset !important;
                padding: unset !important;
                }

                .tab-background,
                .tab-stack {
                min-height: unset !important;
                }

                #tabbrowser-tabs[overflow="true"] .tabbrowser-tab[pinned] :is(.tab-background,.tab-stack) {
                min-height: var(--tab-min-height) !important;
                }

                .tab-close-button {
                margin-inline-end: -6px !important;
                margin-inline-start: 2px !important;
                width: 14px !important;
                height: 14px !important;
                padding: 2px !important;
                border-radius: unset !important;
                }

                .tabbrowser-tab:is([selected],[multiselected]):hover,
                #tabbrowser-tabs:not([closebuttons=activetab]) > #tabbrowser-arrowscrollbox > .tabbrowser-tab:not([selected],[multiselected]):hover {
                --tab-label-mask-size: unset !important;
                }

                .tabbrowser-tab[selected]:not(:hover) .tab-label-container:not([labeldirection="rtl"]),
                #tabbrowser-tabs:not([closebuttons="activetab"]) .tabbrowser-tab:not(:hover,[pinned]) .tab-label-container:not([labeldirection="rtl"]){
                margin-inline-end: unset !important;
                }

                .tabbrowser-tab {
                padding-inline: initial !important;
                }

                .tab-background:-moz-lwtheme {
                border-radius: initial !important;
                margin-block: initial !important;
                }

                .tab-secondary-label {
                display: none !important;
                }

                /* Lightweight theme on tabs */
                #tabbrowser-tabs:not([movingtab]) > #tabbrowser-arrowscrollbox > .tabbrowser-tab > .tab-stack > .tab-background:is([selected],[multiselected]):-moz-lwtheme {
                background-color: var(--tab-selected-bgcolor, var(--toolbar-bgcolor)) !important;
                }

                #main-window:not([lwtheme-image="true"]) #tabbrowser-tabs:not([movingtab]) > #tabbrowser-arrowscrollbox > .tabbrowser-tab > .tab-stack > .tab-background:is([selected],[multiselected]):-moz-lwtheme {
                background-image: var(--toolbar-bgimage) !important;
                }

                /* restore border between navigation toolbar and tabs toolbar */
                #nav-bar:not(:-moz-lwtheme) {
                box-shadow: 0 calc(-1 * var(--tabs-navbar-shadow-size)) 0 var(--classic_squared_tabs-border2) !important;
                }

                #main-window:not(:-moz-lwtheme) #TabsToolbar #tabbrowser-tabs .tabbrowser-tab:not([selected],[multiselected]) .tab-stack .tab-content {
                box-shadow: inset 0 -1px 0 0 var(--classic_squared_tabs-border2) !important;
                }

                /* remove active tabs left and right tab border color when using lw-themes */
                :root:not([lwtheme-mozlightdark]) #TabsToolbar:not([brighttext]) #tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([selected],[multiselected]) > .tab-stack > .tab-background:-moz-lwtheme,
                :root:not([lwtheme-mozlightdark]) #TabsToolbar[brighttext] #tabbrowser-tabs:not([noshadowfortests]) .tabbrowser-tab:is([selected],[multiselected]) > .tab-stack > .tab-background:-moz-lwtheme {
                box-shadow: unset !important;
                }

                @media (-moz-platform: windows-win7), (-moz-os-version:windows-win7) {
                    #tabs-newtab-button:-moz-lwtheme,
                    .tabbrowser-tab:-moz-lwtheme {
                    color: var(--lwt-tab-text, var(--toolbar-color)) !important;
                    fill: var(--lwt-tab-text, var(--toolbar-color)) !important;
                    }
                }

                /* Fx 97+ height fix */
                #tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
                height: unset !important;
                }

                /* Fx 101+ */
                @media (-moz-platform: windows-win10), (-moz-os-version:windows-win10) {

                    #main-window[sizemode="maximized"][tabsintitlebar] #titlebar {
                    margin-top: -5px !important;
                    }

                    #main-window[sizemode="fullscreen"][tabsintitlebar] #titlebar {
                    margin-top: -3px !important;
                    }

                    #main-window[sizemode="maximized"][tabsintitlebar] #toolbar-menubar {
                    padding-top: 5px !important;
                    }

                    #main-window[sizemode="maximized"] #toolbar-menubar[inactive] + #TabsToolbar > .titlebar-buttonbox-container toolbarbutton {
                    padding-top: 10px !important;
                    padding-bottom: 6px !important;
                    }
                }

                /* Fx 105+ - remove Firefox-view-button from tabs toolbar */
                :root:not([privatebrowsingmode=temporary]) :is(toolbarbutton, toolbarpaletteitem) + #tabbrowser-tabs,
                :root[privatebrowsingmode=temporary] :is(toolbarbutton:not(#firefox-view-button), toolbarpaletteitem:not(#wrapper-firefox-view-button)) + #tabbrowser-tabs {
                border-inline-start: 0px solid color-mix(in srgb, currentColor 25%, transparent) !important;
                }

                :root:not([privatebrowsingmode=temporary]):not([firefoxviewhidden]) :is(#firefox-view-button, #wrapper-firefox-view-button) + #tabbrowser-tabs:not([overflow="true"]) {
                padding-inline-start: 0 !important;
                margin-inline-start: 0 !important;
                }

                #main-window:not([customizing]) #TabsToolbar #firefox-view-button {
                display: none !important;
                }

                #main-window[customizing] #TabsToolbar #firefox-view-button {
                list-style-image: url("chrome://branding/content/about-logo.png") !important;
                }

                #main-window[customizing] #TabsToolbar #firefox-view-button image {
                width: 16px !important;
                height: 16px !important;
                }

                /* Fx 106+*/
                #private-browsing-indicator-with-label {
                display: none !important;
                }

                /* center tab label vertically */
                .tab-label-container {
                padding-bottom: 2px !important
                }

                /* Fx 110 nonsense - remove line below active tab */
                #nav-bar:not([tabs-hidden="true"]) {
                position: unset !important;
                }

            /*  /* CUSTOM: Tabs below Address Bar
            /*    :root {
            /*    --tabs_toolbar_color_tabs_not_on_top: linear-gradient(#f9f9fa,#f9f9fa);
            /*    --tab-min-height_tnot: 32px;
            /*    --tab_below_navigation_toolbar_bottom_padding: calc( var(--tab-min-height_tnot) + 5px );
            /*    }
            /*
            /*    #TabsToolbar {
            /*    position: absolute;
            /*    display: block;
            /*    bottom: 0;
            /*    width: 100vw;
            /*    background-clip: padding-box;
            /*    color: var(--toolbar-color);
            /*    z-index: 2;
            /*    }
            /*
            /*    /* overrides other settings too */
            /*    #main-window:not(:-moz-lwtheme) #navigator-toolbox #TabsToolbar:not(:-moz-lwtheme){
            /*    appearance: none;
            /*    background-image: var(--tabs_toolbar_color_tabs_not_on_top) !important;
            /*    }
            /*
            /*    #main-window:not([tabsintitlebar]) #TabsToolbar:not(:-moz-lwtheme){
            /*    appearance: none !important;
            /*    }
            /*
            /*    #tabbrowser-tabs {
            /*    width: 100%;
            /*    }
            /*
            /*    #navigator-toolbox {
            /*    position: relative;
            /*    padding-bottom: var(--tab_below_navigation_toolbar_bottom_padding);
            /*    }
            /*
            /*    #main-window[tabsintitlebar]:not([inDOMFullscreen="true"]) #titlebar,
            /*    #main-window[tabsintitlebar][sizemode="maximized"]:not([inDOMFullscreen="true"]) #titlebar {
            /*    height: 26px;
            /*    }
            /*
            /*    /* prevent possible item overlapping with caption buttons */
            /*    #main-window[tabsintitlebar] #toolbar-menubar {
            /*    padding-inline-end: 140px;
            /*    }
            /*
            /*    /* move caption buttons to windows top right position */
            /*    .titlebar-buttonbox-container {
            /*    position: fixed;
            /*    right: 0;
            /*    visibility: visible;
            /*    display: block;
            /*    }
            /*
            /*    #TabsToolbar .titlebar-buttonbox-container,
            /*    #TabsToolbar .private-browsing-indicator,
            /*    #TabsToolbar #window-controls,
            /*    #TabsToolbar *[type="caption-buttons"],
            /*    #TabsToolbar *[type="pre-tabs"],
            /*    #TabsToolbar *[type="post-tabs"] {
            /*    display: none;
            /*    }
            /*
            /*    /* lw themes support */
            /*    #nav-bar {
            /*    box-shadow: unset !important;
            /*    }
            /*
            /*    /* remove color overlay for lw-themes */
            /*    #main-window[style*='--lwt-header-image'] :is(#nav-bar,#PersonalToolbar,#TabsToolbar):-moz-lwtheme{
            /*    background: unset !important;
            /*    }
            /*
            /*    /* adjust background color */
            /*    #main-window:not([style*='--lwt-header-image']) #TabsToolbar:-moz-lwtheme {
            /*    appearance: none !important;
            /*    background-image: linear-gradient(var(--toolbar-bgcolor),var(--toolbar-bgcolor)) !important;
            /*    }
            /*
            /*    /* Fixes for projects other settings */
            /*    /* remove application/hamburger button in titlebar and tab toolbars start padding */
            /*    #main-window[tabsintitlebar][sizemode="fullscreen"] #navigator-toolbox #PanelUI-button {
            /*    visibility: collapse;
            /*    }
            /*
            /*    /* override code inside appbutton in titlebar code */
            /*    #main-window[tabsintitlebar] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar,
            /*    #main-window[tabsintitlebar][sizemode="maximized"] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar,
            /*    #main-window[tabsintitlebar][sizemode="fullscreen"] #TabsToolbar,
            /*    #main-window[uidensity=compact][tabsintitlebar] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar,
            /*    #main-window[uidensity=compact][tabsintitlebar][sizemode="maximized"] #toolbar-menubar[autohide="true"][inactive="true"] ~ #TabsToolbar,
            /*    #main-window[tabsintitlebar]:is([sizemode="normal"],[sizemode="maximized"],[sizemode="fullscreen"]) #navigator-toolbox #TabsToolbar {
            /*    padding-inline-start: 0px !important;
            /*    margin-inline-start: 0px !important;
            /*    }
            /*
            /*    /* remove restored border between navigation toolbar and tabs toolbar */
            /*    #nav-bar:not(:-moz-lwtheme) {
            /*    box-shadow: unset !important;
            /*    }
            /*
            /*    /* notification position */
            /*    #tab-notification-deck {
            /*    position: absolute;
            /*    display: block;
            /*    bottom: calc( -2 * var(--tab_below_navigation_toolbar_bottom_padding) + 8px );
            /*    width: 100vw;
            /*    }
            /*    /*
            /*    #TabsToolbar #tabbrowser-arrowscrollbox {
            /*    margin-top: 1px !important;
            /*    margin-bottom: -1px !important;
            /*    }
            /*    */
            /*
            /*    /* Fx 105+ */
            /*    :root:not([privatebrowsingmode=temporary]) :is(toolbarbutton, toolbarpaletteitem) + #tabbrowser-tabs,
            /*    :root[privatebrowsingmode=temporary] :is(toolbarbutton:not(#firefox-view-button), toolbarpaletteitem:not(#wrapper-firefox-view-button)) + #tabbrowser-tabs {
            /*    border-inline-start: 0px solid color-mix(in srgb, currentColor 25%, transparent) !important;
            /*    }
            /*
            /*    :root:not([privatebrowsingmode=temporary]):not([firefoxviewhidden]) :is(#firefox-view-button, #wrapper-firefox-view-button) + #tabbrowser-tabs:not([overflow="true"]) {
            /*    padding-inline-start: 0 !important;
            /*    margin-inline-start: 0 !important;
            /*    }
            /*
            /*    /* Fx 106+ */
            /*    #private-browsing-indicator-with-label {
            /*    display: none !important;
            /*    }
            /*
            */

            /* CUSTOM: Set Default size of Sidebar */
            #sidebar-box {
              max-width: none !important;
              min-width: 0px !important;
              width: 350px !important;
            }

             /* CUSTOM: Disable Tab Bar */
             /* hides the native tabs */
                #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
                  opacity: 0;
                  pointer-events: none;
                }
                #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
                    visibility: collapse !important;
                }
                #sidebar-box[sidebarcommand="treestyletab_piro_sakura_ne_jp-sidebar-action"] #sidebar-header {
                  display: none;
                }
                .tab {
                  margin-left: 1px;
                  margin-right: 1px;
                 }
                /* This below removes the top menu bar however also removes the Firefox Button */
                #TabsToolbar { visibility: collapse !important; }
                #PanelUI-button,
                #PanelUI-menu-button {
                  visibility: collapse !important;
                  min-width: 0.1px !important;
                  width: 0.1px !important;
                  max-width: 0.1px !important;
                  opacity: 0 !important;
                }

                /* /* CUSTOM: Auto Open on Hover Sidebar */
                /* #sidebar-box {
                /* --sidebar-hover-width: 40px;
                /* position: relative !important;
                /* overflow-x: hidden !important;
                /* margin-right: calc(var(--sidebar-hover-width) * -1) !important;
                /* min-width: var(--sidebar-hover-width) !important;
                /* max-width: var(--sidebar-hover-width) !important;
                /* border-right: 1px solid var(--sidebar-border-color);
                /* z-index:2147483647 !important;
                /* }
                /*
                /* #sidebar-box:hover {
                /* --sidebar-visible-width: 200px;
                /* margin-right: calc(var(--sidebar-visible-width) * -1) !important;
                /* min-width: var(--sidebar-visible-width) !important;
                /* max-width: var(--sidebar-visible-width) !important;
                /* }
                /*
                /* #sidebar {
                /* opacity: 1 !important;
                /* }
                /*
                /* #sidebar-box:hover #sidebar {
                /* opacity: 1 !important;
                /* }
                /*
                /* /* #sidebar-header is hidden by default, change "none" to "inherit" to restore it. */
                /* #sidebar-header {
                /* display: none !important;
                /* }
                /*
                /* /* #sidebar-splitter styles the divider between the sidebar and the rest of the browser. */
                /* #sidebar-splitter {
                /* display: none;
                /* }
                */

            /* CUSTOM: Show Favicon for tabs without Favicons */
                .tabbrowser-tab:not([pinned]) .tab-icon-image:not([src]) {
                    display: inline !important;
                }

                .tabbrowser-tab:not([pinned])[busy] .tab-icon-image {
                    display: none !important;
                }

            /* CUSTOM: Tab close button always visible */
                #TabsToolbar #tabbrowser-tabs .tabbrowser-tab:not([pinned]) .tab-close-button {
                    visibility: visible !important;
                    display: block !important;
                }
                #TabsToolbar #tabbrowser-tabs .tabbrowser-tab:not([pinned])[faviconized="true"] .tab-close-button {
                    visibility: collapse !important;
                    display: none !important;
                }

            /* CUSTOM: Tab Icon Colours */
                .tabbrowser-tab .tab-icon-image[src="chrome://mozapps/skin/extensions/extension.svg"] {
                fill: green !important;
                }

                .tabbrowser-tab .tab-icon-image[src="chrome://global/skin/icons/settings.svg"] {
                fill: grey !important;
                }

            /* CUSTOM: Hide Private mode indicators / masks */
                #main-window[privatebrowsingmode=temporary]:not([inDOMFullscreen="true"]) #navigator-toolbox #TabsToolbar .private-browsing-indicator,
                * #private-browsing-indicator-titlebar,
                * #private-browsing-indicator,
                * .private-browsing-indicator {
                    visibility: collapse !important;
                }

                #private-browsing-indicator-with-label {
                    display: none !important;
                }

            /* CUSTOM: LINUX GTK - Maximize and Minimize and Close buttons */
                .titlebar-buttonbox{
                    -moz-box-align: stretch !important; /* Fx <112 compatibility */
                    align-items: stretch !important;
                }
                .titlebar-button {
                    -moz-appearance: none !important;
                    -moz-context-properties: fill, stroke, fill-opacity;
                    fill: currentColor;
                    padding: 4px 6px !important;
                    -moz-box-flex: 1;
                    flex-grow: 1;
                    overflow: -moz-hidden-unscrollable;
                }
                .titlebar-button:hover{ display:none }
                .titlebar-min { display:none  }
                .titlebar-close{ display: none);
                }
                */

            /* CUSTOM: Bookmark icons colorized */

                .folder-icon,
                #editBMPanel_chooseFolderMenuItem .menu-iconic-icon,
                treechildren::-moz-tree-image(title, container),
                treechildren::-moz-tree-image(title, query, hostContainer) {
                list-style-image: url("./../../image/folder-item.png")!important;
                }

                treechildren::-moz-tree-image(title, open) {
                list-style-image: url("./../../image/folder-item2.png")!important;
                }

                treechildren::-moz-tree-image(title, container, livemark) {
                list-style-image: url("./../../image/feedIcon16.png") !important;
                }

                #editBMPanel_folderMenuList:-moz-any([label="Bookmarks Toolbar"],[label="Lesezeichen-Symbolleiste"]) .menulist-icon,
                #editBMPanel_toolbarFolderItem .menu-iconic-icon,
                treechildren::-moz-tree-image(container, OrganizerQuery_BookmarksToolbar),
                treechildren::-moz-tree-image(container, queryFolder_toolbar_____) {
                list-style-image: url("./../../image/bookmarksToolbar.png") !important;
                }

                #editBMPanel_folderMenuList:-moz-any([label="Bookmarks Menu"],[label="Lesezeichen-Menü"]) .menulist-icon,
                #editBMPanel_bmRootItem .menu-iconic-icon,
                treechildren::-moz-tree-image(container, OrganizerQuery_BookmarksMenu),
                treechildren::-moz-tree-image(container, queryFolder_menu________) {
                list-style-image: url("./../../image/bookmarksMenu.png") !important;
                }

                #editBMPanel_folderMenuList:-moz-any([label="Other Bookmarks"],[label="Weitere Lesezeichen"]) .menulist-icon,
                #editBMPanel_unfiledRootItem .menu-iconic-icon,
                treechildren::-moz-tree-image(container, OrganizerQuery_UnfiledBookmarks),
                treechildren::-moz-tree-image(container, queryFolder_unfiled_____) {
                list-style-image: url("./../../image/unsortedBookmarks.png") !important;
                }

                treechildren::-moz-tree-image(title, query),
                treechildren::-moz-tree-image(query) {
                list-style-image: url("./../../image/query.png") !important;
                }

                treechildren::-moz-tree-image(title, query, dayContainer) {
                list-style-image: url("./../../image/calendar.png") !important;
                }

                treechildren::-moz-tree-image(query, OrganizerQuery_History),
                treechildren::-moz-tree-image(query, OrganizerQuery_history____v),
                treechildren::-moz-tree-image(title, query, dayContainer) {
                list-style-image: url("./../../image/calendar.png") !important;
                }

                treechildren::-moz-tree-image(query, OrganizerQuery_allbms_____v) {
                list-style-image: url("chrome://browser/skin/bookmark.svg") !important;
                }

                treechildren::-moz-tree-image(query, OrganizerQuery_downloads__v) {
                list-style-image: url("chrome://browser/skin/downloads/downloads.svg") !important;
                }

                toolbarbutton.bookmark-item[container],
                .bookmark-item[container] .menu-iconic-left .menu-iconic-icon {
                list-style-image: url("./../../image/folder-item.png") !important;
                }

                toolbarbutton.bookmark-item[container][open],
                .bookmark-item[container][open] .menu-iconic-left .menu-iconic-icon {
                list-style-image: url("./../../image/folder-item2.png")!important;
                }

                .bookmark-item[container][livemark] {
                list-style-image: url("./../../image/livemark-folder.png") !important;
                }
                .bookmark-item[container][livemark] .bookmark-item {
                list-style-image: url("./../../image/livemark-item.png") !important;
                }
                .bookmark-item[container][livemark] .bookmark-item[visited] {
                list-style-image: url("./../../image/livemark-item2.png") !important;
                }

                .bookmark-item[container][query],
                .bookmark-item[container][query][open],
                .bookmark-item[container][query] > .menu-iconic-left > .menu-iconic-icon,
                .bookmark-item[container][query][open] > .menu-iconic-left > .menu-iconic-icon {
                list-style-image: url("./../../image/query.png") !important;
                }

                treechildren::-moz-tree-image(title, query, tagContainer),
                treechildren::-moz-tree-image(query, OrganizerQuery_tags_______v),
                .bookmark-item[query][tagContainer] {
                list-style-image: url("./../../image/tag.png") !important;
                }

                .bookmark-item[query][dayContainer] {
                list-style-image: url("./../../image/calendar.png") !important;
                }

                .bookmark-item[query][hostContainer] {
                list-style-image: url("./../../image/folder-item.png") !important;
                }

                .bookmark-item[query][hostContainer][open] {
                list-style-image: url("./../../image/folder-item2.png") !important;
                }

                /* Bookmarks roots menu-items */
                #subscribeToPageMenuitem:not([disabled]),
                #subscribeToPageMenupopup {
                list-style-image: url("./../../image/feedIcon16.png") !important;
                }

                #bookmarksToolbarFolderMenu > .menu-iconic-left > .menu-iconic-icon,
                #BMB_bookmarksToolbar > .menu-iconic-left > .menu-iconic-icon,
                #panelMenu_bookmarksToolbar {
                list-style-image: url("./../../image/bookmarksToolbar.png") !important;
                }

                #menu_unsortedBookmarks > .menu-iconic-left > .menu-iconic-icon,
                #BMB_unsortedBookmarks > .menu-iconic-left > .menu-iconic-icon,
                #panelMenu_unsortedBookmarks {
                list-style-image: url("./../../image/unsortedBookmarks.png") !important;
                }


            /* CUSTOM: Toolbar Padding */
                #navigator-toolbox > toolbar:not(#toolbar-menubar):not(#TabsToolbar):not(#nav-bar) {
                padding-left: 0px !important;
                padding-right: 0px !important;
                }

                #navigator-toolbox > #PersonalToolbar {
                min-height: 28px !important;
                padding-top: 1px !important;
                padding-bottom: 1px !important;
                }

            /* CUSTOM: Toolbar Adjustments for Tabs */
                /* Fx58+ titlebar placeholders */
                #TabsToolbar .titlebar-placeholder[type="pre-tabs"],
                #TabsToolbar .titlebar-placeholder[type="post-tabs"]{
                min-width: 0 !important;
                width: 0 !important;
                max-width: 0 !important;
                }

                #TabsToolbar .titlebar-placeholder[type="caption-buttons"] {
                margin-inline-start: 2px !important;
                }

                /* tab toolbar position */
                #TabsToolbar{
                padding-right: 2px !important;
                padding-left: 2px !important;
                min-height: unset !important;
                }

                /* code for Unix (macOS/Linux) */
                @media (not (-moz-os-version: windows-win10)) and (not (-moz-os-version: windows-win8)) and (not (-moz-os-version: windows-win7)) {
                    #TabsToolbar .titlebar-placeholder[type="caption-buttons"]:not([ordinal="1000"]) {
                    margin-inline-start: 24px !important;
                    }
                }

                @media not (-moz-platform: windows) {
                    #TabsToolbar .titlebar-placeholder[type="caption-buttons"]:not([ordinal="1000"]) {
                    margin-inline-start: 24px !important;
                    }
                }

            /* CUSTOM: Searchbar on Menu bar */
                #toolbar-menubar .toolbarbutton-1 .toolbarbutton-icon {
                padding: 0 !important;
                margin: 0 !important;
                width: 16px !important;
                height: 16px !important;
                }

                #main-window[tabsintitlebar][sizemode="maximized"] #toolbar-menubar #searchbar {
                min-height: 22px !important;
                }

                #toolbar-menubar #search-container {
                padding-block: 0.5px !important;
                }

            /* CUSTOM: Bookmarks toolbar height */
                #PersonalToolbar {
                    min-height: 26px !important;
                }

            /* CUSTOM: Toolbar Colours */
                :root {
                --general_toolbar_color_toolbars: linear-gradient(#f9f9fa,#f9f9fa);
                --general_toolbar_color_navbar: linear-gradient(#f9f9fa,#f9f9fa);
                --general_toolbar_text_color: inherit;
                --general_toolbar_text_shadow: transparent;
                }

                #nav-bar:not(:-moz-lwtheme) {
                appearance: none !important;
                background: var(--general_toolbar_color_navbar, inherit) !important;
                }

                #main-window toolbar:not(:-moz-lwtheme):not(#TabsToolbar):not(#toolbar-menubar):not(#nav-bar) {
                appearance: none !important;
                background: var(--general_toolbar_color_toolbars, inherit) !important;
                }

                #nav-bar:not(:-moz-lwtheme) #urlbar ::-moz-selection {
                background-color: Highlight !important;
                color: HighlightText !important;
                }

                /**/

                #main-window:not(:-moz-lwtheme) #PersonalToolbar #bookmarks-menu-button::after,
                #main-window:not(:-moz-lwtheme) toolbar > toolbarbutton > .toolbarbutton-text,
                #main-window:not(:-moz-lwtheme) toolbar #stop-reload-button toolbarbutton > .toolbarbutton-text,
                #main-window:not(:-moz-lwtheme) toolbar #PanelUI-button toolbarbutton > .toolbarbutton-text,
                #main-window:not(:-moz-lwtheme) toolbar > toolbarbutton >.toolbarbutton-badge-stack .toolbarbutton-text,
                #main-window:not(:-moz-lwtheme) #nav-bar-customization-target > toolbarbutton > .toolbarbutton-text,
                #main-window:not(:-moz-lwtheme) #PlacesToolbarItems toolbarbutton > :is(label,description) {
                color: var(--general_toolbar_text_color, inherit) !important;
                text-shadow: 1px 1px 1px var(--general_toolbar_text_shadow, inherit) !important;
                }

                /* findbar */
                #main-window :is(.browserContainer,#viewSource):not(:-moz-lwtheme) :is(findbar,#FindToolbar) {
                background: var(--general_toolbar_color_toolbars, inherit) !important;
                }

                #main-window[style*='--lwt-header-image']:-moz-lwtheme :is(.browserContainer,#viewSource) :is(findbar,#FindToolbar) {
                background: var(--lwt-header-image) !important;
                background-position: calc(100vw - 5px) !important;
                }

                #main-window[style*='--lwt-header-image']:-moz-lwtheme :is(.browserContainer,#viewSource) :is(findbar,#FindToolbar) :is(.toolbarbutton-icon,.toolbarbutton-text) {
                color: var(--lwt-text-color) !important;
                fill: var(--lwt-text-color) !important;
                }
                #main-window[style*='--lwt-header-image']:-moz-lwtheme-brighttext :is(.browserContainer,#viewSource) :is(findbar,#FindToolbar) :is(.toolbarbutton-icon,.toolbarbutton-text) {
                text-shadow: 1px 1px 1px black !important;
                }

                @media (-moz-content-prefers-color-scheme: dark) {
                    #main-window[style*='--lwt-header-image']:-moz-lwtheme :is(.browserContainer,#viewSource) :is(findbar,#FindToolbar) :is(.toolbarbutton-icon,.toolbarbutton-text) {
                    text-shadow: 1px 1px 1px black !important;
                    }
                }


                .browserContainer > findbar > #findbar-close-container {
                background-color: unset !important;
                }

                /* fix Firefox + Windows 8.1 + lw-theme bug (occurring without custom code too) */
                @media (-moz-platform: windows-win8), (-moz-os-version:windows-win8) {
                    #navigator-toolbox:-moz-lwtheme {
                    border: unset !important;
                    }
                }
            /* CUSTOM: URL Bar disable breakout */
                #urlbar[breakout][breakout-extend] {
                top: calc((var(--urlbar-toolbar-height) - var(--urlbar-height)) / 2) !important;
                left: 0px !important;
                width: calc(100% - 0px) !important;
                }

                #urlbar[breakout][breakout-extend] > #urlbar-background {
                animation-name: unset !important;
                }

                #urlbar[breakout][breakout-extend] > #urlbar-input-container {
                height: var(--urlbar-height) !important;
                padding-block: 1px !important;
                padding-inline: 1px !important;
                }

                /* disable result item roundness */
                #urlbar[breakout] .urlbarView-row-inner {
                border-radius: 0px !important;
                }

                /* disable 'breakout' animation */
                #urlbar[breakout],
                #urlbar[breakout] * {
                animation: unset !important;
                duration: 0s !important;
                animation-duration: 0s !important;
                }

                .urlbarView-body-inner {
                border-top: 0px !important;
                }

            /* CUSTOM: URL Bar restore visible border */
                :root{
                --urlbar_border_color: var(--chrome-content-separator-color);
                }

                #urlbar:not([focused="true"]) #urlbar-background,
                #urlbar[open="true"] #urlbar-background,
                #urlbar[focused="true"][open="true"] #urlbar-background,
                #searchbar:not(:focus-within) {
                border: 1px solid var(--urlbar_border_color) !important;
                }

                #urlbar[focused="true"][suppress-focus-border] > #urlbar-input-container {
                border-top: 1px solid var(--urlbar_border_color) !important;
                border-left: 1px solid var(--urlbar_border_color) !important;
                border-right: 1px solid var(--urlbar_border_color) !important;
                }

                #urlbar[focused="true"][suppress-focus-border][open="true"] > #urlbar-input-container {
                border-bottom-left-radius: 0px !important;
                border-bottom-right-radius: 0px !important;
                }

            /* CUSTOM: URL and Megabar Title 50 percent width */
                #urlbar .urlbarView-no-wrap,
                #urlbar .urlbarView-url {
                min-width: 50% !important;
                width: 50% !important;
                }

                #urlbar .urlbarView-url {
                margin-inline-start: 10px !important;
                }

                #urlbar .urlbarView-row:not([has-url="true"]) .urlbarView-no-wrap {
                min-width: 100% !important;
                width: 100% !important;
                }

                #urlbar .urlbarView-row[type="switchtab"][has-url="true"] .urlbarView-no-wrap .urlbarView-action,
                #urlbar .urlbarView-row:not([has-url="true"]) .urlbarView-no-wrap .urlbarView-action {
                position: absolute !important;
                display: block !important;
                left: calc(50% + 10px) !important; /* 50% + 10px url space */
                }

                #urlbar .urlbarView-results[wrap] .urlbarView-row[type="switchtab"][has-url="true"] .urlbarView-no-wrap .urlbarView-action,
                #urlbar .urlbarView-results[wrap] .urlbarView-row:not([has-url="true"]) .urlbarView-no-wrap .urlbarView-action {
                left: calc(50% + 0px) !important;
                }

                #urlbar .urlbarView-results[wrap] > .urlbarView-row[has-url] > .urlbarView-row-inner > .urlbarView-url {
                margin-inline-start: unset !important;
                }

                #urlbar .urlbarView-title-separator {
                display: none !important;
                }

                #urlbar .urlbarView-row:is([type=search],[type=remotetab],[type=switchtab],[type=dynamic],[sponsored]) .urlbarView-title {
                width: calc(50% - 26px) !important;
                }

                /* do not hide actiontype item */
                #urlbar .urlbarView-action{
                visibility: visible !important;
                display: inherit !important;
                }

                /* do not wrap the line */
                #urlbar .urlbarView-results[wrap] > .urlbarView-row > .urlbarView-row-inner {
                flex-wrap: unset !important;
                }
                #urlbar .urlbarView-results[wrap] > .urlbarView-row > .urlbarView-row-inner > .urlbarView-no-wrap {
                max-width: unset !important;
                flex-basis: unset !important;
                }
                #urlbar .urlbarView-results[wrap] > .urlbarView-row[has-url] > .urlbarView-row-inner > .urlbarView-url {
                margin-top: unset !important;
                padding-inline-start: unset !important;
                }

                #urlbar .urlbarView-results > .urlbarView-row[type=remotetab] > .urlbarView-row-inner > .urlbarView-no-wrap > .urlbarView-action {
                appearance: none !important;
                background: unset !important;
                }

                #urlbar .urlbarView-row[dynamicType=onboardTabToSearch] > .urlbarView-row-inner {
                min-height: unset !important;
                }

                .urlbarView-row[dynamicType=onboardTabToSearch] > .urlbarView-row-inner > .urlbarView-no-wrap > .urlbarView-favicon {
                min-width: unset !important;
                height: unset !important;
                }

                .urlbarView-dynamic-onboardTabToSearch-description {
                display: none !important;
                }

                /* use different width values to go from  50/50 to e.g. 40/60 */
                /*
                #urlbar .urlbarView-no-wrap {
                min-width: 40% !important;
                width: 40% !important;
                }
                #urlbar .urlbarView-url {
                min-width: 60% !important;
                width: 60% !important;
                }

                #urlbar .urlbarView-row[type="switchtab"][has-url="true"] .urlbarView-no-wrap .urlbarView-action,
                #urlbar .urlbarView-row:not([has-url="true"]) .urlbarView-no-wrap .urlbarView-action {
                position: absolute !important;
                display: block !important;
                left: calc(40% + 10px) !important;
                }
                #urlbar .urlbarView-results[wrap] .urlbarView-row[type="switchtab"][has-url="true"] .urlbarView-no-wrap .urlbarView-action,
                #urlbar .urlbarView-results[wrap] .urlbarView-row:not([has-url="true"]) .urlbarView-no-wrap .urlbarView-action {
                left: calc(40% + 0px) !important;
                }
                */
            /* CUSTOM: URL Bar compact results */
                /* disable useless space wasting inside popup */
                #urlbar[breakout][breakout-extend] > .urlbarView {
                padding: unset !important;
                margin: unset !important;
                }

                #urlbar[breakout] .urlbarView {
                margin-inline: unset !important;
                width: 100% !important;
                }

                /* disable space wasting inside popup around result items */
                #urlbar[breakout] #urlbar-results {
                padding: 0px !important;
                margin: 0px !important;
                }
                #urlbar[breakout] #urlbar-results .urlbarView-body-outer,
                #urlbar[breakout] #urlbar-results .urlbarView-row,
                #urlbar[breakout] #urlbar-results .urlbarView-row-inner {
                margin-inline-start: 0 !important;
                padding-inline-start: 0 !important;
                margin-inline-end: 0 !important;
                padding-inline-end: 0 !important;
                }

                #urlbar[breakout] #urlbar-results .urlbarView-row-inner {
                padding-inline-start: 4px !important;
                padding-inline-end: 4px !important;
                }

                #urlbar[breakout] .urlbarView-row {
                padding-block: 0px !important;
                }

                /* disable space wasting inside popup around search engines */
                #urlbar[breakout] .search-one-offs {
                padding-top: 0px !important;
                padding-bottom: 0px !important;
                }

            /* CUSTOM Allow Bookmark Bar in Fullscreen */
                #navigator-toolbox[inFullscreen="true"] #PersonalToolbar {
                    visibility: unset !important;
                }
          '';

          userContent = "\n";
        };
        ireen = mkIf (username == "ireen") {
          name = username;
          isDefault = true;
          search = {
            force = true;
            default = "Google";
            engines = {
              "Wikipedia (en)".metaData.alias = "@wiki";
              "Google".metaData.hidden = true;
            };
          };

          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            bitwarden
            clearurls
            copy-selected-links
            decentraleyes
            facebook-container
            floccus
            multi-account-containers
            image-search-options
            ublock-origin
            undoclosetabbutton
            user-agent-string-switcher

            ### Missing:
            ## Canadian English Dictionary dictionary 3.1.3 true en-CA@dictionaries.addons.mozilla.org
            ## Download Manager (S3) extension 5.12 true s3download@statusbar
            ## F.B Purity - Cleans up Facebook extension 36.8.0.0 true fbpElectroWebExt@fbpurity.com
            ## Hard Refresh Button extension 1.0.0 true {b6da57d3-9727-4bc0-b974-d13e7c004af0}
            ## Open With extension 7.2.6 true openwith@darktrojan.net
            ## Rakuten Canada Button extension 7.8.1 true ebatesca@ebates.com
            ## StockTrack.ca plugin extension 0.2.4 true {50b98f8c-707d-4dd8-86e4-7c0e15745027}
            ## The Camelizer extension 3.0.15 true izer@camelcamelcamel.com
            ## Language: English (CA) locale 114.0.20230608.214645 false langpack-en-CA@firefox.mozilla.org
          ];

          settings = {
            # Disable Telemetry (https://support.mozilla.org/kb/share-telemetry-data-mozilla-help-improve-firefox) sends data about the performance and responsiveness of Firefox to Mozilla.
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.rejected" = true;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.unifiedIsOptIn" = false;
            "toolkit.telemetry.prompted" = 2;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.cachedClientID" = "";
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            # Disable health report - Disable sending Firefox health reports(https://www.mozilla.org/privacy/firefox/#health-report) to Mozilla.
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "datareporting.healthreport.service.enabled" = false;
            # Disable shield studies (https://wiki.mozilla.org/Firefox/Shield) is a feature which allows mozilla to remotely install experimental addons.
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";
            "app.shield.optoutstudies.enabled" = false;
            "extensions.shield-recipe-client.enabled" = false;
            "extensions.shield-recipe-client.api_url" = "";
            # Disable experiments (https://wiki.mozilla.org/Telemetry/Experiments) allows automatically download and run specially-designed restartless addons based on certain conditions.
            "experiments.enabled" = false;
            "experiments.manifest.uri" = "";
            "experiments.supported" = false;
            "experiments.activeExperiment" = false;
            "network.allow-experiments" = false;
            # Disable Crash Reports (https://www.mozilla.org/privacy/firefox/#crash-reporter) as it may contain data that identifies you or is otherwise sensitive to you.
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
            "browser.crashReports.unsubmittedCheck .autoSubmit2" = false;
            "extensions.getAddons.cache.enabled" = false; # Opt out metadata updates about installed addons as metadata updates (https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/), so Mozilla is able to recommend you other addons.
            # Disable google safebrowsing - Detect phishing and malware but it also sends informations to google together with an unique id called wrkey (http://electroholiker.de/?p=1594).
            "browser.safebrowsing.enabled" = false;
            "browser.safebrowsing.downloads.remote.url" = "";
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.safebrowsing.blockedURIs.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "browser.safebrowsing.appRepURL" = "";
            "browser.safebrowsing.malware.enabled" = false; # Disable malware scan -  sends an unique identifier for each downloaded file to Google.
            "network.trr.mode" = 5; # Disable DNS over HTTPS  aka. Trusted Recursive Resolver (TRR)
            "network.captive-portal-service.enabled" = false; # Disable check for captive portal. By default, Firefox checks for the presence of a captive portal on every startup.  This involves traffic to Akamai. (https://support.mozilla.org/questions/1169302).
            "browser.urlbar.groupLabels.enabled" = false; # Disable Firefox Suggest(https://support.mozilla.org/en-US/kb/navigate-web-faster-firefox-suggest) feature allows Mozilla to provide search suggestions in the US, which uses your city location and search keywords to send suggestions. This is also used to serve advertisements.
            "browser.urlbar.quicksuggest.enabled" = false; # Disable Firefox Suggest(https://support.mozilla.org/en-US/kb/navigate-web-faster-firefox-suggest) feature allows Mozilla to provide search suggestions in the US, which uses your city location and search keywords to send suggestions. This is also used to serve advertisements.

            ## Security
            "app.update.auto" = true; # Disable automatic updates.
            "browser.aboutConfig.showWarning" = false; # Disable about:config warning.
            "browser.disableResetPrompt" = true; # Disable reset prompt.
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false; # Disable Pocket
            "browser.newtabpage.enhanced" = false; # Content of the new tab page
            "browser.newtabpage.introShown" = false; # Disable the intro to the newtab page on the first run
            "browser.selfsupport.url" = ""; # Disable Heartbeat Userrating
            "browser.shell.checkDefaultBrowser" = false; # Disable checking if Firefox is the default browser
            "browser.startup.homepage_override.mstone" = "ignore"; # Disable the first run tabs with advertisements for the latest firefox features.
            "browser.urlbar.trimURLs" = false; # Do not trim URLs in navigation bar
            "dom.security.https_only_mode" = true; # Enable HTTPS only mode
            "dom.security.https_only_mode_ever_enabled" = true; # Enable HTTPS only mode
            "extensions.blocklist.enabled" = false; # Disable extension blocklist from mozilla.
            "extensions.pocket.enabled" = false; # Disable Pocket
            "media.autoplay.default" = 0; # Disable autoplay of video tags.
            "media.autoplay.enabled" = true; # Disable autoplay of video tags.
            "network.IDN_show_punycode" = true; # Show Punycode.
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false; # Disable Sponsored Top Sites

            ## Extra Settings
            "browser.cache.disk.enable" = false;
            "browser.compactmode.show" = true;
            "browser.download.always_ask_before_handling_new_types" = true;
            "browser.engagement.ctrlTab.has-used" = true;
            "browser.engagement.downloads-button.has-used" = true;
            "browser.engagement.fxa-toolbar-menu-button.has-used" = true;
            "browser.engagement.library-button.has-used" = true;
            "browser.formfill.enable" = false;
            "browser.tabs.closeTabByDblclick" = true;
            "browser.tabs.insertAfterCurrent" = true;
            "browser.tabs.loadBookmarksInTabs" = true;
            "browser.tabs.tabmanager.enabled" = false; # Tab
            "browser.tabs.warnOnClose" = false;
            "browser.toolbars.bookmarks.visibility" = "always";
            "browser.uitour.enabled" = false;
            "browser.urlbar.clickSelectsAll" = true;
            "browser.urlbar.suggest.quickactions" = false; # URL Suggestions
            "browser.urlbar.suggest.topsites" = false; # URL Suggestions
            "devtools.everOpened" = true;
            "extensions.formautofill.addresses.enabled" = false;
            "extensions.formautofill.creditCards.enabled" = false;
            "extensions.formautofill.heuristics.enabled" = false;
            "extensions.screenshots.disabled" = true;
            "font.internaluseonly.changed" = false; # Fonts
            "font.name.monospace.x-western" = "Droid Sans Mono"; # Fonts
            "font.name.sans-serif.x-western" = "Noto Sans"; # Fonts
            "font.name.serif.x-western" = "Noto Sans"; # Fonts
            "font.size.fixed.x-western" = "11"; # Fonts
            "font.size.variable.x-western" = "15"; # Fonts
            "general.smoothScroll" = true; # enable smooth scrolling
            "gfx.webrender.all" = true; # Force using WebRender. Improve performance
            "gfx.webrender.enabled" = true; # Force using WebRender. Improve performance
            "media.ffmpeg.vaapi.enabled" = true; # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
            "media.ffvpx.enabled" = false; # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
            "media.videocontrols.picture-in-picture.allow-multiple" = true; # Enable multi-pip
            "pref.general.disable_button.default_browser" = false;
            "pref.privacy.disable_button.cookie_exceptions" = false;
            "pref.privacy.disable_button.tracking_protection_exceptions" = false;
            "pref.privacy.disable_button.view_passwords" = false;
            "print.more-settings.open" = true;
            "privacy.clearOnShutdown.cache" = false; # Privacy
            "privacy.clearOnShutdown.cookies" = false; # Privacy
            "privacy.clearOnShutdown.downloads" = false; # Privacy
            "privacy.clearOnShutdown.formdata" = false; # Privacy
            "privacy.clearOnShutdown.history" = false; # Privacy
            "privacy.clearOnShutdown.sessions" = false; # Privacy
            "privacy.cpd.cache" = false; # Privacy
            "privacy.cpd.cookies" = false; # Privacy
            "privacy.cpd.downloads" = false; # Privacy
            "privacy.cpd.formdata" = false; # Privacy
            "privacy.cpd.history" = false; # Privacy
            "privacy.cpd.offlineApps" = true; # Privacy
            "privacy.cpd.sessions" = false; # Privacy
            "privacy.donottrackheader.enabled" = true; # Privacy
            "privacy.history.custom" = true; # Privacy
            "privacy.partition.network_state.ocsp_cache" = true; # Privacy
            "privacy.trackingprotection.enabled" = true; # Privacy
            "privacy.trackingprotection.socialtracking.enabled" =
              true; # Privacy
            "privacy.userContext.enabled" = true; # Privacy
            "privacy.userContext.longPressBehavior" = "2"; # Privacy
            "privacy.userContext.newTabContainerOnLeftClick.enabled" =
              false; # Privacy
            "privacy.userContext.ui.enabled" = true; # Privacy
            "signon.management.page.breach-alerts.enabled" = false;
            "signon.rememberSignons" = false;
            "ui.context_menus.after_mouseup" = true;
            "widget.use-xdg-desktop-portal" = true;
          };

          extraConfig = ''
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
            user_pref("full-screen-api.ignore-widgets", true);
            user_pref("media.ffmpeg.vaapi.enabled", true);
            user_pref("media.rdd-vpx.enabled", true);
          '';

          userChrome = ''
            /* CUSTOM: General *?
                :root {

                /* for increase_ui_font_size.css */
                --general_ui_font_size: 10pt !important;

            /* CUSTOM: What's new button hidden always */
                #PanelUI-button #whats-new-menu-button {
                    display: none !important;
                }

          '';

          userContent = "\n";
        };
      };
    };

    wayland.windowManager.hyprland = {
      settings = {
        windowrulev2 = [
           ### Make Firefox PiP window floating and sticky
           "windowrulev2 = float, title:^(Picture-in-Picture)$"
           "windowrulev2 = pin, title:^(Picture-in-Picture)$"
           ### Throw sharing indicators away
           "windowrulev2 = workspace special silent, title:^(Firefox — Sharing Indicator)$"
           "windowrulev2 = workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
         ];
      };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "firefox.desktop")
    );
  };
}
