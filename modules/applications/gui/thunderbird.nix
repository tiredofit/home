{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.thunderbird;
in
  with lib;
{
  options = {
    host.home.applications.thunderbird = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Mail, Calendar, and IM";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          thunderbird
        ];
    };

    programs = {
      thunderbird = {
        enable = false;
        ## TODO - This needs conversion
      };
    };
  };
}
