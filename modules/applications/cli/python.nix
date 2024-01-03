{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.python;
in
  with lib;
{
  options = {
    host.home.applications.python = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Python Interpreter";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          python3
        ];
    };
  };
}
