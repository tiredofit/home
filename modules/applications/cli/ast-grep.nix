{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.ast-grep;
in
  with lib;
{
  options = {
    host.home.applications.ast-grep = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Structural search and replace tool";
      };
    };
  };

  config = mkIf cfg.enable (let
    aliases = {

    };
  in {
    home = {
      packages = with pkgs;
        [
          ast-grep
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
