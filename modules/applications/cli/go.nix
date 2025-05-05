{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.go;
in
  with lib;
{
  options = {
    host.home.applications.go = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "GoLang programming language";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          go
        ];
    };
  };
}
