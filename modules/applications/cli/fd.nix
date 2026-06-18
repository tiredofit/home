{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.fd;
in
  with lib;
{
  options = {
    host.home.applications.fd = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Simple, fast and user-friendly alternative to find";
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
          fd
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
