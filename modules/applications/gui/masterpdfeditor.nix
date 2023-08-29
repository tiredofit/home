{config, lib, pkgs, ...}:

let
  cfg = config.host.home.applications.master-pdf-editor;
in
  with lib;
{
  options = {
    host.home.applications.master-pdf-editor = {
      enable = mkOption {
        default = false;
        type = with types; bool;
        description = "PDF Editor";
      };
    };
  };

  config = mkIf cfg.enable {
    home = {
      packages = with pkgs;
        [
          masterpdfeditor4
        ];
    };
  };
}
