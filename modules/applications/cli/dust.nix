{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.dust;
in
  with lib;
{
  options = {
    host.home.applications.dust = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "'du' command line replacement";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          (if lib.versionAtLeast lib.version "25.11pre" then dust else du-dust)
        ];
    };
    programs = {
      bash = {
        initExtra = ''
          alias du=dust
        '';
      };
    };
  };
}
