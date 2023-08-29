{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.nixfmt;
in
  with lib;
{
  options = {
    host.home.applications.nixfmt = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Format nix code";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          nixfmt
        ];
    };
  };
}
