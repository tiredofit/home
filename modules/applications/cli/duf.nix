{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.duf;
in
  with lib;
{
  options = {
    host.home.applications.duf = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "'du' command line replacement";
      };
    };
  };

  config = mkIf cfg.enable (let
    aliases = {
      df = "duf";
    };
  in {
    home = {
      packages = with pkgs;
        [
          duf
        ];
    };

    programs = {
      bash = {
        shellAliases = aliases;
      };
      zsh = {
        shellAliases = aliases;
      };
    };
  });
}
