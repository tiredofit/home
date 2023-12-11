{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.electrum;
in
  with lib;
{
  options = {
    host.home.applications.electrum = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Electrum wallet";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          electrum
        ];
    };
  };
}
