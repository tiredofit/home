{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.beets;

  beetsPluginPkg =
    let
      useDefaults = cfg.plugins.enable == null;

      selectedPlugins =
        if useDefaults then
          { }
        else
          lib.listToAttrs (map (name: {
            inherit name;
            value = { enable = true; };
          }) cfg.plugins.enable);

      externalPlugins = lib.filterAttrs (_: v: v.enable) {
        alternatives = {
          enable = cfg.plugins.alternatives;
          propagatedBuildInputs = [ pkgs.python3.pkgs.beets-alternatives ];
        };
        audible = {
          enable = cfg.plugins.audible;
          propagatedBuildInputs = [ pkgs.python3.pkgs.beets-audible ];
          wrapperBins = [ pkgs.ffmpeg ];
        };
        copyartifacts = {
          enable = cfg.plugins.copyartifacts;
          propagatedBuildInputs = [ pkgs.python3.pkgs.beets-copyartifacts ];
        };
        filetote = {
          enable = cfg.plugins.filetote;
          propagatedBuildInputs = [ pkgs.python3.pkgs.beets-filetote ];
        };
        importreplace = {
          enable = cfg.plugins.importreplace;
          propagatedBuildInputs = [ pkgs.python3.pkgs.beets-importreplace ];
        };
        ytimport = {
          enable = cfg.plugins.ytimport;
          propagatedBuildInputs = [ pkgs.python3.pkgs.beets-ytimport ];
          wrapperBins = [ pkgs.yt-dlp ];
        };
      };

      customPython = pkgs.python3.override {
        packageOverrides = self: super: {
          beets = super.beets.override {
            disableAllPlugins = !useDefaults;
            pluginOverrides = selectedPlugins // externalPlugins;
          };
        };
      };
    in
    customPython.pkgs.toPythonApplication customPython.pkgs.beets;

  companionPackages =
    [ pkgs.ffmpeg ]
    ++ lib.optionals cfg.plugins.ytimport [ pkgs.yt-dlp ];
in
with lib;
{
  options = {
    host.home.applications.beets = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Music tagger and library organizer";
      };

      plugins = {
        enable = mkOption {
          type = with types; nullOr (listOf str);
          default = null;
          example = [ "chroma" "fetchart" "replaygain" ];
          description = "Builtin plugins to enable (null = all, [] = none)";
        };

        alternatives = mkOption {
          default = false;
          type = with types; bool;
          description = "beets-alternatives: manage external files alongside music";
        };

        audible = mkOption {
          default = false;
          type = with types; bool;
          description = "beets-audible: organize audiobook collection";
        };

        copyartifacts = mkOption {
          default = false;
          type = with types; bool;
          description = "beets-copyartifacts: move non-music files during import";
        };

        filetote = mkOption {
          default = false;
          type = with types; bool;
          description = "beets-filetote: move non-music files during import";
        };

        importreplace = mkOption {
          default = false;
          type = with types; bool;
          description = "beets-importreplace: regex replacements during import";
        };

        ytimport = mkOption {
          default = false;
          type = with types; bool;
          description = "beets-ytimport: import music from YouTube/SoundCloud";
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          beetsPluginPkg
        ] ++ companionPackages;
    };
  };
}
