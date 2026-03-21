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

  config = mkIf cfg.enable (let
    aliases = {
      top = "btop";
    };
  in {
    home = {
      packages = with pkgs;
        [
          btop
        ];
    };

    programs = {
      bash = {
        shellAliases = aliases;
      };
      btop = {
        enable = true;
        settings = {
          color_theme = mkDefault "Default";
          theme_background = mkDefault false;
        };
      };
      zsh = {
        shellAliases = aliases;
      };
    };
  });
}
