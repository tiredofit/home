{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.bat;
in
  with lib;
{
  options = {
    host.home.applications.bat = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Text file viewer";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      bat = {
        enable = true;
        config = {
          map-syntax = [ "*.jenkinsfile:Groovy" "*.props:Java Properties" ];
          pager = "less -FR";
          theme = "TwoDark";
        };
      };
    };
  };
}
