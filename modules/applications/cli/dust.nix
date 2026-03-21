{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.dust;
in
  with lib;
{
  options = {
    host.home.applications.dust = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "'du' command line replacement";
      };
    };
  };

  config = mkIf cfg.enable (let
    aliases = {
      du = "dust";
    };
  in {
    home = {
      packages = with pkgs;
        [
          dust
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
