{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.autokey;
in
  with lib;
{
  options = {
    host.home.applications.autokey = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Perform automation and override keymaps";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          autokey
        ];
    };
  };
}
