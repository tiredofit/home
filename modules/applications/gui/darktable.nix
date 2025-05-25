{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.darktable;
in
  with lib;
{
  options = {
    host.home.applications.darktable = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Phto Manager";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          darktable
        ];
    };

  };
}
