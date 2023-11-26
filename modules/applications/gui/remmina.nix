{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.remmina;
in
  with lib;
{
  options = {
    host.home.applications.remmina = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Remote Desktop viewer";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          remmina
        ];
    };
  };
}
