{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.seahorse;
in
  with lib;
{
  options = {
    host.home.applications.seahorse = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Key manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          gnome.seahorse # 24.11 - Remove the gnome. prefix
        ];
    };
  };
}
