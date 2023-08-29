{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xbacklight;
in
  with lib;
{
  options = {
    host.home.applications.xbacklight = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Control screen brightness, the same as light";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xorg.xbacklight
        ];
    };
  };
}
