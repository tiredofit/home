{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.arandr;
in
  with lib;
{
  options = {
    host.home.applications.arandr = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Graphical Display Setup";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          arandr
        ];
    };
  };
}
