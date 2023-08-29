{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.hadolint;
in
  with lib;
{
  options = {
    host.home.applications.hadolint = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Lint Dockerfiles";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          hadolint
        ];
    };
  };
}
