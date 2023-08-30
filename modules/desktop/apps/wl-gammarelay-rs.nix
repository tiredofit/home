{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.wl-gammarelay-rs;
in
  with lib;
{
  options = {
    host.home.applications.wl-gammarelay-rs = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Wayland Monitor Gamma Adjustment";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          wl-gammarelay-rs
        ];
    };
  };
}
