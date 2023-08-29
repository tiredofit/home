{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.zathura;
in
  with lib;
{
  options = {
    host.home.applications.zathura = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "Console PDF viewer";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      zathura = {
        enable = true;
        options = {
          default-bg = "#000000";
          default-fg = "#FFFFFF";
        };
      };
    };
  };
}
