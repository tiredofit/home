{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.lazygit;
in
  with lib;
{
  options = {
    host.home.applications.lazygit = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Git Interface";
      };
    };
  };

  config = mkIf cfg.enable (let
    shellAliases = {
      lg = ''
        lazygit
      '';
    };
  in {
    home = {
      packages = with pkgs;
        [
          lazygit
        ];
    };

    programs = {
      bash = {
        shellAliases = shellAliases;
      };
      zsh = {
        shellAliases = shellAliases;
      };
      lazygit.enableZshIntegration = mkDefault true;
    };
  });
}
