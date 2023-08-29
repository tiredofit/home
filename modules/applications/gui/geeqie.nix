{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.geeqie;
in
  with lib;
{
  options = {
    host.home.applications.geeqie = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Image viewer";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          geeqie
        ];
    };
  };
}
