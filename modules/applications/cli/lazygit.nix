{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.lazygit;
in
  with lib;
{
  options = {
    host.home.applications.lazygit = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Git Interface";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          lazygit
        ];
    };
  };
}
