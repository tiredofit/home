{ config, lib, pkgs, specialArgs, ... }:

let

  firefoxHelper_bitwarden = pkgs.writeShellScriptBin "firefoxHelper_bitwarden" ''
    windowtitlev2() {
      IFS=',' read -r -a args <<< "$1"
      args[0]="''${args[0]#*>>}"

      if [[ ''${args[1]} == "Extension: (Bitwarden Password Manager) - — Mozilla Firefox" ]]; then
        hyprctl --batch "\
          dispatch setfloating address:0x''${args[0]}; \
          dispatch resizewindowpixel exact 20% 50%, address:0x''${args[0]}; \
          dispatch centerwindow; \
        "
      fi
    }

    handle() {
      case $1 in
        windowtitlev2\>*) windowtitlev2 "$1" ;;
      esac
    }

    ${pkgs.socat}/bin/socat -U - UNIX-CONNECT:"/$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" \
      | while read -r line; do
          handle "$line"
        done
      '';
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
        firefoxHelper_bitwarden
      ];
    };

    programs.firefox = {
      enable = true;
      package = if pkgs.stdenv.isLinux then pkgs.unstable.firefox else pkgs.unstable.firefox-bin;

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
            ## Telemetry + Reporting
            ### Disable Telemetry (https://support.mozilla.org/kb/share-telemetry-data-mozilla-help-improve-firefox) sends data about the performance and responsiveness of Firefox to Mozilla.
            "toolkit.telemetry.enabled" = mkDefault false;
            "toolkit.telemetry.archive.enabled" = mkDefault false;
            "toolkit.telemetry.bhrPing.enabled" = mkDefault false;
            "toolkit.telemetry.cachedClientID" = mkDefault "";
            "toolkit.telemetry.firstShutdownPing.enabled" = mkDefault false;
            "toolkit.telemetry.hybridContent.enabled" = mkDefault false;
            "toolkit.telemetry.newProfilePing.enabled" = mkDefault false;
            "toolkit.telemetry.prompted" = mkDefault 2;
            "toolkit.telemetry.rejected" = mkDefault true;
            "toolkit.telemetry.reportingpolicy.firstRun" = mkDefault false;
            "toolkit.telemetry.server" = mkDefault "";
            "toolkit.telemetry.shutdownPingSender.enabled" = mkDefault false;
            "toolkit.telemetry.unified" = mkDefault false;
            "toolkit.telemetry.unifiedIsOptIn" = mkDefault false;
            "toolkit.telemetry.updatePing.enabled" = mkDefault false;
            ### Disable health report - Disable sending Firefox health reports(https://www.mozilla.org/privacy/firefox/#health-report) to Mozilla.
            "datareporting.healthreport.service.enabled" = mkDefault false;
            "datareporting.healthreport.uploadEnabled" = mkDefault false;
            "datareporting.policy.dataSubmissionEnabled" = mkDefault false;
            ### Disable shield studies (https://wiki.mozilla.org/Firefox/Shield) is a feature which allows mozilla to remotely install experimental addons.
            "app.normandy.enabled" = mkDefault false;
            "app.normandy.api_url" = mkDefault "";
            "app.shield.optoutstudies.enabled" = mkDefault false;
            "extensions.shield-recipe-client.enabled" = mkDefault false;
            "extensions.shield-recipe-client.api_url" = mkDefault "";
            ### Disable experiments (https://wiki.mozilla.org/Telemetry/Experiments) allows automatically download and run specially-designed restartless addons based on certain conditions.
            "experiments.enabled" = mkDefault false;
            "experiments.activeExperiment" = mkDefault false;
            "experiments.manifest.uri" = mkDefault "";
            "experiments.supported" = mkDefault false;
            "network.allow-experiments" = mkDefault false;
            ### Disable Crash Reports (https://www.mozilla.org/privacy/firefox/#crash-reporter) as it may contain data that identifies you or is otherwise sensitive to you.
            "breakpad.reportURL" = mkDefault "";
            "browser.tabs.crashReporting.sendReport" = mkDefault false;
            "browser.crashReports.unsubmittedCheck.enabled" = mkDefault false;
            "browser.crashReports.unsubmittedCheck.autoSubmit" = mkDefault false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = mkDefault false;
            "extensions.getAddons.cache.enabled" = mkDefault false; # Opt out metadata updates about installed addons as metadata updates (https://blog.mozilla.org/addons/how-to-opt-out-of-add-on-metadata-updates/), so Mozilla is able to recommend you other addons.
            #### Disable google safebrowsing - Detect phishing and malware but it also sends informations to google together with an unique id called wrkey (http://electroholiker.de/?p=1594).
            "browser.safebrowsing.enabled" = mkDefault false;
            "browser.safebrowsing.appRepURL" = mkDefault "";
            "browser.safebrowsing.blockedURIs.enabled" = mkDefault false;
            "browser.safebrowsing.downloads.enabled" = mkDefault false;
            "browser.safebrowsing.downloads.remote.enabled" = mkDefault false;
            "browser.safebrowsing.downloads.remote.url" = mkDefault "";
            "browser.safebrowsing.malware.enabled" = mkDefault false; # Disable malware scan -  sends an unique identifier for each downloaded file to Google.
            "browser.safebrowsing.phishing.enabled" = mkDefault false;
            "browser.newtab.preload" = mkDefault false; # Disable preloading of the new tab page. By default Firefox preloads the new tab page (with website thumbnails) in the background before it is even opened.

            ## Privacy
            "dom.indexedDB.enabled" = mkDefault true; # Enable IndexedDB (disabling breaks things)

            ## Security
            "app.update.auto" = mkDefault true; # Disable automatic updates.
            "browser.aboutConfig.showWarning" = mkDefault false; # Disable about:config warning.
            "browser.disableResetPrompt" = mkDefault true; # Disable reset prompt.
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = mkDefault false; # Disable Pocket
            "browser.newtabpage.enhanced" = mkDefault false; # Content of the new tab page
            "browser.newtabpage.introShown" = mkDefault false; # Disable the intro to the newtab page on the first run
            "browser.selfsupport.url" = mkDefault ""; # Disable Heartbeat Userrating
            "browser.shell.checkDefaultBrowser" = mkDefault false; # Disable checking if Firefox is the default browser
            "browser.startup.homepage_override.mstone" = mkDefault "ignore"; # Disable the first run tabs with advertisements for the latest firefox features.
            "browser.urlbar.trimURLs" = mkDefault false; # Do not trim URLs in navigation bar
            "extensions.pocket.enabled" = mkDefault false; # Disable Pocket
            "network.IDN_show_punycode" = mkDefault true; # Show Punycode.
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = mkDefault false; # Disable Sponsored Top Sites

            ## Extra Settings
            "browser.compactmode.show" = mkDefault true;
            "browser.download.always_ask_before_handling_new_types" = mkDefault true;
            "browser.engagement.ctrlTab.has-used" = mkDefault true;
            "browser.engagement.downloads-button.has-used" = mkDefault true;
            "browser.engagement.fxa-toolbar-menu-button.has-used" = mkDefault true;
            "browser.engagement.library-button.has-used" = mkDefault true;
            "browser.tabs.insertAfterCurrent" = mkDefault true;
            "devtools.everOpened" = mkDefault true;
            "font.internaluseonly.changed" = mkDefault false; # Fonts
            "font.name.monospace.x-western" = mkDefault "Droid Sans Mono"; # Fonts
            "font.name.sans-serif.x-western" = mkDefault "Noto Sans"; # Fonts
            "font.name.serif.x-western" = mkDefault "Noto Sans"; # Fonts
            "font.size.fixed.x-western" = mkDefault "11"; # Fonts
            "font.size.variable.x-western" = mkDefault "15"; # Fonts
            "general.smoothScroll" = mkDefault true; # enable smooth scrolling
            "gfx.webrender.all" = mkDefault true; # Force using WebRender. Improve performance
            "gfx.webrender.enabled" = mkDefault true; # Force using WebRender. Improve performance
            "media.ffmpeg.vaapi.enabled" = mkDefault true; # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
            "media.ffvpx.enabled" = mkDefault false; # https://wiki.archlinux.org/title/firefox#Hardware_video_acceleration
            "media.videocontrols.picture-in-picture.allow-multiple" = mkDefault true; # Enable multi-pip
            "pref.general.disable_button.default_browser" = mkDefault false;
            "pref.privacy.disable_button.cookie_exceptions" = mkDefault false;
            "pref.privacy.disable_button.tracking_protection_exceptions" = mkDefault false;
            "pref.privacy.disable_button.view_passwords" = mkDefault false;
            "print.more-settings.open" = mkDefault true;
          };

          extraConfig = mkDefault ''
            user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          '';
        };
      };
    };

    systemd.user.services.hyperlandHelper_firefox_bitwarden = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      Unit = {
        Description = "Help float Firefox Extension Windows in Hyprland";
        After = [ "graphical-session.target" ];
      };

      Service = {
        #Type = "exec";
        ExecStart = "${firefoxHelper_bitwarden}/bin/firefoxHelper_bitwarden";
        #ExecReload = "kill -SIGUSR2 $MAINPID";
        #Restart = "always";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    wayland.windowManager.hyprland = mkIf (config.host.home.feature.gui.displayServer == "wayland" && config.host.home.feature.gui.windowManager == "hyprland" && config.host.home.feature.gui.enable) {
      settings = {
        windowrule = [
           ### Make Firefox PiP window floating and sticky
           "float, title:^(Picture-in-Picture)$"
           "pin, title:^(Picture-in-Picture)$"
           ### Throw sharing indicators away
           "workspace special silent, title:^(Firefox — Sharing Indicator)$"
           "workspace special silent, title:^(.*is sharing (your screen|a window)\.)$"
         ];
      };
    };

    xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
      lib.genAttrs cfg.defaultApplication.mimeTypes (_: "firefox.desktop")
    );
  };
}
