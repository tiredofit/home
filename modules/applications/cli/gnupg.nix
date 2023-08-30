{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.gnupg;
in
  with lib;
{
  options = {
    host.home.applications.gnupg = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "GNU Privacy Guard";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          gnupg
        ];
    };
  };
}
