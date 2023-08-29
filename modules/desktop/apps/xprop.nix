{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xprop;
in
  with lib;
{
  options = {
    host.home.applications.xprop = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "X window information";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xorg.xprop
        ];
    };

    programs = {
      bash = {
        shellAliases = {
          windowtitle = "xprop | grep WM_CLASS" ; # get window title from x application
        };
      };
    };
  };
}
