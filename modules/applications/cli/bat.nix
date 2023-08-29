{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.btop;
in
  with lib;
{
  options = {
    host.home.applications.btop = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Process monitor";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      btop = {
        enable = true;
        settings = {
          color_theme = "Default";
          theme_background = false;
        };
      };

      bash.shellAliases = {
        top = "btop" ; # Process viewer
      };
    };
  };
}
