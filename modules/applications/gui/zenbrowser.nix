{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.zenbrowser;
  zenwrapper = pkgs.writeShellScriptBin "zen" ''
    mkdir -p $HOME/.config/zen/Profiles/main
    ${pkgs.pkg-zenbrowser}/bin/zenbrowser --profile $HOME/.config/zen/Profiles/main
  '';
in
  with lib;
{
  options = {
    host.home.applications.zenbrowser = {
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
          pkg-zenbrowser
          zenwrapper
        ];
    };

    #xdg.mimeApps.defaultApplications = mkIf cfg.defaultApplication.enable (
    #  lib.genAttrs cfg.defaultApplication.mimeTypes (_: "zenbrowser.desktop")
    #);
  };
}
