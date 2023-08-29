{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.direnv;
in
  with lib;
{
  options = {
    host.home.applications.direnv = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Nix development environments";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      direnv = {
        enable = true;
        enableBashIntegration = true;
        nix-direnv.enable = true;
      };
    };
  };
}
