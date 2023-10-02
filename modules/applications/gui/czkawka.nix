{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.czkawka;
in
  with lib;
{
  options = {
    host.home.applications.czkawka = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Duplicate file finder";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          czkawka
        ];
    };
  };
}
