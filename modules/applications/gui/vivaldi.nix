{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.vivaldi;
in
  with lib;
{
  options = {
    host.home.applications.vivaldi = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Web browser and mail client";
      };
      defaultApplication = {
        enable = mkOption {
          description = "MIME default application configuration";
          type = with types; bool;
          default = false;
        };
        mimeTypes = mkOption {
          description = "MIME types to be the default application for";
          type = types.listOf types.str;
          default = [

          ];
        };
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          vivaldi
        ];
    };
  };
}
