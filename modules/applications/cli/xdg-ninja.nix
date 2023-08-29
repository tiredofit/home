{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.xdg-ninja;
in
  with lib;
{
  options = {
    host.home.applications.xdg-ninja = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Help clean $HOME into XDG compatible locations";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          xdg-ninja
        ];
    };
  };
}
