{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xdpyinfo;
in
  with lib;
{
  options = {
    host.home.applications.xdpyinfo = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "X screen information";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xorg.xdpyinfo
        ];
    };
  };
}
