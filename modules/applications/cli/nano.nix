{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nano;
in
  with lib;
{
  options = {
    host.home.applications.nano = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Text editor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      file = { ".config/nano".source = ../../../dotfiles/nano; };

      packages = with pkgs;
      [
        unstable.nano
      ];
    };
  };
}
