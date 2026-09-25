{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.lazydocker;
in
  with lib;
{
  options = {
    host.home.applications.lazydocker = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Docker Interface";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellAliases = {
      ld= ''
        lazydocker
      '';
    };
  in {
    home = {
      packages = with pkgs;
        [
          lazydocker
        ];
    };
    programs = {
      bash = {
        shellAliases = shellAliases;
      };
      zsh = {
        shellAliases = shellAliases;
      };
    };
  });
}
