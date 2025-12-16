{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.feishin;
in
  with lib;
{
  options = {
    host.home.applications.feishin = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Media Player";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          pkg-feishin
        ];
    };
  };
}
