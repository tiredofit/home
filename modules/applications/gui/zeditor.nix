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
    home = {
      packages = with pkgs;
        [
          zed-editor
        ];
    };
  };
}
