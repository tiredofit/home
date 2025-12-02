{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.zeditor;
in
  with lib;
{
  options = {
    host.home.applications.zeditor = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "File Editor";
      };
    };
  };

  config = mkIf cfg.enable {
    programs = {
      zed-editor = {
        enable = mkDefault true;
        package = mkDefault pkgs.zed-editor;
      };
    };
  };
}
